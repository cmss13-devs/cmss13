GLOBAL_DATUM_INIT(bioscan_data, /datum/bioscan_data, new)

/datum/bioscan_data
	var/marines_on_planet = 0
	var/marines_on_ship = 0
	var/xenos_on_planet = 0
	var/xenos_on_ship = 0
	var/xenos_on_ship_uncontained = 0 //ARES scan doesn't count containment xenos

	//We're assembling a list of locations so we can give hint about a random one
	var/list/marine_possible_planet_locations = list()
	var/list/marine_possible_ship_locations = list()
	var/list/xeno_possible_planet_locations = list()
	var/list/xeno_possible_ship_locations = list()

	/// All larva on all hives
	var/larva = 0

	/// Random mentioned locations
	var/marine_planet_location
	var/marine_ship_location
	var/xenos_planet_location
	var/xenos_ship_location

/datum/bioscan_data/proc/clear_data()
	marines_on_planet = 0
	marines_on_ship = 0
	xenos_on_planet = 0
	xenos_on_ship = 0
	xenos_on_ship_uncontained = 0
	marine_possible_planet_locations = list()
	marine_possible_ship_locations = list()
	xeno_possible_planet_locations = list()
	xeno_possible_ship_locations = list()

/datum/bioscan_data/proc/get_scan_data()
	clear_data()
	/// All larva on all hives
	larva = 0


	/// Count all larva across all hives
	for(var/hivenumber in GLOB.hive_datum)
		larva += GLOB.hive_datum[hivenumber].stored_larva

	/// Keeping track of peak numbers to determine when a side is "losing"
	if(GLOB.peak_humans < length(GLOB.alive_human_list))
		GLOB.peak_humans = length(GLOB.alive_human_list)
	if(GLOB.peak_xenos < length(GLOB.living_xeno_list))
		GLOB.peak_xenos = length(GLOB.living_xeno_list)

	for(var/mob/current_mob as anything in GLOB.living_xeno_list)
		if(current_mob.mob_flags & NOBIOSCAN)
			continue
		var/area/area = get_area(current_mob)
		if(area?.flags_area & AREA_AVOID_BIOSCAN)
			continue
		var/atom/where = current_mob
		if (where.z == 0 && current_mob.loc)
			where = current_mob.loc
		if(where.z in SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND, ZTRAIT_RESERVED)))
			xenos_on_planet++
			xeno_possible_planet_locations += where
		else if(is_mainship_level(where.z))
			xenos_on_ship++
			xenos_on_ship_uncontained++
			xeno_possible_ship_locations += where

	for(var/mob/living/carbon/human/current_human as anything in GLOB.alive_human_list)
		if(current_human.mob_flags & NOBIOSCAN)
			continue
		var/area/area = get_area(current_human)
		if(area?.flags_area & AREA_AVOID_BIOSCAN)
			continue
		var/atom/where = current_human
		if(isspecieshuman(current_human))
			if (where.z == 0 && current_human.loc)
				where = current_human.loc
			if(where.z in SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND, ZTRAIT_RESERVED)))
				marines_on_planet++
				marine_possible_planet_locations += where
			else if(is_mainship_level(where.z))
				marines_on_ship++
				marine_possible_ship_locations += where

	/// Pick one random location to disclose
	marine_planet_location = get_area_name(SAFEPICK(marine_possible_planet_locations))
	marine_ship_location = get_area_name(SAFEPICK(marine_possible_ship_locations))
	xenos_planet_location = get_area_name(SAFEPICK(xeno_possible_planet_locations))
	xenos_ship_location = get_area_name(SAFEPICK(xeno_possible_ship_locations))

/// Inform Yautja and Ghosts exactly what's what.
/datum/bioscan_data/proc/yautja_bioscan()
	var/xeno_planet_location_string = "[xenos_planet_location ? ", including one in [xenos_planet_location]" : ""]"
	var/xeno_ship_location_string = "[xenos_ship_location ? ", including one in [xenos_ship_location]." : "."]"
	var/marine_planet_location_string = "[marine_planet_location ? ", including one in [marine_planet_location]." : "."]"
	var/marine_ship_location_string = "[marine_ship_location ? ", including one in [marine_ship_location]." : "."]"

	var/ghost_scan = SPAN_ALERT("[xenos_on_planet] xenos on planet, with [larva] larva.\n[xenos_on_ship] xenos on the ship.\n[marines_on_planet] humans on the planet.\n[marines_on_ship] humans on the ship.")
	var/yautja_scan = SPAN_ALERT("[xenos_on_planet] serpents present in the hunting ground[xeno_planet_location_string], with [larva] larva.\n[xenos_on_ship] serpents present on the human ship[xeno_ship_location_string]\n[marines_on_planet] humans present in the hunting ground[marine_planet_location_string]\n[marines_on_ship] humans present on the human ship[marine_ship_location_string]")
	log_game("BIOSCAN: A Yautja/Ghost bioscan has completed. [ghost_scan]")

	//Announce the numbers to Yautja, they have good scanners
	for(var/mob/living/carbon/human/yautja as anything in GLOB.yautja_mob_list)
		to_chat(yautja, "<h2 class='alert'>Bioscan complete</h2>")
		to_chat(yautja, yautja_scan)

	//Let the ghosts know what's up, they also get good numbers
	for(var/mob/dead/observer/ghost as anything in GLOB.observer_list)
		to_chat(ghost, "<h2 class='alert'>Bioscan complete</h2>")
		to_chat(ghost, ghost_scan)


