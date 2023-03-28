#define KEYBOARD_SOUND_VOLUME 5

/obj/structure/machinery/computer/shuttle
	name = "shuttle console"
	desc = "A shuttle control computer."
	icon_state = "syndishuttle"
	req_access = list( )
// interaction_flags = INTERACT_MACHINE_TGUI
	var/shuttleId
	var/possible_destinations = list()
	var/admin_controlled

/obj/structure/machinery/computer/shuttle/proc/is_disabled()
	return FALSE

/obj/structure/machinery/computer/shuttle/proc/disable()
	return

/obj/structure/machinery/computer/shuttle/proc/enable()
	return

/obj/structure/machinery/computer/shuttle/tgui_interact(mob/user)
	. = ..()
	var/list/options = valid_destinations()
	var/obj/docking_port/mobile/M = SSshuttle.getShuttle(shuttleId)
	var/dat = "Status: [M ? M.getStatusText() : "*Missing*"]<br><br>"
	if(M)
		var/destination_found
		for(var/obj/docking_port/stationary/S in SSshuttle.stationary)
			if(!options.Find(S.id))
				continue
			if(!M.check_dock(S, silent=TRUE))
				continue
			destination_found = TRUE
			dat += "<A href='?src=[REF(src)];move=[S.id]'>Send to [S.name]</A><br>"
		if(!destination_found)
			dat += "<B>Shuttle Locked</B><br>"
			if(admin_controlled)
				dat += "Authorized personnel only<br>"
				dat += "<A href='?src=[REF(src)];request=1]'>Request Authorization</A><br>"

	var/datum/browser/popup = new(user, "computer", "<div align='center'>[M ? M.name : "shuttle"]</div>", 300, 200)
	popup.set_content("<center>[dat]</center>")
	popup.open()

/obj/structure/machinery/computer/shuttle/proc/valid_destinations()
	return params2list(possible_destinations)

/obj/structure/machinery/computer/shuttle/Topic(href, href_list)
	. = ..()
	if(.)
		return

	if(!isqueen(usr) && !allowed(usr))
		to_chat(usr, SPAN_DANGER("Access denied."))
		return TRUE

	if(href_list["move"])
		var/obj/docking_port/mobile/M = SSshuttle.getShuttle(shuttleId)
// if(!(M.shuttle_flags & GAMEMODE_IMMUNE) && world.time < SSticker.round_start_time + SSticker.mode.deploy_time_lock)
// to_chat(usr, SPAN_WARNING("The engines are still refueling."))
// return TRUE
		if(!M.can_move_topic(usr))
			return TRUE
		if(!(href_list["move"] in valid_destinations()))
			log_admin("[key_name(usr)] may be attempting a href dock exploit on [src] with target location \"[href_list["move"]]\"")
// message_admins("[ADMIN_TPMONTY(usr)] may be attempting a href dock exploit on [src] with target location \"[href_list["move"]]\"")
			return TRUE
		var/previous_status = M.mode
		log_game("[key_name(usr)] has sent the shuttle [M] to [href_list["move"]]")
		switch(SSshuttle.moveShuttle(shuttleId, href_list["move"], 1))
			if(DOCKING_SUCCESS)
				if(previous_status != SHUTTLE_IDLE)
					visible_message(SPAN_NOTICE("Destination updated, recalculating route."))
				else
					visible_message(SPAN_NOTICE("Shuttle departing. Please stand away from the doors."))
			if(DOCKING_NULL_SOURCE)
				to_chat(usr, SPAN_WARNING("Invalid shuttle requested."))
				return TRUE
			else
				to_chat(usr, SPAN_NOTICE("Unable to comply."))
				return TRUE

/obj/structure/machinery/computer/shuttle/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock, idnum, override=FALSE)
	if(port && (shuttleId == initial(shuttleId) || override))
		shuttleId = port.id

/obj/structure/machinery/computer/shuttle/ert
	name = "transport shuttle"
	desc = "A transport shuttle flight computer."
	icon_state = "syndishuttle"
	req_access = list()
	breakable = FALSE
	var/disabled = FALSE
	var/compatible_landing_zones = list()

/obj/structure/machinery/computer/shuttle/ert/broken
	name = "nonfunctional shuttle control console"
	disabled = TRUE
	desc = "A transport shuttle flight computer. This one seems broken."

/obj/structure/machinery/computer/shuttle/ert/Initialize(mapload, ...)
	. = ..()
	compatible_landing_zones = get_landing_zones()

