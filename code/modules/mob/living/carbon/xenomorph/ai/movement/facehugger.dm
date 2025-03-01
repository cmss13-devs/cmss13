/datum/xeno_ai_movement/linger/facehugger
	linger_range = 8
	reengage_interval = (12 SECONDS)

/datum/xeno_ai_movement/linger/facehugger/New(mob/living/carbon/xenomorph/parent)
	. = ..()
	var/turf/current_turf = get_turf(parent)
	if(. != INITIALIZE_HINT_QDEL && (locate(/obj/effect/alien/egg) in current_turf))
		home_turf = current_turf

/datum/xeno_ai_movement/linger/facehugger/ai_move_idle(delta_time)
	var/mob/living/carbon/xenomorph/facehugger/idle_xeno = parent
	if(idle_xeno.throwing)
		return

	if(next_home_search < world.time && (!home_turf || !valid_shelter(home_turf) || get_dist(home_turf, idle_xeno) > max_distance_from_home))
		var/turf/T = get_turf(idle_xeno.loc)
		next_home_search = world.time + home_search_delay
		if(valid_shelter(T))
			home_turf = T
		else
			var/shortest_distance = INFINITY
			for(var/i in RANGE_TURFS(home_locate_range, T))
				var/turf/potential_home = i
				if(valid_shelter(potential_home) && get_dist(idle_xeno, potential_home) < shortest_distance)
					home_turf = potential_home
					shortest_distance = get_dist(idle_xeno, potential_home)

	if(!home_turf)
		return

	if(idle_xeno.move_to_next_turf(home_turf, home_locate_range))
		var/shelter = valid_shelter(home_turf)
		if(get_dist(home_turf, idle_xeno) <= 0 && shelter)
			idle_xeno.climb_in(shelter)
		return
	home_turf = null

/datum/xeno_ai_movement/linger/facehugger/proc/valid_shelter(turf/checked_turf)
	var/mob/living/carbon/xenomorph/carrier/carrier = locate(/mob/living/carbon/xenomorph/carrier) in checked_turf
	if(carrier && carrier.huggers_cur < carrier.huggers_max)
		return carrier
	var/obj/effect/alien/egg/eggy = locate(/obj/effect/alien/egg) in checked_turf
	if(eggy && eggy.status == EGG_BURST)
		return eggy

/datum/xeno_ai_movement/linger/facehugger/ai_move_target(delta_time)
	var/mob/living/carbon/xenomorph/moving_xeno = parent

	if(moving_xeno.action_busy)
		return

	return ..()

/mob/living/carbon/xenomorph/facehugger/proc/climb_in(shelter)
	set waitfor = FALSE

	if(!do_after(src, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC, shelter, INTERRUPT_NONE))
		return

	if(!shelter)
		return

	if(iscarrier(shelter))
		var/mob/living/carbon/xenomorph/carrier/horsey = shelter
		if(horsey.huggers_cur >= horsey.huggers_max)
			return
		visible_message(SPAN_XENOWARNING("[src] crawls onto [horsey]!"))
		horsey.huggers_cur = min(horsey.huggers_max, horsey.huggers_cur + 1)
		horsey.update_hugger_overlays()

	else
		var/obj/effect/alien/egg/eggy = shelter
		if(eggy.status != EGG_BURST)
			return
		visible_message(SPAN_XENOWARNING("[src] crawls back into [eggy]!"))
		eggy.status = EGG_GROWN
		eggy.icon_state = "Egg"
		eggy.deploy_egg_triggers()

	qdel(src)
