// === MOBILES

/// Generic Lifeboat definition
/obj/docking_port/mobile/escape_pod
	name = "escapepod"
	ignitionTime = 8 SECONDS
	dwidth = 2
	width = 5
	height = 4
	rechargeTime = 5 MINUTES

	var/can_launch = FALSE
	var/cap_weight = 3

	ignition_sound = 'sound/effects/escape_pod_warmup.ogg'

	var/datum/computer/file/embedded_program/docking/simple/escape_pod/evacuation_program
	var/list/cryo_cells = list()
	var/list/doors = list()
	var/static/survivors = 0

/obj/docking_port/mobile/escape_pod/proc/link_support_units(turf/ref)
	var/obj/structure/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/R = locate() in shuttle_areas //Grab the controller.
	if(!R)
		log_debug("ERROR CODE EV1.5: could not find controller in [id].")
		to_world(SPAN_DEBUG("ERROR CODE EV1: could not find controller in [id]."))
		return FALSE

	//Set the tags.
	R.id_tag = id //Set tag.
	R.tag_door = id //Set the door tag.
	R.evacuation_program = new(R) //Make a new program with the right parent-child relationship. Make sure the master is specified in new().
	//R.docking_program = R.evacuation_program //Link them all to the same program, sigh.
	//R.program = R.evacuation_program
	evacuation_program = R.evacuation_program //For the shuttle, to shortcut the controller program.

	cryo_cells = new
	for(var/obj/structure/machinery/cryopod/evacuation/E in shuttle_areas)
		cryo_cells += E
		E.evacuation_program = evacuation_program
	if(!cryo_cells.len)
		log_debug("ERROR CODE EV2: could not find cryo pods in [id].")
		to_world(SPAN_DEBUG("ERROR CODE EV2: could not find cryo pods in [id]."))
		return FALSE

/obj/docking_port/mobile/escape_pod/proc/can_launch()
	if(EvacuationAuthority.evac_status >= EVACUATION_STATUS_INITIATING || evacuation_program.armed)
		switch(evacuation_program.dock_state)
			if(ESCAPE_STATE_READY)
				return TRUE
			if(ESCAPE_STATE_DELAYED)
				for(var/obj/structure/machinery/cryopod/evacuation/C in cryo_cells)
					if(!C.occupant)
						return FALSE
				return TRUE

/obj/docking_port/mobile/escape_pod/proc/can_cancel()
	. = (EvacuationAuthority.evac_status > EVACUATION_STATUS_STANDING_BY && (evacuation_program.dock_state in ESCAPE_STATE_READY to ESCAPE_STATE_DELAYED))

/obj/docking_port/mobile/escape_pod/proc/check_for_survivors()
	for(var/mob/living/carbon/human/M as anything in GLOB.alive_human_list)
		var/area/A = get_area(M)
		if(!M)
			continue
		if(M.stat != DEAD && (A in shuttle_areas))
			var/turf/T = get_turf(M)
			if(!T || is_mainship_level(T.z))
				continue
			survivors++
//			M.count_statistic_stat(STATISTICS_ESCAPE) MAKE SURE COMMIT AFTER STATISTIC DB REFACTOR MERGED!!!
			to_chat(M, "<br><br>[SPAN_CENTERBOLD("<big>You have successfully left the [MAIN_SHIP_NAME]. You may now ghost and observe the rest of the round.</big>")]<br>")
	EvacuationAuthority.lifesigns += survivors
	return TRUE

/obj/docking_port/mobile/escape_pod/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/docking_port/mobile/escape_pod/LateInitialize()
	. = ..()
	for(var/obj/structure/machinery/cryopod/evacuation/C in cryo_cells)
		C.evacuation_program = evacuation_program

#define MOVE_MOB_OUTSIDE \
for(var/obj/structure/machinery/cryopod/evacuation/C in cryo_cells) C.go_out()

/obj/docking_port/mobile/escape_pod/proc/toggle_ready()
	switch(evacuation_program.dock_state)
		if(ESCAPE_STATE_IDLE)
			evacuation_program.dock_state = ESCAPE_STATE_READY
			can_launch = TRUE
			spawn()
				open_all_doors()

		if(ESCAPE_STATE_READY)
			evacuation_program.dock_state = ESCAPE_STATE_IDLE
			MOVE_MOB_OUTSIDE
			can_launch = FALSE
			spawn(250)
				close_all_doors()

