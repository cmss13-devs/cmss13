GLOBAL_DATUM_INIT(ares_link, /datum/ares_link, new)

/datum/ares_link
	var/link_id = MAIN_SHIP_DEFAULT_NAME
	var/obj/structure/machinery/ares/processor/interface/p_interface
	var/obj/structure/machinery/ares/processor/apollo/p_apollo
	var/obj/structure/machinery/ares/processor/bioscan/p_bioscan
	var/obj/structure/machinery/computer/ares_console/interface

/datum/ares_link/proc/log_bioscan(title, input)
	if(!p_bioscan || p_bioscan.inoperable() || !interface)
		return FALSE
	title = "[title] [worldtime2text()]"
	interface.bioscan_title.Add(title)
	interface.bioscan_details.Add(input)

/proc/log_apollo(speaker, message)
	if(!speaker)
		speaker = "Unknown"
	var/datum/ares_link/link = GLOB.ares_link
	if(!link.p_apollo || link.p_apollo.inoperable())
		return
	if(!link.p_interface || link.p_interface.inoperable())
		return
	if(!link.interface || link.interface.inoperable())
		return
	else
		link.interface.apollo_log.Add("[worldtime2text()]: [speaker], [message]")

/proc/can_bioscan()
	var/datum/ares_link/link = GLOB.ares_link
	if(!link || !link.p_bioscan || link.p_bioscan.inoperable())
		return FALSE
	else
		return TRUE

/proc/ares_bioscan(forced = FALSE)
	if(!forced && !can_bioscan())
		message_admins("An ARES Bioscan has failed.")
		return

	var/variance = 2
	var/numXenosPlanet = 0
	var/numXenosShipAres = 0 //ARES scan doesn't count containment xenos

	//We're assembling a list of locations so we can give hint about a random one
	var/list/xenosPlanetLocations = list()
	var/list/xenosShipLocations = list()


	for(var/mob/M in GLOB.living_xeno_list)
		if(M.mob_flags & NOBIOSCAN)
			continue
		var/atom/where = M
		if (where.z == 0 && M.loc)
			where = M.loc
		if(where.z in SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND, ZTRAIT_RESERVED)))
			numXenosPlanet++
			xenosPlanetLocations+=where
		else if(is_mainship_level(where.z))
			numXenosShipAres++
			xenosShipLocations+=where

	//Pick one random location to disclose
	var/RandomXenosPlanetLocation = ""
	if (xenosPlanetLocations.len>0)
		RandomXenosPlanetLocation = get_area_name(pick(xenosPlanetLocations))
	var/RandomXenosShipLocation = ""
	if (xenosShipLocations.len>0)
		RandomXenosShipLocation = get_area_name(pick(xenosShipLocations))

	//Adjust the randomness there so everyone gets the same thing
	numXenosPlanet = max(0, numXenosPlanet + rand(-variance, variance))

	// The announcement to all Humans. Slightly off for the planet and elsewhere, accurate for the ship.
	var/name = "[MAIN_AI_SYSTEM] Bioscan Status"
	var/input = "Bioscan complete.\n\nSensors indicate [numXenosShipAres ? "[numXenosShipAres]":"no"] unknown lifeform signature[!numXenosShipAres || numXenosShipAres > 1 ? "s":""] present on the ship[numXenosShipAres&&RandomXenosShipLocation?", including one in [RandomXenosShipLocation],":""] and [numXenosPlanet ? "approximately [numXenosPlanet]":"no"] signature[!numXenosPlanet || numXenosPlanet > 1 ? "s":""] located elsewhere[numXenosPlanet&&RandomXenosPlanetLocation?", including one in [RandomXenosPlanetLocation]":""]."
	var/datum/ares_link/link = GLOB.ares_link
	link.log_bioscan(name, input)
	if(forced || (link.p_interface && !link.p_interface.inoperable()))
		marine_announcement(input, name, 'sound/AI/bioscan.ogg')
