/proc/get_step_multiz(ref, dir)
	if(dir & UP)
		dir &= ~UP
		return get_step(SSmapping.get_turf_above(get_turf(ref)), dir)
	if(dir & DOWN)
		dir &= ~DOWN
		return get_step(SSmapping.get_turf_below(get_turf(ref)), dir)
	return get_step(ref, dir)

/proc/get_dir_multiz(turf/us, turf/them)
	us = get_turf(us)
	them = get_turf(them)
	if(!us || !them)
		return NONE
	if(us.z == them.z)
		return get_dir(us, them)
	else
		var/turf/T = get_step_multiz(us, UP)
		var/dir = NONE
		if(T && (T.z == them.z))
			dir = UP
		else
			T = get_step_multiz(us, DOWN)
			if(T && (T.z == them.z))
				dir = DOWN
			else
				return get_dir(us, them)
		return (dir | get_dir(us, them))

/proc/get_lowest_turf(turf/us)
	var/next = SSmapping.get_turf_below(us)
	while(next)
		us = next
		next = SSmapping.get_turf_below(us)
	return us

// I wish this was lisp
/proc/get_highest_turf(turf/us)
	var/next = SSmapping.get_turf_above(us)
	while(next)
		us = next
		next = SSmapping.get_turf_above(us)
	return us
