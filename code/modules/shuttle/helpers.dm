/**
 *	Datum containing methods to allow for the control over multiple door groups.
 */
/datum/door_controller/aggregate
	var/label = "dropship"
	var/list/door_controllers = list()
	var/allow_multicast = TRUE

/datum/door_controller/aggregate/Destroy(force, ...)
	. = ..()
	QDEL_LIST_ASSOC_VAL(door_controllers)
	door_controllers = null

/datum/door_controller/aggregate/proc/set_label(label)
	for(var/datum/door_controller/single/cont in door_controllers)
		cont.label = label

/datum/door_controller/aggregate/proc/add_door(door, direction)
	if(!door_controllers[direction])
		var/datum/door_controller/single/new_controller = new()
		new_controller.label = label
		new_controller.status = SHUTTLE_DOOR_UNLOCKED
		door_controllers[direction] = new_controller

	var/datum/door_controller/single/controller = door_controllers[direction]
	controller.doors += list(door)

/datum/door_controller/aggregate/proc/is_door_locked(direction)
	if(direction == "all")
		for(var/i in door_controllers)
			var/datum/door_controller/single/control = door_controllers[i]
			if(control.status != SHUTTLE_DOOR_LOCKED)
				return FALSE
		return TRUE
	if(door_controllers[direction])
		var/datum/door_controller/single/single_controller = door_controllers[direction]
		return single_controller.status == SHUTTLE_DOOR_LOCKED
	else
		WARNING("Direction [direction] does not exist.")
	return FALSE

/datum/door_controller/aggregate/proc/control_doors(action, direction, force, asynchronous = TRUE)
	if(direction == "all")
		if(allow_multicast)
			for(var/door_group in door_controllers)
				var/datum/door_controller/single/controller = door_controllers[door_group]
				controller.control_doors(action, force, asynchronous)
			return
		else
			WARNING("Aggregate door controller does not support multicast.")
	if(door_controllers[direction])
		var/datum/door_controller/single/controller = door_controllers[direction]
		controller.control_doors(action, force)
	else
		WARNING("Door group [direction] does not exist.")

/datum/door_controller/aggregate/proc/get_data()
	. = list()
	var/all_locked = TRUE

	for(var/direction in door_controllers)
		var/datum/door_controller/single/controller = door_controllers[direction]
		var/list/door_data = list("id" = direction, "value" = controller.status)
		. += list(door_data)
		if(controller.status == SHUTTLE_DOOR_UNLOCKED)
			all_locked = FALSE

	var/list/door_data = list("id" = "all", "value" = all_locked)
	. += list(door_data)

/**
	Datum containing methods to allow for the control over a single door group.
*/
/datum/door_controller/single
	var/label = "dropship"
	var/list/doors = list()
	var/status = SHUTTLE_DOOR_UNLOCKED

/datum/door_controller/single/Destroy(force, ...)
	. = ..()
	doors = null

/datum/door_controller/single/proc/control_doors(action, force = FALSE, asynchronous = TRUE)
	for(var/D in doors)
		var/obj/structure/machinery/door/door = D
		var/is_external = door.borders_space()
		// do not allow the user to normally control external doors
		if(!force && is_external)
			continue
		switch(action)
			if("open")
				INVOKE_ASYNC(door, TYPE_PROC_REF(/obj/structure/machinery/door/airlock, open))
			if("close")
				INVOKE_ASYNC(door, TYPE_PROC_REF(/obj/structure/machinery/door/airlock, close))
			if("force-lock")
				if (status == SHUTTLE_DOOR_BROKEN)
					continue
				INVOKE_ASYNC(src, PROC_REF(lockdown_door), door)
				status = SHUTTLE_DOOR_LOCKED
			if("lock")
				INVOKE_ASYNC(door, TYPE_PROC_REF(/obj/structure/machinery/door/airlock, lock))
				if (status != SHUTTLE_DOOR_BROKEN)
					status = SHUTTLE_DOOR_LOCKED
			if("unlock")
				INVOKE_ASYNC(door, TYPE_PROC_REF(/obj/structure/machinery/door/airlock, unlock))
				if (status != SHUTTLE_DOOR_BROKEN)
					status = SHUTTLE_DOOR_UNLOCKED
			if("force-lock-launch")
				if(asynchronous)
					INVOKE_ASYNC(src, PROC_REF(lockdown_door_launch), door)
				else
					lockdown_door_launch(door)
				if (status != SHUTTLE_DOOR_BROKEN)
					status = SHUTTLE_DOOR_LOCKED
			if("force-unlock")
				INVOKE_ASYNC(src, PROC_REF(force_lock_open_door), door)
				if (status != SHUTTLE_DOOR_BROKEN)
					status = SHUTTLE_DOOR_UNLOCKED
			else
				CRASH("Unknown door command [action]")

