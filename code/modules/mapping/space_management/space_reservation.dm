
//Yes, they can only be rectangular.
//Yes, I'm sorry.
/datum/turf_reservation
	var/list/reserved_turfs = list()
	var/width = 0
	var/height = 0
	var/bottom_left_coords[3]
	var/top_right_coords[3]
	var/wipe_reservation_on_release = TRUE
	var/turf_type = /turf/open/space

/datum/turf_reservation/transit
	turf_type = /turf/open/space/transit

/datum/turf_reservation/interior
	turf_type = /turf/open/void/vehicle

/datum/turf_reservation/proc/Release()
	var/v = reserved_turfs.Copy()
	for(var/i in reserved_turfs)
		var/turf/T = i
		T.flags_atom |= UNUSED_RESERVATION_TURF
		reserved_turfs -= i
		SSmapping.used_turfs -= i
	SSmapping.reserve_turfs(v)

/datum/turf_reservation/proc/Reserve(width, height, zlevel)
	if(width > world.maxx || height > world.maxy || width < 1 || height < 1)
		log_debug("turf reservation had invalid dimensions")
		return FALSE
	var/list/avail = SSmapping.unused_turfs["[zlevel]"]
	var/turf/bottom_left
	var/turf/top_right
	var/list/turf/final = list()
	var/passing = FALSE
	for(var/i in avail)
		CHECK_TICK
		bottom_left = i
		if(!(bottom_left.flags_atom & UNUSED_RESERVATION_TURF))
			continue
		if(bottom_left.x + width > world.maxx || bottom_left.y + height > world.maxy)
			continue
		top_right = locate(bottom_left.x + width - 1, bottom_left.y + height - 1, bottom_left.z)
		if(!(top_right.flags_atom & UNUSED_RESERVATION_TURF))
			continue
		final = block(bottom_left, top_right)
		if(!final)
			continue
		passing = TRUE
		for(var/turf/checking as anything in final)
			if(!(checking.flags_atom & UNUSED_RESERVATION_TURF))
				passing = FALSE
				break
		if(!passing)
			continue
		break
	if(!passing || !istype(bottom_left) || !istype(top_right))
		log_debug("failed to pass reservation tests, [passing], [istype(bottom_left)], [istype(top_right)]")
		return FALSE
	bottom_left_coords = list(bottom_left.x, bottom_left.y, bottom_left.z)
	top_right_coords = list(top_right.x, top_right.y, top_right.z)
	var/weakref = WEAKREF(src)
	for(var/i in final)
		var/turf/T = i
		reserved_turfs |= T
		SSmapping.unused_turfs["[T.z]"] -= T
		SSmapping.used_turfs[T] = weakref
		T = T.ChangeTurf(turf_type, turf_type)
		T.flags_atom &= ~UNUSED_RESERVATION_TURF
	src.width = width
	src.height = height
	return TRUE

/datum/turf_reservation/New()
	LAZYADD(SSmapping.turf_reservations, src)

/datum/turf_reservation/Destroy()
	INVOKE_ASYNC(src, PROC_REF(Release))
	LAZYREMOVE(SSmapping.turf_reservations, src)
	return ..()
