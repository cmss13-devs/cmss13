/datum/game_mode/colonialmarines
	name = "Distress Signal"
	config_tag = "Distress Signal"
	required_players = 1 //Need at least one player, but really we need 2.
	xeno_required_num = 1 //Need at least one xeno.
	monkey_amount = 5
	corpses_to_spawn = 0
	flags_round_type = MODE_INFESTATION|MODE_FOG_ACTIVATED|MODE_NEW_SPAWN
	static_comms_amount = 1
	var/round_status_flags

	var/research_allocation_interval = 10 MINUTES
	var/next_research_allocation = 0

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

/* Pre-pre-startup */
/datum/game_mode/colonialmarines/can_start()
	initialize_special_clamps()
	return TRUE

/datum/game_mode/colonialmarines/announce()
	to_chat_spaced(world, type = MESSAGE_TYPE_SYSTEM, html = SPAN_ROUNDHEADER("The current map is - [SSmapping.configs[GROUND_MAP].map_name]!"))

////////////////////////////////////////////////////////////////////////////////////////
//Temporary, until we sort this out properly.
/obj/effect/landmark/lv624
	icon = 'icons/old_stuff/mark.dmi'

/obj/effect/landmark/lv624/fog_blocker
	name = "fog blocker"
	icon_state = "spawn_event"

/obj/effect/landmark/lv624/fog_blocker/Initialize(mapload, ...)
	. = ..()
	GLOB.fog_blockers += src

/obj/effect/landmark/lv624/fog_blocker/Destroy()
	GLOB.fog_blockers -= src
	return ..()

/obj/effect/landmark/lv624/xeno_tunnel
	name = "xeno tunnel"
	icon_state = "spawn_event"

/obj/effect/landmark/lv624/xeno_tunnel/Initialize(mapload, ...)
	. = ..()
	GLOB.xeno_tunnels += src

/obj/effect/landmark/lv624/xeno_tunnel/Destroy()
	GLOB.xeno_tunnels -= src
	return ..()

////////////////////////////////////////////////////////////////////////////////////////

/* Pre-setup */
/datum/game_mode/colonialmarines/pre_setup()
	for(var/i in GLOB.fog_blockers)
		var/obj/effect/landmark/lv624/fog_blocker/FB = i
		round_fog += new /obj/structure/blocker/fog(FB.loc)
		qdel(FB)

	QDEL_LIST(GLOB.hunter_primaries)
	QDEL_LIST(GLOB.hunter_secondaries)
	QDEL_LIST(GLOB.crap_items)
	QDEL_LIST(GLOB.good_items)

	// Spawn gamemode-specific map items
	if(SSmapping.configs[GROUND_MAP].map_item_type)
		var/type_to_spawn = SSmapping.configs[GROUND_MAP].map_item_type
		for(var/i in GLOB.map_items)
			var/turf/T = get_turf(i)
			qdel(i)
			new type_to_spawn(T)

	if(!round_fog.len)
		round_fog = null //No blockers?
	else
		flags_round_type |= MODE_FOG_ACTIVATED

	//desert river test
	if(!round_toxic_river.len)
		round_toxic_river = null //No tiles?
	else
		round_time_river = rand(-100,100)
		flags_round_type |= MODE_FOG_ACTIVATED

	..()

	var/obj/structure/tunnel/T
	var/i = 0
	var/turf/t
	while(GLOB.xeno_tunnels.len && i++ < 3)
		t = get_turf(pick_n_take(GLOB.xeno_tunnels))
		T = new(t)
		T.id = "hole[i]"
	return TRUE

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

