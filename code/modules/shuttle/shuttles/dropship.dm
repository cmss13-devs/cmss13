#define ALMAYER_DROPSHIP_LZ1 "almayer-hangar-lz1"
#define ALMAYER_DROPSHIP_LZ2 "almayer-hangar-lz2"

#define LV_624_LZ1 "lv624-lz1"
#define LV_624_LZ2 "lv624-lz2"

/obj/docking_port/mobile/marine_dropship
	width = 11
	height = 21
	preferred_direction = SOUTH
	callTime = DROPSHIP_TRANSIT_DURATION
	rechargeTime = SHUTTLE_RECHARGE

	var/list/hatches = list()
	var/datum/door_controller/aggregate/door_control

	// Door control has been overridden
	var/door_override = FALSE

	// Is in gun-run mode
	var/in_flyby = FALSE

	// Is hijacked by opfor
	var/is_hijacked = FALSE
	var/hijacked_bypass_aa = FALSE
	var/final_announcement = FALSE
	var/target_zone

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
	SSshuttle.moveShuttle(src.id, dockedAt.id, callTime)

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

/obj/docking_port/mobile/marine_dropship/proc/control_doors(var/action, var/direction, var/force)
	// its been locked down by the queen
	if(door_override)
		return
	door_control.control_doors(action, direction, force)

/obj/docking_port/mobile/marine_dropship/proc/is_door_locked(var/direction)
	return door_control.is_door_locked(direction)

/obj/docking_port/mobile/marine_dropship/alamo
	name = "Alamo"
	id = DROPSHIP_ALAMO

/obj/docking_port/mobile/marine_dropship/normandy
	name = "Normandy"
	id = DROPSHIP_NORMANDY

/obj/docking_port/mobile/marine_dropship/check()
	. = ..()
	if(!is_hijacked)
		return
	check_AA()
	check_final_approach()

/obj/docking_port/mobile/marine_dropship/proc/check_AA()
	// we are in flight during a hijack without bypassing AA
	if(mode != SHUTTLE_CALL || !is_hijacked || hijacked_bypass_aa)
		return

	// if our duration isn't far enough away
	if(timeLeft(1) > (callTime / 2))
		return

	// if the AA site matches target site
	if(target_zone == almayer_aa_cannon.protecting_section)
		var/list/remaining_crash_sites = almayer_ship_sections.Copy()
		remaining_crash_sites -= target_zone
		var/new_target_zone = pick(remaining_crash_sites)
		var/area/target_area = select_crashsite(new_target_zone)
		// spawn crash location
		var/list/turfs = list()
		for(var/turf/T in get_area_turfs(target_area))
			turfs += T
		var/turf/target = pick(turfs)
		src.destination.Move(target)
		marine_announcement("A hostile aircraft on course for the [target_zone] has been successfully deterred.", "IX-50 MGAD System")
		target_zone = new_target_zone
		// TODO mobs not alerted
		for(var/area/internal_area in shuttle_areas)
			for(var/turf/internal_turf in internal_area)
				for(var/mob/M in internal_turf)
					to_chat(M, SPAN_DANGER("The ship jostles violently as explosions rock the ship!"))
					to_chat(M, SPAN_DANGER("You feel the ship turning sharply as it adjusts its course!"))
					shake_camera(M, 60, 2)
			playsound_area(internal_area, 'sound/effects/antiair_explosions.ogg')

	hijacked_bypass_aa = TRUE

/obj/docking_port/mobile/marine_dropship/proc/check_final_approach()
	// if our duration isn't far enough away
	if(timeLeft(1) > 10 SECONDS)
		return
	if(final_announcement)
		return
	marine_announcement("DROPSHIP ON COLLISION COURSE. CRASH IMMINENT." , "EMERGENCY", 'sound/AI/dropship_emergency.ogg')

	announce_dchat("The dropship is about to impact [get_area_name(src.destination)]", src.destination)
	final_announcement = TRUE

	playsound_area(get_area(src.destination), 'sound/effects/engine_landing.ogg', 100)
	playsound_area(get_area(src.destination), channel = SOUND_CHANNEL_AMBIENCE, status = SOUND_UPDATE)

/obj/docking_port/mobile/marine_dropship/proc/select_crashsite(ship_section)
	var/list/areas = list()
	switch(ship_section)
		if("Upper deck Foreship")
			areas += typesof(/area/almayer/shipboard/brig)
			areas += list(/area/almayer/command/cichallway)
			areas += list(/area/almayer/command/cic)
		if("Upper deck Midship")
			areas += list(
				/area/almayer/medical/morgue,
				/area/almayer/medical/upper_medical,
				/area/almayer/medical/containment,
				/area/almayer/medical/containment/cell,
				/area/almayer/medical/medical_science,
				/area/almayer/medical/testlab,
				/area/almayer/medical/hydroponics,
			)
		if("Upper deck Aftship")
			areas += list(
				/area/almayer/engineering/upper_engineering,
				/area/almayer/command/computerlab,
			)
		if("Lower deck Foreship")
			areas += list(
				/area/almayer/hallways/hangar,
				/area/almayer/hallways/vehiclehangar
			)
		if("Lower deck Midship")
			areas += list(
				/area/almayer/medical/chemistry,
				/area/almayer/medical/lower_medical_lobby,
				/area/almayer/medical/lockerroom,
				/area/almayer/medical/lower_medical_medbay,
				/area/almayer/medical/operating_room_one,
				/area/almayer/medical/operating_room_two,
				/area/almayer/medical/operating_room_three,
				/area/almayer/medical/operating_room_four,
				/area/almayer/living/briefing,
				/area/almayer/squads/req,

			)
		if("Lower deck Aftship")
			areas += list(
				/area/almayer/living/cryo_cells,
				/area/almayer/engineering/engineering_workshop,
			)
		else
			CRASH("Crash site [ship_section] unknown.")
	return pick(areas)

