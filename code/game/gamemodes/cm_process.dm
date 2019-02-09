/*
/mob/verb/test_shuttle()
	set name = "DEBUG EVAC SHUTTLE"
	set category = "DEBUG"

	world << "Location is [emergency_shuttle.shuttle.location]"
	world << "Moving status is [emergency_shuttle.shuttle.moving_status]"
	world << "Departed is [emergency_shuttle.departed]"

*/
#define QUEEN_DEATH_COUNTDOWN 			 6000 //20 minutes. Can be changed into a variable if it needs to be manipulated later.

#define MODE_INFESTATION_X_MAJOR		"Xenomorph Major Victory"
#define MODE_INFESTATION_M_MAJOR		"Marine Major Victory"
#define MODE_INFESTATION_X_MINOR		"Xenomorph Minor Victory"
#define MODE_INFESTATION_M_MINOR		"Marine Minor Victory"
#define MODE_INFESTATION_DRAW_DEATH		"DRAW: Mutual Annihilation"

#define MODE_INFECTION_ZOMBIE_WIN		"Major Zombie Victory"

#define MODE_BATTLEFIELD_W_MAJOR		"W-Y PMC Major Success"
#define MODE_BATTLEFIELD_M_MAJOR		"Marine Major Success"
#define MODE_BATTLEFIELD_W_MINOR		"W-Y PMC Minor Success"
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
/datum/game_mode/proc/check_queen_status(queen_time)
	return

//===================================================\\

				//ANNOUNCE COMPLETION\\

//===================================================\\

/datum/game_mode/proc/declare_completion_announce_objectives()
	set waitfor = 0
	sleep(30)
	if(objectives_controller)
		var/dat = "<span class='round_body'>The objective scores were:</span><br>"
		dat += objectives_controller.get_objectives_progress()

		world << dat

/datum/game_mode/proc/declare_completion_announce_individual()
	set waitfor = 0
	sleep(45)
/*
//WIP proc to announce specific outcomes to players. Might require better tracking, but the basics wouldn't hurt.

dat = "You have met your demise during the events of [upper_text(name)][m.mind.current ? " as [m.mind.current.real_name]" : ]. Rest in peace."

dat = "<b>You have survived the events of [upper_text(name)]</b>"

//General disposition.
dat += ", but a sickly feeling in your chest suggests a darker fate awaits you..."
dat += ", but you find yourself in a sticky situation. Best to find a way out..."
//Pain/damage.
dat += " The pain is making it difficult to see straight. You are still reeling from the experience."
dat += " Your severe injuries will no-doubt be a topic for discussion in the future."
//Managed to get to evac safely.
dat += " At least you've made it to evac; it's all over now, right?"
//Failed to catch it.
dat += " You failed to evacuate \the [MAIN_SHIP_NAME]"


"<b>You have survived</b>
"<b>You have survived</b>, and you have managed to evacuate the [MAIN_SHIP_NAME]. Maybe it's finally over..."
"<b>You have survived</b>. That is more than enough, but who knows what the future holds for you now..."

"<span class='round_body'>You lead your hive, and you have survived. Your influence will grow in time.</span>"
"<span class='round_body'>You have served the hive.</span>"

	for(var/mob/m in player_list)
		if(m.mind)
			if(m.stat == DEAD) "<span class='round_body'>You met your demise during the events of [upper_text(name)].</span>"
			else
				if(isYautja(m))

				if(ishuman(m))
					is_mob_immobalized()
				if(isXeno(m))


				var/turf/T = get_turf(m)
				if(ishuman(H))

				var/turf/playerTurf = get_turf(Player)
				if(emergency_shuttle.departed && emergency_shuttle.evac)
					if(playerTurf.z != 2)
						Player << "<span class='round_body'>You managed to survive, but were marooned on [station_name] as [Player.real_name]...</span>"
					else
						Player << "<font color='green'><b>You managed to survive the events of [name] as [m.real_name].</b></font>"
				else if(playerTurf.z == 2)
					Player << "<font color='green'><b>You successfully underwent crew transfer after events on [station_name] as [Player.real_name].</b></font>"
				else if(issilicon(Player))
					Player << "<font color='green'><b>You remain operational after the events on [station_name] as [Player.real_name].</b></font>"
				else
					Player << "<font color='blue'><b>You missed the crew transfer after the events on [station_name] as [Player.real_name].</b></font>"
			else

	if(xenomorphs.len)
		var/dat = "<span class='round_body'>The xenomorph Queen(s) were:</span>"
		var/mob/M
		for(var/datum/mind/X in xenomorphs)
			if(istype(X))
				M = X.current
				if(!M || !M.loc) M = X.original
				if(M && M.loc && istype(M,/mob/living/carbon/Xenomorph/Queen)) dat += "<br>[X.key] was [M] <span class='boldnotice'>([M.stat == DEAD? "DIED":"SURVIVED"])</span>"

		world << dat
*/
/datum/game_mode/proc/declare_completion_announce_xenomorphs()
	set waitfor = 0
	sleep(60)
	if(xenomorphs.len)
		var/dat = "<span class='round_body'>The xenomorph Queen(s) were:</span>"
		var/mob/M
		for(var/datum/mind/X in xenomorphs)
			if(istype(X))
				M = X.current
				if(!M || !M.loc) M = X.original
				if(M && M.loc && istype(M,/mob/living/carbon/Xenomorph/Queen)) dat += "<br>[X.key] was [M] <span class='boldnotice'>([M.stat == DEAD? "DIED":"SURVIVED"])</span>"

		world << dat

