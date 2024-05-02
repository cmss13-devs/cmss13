#define HIJACK_CRASH_SITE_OFFSET_X 0
#define HIJACK_CRASH_SITE_OFFSET_Y 0

/datum/dropship_hijack
	var/obj/docking_port/mobile/shuttle
	var/obj/docking_port/stationary/crash_site
	var/target_ship_section
	var/hijacked_bypass_aa = FALSE
	var/final_announcement = FALSE

/datum/dropship_hijack/almayer/proc/crash_landing()
	//break APCs
	for(var/obj/structure/machinery/power/apc/A in GLOB.machines)
		if(A.z != crash_site.z)
			continue
		if(prob(A.crash_break_probability))
			A.overload_lighting()
			A.set_broken()

	var/centre_x = crash_site.x + (crash_site.width / 2)
	//determine outside of ship location
	var/y_travel = 1
	var/obj/outer_target = new()
	outer_target.x = centre_x
	outer_target.y = ALMAYER_DECK_BOUNDARY
	outer_target.z = crash_site.z
	if(crash_site.y < ALMAYER_DECK_BOUNDARY)
		outer_target.y = 1

	// find the outer point of the ship, the first turf that is not space
	while(outer_target.y > 1 && istype(get_turf(outer_target), /turf/open/space))
		outer_target.y += y_travel

	// draw a line of explosions to the landing site
	while(outer_target.y < crash_site.y)
		outer_target.y += (y_travel * 5)
		var/turf/sploded = locate(outer_target.x + rand(-3, 3), outer_target.y, crash_site.z)
		if(!sploded)
			continue

		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), sploded, 250, 20, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("dropship crash"))
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(flame_radius), create_cause_data("dropship crash"), 6, sploded, 10, 5, FLAMESHAPE_DEFAULT, null)

	qdel(outer_target)
	// landing site explosion code
	var/explonum = rand(10,15)
	for(var/j = 0; j < explonum; j++)
		var/turf/sploded = locate(crash_site.x + rand(-5, 15), crash_site.y + rand(-5, 25), crash_site.z)
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), sploded, 250, 20, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("dropship crash"))

	// Break the ultra-reinforced windows.
	// Break the briefing windows.
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_HIJACK_IMPACTED)
	RegisterSignal(SSdcs, COMSIG_GLOB_HIJACK_LANDED, PROC_REF(finish_landing))

	// Sleep while the explosions do their job
	var/explosion_alive = TRUE
	while(explosion_alive)
		explosion_alive = FALSE
		for(var/datum/automata_cell/explosion/E in GLOB.cellauto_cells)
			if(E.explosion_cause_data && E.explosion_cause_data.cause_name == "dropship crash")
				explosion_alive = TRUE
				break
		sleep(10)

/datum/dropship_hijack/almayer/proc/finish_landing()
	SShijack.announce_status_on_crash()
	SSticker.hijack_ocurred()

/datum/dropship_hijack/almayer/proc/fire()
	if(!shuttle || !crash_site)
		return FALSE
	shuttle.callTime = DROPSHIP_CRASH_TRANSIT_DURATION * GLOB.ship_alt
	SSshuttle.moveShuttle(shuttle.id, crash_site.id, TRUE)
	if(GLOB.round_statistics)
		GLOB.round_statistics.track_hijack()
	return TRUE

/datum/dropship_hijack/almayer/proc/target_crash_site(ship_section)
	target_ship_section = ship_section
	var/turf/target = get_crashsite_turf(ship_section)
	if(!target)
		to_chat(usr, SPAN_WARNING("No area available"))
		return

	var/obj/docking_port/stationary/marine_dropship/crash_site/target_site = new()
	crash_site = target_site
	var/turf/offset_target = locate(target.x + HIJACK_CRASH_SITE_OFFSET_X, target.y + HIJACK_CRASH_SITE_OFFSET_Y, target.z)
	if(!offset_target)
		offset_target = target // Welp the offsetting failed so...
	target_site.forceMove(offset_target)

	target_site.name = "[shuttle] crash site"
	target_site.id = "crash_site_[shuttle.id]"

