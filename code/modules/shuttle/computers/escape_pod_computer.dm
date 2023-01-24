#define STATE_IDLE 4 //Pod is idle, not ready to launch.
#define STATE_BROKEN 5 //Pod failed to launch, is now broken.
#define STATE_READY 6 //Pod is armed and ready to go.
#define STATE_DELAYED 7 //Pod is being delayed from launching automatically.
#define STATE_LAUNCHING 8 //Pod is about to launch.
#define STATE_LAUNCHED 9 //Pod has successfully launched.

/obj/structure/machinery/computer/shuttle/escape_pod_panel
	name = "escape pod controller"
	icon = 'icons/obj/structures/machinery/airlock_machines.dmi'
	icon_state = "airlock_control_standby"
	unslashable = TRUE
	unacidable = TRUE
	var/pod_state = STATE_IDLE

/obj/structure/machinery/computer/shuttle/escape_pod_panel/ex_act(severity)
	return FALSE

// TGUI stufferinos \\

/obj/structure/machinery/computer/shuttle/escape_pod_panel/attack_hand(mob/user)
	if(..())
		return
	tgui_interact(user)

/obj/structure/machinery/computer/shuttle/escape_pod_panel/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EscapePodConsole", "[src.name]")
		ui.open()

/obj/structure/machinery/computer/shuttle/escape_pod_panel/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/computer/shuttle/escape_pod_panel/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE

/obj/structure/machinery/computer/shuttle/escape_pod_panel/ui_data(mob/user)
	. = list()
	var/obj/docking_port/mobile/escape_shuttle/shuttle = SSshuttle.getShuttle(shuttleId)

	if(pod_state == STATE_IDLE && shuttle.evac_set)
		pod_state = STATE_READY

	.["docking_status"] = pod_state
	switch(shuttle.mode)
		if(SHUTTLE_CRASHED)
			.["docking_status"] = STATE_BROKEN
		if(SHUTTLE_IGNITING)
			.["docking_status"] = STATE_LAUNCHING
		if(SHUTTLE_CALL)
			.["docking_status"] = STATE_LAUNCHED
	var/obj/structure/machinery/door/door = shuttle.door_handler.doors[1]
	.["door_state"] = door.density
	.["door_lock"] = shuttle.door_handler.is_locked
	.["can_delay"] = TRUE//launch_status[2]


/obj/structure/machinery/computer/shuttle/escape_pod_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/obj/docking_port/mobile/escape_shuttle/shuttle = SSshuttle.getShuttle(shuttleId)
	switch(action)
		if("force_launch")
			shuttle.evac_launch()
			pod_state = STATE_LAUNCHING
			. = TRUE
		if("delay_launch")
			pod_state = pod_state == STATE_DELAYED ? STATE_READY : STATE_DELAYED
			. = TRUE
		if("lock_door")
			if(shuttle.door_handler.doors[1].density) //Closed
				shuttle.door_handler.control_doors("force-unlock")
			else //Open
				shuttle.door_handler.control_doors("force-lock-launch")
			. = TRUE