/* Post-setup */
//This happens after create_character, so our mob SHOULD be valid and built by now, but without job data.
//We move it later with transform_survivor but they might flicker at any start_loc spawn landmark effects then disappear.
//Xenos and survivors should not spawn anywhere until we transform them.
/datum/game_mode/colonialmarines/post_setup()
	initialize_post_marine_gear_list()
	spawn_smallhosts()

	if(SSmapping.configs[GROUND_MAP].environment_traits[ZTRAIT_BASIC_RT])
		flags_round_type |= MODE_BASIC_RT

	round_time_lobby = world.time

	addtimer(CALLBACK(src, .proc/ares_online), 5 SECONDS)
	addtimer(CALLBACK(src, .proc/map_announcement), 20 SECONDS)

	return ..()

#define MONKEYS_TO_TOTAL_RATIO 1/32

/datum/game_mode/colonialmarines/proc/spawn_smallhosts()
	if(!players_preassigned)
		return

	monkey_types = SSmapping.configs[GROUND_MAP].monkey_types

	if(!length(monkey_types))
		return

	var/amount_to_spawn = round(players_preassigned * MONKEYS_TO_TOTAL_RATIO)

	for(var/i in 0 to min(amount_to_spawn, length(GLOB.monkey_spawns)))
		var/turf/T = get_turf(pick_n_take(GLOB.monkey_spawns))
		var/monkey_to_spawn = pick(monkey_types)
		new monkey_to_spawn(T)

/datum/game_mode/colonialmarines/proc/ares_online()
	var/name = "ARES Online"
	var/input = "ARES. Online. Good morning, marines."
	shipwide_ai_announcement(input, name, 'sound/AI/ares_online.ogg')

/datum/game_mode/colonialmarines/proc/map_announcement()
	if(SSmapping.configs[GROUND_MAP].announce_text)
		var/rendered_announce_text = replacetext(SSmapping.configs[GROUND_MAP].announce_text, "###SHIPNAME###", MAIN_SHIP_NAME)
		marine_announcement(rendered_announce_text, "[MAIN_SHIP_NAME]")

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

#define FOG_DELAY_INTERVAL		(25 MINUTES)
#define PODLOCKS_OPEN_WAIT		(45 MINUTES) // CORSAT pod doors drop at 12:45

//This is processed each tick, but check_win is only checked 5 ticks, so we don't go crazy with scanning for mobs.
/datum/game_mode/colonialmarines/process()
	. = ..()
	if(--round_started > 0)
		return FALSE //Initial countdown, just to be safe, so that everyone has a chance to spawn before we check anything.

	if(next_research_allocation < world.time)
		chemical_data.update_credits(chemical_data.research_allocation_amount)
		next_research_allocation = world.time + research_allocation_interval

	if(!round_finished)
		var/datum/hive_status/hive
		for(var/hivenumber in GLOB.hive_datum)
			hive = GLOB.hive_datum[hivenumber]
			if(!hive.xeno_queen_timer)
				continue

			if(!hive.living_xeno_queen && hive.xeno_queen_timer < world.time)
				xeno_message("The Hive is ready for a new Queen to evolve.", 3, hive.hivenumber)

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
			if(flags_round_type & MODE_FOG_ACTIVATED && SSmapping.configs[GROUND_MAP].environment_traits[ZTRAIT_FOG] && world.time >= (FOG_DELAY_INTERVAL + SSticker.round_start_time))
				disperse_fog() //Some RNG thrown in.
			if(!(round_status_flags & ROUNDSTATUS_PODDOORS_OPEN) && SSmapping.configs[GROUND_MAP].environment_traits[ZTRAIT_LOCKDOWN] && world.time >= (PODLOCKS_OPEN_WAIT + round_time_lobby))
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

		if(!evolution_ovipositor_threshold && world.time >= SSticker.round_start_time + round_time_evolution_ovipositor)
			for(var/hivenumber in GLOB.hive_datum)
				hive = GLOB.hive_datum[hivenumber]
				hive.evolution_without_ovipositor = FALSE
				if(hive.living_xeno_queen && !hive.living_xeno_queen.ovipositor)
					to_chat(hive.living_xeno_queen, SPAN_XENODANGER("It is time to settle down and let your children grow."))
			evolution_ovipositor_threshold = TRUE
			msg_admin_niche("Xenomorphs now require the queen's ovipositor for evolution progress.")

		if(!GLOB.resin_lz_allowed && world.time >= SSticker.round_start_time + round_time_resin)
			set_lz_resin_allowed(TRUE)

