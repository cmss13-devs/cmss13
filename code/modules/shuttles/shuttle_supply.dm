/obj/effect/landmark/supply_elevator/Initialize(mapload, ...)
	. = ..()
	GLOB.supply_elevator = get_turf(src)
	return INITIALIZE_HINT_QDEL

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
	///Used to mirrors the turfs (and their contents) on the elevator when raising/lowering, so they don't instantly teleport or vanish.
	var/obj/effect/elevator/animation_overlay/elevator_animation

/datum/shuttle/ferry/supply/proc/pick_loc()
	RETURN_TYPE(/turf)
	return GLOB.supply_elevator

/datum/shuttle/ferry/supply/New()
	..()
	elevator_animation = new()
	elevator_animation.pixel_x = 160 //Matches the slope on the sprite.
	elevator_animation.pixel_y = -80
	if(pick_loc())
		Elevator_x = pick_loc().x
		Elevator_y = pick_loc().y
		Elevator_z = pick_loc().z
		SW = new /obj/effect/elevator/supply(locate(Elevator_x-2,Elevator_y-2,Elevator_z))
		SW.vis_contents += elevator_animation
		SE = new /obj/effect/elevator/supply(locate(Elevator_x+2,Elevator_y-2,Elevator_z))
		SE.pixel_x = -128
		SE.vis_contents += elevator_animation
		NW = new /obj/effect/elevator/supply(locate(Elevator_x-2,Elevator_y+2,Elevator_z))
		NW.pixel_y = -128
		NW.vis_contents += elevator_animation
		NE = new /obj/effect/elevator/supply(locate(Elevator_x+2,Elevator_y+2,Elevator_z))
		NE.pixel_x = -128
		NE.pixel_y = -128
		NE.vis_contents += elevator_animation

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

		/*We attach the turfs in our starting area to the vis_contents overlay. The elevator effect procs will animate this. If we're going down, the stuff will instantly be
		teleported and then cosmetically animated as lowering; otherwise, it will be animated as raising, then teleported afterwards. Either way, it's all on the admin level.*/
		for(var/turf/T in away_area)
			elevator_animation.vis_contents += T

		//If we are at the away_area then we are just pretending to move, otherwise actually do the move
		if (origin != away_area)
			playsound(locate(Elevator_x,Elevator_y,Elevator_z), 'sound/machines/asrs_lowering.ogg', 50, 0)
			move(origin, away_area)
			SW.forceMove(locate(Elevator_x-2,Elevator_y-2,Elevator_z))
			SE.forceMove(locate(Elevator_x+2,Elevator_y-2,Elevator_z))
			NW.forceMove(locate(Elevator_x-2,Elevator_y+2,Elevator_z))
			NE.forceMove(locate(Elevator_x+2,Elevator_y+2,Elevator_z))
			animate(elevator_animation, pixel_x = 160, pixel_y = -80, time = 2 SECONDS)
			start_gears(SOUTH)
			sleep(91)
		else
			playsound(locate(Elevator_x,Elevator_y,Elevator_z), 'sound/machines/asrs_raising.ogg', 50, 0)
			start_gears(NORTH)
			sleep(70)
			animate(elevator_animation, pixel_x = 0, pixel_y = 0, time = 2 SECONDS)
			sleep(2 SECONDS)
			SW.moveToNullspace()
			SE.moveToNullspace()
			NW.moveToNullspace()
			NE.moveToNullspace()
			move(away_area, destination)

		moving_status = SHUTTLE_IDLE
		stop_gears()
		elevator_animation.vis_contents.Cut()

		if (!at_station())	//at centcom
			handle_sell()
		else
			lower_railings()

		spawn(0)
			recharging = 0

/datum/shuttle/ferry/supply/proc/handle_sell()
	supply_controller.sell()

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

/datum/shuttle/ferry/supply/proc/start_gears(var/direction = 1)
	for(var/obj/structure/machinery/gear/M in machines)
		if(M.id == gear_id)
			spawn()
				M.icon_state = "gear_moving"
				M.setDir(direction)

/datum/shuttle/ferry/supply/proc/stop_gears()
	for(var/obj/structure/machinery/gear/M in machines)
		if(M.id == gear_id)
			spawn()
				M.icon_state = "gear"

/obj/effect/landmark/vehicleelevator/Initialize(mapload, ...)
	. = ..()
	GLOB.vehicle_elevator = get_turf(src)
	return INITIALIZE_HINT_QDEL

/datum/shuttle/ferry/supply/vehicle
	railing_id = "vehicle_elevator_railing"
	gear_id = "vehicle_elevator_gears"

/datum/shuttle/ferry/supply/vehicle/pick_loc()
	return GLOB.vehicle_elevator
