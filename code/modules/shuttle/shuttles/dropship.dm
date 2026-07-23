/obj/docking_port/mobile/marine_dropship
	width = 11
	height = 21

	dwidth = 5
	dheight = 10

	preferred_direction = SOUTH
	callTime = DROPSHIP_TRANSIT_DURATION
	rechargeTime = SHUTTLE_RECHARGE
	ignitionTime = DROPSHIP_WARMUP_TIME
	prearrivalTime = DROPSHIP_WARMUP_TIME
	var/datum/door_controller/aggregate/door_control

	// Door control has been overridden
	var/door_override = FALSE

	// Is in gun-run mode
	var/in_flyby = FALSE

	// Is hijacked by opfor
	var/is_hijacked = FALSE
	var/datum/dropship_hijack/almayer/hijack
	// CAS gear
	var/list/obj/structure/dropship_equipment/equipments = list()

	// dropship automated target
	var/automated_hangar_id
	var/automated_lz_id
	var/automated_delay
	var/automated_timer
	var/datum/cas_signal/paradrop_signal
	var/faction = FACTION_MARINE

/obj/docking_port/mobile/marine_dropship/Initialize(mapload)
	. = ..()
	door_control = new()
	for(var/place in shuttle_areas)
		for(var/obj/structure/machinery/door/air in place)
			switch(air.id)
				if("starboard_door")
					door_control.add_door(air, "starboard")
				if("port_door")
					door_control.add_door(air, "port")
				if("aft_door")
					door_control.add_door(air, "aft")

			var/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/hatch = air
			if(istype(hatch))
				hatch.linked_dropship = src

	RegisterSignal(src, COMSIG_DROPSHIP_ADD_EQUIPMENT, PROC_REF(add_equipment))
	RegisterSignal(src, COMSIG_DROPSHIP_REMOVE_EQUIPMENT, PROC_REF(remove_equipment))
	RegisterSignal(src, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_dir_change))

/obj/docking_port/mobile/marine_dropship/Destroy(force)
	. = ..()
	qdel(door_control)
	UnregisterSignal(src, COMSIG_DROPSHIP_ADD_EQUIPMENT)
	UnregisterSignal(src, COMSIG_DROPSHIP_REMOVE_EQUIPMENT)
	UnregisterSignal(src, COMSIG_ATOM_DIR_CHANGE)

/obj/docking_port/mobile/marine_dropship/proc/send_for_flyby()
	in_flyby = TRUE
	var/obj/docking_port/stationary/docked_at = get_docked()
	SSshuttle.moveShuttle(src.id, docked_at.id, TRUE)

/obj/docking_port/mobile/marine_dropship/proc/add_equipment(obj/docking_port/mobile/marine_dropship/dropship, obj/structure/dropship_equipment/equipment)
	SIGNAL_HANDLER
	equipments += equipment

/obj/docking_port/mobile/marine_dropship/proc/remove_equipment(obj/docking_port/mobile/marine_dropship/dropship, obj/structure/dropship_equipment/equipment)
	SIGNAL_HANDLER
	equipments -= equipment

/obj/docking_port/mobile/marine_dropship/proc/get_door_data()
	return door_control.get_data()

/obj/docking_port/mobile/marine_dropship/proc/control_doors(action, direction, force, asynchronous = TRUE)
	// its been locked down by the queen
	if(door_override)
		return
	door_control.control_doors(action, direction, force, asynchronous)

/obj/docking_port/mobile/marine_dropship/proc/is_door_locked(direction)
	return door_control.is_door_locked(direction)

/obj/docking_port/mobile/marine_dropship/enterTransit()
	. = ..()
	if(SSticker?.mode && !(SSticker.mode.flags_round_type & MODE_DS_LANDED) && !in_flyby && is_ground_level(destination?.z)) //Launching on first drop.
		SSticker.mode.ds_first_drop(src)

/obj/docking_port/mobile/marine_dropship/beforeShuttleMove(turf/newT, rotation, move_mode, obj/docking_port/mobile/moving_dock)
	. = ..()
	control_doors("force-lock-launch", "all", force=TRUE, asynchronous = FALSE)

/obj/docking_port/mobile/marine_dropship/proc/on_dir_change(datum/source, old_dir, new_dir)
	SIGNAL_HANDLER
	for(var/place in shuttle_areas)
		for(var/obj/structure/machinery/door/air in place)
			air.handle_multidoor(old_dir, new_dir)

/obj/docking_port/mobile/marine_dropship/alamo
	name = "Alamo"
	id = DROPSHIP_ALAMO
	preferred_direction = SOUTH // If you are changing this, please update the dir of the path below as well

