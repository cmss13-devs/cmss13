
#define QUEEN_DEATH_COUNTDOWN 			 10 MINUTES //10 minutes. Can be changed into a variable if it needs to be manipulated later.

#define MODE_INFESTATION_X_MAJOR		"Xenomorph Major Victory"
#define MODE_INFESTATION_M_MAJOR		"Marine Major Victory"
#define MODE_INFESTATION_X_MINOR		"Xenomorph Minor Victory"
#define MODE_INFESTATION_M_MINOR		"Marine Minor Victory"
#define MODE_INFESTATION_DRAW_DEATH		"DRAW: Mutual Annihilation"

#define MODE_INFECTION_ZOMBIE_WIN		"Major Zombie Victory"

#define MODE_BATTLEFIELD_W_MAJOR		"Wey-Yu PMC Major Success"
#define MODE_BATTLEFIELD_M_MAJOR		"Marine Major Success"
#define MODE_BATTLEFIELD_W_MINOR		"Wey-Yu PMC Minor Success"
#define MODE_BATTLEFIELD_M_MINOR		"Marine Minor Success"
#define MODE_BATTLEFIELD_DRAW_STALEMATE "DRAW: Stalemate"
#define MODE_BATTLEFIELD_DRAW_DEATH		"DRAW: My Friends Are Dead"

#define MODE_GENERIC_DRAW_NUKE			"DRAW: Nuclear Explosion"

/*
Like with cm_initialize.dm, these procs exist to quickly populate classic CM game modes.
Specifically for processing, announcing completion, and so on. Simply plug in these procs
in to the appropriate slots, like the in the example game modes, and you're good to go.
This is meant for infestation type game modes for right now (marines vs. aliens, with a chance
of predators), but can be added to include variant game modes (like humans vs. humans).
*/

//If the queen is dead after a period of time, this will end the game.
/datum/game_mode/proc/check_queen_status()
	return

//===================================================\\

				//ANNOUNCE COMPLETION\\

//===================================================\\

/datum/game_mode/proc/declare_completion_announce_fallen_soldiers()
	set waitfor = 0
	sleep(2 SECONDS)
	if(fallen_list.len)
		var/dat = "<br>"
		dat += SPAN_ROUNDBODY("In Flanders fields...<br>")
		dat += SPAN_CENTERBOLD("In memoriam of our fallen soldiers: <br>")
		for(var/i = 1 to fallen_list.len)
			if(i != fallen_list.len)
				dat += "[fallen_list[i]], "
			else
				dat += "[fallen_list[i]].<br>"
		to_world("[dat]")


/datum/game_mode/proc/declare_completion_announce_xenomorphs()
	set waitfor = 0
	sleep(2 SECONDS)
	if(LAZYLEN(xenomorphs) || LAZYLEN(dead_queens))
		var/dat = "<br>"
		dat += SPAN_ROUNDBODY("<br>The xenomorph Queen(s) were:")
		var/mob/M
		for (var/msg in dead_queens)
			dat += msg
		for(var/datum/mind/X in xenomorphs)
			if(!istype(X))
				continue

			M = X.current
			if(!M || !M.loc)
				M = X.original
			if(M && M.loc && isXenoQueen(M) && M.stat != DEAD) // Dead queens handled separately
				dat += "<br>[X.key] was [M] [SPAN_BOLDNOTICE("(SURVIVED)")]"

		to_world("[dat]")

/datum/game_mode/proc/declare_completion_announce_predators()
	set waitfor = 0
	sleep(2 SECONDS)
	if(length(predators))
		var/dat = "<br>"
		dat += SPAN_ROUNDBODY("<br>The Predators were:")
		for(var/entry in predators)
			dat += "<br>[entry] was [predators[entry]["Name"]] [SPAN_BOLDNOTICE("([predators[entry]["Status"]])")]"
		to_world("[dat]")


