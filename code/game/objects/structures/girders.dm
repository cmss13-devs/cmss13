#define STATE_STANDARD 0
#define STATE_DISMANTLING 1
#define STATE_WALL 2
#define STATE_REINFORCED_WALL 3
#define STATE_DISPLACED 4

#define STATE_SCREWDRIVER 1
#define STATE_WIRECUTTER 2
#define STATE_METAL 3
#define STATE_PLASTEEL 4
#define STATE_RODS 5

#define GIRDER_UPGRADE_MATERIAL_COST 5

/obj/structure/girder
	icon_state = "girder"
	anchored = TRUE
	density = TRUE
	layer = OBJ_LAYER
	unacidable = FALSE
	debris = list(/obj/item/stack/sheet/metal, /obj/item/stack/sheet/metal)
	var/state = STATE_STANDARD
	var/step_state = STATE_STANDARD
	health = 125
	// To store what type of wall it used to be
	var/original

/obj/structure/girder/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_THROUGH|PASS_HIGH_OVER_ONLY

/obj/structure/girder/get_examine_text(mob/user)
	. = ..()
	if (health <= 0)
		. += "It's broken, but can be mended by welding it."
		return

	switch(state)
		if(STATE_STANDARD)
			if(step_state == STATE_STANDARD)
				. += SPAN_NOTICE("It looks ready for a [SPAN_HELPFUL("screwdriver")] to dismantle, [SPAN_HELPFUL("metal")] to create a wall or [SPAN_HELPFUL("plasteel")] to create a reinforced wall.")
				return
		if(STATE_DISMANTLING)
			if(step_state == STATE_SCREWDRIVER)
				. += SPAN_NOTICE("Support struts are unsecured. [SPAN_HELPFUL("Wirecutters")] to remove.")
			else if(step_state == STATE_WIRECUTTER)
				. += SPAN_NOTICE("Support struts are removed. [SPAN_HELPFUL("Crowbar")] to dislodge, [SPAN_HELPFUL("wrench")] to dismantle.")
			return
		if(STATE_WALL)
			if(step_state == STATE_METAL)
				. += SPAN_NOTICE("Metal added. [SPAN_HELPFUL("Screwdrivers")] to attach.")
			else if(step_state == STATE_SCREWDRIVER)
				. += SPAN_NOTICE("Metal attached. [SPAN_HELPFUL("Weld")] to finish.")
			return
		if(STATE_REINFORCED_WALL)
			if(step_state == STATE_PLASTEEL)
				. += SPAN_NOTICE("Plasteel added. Add [SPAN_HELPFUL("metal rods")] to stengthen.")
			else if(step_state == STATE_RODS)
				. += SPAN_NOTICE("Metal rods added. [SPAN_HELPFUL("Screwdrivers")] to attach.")
			else if(step_state == STATE_SCREWDRIVER)
				. += SPAN_NOTICE("Plasteel attached. [SPAN_HELPFUL("Weld")] to finish.")
			return
		if(STATE_DISPLACED)
			. += SPAN_NOTICE("It looks dislodged. [SPAN_HELPFUL("Crowbar")] to secure it.")

/obj/structure/girder/update_icon()
	. = ..()

	if(!anchored)
		icon_state = "displaced"
	else
		icon_state = "girder"