/datum/dropship_hijack/almayer/proc/check()
	check_AA()
	check_final_approach()

/datum/dropship_hijack/almayer/proc/check_AA()
	// we are in flight during a hijack without bypassing AA
	if(shuttle.mode != SHUTTLE_CALL || hijacked_bypass_aa)
		return

	// if our duration isn't far enough away
	if(shuttle.timeLeft(1) > (shuttle.callTime / 2))
		return

	// if the AA site matches target site
	if(target_ship_section == GLOB.almayer_aa_cannon.protecting_section)
		var/list/remaining_crash_sites = GLOB.almayer_ship_sections.Copy()
		remaining_crash_sites -= target_ship_section
		var/new_target_ship_section = pick(remaining_crash_sites)
		var/turf/target = get_crashsite_turf(new_target_ship_section)
		var/turf/offset_target = locate(target.x + HIJACK_CRASH_SITE_OFFSET_X, target.y + HIJACK_CRASH_SITE_OFFSET_Y, target.z)
		if(!offset_target)
			offset_target = target // Welp the offsetting failed so...
		crash_site.forceMove(offset_target)
		marine_announcement("Вражеское судно направляющееся к [target_ship_section] было успешно ликвидировано.", "Система IX-50 MGAD", 'sound/effects/gau.ogg', logging = ARES_LOG_SECURITY)
		target_ship_section = new_target_ship_section
		// TODO mobs not alerted
		for(var/area/internal_area in shuttle.shuttle_areas)
			for(var/turf/internal_turf in internal_area)
				for(var/mob/M in internal_turf)
					to_chat(M, SPAN_DANGER("The ship jostles violently as explosions rock the ship!"))
					to_chat(M, SPAN_DANGER("Вы чувствуете как корабль резко поворачивается и меняет направление!"))
					shake_camera(M, 60, 2)
			playsound_area(internal_area, 'sound/effects/antiair_explosions.ogg')

	hijacked_bypass_aa = TRUE

/datum/dropship_hijack/almayer/proc/check_final_approach()
	// if our duration isn't far enough away
	if(shuttle.mode != SHUTTLE_CALL)
		return

	if(shuttle.timeLeft(1) > 10 SECONDS)
		return

	if(final_announcement)
		return

	marine_announcement("ДЕСАНТНЫЙ КОРАБЛЬ ПРЯМО ПО КУРСУ. АВАРИЯ НЕИЗБЕЖНА." , "ТРЕВОГА", 'sound/AI/dropship_emergency.ogg', logging = ARES_LOG_SECURITY)

	notify_ghosts(header = "Столкновение с десантным кораблем", message = "Десантный корабль вот-вот упадет на [get_area_name(crash_site)]!", source = crash_site, extra_large = TRUE)
	final_announcement = TRUE

	playsound_area(get_area(crash_site), 'sound/effects/engine_landing.ogg', 100)
	playsound_area(get_area(crash_site), channel = SOUND_CHANNEL_AMBIENCE, status = SOUND_UPDATE)

	addtimer(CALLBACK(src, PROC_REF(do_dropship_incoming_sound)), 13 SECONDS)

	addtimer(CALLBACK(src, PROC_REF(disable_latejoin)), 3 MINUTES) // latejoin cryorines have 3 minutes to get the hell out


/datum/dropship_hijack/almayer/proc/do_dropship_incoming_sound()
	for(var/area/internal_area in shuttle.shuttle_areas)
		playsound_area(internal_area, 'sound/effects/dropship_incoming.ogg', vol = 75)
	playsound_z(SSmapping.levels_by_any_trait(list(ZTRAIT_MARINE_MAIN_SHIP)), 'sound/effects/dropship_incoming.ogg', volume = 75)

	addtimer(CALLBACK(src, PROC_REF(do_dropship_collision_sound)), 7 SECONDS)