/obj/docking_port/mobile/marine_dropship/alamo/get_transit_path_type()
	return /turf/open/space/transit/dropship/alamo

/obj/docking_port/mobile/marine_dropship/normandy
	name = "Normandy"
	id = DROPSHIP_NORMANDY
	preferred_direction = SOUTH // If you are changing this, please update the dir of the path below as well

/obj/docking_port/mobile/marine_dropship/normandy/get_transit_path_type()
	return /turf/open/space/transit/dropship/normandy

/obj/docking_port/mobile/marine_dropship/saipan
	name = "Saipan"
	id = DROPSHIP_SAIPAN
	preferred_direction = SOUTH // If you are changing this, please update the dir of the path below as well

/obj/docking_port/mobile/marine_dropship/saipan/get_transit_path_type()
	return /turf/open/space/transit/dropship/saipan

/obj/docking_port/mobile/marine_dropship/morana
	name = "Morana"
	id = DROPSHIP_MORANA
	preferred_direction = SOUTH // If you are changing this, please update the dir of the path below as well
	faction = FACTION_UPP

/obj/docking_port/mobile/marine_dropship/morana/get_transit_path_type()
	return /turf/open/space/transit/dropship/morana

/obj/docking_port/mobile/marine_dropship/devana
	name = "Devana"
	id = DROPSHIP_DEVANA
	preferred_direction = SOUTH // If you are changing this, please update the dir of the path below as well
	faction = FACTION_UPP

/obj/docking_port/mobile/marine_dropship/devana/get_transit_path_type()
	return /turf/open/space/transit/dropship/devana


/obj/docking_port/mobile/marine_dropship/check()
	. = ..()

	if(mode == SHUTTLE_CRASHED)
		return

	var/obj/docking_port/stationary/marine_dropship/dropzone = destination
	if(mode == SHUTTLE_PREARRIVAL && dropzone && !dropzone.landing_lights_on)
		if(istype(destination, /obj/docking_port/stationary/marine_dropship))
			dropzone.turn_on_landing_lights()
		playsound(dropzone.return_center_turf(), landing_sound, 60, 0)
		playsound(return_center_turf(), landing_sound, 60, 0)

	automated_check()

	if(hijack)
		hijack.check()
	else
		sneak_hijack_check()

/// Searches the shuttle_areas for a non-dead, non-iff tagged queen and returns her (or null)
/obj/docking_port/mobile/marine_dropship/proc/find_hijack_queen()
	for(var/area/checked_area in shuttle_areas)
		for(var/mob/living/carbon/xenomorph/queen/checked_queen in checked_area)
			if(checked_queen.stat == DEAD || (FACTION_MARINE in checked_queen.iff_tag?.faction_groups))
				continue
			return checked_queen
	return null

/// Triggers a sneak hijack if not already hijacked, less than 20s left on call, and a hostile queen is aboard
/obj/docking_port/mobile/marine_dropship/proc/sneak_hijack_check()
	if(is_hijacked)
		return FALSE

	if(SSticker.mode?.is_in_endgame)
		return FALSE

	if(GLOB.master_mode != GAMEMODE_DISTRESS_SIGNAL)
		return FALSE

	if(mode != SHUTTLE_CALL)
		return FALSE

	if(timeLeft(1) > 20 SECONDS) // This time must be more than /datum/dropship_hijack/almayer/proc/check_final_approach() time
		return FALSE

	// Not already hijacked, look for a queen
	var/mob/living/carbon/xenomorph/queen/queen = find_hijack_queen()
	if(!queen)
		return FALSE

	// Theres a queen that snuck on!
	// Replicate most of /obj/structure/machinery/computer/shuttle/dropship/flight/proc/hijack...
	hijack = new()
	hijack.shuttle = src
	SShijack.on_call_shuttle()
	hijack.target_crash_site(pick(GLOB.almayer_ship_sections - GLOB.almayer_aa_cannon?.protecting_section))

	crashing = TRUE
	is_hijacked = TRUE

	// /datum/dropship_hijack/almayer/proc/fire() stuff
	destination = hijack.crash_site
	GLOB.alt_ctrl_disabled = TRUE

	SShijack.hijack_general_quarters()
	var/ares_message = "Unidentified lifesigns detected onboard. Hijack likely. Shutting down autopilot."
	marine_announcement(ares_message, "Dropship Alert", logging=ARES_LOG_SECURITY)
	log_ares_flight("Unknown", ares_message)
	playsound(src, 'sound/misc/queen_alarm.ogg')

	xeno_message(SPAN_XENOANNOUNCE("The metal bird is arriving at the metal hive in the sky!"), 3, queen.hivenumber)
	xeno_message(SPAN_XENOANNOUNCE("The hive swells with power! You will now steadily gain pooled larva over time."), 2, queen.hivenumber)
	var/datum/hive_status/hive = queen.hive
	hive.bless_on_hijack()
	hive.abandon_on_hijack()

	// Notify the yautja too so they stop the hunt
	elder_overseer_message("The serpent Queen has snuck on a landing shuttle.")

	// Also some /obj/structure/machinery/computer/shuttle/dropship/flight/attack_alien() stuff
	if(!MODE_HAS_MODIFIER(/datum/gamemode_modifier/lz_weeding))
		MODE_SET_MODIFIER(/datum/gamemode_modifier/lz_weeding, TRUE)

	var/obj/structure/machinery/computer/shuttle/dropship/flight/console = getControlConsole()
	if(console)
		console.balloon_alert_to_viewers("autopilot disabled!")
		console.dropship_control_lost = TRUE
		console.update_icon()

	return TRUE