/obj/docking_port/mobile/escape_pod/proc/check_passengers()
	. = TRUE
	var/n = 0 //Generic counter.
	for(var/mob/living/carbon/human/M as anything in GLOB.alive_human_list)
		var/area/A = get_area(M)
		if(!M)
			continue
		if(A in shuttle_areas)
			var/turf/T = get_turf(M)
			if(!T || is_mainship_level(T.z))
				continue
			n++
	for(var/mob/living/carbon/Xenomorph/X as anything in GLOB.living_xeno_list)
		var/area/A = get_area(X)
		if(!X)
			continue
		if(A in shuttle_areas)
			var/turf/T = get_turf(X)
			if(!T || is_mainship_level(T.z))
				continue
			if(X.mob_size >= MOB_SIZE_BIG)
				return FALSE //Huge xenomorphs will automatically fail the launch.
			n++
	if(n > cryo_cells.len)  . = FALSE //Default is 3 cryo cells and three people inside the pod.
	return TRUE

/obj/docking_port/mobile/escape_pod/proc/prepare_for_launch()
	if(!can_launch())
		return FALSE
	evacuation_program.dock_state = ESCAPE_STATE_LAUNCHING
	spawn()
		close_all_doors()
	sleep(31)
	if(!check_passengers())
		evacuation_program.override = FALSE
		evacuation_program.dock_state = ESCAPE_STATE_BROKEN
		explosion(evacuation_program.master, -1, -1, 3, 4, , , , create_cause_data("escape pod malfunction"))
		sleep(25)

		MOVE_MOB_OUTSIDE
		spawn()
			open_all_doors()
		evacuation_program.master.state(SPAN_WARNING("WARNING: Maximum weight limit reached, pod unable to launch. Warning: Thruster failure detected."))
		return FALSE
	send_to_infinite_transit()
	return TRUE

#undef MOVE_MOB_OUTSIDE

/obj/docking_port/mobile/escape_pod/proc/open_all_doors()
	for(var/obj/structure/machinery/door/airlock/evacuation/D in doors)
		INVOKE_ASYNC(D, /obj/structure/machinery/door/airlock/evacuation/.proc/force_open)

/obj/docking_port/mobile/escape_pod/proc/close_all_doors()
	for(var/obj/structure/machinery/door/airlock/evacuation/D in doors)
		INVOKE_ASYNC(D, /obj/structure/machinery/door/airlock/evacuation/.proc/force_close)

/// Port
/obj/docking_port/mobile/escape_pod/up
	id = "escape_pod_up"
	dir = SOUTH
	preferred_direction = SOUTH
	port_direction = SOUTH

/// Starboard
/obj/docking_port/mobile/escape_pod/down
	id = "escape_pod_down"
	dir = NORTH
	preferred_direction = NORTH
	port_direction = NORTH

/// Aft
/obj/docking_port/mobile/escape_pod/left
	id = "escape_pod_left"
	dir = EAST
	preferred_direction = EAST
	port_direction = EAST

/// Stern
/obj/docking_port/mobile/escape_pod/right
	id = "escape_pod_right"
	dir = WEST
	preferred_direction = WEST
	port_direction = WEST

/// Corporate potato pod
/obj/docking_port/mobile/escape_pod/right/corporate
	id = "escape_pod_berth"
	dir = WEST
	preferred_direction = WEST
	port_direction = WEST

/obj/docking_port/mobile/escape_pod/proc/send_to_infinite_transit()
	evacuation_program.dock_state = ESCAPE_STATE_LAUNCHED
	destination = null
	check_for_survivors()
	set_mode(SHUTTLE_IGNITING)
	on_ignition()
	setTimer(ignitionTime)

// === STATIONARIES

/// Generic lifeboat dock
/obj/docking_port/stationary/escape_pod_dock
	name   = "Escape pod docking port"
	dwidth = 2
	width = 5
	height = 4

/obj/docking_port/stationary/escape_pod_dock/almayer/up
	dir = SOUTH
	roundstart_template = /datum/map_template/shuttle/escape_pod_up

