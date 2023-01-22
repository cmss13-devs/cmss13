/obj/structure/machinery/computer/shuttle/dropship/flight
	name = "dropship navigation computer"
	desc = "flight computer for dropship"
	icon = 'icons/obj/structures/machinery/shuttle-parts.dmi'
	icon_state = "console"
	req_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP, ACCESS_WY_CORPORATE_DS)

	// True if we are doing a flyby
	var/is_set_flyby = FALSE

	// Admin disabled
	var/disabled = FALSE

	// Is door control locked -- hijack
	var/dropship_control_lost = FALSE
	var/door_control_cooldown

	// Landing zones which can be used
	var/compatible_landing_zones = list()

	// If the computer is on the dropship or remotely accessing it
	var/is_remote = FALSE

/obj/structure/machinery/computer/shuttle/dropship/flight/remote_control
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "shuttle"
	is_remote = TRUE

/obj/structure/machinery/computer/shuttle/dropship/flight/Initialize(mapload, ...)
	. = ..()
	compatible_landing_zones = get_landing_zones()

/obj/structure/machinery/computer/shuttle/dropship/flight/Destroy()
	. = ..()
	compatible_landing_zones = null

/obj/structure/machinery/computer/shuttle/dropship/flight/proc/get_landing_zones()
	. = list()
	for(var/obj/docking_port/stationary/marine_dropship/dock in SSshuttle.stationary)
		if(istype(dock, /obj/docking_port/stationary/marine_dropship/crash_site))
			continue
		. += list(dock)

/obj/structure/machinery/computer/shuttle/dropship/flight/is_disabled()
	return disabled

/obj/structure/machinery/computer/shuttle/dropship/flight/disable()
	disabled = TRUE

/obj/structure/machinery/computer/shuttle/dropship/flight/enable()
	disabled = FALSE

/obj/structure/machinery/computer/shuttle/dropship/flight/proc/update_equipment(var/optimised=FALSE)
	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttleId)
	var/datum/shuttle/ferry/marine/FM = shuttle_controller.shuttles[shuttleId]

	// initial flight time
	var/flight_duration = DROPSHIP_TRANSIT_DURATION
	if(optimised)
		if(is_set_flyby)
			flight_duration = DROPSHIP_TRANSIT_DURATION * 1.5
		else
			flight_duration = DROPSHIP_TRANSIT_DURATION * SHUTTLE_OPTIMIZE_FACTOR_TRAVEL

	// recharge time before dropship can take off
	var/recharge_duration = SHUTTLE_RECHARGE

	if(optimised)
		recharge_duration = SHUTTLE_RECHARGE * SHUTTLE_OPTIMIZE_FACTOR_RECHARGE

	for(var/obj/structure/dropship_equipment/equipment as anything in FM.equipments)
		// fuel enhancer
		if(istype(equipment, /obj/structure/dropship_equipment/fuel/fuel_enhancer))
			flight_duration = is_set_flyby
				? flight_duration / SHUTTLE_FUEL_ENHANCE_FACTOR_TRAVEL
				: flight_duration * SHUTTLE_FUEL_ENHANCE_FACTOR_TRAVEL

		// cooling system
		if(istype(equipment, /obj/structure/dropship_equipment/fuel/cooling_system))
			recharge_duration = recharge_duration * SHUTTLE_COOLING_FACTOR_RECHARGE

	dropship.callTime = round(flight_duration)
	dropship.rechargeTime = round(recharge_duration)

/obj/structure/machinery/computer/shuttle/dropship/flight/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		var/obj/docking_port/mobile/shuttle = SSshuttle.getShuttle(shuttleId)
		ui = new(user, src, "DropshipFlightControl", "[shuttle.name] Flight Computer")
		ui.open()

/obj/structure/machinery/computer/shuttle/dropship/flight/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE
	if(disabled)
		return UI_UPDATE

/obj/structure/machinery/computer/shuttle/dropship/flight/ui_state(mob/user)
	var/obj/docking_port/mobile/marine_dropship/shuttle = SSshuttle.getShuttle(shuttleId)
	if(shuttle.is_hijacked)
		return GLOB.never_state
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/computer/shuttle/dropship/flight/ui_static_data(mob/user)
	. = ..(user)
	var/obj/docking_port/mobile/shuttle = SSshuttle.getShuttle(shuttleId)
	// we convert the time to seconds for rendering to ui
	.["max_flight_duration"] = shuttle.callTime / 10
	.["max_refuel_duration"] = shuttle.rechargeTime / 10
	.["max_engine_start_duration"] = shuttle.ignitionTime / 10
	.["door_data"] = list("port", "starboard", "aft")

/obj/structure/machinery/computer/shuttle/dropship/flight/attack_hand(mob/user)
	. = ..(user)
	if(.)
		return TRUE

	// if the dropship has crashed don't allow more interactions
	var/obj/docking_port/mobile/marine_dropship/shuttle = SSshuttle.getShuttle(shuttleId)
	if(shuttle.mode == SHUTTLE_CRASHED)
		to_chat(user, SPAN_NOTICE("\The [src] is not responsive"))
		return

	if(!shuttle.is_hijacked)
		tgui_interact(user)

