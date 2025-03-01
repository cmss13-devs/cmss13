
/datum/component/ai_behavior_override/capture
	behavior_icon_state = "capture_order"

	max_assigned = 1

/datum/component/ai_behavior_override/capture/Initialize(...)
	. = ..()

	if(!ishuman(parent))
		var/mob/living/carbon/human/new_parent = locate() in get_turf(parent)
		if(new_parent)
			new_parent.AddComponent(/datum/component/ai_behavior_override/capture)

		return COMPONENT_INCOMPATIBLE

/datum/component/ai_behavior_override/capture/check_behavior_validity(mob/living/carbon/xenomorph/checked_xeno, distance)
	. = ..()
	if(!.)
		return

	if(isfacehugger(checked_xeno))
		return FALSE

	var/mob/living/parent_mob = parent

	var/captee_stat = parent_mob.stat
	var/mob/pulledby = parent_mob.pulledby

	if(captee_stat == DEAD)
		qdel(src)
		return FALSE

	if(HAS_TRAIT(parent, TRAIT_NESTED))
		qdel(src)
		return FALSE

	if(!length(GLOB.ai_hives))
		for(var/client/game_master in GLOB.game_masters)
			to_chat(game_master, SPAN_XENOBOLDNOTICE("Capture behavior requires a valid hive placed"))

		qdel(src)
		return FALSE

	if(distance > 10)
		return FALSE

	if(captee_stat == CONSCIOUS && !(locate(/datum/effects/crit) in parent_mob.effects_list))
		return FALSE

	if(isxeno(pulledby) && pulledby != checked_xeno)
		return FALSE

	return TRUE

/datum/component/ai_behavior_override/capture/process_override_behavior(mob/living/carbon/xenomorph/processing_xeno, delta_time)
	. = ..()
	if(!.)
		return

	processing_xeno.current_target = parent
	processing_xeno.set_resting(FALSE, FALSE, TRUE)

	if(processing_xeno.get_active_hand())
		processing_xeno.swap_hand()

	var/datum/xeno_ai_movement/processing_xeno_movement = processing_xeno.ai_movement_handler
	if(processing_xeno.pulling == parent)
		processing_xeno_movement.ai_move_hive(delta_time)
		return TRUE

	var/atom/movable/target = processing_xeno.current_target
	if(get_dist(processing_xeno, target) <= 1)
		INVOKE_ASYNC(processing_xeno, TYPE_PROC_REF(/mob, start_pulling), target)
		processing_xeno.face_atom(target)
		processing_xeno.swap_hand()

	processing_xeno.ai_move_target(delta_time)
	return TRUE
