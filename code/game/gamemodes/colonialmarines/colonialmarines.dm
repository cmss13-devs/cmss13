/datum/game_mode/colonialmarines
	name = "Distress Signal"
	config_tag = "Distress Signal"
	required_players = 1 //Need at least one player, but really we need 2.
	xeno_required_num = 1 //Need at least one xeno.
	monkey_amount = 5
	flags_round_type = MODE_INFESTATION|MODE_FOG_ACTIVATED|MODE_NEW_SPAWN
	var/round_status_flags

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

/* Pre-pre-startup */
/datum/game_mode/colonialmarines/can_start()
	initialize_special_clamps()
	return TRUE

/datum/game_mode/colonialmarines/announce()
	to_world("<span class='round_header'>The current map is - [map_tag]!</span>")

////////////////////////////////////////////////////////////////////////////////////////
//Temporary, until we sort this out properly.
/obj/effect/landmark/lv624
	icon = 'icons/old_stuff/mark.dmi'

/obj/effect/landmark/lv624/fog_blocker
	name = "fog blocker"
	icon_state = "spawn_event"

/obj/effect/landmark/lv624/fog_time_extender
	name = "fog time extender"
	icon_state = "spawn_event"
	var/time_to_extend = 9000

/obj/effect/landmark/lv624/xeno_tunnel
	name = "xeno tunnel"
	icon_state = "spawn_event"

////////////////////////////////////////////////////////////////////////////////////////

/* Pre-setup */
/datum/game_mode/colonialmarines/pre_setup()
	setup_round_stats()
	round_fog = new
	round_toxic_river = new
	var/xeno_tunnels[] = new
	var/map_items[] = new
	var/obj/structure/blocker/fog/F
	var/fog_timer = 0
	for(var/obj/effect/landmark/L in landmarks_list)
		switch(L.name)
			if("hunter_primary")
				qdel(L)
			if("hunter_secondary")
				qdel(L)
			if("crap_item")
				qdel(L)
			if("good_item")
				qdel(L)
			if("block_hellhound")
				qdel(L)
			if("fog blocker")
				F = new(L.loc)
				round_fog += F
				qdel(L)
			if("fog time extender")
				var/obj/effect/landmark/lv624/fog_time_extender/fte = L
				if(istype(fte))
					fog_timer += fte.time_to_extend
					qdel(L)
			if("toxic river blocker")
				F = new(L.loc)
				round_toxic_river += F
				qdel(L)
			if("xeno tunnel")
				xeno_tunnels += L.loc
				qdel(L)
			if("map item")
				map_items += L.loc
				qdel(L)

	// Spawn gamemode-specific map items
	for(var/turf/T in map_items)
		map_items -= T
		switch(map_tag)
			if(MAP_LV_624) new /obj/item/map/lazarus_landing_map(T)
			if(MAP_ICE_COLONY) new /obj/item/map/ice_colony_map(T)
			if(MAP_BIG_RED) new /obj/item/map/big_red_map(T)
			if(MAP_PRISON_STATION) new /obj/item/map/FOP_map(T)
			if(MAP_DESERT_DAM) new /obj/item/map/desert_dam(T)
			if(MAP_WHISKEY_OUTPOST) new /obj/item/map/whiskey_outpost_map(T)
			if(MAP_SOROKYNE_STRATA) new /obj/item/map/sorokyne_map(T)
			if(MAP_CORSAT) new /obj/item/map/corsat(T)
			if(MAP_KUTJEVO) new /obj/item/map/kutjevo_map(T)

	if(!round_fog.len) round_fog = null //No blockers?
	else
		round_time_fog = fog_timer + rand(-2500,2500)
		flags_round_type |= MODE_FOG_ACTIVATED

	//desert river test
	if(!round_toxic_river.len) round_toxic_river = null //No tiles?
	else
		round_time_river = rand(-100,100)
		flags_round_type |= MODE_FOG_ACTIVATED

	var/obj/structure/tunnel/T
	var/i = 0
	var/turf/t
	while(xeno_tunnels.len && i++ < 3)
		t = pick(xeno_tunnels)
		xeno_tunnels -= t
		T = new(t)
		T.id = "hole[i]"

	..()
	return TRUE

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

/* Post-setup */
//This happens after create_character, so our mob SHOULD be valid and built by now, but without job data.
//We move it later with transform_survivor but they might flicker at any start_loc spawn landmark effects then disappear.
//Xenos and survivors should not spawn anywhere until we transform them.
/datum/game_mode/colonialmarines/post_setup()
	initialize_post_marine_gear_list()
	initialize_map_resource_list()
	spawn_smallhosts()

	round_time_lobby = world.time

	addtimer(CALLBACK(src, .proc/ares_online), SECONDS_5)
	addtimer(CALLBACK(src, .proc/map_announcement), SECONDS_20)

	return ..()