/datum/game_mode/proc/declare_completion_announce_medal_awards()
	set waitfor = 0
	sleep(2 SECONDS)
	if(GLOB.medal_awards.len)
		var/dat = "<br>"
		dat +=  SPAN_ROUNDBODY("<br>Medal Awards:")
		for(var/recipient in GLOB.medal_awards)
			var/datum/recipient_awards/recipient_award = GLOB.medal_awards[recipient]
			for(var/i in 1 to recipient_award.medal_names.len)
				dat += "<br><b>[recipient_award.recipient_rank] [recipient]</b> is awarded [recipient_award.posthumous[i] ? "posthumously " : ""]the <span class='boldnotice'>[recipient_award.medal_names[i]]</span>: \'<i>[recipient_award.medal_citations[i]]</i>\'."
		to_world(dat)
	if(GLOB.jelly_awards.len)
		var/dat = "<br>"
		dat +=  SPAN_ROUNDBODY("<br>Royal Jelly Awards:")
		for(var/recipient in GLOB.jelly_awards)
			var/datum/recipient_awards/recipient_award = GLOB.jelly_awards[recipient]
			for(var/i in 1 to recipient_award.medal_names.len)
				dat += "<br><b>[recipient]</b> is awarded [recipient_award.posthumous[i] ? "posthumously " : ""]a <span class='boldnotice'>[recipient_award.medal_names[i]]</span>: \'<i>[recipient_award.medal_citations[i]]</i>\'[recipient_award.giver_rank[i] ? " by [recipient_award.giver_rank[i]]" : ""][recipient_award.giver_name[i] ? " ([recipient_award.giver_name[i]])" : ""]."
		to_world(dat)

/datum/game_mode/proc/declare_random_fact()
	set waitfor = 0
	sleep(2 SECONDS)
	var/fact_type = pick(subtypesof(/datum/random_fact))
	var/datum/random_fact/fact = new fact_type()
	fact.announce()

//===================================================\\

					//HELPER PROCS\\

//===================================================\\

//Spawns a larva in an appropriate location
/datum/game_mode/proc/spawn_latejoin_larva()
	var/mob/living/carbon/Xenomorph/Larva/new_xeno = new /mob/living/carbon/Xenomorph/Larva(get_turf(pick(GLOB.xeno_spawns)))
	new_xeno.visible_message(SPAN_XENODANGER("A larva suddenly burrows out of the ground!"),
	SPAN_XENODANGER("You burrow out of the ground and awaken from your slumber. For the Hive!"))
	new_xeno << sound('sound/effects/xeno_newlarva.ogg')

//Disperses fog, doing so gradually.
/datum/game_mode/proc/disperse_fog()
	set waitfor = 0
	flags_round_type &= ~MODE_FOG_ACTIVATED
	var/i
	for(i in round_fog)
		round_fog -= i
		qdel(i)
		CHECK_TICK
	round_fog = null

// Open podlocks with the given ID if they aren't already opened.
// DO NOT USE THIS WITH ID's CORRESPONDING TO SHUTTLES OR THEY WILL BREAK!
/datum/game_mode/proc/open_podlocks(var/podlock_id)
	for(var/obj/structure/machinery/door/poddoor/M in machines)
		if(M.id == podlock_id && M.density)
			M.open()

//Variables for the below function that we need to keep throught the round
var/peakHumans = 1
var/peakXenos = 1

var/lastXenoBioscan = 30 MINUTES//30 minutes in (we will add to that!)
var/lastHumanBioscan = 30 MINUTES//30 minutes in (we will add to that!)
var/nextPredatorBioscan = 5 MINUTES//5 minutes in
var/nextAdminBioscan = 30 MINUTES//30 minutes in

/datum/game_mode/proc/select_lz(var/obj/structure/machinery/computer/shuttle_control/console)
	if(active_lz)
		return
	active_lz = console
	// The announcement to all Humans.
	var/name = "[MAIN_AI_SYSTEM] Operation Staging Order"
	var/input = "Command Order Issued.\n\n[active_lz.loc.loc] has been designated as the primary landing zone."
	marine_announcement(input, name)

