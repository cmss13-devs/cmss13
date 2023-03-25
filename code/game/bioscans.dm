GLOBAL_DATUM_INIT(bioscan_data, /datum/bioscan_data, new)
/datum/bioscan_data
	var/numHostsPlanet = 0
	var/numHostsShip = 0
	var/numXenosPlanet = 0
	var/numXenosShip = 0
	var/numXenosShipAres = 0 //ARES scan doesn't count containment xenos

	//We're assembling a list of locations so we can give hint about a random one
	var/list/hostsPlanetLocations = list()
	var/list/hostsShipLocations = list()
	var/list/xenosPlanetLocations = list()
	var/list/xenosShipLocations = list()
	/// All larva on all hives
	var/larva = 0

	/// Random mentioned locations
	var/RandomHostsPlanetLocation = ""
	var/RandomHostsShipLocation = ""
	var/RandomXenosPlanetLocation = ""
	var/RandomXenosShipLocation = ""

/datum/bioscan_data/proc/get_scan_data()
	/// Count all larva across all hives
	var/datum/hive_status/HS
	for(var/hivenumber in GLOB.hive_datum)
		HS = GLOB.hive_datum[hivenumber]
		larva += HS.stored_larva

	/// Keeping track of peak numbers to determine when a side is "losing"
	if(peakHumans < length(GLOB.alive_human_list))
		peakHumans = length(GLOB.alive_human_list)
	if(peakXenos < length(GLOB.living_xeno_list))
		peakXenos = length(GLOB.living_xeno_list)

	for(var/mob/M in GLOB.living_xeno_list)
		if(M.mob_flags & NOBIOSCAN)
			continue
		var/area/A = get_area(M)
		if(A?.flags_area & AREA_AVOID_BIOSCAN)
			numXenosShip++
			continue
		var/atom/where = M
		if (where.z == 0 && M.loc)
			where = M.loc
		if(where.z in SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND, ZTRAIT_RESERVED)))
			numXenosPlanet++
			xenosPlanetLocations+=where
		else if(is_mainship_level(where.z))
			numXenosShip++
			numXenosShipAres++
			xenosShipLocations+=where

	for(var/i in GLOB.alive_human_list)
		var/mob/living/carbon/human/H = i
		if(H.mob_flags & NOBIOSCAN)
			continue
		var/atom/where = H
		if(isspecieshuman(H))
			if (where.z == 0 && H.loc)
				where = H.loc
			if(where.z in SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND, ZTRAIT_RESERVED)))
				numHostsPlanet++
				hostsPlanetLocations += where
			else if(is_mainship_level(where.z))
				numHostsShip++
				hostsShipLocations += where

/// Pick one random location to disclose
	if (hostsPlanetLocations.len>0)
		RandomHostsPlanetLocation = get_area_name(pick(hostsPlanetLocations))
	if (hostsShipLocations.len>0)
		RandomHostsShipLocation = get_area_name(pick(hostsShipLocations))
	if (xenosPlanetLocations.len>0)
		RandomXenosPlanetLocation = get_area_name(pick(xenosPlanetLocations))
	if (xenosShipLocations.len>0)
		RandomXenosShipLocation = get_area_name(pick(xenosShipLocations))

/// Inform Yautja and Ghosts exactly what's what.
/datum/bioscan_data/proc/yautja_bioscan()
	var/xeno_colony_location = "[RandomXenosPlanetLocation?", including one in [RandomXenosPlanetLocation]":""]"
	var/xeno_ship_location = "[RandomXenosShipLocation?", including one in [RandomXenosShipLocation].":"."]"
	var/marine_colony_location = "[RandomHostsPlanetLocation?", including one in [RandomHostsPlanetLocation].":"."]"
	var/marine_ship_location = "[RandomHostsShipLocation?", including one in [RandomHostsShipLocation].":"."]"
	for(var/mob/M in GLOB.player_list)
		//Announce the numbers to Yautja, they have good scanners
		if (isyautja(M))
			to_chat(M, "<h2 class='alert'>Bioscan complete</h2>")
			to_chat(M, SPAN_ALERT("[numXenosPlanet] serpents present in the hunting ground[xeno_colony_location], with [larva] larva.\n[numXenosShip] serpents present on the human ship[xeno_ship_location]\n[numHostsPlanet] humans present in the hunting ground[marine_colony_location]\n[numHostsShip] humans present on the human ship[marine_ship_location]"))

		//Let the ghosts know what's up, they also get good numbers
		if (isobserver(M))
			to_chat(M, "<h2 class='alert'>Bioscan complete</h2>")
			to_chat(M, SPAN_ALERT("[numXenosPlanet] xenos on planet, with [larva] larva.\n[numXenosShip] xenos on the ship.\n[numHostsPlanet] humans on the planet.\n[numHostsShip] humans on the ship."))


/// This will do something after Project ARES.
/datum/bioscan_data/proc/can_ares_bioscan()
	return TRUE

/// The announcement to all Humans. Slightly off for the planet and elsewhere, accurate for the ship.
/datum/bioscan_data/proc/ares_bioscan(forced = FALSE, variance = 2)
	if(!forced && !can_ares_bioscan())
		message_admins("An ARES Bioscan has failed.")
		return

	//Adjust the randomness there so everyone gets the same thing
	var/fakeNumXenosPlanet = max(0, numXenosPlanet + rand(-variance, variance))

	var/name = "[MAIN_AI_SYSTEM] Bioscan Status"
	var/input = "Bioscan complete.\n\nSensors indicate [numXenosShipAres ? "[numXenosShipAres]":"no"] unknown lifeform signature[!numXenosShipAres || numXenosShipAres > 1 ? "s":""] present on the ship[numXenosShipAres&&RandomXenosShipLocation?", including one in [RandomXenosShipLocation],":""] and [fakeNumXenosPlanet ? "approximately [fakeNumXenosPlanet]":"no"] signature[!fakeNumXenosPlanet || fakeNumXenosPlanet > 1 ? "s":""] located elsewhere[fakeNumXenosPlanet&&RandomXenosPlanetLocation?", including one in [RandomXenosPlanetLocation]":""]."
	marine_announcement(input, name, 'sound/AI/bioscan.ogg')

/// The announcement to all Xenos. Slightly off for the human ship, accurate otherwise.
/datum/bioscan_data/proc/qm_bioscan(variance = 2)
	/// Adjust the randomness there so everyone gets the same thing
	var/fakeNumHostsShip = max(0, numHostsShip + rand(-variance, variance))
	/// Shout it at everyone
	for(var/i in GLOB.living_xeno_list)
		var/mob/M = i
		M << sound(get_sfx("queen"), wait = 0, volume = 50)
		to_chat(M, SPAN_XENOANNOUNCE("The Queen Mother reaches into your mind from worlds away."))
		var/metalhive_hosts = "[fakeNumHostsShip ? "approximately [fakeNumHostsShip]":"no"]"
		var/plural = "[!fakeNumHostsShip || fakeNumHostsShip > 1 ? "s":""]"
		var/metalhive_location = "[fakeNumHostsShip&&RandomHostsShipLocation?", including one in [RandomHostsShipLocation],":""]"
		var/planet_hosts = "[numHostsPlanet ? "[numHostsPlanet]":"none"]"
		var/planet_location = "[numHostsPlanet&&RandomHostsPlanetLocation?", including one in [RandomHostsPlanetLocation]":""]"
		to_chat(M, SPAN_XENOANNOUNCE("To my children and their Queen. I sense [metalhive_hosts] host[plural] in the metal hive [metalhive_location] and [planet_hosts] scattered elsewhere[planet_location]."))
