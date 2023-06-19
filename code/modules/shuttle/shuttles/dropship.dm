/obj/docking_port/mobile/marine_dropship
	width = 11
	height = 21
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

/obj/docking_port/mobile/marine_dropship/Destroy(force)
	. = ..()
	qdel(door_control)

/obj/docking_port/mobile/marine_dropship/proc/send_for_flyby()
	in_flyby = TRUE
	var/obj/docking_port/stationary/dockedAt = get_docked()
	SSshuttle.moveShuttle(src.id, dockedAt.id, TRUE)

/obj/docking_port/mobile/marine_dropship/proc/get_door_data()
	return door_control.get_data()

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

/obj/docking_port/mobile/marine_dropship/Destroy(force)
	. = ..()
	qdel(door_control)

/obj/docking_port/mobile/marine_dropship/proc/control_doors(action, direction, force, asynchronous = TRUE)
	// its been locked down by the queen
	if(door_override)
		return
	door_control.control_doors(action, direction, force, asynchronous)

/obj/docking_port/mobile/marine_dropship/proc/is_door_locked(direction)
	return door_control.is_door_locked(direction)

/obj/docking_port/mobile/marine_dropship/enterTransit()
	. = ..()
	if(SSticker?.mode && !(SSticker.mode.flags_round_type & MODE_DS_LANDED)) //Launching on first drop.
		SSticker.mode.ds_first_drop(src)

/obj/docking_port/mobile/marine_dropship/beforeShuttleMove(turf/newT, rotation, move_mode, obj/docking_port/mobile/moving_dock)
	. = ..()
	control_doors("force-lock-launch", "all", force=TRUE, asynchronous = FALSE)

	if(is_hijacked)
		return

	for(var/area/checked_area in shuttle_areas)
		for(var/mob/living/carbon/xenomorph/checked_xeno in checked_area)
			if(checked_xeno.stat == DEAD)
				continue

			var/name = "Unidentified Lifesigns"
			var/input = "Unidentified lifesigns detected onboard. Recommendation: lockdown of exterior access ports, including ducting and ventilation."
			shipwide_ai_announcement(input, name, 'sound/AI/unidentified_lifesigns.ogg')
			set_security_level(SEC_LEVEL_RED)
			return

/obj/docking_port/mobile/marine_dropship/alamo
	name = "Alamo"
	id = DROPSHIP_ALAMO

/obj/docking_port/mobile/marine_dropship/normandy
	name = "Normandy"
	id = DROPSHIP_NORMANDY

/obj/docking_port/mobile/marine_dropship/check()
	. = ..()

	if(mode == SHUTTLE_CRASHED)
		return

	var/obj/docking_port/stationary/marine_dropship/dropzone = destination
	if(mode == SHUTTLE_PREARRIVAL && !dropzone.landing_lights_on)
		if(istype(destination, /obj/docking_port/stationary/marine_dropship))
			dropzone.turn_on_landing_lights()
		playsound(dropzone.return_center_turf(), landing_sound, 60, 0)
		playsound(return_center_turf(), landing_sound, 60, 0)

	automated_check()

	hijack?.check()

/obj/docking_port/mobile/marine_dropship/proc/automated_check()
	var/obj/structure/machinery/computer/shuttle/dropship/flight/root_console = getControlConsole()
	if(root_console.dropship_control_lost)
		automated_hangar_id = null
		automated_lz_id = null
		automated_delay = null
		return

	if(automated_hangar_id && automated_lz_id && automated_delay && !automated_timer && mode == SHUTTLE_IDLE)
		ai_silent_announcement("The [name] will automatically depart in [automated_delay * 0.1] seconds")
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
	var/obj/docking_port/stationary/dockedAt = get_docked()
	if(dockedAt.id == automated_hangar_id)
		SSshuttle.moveShuttle(id, automated_lz_id, TRUE)
	else
		SSshuttle.moveShuttle(id, automated_hangar_id, TRUE)
	ai_silent_announcement("Dropship '[name]' departing.")

