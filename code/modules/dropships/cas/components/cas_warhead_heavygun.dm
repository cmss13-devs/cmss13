/// GAU-21 Classic Impact effect:
///  a stationary rain of autocannon shells
/datum/component/cas_warhead_heavygun
	/// Shells left in salvo
	var/shells
	/// Range around which the shells are to land
	var/bullet_spread_range
	/// Sharpnel embedded in hit mobs
	var/shrapnel_type

	// Runtime Data
	var/time_counter = 0
	var/turf/locked_target

/datum/component/cas_warhead_heavygun/Initialize(shells = 40, bullet_spread_range = 4, shrapnel_type = /datum/ammo/bullet/shrapnel/gau)
	if(!istype(parent, /datum/cas_firing_solution))
		return COMPONENT_INCOMPATIBLE
	src.shells = shells
	src.bullet_spread_range = bullet_spread_range
	src.shrapnel_type = sharpnel_type
	RegisterSignal(parent, COMSIG_CAS_SOLUTION_IMPACT, .proc/prime)
	RegisterSignal(parent, COMSIG_CAS_SOLUTION_PROCESS, .proc/hold)

/datum/component/cas_warhead_heavygun/proc/prime(source, atom/target)
	SIGNAL_HANDLER
	locked_target = get_turf(target)

/datum/component/cas_warhead_heavygun/proc/hold(source)
	if(locked_target && shells)
		return COMPONENT_CAS_SOLUTION_PROCESSING

/datum/component/cas_warhead_heavygun/process(delta_time)
	if(!locked_target)
		return
	time_counter += delta_time * 10
	var/list/turf/turf_list = RANGE_TURFS(bullet_spread_range, locked_target)
	while(time_counter >= 1 && shells >= 1)
		shells--
		time_counter--
		shell_explosion(pick(turf_list))
	if(shells >= 1)
		return
	if(time_counter > 1 SECONDS) // one second after end, supersonic bang
		playsound(locked_target, 'sound/effects/gau.ogg',100,1,60)
		qdel(src)
		return PROCESS_KILL

/datum/component/cas_warhead_heavygun/proc/shell_explosion(turf/T)
	var/datum/cause_data/cause_data = create_cause_data(initial(name), source_mob)
	T.ex_act(EXPLOSION_THRESHOLD_VLOW, pick(alldirs), cause_data)
	create_shrapnel(T, 1, 0, 0, shrapnel_type, cause_data, FALSE, 100) //simulates a bullet
	for(var/atom/movable/AM as anything in T)
		if(iscarbon(AM))
			AM.ex_act(EXPLOSION_THRESHOLD_VLOW, null, cause_data)
		else
			AM.ex_act(EXPLOSION_THRESHOLD_VLOW)
	if(shells % 3 == 0)
		playsound(T, 'sound/effects/gauimpact.ogg',40,1,20)
	if(shells % 6 == 0)
		T.ceiling_debris_check(1)
	new /obj/effect/particle_effect/expl_particles(T)
