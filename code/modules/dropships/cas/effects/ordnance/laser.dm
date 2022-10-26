/datum/cas_effect/ordnance/laser/fire()
	var/list/turf_list = list()
	for(var/turf/T in range(target, 3)) //This is its area of effect
		turf_list += T
	playsound(target, 'sound/effects/pred_vision.ogg', 20, 1)
	for(var/i=1 to 16) //This is how many tiles within that area of effect will be randomly ignited
		var/turf/U = pick(turf_list)
		turf_list -= U
		laser_burn(U)
	qdel(src)

/datum/cas_effect/ordnance/laser/proc/laser_burn(turf/T)
	fire_spread_recur(T, create_cause_data(initial(name), source_mob), 1, null, 5, 75, "#EE6515")//Very, very intense, but goes out very quick
