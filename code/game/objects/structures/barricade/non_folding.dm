/obj/structure/barricade/metal
	name = "metal barricade"
	desc = "A sturdy and easily assembled barricade made of metal plates, often used for quick fortifications. Use a blowtorch to repair."
	icon_state = "metal_0"
	health = 450
	maxhealth = 450
	burn_multiplier = 1.15
	brute_multiplier = 1
	crusher_resistant = TRUE
	force_level_absorption = 10
	stack_type = /obj/item/stack/sheet/metal
	debris = list(/obj/item/stack/sheet/metal)
	stack_amount = 4
	destroyed_stack_amount = 2
	barricade_hitsound = 'sound/effects/metalhit.ogg'
	barricade_type = "metal"
	can_wire = TRUE
	repair_materials = list("metal" = 0.3, "plasteel" = 0.45)
	var/build_state = BARRICADE_BSTATE_SECURED //Look at __game.dm for barricade defines
	var/upgrade = null

	welder_lower_damage_limit = BARRICADE_DMG_HEAVY

/obj/structure/barricade/metal/update_icon()
	. = ..()
	if(dir > 2)
		layer = OBJ_LAYER //This prevents cades from becoming invisible under a north/south facing plasteel cade.

/obj/structure/barricade/metal/get_examine_text(mob/user)
	. = ..()
	switch(build_state)
		if(BARRICADE_BSTATE_SECURED)
			. += SPAN_INFO("The protection panel is still tightly screwed in place.")
		if(BARRICADE_BSTATE_UNSECURED)
			. += SPAN_INFO("The protection panel has been removed, you can see the anchor bolts.")
		if(BARRICADE_BSTATE_MOVABLE)
			. += SPAN_INFO("The protection panel has been removed and the anchor bolts loosened. It's ready to be taken apart.")

	switch(upgrade)
		if(BARRICADE_UPGRADE_BURN)
			. += SPAN_NOTICE("The cade is protected by a biohazardous upgrade.")
		if(BARRICADE_UPGRADE_BRUTE)
			. += SPAN_NOTICE("The cade is protected by a reinforced upgrade.")
		if(BARRICADE_UPGRADE_ANTIFF)
			. += SPAN_NOTICE("The cade is protected by a composite upgrade.")

/obj/structure/barricade/metal/can_weld(obj/item/item, mob/user, silent)
	if(!..())
		return FALSE

	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_NOVICE))
		if(!silent)
			to_chat(user, SPAN_WARNING("You're not trained to repair [src]..."))
		return FALSE

	return TRUE