/obj/structure/machinery/computer/shuttle/ert/proc/get_landing_zones()
	. = list()
	for(var/obj/docking_port/stationary/emergency_response/dock in SSshuttle.stationary)
		if(!dock.is_external)
			. += list(dock)


/obj/structure/machinery/computer/shuttle/ert/is_disabled()
	return disabled

/obj/structure/machinery/computer/shuttle/ert/disable()
	disabled = TRUE

/obj/structure/machinery/computer/shuttle/ert/enable()
	disabled = FALSE

/obj/structure/machinery/computer/shuttle/ert/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		var/obj/docking_port/mobile/shuttle = SSshuttle.getShuttle(shuttleId)
		ui = new(user, src, "NavigationShuttle", "[shuttle.name] Navigation Computer")
		ui.open()


/obj/structure/machinery/computer/shuttle/ert/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE
	if(disabled)
		return UI_UPDATE


/obj/structure/machinery/computer/shuttle/ert/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/computer/shuttle/ert/ui_static_data(mob/user)
	. = ..(user)
	var/obj/docking_port/mobile/shuttle = SSshuttle.getShuttle(shuttleId)
	// we convert the time to seconds for rendering to ui
	.["max_flight_duration"] = shuttle.callTime / 10
	.["max_refuel_duration"] = shuttle.rechargeTime / 10
	.["max_engine_start_duration"] = shuttle.ignitionTime / 10

/obj/structure/machinery/computer/shuttle/ert/ui_data(mob/user)
	var/obj/docking_port/mobile/emergency_response/ert = SSshuttle.getShuttle(shuttleId)
	. = list()
	.["shuttle_mode"] = ert.mode
	.["flight_time"] = ert.timeLeft(0)
	.["is_disabled"] = disabled

	var/door_count = length(ert.external_doors)
	var/locked_count = 0
	for(var/obj/structure/machinery/door/airlock/air as anything in ert.external_doors)
		if(air.locked)
			locked_count++
	.["locked_down"] = door_count == locked_count

	.["target_destination"] = ert.destination?.name

	.["destinations"] = list()
	for(var/obj/docking_port/stationary/dock in compatible_landing_zones)
		var/dock_reserved = FALSE
		for(var/obj/docking_port/mobile/other_shuttle in SSshuttle.mobile)
			if(dock == other_shuttle.destination)
				dock_reserved = TRUE
				break
		var/can_dock = ert.canDock(dock)
		var/list/dockinfo = list(
			"id" = dock.id,
			"name" = dock.name,
			"available" = can_dock == SHUTTLE_CAN_DOCK && !dock_reserved,
			"error" = can_dock,
		)
		.["destinations"] += list(dockinfo)

/obj/structure/machinery/computer/shuttle/ert/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(disabled)
		return

	var/obj/docking_port/mobile/emergency_response/ert = SSshuttle.getShuttle(shuttleId)
	switch(action)
		if("move")
			if(ert.mode != SHUTTLE_IDLE)
				to_chat(usr, SPAN_WARNING("You can't move to a new destination whilst in transit."))
				return TRUE
			var/dockId = params["target"]
			var/list/local_data = ui_data(usr)
			var/found = FALSE
			playsound(loc, get_sfx("terminal_button"), KEYBOARD_SOUND_VOLUME, 1)
			for(var/destination in local_data["destinations"])
				if(destination["id"] == dockId)
					found = TRUE
					break
			if(!found)
				log_admin("[key_name(usr)] may be attempting a href dock exploit on [src] with target location \"[dockId]\"")
				to_chat(usr, SPAN_WARNING("The [dockId] dock is not available at this time."))
				return
			var/obj/docking_port/stationary/dock = SSshuttle.getDock(dockId)
			var/dock_reserved = FALSE
			for(var/obj/docking_port/mobile/other_shuttle in SSshuttle.mobile)
				if(dock == other_shuttle.destination)
					dock_reserved = TRUE
					break
			if(dock_reserved)
				to_chat(usr, SPAN_WARNING("\The [dock] is currently in use."))
				return TRUE
			SSshuttle.moveShuttle(ert.id, dock.id, TRUE)
			to_chat(usr, SPAN_NOTICE("You begin the launch sequence to [dock]."))
			return TRUE
		if("button-push")
			playsound(loc, get_sfx("terminal_button"), KEYBOARD_SOUND_VOLUME, 1)
			return FALSE
		if("open")
			if(ert.mode == SHUTTLE_CALL || ert.mode == SHUTTLE_RECALL)
				return TRUE
			ert.control_doors("open", external_only = TRUE)
		if("close")
			if(ert.mode == SHUTTLE_CALL || ert.mode == SHUTTLE_RECALL)
				return TRUE
			ert.control_doors("close", external_only = TRUE)
		if("lockdown")
			if(ert.mode == SHUTTLE_CALL || ert.mode == SHUTTLE_RECALL)
				return TRUE
			ert.control_doors("force-lock", external_only = TRUE)
		if("lock")
			if(ert.mode == SHUTTLE_CALL || ert.mode == SHUTTLE_RECALL)
				return TRUE
			ert.control_doors("lock", external_only = TRUE)
		if("unlock")
			if(ert.mode == SHUTTLE_CALL || ert.mode == SHUTTLE_RECALL)
				return TRUE
			ert.control_doors("unlock", external_only = TRUE)

