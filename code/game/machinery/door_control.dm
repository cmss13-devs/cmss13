/obj/structure/machinery/door_control
	name = "remote door-control"
	desc = "It controls doors, remotely."
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "doorctrl"
	desc = "A remote control-switch for a door."
	power_channel = POWER_CHANNEL_ENVIRON
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE
	var/id = null
	var/range = 10
	var/normaldoorcontrol = CONTROL_POD_DOORS
	var/desiredstate = CONTROL_STATE_CLOSED
	var/specialfunctions = 1
	/*
	Bitflag, 1= open
				2= idscan,
				4= bolts
				8= shock
				16= door safties

	*/

	var/exposedwires = 0
	var/wires = 3
	/*
	Bitflag, 1=checkID
				2=Network Access
	*/

	anchored = TRUE
	use_power = USE_POWER_IDLE
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

/obj/structure/machinery/door_control/handle_tail_stab(mob/living/carbon/xenomorph/xeno, blunt_stab)
	return TAILSTAB_COOLDOWN_NONE

/obj/structure/machinery/door_control/attackby(obj/item/W, mob/user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/door_control/ex_act(severity)
	if(explo_proof)
		return FALSE
	..()

/obj/structure/machinery/door_control/proc/handle_dropship(ship_id)
	var/obj/docking_port/mobile/marine_dropship/shuttle = SSshuttle.getShuttle(ship_id)
	if (!istype(shuttle))
		return
	var/obj/structure/machinery/computer/shuttle/dropship/flight/comp = shuttle.getControlConsole()
	if(comp?.dropship_control_lost)
		return
	if(is_mainship_level(z)) // on the almayer
		return

	shuttle.control_doors("force-lock", "all", force=FALSE)

/obj/structure/machinery/door_control/proc/handle_door()
	for(var/obj/structure/machinery/door/airlock/target_door in range(range))
		if(target_door.id_tag == id)
			if(specialfunctions & OPEN)
				if (target_door.density)
					INVOKE_ASYNC(target_door, TYPE_PROC_REF(/obj/structure/machinery/door, open))
				else
					INVOKE_ASYNC(target_door, TYPE_PROC_REF(/obj/structure/machinery/door, close))
			if(desiredstate == CONTROL_STATE_OPEN)
				if(specialfunctions & IDSCAN)
					target_door.remoteDisabledIdScanner = 1
				if(specialfunctions & BOLTS)
					if(target_door.density)
						target_door.lock()
					else
						INVOKE_ASYNC(target_door, TYPE_PROC_REF(/obj/structure/machinery/door, close))
						addtimer(CALLBACK(target_door, TYPE_PROC_REF(/obj/structure/machinery/door/airlock, lock)), 1 SECONDS)
				if(specialfunctions & SHOCK)
					target_door.secondsElectrified = -1
				if(specialfunctions & SAFE)
					target_door.safe = 0
			else
				if(specialfunctions & IDSCAN)
					target_door.remoteDisabledIdScanner = 0
				if(specialfunctions & BOLTS)
					if(!target_door.isWireCut(4) && target_door.arePowerSystemsOn())
						target_door.unlock()
				if(specialfunctions & SHOCK)
					target_door.secondsElectrified = 0
				if(specialfunctions & SAFE)
					target_door.safe = 1

/obj/structure/machinery/door_control/proc/handle_cell_divider()
	for(var/turf/closed/wall/almayer/research/containment/wall/divide/wall in range(range))
		if(wall.remote_id == id)
			if(wall.density)
				wall.open()
			else
				wall.close()

/obj/structure/machinery/door_control/proc/handle_pod()
	for(var/obj/structure/machinery/door/poddoor/M in GLOB.machines)
		if(M.id == id)
			if(M.density)
				INVOKE_ASYNC(M, TYPE_PROC_REF(/obj/structure/machinery/door, open))
			else
				INVOKE_ASYNC(M, TYPE_PROC_REF(/obj/structure/machinery/door, close))

/obj/structure/machinery/door_control/verb/push_button()
	set name = "Push Button"
	set category = "Object"
	if(isliving(usr))
		var/mob/living/L = usr
		attack_hand(L)

/obj/structure/machinery/door_control/attack_hand(mob/living/user)
	add_fingerprint(user)
	if(istype(user,/mob/living/carbon/xenomorph))
		return
	use_button(user)

/obj/structure/machinery/door_control/proc/use_button(mob/living/user, force = FALSE)
	if(inoperable())
		to_chat(user, SPAN_WARNING("[src] doesn't seem to be working."))
		return

	if(!allowed(user) && (wires & 1) && !force )
		to_chat(user, SPAN_DANGER("Access Denied."))
		flick(initial(icon_state) + "-denied",src)
		return

	use_power(5)
	icon_state = initial(icon_state) + "1"
	add_fingerprint(user)
	to_chat(user, SPAN_NOTICE("You press \the [name] button."))

	switch(normaldoorcontrol)
		if(CONTROL_NORMAL_DOORS)
			handle_door()
		if(CONTROL_POD_DOORS)
			handle_pod()
		if(CONTROL_DROPSHIP)
			handle_dropship(id)
		if(CONTROL_CELL_DIVIDER)
			handle_cell_divider()

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

// Controls elevator railings
/obj/structure/machinery/door_control/railings
	name = "railing controls"
	desc = "Allows for raising and lowering the guard rails on the vehicle ASRS elevator when it's raised."
	id = "vehicle_elevator_railing_aux"
	gender = PLURAL
	var/busy = FALSE

/obj/structure/machinery/door_control/railings/use_button(mob/living/user, force = FALSE)
	if(inoperable())
		to_chat(user, SPAN_WARNING("[src] doesn't seem to be working."))
		return

	if(busy)
		flick(initial(icon_state) + "-denied",src)
		return

	if(!allowed(user) && (wires & 1) && !force)
		to_chat(user, SPAN_DANGER("Access Denied."))
		flick(initial(icon_state) + "-denied",src)
		return

	if(!SSshuttle.vehicle_elevator)
		flick(initial(icon_state) + "-denied",src)
		return

	// If someone's trying to lower the railings but the elevator isn't in the vehicle bay.
	if(desiredstate == CONTROL_STATE_CLOSED && !is_mainship_level(SSshuttle.vehicle_elevator.z))
		flick(initial(icon_state) + "-denied", src) // Safety first!
		return

	use_power(5)
	icon_state = initial(icon_state) + "1"
	busy = TRUE
	add_fingerprint(user)

	var/effective = 0
	for(var/obj/structure/machinery/door/poddoor/pod in GLOB.machines)
		if(pod.id == id)
			effective = 1
			spawn()
				if(desiredstate == CONTROL_STATE_OPEN)
					pod.open()
				else
					pod.close()
	if(effective)
		playsound(get_turf(SSshuttle.vehicle_elevator), 'sound/machines/elevator_openclose.ogg', 50, 0)

	desiredstate = !desiredstate
	spawn(15)
		busy = FALSE
		if(!(stat & NOPOWER))
			icon_state = initial(icon_state) + "0"

/obj/structure/machinery/door_control/yautja
	icon = 'icons/obj/structures/machinery/yautja_machines.dmi'

/obj/structure/machinery/door_control/brbutton
	icon_state = "big_red_button_wallv"


/obj/structure/machinery/door_control/brbutton/alt
	icon_state = "big_red_button_tablev"

/obj/structure/machinery/door_control/airlock
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "elevator_screen"

/obj/structure/machinery/door_control/airlock/use_button(mob/living/user, force = FALSE)
	if(inoperable())
		to_chat(user, SPAN_WARNING("\The [src] doesn't seem to be working."))
		return

	use_power(5)
	add_fingerprint(user)
	to_chat(user, SPAN_NOTICE("You press \the [name] button."))

	switch(normaldoorcontrol)
		if(CONTROL_NORMAL_DOORS)
			handle_door()
		if(CONTROL_POD_DOORS)
			handle_pod()
		if(CONTROL_DROPSHIP)
			handle_dropship(id)
		if(CONTROL_CELL_DIVIDER)
			handle_cell_divider()

	desiredstate = !desiredstate

/obj/structure/machinery/door_control/cl
	req_access_txt = "200"
	needs_power = FALSE
	use_power = FALSE

// seperating quarter and office because we might want to allow more access to the office than quarter in the future.
/obj/structure/machinery/door_control/cl/office

/obj/structure/machinery/door_control/cl/office/lobby_door
	name = "Lobby Door Shutter"
	id = "cl_lobby_door"

/obj/structure/machinery/door_control/cl/office/office_door
	name = "Office Door Shutter"
	id = "cl_office_door_s"

/obj/structure/machinery/door_control/cl/office/office_door_remote
	name = "Office Door Control"
	id = "cl_office_door"
	normaldoorcontrol = TRUE


/obj/structure/machinery/door_control/cl/office/lobby_window
	name = "Lobby Windows Shutters"
	id = "cl_lobby_windows"

/obj/structure/machinery/door_control/cl/office/office_window
	name = "Office Windows Shutters"
	id = "cl_office_windows"

/obj/structure/machinery/door_control/cl/office/divider
	name = "Room Divider"
	id = "RoomDivider"

//special button that unlock the cl lock on is evac pod door bypassing general lockdown.
/obj/structure/machinery/door_control/cl/office/evac
	name = "Evac Pod Door Control"
	id = "cl_evac"
	normaldoorcontrol = 1

/obj/structure/machinery/door_control/cl/quarter

/obj/structure/machinery/door_control/cl/quarter/office_door
	name = "Quarter Door Shutter"
	id = "cl_quarter_door"

/obj/structure/machinery/door_control/cl/quarter/backdoor
	name = "Maintenance Door Shutter"
	id = "cl_quarter_maintenance"

/obj/structure/machinery/door_control/cl/quarter/windows
	name = "Quarter Windows Shutters"
	id = "cl_quarter_windows"

// Hybrisa lockdown announcements

/obj/structure/machinery/door_control/colony_lockdown
	var/used = FALSE
	var/colony_lockdown_time = 25 MINUTES

/obj/structure/machinery/door_control/colony_lockdown/use_button(mob/living/user,force)
	if(world.time < SSticker.mode.round_time_lobby + colony_lockdown_time)
		to_chat(user, SPAN_WARNING("The colony-wide lockdown cannot be lifted yet. Please wait another [floor((SSticker.mode.round_time_lobby + colony_lockdown_time-world.time)/600)] minutes before trying again."))
		return
	if(used)
		to_chat(user, SPAN_WARNING("The colony-wide lockdown has already been lifted."))
		return
	. = ..()
	marine_announcement("The colony-wide lockdown protocols have been lifted.")
	used = TRUE

// Research

/obj/structure/machinery/door_control/research_lockdown
	var/used = FALSE
	var/colony_lockdown_time = 10 MINUTES

/obj/structure/machinery/door_control/research_lockdown/use_button(mob/living/user,force)
	if(world.time < SSticker.mode.round_time_lobby + colony_lockdown_time)
		to_chat(user, SPAN_WARNING("The WY-Research-Facility lockdown cannot be lifted yet. Please wait another [floor((SSticker.mode.round_time_lobby + colony_lockdown_time-world.time)/600)] minutes before trying again."))
		return
	if(used)
		to_chat(user, SPAN_WARNING("The WY-Research-Facility lockdown has already been lifted."))
		return
	. = ..()
	marine_announcement("The WY-Research-Facility lockdown protocols have been lifted.")
	used = TRUE

/// Automatic door control that doesn't act as a button but instead searches for mobs every process in its own area
/obj/structure/machinery/door_control/automatic
	name = "automatic door-control"
	desc = "It controls doors, automatically."
	icon_state = "launcherbtt"
	/// The faction to open for (or none for any)
	var/faction_to_monitor
	/// Any optional delay between triggering and opening
	var/open_delay = 0 SECONDS
	/// Any optional delay between untriggering and closing
	var/close_delay = 0 SECONDS
	/// timer_id for any change_state(TRUE) timer
	var/timer_id_open = TIMER_ID_NULL
	/// timer_id for any change_state(FALSE) timer
	var/timer_id_close = TIMER_ID_NULL

/obj/structure/machinery/door_control/automatic/Initialize(mapload, ...)
	. = ..()
	start_processing()

/obj/structure/machinery/door_control/automatic/use_button(mob/living/user, force)
	return

/obj/structure/machinery/door_control/automatic/power_change()
	..()
	icon_state = desiredstate ? "launcheract" : "launcherbtt"

/obj/structure/machinery/door_control/automatic/process()
	var/area/my_area = get_area(src)
	for(var/mob/creature in my_area)
		if(creature.stat == DEAD)
			continue
		if(!faction_to_monitor || creature.faction == faction_to_monitor || (faction_to_monitor in creature.faction_group))
			change_state(TRUE)
			return
	change_state(FALSE)

/obj/structure/machinery/door_control/automatic/proc/change_state(triggered, immediate)
	icon_state = triggered ? "launcheract" : "launcherbtt"

	if(triggered == desiredstate)
		// Cancel any timers if needed
		if(triggered)
			if(timer_id_close != TIMER_ID_NULL)
				deltimer(timer_id_close)
				timer_id_close = TIMER_ID_NULL
		else
			if(timer_id_open != TIMER_ID_NULL)
				deltimer(timer_id_open)
				timer_id_open = TIMER_ID_NULL
		return

	if(!immediate)
		// Open/Close w/ delay?
		if(triggered)
			if(open_delay > 0)
				if(timer_id_open == TIMER_ID_NULL)
					timer_id_open = addtimer(CALLBACK(src, PROC_REF(change_state), TRUE, TRUE), open_delay, TIMER_UNIQUE|TIMER_NO_HASH_WAIT|TIMER_STOPPABLE)
				return
		else
			if(close_delay > 0)
				if(timer_id_close == TIMER_ID_NULL)
					timer_id_close = addtimer(CALLBACK(src, PROC_REF(change_state), FALSE, TRUE), close_delay, TIMER_UNIQUE|TIMER_NO_HASH_WAIT|TIMER_STOPPABLE)
				return
	else
		if(triggered)
			timer_id_open = TIMER_ID_NULL
		else
			timer_id_close = TIMER_ID_NULL

	use_power(5)

	switch(normaldoorcontrol)
		if(CONTROL_NORMAL_DOORS)
			handle_door()
		if(CONTROL_POD_DOORS)
			handle_pod()
		if(CONTROL_DROPSHIP)
			handle_dropship(id)

	desiredstate = !desiredstate

/obj/structure/machinery/door_control/hatch_ladder
	name = "Hatch Ladder Access"
	desc = "Looks intimaditing enough to challenge non-humans to use it."
	icon = 'icons/obj/structures/machinery/omaha/interior_item.dmi'
	icon_state = "doorctrl"
	dir = EAST
	normaldoorcontrol = CONTROL_NORMAL_DOORS
	var/obj/structure/ladder/multiz/dropship/linked_ladder
	id = "change_this"

/obj/structure/machinery/door_control/hatch_ladder/omaha
	icon = 'icons/obj/structures/machinery/omaha/interior_item.dmi'
	id = "omaha_cockpit_ladder"

/obj/structure/machinery/door_control/hatch_ladder/midway
	icon = 'icons/obj/structures/machinery/midway/interior_item.dmi'
	id = "midway_cockpit_ladder"

/obj/structure/machinery/door_control/hatch_ladder/attack_hand(mob/living/user) // if(is_reserved_level(z)
	add_fingerprint(user) // removed xeno check. i am in control
	if(!linked_ladder)
		for(var/obj/structure/ladder/multiz/dropship/target_ladder in range(1, src.loc))
			if(target_ladder.id == id)
				linked_ladder = target_ladder
				break
	if(is_reserved_level(z))
		to_chat(user, SPAN_NOTICE("You almost press \the [name] button, but then reconsider killing yourself by venting atmo."))
		return
	else
		use_button(user)

/obj/structure/machinery/door_control/hatch_ladder/handle_door() // test this and map it
	if(linked_ladder.deployed) // add transit check
		linked_ladder.undeploy()
	else
		linked_ladder.deploy()

/obj/structure/machinery/door_control/hatch_ladder/beforeShuttleMove(turf/newT, rotation, move_mode, obj/docking_port/mobile/moving_dock)
	. = ..()
	if(linked_ladder?.deployed)
		linked_ladder.undeploy() // forced true

/obj/structure/machinery/door_control/side_hatch
	icon = 'icons/obj/structures/machinery/omaha/interior_item.dmi'
	icon_state = "doorctrl"
	var/obj/structure/machinery/door/airlock/hatch/side_hatch/linked_hatch
	normaldoorcontrol = CONTROL_NORMAL_DOORS
	var/obj/docking_port/mobile/marine_dropship/linked_dropship
	var/datum/door_controller/single/linked_single_controller
	var/direction

/obj/structure/machinery/door_control/side_hatch/omaha_hatch_left
	name = "Port Hatch Access"
	id = "port_door"
	dir = WEST
	direction = "port"

/obj/structure/machinery/door_control/side_hatch/omaha_hatch_right
	name = "Starboard Hatch Access"
	id = "starboard_door"
	dir = EAST
	direction = "starboard"

/obj/structure/machinery/door_control/side_hatch/midway_hatch_left
	name = "Port Hatch Access"
	icon = 'icons/obj/structures/machinery/midway/interior_item.dmi'
	id = "port_door"
	dir = WEST
	direction = "port"

/obj/structure/machinery/door_control/side_hatch/midway_hatch_right
	name = "Starboard Hatch Access"
	icon = 'icons/obj/structures/machinery/midway/interior_item.dmi'
	id = "starboard_door"
	dir = EAST
	direction = "starboard"

/obj/structure/machinery/door_control/side_hatch/beforeShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	. = ..()
	if(!linked_single_controller)
		for(var/direction in linked_dropship.door_control.door_controllers)
			var/datum/door_controller/single/controller = linked_dropship.door_control.door_controllers[direction]
			if(direction == src.direction)
				linked_single_controller = controller
	if(!linked_hatch)
		for(var/obj/structure/machinery/door/airlock/hatch/side_hatch/target_hatch in range(1, src.loc))
			if(target_hatch.id == id)
				linked_hatch = target_hatch
				break

/obj/structure/machinery/door_control/side_hatch/attack_hand(mob/living/user)
	add_fingerprint(user)
	if(istype(user,/mob/living/carbon/xenomorph))
		return
	if(is_reserved_level(z))
		to_chat(user, SPAN_NOTICE("You almost press \the [name] button, but then reconsider killing yourself by venting atmo."))
		return
	else
		use_button(user)

/obj/structure/machinery/door_control/side_hatch/handle_door()
	if(linked_single_controller.status == SHUTTLE_DOOR_LOCKED)
		linked_single_controller.control_doors("unlock")
	else
		linked_single_controller.control_doors("lock")

/obj/structure/machinery/door_control/side_hatch/attackby(obj/item/item, mob/user)
	if(HAS_TRAIT(item, TRAIT_TOOL_MULTITOOL))
		var/datum/door_controller/single/control = linked_single_controller
		if (control.status != SHUTTLE_DOOR_BROKEN)
			return ..()
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED) && !skillcheck(user, SKILL_PILOT, SKILL_PILOT_TRAINED))
			to_chat(user, SPAN_WARNING("You don't seem to understand how to restore a remote connection to [src]."))
			return
		if(user.action_busy)
			return

		to_chat(user, SPAN_WARNING("You begin to restore the remote connection to [src]."))
		if(!do_after(user, (skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED) ? 5 SECONDS : 8 SECONDS), INTERRUPT_ALL, BUSY_ICON_BUILD))
			to_chat(user, SPAN_WARNING("You fail to restore a remote connection to [src]."))
			return
		control.status = SHUTTLE_DOOR_UNLOCKED
		control.control_doors("lower")
		to_chat(user, SPAN_WARNING("You successfully restored the remote connection to [src]."))
		return
	. = ..()