/obj/structure/barricade/metal/attackby(obj/item/item, mob/user)
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
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("You are not trained to touch [src]..."))
					return
				if(user.action_busy)
					return
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					return
				user.visible_message(SPAN_NOTICE("[user] removes [src]'s protection panel."),
				SPAN_NOTICE("You remove [src]'s protection panels, exposing the anchor bolts."))
				build_state = BARRICADE_BSTATE_UNSECURED
				return

			if(istype(item, /obj/item/stack/sheet/metal))
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("You are not trained to touch [src]..."))
					return
				if(upgraded)
					to_chat(user, SPAN_NOTICE("This barricade is already upgraded."))
					return
				var/obj/item/stack/sheet/metal/metal = item
				if(user.client?.prefs?.no_radials_preference)
					var/choice = tgui_input_list(user, "Choose an upgrade to apply to the barricade", "Apply Upgrade", list(BARRICADE_UPGRADE_BURN, BARRICADE_UPGRADE_BRUTE, BARRICADE_UPGRADE_ANTIFF))
					if(!choice)
						return
					if(!user.Adjacent(src))
						to_chat(user, SPAN_NOTICE("You are too far away!"))
						return
					if(upgraded)
						to_chat(user, SPAN_NOTICE("This barricade is already upgraded."))
						return
					if(metal.get_amount() < 2)
						to_chat(user, SPAN_NOTICE("You lack the required metal."))
						return
					if((usr.get_active_hand()) != metal)
						to_chat(user, SPAN_WARNING("You must be holding [metal] to upgrade [src]!"))
						return

					switch(choice)
						if(BARRICADE_UPGRADE_BURN)
							burn_multiplier = 0.75
							burn_flame_multiplier = 0.75
							upgraded = BARRICADE_UPGRADE_BURN
							to_chat(user, SPAN_NOTICE("You applied a biohazardous upgrade."))
						if(BARRICADE_UPGRADE_BRUTE)
							brute_multiplier = 0.75
							brute_projectile_multiplier = 0.75
							upgraded = BARRICADE_UPGRADE_BRUTE
							to_chat(user, SPAN_NOTICE("You applied a reinforced upgrade."))
						if(BARRICADE_UPGRADE_ANTIFF)
							explosive_multiplier = 0.5
							brute_projectile_multiplier = 0.5
							burn_flame_multiplier = 0.5
							upgraded = BARRICADE_UPGRADE_ANTIFF
							to_chat(user, SPAN_NOTICE("You applied a composite upgrade."))

					metal.use(2)
					user.count_niche_stat(STATISTICS_NICHE_UPGRADE_CADES)
					update_icon()
					return
				else
					var/static/list/cade_types = list(BARRICADE_UPGRADE_ANTIFF = image(icon = 'icons/obj/structures/barricades.dmi', icon_state = "explosive_obj"), BARRICADE_UPGRADE_BRUTE = image(icon = 'icons/obj/structures/barricades.dmi', icon_state = "brute_obj"), BARRICADE_UPGRADE_BURN = image(icon = 'icons/obj/structures/barricades.dmi', icon_state = "burn_obj"))
					var/choice = show_radial_menu(user, src, cade_types, require_near = TRUE)
					if(!choice)
						return
					if(!user.Adjacent(src))
						to_chat(user, SPAN_NOTICE("You are too far away!"))
						return
					if(upgraded)
						to_chat(user, SPAN_NOTICE("This barricade is already upgraded."))
						return
					if(metal.get_amount() < 2)
						to_chat(user, SPAN_NOTICE("You lack the required metal."))
						return
					if((usr.get_active_hand()) != metal)
						to_chat(user, SPAN_WARNING("You must be holding [metal] to upgrade [src]!"))
						return

					switch(choice)
						if(BARRICADE_UPGRADE_BURN)
							burn_multiplier = 0.75
							burn_flame_multiplier = 0.75
							upgraded = BARRICADE_UPGRADE_BURN
							to_chat(user, SPAN_NOTICE("You applied a biohazardous upgrade."))
						if(BARRICADE_UPGRADE_BRUTE)
							brute_multiplier = 0.75
							brute_projectile_multiplier = 0.75
							upgraded = BARRICADE_UPGRADE_BRUTE
							to_chat(user, SPAN_NOTICE("You applied a reinforced upgrade."))
						if(BARRICADE_UPGRADE_ANTIFF)
							explosive_multiplier = 0.5
							brute_projectile_multiplier = 0.5
							burn_flame_multiplier = 0.5
							upgraded = BARRICADE_UPGRADE_ANTIFF
							to_chat(user, SPAN_NOTICE("You applied a composite upgrade."))

					metal.use(2)
					user.count_niche_stat(STATISTICS_NICHE_UPGRADE_CADES)
					update_icon()
					return

			if(HAS_TRAIT(item, TRAIT_TOOL_MULTITOOL))
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("You are not trained to touch [src]..."))
					return
				if(user.action_busy || !upgraded)
					return
				if(!do_after(user, 5, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					return
				user.visible_message(SPAN_NOTICE("[user] strips off [src]'s upgrade."),
					SPAN_NOTICE("You strip off [src]'s upgrade, making it a normal cade."))
				upgraded = null
				explosive_multiplier = initial(explosive_multiplier)
				brute_multiplier = initial(brute_multiplier)
				brute_projectile_multiplier = initial(brute_projectile_multiplier)
				burn_multiplier = initial(burn_multiplier)
				burn_flame_multiplier = initial(burn_flame_multiplier)
				new stack_type (loc, 1)
				update_icon()
				return

		if(BARRICADE_BSTATE_UNSECURED) //Protection panel removed step. Screwdriver to put the panel back, wrench to unsecure the anchor bolts
			if(HAS_TRAIT(item, TRAIT_TOOL_SCREWDRIVER))
				if(user.action_busy)
					return
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("You are not trained to assemble [src]..."))
					return
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					return
				user.visible_message(SPAN_NOTICE("[user] set [src]'s protection panel back."),
				SPAN_NOTICE("You set [src]'s protection panel back."))
				build_state = BARRICADE_BSTATE_SECURED
				return

			if(HAS_TRAIT(item, TRAIT_TOOL_WRENCH))
				if(user.action_busy)
					return
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("You are not trained to disassemble [src]..."))
					return
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					return
				user.visible_message(SPAN_NOTICE("[user] loosens [src]'s anchor bolts."),
				SPAN_NOTICE("You loosen [src]'s anchor bolts."))
				anchored = FALSE
				build_state = BARRICADE_BSTATE_MOVABLE
				update_icon() //unanchored changes layer
				return

		if(BARRICADE_BSTATE_MOVABLE) //Anchor bolts loosened step. Apply crowbar to unseat the panel and take apart the whole thing. Apply wrench to resecure anchor bolts
			if(HAS_TRAIT(item, TRAIT_TOOL_WRENCH))
				if(user.action_busy)
					return
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("You are not trained to assemble [src]..."))
					return
				for(var/obj/structure/barricade/B in loc)
					if(B != src && B.dir == dir)
						to_chat(user, SPAN_WARNING("There's already a barricade here."))
						return
				var/turf/open/turf = loc
				if(!(istype(turf) && turf.allow_construction))
					to_chat(user, SPAN_WARNING("[src] must be secured on a proper surface!"))
					return
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					return
				user.visible_message(SPAN_NOTICE("[user] secures [src]'s anchor bolts."),
				SPAN_NOTICE("You secure [src]'s anchor bolts."))
				build_state = BARRICADE_BSTATE_UNSECURED
				anchored = TRUE
				update_icon() //unanchored changes layer
				return

			if(HAS_TRAIT(item, TRAIT_TOOL_CROWBAR))
				if(user.action_busy)
					return
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("You are not trained to disassemble [src]..."))
					return
				user.visible_message(SPAN_NOTICE("[user] starts unseating [src]'s panels."),
				SPAN_NOTICE("You start unseating [src]'s panels."))
				playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
				if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					user.visible_message(SPAN_NOTICE("[user] takes [src]'s panels apart."),
					SPAN_NOTICE("You take [src]'s panels apart."))
					playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
					deconstruct(TRUE) //Note : Handles deconstruction too !
				return

	return ..()

/obj/structure/barricade/metal/wired/New()
	maxhealth += 50
	update_health(-50)
	can_wire = FALSE
	is_wired = TRUE
	climbable = FALSE
	update_icon()
	return ..()

/obj/structure/barricade/metal/wired/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	flags_can_pass_front_temp &= ~PASS_OVER_THROW_MOB
	flags_can_pass_behind_temp &= ~PASS_OVER_THROW_MOB

/obj/structure/barricade/metal/plasteel
	name = "plasteel barricade"
	desc = "A sturdy and easily assembled barricade made of reinforced plasteel plates, the pinnacle of strongpoints. Use a blowtorch to repair."
	icon_state = "new_plasteel_0"
	health = 900
	maxhealth = 900
	crusher_resistant = TRUE
	force_level_absorption = 20
	stack_type = /obj/item/stack/sheet/plasteel
	debris = list(/obj/item/stack/sheet/plasteel)
	destroyed_stack_amount = 3
	barricade_type = "new_plasteel"
	repair_materials = list("plasteel" = 0.45)

