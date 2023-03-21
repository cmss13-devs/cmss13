/obj/structure/machinery/computer/shuttle/dropship/flight
	name = "dropship navigation computer"
	desc = "flight computer for dropship"
	icon = 'icons/obj/structures/machinery/shuttle-parts.dmi'
	icon_state = "console"
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP)
	unacidable = TRUE
	exproof = TRUE
	needs_power = FALSE

	// True if we are doing a flyby
	var/is_set_flyby = FALSE

	// Admin disabled
	var/disabled = FALSE

	// Is door control locked -- hijack
	var/dropship_control_lost = FALSE
	var/door_control_cooldown

	// Allows admins to var edit the time lock away.
	var/skip_time_lock = FALSE

	// Landing zones which can be used
	var/compatible_landing_zones = list()

	// If the computer is on the dropship or remotely accessing it
	var/is_remote = FALSE

	// linked lz id (lz1, lz2 or null)
	var/linked_lz

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

/obj/structure/machinery/computer/shuttle/dropship/flight/proc/update_equipment(optimised=FALSE)
	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttleId)
	if(!dropship)
		return

	// initial flight time
	var/flight_duration =  is_set_flyby ? DROPSHIP_TRANSIT_DURATION : DROPSHIP_TRANSIT_DURATION * GLOB.ship_alt
	if(optimised)
		if(is_set_flyby)
			flight_duration = DROPSHIP_TRANSIT_DURATION * 1.5
		else
			flight_duration = DROPSHIP_TRANSIT_DURATION * SHUTTLE_OPTIMIZE_FACTOR_TRAVEL

	// recharge time before dropship can take off
	var/recharge_duration = SHUTTLE_RECHARGE

	if(optimised)
		recharge_duration = SHUTTLE_RECHARGE * SHUTTLE_OPTIMIZE_FACTOR_RECHARGE

	for(var/obj/structure/dropship_equipment/equipment as anything in dropship.equipments)
		// fuel enhancer
		if(istype(equipment, /obj/structure/dropship_equipment/fuel/fuel_enhancer))
			if(is_set_flyby)
				flight_duration = flight_duration / SHUTTLE_FUEL_ENHANCE_FACTOR_TRAVEL
			else
				flight_duration = flight_duration * SHUTTLE_FUEL_ENHANCE_FACTOR_TRAVEL

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
	if(!skip_time_lock && world.time < SSticker.mode.round_time_lobby + SHUTTLE_TIME_LOCK)
		to_chat(user, SPAN_WARNING("The shuttle is still undergoing pre-flight fueling and cannot depart yet. Please wait another [round((SSticker.mode.round_time_lobby + SHUTTLE_TIME_LOCK-world.time)/600)] minutes before trying again."))
		return UI_CLOSE
	if(dropship_control_lost)
		var/remaining_time = timeleft(door_control_cooldown) / 10
		var/units = "seconds"
		if(remaining_time > 60)
			remaining_time = remaining_time / 60
			units = "minutes"
		to_chat(user, SPAN_WARNING("The shuttle is not responding, try again in [remaining_time] [units]."))
		return UI_CLOSE

/obj/structure/machinery/computer/shuttle/dropship/flight/ui_state(mob/user)
	var/obj/docking_port/mobile/marine_dropship/shuttle = SSshuttle.getShuttle(shuttleId)
	if(shuttle.is_hijacked)
		return GLOB.never_state
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/computer/shuttle/dropship/flight/ui_static_data(mob/user)
	. = ..(user)
	compatible_landing_zones = get_landing_zones()
	var/obj/docking_port/mobile/shuttle = SSshuttle.getShuttle(shuttleId)
	// we convert the time to seconds for rendering to ui
	.["max_flight_duration"] = shuttle.callTime / 10
	.["max_pre_arrival_duration"] = shuttle.prearrivalTime / 10
	.["max_refuel_duration"] = shuttle.rechargeTime / 10
	.["max_engine_start_duration"] = shuttle.ignitionTime / 10
	.["door_data"] = list("port", "starboard", "aft")

