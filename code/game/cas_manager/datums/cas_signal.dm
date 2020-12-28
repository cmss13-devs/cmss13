/datum/cas_signal
	var/signal_loc
	var/name = "Unknown Electronic Signal"
	var/target_id = 0
	var/obj/structure/machinery/camera/linked_cam
	var/z_initial

/datum/cas_signal/New(location)
	z_initial = z_descend(location)
	signal_loc = location

/datum/cas_signal/Destroy()
	QDEL_NULL(linked_cam)
	. = ..()

/datum/cas_signal/proc/get_name()
	var/area/laser_area = get_area(signal_loc)
	var/obstructed = obstructed_signal()?"OBSTRUCTED":""
	if(laser_area)
		return "[name] ([laser_area.name]) [obstructed]"
	return "[name] [obstructed]"

//prevents signal from being triggered from pockets. It has to be on turf
/datum/cas_signal/proc/valid_signal()
	var/obj/object = signal_loc
	var/area/laser_area = get_area(signal_loc)
	var/new_z = z_descend(signal_loc)
	return istype(object) && istype(object.loc,/turf/) && istype(laser_area) && laser_area.ceiling <CEILING_DEEP_UNDERGROUND_METAL  && new_z == z_initial

/datum/cas_signal/proc/obstructed_signal()
	var/area/laser_area = get_area(signal_loc)
	return !istype(laser_area) || laser_area.ceiling > CEILING_METAL

/proc/z_descend(loc)
	var/sloc = loc
	while(sloc && !sloc:z)
		sloc = sloc:loc
	if(!sloc)
		return null
	return sloc:z