/obj/structure/machinery/door_control/shuttle_ramp
	name = "Ramp Access"
	icon = 'icons/obj/structures/machinery/omaha/interior_item.dmi'
	icon_state = "ramp_control"
	id = "aft_ramp"
	var/dropship_id
	var/obj/docking_port/mobile/marine_dropship/linked_dropship
	var/list/first_ramps = list()
	var/list/second_ramps = list()
	var/list/third_ramps = list()
	var/list/fourth_ramps = list()
	var/list/fifth_ramps = list()
	var/list/linked_railings = list()
	normaldoorcontrol = CONTROL_NORMAL_DOORS
	var/datum/door_controller/single/linked_single_controller
	var/direction = "aft"
	var/busy = FALSE
	var/broken = FALSE
	var/obj/deployer/shuttle/dropship/dummy_part/rampazoid
	var/obj/effect/drosphip_ramp_shadow/linked_shadow

/obj/structure/machinery/door_control/shuttle_ramp/omaha_aft
	icon = 'icons/obj/structures/machinery/omaha/interior_item.dmi'
	icon_state = "ramp_control"
	id = "aft_ramp"
	dropship_id = DROPSHIP_OMAHA

/obj/structure/machinery/door_control/shuttle_ramp/midway_aft
	icon = 'icons/obj/structures/machinery/midway/interior_item.dmi'
	icon_state = "ramp_control"
	id = "aft_ramp"
	dropship_id = DROPSHIP_MIDWAY