/obj/docking_port/stationary/escape_pod_dock/almayer/down
	dir = NORTH
	roundstart_template = /datum/map_template/shuttle/escape_pod_down

/obj/docking_port/stationary/escape_pod_dock/almayer/left
	dir = EAST
	roundstart_template = /datum/map_template/shuttle/escape_pod_left

/obj/docking_port/stationary/escape_pod_dock/almayer/right
	dir = WEST
	roundstart_template = /datum/map_template/shuttle/escape_pod_right

/obj/docking_port/stationary/escape_pod_dock/almayer/right/berth
	dir = WEST
	roundstart_template = /datum/map_template/shuttle/escape_pod_berth

/obj/docking_port/stationary/escape_pod_dock/almayer/Initialize(mapload)
	. = ..()
	GLOB.escape_almayer_docks += src

/obj/docking_port/stationary/escape_pod_dock/almayer/Destroy(force)
	if(force)
		GLOB.escape_almayer_docks -= src
	. = ..()

// === SHUTTLE TEMPLATES FOR SPAWNING THEM

/// Port
/datum/map_template/shuttle/escape_pod_up
	name = "escape pod up"
	shuttle_id = "escape_pod_up"

/// Starboard
/datum/map_template/shuttle/escape_pod_down
	name = "escape pod down"
	shuttle_id = "escape_pod_down"

/// Aft
/datum/map_template/shuttle/escape_pod_left
	name = "escape pod left"
	shuttle_id = "escape_pod_left"

/// Stern
/datum/map_template/shuttle/escape_pod_right
	name = "escape pod right"
	shuttle_id = "escape_pod_right"

/// Corporate
/datum/map_template/shuttle/escape_pod_berth
	name = "escape pod berth"
	shuttle_id = "escape_pod_berth"


//=========================================================================================
//================================Evacuation Sleeper=======================================
//=========================================================================================

/obj/structure/machinery/cryopod/evacuation
	stat = MACHINE_DO_NOT_PROCESS
	unslashable = TRUE
	unacidable = TRUE
	time_till_despawn = 6000000 //near infinite so despawn never occurs.
	var/being_forced = 0 //Simple variable to prevent sound spam.
	var/datum/computer/file/embedded_program/docking/simple/escape_pod/evacuation_program
	var/linked_to_shuttle = FALSE

	ex_act(severity)
		return FALSE

	attackby(obj/item/grab/G, mob/user)
		if(istype(G))
			if(being_forced)
				to_chat(user, SPAN_WARNING("There's something forcing it open!"))
				return FALSE

			if(occupant)
				to_chat(user, SPAN_WARNING("There is someone in there already!"))
				return FALSE

			if(evacuation_program.dock_state < ESCAPE_STATE_READY)
				to_chat(user, SPAN_WARNING("The cryo pod is not responding to commands!"))
				return FALSE

			var/mob/living/carbon/human/M = G.grabbed_thing
			if(!istype(M))
				return FALSE

			visible_message(SPAN_WARNING("[user] starts putting [M.name] into the cryo pod."), null, null, 3)

			if(do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_GENERIC))
				if(!M || !G || !G.grabbed_thing || !G.grabbed_thing.loc || G.grabbed_thing != M)
					return FALSE
				move_mob_inside(M)

	eject()
		set name = "Eject Pod"
		set category = "Object"
		set src in oview(1)

		if(!occupant || !usr.stat || usr.is_mob_restrained())
			return FALSE

		if(occupant) //Once you're in, you cannot exit, and outside forces cannot eject you.
			//The occupant is actually automatically ejected once the evac is canceled.
			if(occupant != usr) to_chat(usr, SPAN_WARNING("You are unable to eject the occupant unless the evacuation is canceled."))

		add_fingerprint(usr)

	go_out() //When the system ejects the occupant.
		if(occupant)
			occupant.forceMove(get_turf(src))
			occupant.in_stasis = FALSE
			occupant = null
			icon_state = orient_right ? "body_scanner_0-r" : "body_scanner_0"

	move_inside()
		set name = "Enter Pod"
		set category = "Object"
		set src in oview(1)

		var/mob/living/carbon/human/user = usr

		if(!istype(user) || user.stat || user.is_mob_restrained())
			return FALSE

		if(being_forced)
			to_chat(user, SPAN_WARNING("You can't enter when it's being forced open!"))
			return FALSE

		if(occupant)
			to_chat(user, SPAN_WARNING("The cryogenic pod is already in use! You will need to find another."))
			return FALSE

		if(evacuation_program.dock_state < ESCAPE_STATE_READY)
			to_chat(user, SPAN_WARNING("The cryo pod is not responding to commands!"))
			return FALSE

		visible_message(SPAN_WARNING("[user] starts climbing into the cryo pod."), null, null, 3)

		if(do_after(user, 20, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
			user.stop_pulling()
			move_mob_inside(user)

	attack_alien(mob/living/carbon/Xenomorph/user)
		if(being_forced)
			to_chat(user, SPAN_XENOWARNING("It's being forced open already!"))
			return XENO_NO_DELAY_ACTION

		if(!occupant)
			to_chat(user, SPAN_XENOWARNING("There is nothing of interest in there."))
			return XENO_NO_DELAY_ACTION

		being_forced = !being_forced
		xeno_attack_delay(user)
		visible_message(SPAN_WARNING("[user] begins to pry \the [src]'s cover!"), null, null, 3)
		playsound(src,'sound/effects/metal_creaking.ogg', 25, 1)
		if(do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_HOSTILE)) go_out() //Force the occupant out.
		being_forced = !being_forced
		return XENO_NO_DELAY_ACTION

/obj/structure/machinery/cryopod/evacuation/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock, idnum, override=FALSE)
	if(linked_to_shuttle)
		return
	. = ..()

	if(istype(port, /obj/docking_port/mobile/escape_pod))
		var/obj/docking_port/mobile/escape_pod/M = port
		M.cryo_cells += src
		linked_to_shuttle = TRUE

