/datum/xeno_ai_movement/linger/lurking

	// Are we currently hiding?
	var/ai_lurking = FALSE

	// Gradually increases the chance of AI to try and bait marines, annoyance accumulate when we lurk (stand invisible) and aware of our target
	var/annoyance = 0

	// Total baits this xeno has made
	var/total_baits = 0

	// Distance at which we want to stay from our spotted target
	var/stalking_distance = 12

	// List of turfs we see and register while lurking
	var/list/registered_turfs = list()

	// Let's lower this a little bit cause we do some heavy checks while finding our "home"
	home_locate_range = 10

	max_distance_from_home = 10

#define AI_CHECK_ANNOYANCE_COOLDOWN 2.5 SECONDS

/datum/xeno_ai_movement/linger/lurking/New(mob/living/carbon/xenomorph/parent)
	. = ..()

	RegisterSignal(parent, COMSIG_XENO_HANDLE_AI_SHOT, PROC_REF(stop_lurking))
	RegisterSignal(parent, COMSIG_XENO_ENTER_CRIT, PROC_REF(stop_lurking))
	RegisterSignal(parent, COMSIG_XENO_USED_POUNCE, PROC_REF(stop_lurking))

	addtimer(CALLBACK(src, PROC_REF(check_annoyance)), AI_CHECK_ANNOYANCE_COOLDOWN, TIMER_UNIQUE|TIMER_LOOP|TIMER_DELETE_ME)

	start_lurking()

#undef AI_CHECK_ANNOYANCE_COOLDOWN

/datum/xeno_ai_movement/linger/lurking/ai_move_idle(delta_time)
	var/mob/living/carbon/xenomorph/idle_xeno = parent
	if(idle_xeno.throwing)
		return

	if(home_turf)
		if(get_dist(home_turf, idle_xeno) <= 0)
			start_lurking()
			return

		if(!idle_xeno.move_to_next_turf(home_turf))
			home_turf = null
			return

		return

	if(next_home_search > world.time)
		return

	var/turf/current_turf = get_turf(idle_xeno)

	if(!current_turf)
		return

	next_home_search = world.time + home_search_delay
	var/shortest_distance = INFINITY
	var/turf/non_preferred_turf
	for(var/turf/potential_home as anything in shuffle(RANGE_TURFS(home_locate_range, current_turf)))
		if(potential_home.density)
			continue

		var/blocked = FALSE
		for(var/obj/structure/potential_blocker in potential_home)
			if(potential_blocker.unslashable && potential_blocker.can_block_movement && potential_blocker.density)
				blocked = TRUE
				break

		for(var/mob/potential_blocker in potential_home)
			if(potential_blocker != idle_xeno && potential_blocker.can_block_movement && potential_blocker.density)
				blocked = TRUE
				break

		if(blocked)
			continue

		var/preferred = FALSE
		for(var/obj/structure/structure in potential_home)
			if(structure.unslashable && structure.can_block_movement && structure.density)
				continue

			if(structure.invisibility == 101)
				continue

			preferred = TRUE
			break

		for(var/turf/closed/touching_turf in orange(1, potential_home))
			if(get_dir(potential_home, touching_turf) in GLOB.diagonals)
				continue

			preferred = TRUE
			break

		for(var/obj/item/stack/sheet/sheet in potential_home)
			preferred = TRUE
			break

		var/atom/movable/our_target = idle_xeno.current_target
		if(our_target)
			var/potential_home_dir = get_dir(idle_xeno, potential_home)
			var/current_target_dir = get_dir(idle_xeno, our_target)

			if(current_target_dir == potential_home_dir || current_target_dir == turn(potential_home_dir, 45) || current_target_dir == turn(potential_home_dir, -45))
				continue

			if(get_dist(potential_home, our_target) > stalking_distance)
				continue

		var/xeno_to_potential_home_distance = get_dist(idle_xeno, potential_home)
		if(xeno_to_potential_home_distance > shortest_distance)
			continue

		if(preferred)
			home_turf = potential_home
			shortest_distance = xeno_to_potential_home_distance
			continue

		if(xeno_to_potential_home_distance < get_dist(idle_xeno, non_preferred_turf))
			non_preferred_turf = potential_home
			continue

	if(!home_turf)
		home_turf = non_preferred_turf
		return

/datum/xeno_ai_movement/linger/lurking/ai_move_target(delta_time)
	var/mob/living/carbon/xenomorph/moving_xeno = parent
	if(moving_xeno.throwing)
		return

	var/incapacitated_check = TRUE
	if(istype(moving_xeno.current_target, /mob))
		var/mob/current_target_mob = moving_xeno.current_target
		incapacitated_check = current_target_mob.is_mob_incapacitated()

	if(incapacitated_check)
		return ..()

	var/turf/target_turf = get_turf(moving_xeno.current_target)
	if(ai_lurking || get_dist(moving_xeno, target_turf) > world.view + 1)
		if(get_dist(moving_xeno, target_turf) > stalking_distance)
			home_turf = null
			return moving_xeno.move_to_next_turf(target_turf)
		return ai_move_idle(delta_time)

	annoyance = 0
	check_for_travelling_turf_change(moving_xeno)

	if(!moving_xeno.move_to_next_turf(travelling_turf))
		travelling_turf = target_turf
		return TRUE

