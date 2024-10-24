#define DROPSIP_TIME_REDUCTION_IF_IN_AA_ZONE 0.9

/obj/structure/machinery/defenses/planetary_anti_air
	name = "\improper Planetary AA"
	desc = "\improper The Planetary AA provides cover from aerial attacks"
	icon = 'icons/obj/structures/machinery/defenses/aa_tower.dmi'
	icon_state = ""
	can_be_near_defense = TRUE
	defense_icon = null
	faction_group = FACTION_LIST_MARINE
	bound_width = 32
	bound_height = 32
	pixel_x = -15
	pixel_y = -8
	hack_time = 300
	disassemble_time = 150
	health = 500
	health_max = 500
	anchored = FALSE
	placed = FALSE
	static = TRUE
	encryptable = FALSE
	var/luminosity_strength = 2
	var/anchor_time = 40

	//CAS cant operate in area
	var/restricted_range = 20
	//CAS can operate but will get some effects
	var/covered_range = 40

	var/list/linked_turfs_restricted = list()
	var/list/linked_turfs_covered = list()

	var/last_fired = 0
	var/fire_delay = 30

/obj/structure/machinery/defenses/planetary_anti_air/proc/fire()
	if(!(world.time - last_fired >= fire_delay) || !turned_on || health <= 0)
		return

	playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
	sleep(3)
	visible_message("[icon2html(src, viewers(src))] [SPAN_WARNING("The [name] fires projectiles into air!")]")
	playsound(loc, 'sound/weapons/vehicles/autocannon_fire.ogg', 50, 1)
	sleep(0.5)
	playsound(loc, 'sound/weapons/vehicles/autocannon_fire.ogg', 50, 1)
	last_fired = world.time

/obj/structure/machinery/defenses/planetary_anti_air/get_examine_text(mob/user)
	var/message = ""
	if (health <= 0)
		message += "It appears to be completely broken."
		return list(message)
	if(stat == DEFENSE_DAMAGED)
		message += "It does not appear to be working.\n"
	if(ishuman(user))
		if (FACTION_UPP in faction_group)
			message += SPAN_INFO("It is currently allied to [FACTION_UPP].") + "\n"
		if (FACTION_MARINE in faction_group)
			message += SPAN_INFO("It is currently allied to [FACTION_MARINE].") + "\n"
		message += SPAN_INFO("It has [SPAN_HELPFUL("[health]/[health_max]")] health.")
	return list(message)