/obj/structure/machinery/cryopod/evacuation/proc/move_mob_inside(mob/M)
	if(occupant)
		to_chat(M, SPAN_WARNING("The cryogenic pod is already in use. You will need to find another."))
		return FALSE
	M.forceMove(src)
	to_chat(M, SPAN_NOTICE("You feel cool air surround you as your mind goes blank and the pod locks."))
	occupant = M
	occupant.in_stasis = STASIS_IN_CRYO_CELL
	add_fingerprint(M)
	icon_state = orient_right ? "body_scanner_1-r" : "body_scanner_1"


/obj/structure/machinery/door/airlock/evacuation
	name = "Evacuation Airlock"
	icon = 'icons/obj/structures/doors/pod_doors.dmi'
	heat_proof = 1
	unslashable = TRUE
	unacidable = TRUE
	var/linked_to_shuttle = FALSE

/obj/structure/machinery/door/airlock/evacuation/Initialize()
	. = ..()
	INVOKE_ASYNC(src, .proc/lock)
	generate_name()

/obj/structure/machinery/door/airlock/evacuation/proc/generate_name()
	name = "[name]-[pick(alphabet_uppercase)][pick(alphabet_uppercase)][rand(1,9)]"

/obj/structure/machinery/door/airlock/evacuation/proc/force_open()
	if(!density)
		return
	unlock()
	open()
	lock()

/obj/structure/machinery/door/airlock/evacuation/proc/force_close()
	if(density)
		return
	unlock()
	close()
	lock()

	//Can't interact with them, mostly to prevent grief and meta.
/obj/structure/machinery/door/airlock/evacuation/Collided()
	return FALSE

/obj/structure/machinery/door/airlock/evacuation/attackby()
	return FALSE

/obj/structure/machinery/door/airlock/evacuation/attack_hand()
	return FALSE

/obj/structure/machinery/door/airlock/evacuation/attack_alien()
	return FALSE //Probably a better idea that these cannot be forced open.

/obj/structure/machinery/door/airlock/evacuation/attack_remote()
	return FALSE

/obj/structure/machinery/door/airlock/evacuation/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock, idnum, override=FALSE)
	if(linked_to_shuttle)
		return
	. = ..()

	if(istype(port, /obj/docking_port/mobile/escape_pod))
		var/obj/docking_port/mobile/escape_pod/M = port
		id_tag = M.id
		M.doors += src
		linked_to_shuttle = TRUE


//=========================================================================================
//==================================Console Object=========================================
//=========================================================================================

