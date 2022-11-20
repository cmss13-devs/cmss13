//=========================================================================================
//===================================Shuttle Datum=========================================
//=========================================================================================
#define STATE_IDLE			4 //Pod is idle, not ready to launch.
#define STATE_BROKEN		5 //Pod failed to launch, is now broken.
#define STATE_READY			6 //Pod is armed and ready to go.
#define STATE_DELAYED		7 //Pod is being delayed from launching automatically.
#define STATE_LAUNCHING		8 //Pod is about to launch.
#define STATE_LAUNCHED		9 //Pod has successfully launched.
/*Other states are located in docking_program.dm, but they aren't important here.
This is built upon a weird network of different states, including docking states, moving
states, process states, and so forth. It's disorganized, but I tried to keep it in line
with the original.*/

/datum/shuttle/ferry/marine/evacuation_pod
	location = 0
	warmup_time = 5 SECONDS
	shuttle_tag = "Almayer Evac"
	info_tag = "Almayer Evac"
	sound_target = 18
	sound_misc = 'sound/effects/escape_pod_launch.ogg'
	var/static/passengers = 0 //How many living escape on the shuttle. Does not count simple animals.
	var/cryo_cells[] //List of the crypods attached to the evac pod.
	var/area/staging_area //The area the shuttle starts in, used to link the various machinery.
	var/datum/computer/file/embedded_program/docking/simple/escape_pod/evacuation_program //The program that runs the doors.
	var/obj/structure/machinery/door/airlock/evacuation/D //TODO Get rid of this.
	//docking_controller is the program that runs doors.
	//TODO: Make sure that the area has light once evac is in progress.

	//Can only go one way, never back. Very simple.
	process()
		switch(process_state)
			if(WAIT_LAUNCH)
				short_jump()
				process_state = IDLE_STATE

	//No safeties here. Everything is done through dock_state.
	launch()
		process_state = WAIT_LAUNCH

	can_launch() //Cannot launch it early before the evacuation takes place proper, and the pod must be ready. Cannot be delayed, broken, launching, or otherwise.
		if(..() && EvacuationAuthority.evac_status >= EVACUATION_STATUS_INITIATING)
			switch(evacuation_program.dock_state)
				if(STATE_READY)
					return TRUE
				if(STATE_DELAYED)
					for(var/obj/structure/machinery/cryopod/evacuation/C in cryo_cells) //If all are occupied, the pod will launch anyway.
						if(!C.occupant)
							return FALSE
					return TRUE

	//The pod can be delayed until after the automatic launch.
	can_cancel()
		. = (EvacuationAuthority.evac_status > EVACUATION_STATUS_STANDING_BY && (evacuation_program.dock_state in STATE_READY to STATE_DELAYED)) //Must be evac time and the pod can't be launching/launched.

	short_jump()
		. = ..()
		evacuation_program.dock_state = STATE_LAUNCHED
		spawn(10)
			check_passengers("<br><br>[SPAN_CENTERBOLD("<big>You have successfully left the [MAIN_SHIP_NAME]. You may now ghost and observe the rest of the round.</big>")]<br>")

/*
This processes tags and connections dynamically, so you do not need to modify or pregenerate linked objects.
There is no specific need to even have this complicated system in place, but I wanted something that worked
off an existing controller that allowed more robust functinonality. But in reality, all of the objects
are basically hard-linked together and do not need a go-between controller. The shuttle datum itself would
suffice.
*/
/datum/shuttle/ferry/marine/evacuation_pod/proc/link_support_units(turf/ref)
	var/datum/coords/C = info_datums[1] //Grab a coord for random turf.
	var/turf/T = locate(ref.x + C.x_pos, ref.y + C.y_pos, ref.z) //Get a turf from the coordinates.
	if(!istype(T))
		log_debug("ERROR CODE EV0: unable to find the first turf of [shuttle_tag].")
		to_world(SPAN_DEBUG("ERROR CODE EV0: unable to find the first turf of [shuttle_tag]."))
		return FALSE

	staging_area = T.loc //Grab the area and store it on file.
	staging_area.name = "\improper[shuttle_tag]"

	D = locate() in staging_area
	if(!D)
		log_debug("ERROR CODE EV1.5: could not find door in [shuttle_tag].")
		to_world(SPAN_DEBUG("ERROR CODE EV1: could not find door in [shuttle_tag]."))
		return FALSE
	D.id_tag = shuttle_tag //So that the door can be operated via controller later.


	var/obj/structure/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/R = locate() in staging_area //Grab the controller.
	if(!R)
		log_debug("ERROR CODE EV1.5: could not find controller in [shuttle_tag].")
		to_world(SPAN_DEBUG("ERROR CODE EV1: could not find controller in [shuttle_tag]."))
		return FALSE

	//Set the tags.
	R.id_tag = shuttle_tag //Set tag.
	R.tag_door = shuttle_tag //Set the door tag.
	R.evacuation_program = new(R) //Make a new program with the right parent-child relationship. Make sure the master is specified in new().
	//R.docking_program = R.evacuation_program //Link them all to the same program, sigh.
	//R.program = R.evacuation_program
	evacuation_program = R.evacuation_program //For the shuttle, to shortcut the controller program.

	cryo_cells = new
	for(var/obj/structure/machinery/cryopod/evacuation/E in staging_area)
		cryo_cells += E
		E.evacuation_program = evacuation_program
	if(!cryo_cells.len)
		log_debug("ERROR CODE EV2: could not find cryo pods in [shuttle_tag].")
		to_world(SPAN_DEBUG("ERROR CODE EV2: could not find cryo pods in [shuttle_tag]."))
		return FALSE