/obj/structure/machinery/computer/shuttle/dropship/flight/attack_hand(mob/user)
	. = ..(user)
	if(.)
		return TRUE

	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return TRUE

	// if the dropship has crashed don't allow more interactions
	var/obj/docking_port/mobile/marine_dropship/shuttle = SSshuttle.getShuttle(shuttleId)
	if(shuttle.mode == SHUTTLE_CRASHED)
		to_chat(user, SPAN_NOTICE("\The [src] is not responsive"))
		return

	if(dropship_control_lost && skillcheck(user, SKILL_PILOT, SKILL_PILOT_EXPERT))
		to_chat(user, SPAN_NOTICE("You start to remove the Queens override."))
		if(!do_after(user, 3 MINUTES, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			to_chat(user, SPAN_WARNING("You fail to remove the Queens override"))
			return
		playsound(loc, 'sound/machines/terminal_success.ogg', KEYBOARD_SOUND_VOLUME, 1)

	if(!shuttle.is_hijacked)
		tgui_interact(user)

/obj/structure/machinery/computer/shuttle/dropship/flight/proc/groundside_alien_action(mob/living/carbon/xenomorph/xeno)
	if(SSticker.mode.active_lz != src)
		to_chat(xeno, SPAN_NOTICE("This terminal is inactive."))
		return

	if(!SSobjectives.first_drop_complete)
		to_chat(xeno, SPAN_NOTICE("This terminal is inactive."))
		return

	var/obj/docking_port/mobile/shuttle = SSshuttle.getShuttle(shuttleId)
	if(linked_lz)
		playsound(loc, 'sound/machines/terminal_success.ogg', KEYBOARD_SOUND_VOLUME, 1)
		if(shuttle.mode == SHUTTLE_IDLE && !is_ground_level(shuttle.z))
			var/result = SSshuttle.moveShuttle(shuttleId, linked_lz, TRUE)
			if(result != DOCKING_SUCCESS)
				to_chat(xeno, SPAN_WARNING("The metal bird can not land here. It might be currently occupied!"))
				return
			to_chat(xeno, SPAN_NOTICE("You command the metal bird to come down. Clever girl."))
			xeno_announcement(SPAN_XENOANNOUNCE("Your Queen has commanded the metal bird to the hive at [linked_lz]."), xeno.hivenumber, XENO_GENERAL_ANNOUNCE)
			return
		if(shuttle.destination.id != linked_lz)
			to_chat(xeno, "The shuttle not ready. The screen reads T-[shuttle.timeLeft(10)]. Have patience.")
			return
		if(shuttle.mode == SHUTTLE_CALL)
			to_chat(xeno, "The shuttle is in flight. The screen reads T-[shuttle.timeLeft(10)]. Have patience.")
			return
		if(shuttle.mode == SHUTTLE_PREARRIVAL)
			to_chat(xeno, "The shuttle is landing. Be ready.")
			return
		if(shuttle.mode == SHUTTLE_IGNITING)
			to_chat(xeno, "The shuttle is launching.")
			return


/obj/structure/machinery/computer/shuttle/dropship/flight/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(!is_ground_level(z))
		to_chat(xeno, SPAN_NOTICE("Lights flash from the terminal but you can't comprehend their meaning."))
		playsound(loc, 'sound/machines/terminal_error.ogg', KEYBOARD_SOUND_VOLUME, 1)
		return

	if(xeno.hive_pos != XENO_QUEEN)
		to_chat(xeno, SPAN_NOTICE("Lights flash from the terminal but you can't comprehend their meaning."))
		playsound(loc, 'sound/machines/terminal_error.ogg', KEYBOARD_SOUND_VOLUME, 1)
		return

	if(is_remote)
		groundside_alien_action(xeno)
		return

	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttleId)
	if(dropship.is_hijacked)
		return

	// door controls being overriden
	if(!dropship_control_lost)
		to_chat(xeno, SPAN_XENONOTICE("You override the doors."))
		xeno_message(SPAN_XENOANNOUNCE("The doors of the metal bird have been overridden! Rejoice!"), 3, xeno.hivenumber)
		dropship.control_doors("unlock", "all", TRUE)
		dropship_control_lost = TRUE
		door_control_cooldown = addtimer(CALLBACK(src, PROC_REF(remove_door_lock)), SHUTTLE_LOCK_COOLDOWN, TIMER_STOPPABLE)
		announce_dchat("[xeno] has locked \the [dropship]", src)

		if(!GLOB.resin_lz_allowed)
			set_lz_resin_allowed(TRUE)
		return

	if(dropship_control_lost)
		//keyboard
		for(var/i = 0; i < 5; i++)
			playsound(loc, get_sfx("keyboard"), KEYBOARD_SOUND_VOLUME, 1)
			if(!do_after(usr, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
				return
			if(i < 4)
				playsound(loc, 'sound/machines/terminal_error.ogg', KEYBOARD_SOUND_VOLUME, 1)
		playsound(loc, 'sound/machines/terminal_success.ogg', KEYBOARD_SOUND_VOLUME, 1)
		if(world.time < SHUTTLE_LOCK_TIME_LOCK)
			to_chat(xeno, SPAN_XENODANGER("You can't mobilize the strength to hijack the shuttle yet. Please wait another [time_left_until(SHUTTLE_LOCK_TIME_LOCK, world.time, 1 MINUTES)] minutes before trying again."))
			return
		hijack(xeno)
		return

/obj/structure/machinery/computer/shuttle/dropship/flight/proc/hijack(mob/user)

	// select crash location
	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(shuttleId)
	var/result = tgui_input_list(user, "Where to 'land'?", "Dropship Hijack", almayer_ship_sections)
	if(!result)
		return
	if(dropship.is_hijacked)
		return
	var/datum/dropship_hijack/almayer/hijack = new()
	dropship.hijack = hijack
	hijack.shuttle = dropship
	hijack.target_crash_site(result)

	dropship.crashing = TRUE
	dropship.is_hijacked = TRUE

	hijack.fire()
	GLOB.alt_ctrl_disabled = TRUE
	if(almayer_orbital_cannon)
		almayer_orbital_cannon.is_disabled = TRUE
		addtimer(CALLBACK(almayer_orbital_cannon, .obj/structure/orbital_cannon/proc/enable), 10 MINUTES, TIMER_UNIQUE)

	marine_announcement("Unscheduled dropship departure detected from operational area. Hijack likely. Shutting down autopilot.", "Dropship Alert", 'sound/AI/hijack.ogg')

	var/mob/living/carbon/xenomorph/xeno = user
	xeno_message(SPAN_XENOANNOUNCE("The Queen has commanded the metal bird to depart for the metal hive in the sky! Rejoice!"), 3, xeno.hivenumber)
	xeno_message(SPAN_XENOANNOUNCE("The hive swells with power! You will now steadily gain pooled larva over time."), 2, xeno.hivenumber)
	xeno.hive.abandon_on_hijack()

	// Notify the yautja too so they stop the hunt
	message_all_yautja("The serpent Queen has commanded the landing shuttle to depart.")
	playsound(src, 'sound/misc/queen_alarm.ogg')

	if(istype(SSticker.mode, /datum/game_mode/colonialmarines))
		var/datum/game_mode/colonialmarines/colonial_marines = SSticker.mode
		colonial_marines.add_current_round_status_to_end_results("Hijack")

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
	.["automated_control"] = list(
		"is_automated" = shuttle.automated_hangar_id != null || shuttle.automated_lz_id != null,
		"hangar_lz" = shuttle.automated_hangar_id,
		"ground_lz" = shuttle.automated_lz_id
	)
	.["primary_lz"] = SSticker.mode.active_lz?.linked_lz
	if(shuttle.destination)
		.["target_destination"] = shuttle.in_flyby? "Flyby" : shuttle.destination.name
	.["destinations"] = list()

	.["door_status"] = is_remote ? list() : shuttle.get_door_data()

	.["flight_configuration"] = is_set_flyby ? "flyby" : "ferry"
	.["has_flyby_skill"] = skillcheck(user, SKILL_PILOT, SKILL_PILOT_EXPERT)

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
	var/obj/structure/machinery/computer/shuttle/dropship/flight/comp = shuttle.getControlConsole()
	if(comp.dropship_control_lost)
		to_chat(user, SPAN_WARNING("The dropship isn't responding to controls."))
		return

	switch(action)
		if("move")
			if(shuttle.mode != SHUTTLE_IDLE && (shuttle.mode != SHUTTLE_CALL && !shuttle.destination))
				to_chat(usr, SPAN_WARNING("You can't move to a new destination right now."))
				return TRUE

			if(is_set_flyby && !skillcheck(user, SKILL_PILOT, SKILL_PILOT_EXPERT))
				to_chat(user, SPAN_WARNING("You don't have the skill to perform a flyby."))
				return FALSE
			var/is_optimised = FALSE
			// automatically apply optimisation if user is a pilot
			if(skillcheck(user, SKILL_PILOT, SKILL_PILOT_EXPERT))
				is_optimised = TRUE
			update_equipment(is_optimised)
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
			msg_admin_niche("[key_name_admin(usr)] set the dropship [src.shuttleId] into transport")
		if("set-flyby")
			is_set_flyby = TRUE
			msg_admin_niche("[key_name_admin(usr)] set the dropship [src.shuttleId] into flyby")
		if("set-automate")
			var/almayer_lz = params["hangar_id"]
			var/ground_lz = params["ground_id"]
			var/delay = Clamp(params["delay"] SECONDS, DROPSHIP_MIN_AUTO_DELAY, DROPSHIP_MAX_AUTO_DELAY)

			// TODO verify
			if(almayer_lz == ground_lz)
				playsound(loc, 'sound/machines/terminal_error.ogg', KEYBOARD_SOUND_VOLUME, 1)
				return
			var/obj/structure/machinery/computer/shuttle/dropship/flight/root_console = shuttle.getControlConsole()
			if(root_console.dropship_control_lost)
				to_chat(user, SPAN_WARNING("The dropships main controls are not accepting the order."))
				playsound(loc, 'sound/machines/terminal_error.ogg', KEYBOARD_SOUND_VOLUME, 1)
				return

			shuttle.automated_hangar_id = almayer_lz
			shuttle.automated_lz_id = ground_lz
			shuttle.automated_delay = delay
			playsound(loc, get_sfx("terminal_button"), KEYBOARD_SOUND_VOLUME, 1)
			message_admins("[key_name_admin(usr)] has set auto pilot on '[shuttle.name]'")
			return
			/* TODO
				if(!dropship.automated_launch) //If we're toggling it on...
					var/auto_delay
					auto_delay = tgui_input_number(usr, "Set the delay for automated departure after recharging (seconds)", "Automated Departure Settings", DROPSHIP_MIN_AUTO_DELAY/10, DROPSHIP_MAX_AUTO_DELAY/10, DROPSHIP_MIN_AUTO_DELAY/10)
					dropship.automated_launch_delay = Clamp(auto_delay SECONDS, DROPSHIP_MIN_AUTO_DELAY, DROPSHIP_MAX_AUTO_DELAY)
					dropship.set_automated_launch(!dropship.automated_launch)
			*/
		if("disable-automate")
			shuttle.automated_hangar_id = null
			shuttle.automated_lz_id = null
			shuttle.automated_delay = null
			playsound(loc, get_sfx("terminal_button"), KEYBOARD_SOUND_VOLUME, 1)
			message_admins("[key_name_admin(usr)] has removed auto pilot on '[shuttle.name]'")
			return

		if("cancel-flyby")
			if(shuttle.in_flyby && shuttle.timer && shuttle.timeLeft(1) >= DROPSHIP_WARMUP_TIME)
				shuttle.setTimer(DROPSHIP_WARMUP_TIME)

/obj/structure/machinery/computer/shuttle/dropship/flight/lz1
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "shuttle"
	linked_lz = DROPSHIP_LZ1
	shuttleId = DROPSHIP_ALAMO
	is_remote = TRUE

/obj/structure/machinery/computer/shuttle/dropship/flight/lz2
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "shuttle"
	linked_lz = DROPSHIP_LZ2
	shuttleId = DROPSHIP_NORMANDY
	is_remote = TRUE

/obj/structure/machinery/computer/shuttle/dropship/flight/remote_control
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "shuttle"
	is_remote = TRUE
	needs_power = TRUE
