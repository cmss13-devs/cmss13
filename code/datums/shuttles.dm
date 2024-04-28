/datum/map_template/shuttle
	name = "Base Shuttle Template"
	var/prefix = "maps/shuttles/"
	var/suffix
	var/port_id
	var/shuttle_id = "SHOULD NEVER EXIST"

	var/description
	var/prerequisites
	var/admin_notes

	var/list/movement_force // If set, overrides default movement_force on shuttle

	var/port_x_offset
	var/port_y_offset

/datum/map_template/shuttle/proc/prerequisites_met()
	return TRUE

/datum/map_template/shuttle/New()
	if(shuttle_id == "SHOULD NEVER EXIST")
		stack_trace("invalid shuttle datum")
	//shuttle_id = "[port_id]_[suffix]"
	mappath = "[prefix][shuttle_id].dmm"
	return ..()

/datum/map_template/shuttle/preload_size(path, cache)
	. = ..(path, TRUE) // Done this way because we still want to know if someone actualy wanted to cache the map
	if(!cached_map)
		return

	discover_port_offset()

	if(!cache)
		cached_map = null

/datum/map_template/shuttle/proc/discover_port_offset()
	var/key
	var/list/models = cached_map.grid_models
	for(key in models)
		if(findtext(models[key], "[/obj/docking_port/mobile]")) // Yay compile time checks
			break // This works by assuming there will ever only be one mobile dock in a template at most

	for(var/i in cached_map.gridSets)
		var/datum/grid_set/gset = i
		var/ycrd = gset.ycrd
		for(var/line in gset.gridLines)
			var/xcrd = gset.xcrd
			for(var/j in 1 to length(line) step cached_map.key_len)
				if(key == copytext(line, j, j + cached_map.key_len))
					port_x_offset = xcrd
					port_y_offset = ycrd
					return
				++xcrd
			--ycrd

/datum/map_template/shuttle/load(turf/T, centered, register=TRUE)
	. = ..()
	if(!.)
		return
	var/list/turfs = block( locate(.[MAP_MINX], .[MAP_MINY], .[MAP_MINZ]),
							locate(.[MAP_MAXX], .[MAP_MAXY], .[MAP_MAXZ]))
	for(var/i in 1 to turfs.len)
		var/turf/place = turfs[i]

		// ================== CM Change ==================
		// We perform atom initialization of the docking_ports BEFORE skipping space,
		// because our lifeboats have their corners as object props and still
		// reside on space turfs. Notably the bottom left corner, which also contains
		// the docking port.

		for(var/obj/docking_port/mobile/port in place)
			SSatoms.InitializeAtoms(list(port))
			if(register)
				port.register()

		if(istype(place, /turf/open/space)) // This assumes all shuttles are loaded in a single spot then moved to their real destination.
			continue
		if(length(place.baseturfs) < 2) // Some snowflake shuttle shit
			continue
		place.baseturfs.Insert(3, /turf/baseturf_skipover/shuttle)
		// =============== END CM Change =================

//Whatever special stuff you want
/datum/map_template/shuttle/post_load(obj/docking_port/mobile/M)
	if(movement_force)
		M.movement_force = movement_force.Copy()
	M.linkup(M)



/datum/map_template/shuttle/vehicle
	shuttle_id = MOBILE_SHUTTLE_VEHICLE_ELEVATOR
	name = "Vehicle Elevator"

/datum/map_template/shuttle/trijent_elevator
	name = "Trijent Elevator"
	shuttle_id = MOBILE_TRIJENT_ELEVATOR
	var/elevator_network

/datum/map_template/shuttle/trijent_elevator/A
	elevator_network = "A"

/datum/map_template/shuttle/trijent_elevator/B
	elevator_network = "B"

/datum/map_template/shuttle/trijent_elevator/post_load(obj/docking_port/mobile/M)
	. = ..()
	var/obj/docking_port/mobile/trijent_elevator/elev = M
	elev.elevator_network = elevator_network
	log_debug("Adding network [elevator_network] to [M.id]")