//Delta is the randomness interval, in +/-. Might not be the exact mathematical definition
/datum/game_mode/proc/announce_bioscans(var/delta = 2)
	var/numHostsPlanet	= 0
	var/numHostsShip	= 0
	var/numXenosPlanet	= 0
	var/numXenosShip	= 0
	var/numXenosShipAres = 0 //ARES scan doesn't count containment xenos

	//We're assembling a list of locations so we can give hint about a random one
	var/list/hostsPlanetLocations = list()
	var/list/hostsShipLocations = list()
	var/list/xenosPlanetLocations = list()
	var/list/xenosShipLocations = list()

	var/larva = 0
	//Count all larva across all hives
	var/datum/hive_status/HS
	for(var/hivenumber in GLOB.hive_datum)
		HS = GLOB.hive_datum[hivenumber]
		larva += HS.stored_larva

	//Keeping track of peak numbers to determine when a side is "losing"
	if (peakHumans < length(GLOB.alive_human_list))
		peakHumans = length(GLOB.alive_human_list)
	if (peakXenos < length(GLOB.living_xeno_list))
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
		if(where.z in SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND, ZTRAIT_LOWORBIT)))
			numXenosPlanet++
			xenosPlanetLocations+=where
		else if(is_mainship_level(where.z))
			numXenosShip++
			numXenosShipAres++
			xenosShipLocations+=where


	for (var/i in GLOB.alive_human_list)
		var/mob/living/carbon/human/H = i
		if(H.mob_flags & NOBIOSCAN)
			continue
		var/atom/where = H
		if(isSpeciesHuman(H))
			if (where.z == 0 && H.loc)
				where = H.loc
			if(where.z in SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND, ZTRAIT_LOWORBIT)))
				numHostsPlanet++
				hostsPlanetLocations += where
			else if(is_mainship_level(where.z))
				numHostsShip++
				hostsShipLocations += where

	if (world.time > nextAdminBioscan)
		nextAdminBioscan += 30 MINUTES//every 30 minutes, straight
		//Message the admins first before we tweak the numbers
		message_staff("A bioscan/Queen Mother message has completed. Humans: [numHostsPlanet] on the planet and [numHostsShip] on the ship. Xenos: [numXenosPlanet] on the planet and [numXenosShip] on the ship.")

	//Pick one random location to disclose
	var/RandomHostsPlanetLocation = ""
	if (hostsPlanetLocations.len>0)
		RandomHostsPlanetLocation = get_area_name(pick(hostsPlanetLocations))
	var/RandomHostsShipLocation = ""
	if (hostsShipLocations.len>0)
		RandomHostsShipLocation = get_area_name(pick(hostsShipLocations))
	var/RandomXenosPlanetLocation = ""
	if (xenosPlanetLocations.len>0)
		RandomXenosPlanetLocation = get_area_name(pick(xenosPlanetLocations))
	var/RandomXenosShipLocation = ""
	if (xenosShipLocations.len>0)
		RandomXenosShipLocation = get_area_name(pick(xenosShipLocations))

	if(world.time > nextPredatorBioscan)
		nextPredatorBioscan += 5 MINUTES//5 minutes, straight
		var/xeno_colony_location = "[RandomXenosPlanetLocation?", including one in [RandomXenosPlanetLocation]":""]"
		var/xeno_ship_location = "[RandomXenosShipLocation?", including one in [RandomXenosShipLocation].":"."]"
		var/marine_colony_location = "[RandomHostsPlanetLocation?", including one in [RandomHostsPlanetLocation].":"."]"
		var/marine_ship_location = "[RandomHostsShipLocation?", including one in [RandomHostsShipLocation].":"."]"
		for(var/mob/M in GLOB.player_list)
			//Announce the numbers to Yautja, they have good scanners
			if (isYautja(M))
				to_chat(M, "<h2 class='alert'>Bioscan complete</h2>")
				to_chat(M, SPAN_ALERT("[numXenosPlanet] serpents present in the hunting ground[xeno_colony_location], with [larva] larva.\n[numXenosShip] serpents present on the human ship[xeno_ship_location]\n[numHostsPlanet] humans present in the hunting ground[marine_colony_location]\n[numHostsShip] humans present on the human ship[marine_ship_location]"))

			//Let the ghosts know what's up, they also get good numbers
			if (isobserver(M))
				to_chat(M, "<h2 class='alert'>Bioscan complete</h2>")
				to_chat(M, SPAN_ALERT("[numXenosPlanet] xenos on planet, with [larva] larva.\n[numXenosShip] xenos on the ship.\n[numHostsPlanet] humans on the planet.\n[numHostsShip] humans on the ship."))

	//Adjust the randomness there so everyone gets the same thing
	numHostsShip = max(0, numHostsShip + rand(-delta, delta))
	numXenosPlanet = max(0, numXenosPlanet + rand(-delta, delta))

	//Depending on how either side is doing, we speed up the bioscans
	//Formula is - last bioscan time, plus 30 minutes multiplied by ratio of current pop divided by highest pop
	//So if you have peak 30 xenos, if you still have 30 xenos, humans will have to wait 30 minutes between bioscans
	//But if you fall down to 15 xenos, humans will get them every 15 minutes
	//But never more often than 5 minutes apart
	var/nextXenoBioscan = lastXenoBioscan + max(30 MINUTES * length(GLOB.alive_human_list) / peakHumans, 5 MINUTES)
	var/nextHumanBioscan = lastHumanBioscan + max(30 MINUTES * length(GLOB.living_xeno_list) / peakXenos, 5 MINUTES)

	if(world.time > nextXenoBioscan)
		lastXenoBioscan = world.time
		// The announcement to all Xenos. Slightly off for the human ship, accurate otherwise.
		for(var/i in GLOB.living_xeno_list)
			var/mob/M = i
			M << sound(get_sfx("queen"), wait = 0, volume = 50)
			to_chat(M, SPAN_XENOANNOUNCE("The Queen Mother reaches into your mind from worlds away."))
			var/metalhive_hosts = "[numHostsShip ? "approximately [numHostsShip]":"no"]"
			var/plural = "[!numHostsShip || numHostsShip > 1 ? "s":""]"
			var/metalhive_location = "[numHostsShip&&RandomHostsShipLocation?", including one in [RandomHostsShipLocation],":""]"
			var/planet_hosts = "[numHostsPlanet ? "[numHostsPlanet]":"none"]"
			var/planet_location = "[numHostsPlanet&&RandomHostsPlanetLocation?", including one in [RandomHostsPlanetLocation]":""]"
			to_chat(M, SPAN_XENOANNOUNCE("To my children and their Queen. I sense [metalhive_hosts] host[plural] in the metal hive [metalhive_location] and [planet_hosts] scattered elsewhere[planet_location]."))


	if(world.time > nextHumanBioscan)
		lastHumanBioscan = world.time
		// The announcement to all Humans. Slightly off for the planet and elsewhere, accurate for the ship.
		var/name = "[MAIN_AI_SYSTEM] Bioscan Status"
		var/input = "Bioscan complete.\n\nSensors indicate [numXenosShipAres ? "[numXenosShipAres]":"no"] unknown lifeform signature[!numXenosShipAres || numXenosShipAres > 1 ? "s":""] present on the ship[numXenosShipAres&&RandomXenosShipLocation?", including one in [RandomXenosShipLocation],":""] and [numXenosPlanet ? "approximately [numXenosPlanet]":"no"] signature[!numXenosPlanet || numXenosPlanet > 1 ? "s":""] located elsewhere[numXenosPlanet&&RandomXenosPlanetLocation?", including one in [RandomXenosPlanetLocation]":""]."
		marine_announcement(input, name, 'sound/AI/bioscan.ogg')

