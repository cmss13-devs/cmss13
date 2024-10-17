/obj/structure/barricade/plasteel
	name = "folding plasteel barricade"
	desc = "A very sturdy barricade made out of plasteel panels, the pinnacle of strongpoints. Use a blowtorch to repair. Can be flipped down to create a path."
	icon_state = "plasteel_closed_0"
	health = 800
	maxhealth = 800
	burn_multiplier = 1.15
	brute_multiplier = 1
	crusher_resistant = TRUE
	force_level_absorption = 20
	stack_type = /obj/item/stack/sheet/plasteel
	debris = list(/obj/item/stack/sheet/plasteel)
	stack_amount = 8
	destroyed_stack_amount = 4
	barricade_hitsound = 'sound/effects/metalhit.ogg'
	barricade_type = "plasteel"
	density = FALSE
	closed = TRUE
	can_wire = TRUE
	repair_materials = list("plasteel" = 0.3)

	var/build_state = BARRICADE_BSTATE_SECURED //Look at __game.dm for barricade defines
	/// Delay to apply tools to prevent spamming
	var/tool_cooldown = 0
	/// Standard busy check
	var/busy = FALSE
	var/linked = 0
	var/recentlyflipped = FALSE
	var/hasconnectionoverlay = TRUE
	var/linkable = TRUE
	welder_lower_damage_limit = BARRICADE_DMG_HEAVY

/obj/structure/barricade/plasteel/update_icon()
	..()
	if(linked)
		for(var/direction in GLOB.cardinals)
			for(var/obj/structure/barricade/plasteel/cade in get_step(src, direction))
				if(((dir & (NORTH|SOUTH) && get_dir(src, cade) & (EAST|WEST)) || (dir & (EAST|WEST) && get_dir(src, cade) & (NORTH|SOUTH))) && dir == cade.dir && cade.linked && cade.closed == src.closed && hasconnectionoverlay)
					if(closed)
						overlays += image('icons/obj/structures/barricades.dmi', icon_state = "[src.barricade_type]_closed_connection_[get_dir(src, cade)]")
					else
						overlays += image('icons/obj/structures/barricades.dmi', icon_state = "[src.barricade_type]_connection_[get_dir(src, cade)]")
					continue


/obj/structure/barricade/plasteel/handle_barrier_chance(mob/living/M)
	if(!closed) // Closed = gate down for plasteel for some reason
		return ..()
	else
		return FALSE

/obj/structure/barricade/plasteel/get_examine_text(mob/user)
	. = ..()

	switch(build_state)
		if(BARRICADE_BSTATE_SECURED)
			. += SPAN_INFO("The protection panel is still tightly screwed in place.")
		if(BARRICADE_BSTATE_UNSECURED)
			. += SPAN_INFO("The protection panel has been removed, you can see the anchor bolts.")
		if(BARRICADE_BSTATE_MOVABLE)
			. += SPAN_INFO("The protection panel has been removed and the anchor bolts loosened. It's ready to be taken apart.")

/obj/structure/barricade/plasteel/try_weld_cade(obj/item/item, mob/user, repeat = TRUE, skip_check = FALSE)
	busy = TRUE
	..()
	busy = FALSE

/obj/structure/barricade/plasteel/can_weld(obj/item/item, mob/user, silent)
	if(!..())
		return FALSE

	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_NOVICE))
		if(!silent)
			to_chat(user, SPAN_WARNING("You're not trained to repair [src]..."))
		return FALSE

	return TRUE

