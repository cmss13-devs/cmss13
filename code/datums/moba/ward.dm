/datum/action/xeno_action/activable/place_ward
	name = "Place Ward"
	desc = "Place a vision ward that goes invisible after a short duration. This ward can be observed by all xenomorphs on your team and will decay after 2 minutes. Your wards are shared between the entire team."
	action_icon_state = "shield pillar"
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 1 SECONDS
	plasma_cost = 0
	var/place_range = 4
	var/team2 = FALSE
	var/map_id

/datum/action/xeno_action/activable/place_ward/New(Target, override_icon_state, team2, map_id)
	. = ..()
	src.team2 = team2
	src.map_id = map_id

/datum/action/xeno_action/activable/place_ward/can_use_action()
	if(!map_id)
		return FALSE
	var/datum/moba_controller/controller = SSmoba.get_moba_controller(map_id)
	if(!team2 && controller.team1_ward_count)
		return TRUE
	else if(team2 && controller.team2_ward_count)
		return TRUE
	return FALSE

/datum/action/xeno_action/activable/place_ward/use_ability(atom/targetted_atom)
	var/mob/living/carbon/xenomorph/stabbing_xeno = owner

	if(HAS_TRAIT(stabbing_xeno, TRAIT_ABILITY_BURROWED) || stabbing_xeno.is_ventcrawling)
		to_chat(stabbing_xeno, SPAN_XENOWARNING("We must be above ground to do this."))
		return FALSE

	var/datum/moba_controller/controller = SSmoba.get_moba_controller(map_id)
	if(!team2 && !controller.team1_ward_count)
		return FALSE
	else if(team2 && !controller.team2_ward_count)
		return FALSE

	if(!isturf(targetted_atom))
		targetted_atom = get_turf(targetted_atom)
		return FALSE

	if(!stabbing_xeno.check_state())
		return FALSE

	if(!action_cooldown_check())
		return FALSE

	var/distance = get_dist(stabbing_xeno, targetted_atom)
	if(distance > place_range)
		return FALSE

	var/list/turf/path = get_line(stabbing_xeno, targetted_atom, include_start_atom = FALSE)
	for(var/turf/path_turf as anything in path)
		if(path_turf.density)
			to_chat(stabbing_xeno, SPAN_WARNING("We need to be unobstructed to place a ward."))
			return FALSE
		for(var/obj/path_contents in path_turf.contents)
			if(path_contents != targetted_atom && path_contents.density && !path_contents.throwpass)
				to_chat(stabbing_xeno, SPAN_WARNING("We need to be unobstructed to place a ward."))
				return FALSE

	if(!team2)
		SSmoba.get_moba_controller(map_id).use_team1_ward()
		new /obj/effect/alien/resin/construction/ward(targetted_atom, GLOB.hive_datum[XENO_HIVE_MOBA_LEFT], map_id, FALSE)
	else
		SSmoba.get_moba_controller(map_id).use_team2_ward()
		new /obj/effect/alien/resin/construction/ward(targetted_atom, GLOB.hive_datum[XENO_HIVE_MOBA_RIGHT], map_id, TRUE)
	owner.visible_message(SPAN_XENONOTICE("[owner] plants a [name]."), SPAN_XENONOTICE("We plant a [name]."))

	apply_cooldown()
	return ..()


/obj/effect/alien/resin/construction/ward
	name = "resin ward"
	desc = "A pillar of some sort. You swear a light in it is following you."
	icon = 'icons/obj/structures/alien/structures.dmi'
	icon_state = "resin_ward"
	var/team2
	var/map_id
	var/decay_time = 2 MINUTES
	var/creation_time
	COOLDOWN_DECLARE(warning_declare_cd)
	var/warning_cooldown_time = 20 SECONDS