/*
Count up surviving humans and aliens.
Can't be in a locker, in space, in the thunderdome, or distress.
Only checks living mobs with a client attached.
*/

/datum/game_mode/proc/count_xenos(list/z_levels = SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND, ZTRAIT_LOWORBIT, ZTRAIT_MARINE_MAIN_SHIP)))
	var/num_xenos = 0
	for(var/i in GLOB.living_xeno_list)
		var/mob/M = i
		if(M.z && (M.z in z_levels) && !istype(M.loc, /turf/open/space)) //If they have a z var, they are on a turf.
			num_xenos++
	return num_xenos

/datum/game_mode/proc/count_humans_and_xenos(list/z_levels = SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND, ZTRAIT_LOWORBIT, ZTRAIT_MARINE_MAIN_SHIP)))
	var/num_humans = 0
	var/num_xenos = 0

	for(var/mob/M in GLOB.player_list)
		if(M.z && (M.z in z_levels) && M.stat != DEAD && !istype(M.loc, /turf/open/space)) //If they have a z var, they are on a turf.
			if(ishuman(M) && !isYautja(M) && !(M.status_flags & XENO_HOST) && !iszombie(M))
				var/mob/living/carbon/human/H = M
				if(((H.species && H.species.name == "Human") || (H.is_important)) && !H.hivenumber) //only real humans count, or those we have set to also be included
					num_humans++
			else
				var/area/A = get_area(M)
				if(isXeno(M))
					var/mob/living/carbon/Xenomorph/xeno = M
					if(!xeno.counts_for_roundend)
						continue
					var/datum/hive_status/xeno_hive = GLOB.hive_datum[xeno.hivenumber]
					if(!xeno_hive || (xeno_hive.need_round_end_check && !xeno_hive.can_delay_round_end(xeno)))
						continue
					if (A.flags_area & AREA_AVOID_BIOSCAN)
						continue
					num_xenos++
				else if(iszombie(M))
					if (A.flags_area & AREA_AVOID_BIOSCAN)
						continue
					num_xenos++

	return list(num_humans,num_xenos)