/datum/door_controller/single/proc/lockdown_door_launch(obj/structure/machinery/door/door)
	for(var/turf/door_turf in door.locs)
		bump_at_turf(door_turf, door)

	lockdown_door(door)

/datum/door_controller/single/proc/bump_at_turf(turf/door_turf, obj/structure/machinery/door/door)
	// Find somewhere valid to push towards (non-shuttle turf)
	var/turf/target_turf
	for(var/turf/current_turf in orange(1, door_turf))
		if(istype(current_turf, /turf/open/shuttle))
			continue
		if(istype(current_turf, /turf/closed/shuttle))
			continue
		if(islist(current_turf.baseturfs))
			if(ispath(current_turf.baseturfs[length(current_turf.baseturfs)], /turf/open/shuttle))
				continue
			if(ispath(current_turf.baseturfs[length(current_turf.baseturfs)], /turf/closed/shuttle))
				continue
		if(locate(/obj/structure/shuttle) in current_turf)
			continue
		target_turf = current_turf
		break

	// Push mobs
	for(var/mob/living/blocking_mob in door_turf)
		to_chat(blocking_mob, SPAN_HIGHDANGER("You get thrown back as the [label] doors slam shut!"))
		blocking_mob.KnockDown(4)
		blocking_mob.forceMove(target_turf)

	// Push objects
	for(var/obj/blocking_obj in door_turf)
		if(blocking_obj == door)
			continue
		if(istype(blocking_obj, /obj/effect/alien/weeds))
			continue // No need to push

		// Skip anything that'd just get crushed instead
		if(istype(door, /obj/structure/machinery/door/airlock))
			if(is_type_in_list(blocking_obj, door:resin_smushables)) // Done with : because of https://www.byond.com/forum/post/2954294
				continue

		// Vehicles need a much more specific location to push to
		if(istype(blocking_obj, /obj/vehicle/multitile))
			var/obj/vehicle/multitile/vehicle = blocking_obj
			var/list/vehicle_dimensions = vehicle.get_dimensions()
			var/height = vehicle_dimensions["height"]
			var/width = vehicle_dimensions["width"]
			if(vehicle.dir & (EAST|WEST))
				height = vehicle_dimensions["width"]
				width = vehicle_dimensions["height"]
			var/dir_to_push = get_dir(door_turf, target_turf)
			// half width/height because the vehicle loc is centered
			if(door.dir & (EAST|WEST))
				switch(dir_to_push)
					if(NORTH, NORTHEAST, NORTHWEST)
						target_turf = locate(vehicle.x, door.y + ceil(height*0.5), vehicle.z)
					if(SOUTH, SOUTHEAST, SOUTHWEST)
						target_turf = locate(vehicle.x, door.y - ceil(height*0.5), vehicle.z)
					if(EAST)
						target_turf = locate(door.x + ceil(width*0.5), vehicle.y, vehicle.z)
					else
						target_turf = locate(door.x - ceil(width*0.5), vehicle.y, vehicle.z)
			else // otherwise door opens east/west so favor those directions
				switch(dir_to_push)
					if(NORTH)
						target_turf = locate(vehicle.x, door.y + ceil(height*0.5), vehicle.z)
					if(SOUTH)
						target_turf = locate(vehicle.x, door.y - ceil(height*0.5), vehicle.z)
					if(EAST, NORTHEAST, SOUTHEAST)
						target_turf = locate(door.x + ceil(width*0.5), vehicle.y, vehicle.z)
					else
						target_turf = locate(door.x - ceil(width*0.5), vehicle.y, vehicle.z)

		// Now actually push it
		blocking_obj.forceMove(target_turf)

/datum/door_controller/proc/lockdown_door(obj/structure/machinery/door/target)
	if(istype(target, /obj/structure/machinery/door/airlock))
		var/obj/structure/machinery/door/airlock/air = target
		var/old_safe = air.safe
		air.safe = FALSE
		air.unlock(TRUE)
		air.close(TRUE)
		air.lock(TRUE)
		air.safe = old_safe
		return

	if(istype(target, /obj/structure/machinery/door/poddoor))
		target.close()

/datum/door_controller/proc/force_lock_open_door(obj/structure/machinery/door/target)
	if(istype(target, /obj/structure/machinery/door/airlock))
		var/obj/structure/machinery/door/airlock/air = target
		var/old_safe = air.safe
		air.safe = FALSE
		air.unlock(TRUE)
		air.open(TRUE)
		air.lock(TRUE)
		air.safe = old_safe
		return

	if(istype(target, /obj/structure/machinery/door/poddoor))
		target.open()