#define MONKEYS_TO_MARINES_RATIO 1/20

/datum/game_mode/colonialmarines/proc/spawn_smallhosts()
	if(!marines_assigned)
		return

	var/list/monkey_spawns = list()
	for(var/obj/effect/landmark/L in landmarks_list)
		if(L.name == "monkey_spawn")
			monkey_spawns += L.loc
			qdel(L)

	switch(map_tag)
		if(MAP_LV_624)
			monkey_types = list(/mob/living/carbon/human/farwa, /mob/living/carbon/human/monkey, /mob/living/carbon/human/neaera, /mob/living/carbon/human/stok)
		if(MAP_ICE_COLONY)
			monkey_types = list(/mob/living/carbon/human/yiren)
		if(MAP_BIG_RED)
			monkey_types = list(/mob/living/carbon/human/neaera)
		if(MAP_KUTJEVO)
			monkey_types = list(/mob/living/carbon/human/neaera, /mob/living/carbon/human/stok)
		if(MAP_PRISON_STATION)
			monkey_types = list(/mob/living/carbon/human/monkey)
		if(MAP_DESERT_DAM)
			monkey_types = list(/mob/living/carbon/human/stok)
		if(MAP_SOROKYNE_STRATA)
			monkey_types = list(/mob/living/carbon/human/yiren)
		if(MAP_CORSAT)
			monkey_types = list(/mob/living/carbon/human/yiren, /mob/living/carbon/human/farwa, /mob/living/carbon/human/monkey, /mob/living/carbon/human/neaera, /mob/living/carbon/human/stok)
		else
			monkey_types = list(/mob/living/carbon/human/monkey) //make sure we always have a monkey type

	if(!length(monkey_types))
		return

	var/amount_to_spawn = round(marines_assigned * MONKEYS_TO_MARINES_RATIO)

	for(var/i in 0 to min(amount_to_spawn, length(monkey_spawns)))
		var/turf/T = pick(monkey_spawns)
		monkey_spawns -= T
		var/monkey_to_spawn = pick(monkey_types)
		new monkey_to_spawn(T)

/datum/game_mode/colonialmarines/proc/ares_online()
	var/name = "ARES Online"
	var/input = "ARES. Online. Good morning, marines."
	shipwide_ai_announcement(input, name, 'sound/AI/ares_online.ogg')

/datum/game_mode/colonialmarines/proc/map_announcement()
	switch(map_tag)
		if(MAP_LV_624)
			marine_announcement("An automated distress signal has been received from archaeology site Lazarus Landing, on border world LV-624. A response team from the [MAIN_SHIP_NAME] will be dispatched shortly to investigate.", "[MAIN_SHIP_NAME]")
		if(MAP_ICE_COLONY)
			marine_announcement("An automated distress signal has been received from archaeology site \"Shiva's Snowball\", on border ice world \"Ifrit\". A response team from the [MAIN_SHIP_NAME] will be dispatched shortly to investigate.", "[MAIN_SHIP_NAME]")
		if(MAP_BIG_RED)
			marine_announcement("We've lost contact with the Weston-Yamada's research facility, [map_tag]. The [MAIN_SHIP_NAME] has been dispatched to assist.", "[MAIN_SHIP_NAME]")
		if(MAP_PRISON_STATION)
			marine_announcement("An automated distress signal has been received from maximum-security prison \"Fiorina Orbital Penitentiary\". A response team from the [MAIN_SHIP_NAME] will be dispatched shortly to investigate.", "[MAIN_SHIP_NAME]")
		if(MAP_DESERT_DAM)
			marine_announcement("We've lost contact with Weston-Yamada's extra-solar colony, \"[map_tag]\", on the planet \"Navarone.\" The [MAIN_SHIP_NAME] has been dispatched to assist.", "[MAIN_SHIP_NAME]")
		if (MAP_SOROKYNE_STRATA)
			marine_announcement("An automated distress signal has been recieved from a mining colony on border world LV-976, \"Sorokyne Outpost\". A response team from the [MAIN_SHIP_NAME] will be dispatched shortly to investigate.", "[MAIN_SHIP_NAME]")
		if (MAP_CORSAT)
			marine_announcement("An automated distress signal has been received from Weston-Yamada's Corporate Orbital Research Station for Advanced Technology, or CORSAT. The [MAIN_SHIP_NAME] has been dispatched to investigate.", "[MAIN_SHIP_NAME]")
		if (MAP_KUTJEVO)
			marine_announcement("An automated distress signal has been received from Weston-Yamada colony Kutjevo Refinery, known for botanical research, export, and raw materials processing and refinement. The [MAIN_SHIP_NAME] has been dispatched to investigate.", "[MAIN_SHIP_NAME]")

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