#define MOVE_MOB_OUTSIDE \
for(var/obj/structure/machinery/cryopod/evacuation/C in cryo_cells) C.go_out()

/datum/shuttle/ferry/marine/evacuation_pod/proc/toggle_ready()
	switch(evacuation_program.dock_state)
		if(STATE_IDLE)
			evacuation_program.dock_state = STATE_READY
			spawn()
				D.unlock()
				D.open()
				D.lock()
		if(STATE_READY)
			evacuation_program.dock_state = STATE_IDLE
			MOVE_MOB_OUTSIDE
			spawn(250)
				D.unlock()
				D.close()
				D.lock()

/datum/shuttle/ferry/marine/evacuation_pod/proc/prepare_for_launch()
	if(!can_launch())
		return FALSE //Can't launch in some circumstances.
	evacuation_program.dock_state = STATE_LAUNCHING
	spawn()
		D.unlock()
		D.close()
		D.lock()
	evacuation_program.prepare_for_undocking()
	sleep(31)
	if(!check_passengers())
		evacuation_program.dock_state = STATE_BROKEN
		explosion(evacuation_program.master, -1, -1, 3, 4, , , , create_cause_data("escape pod malfunction"))
		sleep(25)
		staging_area.lighting_use_dynamic = TRUE
		staging_area.initialize_power_and_lighting(TRUE) //We want to reinitilize power usage and turn off everything.

		MOVE_MOB_OUTSIDE
		spawn()
			D.unlock()
			D.open()
			D.lock()
		evacuation_program.master.state(SPAN_WARNING("WARNING: Maximum weight limit reached, pod unable to launch. Warning: Thruster failure detected."))
		return FALSE
	launch()
	return TRUE

#undef MOVE_MOB_OUTSIDE

/*
You could potentially make stuff like crypods in these, but they should generally not be allowed to build inside pods.
This can probably be done a lot more elegantly either way, but it'll suffice for now.
*/
/datum/shuttle/ferry/marine/evacuation_pod/proc/check_passengers(var/msg = "")
	. = TRUE
	var/n = 0 //Generic counter.
	var/mob/M
	for(var/obj/structure/machinery/cryopod/evacuation/C in cryo_cells)
		if(C.occupant)
			n++
			if(C.occupant.stat != DEAD && msg)
				to_chat(C.occupant, msg)
	//Hardcoded typecast, which should be changed into some weight system of some kind eventually.
	var/area/A = msg ? evacuation_program.master.loc.loc : staging_area //Before or after launch.
	for(var/i in A)
		if(istype(i, /obj/structure/closet))
			M = locate(/mob/living/carbon/human) in i
			if(M)
				n++ //No hiding in closets.
				if(M.stat != DEAD && msg)
					to_chat(M, msg)
		else if(istype(i, /mob/living/carbon/human) || isrobot(i))
			n++ //Dead or alive, counts as a thing.
			M = i
			if(M.stat != DEAD && msg)
				to_chat(M, msg)
		else if(istype(i, /mob/living/carbon/Xenomorph))
			var/mob/living/carbon/Xenomorph/X = i
			if(X.mob_size >= MOB_SIZE_BIG)
				return FALSE //Huge xenomorphs will automatically fail the launch.
			n++
			if(X.stat != DEAD && msg)
				to_chat(X, msg)
	if(n > cryo_cells.len)  . = FALSE //Default is 3 cryo cells and three people inside the pod.
	if(msg)
		passengers += n //Return the total number of occupants instead if it successfully launched.
		return TRUE