/datum/bioscan_data/proc/ares_can_bioscan()
	var/datum/ares_link/link = GLOB.ares_link
	if(!istype(link) || !ares_is_active())
		return FALSE
	if(link.processor_bioscan && !link.processor_bioscan.inoperable())
		return TRUE
	return FALSE

/// The announcement to all Humans. Slightly off for the planet and elsewhere, accurate for the ship.
/datum/bioscan_data/proc/ares_bioscan(forced = FALSE, variance = 2)
	if(!forced && !ares_can_bioscan())
		message_admins("An ARES Bioscan has failed.")
		var/name = "[MAIN_AI_SYSTEM] Bioscan Status"
		var/input = "Bioscan failed. \n\nInvestigation into Bioscan subsystem recommended."
		log_ares_bioscan(name, input, forced)
		if(ares_can_interface() || forced)
			marine_announcement(input, name, 'sound/misc/interference.ogg', logging = ARES_LOG_NONE)
		return
	//Adjust the randomness there so everyone gets the same thing
	var/fake_xenos_on_planet = max(0, xenos_on_planet + rand(-variance, variance))
	var/name = "[MAIN_AI_SYSTEM] Bioscan Status"
	var/input = "Bioscan complete.\n\nSensors indicate [xenos_on_ship_uncontained ? "[xenos_on_ship_uncontained]" : "no"] unknown lifeform signature[!xenos_on_ship_uncontained || xenos_on_ship_uncontained > 1 ? "s":""] present on the ship[xenos_on_ship_uncontained && xenos_ship_location ? ", including one in [xenos_ship_location]," : ""] and [fake_xenos_on_planet ? "approximately [fake_xenos_on_planet]" : "no"] signature[!fake_xenos_on_planet || fake_xenos_on_planet > 1 ? "s":""] located elsewhere[fake_xenos_on_planet && xenos_planet_location ? ", including one in [xenos_planet_location]":""]."

	log_game("BIOSCAN: ARES bioscan completed. [input]")

	log_ares_bioscan(name, input) //if interface is down, bioscan still logged, just have to go read it.
	if(forced || ares_can_interface())
		marine_announcement(input, name, 'sound/AI/bioscan.ogg', logging = ARES_LOG_NONE)
	else
		message_admins("An ARES Bioscan has succeeded, but was not announced.")

/// The announcement to all Xenos. Slightly off for the human ship, accurate otherwise.
/datum/bioscan_data/proc/qm_bioscan(variance = 2)
	/// Adjust the randomness there so everyone gets the same thing
	var/fake_marines_on_ship = max(0, marines_on_ship + rand(-variance, variance))
	var/metalhive_hosts = "[fake_marines_on_ship ? "approximately [fake_marines_on_ship]":"no"]"
	var/plural = "[!fake_marines_on_ship || fake_marines_on_ship > 1 ? "s":""]"
	var/metalhive_location = "[fake_marines_on_ship && marine_ship_location?", including one in [marine_ship_location]," : ""]"
	var/planet_hosts = "[marines_on_planet ? "[marines_on_planet]" : "none"]"
	var/planet_location = "[marines_on_planet && marine_planet_location ? ", including one in [marine_planet_location]" : ""]"

	var/title = SPAN_XENOANNOUNCE("The Queen Mother reaches into your mind from worlds away.")
	var/content = SPAN_XENOANNOUNCE("To my children and their Queen: I sense [metalhive_hosts] host[plural] in the metal hive[metalhive_location] and [planet_hosts] scattered elsewhere[planet_location].")

	log_game("BIOSCAN: Queen Mother bioscan completed. [content]")
	/// Shout it at everyone
	for(var/mob/current_mob as anything in GLOB.living_xeno_list)
		current_mob << sound(get_sfx("queen"), wait = 0, volume = 50)
		to_chat(current_mob, title)
		to_chat(current_mob, content)