/obj/docking_port/stationary/marine_dropship
	dir = NORTH
	width = 11
	height = 21
	var/list/landing_lights = list()
	var/auto_open = FALSE

/obj/docking_port/stationary/marine_dropship/Initialize(mapload)
	. = ..()
	link_landing_lights()

/obj/docking_port/stationary/marine_dropship/proc/link_landing_lights()
	var/area/landing_area = get_area(src)
	for(var/obj/structure/machinery/landinglight/light in landing_area)
		landing_lights += list(light)

/obj/docking_port/stationary/marine_dropship/proc/turn_on_landing_lights()
	for(var/obj/structure/machinery/landinglight/light in landing_lights)
		light.turn_on()

/obj/docking_port/stationary/marine_dropship/proc/turn_off_landing_lights()
	for(var/obj/structure/machinery/landinglight/light in landing_lights)
		light.turn_off()

/obj/docking_port/stationary/marine_dropship/on_prearrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()
	turn_on_landing_lights()

/obj/docking_port/stationary/marine_dropship/on_arrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()
	turn_off_landing_lights()
	if(auto_open && istype(arriving_shuttle, /obj/docking_port/mobile/marine_dropship))
		var/obj/docking_port/mobile/marine_dropship/dropship = arriving_shuttle
		dropship.in_flyby = FALSE
		dropship.control_doors("unlock", "all", force=TRUE)

/obj/docking_port/stationary/marine_dropship/on_dock_ignition(obj/docking_port/mobile/departing_shuttle)
	. = ..()
	turn_on_landing_lights()

/obj/docking_port/stationary/marine_dropship/on_departure(obj/docking_port/mobile/departing_shuttle)
	. = ..()
	turn_off_landing_lights()
	if(istype(departing_shuttle, /obj/docking_port/mobile/marine_dropship))
		var/obj/docking_port/mobile/marine_dropship/dropship = departing_shuttle
		dropship.control_doors("force-lock-launch", "all", force=TRUE)

/obj/docking_port/stationary/marine_dropship/lv642_lz1
	name = "Nexus Landing Zone"
	id = LV_624_LZ1

/obj/docking_port/stationary/marine_dropship/lv642_lz2
	name = "Robotics Landing Zone"
	id = LV_624_LZ2

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

/obj/docking_port/stationary/marine_dropship/crash_site/on_prearrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()

	//break APCs
	for(var/obj/structure/machinery/power/apc/A in machines)
		if(A.z != src.z) continue
		if(prob(A.crash_break_probability))
			A.overload_lighting()
			A.set_broken()

	// explosion code
	var/turf/sploded
	var/explonum = rand(10,15)
	for(var/j=0; j<explonum; j++)
		sploded = locate(src.x + rand(-5, 15), src.y + rand(-5, 25), src.z)
		//Fucking. Kaboom.
		cell_explosion(sploded, 250, 10, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("dropship crash")) //Clears out walls
		sleep(3)

	// Break the ultra-reinforced windows.
	// Break the briefing windows.
	for(var/i in GLOB.hijack_bustable_windows)
		var/obj/structure/window/H = i
		H.deconstruct(FALSE)

	for(var/k in GLOB.hijack_bustable_ladders)
		var/obj/structure/ladder/fragile_almayer/L = k
		L.deconstruct()

	// Delete the briefing door(s).
	for(var/D in GLOB.hijack_deletable_windows)
		qdel(D)

	// Sleep while the explosions do their job
	var/explosion_alive = TRUE
	while(explosion_alive)
		explosion_alive = FALSE
		for(var/datum/automata_cell/explosion/E in cellauto_cells)
			if(E.explosion_cause_data && E.explosion_cause_data.cause_name == "dropship crash")
				explosion_alive = TRUE
				break
		sleep(1)

	for(var/mob/living/carbon/affected_mob in (GLOB.alive_human_list + GLOB.living_xeno_list)) //knock down mobs
		if(affected_mob.z != src.z)
			continue
		if(affected_mob.buckled)
			to_chat(affected_mob, SPAN_WARNING("You are jolted against [affected_mob.buckled]!"))
			// shake_camera(affected_mob, 3, 1)
		else
			to_chat(affected_mob, SPAN_WARNING("The floor jolts under your feet!"))
			// shake_camera(affected_mob, 10, 1)
			affected_mob.apply_effect(3, WEAKEN)

	// TODO this should be handled elsewhere
	sleep(100)
	arriving_shuttle.mode = SHUTTLE_CRASHED
	if(SSticker.mode)
		SSticker.mode.is_in_endgame = TRUE
		SSticker.mode.force_end_at = (world.time + 25 MINUTES)

/datum/map_template/shuttle/alamo
	name = "Alamo"
	shuttle_id = DROPSHIP_ALAMO

/datum/map_template/shuttle/normandy
	name = "Normandy"
	shuttle_id = DROPSHIP_NORMANDY