/obj/structure/machinery/defenses/planetary_anti_air/attackby(obj/item/object as obj, mob/user as mob)
	if(QDELETED(object))
		return

	if(HAS_TRAIT(object, TRAIT_TOOL_MULTITOOL))
		if(!friendly_faction(user.faction))
			to_chat(user, SPAN_WARNING("This doesn't seem safe..."))
			var/additional_shock = 1
			if(!do_after(user, hack_time * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
				additional_shock++
			if(prob(50))
				var/mob/living/carbon/human/user_human = user
				if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_NOVICE))
					if(turned_on)
						additional_shock++
					user_human.electrocute_act(40, src, additional_shock)//god damn Hans...
					setDir(get_dir(src, user_human))//Make sure he died
					power_off()
					power_on()
					return
				else
					user_human.electrocute_act(20, src)//god bless him for stupid move
					return
			if(additional_shock >= 2)
				return
			LAZYCLEARLIST(faction_group)
			for(var/i in user.faction_group)
				LAZYADD(faction_group, i)
			to_chat(user, SPAN_WARNING("You've hacked \the [src], it's now ours!"))
			return

		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_NOVICE))
			to_chat(user, SPAN_WARNING("You don't have the training to do this."))
			return

		if(static)
			to_chat(user, SPAN_WARNING("\The [src] is bolted to the ground!"))
			return

		user.visible_message(SPAN_NOTICE("[user] begins disassembling \the [src]."), SPAN_NOTICE("You begin disassembling \the [src]."))

		if(!do_after(user, disassemble_time * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
			return

		if(health < health_max * 0.25) //repeat check
			to_chat(user, SPAN_WARNING("\The [src] is too damaged to pick up!"))
			return

		user.visible_message(SPAN_NOTICE("[user] disassembles [src]."), SPAN_NOTICE("You disassemble [src]."))

		playsound(loc, 'sound/mecha/mechmove04.ogg', 30, 1)
		var/turf/turf_under_aa = get_turf(src)
		power_off()
		HD.forceMove(turf_under_aa)
		transfer_label_component(HD)
		HD.dropped = 1
		HD.update_icon()
		placed = 0
		forceMove(HD)

		return

	if(HAS_TRAIT(object, TRAIT_TOOL_WRENCH))
		if(anchored)
			if(turned_on)
				to_chat(user, SPAN_WARNING("[src] is currently active. You need to deactivate it first."))
				return
			user.visible_message(SPAN_NOTICE("[user] begins unanchoring [src] from the ground."),
			SPAN_NOTICE("You begin unanchoring [src] from the ground."))

			if(!do_after(user, anchor_time * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
				return
			user.visible_message(SPAN_NOTICE("[user] unanchors [src] from the ground."),
			SPAN_NOTICE("You unanchor [src] from the ground."))
			anchored = FALSE
			playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
			return
		else
			var/turf/turf_under_aa = get_turf(src)
			var/area/area = get_area(turf_under_aa)
			if(CEILING_IS_PROTECTED(area.ceiling, CEILING_PROTECTION_TIER_1) || !is_ground_level(turf_under_aa.z))
				to_chat(user, SPAN_RED("You realize how bad of an idea this is and quickly stop."))
				return

			var/turf/open/floor = get_turf(src)
			if(!floor.allow_construction)
				to_chat(user, SPAN_WARNING("You cannot secure \the [src] here, find a more secure surface!"))
				return FALSE
			user.visible_message(SPAN_NOTICE("[user] begins securing [src] to the ground."),
			SPAN_NOTICE("You begin securing [src] to the ground."))

			if(!do_after(user, anchor_time * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
				return
			user.visible_message(SPAN_NOTICE("[user] secures [src] to the ground."),
			SPAN_NOTICE("You secure [src] to the ground."))
			anchored = TRUE
			playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
			return

	if(iswelder(object))
		if(!HAS_TRAIT(object, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		var/obj/item/tool/weldingtool/WT = object
		if(health < 0)
			to_chat(user, SPAN_WARNING("[src]'s internal circuitry is ruined, there's no way you can salvage this on the go."))
			return

		if(health >= health_max)
			to_chat(user, SPAN_WARNING("[src] isn't in need of repairs."))
			return

		if(WT.remove_fuel(0, user))
			user.visible_message(SPAN_NOTICE("[user] begins repairing [src]."),
			SPAN_NOTICE("You begin repairing [src]."))
			if(do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, src))
				user.visible_message(SPAN_NOTICE("[user] repairs [src]."),
				SPAN_NOTICE("You repair [src]."))
				if(stat == DEFENSE_DAMAGED)
					stat &= ~DEFENSE_DAMAGED
				update_health(-50)
				playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
			return
		return

	return TRUE

/obj/structure/machinery/defenses/planetary_anti_air/update_icon()
	if(turned_on)
		if (FACTION_UPP in faction_group)
			icon_state = "aa_upp"
		else
			icon_state = "aa_uscm"
	else if(health <= 0)
		icon_state = "aa_destroyed"
	else
		icon_state = "aa_off"

/obj/structure/machinery/defenses/planetary_anti_air/upp
	icon = 'icons/obj/structures/machinery/defenses/aa_tower.dmi'
	icon_state = "aa_upp"
	faction_group = FACTION_LIST_UPP

/obj/structure/machinery/defenses/planetary_anti_air/proc/get_protection_level(turf/turf_to_check)
	if (turf_to_check in linked_turfs_restricted)
		return TURF_AA_PROTECTION_CAS_RESTRICTED
	if (turf_to_check in linked_turfs_covered)
		return TURF_AA_PROTECTION_CAS_COVERED
	return TURF_PROTECTION_NONE

/obj/structure/machinery/defenses/planetary_anti_air/power_on_action(mob/user)
	var/turf/turf_under_aa = get_turf(src)
	var/area/area = get_area(turf_under_aa)

	if(CEILING_IS_PROTECTED(area.ceiling, CEILING_PROTECTION_TIER_1))
		to_chat(user, SPAN_RED("[name] must be in the open air."))
		return
	if(!is_ground_level(turf_under_aa.z))
		to_chat(user, SPAN_RED("You realize how bad of an idea this is and quickly stop."))
		return

	set_light(luminosity_strength)
	visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("The [name] hums to life and emits several beeps.")]")

	for(var/turf/turf_in_big_range as anything in RANGE_TURFS(covered_range, loc))
		LAZYADD(turf_in_big_range.linked_aa, src)
		linked_turfs_covered += turf_in_big_range
	for(var/turf/turf_in_close_range as anything in RANGE_TURFS(restricted_range, loc))
		linked_turfs_restricted += turf_in_close_range

/obj/structure/machinery/defenses/planetary_anti_air/proc/remove_protected_area()
	for(var/turf/turf_in_big_range as anything in RANGE_TURFS(covered_range, loc))
		LAZYREMOVE(turf_in_big_range.linked_aa, src)
		linked_turfs_covered -= turf_in_big_range
	for(var/turf/turf_in_close_range as anything in RANGE_TURFS(restricted_range, loc))
		linked_turfs_restricted -= turf_in_close_range

/obj/structure/machinery/defenses/planetary_anti_air/power_off_action(mob/user)
	set_light(0)
	visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("The [name] powers down and goes silent.")]")
	remove_protected_area()

/obj/structure/machinery/defenses/planetary_anti_air/Destroy()
	remove_protected_area()
	update_icon()
	. = ..()

/obj/structure/machinery/defenses/planetary_anti_air/destroyed_action()
	remove_protected_area()
	visible_message("[icon2html(src, viewers(src))] [SPAN_WARNING("The [name] starts spitting out sparks and smoke!")]")
	playsound(loc, 'sound/mecha/critdestrsyndi.ogg', 25, 1)
	sleep(10)
	cell_explosion(loc, 20, 20, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("AA tower explosion"))
	update_icon()

/obj/structure/machinery/defenses/planetary_anti_air/damaged_action(damage)
	if(health < health_max * 0.15)
		visible_message(SPAN_DANGER("[icon2html(src, viewers(src))] The [name] cracks and breaks apart!"))
		stat |= DEFENSE_DAMAGED
		turned_on = FALSE
		remove_protected_area()
		set_light(0)
		update_icon()
