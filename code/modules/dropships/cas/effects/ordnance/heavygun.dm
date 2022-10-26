/// GAU-21 Classic Impact effect:
///  a stationary rain of autocannon shells
/datum/cas_effect/ordnance/heavygun
	// Behavior Config
	/// Shells left in salvo
	var/shells = 40
	/// Range around which the shells are to land
	var/bullet_spread_range = 4
	/// Sharpnel embedded in hit mobs
	var/shrapnel_type = /datum/ammo/bullet/shrapnel/gau

	// Runtime Data
	var/time_counter = 0

/datum/cas_effect/ordnance/heavygun/process(delta_time)
	time_counter += delta_time * 10
	var/list/turf/turf_list = RANGE_TURFS(bullet_spread_range, target)
	while(time_counter >= 1 && shells >= 1)
		shells--
		time_counter--
		shell_explosion(pick(turf_list))
	if(shells >= 1)
		return
	if(time_counter > 1 SECONDS) // one second after end, supersonic bang
		playsound(target, 'sound/effects/gau.ogg',100,1,60)
		qdel(src)
		return PROCESS_KILL

/datum/cas_effect/ordnance/heavygun/proc/shell_explosion(turf/T)
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

/datum/cas_effect/ordnance/heavygun/antitank
	shrapnel_type = /datum/ammo/bullet/shrapnel/gau/at