//This controller goes on the escape pod itself.
/obj/structure/machinery/embedded_controller/radio/simple_docking_controller/escape_pod
	name = "escape pod controller"
	unslashable = TRUE
	unacidable = TRUE
	var/datum/computer/file/embedded_program/docking/simple/escape_pod/evacuation_program
	var/linked_to_shuttle = FALSE

/obj/structure/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/Initialize()
	. = ..()
	GLOB.escape_pod_controllers += src

/obj/structure/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/ex_act(severity)
		return FALSE

/obj/structure/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	var/launch_status[] = evacuation_program.check_launch_status()
	var/data[] = list(
		"docking_status"	= evacuation_program.dock_state,
		"door_state"		= evacuation_program.memory["door_status"]["state"],
		"door_lock"			= evacuation_program.memory["door_status"]["lock"],
		"can_lock"			= evacuation_program.dock_state == (ESCAPE_STATE_READY || ESCAPE_STATE_DELAYED) ? 1:0,
		"can_force"			= evacuation_program.dock_state == (ESCAPE_STATE_READY || ESCAPE_STATE_DELAYED) ? 1:0,
		"can_delay"			= launch_status[2]
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "escape_pod_console.tmpl", id_tag, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(0)

/obj/structure/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/Topic(href, href_list)
	if(..())
		return TRUE	//Has to return true to fail. For some reason.

	var/obj/docking_port/mobile/escape_pod/P = SSshuttle.getShuttle("[id_tag]")
	switch(href_list["command"])
		if("force_launch")
			P.prepare_for_launch()
		if("delay_launch")
			evacuation_program.dock_state = evacuation_program.dock_state == ESCAPE_STATE_DELAYED ? ESCAPE_STATE_READY : ESCAPE_STATE_DELAYED
		if("lock_door")
			var/obj/structure/machinery/door/airlock/evacuation/D = pick(P.doors)
			if(D.density) //Closed
				spawn()
					P.open_all_doors()
			else //Open
				spawn()
					P.close_all_doors()


/obj/structure/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock, idnum, override=FALSE)
	if(linked_to_shuttle)
		return
	. = ..()

	if(istype(port, /obj/docking_port/mobile/escape_pod))
		var/obj/docking_port/mobile/escape_pod/M = port
		id_tag = M.id
		tag_door = M.id
		evacuation_program = new(src)
		M.evacuation_program = evacuation_program
		linked_to_shuttle = TRUE
		if(id_tag == "escape_pod_berth")
			for(var/obj/structure/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/berth/EPB in GLOB.escape_pod_controllers)
				if(id_tag == "escape_pod_berth" && !EPB.evacuation_program)
					EPB.evacuation_program = evacuation_program


//Leaving this commented out for the CL pod, which should have a way to open from the outside.

//This controller is for the escape pod berth (station side)
/obj/structure/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/berth
	name = "escape pod berth controller"
	id_tag = "escape_pod_berth"

/obj/structure/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/berth/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[] = list(
		"docking_status"	= evacuation_program.dock_state,
		"override_enabled"	= evacuation_program.override,
		"armed" = evacuation_program.armed,
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "escape_pod_berth_console.tmpl", name, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/structure/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/berth/Topic(href, href_list)
	if(..())
		return TRUE	//Has to return true to fail. For some reason.

	var/obj/docking_port/mobile/escape_pod/P = SSshuttle.getShuttle("[id_tag]")
	switch(href_list["command"])
		if("toggle_override")
			evacuation_program.armed = !evacuation_program.armed
			P.toggle_ready()
		if("force_door")
			var/obj/structure/machinery/door/airlock/evacuation/D = pick(P.doors)
			if(D.density) //Closed
				spawn()
					P.open_all_doors()
			else //Open
				spawn()
					P.close_all_doors()


//=========================================================================================
//================================Controller Program=======================================
//=========================================================================================

//A docking controller program for a simple door based docking port
/datum/computer/file/embedded_program/docking/simple/escape_pod
	dock_state = ESCAPE_STATE_IDLE
	var/armed = FALSE
	var/override = TRUE

/datum/computer/file/embedded_program/docking/simple/escape_pod/proc/check_launch_status()
	var/obj/docking_port/mobile/escape_pod/P = SSshuttle.getShuttle("[id_tag]")
	. = list(P.can_launch(), P.can_cancel())