/obj/structure/machinery/door_control/shuttle_ramp/proc/borders_space()
	if(is_reserved_level(src.z))
		return TRUE
	else
		return FALSE

/obj/structure/machinery/door_control/shuttle_ramp/handle_door()
	if(is_reserved_level(src.z))
		return
	if(linked_single_controller.status == SHUTTLE_DOOR_UNLOCKED)
		linked_single_controller.control_doors("close")
	else if(linked_single_controller.status == SHUTTLE_DOOR_LOCKED)
		linked_single_controller.control_doors("open")

/obj/structure/machinery/door_control/shuttle_ramp/proc/raise(forced = FALSE)
	if(linked_single_controller?.status == SHUTTLE_DOOR_LOCKED || busy || is_reserved_level(src.z))
		return

	busy = TRUE

	playsound(src.loc, 'sound/machines/omaha_ramp.ogg', 60, 0)
	var/turf/turf_below = SSmapping.get_turf_below(src.loc)
	if(turf_below)
		playsound(turf_below, 'sound/machines/omaha_ramp.ogg', 60, 0)

	linked_shadow.set_icon_state(TRUE)
	for(var/obj/structure/machinery/door/poddoor/railing/railme in linked_railings)
		railme.open()
	raise_ramp(fifth_ramps)
	raise_ramp(fourth_ramps)
	addtimer(CALLBACK(src, PROC_REF(raise_ramp), third_ramps), 25) // TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT
	addtimer(CALLBACK(src, PROC_REF(raise_ramp), second_ramps), 50)
	addtimer(CALLBACK(src, PROC_REF(raise_ramp), first_ramps, TRUE), 50)