/obj/structure/barricade/plasteel/attackby(obj/item/item, mob/user)
	if(iswelder(item))
		try_weld_cade(item, user)
		return

	if(try_nailgun_usage(item, user))
		return

	for(var/obj/effect/xenomorph/acid/A in src.loc)
		if(A.acid_t == src)
			to_chat(user, "You can't get near that, it's melting!")
			return

	switch(build_state)
		if(BARRICADE_BSTATE_SECURED) //Fully constructed step. Use screwdriver to remove the protection panels to reveal the bolts
			if(HAS_TRAIT(item, TRAIT_TOOL_SCREWDRIVER))
				if(busy || tool_cooldown > world.time)
					return
				tool_cooldown = world.time + 10
				if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
					to_chat(user, SPAN_WARNING("You are not trained to assemble [src]..."))
					return

				for(var/obj/structure/barricade/B in loc)
					if(B != src && B.dir == dir)
						to_chat(user, SPAN_WARNING("There's already a barricade here."))
						return
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					return
				user.visible_message(SPAN_NOTICE("[user] removes [src]'s protection panel."),
				SPAN_NOTICE("You remove [src]'s protection panels, exposing the anchor bolts."))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				build_state = BARRICADE_BSTATE_UNSECURED
				return

			if(HAS_TRAIT(item, TRAIT_TOOL_CROWBAR))
				if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
					to_chat(user, SPAN_WARNING("You are not trained to modify [src]..."))
					return
				playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
				if(linked)
					user.visible_message(SPAN_NOTICE("[user] removes the linking on [src]."),
					SPAN_NOTICE("You remove the linking on [src]."))
				else if(linkable)
					user.visible_message(SPAN_NOTICE("[user] sets up [src] for linking."),
					SPAN_NOTICE("You set up [src] for linking."))
				else
					to_chat(user, SPAN_WARNING("[src] has no linking points..."))
					return
				linked = !linked
				for(var/direction in GLOB.cardinals)
					for(var/obj/structure/barricade/plasteel/cade in get_step(src, direction))
						cade.update_icon()
				update_icon()

		if(BARRICADE_BSTATE_UNSECURED) //Protection panel removed step. Screwdriver to put the panel back, wrench to unsecure the anchor bolts
			if(HAS_TRAIT(item, TRAIT_TOOL_SCREWDRIVER))
				if(busy || tool_cooldown > world.time)
					return
				tool_cooldown = world.time + 10
				if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
					to_chat(user, SPAN_WARNING("You are not trained to assemble [src]..."))
					return
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					return
				user.visible_message(SPAN_NOTICE("[user] set [src]'s protection panel back."),
				SPAN_NOTICE("You set [src]'s protection panel back."))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				build_state = BARRICADE_BSTATE_SECURED
				return

			if(HAS_TRAIT(item, TRAIT_TOOL_WRENCH))
				if(busy || tool_cooldown > world.time)
					return
				tool_cooldown = world.time + 10
				if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
					to_chat(user, SPAN_WARNING("You are not trained to assemble [src]..."))
					return
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					return
				user.visible_message(SPAN_NOTICE("[user] loosens [src]'s anchor bolts."),
				SPAN_NOTICE("You loosen [src]'s anchor bolts."))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				anchored = FALSE
				build_state = BARRICADE_BSTATE_MOVABLE
				update_icon() //unanchored changes layer
				return

		if(BARRICADE_BSTATE_MOVABLE) //Anchor bolts loosened step. Apply crowbar to unseat the panel and take apart the whole thing. Apply wrench to rescure anchor bolts
			if(HAS_TRAIT(item, TRAIT_TOOL_WRENCH))
				if(busy || tool_cooldown > world.time)
					return
				tool_cooldown = world.time + 10
				if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
					to_chat(user, SPAN_WARNING("You are not trained to assemble [src]..."))
					return
				var/turf/open/T = loc
				if(!(istype(T) && T.allow_construction))
					to_chat(user, SPAN_WARNING("[src] must be secured on a proper surface!"))
					return
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					return
				user.visible_message(SPAN_NOTICE("[user] secures [src]'s anchor bolts."),
				SPAN_NOTICE("You secure [src]'s anchor bolts."))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				anchored = TRUE
				build_state = BARRICADE_BSTATE_UNSECURED
				update_icon() //unanchored changes layer
				return

			if(HAS_TRAIT(item, TRAIT_TOOL_CROWBAR))
				if(busy || tool_cooldown > world.time)
					return
				tool_cooldown = world.time + 10
				if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
					to_chat(user, SPAN_WARNING("You are not trained to assemble [src]..."))
					return
				user.visible_message(SPAN_NOTICE("[user] starts unseating [src]'s panels."),
				SPAN_NOTICE("You start unseating [src]'s panels."))
				playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
				busy = TRUE
				if(do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					user.visible_message(SPAN_NOTICE("[user] takes [src]'s panels apart."),
					SPAN_NOTICE("You take [src]'s panels apart."))
					playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
					deconstruct(TRUE) //Note : Handles deconstruction too !
				busy = FALSE
				return

	return ..()

/obj/structure/barricade/plasteel/attack_hand(mob/user as mob)
	if(isxeno(user))
		return

	if(closed)
		if(recentlyflipped)
			to_chat(user, SPAN_NOTICE("[src] has been flipped too recently!"))
			return
		user.visible_message(SPAN_NOTICE("[user] flips [src] open."),
		SPAN_NOTICE("You flip [src] open."))
		open(src)
		recentlyflipped = TRUE
		spawn(10)
			if(istype(src, /obj/structure/barricade/plasteel))
				recentlyflipped = FALSE

	else
		if(recentlyflipped)
			to_chat(user, SPAN_NOTICE("[src] has been flipped too recently!"))
			return
		user.visible_message(SPAN_NOTICE("[user] flips [src] closed."),
		SPAN_NOTICE("You flip [src] closed."))
		close(src)
		recentlyflipped = TRUE
		spawn(10)
			if(istype(src, /obj/structure/barricade/plasteel))
				recentlyflipped = FALSE

/obj/structure/barricade/plasteel/proc/open(obj/structure/barricade/plasteel/origin)
	if(!closed)
		return
	playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
	closed = 0
	density = TRUE
	if(linked)
		for(var/direction in GLOB.cardinals)
			for(var/obj/structure/barricade/plasteel/cade in get_step(src, direction))
				if(((dir & (NORTH|SOUTH) && get_dir(src, cade) & (EAST|WEST)) || (dir & (EAST|WEST) && get_dir(src, cade) & (NORTH|SOUTH))) && dir == cade.dir && cade != origin && cade.linked)
					cade.open(src)
	update_icon()

/obj/structure/barricade/plasteel/proc/close(obj/structure/barricade/plasteel/origin)
	if(closed)
		return
	playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
	closed = 1
	density = FALSE
	if(linked)
		for(var/direction in GLOB.cardinals)
			for(var/obj/structure/barricade/plasteel/cade in get_step(src, direction))
				if(((dir & (NORTH|SOUTH) && get_dir(src, cade) & (EAST|WEST)) || (dir & (EAST|WEST) && get_dir(src, cade) & (NORTH|SOUTH))) && dir == cade.dir && cade != origin && cade.linked)
					cade.close(src)
	update_icon()


/obj/structure/barricade/plasteel/wired/New()
	can_wire = FALSE
	is_wired = TRUE
	climbable = FALSE
	update_icon()
	return ..()

/obj/structure/barricade/plasteel/wired/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	flags_can_pass_front_temp &= ~PASS_OVER_THROW_MOB
	flags_can_pass_behind_temp &= ~PASS_OVER_THROW_MOB

/obj/structure/barricade/plasteel/metal
	name = "folding metal barricade"
	desc = "A folding barricade made out of metal, making it slightly weaker than a normal metal barricade. Use a blowtorch to repair. Can be flipped down to create a path."
	icon_state = "folding_metal_closed_0"
	health = 400
	maxhealth = 400
	force_level_absorption = 10
	stack_type = /obj/item/stack/sheet/metal
	debris = list(/obj/item/stack/sheet/metal)
	stack_amount = 6
	destroyed_stack_amount = 3
	barricade_type = "folding_metal"
	repair_materials = list("metal" = 0.3, "plasteel" = 0.45)

	linkable = FALSE