/datum/game_mode/proc/declare_completion_announce_survivors()
	set waitfor = 0
	sleep(85)
	if(survivors.len)
		var/dat = "<span class='round_body'>The survivors were:</span>"
		var/mob/M
		for(var/datum/mind/S in survivors)
			if(istype(S))
				M = S.current
				if(!M || !M.loc) M = S.original
				if(M && M.loc) 	dat += "<br>[S.key] was [M.real_name] <span class='boldnotice'>([M.stat == DEAD? "DIED":"SURVIVED"])</span>"
				else 			dat += "<br>[S.key]'s body was destroyed... <span class='boldnotice'>(DIED)</span>"

		world << dat

/datum/game_mode/proc/declare_completion_announce_predators()
	set waitfor = 0
	sleep(100)
	if(predators.len)
		var/dat = "<span class='round_body'>The Predators were:</span>"
		var/mob/M
		for(var/datum/mind/P in predators)
			if(istype(P))
				M = P.current
				if(!M || !M.loc) M = P.original
				if(M && M.loc) 	dat += "<br>[P.key] was [M.real_name] <span class='boldnotice'>([M.stat == DEAD? "DIED":"SURVIVED"])</span>"
				else 			dat += "<br>[P.key]'s body was destroyed... <span class='boldnotice'>(DIED)</span>"

		world << dat


/datum/game_mode/proc/declare_completion_announce_medal_awards()
	set waitfor = 0
	sleep(120)
	if(medal_awards.len)
		var/dat =  "<span class='round_body'>Medal Awards:</span>"
		for(var/recipient in medal_awards)
			var/datum/recipient_awards/RA = medal_awards[recipient]
			for(var/i in 1 to RA.medal_names.len)
				dat += "<br><b>[RA.recipient_rank] [recipient]</b> is awarded [RA.posthumous[i] ? "posthumously " : ""]the <span class='boldnotice'>[RA.medal_names[i]]</span>: \'<i>[RA.medal_citations[i]]</i>\'."
		world << dat



//===================================================\\

					//HELPER PROCS\\

//===================================================\\

//Spawns a larva in an appropriate location
/datum/game_mode/proc/spawn_latejoin_larva()
	var/mob/living/carbon/Xenomorph/Larva/new_xeno = new /mob/living/carbon/Xenomorph/Larva(pick(xeno_spawn))
	new_xeno.visible_message("<span class='xenodanger'>A larva suddenly burrows out of the ground!</span>",
	"<span class='xenodanger'>You burrow out of the ground and awaken from your slumber. For the Hive!</span>")
	new_xeno << sound('sound/effects/xeno_newlarva.ogg')

//Disperses fog, doing so gradually.
/datum/game_mode/proc/disperse_fog()
	set waitfor = 0
	//world << "<span class='boldnotice'>The fog north of the colony is starting to recede.</span>" //Let's try it without an announcement.
	flags_round_type &= ~MODE_FOG_ACTIVATED
	var/i
	for(i in round_fog)
		round_fog -= i
		cdel(i)
		sleep(1)
	round_fog = null


//Variables for the below function that we need to keep throught the round
var/peakHumans = 1
var/peakXenos = 1

var/lastXenoBioscan = 18000//30 minutes in (we will add to that!)
var/lastHumanBioscan = 18000//30 minutes in (we will add to that!)
var/nextPredatorBioscan = 3000//5 minutes in
var/nextAdminBioscan = 18000//30 minutes in