/obj/structure/machinery/door_control/shuttle_ramp/proc/raise_forced()
	raise(forced = TRUE)

/obj/structure/machinery/door_control/shuttle_ramp/proc/raise_things(obj/our_deployer)
	var/turf/turf_below = SSmapping.get_turf_below(our_deployer.loc)
	if(turf_below)
		for(var/atom/movable/movabius in turf_below.contents)
			movabius.forceMove(our_deployer.loc)

/obj/structure/machinery/door_control/shuttle_ramp/proc/raise_ramp(list/ramp_group, finality = FALSE)
	var/turf/open/our_turf
	for(rampazoid in ramp_group)
		our_turf = rampazoid.loc

		if(rampazoid.linked_deployable)
			QDEL_NULL(rampazoid.linked_deployable)
			rampazoid.linked_deployable = null
		if(rampazoid.stored_turf)
			rampazoid.stored_turf.ScrapeAway()
			our_turf.update_vis_contents()
		raise_things(rampazoid)
	if(finality)
		busy = FALSE
		linked_single_controller.status = SHUTTLE_DOOR_LOCKED

/obj/structure/machinery/door_control/shuttle_ramp/proc/lower()
	if(linked_single_controller?.status == SHUTTLE_DOOR_UNLOCKED || busy || is_reserved_level(src.z) || linked_dropship.is_hijacked)
		return

	busy = TRUE

	playsound(src.loc, 'sound/machines/omaha_ramp.ogg', 50, 0)
	var/turf/turf_below = SSmapping.get_turf_below(src.loc)
	if(turf_below)
		playsound(turf_below, 'sound/machines/omaha_ramp.ogg', 60, 0)

	linked_shadow.set_icon_state(FALSE)
	for(var/obj/structure/machinery/door/poddoor/railing/railme in linked_railings)
		railme.close()
	lower_ramp(first_ramps)
	lower_ramp(second_ramps)
	addtimer(CALLBACK(src, PROC_REF(lower_ramp), third_ramps), 25) // TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT
	addtimer(CALLBACK(src, PROC_REF(lower_ramp), fourth_ramps), 50)
	addtimer(CALLBACK(src, PROC_REF(lower_ramp), fifth_ramps, TRUE), 50)