/obj/docking_port/mobile/marine_dropship/proc/automated_check()
	var/obj/structure/machinery/computer/shuttle/dropship/flight/root_console = getControlConsole()
	if(!root_console || root_console.dropship_control_lost || SShijack.in_ftl || SShijack.hijack_status >= HIJACK_OBJECTIVES_GROUND_CRASH)
		automated_hangar_id = null
		automated_lz_id = null
		automated_delay = null
		return

	if(automated_hangar_id && automated_lz_id && automated_delay && !automated_timer && mode == SHUTTLE_IDLE)
		var/obj/docking_port/stationary/marine_dropship/docked_at = get_docked()
		if(faction == FACTION_MARINE)
			ai_silent_announcement("The [name] will automatically depart from [docked_at.name] in [automated_delay * 0.1] seconds.")

		automated_timer = addtimer(CALLBACK(src, PROC_REF(automated_fly)), automated_delay, TIMER_STOPPABLE)

/obj/docking_port/mobile/marine_dropship/proc/automated_fly()
	automated_timer = null
	if(!automated_hangar_id || !automated_lz_id || !automated_delay)
		return
	var/obj/structure/machinery/computer/shuttle/dropship/flight/root_console = getControlConsole()
	if(root_console.dropship_control_lost)
		return
	if(mode != SHUTTLE_IDLE)
		return
	var/obj/docking_port/stationary/marine_dropship/docked_at = get_docked()
	var/target_id = (docked_at?.id == automated_hangar_id) ? automated_lz_id : automated_hangar_id
	SSshuttle.moveShuttle(id, target_id, TRUE)
	if(faction == FACTION_MARINE)
		ai_silent_announcement("Dropship '[name]' departing from [docked_at.name].")

/obj/docking_port/stationary/marine_dropship
	dir = NORTH
	width = 11
	height = 21
	dwidth = 5
	dheight = 10

	var/auto_open = FALSE
	var/xeno_announce = FALSE
	var/faction = FACTION_MARINE

/obj/docking_port/stationary/marine_dropship/Destroy()
	. = ..()
	for(var/obj/structure/machinery/landinglight/light in landing_lights)
		light.linked_port = null
	if(landing_lights)
		landing_lights.Cut()
	landing_lights = null // We didn't make them, so lets leave them
	for(var/obj/structure/machinery/computer/shuttle/dropship/flight/flight_console in GLOB.machines)
		flight_console.compatible_landing_zones -= src

/obj/docking_port/stationary/marine_dropship/on_arrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()
	var/obj/docking_port/mobile/marine_dropship/dropship = arriving_shuttle

	if(auto_open && istype(arriving_shuttle, /obj/docking_port/mobile/marine_dropship))
		dropship.in_flyby = FALSE
		dropship.control_doors("unlock", "all", force=FALSE)
		var/obj/structure/machinery/computer/shuttle/dropship/flight/console = dropship.getControlConsole()
		console?.update_equipment()
	if(is_ground_level(z) && !SSobjectives.first_drop_complete)
		SSticker.mode.ds_first_landed(src)
		SSticker.mode.flags_round_type |= MODE_DS_LANDED

	if(xeno_announce)
		xeno_announcement(SPAN_XENOANNOUNCE("The dropship has landed."), "everything")
		xeno_announce = FALSE

	for(var/obj/structure/dropship_equipment/eq as anything in dropship.equipments)
		eq.on_arrival()

	if(dropship.is_hijacked || !is_mainship_level(z))
		return

	for(var/area/checked_area in dropship.shuttle_areas)
		for(var/mob/living/carbon/xenomorph/checked_xeno in checked_area)
			if(checked_xeno.stat == DEAD || (FACTION_MARINE in checked_xeno.iff_tag?.faction_groups))
				continue
			var/name = "Unidentified Lifesigns"
			var/input = "Unidentified lifesigns detected onboard. Recommendation: lockdown of exterior access ports, including ducting and ventilation."
			shipwide_ai_announcement(input, name, 'sound/AI/unidentified_lifesigns.ogg', ares_logging = ARES_LOG_SECURITY)
			set_security_level(SEC_LEVEL_RED)
			return