#undef FOG_DELAY_INTERVAL
#undef PODLOCKS_OPEN_WAIT

// Resource Towers

/datum/game_mode/colonialmarines/ds_first_drop(var/datum/shuttle/ferry/marine/m_shuttle)
	addtimer(CALLBACK(GLOBAL_PROC, /proc/show_blurb_uscm), DROPSHIP_DROP_MSG_DELAY)

///////////////////////////
//Checks to see who won///
//////////////////////////
/datum/game_mode/colonialmarines/check_win()
	if(SSticker.current_state != GAME_STATE_PLAYING)
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
			if(SSticker.mode && SSticker.mode.is_in_endgame)
				round_finished = MODE_INFESTATION_X_MINOR //Evacuation successfully took place.
			else
				round_finished = MODE_INFESTATION_M_MAJOR //Humans destroyed the xenomorphs.
		else if(!num_humans && !num_xenos)
			round_finished = MODE_INFESTATION_DRAW_DEATH //Both were somehow destroyed.

/datum/game_mode/colonialmarines/check_queen_status(var/hivenumber)
	set waitfor = 0
	if(!(flags_round_type & MODE_INFESTATION)) return
	xeno_queen_deaths++
	var/num_last_deaths = xeno_queen_deaths
	sleep(QUEEN_DEATH_COUNTDOWN)
	//We want to make sure that another queen didn't die in the interim.

	if(xeno_queen_deaths == num_last_deaths && !round_finished)
		var/datum/hive_status/HS
		for(var/HN in GLOB.hive_datum)
			HS = GLOB.hive_datum[HN]
			if(HS.living_xeno_queen && !is_admin_level(HS.living_xeno_queen.loc.z))
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
			if(round_statistics && round_statistics.current_map)
				round_statistics.current_map.total_xeno_victories++
				round_statistics.current_map.total_xeno_majors++
		if(MODE_INFESTATION_M_MAJOR)
			musical_track = pick('sound/theme/winning_triumph1.ogg','sound/theme/winning_triumph2.ogg')
			end_icon = "marine_major"
			if(round_statistics && round_statistics.current_map)
				round_statistics.current_map.total_marine_victories++
				round_statistics.current_map.total_marine_majors++
		if(MODE_INFESTATION_X_MINOR)
			musical_track = pick('sound/theme/neutral_melancholy1.ogg','sound/theme/neutral_melancholy2.ogg')
			end_icon = "xeno_minor"
			if(round_statistics && round_statistics.current_map)
				round_statistics.current_map.total_xeno_victories++
		if(MODE_INFESTATION_M_MINOR)
			musical_track = pick('sound/theme/neutral_hopeful1.ogg','sound/theme/neutral_hopeful2.ogg')
			end_icon = "marine_minor"
			if(round_statistics && round_statistics.current_map)
				round_statistics.current_map.total_marine_victories++
		if(MODE_INFESTATION_DRAW_DEATH)
			end_icon = "draw"
			musical_track = pick('sound/theme/nuclear_detonation1.ogg','sound/theme/nuclear_detonation2.ogg')
			if(round_statistics && round_statistics.current_map)
				round_statistics.current_map.total_draws++
	var/sound/S = sound(musical_track, channel = SOUND_CHANNEL_LOBBY)
	S.status = SOUND_STREAM
	sound_to(world, S)
	if(round_statistics)
		round_statistics.game_mode = name
		round_statistics.round_length = world.time
		round_statistics.round_result = round_finished
		round_statistics.end_round_player_population = GLOB.clients.len

		round_statistics.log_round_statistics()

	calculate_end_statistics()
	show_end_statistics(end_icon)

	declare_completion_announce_fallen_soldiers()
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