/obj/structure/machinery/door_control/shuttle_ramp/proc/lower_ramp(list/ramp_group, finality = FALSE)
	var/turf/open/our_turf
	var/turf/turf_beneath
	for(rampazoid in ramp_group)
		crush_mobs(rampazoid)
		our_turf = rampazoid.loc
		turf_beneath = SSmapping.get_turf_below(our_turf)

		if(!rampazoid.cached_icon)
			rampazoid.cached_icon = our_turf.icon
			rampazoid.cached_icon_state = "[our_turf.icon_state]-low"

		if(rampazoid.mode == "fifth")
			rampazoid.stored_turf = turf_beneath.place_on_top(rampazoid.item_to_deploy)
			rampazoid.linked_deployable = new rampazoid.item_to_deploy2(our_turf)
			for(var/mob/living/carbon/morbius in our_turf.contents)
				rampazoid.loc.Entered(morbius)
		else
			if(rampazoid.item_to_deploy2)
				rampazoid.linked_deployable = new rampazoid.item_to_deploy2(turf_beneath)
			lower_things(rampazoid)
			rampazoid.stored_turf = our_turf.place_on_top(rampazoid.item_to_deploy)

		if(rampazoid.linked_deployable)
			rampazoid.linked_deployable.icon = rampazoid.cached_icon
			rampazoid.linked_deployable.icon_state = rampazoid.cached_icon_state

	if(finality)
		busy = FALSE
		if(broken)
			linked_single_controller.status = SHUTTLE_DOOR_BROKEN
		else
			linked_single_controller.status = SHUTTLE_DOOR_UNLOCKED