/datum/dropship_hijack/almayer/proc/do_dropship_collision_sound()
	playsound_z(SSmapping.levels_by_any_trait(list(ZTRAIT_MARINE_MAIN_SHIP)), 'sound/effects/dropship_crash.ogg', volume = 75)

/datum/dropship_hijack/almayer/proc/disable_latejoin()
	GLOB.enter_allowed = FALSE

/datum/dropship_hijack/almayer/proc/get_crashsite_turf(ship_section)
	var/list/turfs = list()
	switch(ship_section)
		if("Upper deck Foreship")
			turfs += get_area_turfs(/area/almayer/shipboard/brig/armory)
			turfs += get_area_turfs(/area/almayer/shipboard/brig/cells)
			turfs += get_area_turfs(/area/almayer/shipboard/brig/cic_hallway)
			turfs += get_area_turfs(/area/almayer/shipboard/brig/cryo)
			turfs += get_area_turfs(/area/almayer/shipboard/brig/evidence_storage)
			turfs += get_area_turfs(/area/almayer/shipboard/brig/general_equipment)
			turfs += get_area_turfs(/area/almayer/shipboard/brig/lobby)
			turfs += get_area_turfs(/area/almayer/shipboard/brig/starboard_hallway)
			turfs += get_area_turfs(/area/almayer/shipboard/brig/perma)
			turfs += get_area_turfs(/area/almayer/shipboard/brig/processing)
			turfs += get_area_turfs(/area/almayer/shipboard/brig/medical)
			turfs += get_area_turfs(/area/almayer/shipboard/brig/mp_bunks)
			turfs += get_area_turfs(/area/almayer/shipboard/brig/chief_mp_office)
			turfs += get_area_turfs(/area/almayer/command/cichallway)
			turfs += get_area_turfs(/area/almayer/command/cic)
		if("Upper deck Midship")
			turfs += get_area_turfs(/area/almayer/medical/morgue)
			turfs += get_area_turfs(/area/almayer/medical/upper_medical)
			turfs += get_area_turfs(/area/almayer/medical/containment)
			turfs += get_area_turfs(/area/almayer/medical/containment/cell)
			turfs += get_area_turfs(/area/almayer/medical/medical_science)
			turfs += get_area_turfs(/area/almayer/medical/hydroponics)
		if("Upper deck Aftship")
			turfs += get_area_turfs(/area/almayer/engineering/upper_engineering)
			turfs += get_area_turfs(/area/almayer/engineering/laundry)
		if("Lower deck Foreship")
			turfs += get_area_turfs(/area/almayer/hallways/hangar)
			turfs += get_area_turfs(/area/almayer/hallways/lower/vehiclehangar)
		if("Lower deck Midship")
			turfs += get_area_turfs(/area/almayer/medical/chemistry)
			turfs += get_area_turfs(/area/almayer/medical/lower_medical_lobby)
			turfs += get_area_turfs(/area/almayer/medical/lockerroom)
			turfs += get_area_turfs(/area/almayer/medical/lower_medical_medbay)
			turfs += get_area_turfs(/area/almayer/medical/operating_room_one)
			turfs += get_area_turfs(/area/almayer/medical/operating_room_two)
			turfs += get_area_turfs(/area/almayer/medical/operating_room_three)
			turfs += get_area_turfs(/area/almayer/medical/operating_room_four)
			turfs += get_area_turfs(/area/almayer/living/briefing)
			turfs += get_area_turfs(/area/almayer/squads/req)
		if("Lower deck Aftship")
			turfs += get_area_turfs(/area/almayer/living/cryo_cells)
			turfs += get_area_turfs(/area/almayer/engineering/lower/workshop)
		else
			CRASH("Crash site [ship_section] unknown.")
	return pick(turfs)

#undef HIJACK_CRASH_SITE_OFFSET_X
#undef HIJACK_CRASH_SITE_OFFSET_Y