//=========================================================================================
//==================================Console Object=========================================
//=========================================================================================
/*
These were written by a crazy person, so that datums are constantly inserted for child objects,
the same datums that serve a similar purpose all-around. Incredibly stupid, but there you go.
As such, a new tracker datum must be constructed to follow proper child inheritance.
*/

//This controller goes on the escape pod itself.
/obj/structure/machinery/embedded_controller/radio/simple_docking_controller/escape_pod
	name = "escape pod controller"
	unslashable = TRUE
	unacidable = TRUE
	var/datum/computer/file/embedded_program/docking/simple/escape_pod/evacuation_program //Runs the doors and states.
	//door_tag is the tag for the pod door.
	//id_tag is the generic connection tag.
	//TODO make sure you can't C4 this.

/obj/structure/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/ex_act(severity)
	return FALSE

// TGUI stufferinos \\

/obj/structure/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/attack_hand(mob/user)
	if(..())
		return
	tgui_interact(user)

/obj/structure/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EscapePodConsole", "[src.name]")
		ui.open()

/obj/structure/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE

/obj/structure/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/ui_data(mob/user)
	var/list/data = list()
	var/launch_status[] = evacuation_program.check_launch_status()
	var/datum/shuttle/ferry/marine/evacuation_pod/P = shuttle_controller.shuttles[id_tag]

	data["docking_status"] = evacuation_program.dock_state
	data["door_state"] = P.D.density
	data["door_lock"] = P.D.locked
	data["can_delay"] = launch_status[2]

	return data

/obj/structure/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/datum/shuttle/ferry/marine/evacuation_pod/P = shuttle_controller.shuttles[id_tag]

	switch(action)
		if("force_launch")
			P.prepare_for_launch()
			. = TRUE
		if("delay_launch")
			evacuation_program.dock_state = evacuation_program.dock_state == STATE_DELAYED ? STATE_READY : STATE_DELAYED
			. = TRUE
		if("lock_door")
			if(P.D.density) //Closed
				P.D.unlock()
				P.D.open()
				P.D.lock()
			else //Open
				P.D.unlock()
				P.D.close()
				P.D.lock()
			. = TRUE


// TGUI stuff END \\

//=========================================================================================
//================================Controller Program=======================================
//=========================================================================================

//A docking controller program for a simple door based docking port
/datum/computer/file/embedded_program/docking/simple/escape_pod
	dock_state = STATE_IDLE //Controls the state of the docking. We manipulate it directly and add a few more to the default.
	//master is the console object.
	//door_tag is the tag for the pod door.
	//id_tag is the generic connection tag.

	//receive_user_command(command)
	//	if(dock_state == STATE_READY)
	//		..(command)

	prepare_for_undocking()
		playsound(master,'sound/effects/escape_pod_warmup.ogg', 50, 1)
		//close_door()

/datum/computer/file/embedded_program/docking/simple/escape_pod/proc/check_launch_status()
	var/datum/shuttle/ferry/marine/evacuation_pod/P = shuttle_controller.shuttles[id_tag]
	. = list(P.can_launch(), P.can_cancel())

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

			if(evacuation_program.dock_state < STATE_READY)
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

		if(evacuation_program.dock_state < STATE_READY)
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
	name = "\improper Evacuation Airlock"
	icon = 'icons/obj/structures/doors/pod_doors.dmi'
	heat_proof = 1
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/machinery/door/airlock/evacuation/Initialize()
	. = ..()
	INVOKE_ASYNC(src, .proc/lock)

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

#undef STATE_IDLE
#undef STATE_READY
#undef STATE_BROKEN
#undef STATE_LAUNCHED

/*
//Leaving this commented out for the CL pod, which should have a way to open from the outside.

//This controller is for the escape pod berth (station side)
/obj/structure/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth
	name = "escape pod berth controller"

/obj/structure/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth/Initialize()
	. = ..()
	docking_program = new/datum/computer/file/embedded_program/docking/simple/escape_pod(src)
	program = docking_program

/obj/structure/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/armed = null
	if (istype(docking_program, /datum/computer/file/embedded_program/docking/simple/escape_pod))
		var/datum/computer/file/embedded_program/docking/simple/escape_pod/P = docking_program
		armed = P.armed

	var/data[] = list(
		"docking_status" = docking_program.get_docking_status(),
		"override_enabled" = docking_program.override_enabled,
		"armed" = armed,
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "escape_pod_berth_console.tmpl", name, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
*/