/obj/structure/machinery/door_control/shuttle_ramp/proc/lower_things(obj/our_deployer)
	var/turf/turf_below = SSmapping.get_turf_below(our_deployer.loc)
	if(turf_below)
		for(var/atom/movable/movablius in rampazoid.loc.contents)
			if(!movablius.anchored)
				movablius.forceMove(turf_below)

/obj/structure/machinery/door_control/shuttle_ramp/proc/crush_mobs(obj/our_deployer) // eh
	var/turf/open/turf_below = SSmapping.get_turf_below(our_deployer.loc)
	for(var/mob/living/carbon/morbius in turf_below.contents)
		morbius.throw_random_direction(2, 3, spin = TRUE)
		morbius.apply_effect(5, WEAKEN)
		shake_camera(morbius, 10, 1)
		morbius.apply_armoured_damage(40, ARMOR_MELEE, BRUTE, rand_zone())

/obj/structure/machinery/door_control/shuttle_ramp/beforeShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	.=..()
	if(!length(first_ramps))
		for(rampazoid in linked_dropship.obj_shuttle_contents) // switch to switch and "" vars
			switch(rampazoid.mode)
				if("first")
					first_ramps += rampazoid
				if("second")
					second_ramps += rampazoid
				if("third")
					third_ramps += rampazoid
				if("fourth")
					fourth_ramps += rampazoid
				if("fifth")
					fifth_ramps += rampazoid

	if(!linked_single_controller)
		for(var/direction in linked_dropship.door_control.door_controllers)
			var/datum/door_controller/single/controller = linked_dropship.door_control.door_controllers[direction]
			if(direction == src.direction)
				linked_single_controller = controller
	if(!linked_shadow)
		linked_shadow = locate(/obj/effect/drosphip_ramp_shadow) in linked_dropship.obj_shuttle_contents
	if(!length(linked_railings))
		for(var/obj/structure/machinery/door/poddoor/railing/railme in linked_dropship.obj_shuttle_contents)
			if(dropship_id == railme.id)
				linked_railings += railme