#define FOG_DELAY_INTERVAL		MINUTES_30 // 30 minutes
#define PODLOCKS_OPEN_WAIT		MINUTES_45 // CORSAT pod doors drop at 12:45

//This is processed each tick, but check_win is only checked 5 ticks, so we don't go crazy with scanning for mobs.
/datum/game_mode/colonialmarines/process()
	. = ..()
	if(--round_started > 0)
		return FALSE //Initial countdown, just to be safe, so that everyone has a chance to spawn before we check anything.

	if(!round_finished)
		for(var/datum/hive_status/hive in hive_datum)
			if(!hive.living_xeno_queen && hive.xeno_queen_timer && world.time>hive.xeno_queen_timer) xeno_message("The Hive is ready for a new Queen to evolve.", 3, hive.hivenumber)

		if(!active_lz && world.time > lz_selection_timer)
			for(var/obj/structure/machinery/computer/shuttle_control/dropship1/default_console in machines)
				if(is_ground_level(default_console.z) && !default_console.onboard)
					select_lz(default_console)
					break

		// Automated bioscan / Queen Mother message
		if(world.time > bioscan_current_interval) //If world time is greater than required bioscan time.
			announce_bioscans() //Announce the results of the bioscan to both sides.
			bioscan_current_interval += bioscan_ongoing_interval //Add to the interval based on our set interval time.

		if(++round_checkwin >= 5) //Only check win conditions every 5 ticks.
			if(flags_round_type & MODE_FOG_ACTIVATED && map_tag == MAP_LV_624  && world.time >= (FOG_DELAY_INTERVAL + round_time_lobby + round_time_fog))
				disperse_fog() //Some RNG thrown in.
			if(!(round_status_flags & ROUNDSTATUS_PODDOORS_OPEN) && (map_tag == MAP_CORSAT || map_tag == MAP_PRISON_STATION) && world.time >= (PODLOCKS_OPEN_WAIT + round_time_lobby))
				round_status_flags |= ROUNDSTATUS_PODDOORS_OPEN

				var/input = "Security lockdown will be lifting in 30 seconds per automated lockdown protocol."
				var/name = "Automated Security Authority Announcement"
				marine_announcement(input, name, 'sound/AI/commandreport.ogg')
				for(var/i in GLOB.living_xeno_list)
					var/mob/M = i
					sound_to(M, sound(get_sfx("queen"), wait = 0, volume = 50))
					to_chat(M, SPAN_XENOANNOUNCE("The Queen Mother reaches into your mind from worlds away."))
					to_chat(M, SPAN_XENOANNOUNCE("To my children and their Queen. I sense the large doors that trap us will open in 30 seconds."))
				addtimer(CALLBACK(src, .proc/open_podlocks, "map_lockdown"), 300)

			if(round_should_check_for_win)
				check_win()
			round_checkwin = 0

		if(!(resin_allow_finished) && world.time >= round_time_resin)
			for(var/area/A in all_areas)
				if(!(A.is_resin_allowed))
					A.is_resin_allowed = TRUE
			resin_allow_finished = 1
			msg_admin_niche("Areas close to landing zones are now weedable.")


#undef FOG_DELAY_INTERVAL
#undef PODLOCKS_OPEN_WAIT

///////////////////////////
//Checks to see who won///
//////////////////////////
/datum/game_mode/colonialmarines/check_win()
	if(ticker.current_state != GAME_STATE_PLAYING)
		return

	var/living_player_list[] = count_humans_and_xenos(EvacuationAuthority.get_affected_zlevels())
	var/num_humans = living_player_list[1]
	var/num_xenos = living_player_list[2]

	if(force_end_at && world.time > force_end_at)
		round_finished = MODE_INFESTATION_X_MINOR
	if(EvacuationAuthority.dest_status == NUKE_EXPLOSION_FINISHED)
		round_finished = MODE_GENERIC_DRAW_NUKE //Nuke went off, ending the round.
	if(EvacuationAuthority.dest_status == NUKE_EXPLOSION_GROUND_FINISHED)
		round_finished = MODE_INFESTATION_M_MINOR //Nuke went off, ending the round.
	if(EvacuationAuthority.dest_status < NUKE_EXPLOSION_IN_PROGRESS) //If the nuke ISN'T in progress. We do not want to end the round before it detonates.
		if(!num_humans && num_xenos) //No humans remain alive.
			round_finished = MODE_INFESTATION_X_MAJOR //Evacuation did not take place. Everyone died.
		else if(num_humans && !num_xenos)
			if(ticker && ticker.mode && ticker.mode.is_in_endgame)
				round_finished = MODE_INFESTATION_X_MINOR //Evacuation successfully took place.
			else
				round_finished = MODE_INFESTATION_M_MAJOR //Humans destroyed the xenomorphs.
		else if(!num_humans && !num_xenos)
			round_finished = MODE_INFESTATION_DRAW_DEATH //Both were somehow destroyed.

