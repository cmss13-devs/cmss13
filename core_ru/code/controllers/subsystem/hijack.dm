/obj/structure/machinery/computer/shuttle/dropship/flight
	var/escape_locked = FALSE

/datum/controller/subsystem/hijack
	var/ship_evac_time
	var/ship_operation_stage_status = OPERATION_DECRYO
	var/shuttles_to_check = list(DROPSHIP_ALAMO, DROPSHIP_NORMANDY)
	var/ship_evacuating = FALSE

/datum/controller/subsystem/hijack/proc/get_ship_operation_stage_status_panel_eta()
	switch(ship_operation_stage_status)
		if(OPERATION_DECRYO) . = "decryo"
		if(OPERATION_BRIEFING) . = "briefing"
		if(OPERATION_FIRST_LANDING) . = "landing"
		if(OPERATION_IN_PROGRESS) . = "working on operation goals"
		if(OPERATION_ENDING) . = "operation ended"
		if(OPERATION_LEAVING_OPERATION_PLACE)
			var/eta = SHIP_ESCAPE_ESTIMATE_DEPARTURE
			. = "time until operation zone leave - ETA [time2text(eta, "hh:mm.ss")]"
		if(OPERATION_DEBRIEFING) . = "accounting results"
		if(OPERATION_CRYO) . = "moving crew to cryo"

//Begins ship runaway
/datum/controller/subsystem/hijack/proc/initiate_ship_evacuation(force = FALSE)
	if((force || !ship_evac_blocked()) && !ship_evacuating)
		ship_evac_time = world.time
		ship_evacuating = TRUE
		ship_operation_stage_status = OPERATION_LEAVING_OPERATION_PLACE
		GLOB.enter_allowed = FALSE
		ai_announcement("Attention. Emergency. All personnel and marines return to the ship immediately, due to the critical situation an immediate process of departure from the area of operation is initiated, boarding shuttles will become unavailable after the [duration2text(SHIP_EVACUATION_AUTOMATIC_DEPARTURE)]!", 'sound/AI/evacuate.ogg', logging = ARES_LOG_SECURITY)
		xeno_message_all("A wave of adrenaline swept through the hive. The creatures of flesh are trying to fly away, we must get to their iron hive now! You have only [duration2text(SHIP_EVACUATION_AUTOMATIC_DEPARTURE)] before they get out of range..")

		for(var/obj/structure/machinery/status_display/cycled_status_display in GLOB.machines)
			if(is_mainship_level(cycled_status_display.z))
				cycled_status_display.set_picture("depart")

		for(var/shuttle_id in shuttles_to_check)
			var/obj/docking_port/mobile/marine_dropship/shuttle = SSshuttle.getShuttle(shuttle_id)
			var/obj/structure/machinery/computer/shuttle/dropship/flight/console = shuttle.getControlConsole()
			console.escape_locked = TRUE
		return TRUE

/datum/controller/subsystem/hijack/proc/shuttels_onboard()
	for(var/shuttle_id in shuttles_to_check)
		var/obj/docking_port/mobile/marine_dropship/shuttle = SSshuttle.getShuttle(shuttle_id)
		if(!shuttle)
			CRASH("Warning, something went wrong at evacuation shuttles check, please review shuttles spelling")
		else if(!is_mainship_level(shuttle.z))
			return shuttle.name
	return FALSE

/datum/controller/subsystem/hijack/proc/ship_evac_blocked()
	if(get_security_level() != "red")
		return "Required RED alert"
	else if(!critical_faction_loses(FACTION_MARINE) && !all_faction_mobs_onboard(FACTION_MARINE))
		return "Not all forces onboard"
	else if(!shuttels_onboard())
		return "All shuttles should be loaded on ship"
	return FALSE

/datum/controller/subsystem/hijack/proc/critical_faction_loses(faction)
	var/alive = 0
	var/dead = 0
	for(var/mob/living/carbon/human/creature as anything in GLOB.human_mob_list)
		if(creature.faction != faction)
			continue
		if(should_block_game_interaction(creature))
			continue
		if(!(creature.job in GLOB.ROLES_MARINES))
			continue
		if(creature.stat == DEAD)
			dead++
		else
			alive++
	if(alive * 4 < dead)
		return TRUE
	return FALSE

/datum/controller/subsystem/hijack/proc/all_faction_mobs_onboard(faction)
	var/total_mobs = 0
	var/non_aboard = 0
	for(var/mob/living/carbon/human/creature as anything in GLOB.human_mob_list)
		if(creature.faction != faction)
			continue
		if(creature.stat != CONSCIOUS || creature.status_flags & XENO_HOST)
			continue
		if(!is_mainship_level(creature.z) && !(creature.status_flags & XENO_HOST))
			non_aboard++
		else
			total_mobs++
	if(non_aboard * 4 < total_mobs)
		return TRUE
	return FALSE

//Cancels the evac procedure. Useful if admins do not want the marines leaving.
/datum/controller/subsystem/hijack/proc/cancel_ship_evacuation(reason)
	if(ship_operation_stage_status == OPERATION_LEAVING_OPERATION_PLACE)
		ship_operation_stage_status = OPERATION_ENDING
		ship_evacuating = FALSE
		GLOB.enter_allowed = TRUE
		ai_announcement(reason, 'sound/AI/evacuate_cancelled.ogg', logging = ARES_LOG_SECURITY)

		for(var/shuttle_id in shuttles_to_check)
			var/obj/docking_port/mobile/marine_dropship/shuttle = SSshuttle.getShuttle(shuttle_id)
			var/obj/structure/machinery/computer/shuttle/dropship/flight/console = shuttle.getControlConsole()
			console.escape_locked = FALSE

		for(var/obj/structure/machinery/status_display/status_display in GLOB.machines)
			if(is_mainship_level(status_display.z))
				status_display.set_picture("redalert")
		return TRUE
