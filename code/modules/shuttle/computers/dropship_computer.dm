/obj/structure/machinery/computer/shuttle/dropship/flight
	name = "dropship navigation computer"
	desc = "flight computer for dropship"
	icon = 'icons/obj/structures/machinery/shuttle-parts.dmi'
	icon_state = "console"
	req_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP, ACCESS_WY_CORPORATE_DS)
	var/is_set_flyby = FALSE
	var/disabled = FALSE
	var/compatible_landing_zones = list()

/obj/structure/machinery/computer/shuttle/dropship/flight/Initialize(mapload, ...)
	. = ..()
	compatible_landing_zones = get_landing_zones()

/obj/structure/machinery/computer/shuttle/dropship/flight/proc/get_landing_zones()
	. = list()
	for(var/obj/docking_port/stationary/marine_dropship/dock in SSshuttle.stationary)
		. += list(dock)

/obj/structure/machinery/computer/shuttle/dropship/flight/is_disabled()
	return disabled

/obj/structure/machinery/computer/shuttle/dropship/flight/disable()
	disabled = TRUE

/obj/structure/machinery/computer/shuttle/dropship/flight/enable()
	disabled = FALSE

/obj/structure/machinery/computer/shuttle/dropship/flight/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		var/obj/docking_port/mobile/shuttle = SSshuttle.getShuttle(shuttleId)
		ui = new(user, src, "NavigationShuttle", "[shuttle.name] Flight Computer")
		ui.open()

/obj/structure/machinery/computer/shuttle/dropship/flight/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE
	if(disabled)
		return UI_UPDATE

/obj/structure/machinery/computer/shuttle/dropship/flight/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/computer/shuttle/dropship/flight/ui_static_data(mob/user)
	. = ..(user)
	var/obj/docking_port/mobile/shuttle = SSshuttle.getShuttle(shuttleId)
	// we convert the time to seconds for rendering to ui
	.["max_flight_duration"] = shuttle.callTime / 10
	.["max_refuel_duration"] = shuttle.rechargeTime / 10
	.["max_engine_start_duration"] = shuttle.ignitionTime / 10

/obj/structure/machinery/computer/shuttle/dropship/flight/attack_hand(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	tgui_interact(user)

/obj/structure/machinery/computer/shuttle/dropship/flight/ui_data(mob/user)
	var/obj/docking_port/mobile/marine_dropship/shuttle = SSshuttle.getShuttle(shuttleId)
	. = list()
	.["shuttle_mode"] = shuttle.mode
	.["flight_time"] = shuttle.timeLeft(0)
	.["is_disabled"] = disabled
	.["locked_down"] = FALSE
	if(shuttle.destination)
		.["target_destination"] = shuttle.in_flyby? "Flyby" : shuttle.destination.name
	.["destinations"] = list()
	.["door_status"] = shuttle.get_door_data()
	.["flight_configuration"] = is_set_flyby ? "flyby" : "ferry"

	for(var/obj/docking_port/stationary/dock in compatible_landing_zones)
		var/dock_reserved = FALSE
		for(var/obj/docking_port/mobile/other_shuttle in SSshuttle.mobile)
			if(dock == other_shuttle.destination)
				dock_reserved = TRUE
				break
		var/can_dock = shuttle.canDock(dock)
		var/list/dockinfo = list(
			"id" = dock.id,
			"name" = dock.name,
			"available" = can_dock == SHUTTLE_CAN_DOCK && !dock_reserved,
			"error" = can_dock,
		)
		.["destinations"] += list(dockinfo)

/obj/structure/machinery/computer/shuttle/dropship/flight/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(disabled)
		return
	var/obj/docking_port/mobile/marine_dropship/shuttle = SSshuttle.getShuttle(shuttleId)
	switch(action)
		if("move")
			if(shuttle.mode != SHUTTLE_IDLE)
				to_chat(usr, SPAN_WARNING("You can't move to a new destination whilst in transit."))
				return TRUE
			if(is_set_flyby)
				to_chat(usr, SPAN_NOTICE("You begin the launch sequence for a flyby."))
				shuttle.send_for_flyby()
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
			SSshuttle.moveShuttle(shuttle.id, dock.id, TRUE)
			to_chat(usr, SPAN_NOTICE("You begin the launch sequence to [dock]."))
			return TRUE
		if("button-push")
			playsound(loc, get_sfx("terminal_button"), KEYBOARD_SOUND_VOLUME, 1)
			return FALSE
		if("door-control")
			if(shuttle.mode == SHUTTLE_CALL || shuttle.mode == SHUTTLE_RECALL)
				return TRUE
			var/interaction = params["interaction"]
			var/location = params["location"]
			shuttle.control_doors(interaction, location)
		if("set-ferry")
			is_set_flyby = FALSE
		if("set-flyby")
			is_set_flyby = TRUE
		if("cancel-flyby")
			if(shuttle.in_flyby && shuttle.timer && shuttle.timeLeft(1) >= 5 SECONDS)
				shuttle.setTimer(5 SECONDS)