/obj/structure/girder/attackby(obj/item/W, mob/user)
	for(var/obj/effect/xenomorph/acid/A in src.loc)
		if(A.acid_t == src)
			to_chat(user, "You can't get near that, it's melting!")
			return

	if(user.action_busy)
		return TRUE //no afterattack

	if(istype(W, /obj/item/weapon/twohanded/breacher))
		var/obj/item/weapon/twohanded/breacher/current_hammer = W
		if(user.action_busy)
			return
		if(!(HAS_TRAIT(user, TRAIT_SUPER_STRONG) || !current_hammer.really_heavy))
			to_chat(user, SPAN_WARNING("You can't use \the [current_hammer] properly!"))
			return

		to_chat(user, SPAN_NOTICE("You start taking down \the [src]."))
		if(!do_after(user, 3 SECONDS, INTERRUPT_ALL_OUT_OF_RANGE, BUSY_ICON_BUILD))
			to_chat(user, SPAN_NOTICE("You stop taking down \the [src]."))
			return
		to_chat(user, SPAN_NOTICE("You tear down \the [src]."))

		playsound(loc, 'sound/effects/metal_shatter.ogg', 40, 1)
		dismantle()
		return

	if(istool(W) && !skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
		to_chat(user, SPAN_WARNING("You are not trained to configure [src]..."))
		return TRUE

	if(health > 0)
		if(change_state(W, user))
			return
	else if(iswelder(W))
		if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		for(var/obj/object in loc)
			if(object.density)
				to_chat(user, SPAN_WARNING("[object] is blocking you from welding [src] together!"))
				return
		if(do_after(user,30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			if(QDELETED(src))
				return
			to_chat(user, SPAN_NOTICE("You weld the girder together!"))
			repair()
			return
	..()

/obj/structure/girder/proc/change_state(obj/item/W, mob/user)
	switch(state)
		if(STATE_STANDARD)
			if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("Now unsecuring support struts."))
				if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return TRUE
				to_chat(user, SPAN_NOTICE("You unsecured the support struts!"))
				state = STATE_DISMANTLING
				step_state = STATE_SCREWDRIVER
				return TRUE

			else if(istype(W, /obj/item/stack/sheet/metal))
				if(istype(get_area(loc), /area/shuttle))
					to_chat(user, SPAN_WARNING("No. This area is needed for the dropships and personnel."))
					return TRUE

				var/obj/item/stack/sheet/metal/M = W
				to_chat(user, SPAN_NOTICE("You start adding the metal to the internals."))
				if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return TRUE
				if(M.use(GIRDER_UPGRADE_MATERIAL_COST))
					state = STATE_WALL
					step_state = STATE_METAL
					to_chat(user, SPAN_NOTICE("You added the metal to the internals!"))
				else
					to_chat(user, SPAN_NOTICE("Not enough metal!"))
				return TRUE

			else if(istype(W, /obj/item/stack/sheet/plasteel))
				if(istype(get_area(loc), /area/shuttle))
					to_chat(user, SPAN_WARNING("No. This area is needed for the dropships and personnel."))
					return TRUE

				var/obj/item/stack/sheet/plasteel/P = W
				to_chat(user, SPAN_NOTICE("You start adding the plates to the internals."))
				if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return TRUE
				if(P.use(GIRDER_UPGRADE_MATERIAL_COST))
					state = STATE_REINFORCED_WALL
					step_state = STATE_PLASTEEL
					to_chat(user, SPAN_NOTICE("You added the plates to the internals!"))
				else
					to_chat(user, SPAN_NOTICE("Not enough plasteel!"))
				return TRUE

		if(STATE_DISMANTLING)
			return do_dismantle(W, user)
		if(STATE_WALL)
			return do_wall(W, user)
		if(STATE_REINFORCED_WALL)
			return do_reinforced_wall(W, user)
		if(STATE_DISPLACED)
			if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
				var/turf/open/floor = loc
				if(!floor.allow_construction)
					to_chat(user, SPAN_WARNING("The girder must be secured on a proper surface!"))
					return
				var/obj/structure/tunnel/tunnel = locate(/obj/structure/tunnel) in loc
				if(tunnel)
					to_chat(user, SPAN_WARNING("The girder cannot be secured on a tunnel!"))
					return
				playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("Now securing the girder..."))
				if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return TRUE
				to_chat(user, SPAN_NOTICE("You secured the girder!"))
				anchored = TRUE
				state = STATE_STANDARD
				step_state = STATE_STANDARD
				update_icon()
				return TRUE
	return FALSE

/obj/structure/girder/proc/do_dismantle(obj/item/W, mob/user)
	if(!(state == STATE_DISMANTLING))
		return FALSE

	else if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS) && step_state == STATE_SCREWDRIVER)
		playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
		to_chat(user, SPAN_NOTICE("Now removing support struts."))
		if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return TRUE
		to_chat(user, SPAN_NOTICE("You removed the support struts!"))
		step_state = STATE_WIRECUTTER
		return TRUE

	else if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR) && step_state == STATE_WIRECUTTER)
		playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
		to_chat(user, SPAN_NOTICE("Now dislodging the girder..."))
		if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return TRUE
		to_chat(user, SPAN_NOTICE("You dislodged the girder!"))
		anchored = FALSE
		state = STATE_DISPLACED
		step_state = STATE_STANDARD
		update_icon()
		return TRUE

	else if(HAS_TRAIT(W, TRAIT_TOOL_WRENCH) && step_state == STATE_WIRECUTTER)
		to_chat(user, SPAN_NOTICE("You start wrenching it apart."))
		playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
		if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return TRUE
		to_chat(user, SPAN_NOTICE("You wrenched it apart!"))
		deconstruct(TRUE)

		return TRUE
	return FALSE

/obj/structure/girder/deconstruct(disassembled = TRUE)
	if(disassembled)
		new /obj/item/stack/sheet/metal(loc, 2)
	return ..()

/obj/structure/girder/proc/do_wall(obj/item/W, mob/user)
	if(!(state == STATE_WALL))
		return FALSE

	if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER) && step_state == STATE_METAL)
		playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
		to_chat(user, SPAN_NOTICE("You are attaching the metal to the internal structure."))
		if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, src))
			return TRUE
		to_chat(user, SPAN_NOTICE("You have attached the metal to the internal structure!"))
		step_state = STATE_SCREWDRIVER
		return TRUE

	if(iswelder(W) && step_state == STATE_SCREWDRIVER)
		if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		var/obj/item/tool/weldingtool/WT = W
		if(WT.remove_fuel(5, user))
			to_chat(user, SPAN_NOTICE("You start welding the new additions."))
			playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
			if(!do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, src))
				WT.remove_fuel(-5)
				return TRUE
			to_chat(user, SPAN_NOTICE("You have welded the new additions!"))
			playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
			var/turf/T = get_turf(src)
			if(is_mainship_level(z))
				T.PlaceOnTop(/turf/closed/wall/almayer)
				SEND_SIGNAL(user, COMSIG_MOB_CONSTRUCT_WALL, /turf/closed/wall/almayer)
			else
				T.PlaceOnTop(/turf/closed/wall)
				SEND_SIGNAL(user, COMSIG_MOB_CONSTRUCT_WALL, /turf/closed/wall)
			var/obj/effect/alien/weeds/weeds_in_tile = locate(/obj/effect/alien/weeds) in T
			if(weeds_in_tile)
				qdel(weeds_in_tile)
			T.add_fingerprint(user)
			qdel(src)
		return TRUE
	return FALSE