/obj/docking_port/stationary/marine_dropship
	dir = NORTH
	width = 11
	height = 21
	dwidth = 1
	var/list/landing_lights = list()
	var/auto_open = FALSE
	var/landing_lights_on = FALSE
	var/xeno_announce = FALSE

/obj/docking_port/stationary/marine_dropship/Initialize(mapload)
	. = ..()
	link_landing_lights()

/obj/docking_port/stationary/marine_dropship/Destroy()
	. = ..()
	for(var/obj/structure/machinery/landinglight/light in landing_lights)
		light.linked_port = null
	if(landing_lights)
		landing_lights.Cut()
	landing_lights = null // We didn't make them, so lets leave them

/obj/docking_port/stationary/marine_dropship/proc/link_landing_lights()
	var/list/coords = return_coords()
	var/scan_range = 5
	var/x0 = coords[1] - scan_range
	var/y0 = coords[2] - scan_range
	var/x1 = coords[3] + scan_range
	var/y1 = coords[4] + scan_range

	for(var/xscan = x0; xscan < x1; xscan++)
		for(var/yscan = y0; yscan < y1; yscan++)
			var/turf/searchspot = locate(xscan, yscan, src.z)
			for(var/obj/structure/machinery/landinglight/light in searchspot)
				landing_lights += light
				light.linked_port = src

/obj/docking_port/stationary/marine_dropship/proc/turn_on_landing_lights()
	for(var/obj/structure/machinery/landinglight/light in landing_lights)
		light.turn_on()
	landing_lights_on = TRUE

/obj/docking_port/stationary/marine_dropship/proc/turn_off_landing_lights()
	for(var/obj/structure/machinery/landinglight/light in landing_lights)
		light.turn_off()
	landing_lights_on = FALSE

/obj/docking_port/stationary/marine_dropship/on_prearrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()
	turn_on_landing_lights()

/obj/docking_port/stationary/marine_dropship/on_arrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()
	turn_off_landing_lights()
	if(auto_open && istype(arriving_shuttle, /obj/docking_port/mobile/marine_dropship))
		var/obj/docking_port/mobile/marine_dropship/dropship = arriving_shuttle
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

/obj/docking_port/stationary/marine_dropship/on_dock_ignition(obj/docking_port/mobile/departing_shuttle)
	. = ..()
	turn_on_landing_lights()

/obj/docking_port/stationary/marine_dropship/on_departure(obj/docking_port/mobile/departing_shuttle)
	. = ..()
	turn_off_landing_lights()
	var/obj/docking_port/mobile/marine_dropship/shuttle = departing_shuttle
	for(var/obj/structure/dropship_equipment/eq as anything in shuttle.equipments)
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

/obj/docking_port/stationary/marine_dropship/crash_site
	auto_open = TRUE
	dwidth = 1

/obj/docking_port/stationary/marine_dropship/crash_site/on_prearrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()
	if(istype(arriving_shuttle, /obj/docking_port/mobile/marine_dropship))
		var/obj/docking_port/mobile/marine_dropship/ds = arriving_shuttle
		ds.hijack.crash_landing()

/obj/docking_port/stationary/marine_dropship/crash_site/on_arrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()
	arriving_shuttle.mode = SHUTTLE_CRASHED
	for(var/mob/living/carbon/affected_mob in (GLOB.alive_human_list + GLOB.living_xeno_list)) //knock down mobs
		if(affected_mob.z != z)
			continue
		if(affected_mob.buckled)
			to_chat(affected_mob, SPAN_WARNING("You are jolted against [affected_mob.buckled]!"))
			// shake_camera(affected_mob, 3, 1)
		else
			to_chat(affected_mob, SPAN_WARNING("The floor jolts under your feet!"))
			// shake_camera(affected_mob, 10, 1)
			affected_mob.apply_effect(3, WEAKEN)

/datum/map_template/shuttle/alamo
	name = "Alamo"
	shuttle_id = DROPSHIP_ALAMO

/datum/map_template/shuttle/normandy
	name = "Normandy"
	shuttle_id = DROPSHIP_NORMANDY
