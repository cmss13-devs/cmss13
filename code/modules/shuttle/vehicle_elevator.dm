/obj/docking_port/mobile/vehicle_elevator
	name = "vehicle elevator"
	width = 5
	height = 5
	dwidth = 2
	dheight = 2

	id = MOBILE_SHUTTLE_VEHICLE_ELEVATOR

	// Call and ""ignition"" times are set to line up with the sound effects.
	callTime = 4 SECONDS
	ignitionTime = 5 SECONDS

	ignition_sound = 'sound/machines/asrs_lowering.ogg'
	ambience_idle = null
	ambience_flight = null

	var/list/railings = list()
	var/list/gears = list()

/obj/docking_port/mobile/vehicle_elevator/register()
	. = ..()
	SSshuttle.vehicle_elevator = src
	for(var/obj/structure/machinery/gear/G in GLOB.machines)
		if(G.id == "vehicle_elevator_gears")
			gears += G
	for(var/obj/structure/machinery/door/poddoor/railing/R in GLOB.machines)
		if(R.id == "vehicle_elevator_railing")
			railings += R

/obj/docking_port/mobile/vehicle_elevator/on_ignition()
	. = ..()
	// If the elevator isn't in the vehicle bay, start the gears immediately.
	if(!is_mainship_level(z))
		start_gears()

		// Play the 'raising' sound effect at the destination docking port manually.
		// `landing_sound` can't be used since that only plays on the elevator itself,
		// and this sound file is too long for that either way.
		playsound(destination, 'sound/machines/asrs_raising.ogg', 60)
		return

	// If the elevator *is* in the vehicle bay, close the railings and start the gears when it leaves.
	close_railings()
	addtimer(CALLBACK(src, PROC_REF(start_gears)), ignitionTime)

/obj/docking_port/mobile/vehicle_elevator/afterShuttleMove()
	. = ..()
	// Check `get_docked()` in order to skip this if it just moved to the 'transit' port.
	if(get_docked() == destination)
		stop_gears()

	// If the elevator moved to the vehicle bay, open the railings.
	if(is_mainship_level(z))
		open_railings()

/obj/docking_port/mobile/vehicle_elevator/proc/start_gears()
	for(var/obj/structure/machinery/gear/gear as anything in gears)
		gear.start_moving()

/obj/docking_port/mobile/vehicle_elevator/proc/stop_gears()
	for(var/obj/structure/machinery/gear/gear as anything in gears)
		gear.stop_moving()

/obj/docking_port/mobile/vehicle_elevator/proc/open_railings()
	for(var/obj/structure/machinery/door/poddoor/railing/railing as anything in railings)
		// If the railing isn't already open.
		if(railing.density)
			railing.open()

/obj/docking_port/mobile/vehicle_elevator/proc/close_railings()
	for(var/obj/structure/machinery/door/poddoor/railing/railing as anything in railings)
		// If the railing isn't already closed.
		if(!railing.density)
			railing.close()

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

	//elevator effects (four so the entire elevator doesn't vanish when there's one opaque obstacle between you and the actual elevator loc).
	var/obj/effect/elevator/vehicle/SW
	var/obj/effect/elevator/vehicle/SE
	var/obj/effect/elevator/vehicle/NW
	var/obj/effect/elevator/vehicle/NE

/obj/docking_port/stationary/vehicle_elevator/almayer/Initialize(mapload)
	. = ..()
	// Create and offset some effects for the elevator shaft sprite.
	SW = new(locate(src.x - 2, src.y - 2, src.z))

	SE = new(locate(src.x + 2, src.y - 2, src.z))
	SE.pixel_x = -128

	NW = new(locate(src.x - 2, src.y + 2, src.z))
	NW.pixel_y = -128

	NE = new(locate(src.x + 2, src.y + 2, src.z))
	NE.pixel_x = -128
	NE.pixel_y = -128

	SW.invisibility = INVISIBILITY_ABSTRACT
	SE.invisibility = INVISIBILITY_ABSTRACT
	NW.invisibility = INVISIBILITY_ABSTRACT
	NE.invisibility = INVISIBILITY_ABSTRACT

// Make the elevator shaft visible when the elevator leaves.
/obj/docking_port/stationary/vehicle_elevator/almayer/on_departure(obj/docking_port/mobile/departing_shuttle)
	SW.invisibility = 0
	SE.invisibility = 0
	NW.invisibility = 0
	NE.invisibility = 0

// And make it invisible again when the elevator returns.
/obj/docking_port/stationary/vehicle_elevator/almayer/on_arrival(obj/docking_port/mobile/arriving_shuttle)
	SW.invisibility = INVISIBILITY_ABSTRACT
	SE.invisibility = INVISIBILITY_ABSTRACT
	NW.invisibility = INVISIBILITY_ABSTRACT
	NE.invisibility = INVISIBILITY_ABSTRACT

/obj/docking_port/stationary/vehicle_elevator/adminlevel
	name = "Adminlevel Vehicle Elevator Dock"
	id = "adminlevel vehicle"