/obj/structure/girder/proc/do_reinforced_wall(obj/item/W, mob/user)
	if(!(state == STATE_REINFORCED_WALL))
		return FALSE

	if(istype(W, /obj/item/stack/rods) && step_state == STATE_PLASTEEL)
		var/obj/item/stack/rods/R = W
		if(R.use(2))
			to_chat(user, SPAN_NOTICE("You strengthened the connection rods."))
			step_state = STATE_RODS
		else
			to_chat(user, SPAN_NOTICE("You failed to strengthen the connection rods. You need more rods."))
		return TRUE

	if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER) && step_state == STATE_RODS)
		playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
		to_chat(user, SPAN_NOTICE("You are attaching the plasteel to the internal structure."))
		if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, src))
			return TRUE
		to_chat(user, SPAN_NOTICE("You have attached the plasteel to the internal structure!"))
		step_state = STATE_SCREWDRIVER
		return TRUE

	if(iswelder(W) && step_state == STATE_SCREWDRIVER)
		if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		var/obj/item/tool/weldingtool/WT = W
		if(WT.remove_fuel(5, user))
			to_chat(user, SPAN_NOTICE("You start welding the new additions."))
			playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
			if(!do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, src))
				WT.remove_fuel(-5)
				return TRUE
			to_chat(user, SPAN_NOTICE("You have welded the new additions!"))
			playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
			var/turf/T = get_turf(src)
			if(is_mainship_level(z))
				T.PlaceOnTop(/turf/closed/wall/almayer/reinforced)
			else
				T.PlaceOnTop(/turf/closed/wall/r_wall)
			var/obj/effect/alien/weeds/weeds_in_tile = locate(/obj/effect/alien/weeds) in T
			if(weeds_in_tile)
				qdel(weeds_in_tile)
			T.add_fingerprint(user)
			qdel(src)
		return TRUE

	return FALSE

/obj/structure/girder/bullet_act(obj/projectile/P)
	//Tasers and the like should not damage girders.
	if(P.ammo.damage_type == HALLOSS || P.ammo.damage_type == TOX || P.ammo.damage_type == CLONE || P.damage == 0)
		return FALSE
	var/dmg = 0
	if(P.ammo.damage_type == BURN)
		dmg = P.damage
	else
		dmg = floor(P.damage * 0.5)
	if(dmg)
		take_damage(dmg)
		bullet_ping(P)
	if(health <= 0)
		update_state()
	return TRUE

/obj/structure/girder/proc/take_damage(damage)
	health -= damage
	if(health <= -100)
		qdel(src)
	if(health <= 0)
		update_state()


/obj/structure/girder/proc/dismantle()
	health = 0
	update_state()

/obj/structure/girder/proc/repair()
	health = initial(health)
	update_state()

/obj/structure/girder/proc/update_state()
	if(health <= 0 && density)
		icon_state = "[icon_state]_damaged"
		density = FALSE

	else if(health > 0 && !density)
		var/underscore_position =  findtext(icon_state,"_")
		var/new_state = copytext(icon_state, 1, underscore_position)
		icon_state = new_state
		density = TRUE

/obj/structure/girder/attack_animal(mob/living/simple_animal/user)
	if(user.wall_smash)
		visible_message(SPAN_DANGER("[user] smashes [src] apart!"))
		dismantle()
		return
	return ..()

/obj/structure/girder/ex_act(severity, direction, datum/cause_data/cause_data)
	health -= severity
	if(health <= 0)
		var/location = get_turf(src)
		handle_debris(severity, direction)
		deconstruct(FALSE)
		create_shrapnel(location, rand(2,5), direction, 45, /datum/ammo/bullet/shrapnel/light, cause_data) // Shards go flying
	else
		update_state()

/obj/structure/girder/displaced
	icon_state = "displaced"
	anchored = FALSE
	state = STATE_DISPLACED

/obj/structure/girder/reinforced
	icon_state = "reinforced"
	health = 500


#undef STATE_STANDARD
#undef STATE_DISMANTLING
#undef STATE_WALL
#undef STATE_REINFORCED_WALL

#undef STATE_SCREWDRIVER
#undef STATE_WIRECUTTER
#undef STATE_METAL
#undef STATE_PLASTEEL
#undef STATE_RODS

#undef GIRDER_UPGRADE_MATERIAL_COST
