/obj/docking_port/mobile/trijent_elevator
	name="Elevator"
	id=MOBILE_TRIJENT_ELEVATOR

	// Map information
	height=6
	width=7
	preferred_direction = NORTH
	port_direction = SOUTH

	area_type = /area/shuttle/trijent_shuttle/elevator

	// Shuttle timings
	callTime = 30 SECONDS
	rechargeTime = 30 SECONDS
	ignitionTime = 4 SECONDS
	ambience_flight = 'sound/vehicles/tank_driving.ogg'
	ignition_sound = 'sound/mecha/powerup.ogg'

	movement_force = list("KNOCKDOWN" = 0, "THROW" = 0)
	var/datum/door_controller/aggregate/door_control
	var/elevator_network

/obj/docking_port/mobile/trijent_elevator/Initialize(mapload, ...)
	. = ..()
	door_control = new()
	door_control.label = "elevator"
	for(var/area/shuttle_area in shuttle_areas)
		for(var/obj/structure/machinery/door/door in shuttle_area)
			if(door.abstract_door)
				continue
			door_control.add_door(door, door.id)

/obj/docking_port/mobile/trijent_elevator/Destroy(force, ...)
	. = ..()
	QDEL_NULL(door_control)

/obj/docking_port/mobile/trijent_elevator/beforeShuttleMove(turf/newT, rotation, move_mode, obj/docking_port/mobile/moving_dock)
	. = ..()
	door_control.control_doors("force-lock-launch", "all", force=TRUE)

/obj/docking_port/stationary/trijent_elevator
	dir=NORTH
	width=7
	height=6
	// shutters to clear the area
	var/airlock_area
	var/airlock_exit
	var/elevator_network

/obj/docking_port/stationary/trijent_elevator/proc/get_doors()
	. = list()
	for(var/area/target_area in world)
		if(istype(target_area, airlock_area))
			for(var/obj/structure/machinery/door/door in target_area)
				. += list(door)

/obj/docking_port/stationary/trijent_elevator/on_arrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()
	// open elevator doors
	if(istype(arriving_shuttle, /obj/docking_port/mobile/trijent_elevator))
		var/obj/docking_port/mobile/trijent_elevator/elevator = arriving_shuttle
		elevator.door_control.control_doors("open", airlock_exit)

	// open dock doors
	var/datum/door_controller/single/door_control = new()
	door_control.doors = get_doors()
	door_control.control_doors("open", FALSE, FALSE)
	qdel(door_control)

	playsound(src, 'sound/machines/ping.ogg', 25, 1)
	playsound(arriving_shuttle, 'sound/machines/ping.ogg', 25, 1)

/obj/docking_port/stationary/trijent_elevator/on_departure(obj/docking_port/mobile/departing_shuttle)
	. = ..()
	var/datum/door_controller/single/door_control = new()
	door_control.doors = get_doors()
	door_control.control_doors("force-lock-launch")
	qdel(door_control)

/obj/docking_port/stationary/trijent_elevator/occupied
	name = "occupied"
	id = STAT_TRIJENT_OCCUPIED
	airlock_exit = "west"
	roundstart_template = /datum/map_template/shuttle/trijent_elevator

/obj/docking_port/stationary/trijent_elevator/empty
	name = "empty"
	id = STAT_TRIJENT_EMPTY
	airlock_exit = "west"

/obj/docking_port/stationary/trijent_elevator/lz1
	name="Lz1 Elevator"
	id=STAT_TRIJENT_LZ1
	airlock_area=/area/shuttle/trijent_shuttle/lz1
	airlock_exit="west"
	roundstart_template = /datum/map_template/shuttle/trijent_elevator

/obj/docking_port/stationary/trijent_elevator/lz2
	name="Lz2 Elevator"
	id=STAT_TRIJENT_LZ2
	airlock_area=/area/shuttle/trijent_shuttle/lz2
	airlock_exit="west"

/obj/docking_port/stationary/trijent_elevator/engineering
	name="Engineering Elevator"
	id=STAT_TRIJENT_ENGI
	airlock_area=/area/shuttle/trijent_shuttle/engi
	airlock_exit="east"

/obj/docking_port/stationary/trijent_elevator/omega
	name="Omega Elevator"
	id=STAT_TRIJENT_OMEGA
	airlock_area=/area/shuttle/trijent_shuttle/omega
	airlock_exit="east"

//ice classic
/obj/docking_port/mobile/trijent_elevator/ice_classic
	name = "Ice Classic Elevator (Dorm)"
	id = "ice_classic_shuttle"
	width = 8
	height = 5

/obj/docking_port/mobile/trijent_elevator/ice_classic/north
	name = "Ice Classic Elevator (Lab)"
	id = "ice_classic_shuttle_north"

/obj/docking_port/stationary/trijent_elevator/ice_classic
	width = 8
	height = 5

/obj/docking_port/stationary/trijent_elevator/ice_classic/dorm
	elevator_network = "dorm"
	airlock_exit = "elevator_dorm"

/obj/docking_port/stationary/trijent_elevator/ice_classic/dorm/upper
	name = "Dormitory Upper Floor"
	id = "ice_dorm_upper"
	airlock_area = /area/shuttle/elevator2/ground
	roundstart_template = /datum/map_template/shuttle/trijent_elevator/ice_elevator

/obj/docking_port/stationary/trijent_elevator/ice_classic/dorm/lower
	name = "Dormitory Lower Floor"
	id = "ice_dorm_lower"
	airlock_area = /area/shuttle/elevator2/underground

/obj/docking_port/stationary/trijent_elevator/ice_classic/lab
	elevator_network = "lab"
	airlock_exit = "elevator_lab"

/obj/docking_port/stationary/trijent_elevator/ice_classic/lab/upper
	name = "Laboratory Upper Floor"
	id = "ice_lab_upper"
	airlock_area = /area/shuttle/elevator3/ground
	roundstart_template = /datum/map_template/shuttle/trijent_elevator/ice_elevator/lab

/obj/docking_port/stationary/trijent_elevator/ice_classic/lab/lower
	name = "Laboratory Lower Floor"
	id = "ice_lab_lower"
	airlock_area = /area/shuttle/elevator3/underground
