/obj/docking_port/mobile/trijent_elevator
	name="Elevator"
	id=MOBILE_TRIJENT_ELEVATOR
	preferred_direction = NORTH
	port_direction = SOUTH
	area_type = /area/shuttle/trijent_shuttle
	width=7
	height=6

/obj/docking_port/stationary/trijent_elevator
	preferred_direction = NORTH
	port_direction = SOUTH
	width=7
	height=6
	// shutters to clear the area
	var/datum/door_controller/single/cont
	var/shutter_dir

/obj/docking_port/stationary/trijent_elevator/Initialize(mapload)
	. = ..()
	cont = new()
	for(var/place in shuttle_areas)
		for(var/obj/structure/machinery/door/air in place)


/obj/docking_port/stationary/trijent_elevator/lz1
	name="Lz1 Elevator"
	id=STAT_TRIJENT_LZ1
	shutter_dir=WEST

/obj/docking_port/stationary/trijent_elevator/lz2
	name="Lz2 Elevator"
	id=STAT_TRIJENT_LZ2
	shutter_dir=WEST

/obj/docking_port/stationary/trijent_elevator/engineering
	name="Engineering Elevator"
	id=STAT_TRIJENT_ENGI
	shutter_dir=EAST

/obj/docking_port/stationary/trijent_elevator/omega
	name="Omega Elevator"
	id=STAT_TRIJENT_OMEGA
	shutter_dir=EAST
