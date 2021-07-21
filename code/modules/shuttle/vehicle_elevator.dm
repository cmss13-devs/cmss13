/obj/docking_port/mobile/vehicle_elevator
	name = "vehicle elevator"
	width = 5
	height = 5
	dwidth = 2
	dheight = 2

	callTime = 5 SECONDS
	ignitionTime = 1 SECONDS

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
		INVOKE_ASYNC(R, /obj/structure/machinery/door.proc/open)

/obj/docking_port/stationary/vehicle_elevator
	name = "Alamyer Vehicle Elevator Dock"
	id = "almayer vehicle"
	width = 5
	height = 5
	dwidth = 2
	dheight = 2

/obj/docking_port/stationary/vehicle_elevator/adminlevel
	name = "Adminlevel Vehicle Elevator Dock"
	id = "adminlevel vehicle"
	roundstart_template = /datum/map_template/shuttle/vehicle