/obj/structure/machinery/computer/shuttle/ert/attack_hand(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	tgui_interact(user)

/obj/structure/machinery/computer/shuttle/ert/small
	name = "transport shuttle"
	desc = "A transport shuttle flight computer."
	icon_state = "comm_alt"
	req_access = list()
	breakable = FALSE

/obj/structure/machinery/computer/shuttle/ert/small/get_landing_zones()
	. = list()
	for(var/obj/docking_port/stationary/emergency_response/dock in SSshuttle.stationary)
		if(istype(dock, /obj/docking_port/stationary/emergency_response/external/hangar_port))
			continue
		if(istype(dock, /obj/docking_port/stationary/emergency_response/external/hangar_starboard))
			continue
		. += list(dock)

/obj/structure/machinery/computer/shuttle/ert/big
	name = "transport shuttle"
	desc = "A transport shuttle flight computer."
	icon_state = "comm_alt"
	req_access = list()
	breakable = FALSE

/obj/structure/machinery/computer/shuttle/ert/big/get_landing_zones()
	. = list()
	for(var/obj/docking_port/stationary/emergency_response/dock in SSshuttle.stationary)
		. += list(dock)

/obj/structure/machinery/computer/shuttle/lifeboat
	name = "lifeboat console"
	desc = "A lifeboat control computer."
	icon_state = "terminal"
	req_access = list()
	breakable = FALSE

/obj/structure/machinery/computer/shuttle/lifeboat/attack_hand(mob/user)
	. = ..()
	var/obj/docking_port/mobile/lifeboat/lifeboat = SSshuttle.getShuttle(shuttleId)
	if(lifeboat.status == LIFEBOAT_LOCKED)
		to_chat(user, SPAN_WARNING("\The [src] flickers with error messages."))
	else if(lifeboat.status == LIFEBOAT_INACTIVE)
		to_chat(user, SPAN_NOTICE("\The [src]'s screen says \"Awaiting evacuation order\"."))
	else if(lifeboat.status == LIFEBOAT_ACTIVE)
		switch(lifeboat.mode)
			if(SHUTTLE_IDLE)
				to_chat(user, SPAN_NOTICE("\The [src]'s screen says \"Awaiting confirmation of the evacuation order\"."))
			if(SHUTTLE_IGNITING)
				to_chat(user, SPAN_NOTICE("\The [src]'s screen says \"Engines firing\"."))
			if(SHUTTLE_CALL)
				to_chat(user, SPAN_NOTICE("\The [src] has flight information scrolling across the screen. The autopilot is working correctly."))

/obj/structure/machinery/computer/shuttle/lifeboat/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(xeno.caste && xeno.caste.is_intelligent)
		var/obj/docking_port/mobile/lifeboat/lifeboat = SSshuttle.getShuttle(shuttleId)
		if(lifeboat.status == LIFEBOAT_LOCKED)
			to_chat(xeno, SPAN_WARNING("We already wrested away control of this metal bird."))
			return XENO_NO_DELAY_ACTION

		xeno_attack_delay(xeno)
		if(do_after(usr, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			if(lifeboat.status != LIFEBOAT_LOCKED)
				lifeboat.status = LIFEBOAT_LOCKED
				lifeboat.available = FALSE
				lifeboat.set_mode(SHUTTLE_IDLE)
				xeno_message(SPAN_XENOANNOUNCE("We have wrested away control of one of the metal birds! They shall not escape!"), 3, xeno.hivenumber)
		return XENO_NO_DELAY_ACTION
	else
		return ..()