/obj/effect/alien/resin/construction/ward/Initialize(mapload, hive_ref, map_id, team2)
	. = ..()
	name = "resin ward ([rand(0, 9)][rand(0, 9)][rand(0, 9)])"
	var/datum/moba_controller/controller = SSmoba.get_moba_controller(map_id)
	src.team2 = team2
	src.map_id = map_id
	if(!team2)
		controller.add_team1_ward(src)
	else
		controller.add_team2_ward(src)

	animate(src, alpha = 125, 2 SECONDS)
	addtimer(VARSET_CALLBACK(src, invisibility, INVISIBILITY_LEVEL_TWO), 2 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(decay)), decay_time + (2 SECONDS))
	creation_time = world.time
	for(var/turf/open/tile in range(7, src))
		RegisterSignal(tile, COMSIG_TURF_ENTERED, PROC_REF(on_turf_enter))

	RegisterSignal(get_turf(src), COMSIG_PARENT_EXAMINE, PROC_REF(on_mainturf_examine))

/obj/effect/alien/resin/construction/ward/Destroy()
	var/datum/moba_controller/controller = SSmoba.get_moba_controller(map_id)
	if(!team2)
		controller.team1_wards -= src
		controller.remove_team1_ward(src)
	else
		controller.team2_wards -= src
		controller.remove_team2_ward(src)
	return ..()

/obj/effect/alien/resin/construction/ward/get_examine_text(mob/user)
	. = ..()
	var/can_see = FALSE
	if(isobserver(user))
		can_see = TRUE
	else if(isxeno(user))
		var/mob/living/carbon/xenomorph/xeno = user
		if(!team2 && (xeno.hivenumber == XENO_HIVE_MOBA_LEFT))
			can_see = TRUE
		else if(team2 && (xeno.hivenumber == XENO_HIVE_MOBA_RIGHT))
			can_see = TRUE

	if(can_see)
		. += SPAN_XENONOTICE("[src] will decay in [((creation_time + decay_time) - world.time) * 0.1] seconds.")
		if(!COOLDOWN_FINISHED(src, warning_declare_cd))
			. += SPAN_XENONOTICE("[src] will be ready to alert us again in [COOLDOWN_TIMELEFT(src, warning_declare_cd) * 0.1] seconds.")

/obj/effect/alien/resin/construction/ward/proc/decay()
	visible_message(SPAN_XENOWARNING("[src] wilts away into small chunks of resin."))
	qdel(src)

/// Even though we can see the object thanks to client images, we can't examine it. This is a workaround.
/obj/effect/alien/resin/construction/ward/proc/on_mainturf_examine(datum/source, mob/observer, list/strings)
	SIGNAL_HANDLER

	if(isobserver(observer))
		return

	examine(observer)
	return COMPONENT_NO_EXAMINE

/obj/effect/alien/resin/construction/ward/proc/on_turf_enter(datum/source, atom/movable/mover)
	SIGNAL_HANDLER

	if(!COOLDOWN_FINISHED(src, warning_declare_cd))
		return

	if(isxeno(mover) && !HAS_TRAIT(mover, TRAIT_MOBA_MINION))
		var/mob/living/carbon/xenomorph/xeno = mover
		if(!team2 && (xeno.hivenumber != XENO_HIVE_MOBA_LEFT))
			announce_warning(xeno, XENO_HIVE_MOBA_LEFT)
		else if(team2 && (xeno.hivenumber != XENO_HIVE_MOBA_RIGHT))
			announce_warning(xeno, XENO_HIVE_MOBA_RIGHT)

/obj/effect/alien/resin/construction/ward/proc/announce_warning(mob/living/carbon/xenomorph/xeno, hivenumber)
	COOLDOWN_START(src, warning_declare_cd, warning_cooldown_time)
	for(var/mob/living/carbon/xenomorph/listener as anything in GLOB.living_xeno_list)
		if((listener.hivenumber == hivenumber) && HAS_TRAIT(listener, TRAIT_MOBA_MAP_PARTICIPANT(map_id)))
			to_chat(listener, SPAN_XENOMINORWARNING("We sense that [xeno] has walked near our [src]!"))
