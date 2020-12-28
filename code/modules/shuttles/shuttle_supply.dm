




/datum/shuttle/ferry/supply
	iselevator = 1
	var/away_location = 1	//the location to hide at while pretending to be in-transit
	var/late_chance = 0
	var/max_late_time = 300
	var/railing_id = "supply_elevator_railing"
	var/gear_id = "supply_elevator_gear"
	var/obj/effect/elevator/supply/SW //elevator effects (four so the entire elevator doesn't vanish when
	var/obj/effect/elevator/supply/SE //there's one opaque obstacle between you and the actual elevator loc).
	var/obj/effect/elevator/supply/NW
	var/obj/effect/elevator/supply/NE
	var/Elevator_x
	var/Elevator_y
	var/Elevator_z
	var/elevator_loc

/datum/shuttle/ferry/supply/proc/pick_loc()
	elevator_loc = SupplyElevator

/datum/shuttle/ferry/supply/New()
	..()
	pick_loc()
	var/turf/SupplyElevatorLoc = get_turf(elevator_loc)
	Elevator_x = SupplyElevatorLoc.x
	Elevator_y = SupplyElevatorLoc.y
	Elevator_z = SupplyElevatorLoc.z
	SW = new /obj/effect/elevator/supply(locate(Elevator_x-2,Elevator_y-2,Elevator_z))
	SE = new /obj/effect/elevator/supply(locate(Elevator_x+2,Elevator_y-2,Elevator_z))
	SE.pixel_x = -128
	NW = new /obj/effect/elevator/supply(locate(Elevator_x-2,Elevator_y+2,Elevator_z))
	NW.pixel_y = -128
	NE = new /obj/effect/elevator/supply(locate(Elevator_x+2,Elevator_y+2,Elevator_z))
	NE.pixel_x = -128
	NE.pixel_y = -128

/datum/shuttle/ferry/supply/short_jump(var/area/origin,var/area/destination)
	if(moving_status != SHUTTLE_IDLE)
		return

	if(isnull(location))
		return

	recharging = 1

	if(!destination)
		destination = get_location_area(!location)
	if(!origin)
		origin = get_location_area(location)

	//it would be cool to play a sound here
	moving_status = SHUTTLE_WARMUP
	spawn(warmup_time)
		if (moving_status == SHUTTLE_IDLE)
			return	//someone cancelled the launch

		if (at_station())
			raise_railings()
			sleep(12)
			if(forbidden_atoms_check())
				//cancel the launch because of forbidden atoms. announce over supply channel?
				moving_status = SHUTTLE_IDLE
				playsound(locate(Elevator_x,Elevator_y,Elevator_z), 'sound/machines/buzz-two.ogg', 50, 0)
				lower_railings()
				return
		else	//at centcom
			supply_controller.buy()

		//We pretend it's a long_jump by making the shuttle stay at centcom for the "in-transit" period.
		var/area/away_area = get_location_area(away_location)
		moving_status = SHUTTLE_INTRANSIT

		//If we are at the away_area then we are just pretending to move, otherwise actually do the move
		if (origin != away_area)
			playsound(locate(Elevator_x,Elevator_y,Elevator_z), 'sound/machines/asrs_lowering.ogg', 50, 0)
			move(origin, away_area)
			lower_elevator_effect()
			start_gears(SOUTH)
			sleep(91)
		else
			playsound(locate(Elevator_x,Elevator_y,Elevator_z), 'sound/machines/asrs_raising.ogg', 50, 0)
			start_gears(NORTH)
			sleep(70)
			raise_elevator_effect()
			sleep(21)
			SW.moveToNullspace()
			SE.moveToNullspace()
			NW.moveToNullspace()
			NE.moveToNullspace()
			move(away_area, destination)

		moving_status = SHUTTLE_IDLE
		stop_gears()

		if (!at_station())	//at centcom
			supply_controller.sell()
		else
			lower_railings()

		spawn(0)
			recharging = 0

// returns 1 if the supply shuttle should be prevented from moving because it contains forbidden atoms
/datum/shuttle/ferry/supply/proc/forbidden_atoms_check()
	if (!at_station())
		return 0	//if badmins want to send mobs or a nuke on the supply shuttle from centcom we don't care

	return supply_controller.forbidden_atoms_check(get_location_area())

/datum/shuttle/ferry/supply/proc/at_station()
	return (!location)

//returns 1 if the shuttle is idle and we can still mess with the cargo shopping list
/datum/shuttle/ferry/supply/proc/idle()
	return (moving_status == SHUTTLE_IDLE)

//returns the ETA in minutes
/datum/shuttle/ferry/supply/proc/eta_minutes()
	var/ticksleft = arrive_time - world.time
	return round(ticksleft/MINUTES_1,1)

/datum/shuttle/ferry/supply/proc/raise_railings()
	var/effective = 0
	for(var/obj/structure/machinery/door/poddoor/M in machines)
		if(M.id == railing_id && !M.density)
			effective = 1
			spawn()
				M.close()
	if(effective)
		playsound(locate(Elevator_x,Elevator_y,Elevator_z), 'sound/machines/elevator_openclose.ogg', 50, 0)

/datum/shuttle/ferry/supply/proc/lower_railings()
	var/effective = 0
	for(var/obj/structure/machinery/door/poddoor/M in machines)
		if(M.id == railing_id && M.density)
			effective = 1
			INVOKE_ASYNC(M, /obj/structure/machinery/door.proc/open)
	if(effective)
		playsound(locate(Elevator_x,Elevator_y,Elevator_z), 'sound/machines/elevator_openclose.ogg', 50, 0)

/datum/shuttle/ferry/supply/proc/lower_elevator_effect()
	SW.forceMove(locate(Elevator_x-2,Elevator_y-2,Elevator_z))
	SE.forceMove(locate(Elevator_x+2,Elevator_y-2,Elevator_z))
	NW.forceMove(locate(Elevator_x-2,Elevator_y+2,Elevator_z))
	NE.forceMove(locate(Elevator_x+2,Elevator_y+2,Elevator_z))
	flick("supply_elevator_lowering", SW)
	flick("supply_elevator_lowering", SE)
	flick("supply_elevator_lowering", NW)
	flick("supply_elevator_lowering", NE)
	SW.icon_state = "supply_elevator_lowered"
	SE.icon_state = "supply_elevator_lowered"
	NW.icon_state = "supply_elevator_lowered"
	NE.icon_state = "supply_elevator_lowered"

/datum/shuttle/ferry/supply/proc/raise_elevator_effect()
	flick("supply_elevator_raising", SW)
	flick("supply_elevator_raising", SE)
	flick("supply_elevator_raising", NW)
	flick("supply_elevator_raising", NE)
	SW.icon_state = "supply_elevator_raised"
	SE.icon_state = "supply_elevator_raised"
	NW.icon_state = "supply_elevator_raised"
	NE.icon_state = "supply_elevator_raised"

/datum/shuttle/ferry/supply/proc/start_gears(var/direction = 1)
	for(var/obj/structure/machinery/gear/M in machines)
		if(M.id == gear_id)
			spawn()
				M.icon_state = "gear_moving"
				M.dir = direction

/datum/shuttle/ferry/supply/proc/stop_gears()
	for(var/obj/structure/machinery/gear/M in machines)
		if(M.id == gear_id)
			spawn()
				M.icon_state = "gear"

/datum/shuttle/ferry/supply/vehicle
	railing_id = "vehicle_elevator_railing"
	gear_id = "vehicle_elevator_gears"

/datum/shuttle/ferry/supply/vehicle/pick_loc()
	elevator_loc = VehicleElevator
