
/datum/component/ai_behavior_override/build
	behavior_icon_state = "priority_move_order"

	max_assigned = 1

/datum/component/ai_behavior_override/build/Initialize(...)
	. = ..()

	if(istype(parent, /mob))
		return COMPONENT_INCOMPATIBLE

	var/turf/open/location = get_turf(parent)
	if(location.is_weedable() != FULLY_WEEDABLE)
		return COMPONENT_INCOMPATIBLE

/datum/component/ai_behavior_override/build/Destroy(force, silent, ...)
	var/turf/parent_turf = get_turf(parent)
	if(QDELETED(parent) && parent_turf != parent)
		parent_turf.AddComponent(/datum/component/ai_behavior_override/build)

	return ..()

/datum/component/ai_behavior_override/build/check_behavior_validity(mob/living/carbon/xenomorph/checked_xeno, distance)
	. = ..()
	if(!.)
		return

	var/turf/open/location = get_turf(parent)
	if(!istype(location))
		qdel(src)
		return FALSE

	var/area/current_area = get_area(location)
	if(!current_area.is_resin_allowed)
		for(var/client/admin in GLOB.admins)
			to_chat(admin, SPAN_XENOBOLDNOTICE("[current_area] doesn't allow xenos to build here"))

		qdel(src)
		return FALSE

	if(locate(/obj/structure/mineral_door/resin) in location)
		qdel(src)
		return FALSE

	if(distance > 10)
		return FALSE

	if(!locate(/datum/action/xeno_action/activable/secrete_resin) in checked_xeno.actions)
		return FALSE

	if(checked_xeno.get_plasma_percentage() < PLASMA_RETREAT_PERCENTAGE)
		var/turf/xeno_loc = get_turf(checked_xeno)
		if(xeno_loc.weeds)
			checked_xeno.set_resting(TRUE, FALSE)

		return FALSE

	return TRUE

/datum/component/ai_behavior_override/build/process_override_behavior(mob/living/carbon/xenomorph/processing_xeno, delta_time)
	. = ..()
	if(!.)
		return

	processing_xeno.set_resting(FALSE, FALSE, TRUE)

	var/turf/xeno_loc = get_turf(processing_xeno)
	if(xeno_loc.density)
		return FALSE // We shouldn't stand in a wall, let's act default

	var/turf/parent_turf = get_turf(parent)
	var/distance = get_dist(processing_xeno, parent)

	/// Is xeno adjacent to parent_turf?
	if(distance > 1)
		return processing_xeno.move_to_next_turf(parent_turf)

	/// Xeno will be stuck after building at its loc, if so - we command droney to step away
	if(distance < 1)
		return processing_xeno.move_to_next_turf(pick(GLOB.cardinals))

	/// If there is something that might block our resin - slash it
	for(var/obj/structure/blocker in parent_turf.contents)
		if(!blocker.unslashable && (blocker.density || istype(blocker, /obj/structure/bed)))
			INVOKE_ASYNC(processing_xeno, TYPE_PROC_REF(/mob, do_click), blocker, "", list())
			return TRUE

	/// If no ground weeds present - command our xeno to plant one
	if(!parent_turf.weeds)
		var/datum/action/xeno_action/onclick/plant_weeds/weeds_action = locate() in processing_xeno.actions
		INVOKE_ASYNC(weeds_action, TYPE_PROC_REF(/datum/action/xeno_action/onclick/plant_weeds, use_ability_wrapper))
		return TRUE

	var/list/resin_types = processing_xeno.resin_build_order
	processing_xeno.selected_resin = locate(/datum/resin_construction/resin_turf/wall) in resin_types

	/// Let's decide whenever we are building a door or naw
	var/build_door = FALSE
	for(var/turf/blocked_turf in RANGE_TURFS(1, parent_turf) - parent_turf)
		var/direction = get_dir(parent_turf, blocked_turf)
		if(direction in GLOB.diagonals)
			continue

		if(!blocked_turf.density)
			continue

		/// Checking for any opposite walls on angles 135, 180, 225 respectfully
		for(var/opposite_dir in reverse_nearby_direction(direction))
			var/turf/opposite_turf = get_step(parent_turf, opposite_dir)
			if(opposite_turf.density)
				build_door = TRUE
				break

			var/obj/effect/alien/weeds/opposite_weeds = opposite_turf.weeds
			if(opposite_weeds && opposite_weeds.secreting)
				/// Something is being constructed nearby, let's bet this is a new resin wall
				build_door = TRUE

	if(build_door || prob(XENO_DOOR_BUILDING_CHANCE))
		processing_xeno.selected_resin = locate(/datum/resin_construction/resin_obj/door) in resin_types

	var/datum/action/xeno_action/activable/secrete_resin/build_action = locate() in processing_xeno.actions
	INVOKE_ASYNC(build_action, TYPE_PROC_REF(/datum/action/xeno_action/activable/secrete_resin, use_ability_wrapper), parent_turf)
	return TRUE