/obj/docking_port/stationary/marine_dropship/on_departure(obj/docking_port/mobile/departing_shuttle)
	. = ..()
	var/obj/docking_port/mobile/marine_dropship/dropship = departing_shuttle
	for(var/obj/structure/dropship_equipment/eq as anything in dropship.equipments)
		eq.on_launch()

/obj/docking_port/stationary/marine_dropship/lz1
	name = "LZ1 Landing Zone"
	id = DROPSHIP_LZ1
	auto_open = TRUE

/obj/docking_port/stationary/marine_dropship/lz2
	name = "LZ2 Landing Zone"
	id = DROPSHIP_LZ2
	auto_open = TRUE

/obj/docking_port/stationary/marine_dropship/almayer_hangar_1
	name = "Almayer Hangar bay 1"
	id = ALMAYER_DROPSHIP_LZ1
	auto_open = TRUE
	roundstart_template = /datum/map_template/shuttle/alamo

/obj/docking_port/stationary/marine_dropship/almayer_hangar_2
	name = "Almayer Hangar bay 2"
	id = ALMAYER_DROPSHIP_LZ2
	auto_open = TRUE
	roundstart_template = /datum/map_template/shuttle/normandy

/obj/docking_port/stationary/marine_dropship/upp/hangar_1
	name = "Rostock Hangar bay 1"
	id = UPP_DROPSHIP_LZ1
	faction = "UPP"
	auto_open = TRUE
	roundstart_template = /datum/map_template/shuttle/morana

/obj/docking_port/stationary/marine_dropship/upp/hangar_2
	name = "Rostock Hangar bay 2"
	id = UPP_DROPSHIP_LZ2
	auto_open = TRUE
	roundstart_template = /datum/map_template/shuttle/devana

/obj/docking_port/stationary/marine_dropship/yautja_hangar_1
	name = "Yautja Hangar A"
	id = YAUTJA_HANGAR_A
	auto_open = TRUE
	faction = FACTION_YAUTJA

/obj/docking_port/stationary/marine_dropship/crash_site
	auto_open = TRUE

/obj/docking_port/stationary/marine_dropship/crash_site/on_prearrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()
	if(istype(arriving_shuttle, /obj/docking_port/mobile/marine_dropship))
		var/obj/docking_port/mobile/marine_dropship/ds = arriving_shuttle
		ds.hijack.crash_landing()

/obj/docking_port/stationary/marine_dropship/crash_site/on_arrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()
	arriving_shuttle.set_mode(SHUTTLE_CRASHED)
	for(var/mob/living/carbon/affected_mob in (GLOB.alive_human_list + GLOB.living_xeno_list)) //knock down mobs
		if(!is_mainship_level(affected_mob.z))
			continue
		if(affected_mob && HAS_TRAIT_FROM(affected_mob, TRAIT_UNDENSE, WALL_HIDING_TRAIT))
			to_chat(affected_mob, SPAN_WARNING("You brace yourself against the impact!"))
			continue
		if(affected_mob.buckled)
			to_chat(affected_mob, SPAN_WARNING("You are jolted against [affected_mob.buckled]!"))
			// shake_camera(affected_mob, 3, 1)
		else
			to_chat(affected_mob, SPAN_WARNING("The floor jolts under your feet!"))
			// shake_camera(affected_mob, 10, 1)
			affected_mob.apply_effect(3, WEAKEN)

	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_HIJACK_LANDED)

/obj/docking_port/stationary/marine_dropship/upp
	faction = FACTION_UPP

/datum/map_template/shuttle/alamo
	name = "Alamo"
	shuttle_id = DROPSHIP_ALAMO

/datum/map_template/shuttle/normandy
	name = "Normandy"
	shuttle_id = DROPSHIP_NORMANDY

/datum/map_template/shuttle/saipan
	name = "Saipan"
	shuttle_id = DROPSHIP_SAIPAN

/datum/map_template/shuttle/morana
	name = "Morana"
	shuttle_id = DROPSHIP_MORANA

/datum/map_template/shuttle/devana
	name = "Devana"
	shuttle_id = DROPSHIP_DEVANA
