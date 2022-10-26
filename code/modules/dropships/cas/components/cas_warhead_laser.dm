/datum/component/cas_warhead_laser/Initialize()
	RegisterSignal(parent, COMSIG_CAS_SOLUTION_IMPACT, .proc/boom)

/datum/component/cas_warhead_laser/proc/boom
	SIGNAL_HANLDER
	var/list/turf_list = list()
	for(var/turf/T in range(target, 3)) //This is its area of effect
		turf_list += T
	playsound(target, 'sound/effects/pred_vision.ogg', 20, 1)
	for(var/i=1 to 16) //This is how many tiles within that area of effect will be randomly ignited
		var/turf/U = pick(turf_list)
		turf_list -= U
		laser_burn(U)
	qdel(src)

/datum/component/cas_warhead_laser/proc/laser_burn(turf/T)
	var/datum/cas_firing_solution/FS = parent
	fire_spread_recur(T, create_cause_data(initial(FS.name), FS.source_mob), 1, null, 5, 75, "#EE6515")//Very, very intense, but goes out very quick
