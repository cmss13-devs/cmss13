/datum/component/moba_minion
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mob/living/carbon/xenomorph/parent_xeno
	var/atom/movable/target
	var/turf/next_turf_target
	var/is_moving_to_next_point = FALSE
	var/is_moving_to_target = FALSE
	var/walk_to_delay = 0.7 SECONDS

/datum/component/moba_minion/Initialize()
	. = ..()
	if(!isxeno(parent))
		return COMPONENT_INCOMPATIBLE

	parent_xeno = parent

	START_PROCESSING(SSprocessing, src)
	parent_xeno.a_intent_change(INTENT_HARM)
	parent_xeno.need_weeds = FALSE
	ADD_TRAIT(parent_xeno, TRAIT_MOBA_MINION, TRAIT_SOURCE_INHERENT)
	// We don't want minions passing through each other and players
	parent_xeno.pass_flags = new()
	parent_xeno.pass_flags.flags_pass = PASS_MOB_IS_XENO
	parent_xeno.pass_flags.flags_can_pass_all = PASS_MOB_THRU_XENO|PASS_AROUND|PASS_HIGH_OVER_ONLY

/datum/component/moba_minion/Destroy(force, silent)
	REMOVE_TRAIT(parent_xeno, TRAIT_MOBA_MINION, TRAIT_SOURCE_INHERENT)
	parent_xeno = null
	target = null
	next_turf_target = null
	return ..()

/datum/component/moba_minion/process(delta_time) // We do the bound_width/height bullshit so that AI can actually attack large objects
	if(parent_xeno.stat == DEAD)
		return

	if(!target)
		try_find_target()

	var/target_dist = get_dist(parent_xeno, target)

	if(target && (target_dist >= 4))
		target = null

	if(target && (target_dist > ((target.bound_height + target.bound_width) / 64)))
		move_to_target()

	if(target && ((target_dist <= ((target.bound_height + target.bound_width) / 64))))
		attack_target()

	if(!target && !is_moving_to_next_point)
		move_to_next_point()

/datum/component/moba_minion/proc/try_find_target()
	var/mob/living/best_target_found
	var/best_weight_found
	var/list/view_list = view(3, parent_xeno)
	for(var/mob/living/possible_target in view_list)
		var/weight = 0
		if((possible_target.stat == DEAD) || parent_xeno.hive.is_ally(possible_target) || HAS_TRAIT(possible_target, TRAIT_CLOAKED))
			continue

		if(HAS_TRAIT(possible_target, TRAIT_MOBA_ATTACKED_HIVE(parent_xeno.hive.hivenumber))) // If attacked a friendly player, they're on our shitlist
			weight = 4

		else if(HAS_TRAIT(possible_target, TRAIT_MOBA_PARTICIPANT))
			weight = 1

		else if(HAS_TRAIT(possible_target, TRAIT_MOBA_MINION))
			weight = 2

		if(weight > best_weight_found)
			best_target_found = possible_target
			best_weight_found = weight

	var/seen_turret = FALSE

	for(var/obj/effect/alien/resin/moba_turret/turret in view_list)
		if(turret.hivenumber == parent_xeno.hive.hivenumber)
			continue

		if(best_weight_found <= 2)
			best_target_found = turret
			seen_turret = TRUE

	if(!seen_turret) // We prioritize the things that are shooting at us first
		for(var/obj/effect/alien/resin/moba_hive_core/nexus in view_list)
			if(nexus.hivenumber == parent_xeno.hive.hivenumber)
				continue

			if(best_weight_found <= 2)
				best_target_found = nexus

	target = best_target_found
	if(target) // Zonenote consider having them return to the tile they came from if they move to target someone
		is_moving_to_next_point = FALSE
		walk(parent_xeno, 0) // stops them walking

/datum/component/moba_minion/proc/attack_target()
	if(isliving(target))
		var/mob/living/living_target = target
		if(living_target.stat == DEAD)
			target = null
			return

	is_moving_to_target = FALSE
	target.attack_alien(parent_xeno)

/datum/component/moba_minion/proc/move_to_target()
	walk_to(parent_xeno, target, 1, walk_to_delay)
	is_moving_to_target = TRUE

/datum/component/moba_minion/proc/move_to_next_point()
	is_moving_to_next_point = TRUE
	walk_to(parent_xeno, next_turf_target, 0, walk_to_delay)