//Delta is the randomness interval, in +/-. Might not be the exact mathematical definition
/datum/game_mode/proc/announce_bioscans(var/delta = 2)
	var/numHostsPlanet	= 0
	var/numHostsShip	= 0
	var/numXenosPlanet	= 0
	var/numXenosShip	= 0

	//We're assembling a list of locations so we can give hint about a random one
	var/list/hostsPlanetLocations = list()
	var/list/hostsShipLocations = list()
	var/list/xenosPlanetLocations = list()
	var/list/xenosShipLocations = list()

	var/larva = 0
	//Count all larva across all hives
	for(var/datum/hive_status/hs in hive_datum)
		larva += hs.stored_larva

	//Keeping track of peak numbers to determine when a side is "losing"
	if (peakHumans < living_human_list.len)
		peakHumans = living_human_list.len
	if (peakXenos < living_xeno_list.len)
		peakXenos = living_xeno_list.len

	for(var/mob/M in living_xeno_list)
		var/atom/where = M
		if (where == 0 && M.loc)
			where = M.loc
		switch(where.z)
			if(3)//On the ship
				numXenosShip++
				xenosShipLocations+=where
			if(1)//planet
				numXenosPlanet++
				xenosPlanetLocations+=where
			else numXenosPlanet++ //Elsewhere, nullspace, transit

	for (var/mob/M in living_human_list)
		var/atom/where = M
		if (where == 0 && M.loc)
			where = M.loc
		switch(where.z)
			if(3) //On the ship.
				numHostsShip++
				hostsShipLocations+=where
			if(1)//planet
				numHostsPlanet++
				hostsPlanetLocations+=where
			else numHostsPlanet++ //Elsewhere, nullspace, transit

	if (world.time > nextAdminBioscan)
		nextAdminBioscan += 18000//every 30 minutes, straight
		//Message the admins first before we tweak the numbers
		log_admin("A bioscan/Queen Mother message has completed. Humans: [numHostsPlanet] on the planet and [numHostsShip] on the ship. Xenos: [numXenosPlanet] on the planet and [numXenosShip] on the ship.")
		message_admins("A bioscan/Queen Mother message has completed. Humans: [numHostsPlanet] on the planet and [numHostsShip] on the ship. Xenos: [numXenosPlanet] on the planet and [numXenosShip] on the ship.", 1)

	//Pick one random location to disclose
	var/RandomHostsPlanetLocation = ""
	if (hostsPlanetLocations.len>0)
		RandomHostsPlanetLocation = get_area(hostsPlanetLocations[rand(1, hostsPlanetLocations.len)]).name
	var/RandomHostsShipLocation = ""
	if (hostsShipLocations.len>0)
		RandomHostsShipLocation = get_area(hostsShipLocations[rand(1, hostsShipLocations.len)]).name
	var/RandomXenosPlanetLocation = ""
	if (xenosPlanetLocations.len>0)
		RandomXenosPlanetLocation = get_area(xenosPlanetLocations[rand(1, xenosPlanetLocations.len)]).name
	var/RandomXenosShipLocation = ""
	if (xenosShipLocations.len>0)
		RandomXenosShipLocation = get_area(xenosShipLocations[rand(1, xenosShipLocations.len)]).name

	if(world.time > nextPredatorBioscan)
		nextPredatorBioscan += 3000//5 minutes, straight
		for(var/mob/M in player_list)
			//Announce the numbers to Yautja, they have good scanners
			if (isYautja(M))
				M << "<h2 class='alert'>Bioscan complete</h2>"
				M << "<span class='alert'>[numXenosPlanet] serpents present in the hunting ground[RandomXenosPlanetLocation?", including one in [RandomXenosPlanetLocation]":""], with [larva] larva.\n[numXenosShip] serpents present on the ooman ship[RandomXenosShipLocation?", including one in [RandomXenosShipLocation].":"."]\n[numHostsPlanet] oomans present in the hunting ground[RandomHostsPlanetLocation?", including one in [RandomHostsPlanetLocation].":"."]\n[numHostsShip] oomans present on the ooman ship[RandomHostsShipLocation?", including one in [RandomHostsShipLocation].":"."]</span>"

			//Let the ghosts know what's up, they also get good numbers
			if (isobserver(M))
				M << "<h2 class='alert'>Bioscan complete</h2>"
				M << "<span class='alert'>[numXenosPlanet] xenos on planet, with [larva] larva.\n[numXenosShip] xenos on the ship.\n[numHostsPlanet] humans on the planet.\n[numHostsShip] humans on the ship.</span>"

	//Adjust the randomness there so everyone gets the same thing
	numHostsShip = max(0, numHostsShip + rand(-delta, delta))
	numXenosPlanet = max(0, numXenosPlanet + rand(-delta, delta))

	//Depending on how either side is doing, we speed up the bioscans
	//Formula is - last bioscan time, plus 30 minutes multiplied by ratio of current pop divided by highest pop
	//So if you have peak 30 xenos, if you still have 30 xenos, humans will have to wait 30 minutes between bioscans
	//But if you fall down to 15 xenos, humans will get them every 15 minutes
	//But never more often than 5 minutes apart
	var/nextXenoBioscan = lastXenoBioscan + max(18000 * living_human_list.len / peakHumans, 3000)
	var/nextHumanBioscan = lastHumanBioscan + max(18000 * living_xeno_list.len / peakXenos, 3000)

	if(world.time > nextXenoBioscan)
		lastXenoBioscan = world.time
		// The announcement to all Xenos. Slightly off for the human ship, accurate otherwise.
		for(var/mob/M in player_list)
			if(isXeno(M))
				M << sound(get_sfx("queen"), wait = 0, volume = 50)
				M << "<span class='xenoannounce'>The Queen Mother reaches into your mind from worlds away.</span>"
				M << "<span class='xenoannounce'>To my children and their Queen. I sense [numHostsShip ? "approximately [numHostsShip]":"no"] host[!numHostsShip || numHostsShip > 1 ? "s":""] in the metal hive[numHostsShip&&RandomHostsShipLocation?", including one in [RandomHostsShipLocation],":""] and [numHostsPlanet ? "[numHostsPlanet]":"none"] scattered elsewhere[numHostsPlanet&&RandomHostsPlanetLocation?", including one in [RandomHostsPlanetLocation]":""].</span>"


	if(world.time > nextHumanBioscan)
		lastHumanBioscan = world.time
		// The announcement to all Humans. Slightly off for the planet and elsewhere, accurate for the ship.
		var/name = "[MAIN_AI_SYSTEM] Bioscan Status"
		var/input = "Bioscan complete.\n\nSensors indicate [numXenosShip ? "[numXenosShip]":"no"] unknown lifeform signature[!numXenosShip || numXenosShip > 1 ? "s":""] present on the ship[numXenosShip&&RandomXenosShipLocation?", including one in [RandomXenosShipLocation],":""] and [numXenosPlanet ? "approximately [numXenosPlanet]":"no"] signature[!numXenosPlanet || numXenosPlanet > 1 ? "s":""] located elsewhere[numXenosPlanet&&RandomXenosPlanetLocation?", including one in [RandomXenosPlanetLocation]":""]."
		command_announcement.Announce(input, name, new_sound = 'sound/AI/bioscan.ogg')