/datum/game_mode/proc/count_marines_and_pmcs(list/z_levels = SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND, ZTRAIT_LOWORBIT, ZTRAIT_MARINE_MAIN_SHIP)))
	var/num_marines = 0
	var/num_pmcs = 0

	for(var/i in GLOB.alive_human_list)
		var/mob/M = i
		if(M.z && (M.z in z_levels) && !istype(M.loc, /turf/open/space))
			if(M.faction in FACTION_LIST_WY)
				num_pmcs++
			else if(M.faction == FACTION_MARINE)
				num_marines++

	return list(num_marines,num_pmcs)

/datum/game_mode/proc/count_marines(list/z_levels = SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND, ZTRAIT_LOWORBIT, ZTRAIT_MARINE_MAIN_SHIP)))
	var/num_marines = 0

	for(var/i in GLOB.alive_human_list)
		var/mob/M = i
		if(M.z && (M.z in z_levels) && !istype(M.loc, /turf/open/space))
			if(M.faction == FACTION_MARINE)
				num_marines++

	return num_marines


/*
#undef QUEEN_DEATH_COUNTDOWN
#undef MODE_INFESTATION_X_MAJOR
#undef MODE_INFESTATION_M_MAJOR
#undef MODE_INFESTATION_X_MINOR
#undef MODE_INFESTATION_M_MINOR
#undef MODE_INFESTATION_DRAW_DEATH
#undef MODE_BATTLEFIELD_W_MAJOR
#undef MODE_BATTLEFIELD_M_MAJOR
#undef MODE_BATTLEFIELD_W_MINOR
#undef MODE_BATTLEFIELD_M_MINOR
#undef MODE_BATTLEFIELD_DRAW_STALEMATE
#undef MODE_BATTLEFIELD_DRAW_DEATH
#undef MODE_GENERIC_DRAW_NUKE*/
