#define CONTROL_POD_DOORS 0
#define CONTROL_NORMAL_DOORS 1
#define CONTROL_EMITTERS 2
#define CONTROL_DROPSHIP 3

/obj/structure/machinery/door_control
	name = "remote door-control"
	desc = "It controls doors, remotely."
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "doorctrl"
	desc = "A remote control-switch for a door."
	power_channel = POWER_CHANNEL_ENVIRON
	unslashable = TRUE
	unacidable = TRUE
	var/id = null
	var/range = 10
	var/normaldoorcontrol = CONTROL_POD_DOORS
	var/desiredstate = 0 // Zero is closed, 1 is open.
	var/specialfunctions = 1
	/*
	Bitflag, 	1= open
				2= idscan,
				4= bolts
				8= shock
				16= door safties

	*/

	var/exposedwires = 0
	var/wires = 3
	/*
	Bitflag,	1=checkID
				2=Network Access
	*/

	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4

	appearance_flags = TILE_BOUND

/obj/structure/machinery/door_control/attack_remote(mob/user as mob)
	if(wires & 2)
		return src.attack_hand(user)
	else
		to_chat(user, "Error, no route to host.")

/obj/structure/machinery/door_control/attack_alien(mob/user as mob)
	return

/obj/structure/machinery/door_control/attackby(obj/item/W, mob/user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/door_control/proc/handle_dropship(var/ship_id)
	var/shuttle_tag
	switch(ship_id)
		if("sh_dropship1")
			shuttle_tag = "[MAIN_SHIP_NAME] Dropship 1"
		if("sh_dropship2")
			shuttle_tag = "[MAIN_SHIP_NAME] Dropship 2"
		if("gr_transport1")
			shuttle_tag = "Ground Transport 1"
	if(!shuttle_tag)
		return
	var/datum/shuttle/ferry/shuttle = shuttle_controller.shuttles[shuttle_tag]
	if (!istype(shuttle))
		return
	if(shuttle.door_override)
		return // its been locked down by the queen
	if(z == 3) // on the almayer
		return
	for(var/obj/structure/machinery/door/airlock/dropship_hatch/M in machines)
		if(M.id == ship_id)
			if(M.locked && M.density)
				continue // jobs done
			else if(!M.locked && M.density)
				M.lock() // closed but not locked yet
				continue
			else
				M.do_command("secure_close")

	var/obj/structure/machinery/door/airlock/multi_tile/almayer/reardoor
	switch(ship_id)
		if("sh_dropship1")
			for(var/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/ds1/D in machines)
				reardoor = D
		if("sh_dropship2")
			for(var/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/ds2/D in machines)
				reardoor = D

	if(!reardoor.locked && reardoor.density)
		reardoor.lock() // closed but not locked yet
	else if(reardoor.locked && !reardoor.density)
		spawn()
			reardoor.unlock()
			sleep(1)
			reardoor.close()
			sleep(reardoor.openspeed + 1) // let it close
			reardoor.lock() // THEN lock it
	else
		spawn()
			reardoor.close()
			sleep(reardoor.openspeed + 1)
			reardoor.lock()

/obj/structure/machinery/door_control/proc/handle_door()
	for(var/obj/structure/machinery/door/airlock/D in range(range))
		if(D.id_tag == src.id)
			if(specialfunctions & OPEN)
				if (D.density)
					INVOKE_ASYNC(D, /obj/structure/machinery/door.proc/open)
				else
					INVOKE_ASYNC(D, /obj/structure/machinery/door.proc/close)
			if(desiredstate == 1)
				if(specialfunctions & IDSCAN)
					D.remoteDisabledIdScanner = 1
				if(specialfunctions & BOLTS)
					D.lock()
				if(specialfunctions & SHOCK)
					D.secondsElectrified = -1
				if(specialfunctions & SAFE)
					D.safe = 0
			else
				if(specialfunctions & IDSCAN)
					D.remoteDisabledIdScanner = 0
				if(specialfunctions & BOLTS)
					if(!D.isWireCut(4) && D.arePowerSystemsOn())
						D.unlock()
				if(specialfunctions & SHOCK)
					D.secondsElectrified = 0
				if(specialfunctions & SAFE)
					D.safe = 1

/obj/structure/machinery/door_control/proc/handle_pod()
	for(var/obj/structure/machinery/door/poddoor/M in machines)
		if(M.id == id)
			var/datum/shuttle/ferry/marine/S
			var/area/A = get_area(M)
			for(var/i = 1 to 2)
				if(istype(A, text2path("/area/shuttle/drop[i]")))
					S = shuttle_controller.shuttles["[MAIN_SHIP_NAME] Dropship [i]"]
					if(S.moving_status == SHUTTLE_INTRANSIT)
						return FALSE
			if(M.density)
				INVOKE_ASYNC(M, /obj/structure/machinery/door.proc/open)
			else
				INVOKE_ASYNC(M, /obj/structure/machinery/door.proc/close)

/obj/structure/machinery/door_control/verb/push_button()
	set name = "Push Button"
	set category = "Object"
	if(isliving(usr))
		var/mob/living/L = usr
		attack_hand(L)

/obj/structure/machinery/door_control/attack_hand(mob/living/user)
	add_fingerprint(user)
	if(istype(user,/mob/living/carbon/Xenomorph))
		return
	use_button(user)

/obj/structure/machinery/door_control/proc/use_button(mob/living/user, var/force = FALSE)
	if(inoperable())
		to_chat(user, SPAN_WARNING("[src] doesn't seem to be working."))
		return

	if(!allowed(user) && (wires & 1) && !force )
		to_chat(user, SPAN_DANGER("Access Denied"))
		flick(initial(icon_state) + "-denied",src)
		return

	use_power(5)
	icon_state = initial(icon_state) + "1"
	add_fingerprint(user)

	switch(normaldoorcontrol)
		if(CONTROL_NORMAL_DOORS)
			handle_door()
		if(CONTROL_POD_DOORS)
			handle_pod()
		if(CONTROL_DROPSHIP)
			handle_dropship(id)

	desiredstate = !desiredstate
	spawn(15)
		if(!(stat & NOPOWER))
			icon_state = initial(icon_state) + "0"

/obj/structure/machinery/door_control/power_change()
	..()
	if(stat & NOPOWER)
		icon_state = initial(icon_state) + "-p"
	else
		icon_state = initial(icon_state) + "0"

/obj/structure/machinery/driver_button/attack_remote(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/driver_button/attackby(obj/item/W, mob/user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/driver_button/attack_hand(mob/user as mob)

	src.add_fingerprint(usr)
	if(inoperable())
		return
	if(active)
		return
	add_fingerprint(user)

	use_power(5)

	active = 1
	icon_state = "launcheract"

	for(var/obj/structure/machinery/door/poddoor/M in machines)
		if(M.id == src.id)
			INVOKE_ASYNC(M, /obj/structure/machinery/door.proc/open)

	sleep(20)

	for(var/obj/structure/machinery/mass_driver/M in machines)
		if(M.id == src.id)
			M.drive()

	sleep(50)

	for(var/obj/structure/machinery/door/poddoor/M in machines)
		if(M.id == src.id)
			INVOKE_ASYNC(M, /obj/structure/machinery/door.proc/close)

	icon_state = "launcherbtt"
	active = 0

	return

/obj/structure/machinery/door_control/timed_automatic
	var/trigger_delay = 1 //in minutes
	var/trigger_time
	var/triggered = 0
	use_power = 0

/obj/structure/machinery/door_control/timed_automatic/New()
	..()
	trigger_time = world.time + trigger_delay*600
	processing_objects.Add(src)
	start_processing()  // should really be using this -spookydonut

/obj/structure/machinery/door_control/timed_automatic/process()
	if (!triggered && world.time >= trigger_time)
		icon_state = initial(icon_state) + "1"

		switch(normaldoorcontrol)
			if(CONTROL_NORMAL_DOORS)
				handle_door()
			if(CONTROL_POD_DOORS)
				handle_pod()
			if(CONTROL_DROPSHIP)
				handle_dropship(id)

		desiredstate = !desiredstate
		triggered = 1
		processing_objects.Remove(src)
		//stop_processing()
		spawn(15)
			if(!(stat & NOPOWER))
				icon_state = initial(icon_state) + "0"

// Controls elevator railings
/obj/structure/machinery/door_control/railings
	name = "railing controls"
	desc = "Allows for raising and lowering the guard rails on the vehicle ASRS elevator when it's raised."
	id = "vehicle_elevator_railing_aux"

	var/busy = FALSE

/obj/structure/machinery/door_control/railings/use_button(mob/living/user, var/force = FALSE)
	if(inoperable())
		to_chat(user, SPAN_WARNING("[src] doesn't seem to be working."))
		return

	if(busy)
		flick(initial(icon_state) + "-denied",src)
		return

	if(!allowed(user) && (wires & 1) && !force)
		to_chat(user, SPAN_DANGER("Access Denied"))
		flick(initial(icon_state) + "-denied",src)
		return

	var/datum/shuttle/ferry/supply/vehicle/elevator = supply_controller.vehicle_elevator
	if(!elevator)
		flick(initial(icon_state) + "-denied",src)
		return

	// safety first
	if(!elevator.at_station())
		flick(initial(icon_state) + "-denied",src)
		return

	use_power(5)
	icon_state = initial(icon_state) + "1"
	busy = TRUE
	add_fingerprint(user)

	var/effective = 0
	for(var/obj/structure/machinery/door/poddoor/M in machines)
		if(M.id == id)
			effective = 1
			spawn()
				if(desiredstate)
					M.open()
				else
					M.close()
	if(effective)
		playsound(locate(elevator.Elevator_x,elevator.Elevator_y,elevator.Elevator_z), 'sound/machines/elevator_openclose.ogg', 50, 0)

	desiredstate = !desiredstate
	spawn(15)
		busy = FALSE
		if(!(stat & NOPOWER))
			icon_state = initial(icon_state) + "0"

/obj/structure/machinery/door_control/brbutton
	icon_state = "big_red_button_wallv"


/obj/structure/machinery/door_control/brbutton/alt
	icon_state = "big_red_button_tablev"
