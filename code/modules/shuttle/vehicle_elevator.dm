/obj/docking_port/mobile/vehicle_elevator
	name = "vehicle elevator"
	width = 5
	height = 5
	dwidth = 2
	dheight = 2

	id = MOBILE_SHUTTLE_VEHICLE_ELEVATOR

	callTime = 5 SECONDS
	ignitionTime = 1 SECONDS

	ignition_sound = 'sound/machines/asrs_raising.ogg'
	ambience_idle = null
	ambience_flight = null

	var/list/railings = list()
	var/list/gears = list()

/obj/docking_port/mobile/vehicle_elevator/register()
	. = ..()
	SSshuttle.vehicle_elevator = src
	for(var/obj/structure/machinery/gear/G in machines)
		if(G.id == "vehicle_elevator_gears")
			gears += G
	for(var/obj/structure/machinery/door/poddoor/railing/R in machines)
		if(R.id == "vehicle_elevator_railing")
			railings += R

/obj/docking_port/mobile/vehicle_elevator/on_ignition()
	for(var/i in gears)
		var/obj/structure/machinery/gear/G = i
		G.start_moving()

/obj/docking_port/mobile/vehicle_elevator/afterShuttleMove()
	if(!is_mainship_level(z))
		return
	for(var/i in gears)
		var/obj/structure/machinery/gear/G = i
		G.stop_moving()
	for(var/i in railings)
		var/obj/structure/machinery/door/poddoor/railing/R = i
		INVOKE_ASYNC(R, TYPE_PROC_REF(/obj/structure/machinery/door, open))

/obj/docking_port/stationary/vehicle_elevator
	name = "Root Vehicle Elevator Dock"
	id = "root vehicle"
	width = 5
	height = 5
	dwidth = 2
	dheight = 2

/obj/docking_port/stationary/vehicle_elevator/almayer
	name = "Almayer Vehicle Elevator Dock"
	id = "almayer vehicle"
	roundstart_template = /datum/map_template/shuttle/vehicle

/obj/docking_port/stationary/vehicle_elevator/adminlevel
	name = "Adminlevel Vehicle Elevator Dock"
	id = "adminlevel vehicle"
