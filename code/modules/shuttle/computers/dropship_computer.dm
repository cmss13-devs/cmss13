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

	// Is hijacked by opfor
	var/hijacked = FALSE

	// Is door control locked -- hijack
	var/door_control_lost = FALSE
	var/door_control_cooldown

	// Landing zones which can be used
	var/compatible_landing_zones = list()

/obj/structure/machinery/computer/shuttle/dropship/flight/Initialize(mapload, ...)
	. = ..()
	compatible_landing_zones = get_landing_zones()

/obj/structure/machinery/computer/shuttle/dropship/flight/Destroy()
	. = ..()
	compatible_landing_zones = null

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
	if(hijacked)
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

	if(!hijacked)
		tgui_interact(user)

/obj/structure/machinery/computer/shuttle/dropship/flight/attack_alien(mob/living/carbon/Xenomorph/xeno)
	// door controls being overriden

	if(xeno.caste && xeno.caste.is_intelligent)
		if(!door_control_lost)
			to_chat(xeno, SPAN_XENONOTICE("You override the doors."))
			xeno_message(SPAN_XENOANNOUNCE("The doors of the metal bird have been overridden! Rejoice!"), 3, xeno.hivenumber)

			var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttleId)
			dropship.control_doors("unlock", "all", TRUE)
			door_control_lost = TRUE
			door_control_cooldown = addtimer(CALLBACK(src, PROC_REF(remove_door_lock)), /*SHUTTLE_LOCK_COOLDOWN*/ 30 SECONDS)
			announce_dchat("[xeno] has locked \the [dropship]", src)
			return
		if(isXenoQueen(xeno) && door_control_lost)
			//keyboard
			for(var/i = 0; i < 5; i++)
				playsound(loc, get_sfx("keyboard"), KEYBOARD_SOUND_VOLUME, 1)
				if(!do_after(usr, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
					return
				if(i < 4)
					playsound(loc, 'sound/machines/terminal_error.ogg', KEYBOARD_SOUND_VOLUME, 1)
			playsound(loc, 'sound/machines/terminal_success.ogg', KEYBOARD_SOUND_VOLUME, 1)
			hijack(xeno)

/obj/structure/machinery/computer/shuttle/dropship/flight/proc/hijack(mob/user)

	// select crash location
	/*
	var/list/crash_locations = list()
	crash_locations += list(/area/almayer/hallways/hangar)
	crash_locations += typesof(/area/almayer/medical)
	crash_locations += list(/area/almayer/living/briefing)
	crash_locations += list(/area/almayer/squads/req)
	crash_locations += typesof(/area/almayer/command/cic)
	crash_locations += typesof(/area/almayer/engineering)
	var/result = tgui_input_list(user, "Where to 'land'?", "Dropship Hijack", crash_locations)
	if(!result)
		return
	*/
	// spawn crash location
	var/list/turfs = list()
	for(var/turf/T in get_area_turfs(/area/almayer/command/cic))
		turfs += T

	if(!turfs || !turfs.len)
		to_chat(src, "<span style='color: red;'>No area available.</span>")
		return
	var/turf/target = pick(turfs)

	var/obj/docking_port/stationary/marine_dropship/crash_site/target_site = new()
	target_site.x = target.x
	target_site.y = target.y
	target_site.z = target.z
	target_site.dwidth = 1

	target_site.name = "[shuttleId] crash site"
	target_site.id = "crash_site_[shuttleId]"

	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttleId)
	dropship.crashing = TRUE
	dropship.is_hijacked = TRUE
	hijacked = TRUE

	// move shuttle with long duration
	SSshuttle.moveShuttle(shuttleId, target_site.id, DROPSHIP_CRASH_TRANSIT_DURATION)

	if(round_statistics)
		round_statistics.track_hijack()
	// when launched announce
	// deal with AA
	// DROPSHIP ON COLLISION COURSE. CRASH IMMINENT



/obj/structure/machinery/computer/shuttle/dropship/flight/proc/remove_door_lock()
	if(hijacked)
		return
	playsound(loc, 'sound/machines/terminal_success.ogg', KEYBOARD_SOUND_VOLUME, 1)
	door_control_lost = FALSE
	if(door_control_cooldown)
		door_control_cooldown = null

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
	var/mob/user = usr
	var/obj/docking_port/mobile/marine_dropship/shuttle = SSshuttle.getShuttle(shuttleId)
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
			if(!door_control_lost)
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

