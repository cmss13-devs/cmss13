/datum/cas_signal
	var/loc
	var/name = "Unknown Electronic Signal"
	var/target_id = 0
	var/obj/machinery/camera/linked_cam

/datum/cas_signal/proc/get_name()
	var/area/laser_area = get_area(loc)
	var/obstructed = obstructed_signal()?"OBSTRUCTED":""
	if(laser_area)
		return "[name] ([laser_area.name]) [obstructed]"
	return "[name] [obstructed]"

//prevents signal from being triggered from pockets. It has to be on turf
/datum/cas_signal/proc/valid_signal()
	var/obj/object = loc
	var/area/laser_area = get_area(loc)
	return istype(object) && istype(object.loc,/turf/) && istype(laser_area) && laser_area.ceiling <CEILING_DEEP_UNDERGROUND_METAL 

/datum/cas_signal/proc/obstructed_signal()
	var/area/laser_area = get_area(loc)
	return !istype(laser_area) || laser_area.ceiling > CEILING_METAL