/obj/structure/machinery/computer/shuttle/dropship/flight/attack_alien(mob/living/carbon/Xenomorph/xeno)
	var/obj/docking_port/mobile/shuttle = SSshuttle.getShuttle(shuttleId)
	if(shuttle.mode != SHUTTLE_IDLE || !xeno.caste || !xeno.caste.is_intelligent || is_remote)
		to_chat(xeno, SPAN_NOTICE("Lights flash from the terminal but you can't comprehend their meaning."))
		return

	// door controls being overriden
	if(!dropship_control_lost)
		to_chat(xeno, SPAN_XENONOTICE("You override the doors."))
		xeno_message(SPAN_XENOANNOUNCE("The doors of the metal bird have been overridden! Rejoice!"), 3, xeno.hivenumber)

		var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttleId)
		dropship.control_doors("unlock", "all", TRUE)
		dropship_control_lost = TRUE
		door_control_cooldown = addtimer(CALLBACK(src, PROC_REF(remove_door_lock)), SHUTTLE_LOCK_COOLDOWN)
		announce_dchat("[xeno] has locked \the [dropship]", src)
		return

	if(isXenoQueen(xeno) && dropship_control_lost)
		//keyboard
		for(var/i = 0; i < 5; i++)
			playsound(loc, get_sfx("keyboard"), KEYBOARD_SOUND_VOLUME, 1)
			if(!do_after(usr, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
				return
			if(i < 4)
				playsound(loc, 'sound/machines/terminal_error.ogg', KEYBOARD_SOUND_VOLUME, 1)
		playsound(loc, 'sound/machines/terminal_success.ogg', KEYBOARD_SOUND_VOLUME, 1)
		hijack(xeno)
		return


/obj/structure/machinery/computer/shuttle/dropship/flight/proc/hijack(mob/user)

	// select crash location
	var/result = tgui_input_list(user, "Where to 'land'?", "Dropship Hijack", almayer_ship_sections)
	if(!result)
		return
	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttleId)
	var/datum/dropship_hijack/almayer/hijack = new()
	dropship.hijack = hijack
	hijack.shuttle = dropship
	hijack.target_crash_site(result)

	dropship.crashing = TRUE
	dropship.is_hijacked = TRUE

	hijack.fire()

	// when launched announce


/obj/structure/machinery/computer/shuttle/dropship/flight/proc/remove_door_lock()
	var/obj/docking_port/mobile/marine_dropship/shuttle = SSshuttle.getShuttle(shuttleId)
	if(shuttle.is_hijacked)
		return
	playsound(loc, 'sound/machines/terminal_success.ogg', KEYBOARD_SOUND_VOLUME, 1)
	dropship_control_lost = FALSE
	if(door_control_cooldown)
		door_control_cooldown = null

/obj/structure/machinery/computer/shuttle/dropship/flight/ui_data(mob/user)
	var/obj/docking_port/mobile/marine_dropship/shuttle = SSshuttle.getShuttle(shuttleId)
	. = list()
	.["shuttle_mode"] = shuttle.mode
	.["flight_time"] = shuttle.timeLeft(0)
	.["is_disabled"] = disabled || shuttle.is_hijacked
	.["locked_down"] = FALSE
	.["can_fly_by"] = !is_remote
	.["can_set_automated"] = is_remote
	if(shuttle.destination)
		.["target_destination"] = shuttle.in_flyby? "Flyby" : shuttle.destination.name
	.["destinations"] = list()

	.["door_status"] = is_remote ? list() : shuttle.get_door_data()

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
	var/obj/docking_port/mobile/marine_dropship/shuttle = SSshuttle.getShuttle(shuttleId)
	if(disabled || shuttle.is_hijacked)
		return
	var/mob/user = usr
	switch(action)
		if("move")
			update_equipment(FALSE)
			if(shuttle.mode != SHUTTLE_IDLE)
				to_chat(user, SPAN_WARNING("You can't move to a new destination whilst in transit."))
				return TRUE
			if(is_set_flyby)
				to_chat(user, SPAN_NOTICE("You begin the launch sequence for a flyby."))
				shuttle.send_for_flyby()
				return TRUE
			var/dockId = params["target"]
			var/list/local_data = ui_data(user)
			var/found = FALSE
			playsound(loc, get_sfx("terminal_button"), KEYBOARD_SOUND_VOLUME, 1)
			for(var/destination in local_data["destinations"])
				if(destination["id"] == dockId)
					found = TRUE
					break
			if(!found)
				log_admin("[key_name(user)] may be attempting a href dock exploit on [src] with target location \"[dockId]\"")
				to_chat(user, SPAN_WARNING("The [dockId] dock is not available at this time."))
				return
			var/obj/docking_port/stationary/dock = SSshuttle.getDock(dockId)
			var/dock_reserved = FALSE
			for(var/obj/docking_port/mobile/other_shuttle in SSshuttle.mobile)
				if(dock == other_shuttle.destination)
					dock_reserved = TRUE
					break
			if(dock_reserved)
				to_chat(user, SPAN_WARNING("\The [dock] is currently in use."))
				return TRUE
			SSshuttle.moveShuttle(shuttle.id, dock.id, TRUE)
			to_chat(user, SPAN_NOTICE("You begin the launch sequence to [dock]."))
			return TRUE
		if("button-push")
			playsound(loc, get_sfx("terminal_button"), KEYBOARD_SOUND_VOLUME, 1)
			return FALSE
		if("door-control")
			if(shuttle.mode == SHUTTLE_CALL || shuttle.mode == SHUTTLE_RECALL)
				return TRUE
			var/interaction = params["interaction"]
			var/location = params["location"]
			if(!dropship_control_lost)
				shuttle.control_doors(interaction, location)
			else
				playsound(loc, 'sound/machines/terminal_error.ogg', KEYBOARD_SOUND_VOLUME, 1)
				to_chat(user, SPAN_WARNING("Door controls have been overridden. Please call technical support."))
		if("set-ferry")
			is_set_flyby = FALSE
		if("set-flyby")
			is_set_flyby = TRUE
		if("cancel-flyby")
			if(shuttle.in_flyby && shuttle.timer && shuttle.timeLeft(1) >= DROPSHIP_WARMUP_TIME)
				shuttle.setTimer(DROPSHIP_WARMUP_TIME)