/obj/structure/machinery/door_control/shuttle_ramp/attackby(obj/item/item, mob/user)
	if(HAS_TRAIT(item, TRAIT_TOOL_MULTITOOL))
		var/datum/door_controller/single/control = linked_single_controller
		if (control.status != SHUTTLE_DOOR_BROKEN)
			return ..()
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED) && !skillcheck(user, SKILL_PILOT, SKILL_PILOT_TRAINED))
			to_chat(user, SPAN_WARNING("You don't seem to understand how to restore a remote connection to [src]."))
			return
		if(user.action_busy)
			return

		to_chat(user, SPAN_WARNING("You begin to restore the remote connection to [src]."))
		if(!do_after(user, (skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED) ? 5 SECONDS : 8 SECONDS), INTERRUPT_ALL, BUSY_ICON_BUILD))
			to_chat(user, SPAN_WARNING("You fail to restore a remote connection to [src]."))
			return
		control.status = SHUTTLE_DOOR_UNLOCKED
		control.control_doors("lower")
		to_chat(user, SPAN_WARNING("You successfully restored the remote connection to [src]."))
		return
	. = ..()

/obj/structure/machinery/door_control/shuttle_ramp/attack_alien(mob/living/carbon/xenomorph/xeno)
	. = ..()
	if(xeno.hive_pos != XENO_QUEEN)
		return ..()

	if(xeno.action_busy || is_reserved_level(z) || linked_single_controller.status == SHUTTLE_DOOR_UNLOCKED)
		return

	if(linked_single_controller && linked_single_controller.status == SHUTTLE_DOOR_BROKEN)
		to_chat(xeno, SPAN_NOTICE("The door is already disabled."))
		return

	to_chat(xeno, SPAN_WARNING("You start messing with the ramp controls!"))
	if(do_after(xeno, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		if(linked_single_controller)
			linked_single_controller.status = SHUTTLE_DOOR_BROKEN
			broken = TRUE
			broken = TRUE
		lower()

/obj/structure/machinery/door_control/dropship_ramp_dummy
	name = "Ramp Access"
	icon = 'icons/obj/structures/machinery/omaha/interior_item.dmi'
	icon_state = "ramp_control"
	id = "aft_ramp"
	normaldoorcontrol = CONTROL_NORMAL_DOORS
	var/obj/docking_port/mobile/marine_dropship/linked_dropship
	var/obj/structure/machinery/door_control/shuttle_ramp/linked_ramp_control
	var/datum/door_controller/single/linked_single_controller
	var/direction = "aft"
	var/broken = FALSE

/obj/structure/machinery/door_control/dropship_ramp_dummy/omaha_aft
	name = "Ramp Access"
	icon = 'icons/obj/structures/machinery/omaha/interior_item.dmi'
	icon_state = "ramp_control"
	id = "aft_ramp"

/obj/structure/machinery/door_control/dropship_ramp_dummy/midway_aft
	name = "Ramp Access"
	icon = 'icons/obj/structures/machinery/midway/interior_item.dmi'
	icon_state = "ramp_control"
	id = "aft_ramp"

/obj/structure/machinery/door_control/dropship_ramp_dummy/handle_door()
	return linked_ramp_control.handle_door()

/obj/structure/machinery/door_control/dropship_ramp_dummy/attackby(obj/item/item, mob/user)
	return linked_ramp_control.attackby(item, user)

/obj/structure/machinery/door_control/dropship_ramp_dummy/attack_alien(mob/living/carbon/xenomorph/xeno)
	return linked_ramp_control.attack_alien(xeno)