/*
Count up surviving humans and aliens.
Can't be in a locker, in space, in the thunderdome, or distress.
Only checks living mobs with a client attached.
*/

/datum/game_mode/proc/count_xenos(list/z_levels = GAME_PLAY_Z_LEVELS)
	var/num_xenos = 0
	for(var/mob/M in player_list)
		if(M.z && (M.z in z_levels) && M.stat != DEAD && !istype(M.loc, /turf/open/space)) //If they have a z var, they are on a turf.
			if(isXeno(M)) num_xenos++
	return num_xenos
	
/datum/game_mode/proc/count_humans_and_xenos(list/z_levels = GAME_PLAY_Z_LEVELS)
	var/num_humans = 0
	var/num_xenos = 0

	for(var/mob/M in player_list)
		if(M.z && (M.z in z_levels) && M.stat != DEAD && !istype(M.loc, /turf/open/space)) //If they have a z var, they are on a turf.
			if(ishuman(M) && !isYautja(M) && !(M.status_flags & XENO_HOST) && !iszombie(M))
				var/mob/living/carbon/human/H = M
				if(H.species && H.species.name == "Human") //only real humans count
					num_humans++
			else if(isXeno(M)) num_xenos++
			else if(iszombie(M)) num_xenos++

	return list(num_humans,num_xenos)

/datum/game_mode/proc/count_marines_and_pmcs(list/z_levels = GAME_PLAY_Z_LEVELS)
	var/num_marines = 0
	var/num_pmcs = 0

	for(var/mob/M in living_human_list)
		if(M.z && (M.z in z_levels) && M.stat != DEAD && !istype(M.loc, /turf/open/space))
			if(ishuman(M) && !isYautja(M))
				if(M.mind && M.mind.special_role == "PMC") 	num_pmcs++
				else if(M.mind && !M.mind.special_role)		num_marines++

	return list(num_marines,num_pmcs)

/datum/game_mode/proc/count_marines(list/z_levels = GAME_PLAY_Z_LEVELS)
	var/num_marines = 0

	for(var/mob/M in living_human_list)
		if(M.z && (M.z in z_levels) && M.stat != DEAD && !istype(M.loc, /turf/open/space))
			if(ishuman(M) && !isYautja(M))
				if(M.mind && !M.mind.special_role)		num_marines++

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