/datum/game_mode/colonialmarines/check_queen_status(var/queen_time, var/hivenumber)
	set waitfor = 0
	var/datum/hive_status/hive = hive_datum[hivenumber]
	hive.xeno_queen_timer = world.time + queen_time SECONDS
	if(!(flags_round_type & MODE_INFESTATION)) return
	xeno_queen_deaths += 1
	var/num_last_deaths = xeno_queen_deaths
	sleep(QUEEN_DEATH_COUNTDOWN)
	//We want to make sure that another queen didn't die in the interim.

	if(xeno_queen_deaths == num_last_deaths && !round_finished)
		for(var/datum/hive_status/hs in hive_datum)
			if(hs.living_xeno_queen && !is_admin_level(hs.living_xeno_queen.loc.z))
				//Some Queen is alive, we shouldn't end the game yet
				return
		round_finished = MODE_INFESTATION_M_MINOR

///////////////////////////////
//Checks if the round is over//
///////////////////////////////
/datum/game_mode/colonialmarines/check_finished()
	if(round_finished) return 1

//////////////////////////////////////////////////////////////////////
//Announces the end of the game with all relevant information stated//
//////////////////////////////////////////////////////////////////////
/datum/game_mode/colonialmarines/declare_completion()
	announce_ending()
	var/musical_track
	var/end_icon = "draw"
	switch(round_finished)
		if(MODE_INFESTATION_X_MAJOR)
			musical_track = pick('sound/theme/sad_loss1.ogg','sound/theme/sad_loss2.ogg')
			end_icon = "xeno_major"
		if(MODE_INFESTATION_M_MAJOR)
			musical_track = pick('sound/theme/winning_triumph1.ogg','sound/theme/winning_triumph2.ogg')
			end_icon = "marine_major"
		if(MODE_INFESTATION_X_MINOR)
			musical_track = pick('sound/theme/neutral_melancholy1.ogg','sound/theme/neutral_melancholy2.ogg')
			end_icon = "xeno_minor"
		if(MODE_INFESTATION_M_MINOR)
			musical_track = pick('sound/theme/neutral_hopeful1.ogg','sound/theme/neutral_hopeful2.ogg')
			end_icon = "marine_minor"
		if(MODE_INFESTATION_DRAW_DEATH)
			end_icon = "draw"
			musical_track = pick('sound/theme/nuclear_detonation1.ogg','sound/theme/nuclear_detonation2.ogg')
	var/sound/S = sound(musical_track, channel = SOUND_CHANNEL_LOBBY)
	S.status = SOUND_STREAM
	sound_to(world, S)
	if(round_statistics)
		round_statistics.game_mode = name
		round_statistics.round_length = world.time
		round_statistics.end_round_player_population = GLOB.clients.len

		round_statistics.log_round_statistics()

	calculate_end_statistics()
	show_end_statistics(end_icon)

	declare_completion_announce_fallen_soldiers()
	announce_agents()
	declare_completion_announce_xenomorphs()
	declare_completion_announce_predators()
	declare_completion_announce_medal_awards()
	declare_random_fact()

	return 1

// for the toolbox
/datum/game_mode/colonialmarines/end_round_message()
	switch(round_finished)
		if(MODE_INFESTATION_X_MAJOR)
			return "Round has ended. Xeno Major Victory."
		if(MODE_INFESTATION_M_MAJOR)
			return "Round has ended. Marine Major Victory."
		if(MODE_INFESTATION_X_MINOR)
			return "Round has ended. Xeno Minor Victory."
		if(MODE_INFESTATION_M_MINOR)
			return "Round has ended. Marine Minor Victory."
		if(MODE_INFESTATION_DRAW_DEATH)
			return "Round has ended. Draw."
	return "Round has ended in a strange way."