/datum/xeno_ai_movement/linger/lurking/proc/check_annoyance()
	var/mob/living/carbon/xenomorph/annoyed_xeno = parent
	if(!annoyed_xeno.current_target || !ai_lurking)
		return

	var/target_distance = get_dist(annoyed_xeno, annoyed_xeno.current_target)

	if(target_distance < world.view)
		return

	if(target_distance > 10)
		annoyance = 0
		total_baits = 0
		return

	annoyance++

	if(prob(annoyance))
		try_bait()

#define LURKER_BAIT_TYPES list("Taunt","Emote","Interact")
#define LURKER_BAIT_EMOTES list("growl","roar","hiss","needshelp")
#define LURKER_BAIT_TAUNTS list("Come here, little host","I won't bite","I see you","Safe to go, little one")
#define LURKER_BAITS_BEFORE_AMBUSH 3

/datum/xeno_ai_movement/linger/lurking/proc/try_bait(no_interact)
	var/mob/living/carbon/xenomorph/baiting_xeno = parent
	if(baiting_xeno.throwing)
		return

	if(total_baits >= LURKER_BAITS_BEFORE_AMBUSH)
		stop_lurking()
		total_baits = 0
		return

	var/bait_types = LURKER_BAIT_TYPES
	if(no_interact)
		bait_types -= "Interact"

	var/bait = pick(bait_types)
	switch(bait)
		if("Emote")
			baiting_xeno.emote(pick(LURKER_BAIT_EMOTES))
		if("Taunt")
			baiting_xeno.say(pick(LURKER_BAIT_TAUNTS))
		if("Interact")
			if(!interact_random(baiting_xeno))
				return try_bait(no_interact = TRUE)

	total_baits++
	annoyance = 0
	return bait

#undef LURKER_BAIT_TYPES
#undef LURKER_BAIT_EMOTES
#undef LURKER_BAIT_TAUNTS
#undef LURKER_BAITS_BEFORE_AMBUSH

/datum/xeno_ai_movement/linger/lurking/proc/interact_random(mob/living/carbon/xenomorph/X)
	for(var/atom/potential_interaction in orange(1, X))
		if(istype(potential_interaction, /obj/structure/shuttle))
			continue
		if(istype(potential_interaction, /turf/closed/shuttle))
			continue
		if(istype(potential_interaction, /obj/effect))
			continue
		if(istype(potential_interaction, /turf/open))
			continue
		if(!potential_interaction.xeno_ai_act(X))
			continue
		return TRUE
	return FALSE

/datum/xeno_ai_movement/linger/lurking/proc/start_lurking()
	SIGNAL_HANDLER
	if(ai_lurking)
		return

	var/mob/living/carbon/xenomorph/lurking_xeno = parent
	animate(lurking_xeno, alpha = 20, time = 0.5 SECONDS, easing = QUAD_EASING)
	lurking_xeno.set_movement_intent(MOVE_INTENT_WALK)
	register_turf_signals()
	ai_lurking = TRUE

	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(lurking_parent_moved))

	var/datum/action/xeno_action/activable/pounce/lurker/LPA = get_action(lurking_xeno, /datum/action/xeno_action/activable/pounce/lurker)
	if(LPA && istype(LPA))
		LPA.knockdown = TRUE
		LPA.freeze_self = TRUE

	INVOKE_ASYNC(lurking_xeno, TYPE_PROC_REF(/mob, stop_pulling))

/datum/xeno_ai_movement/linger/lurking/proc/stop_lurking()
	SIGNAL_HANDLER
	if(!ai_lurking)
		return

	var/mob/living/carbon/xenomorph/lurking_xeno = parent
	animate(lurking_xeno, alpha = initial(lurking_xeno.alpha), time = 0.2 SECONDS, easing = QUAD_EASING)
	lurking_xeno.set_movement_intent(MOVE_INTENT_RUN)
	unregister_turf_signals()
	ai_lurking = FALSE

	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)

	INVOKE_ASYNC(lurking_xeno, TYPE_PROC_REF(/mob, stop_pulling))

/datum/xeno_ai_movement/linger/lurking/proc/register_turf_signals()
	for(var/turf/open/cycled_open_turf in view(world.view, parent))
		RegisterSignal(cycled_open_turf, COMSIG_TURF_ENTERED, PROC_REF(set_target))
		registered_turfs += cycled_open_turf

		var/mob/living/carbon/human/possible_target = locate() in cycled_open_turf
		if(possible_target && (!parent.current_target || get_dist(parent, possible_target) < get_dist(parent, parent.current_target)) && possible_target.ai_can_target(parent))
			parent.current_target = possible_target

/datum/xeno_ai_movement/linger/lurking/proc/unregister_turf_signals()
	for(var/turf/open/cycled_open_turf in registered_turfs)
		UnregisterSignal(cycled_open_turf, COMSIG_TURF_ENTERED)
	registered_turfs.Cut()

/datum/xeno_ai_movement/linger/lurking/proc/set_target(turf/hooked, atom/movable/entering_atom)
	SIGNAL_HANDLER

	if(!istype(entering_atom, /mob/living/carbon/human))
		return

	var/mob/living/carbon/human/possible_target = entering_atom
	if(!parent.current_target || get_dist(parent, possible_target) < get_dist(parent, parent.current_target) && possible_target.ai_can_target(parent))
		parent.current_target = possible_target

/datum/xeno_ai_movement/linger/lurking/proc/lurking_parent_moved(atom/movable/moving_atom, atom/oldloc, direction, Forced)
	SIGNAL_HANDLER

	unregister_turf_signals()
	register_turf_signals()
