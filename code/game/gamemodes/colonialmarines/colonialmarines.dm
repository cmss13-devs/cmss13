#define HIJACK_EXPLOSION_COUNT 5
#define MARINE_MAJOR_ROUND_END_DELAY 3 MINUTES

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
	var/next_stat_check = 0
	var/list/running_round_stats = list()

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

/* Pre-pre-startup */
/datum/game_mode/colonialmarines/can_start()
	initialize_special_clamps()
	return TRUE

/datum/game_mode/colonialmarines/announce()
	to_chat_spaced(world, type = MESSAGE_TYPE_SYSTEM, html = SPAN_ROUNDHEADER("The current map is - [SSmapping.configs[GROUND_MAP].map_name]!"))

/datum/game_mode/colonialmarines/get_roles_list()
	return ROLES_DISTRESS_SIGNAL

////////////////////////////////////////////////////////////////////////////////////////
//Temporary, until we sort this out properly.
/obj/effect/landmark/lv624
	icon = 'icons/landmarks.dmi'

/obj/effect/landmark/lv624/fog_blocker
	name = "fog blocker"
	icon_state = "fog"

	var/time_to_dispel = 25 MINUTES

/obj/effect/landmark/lv624/fog_blocker/short
	time_to_dispel = 15 MINUTES

/obj/effect/landmark/lv624/fog_blocker/Initialize(mapload, ...)
	. = ..()

	return INITIALIZE_HINT_ROUNDSTART

/obj/effect/landmark/lv624/fog_blocker/LateInitialize()
	if(!(SSticker.mode.flags_round_type & MODE_FOG_ACTIVATED) || !SSmapping.configs[GROUND_MAP].environment_traits[ZTRAIT_FOG])
		return

	new /obj/structure/blocker/fog(loc, time_to_dispel)
	qdel(src)

/obj/effect/landmark/lv624/xeno_tunnel
	name = "xeno tunnel"
	icon_state = "xeno_tunnel"

/obj/effect/landmark/lv624/xeno_tunnel/Initialize(mapload, ...)
	. = ..()
	GLOB.xeno_tunnels += src

/obj/effect/landmark/lv624/xeno_tunnel/Destroy()
	GLOB.xeno_tunnels -= src
	return ..()

////////////////////////////////////////////////////////////////////////////////////////

/* Pre-setup */
/datum/game_mode/colonialmarines/pre_setup()
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

	addtimer(CALLBACK(src, PROC_REF(ares_online)), 5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(map_announcement)), 20 SECONDS)

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

/datum/game_mode/colonialmarines/proc/map_announcement()
	if(SSmapping.configs[GROUND_MAP].announce_text)
		var/rendered_announce_text = replacetext(SSmapping.configs[GROUND_MAP].announce_text, "###SHIPNAME###", MAIN_SHIP_NAME)
		marine_announcement(rendered_announce_text, "[MAIN_SHIP_NAME]")

/datum/game_mode/colonialmarines/proc/ares_conclude()
	ai_silent_announcement("Bioscan complete. No unknown lifeform signature detected.", ".V")
	ai_silent_announcement("Saving operational report to archive.", ".V")
	ai_silent_announcement("Commencing final systems scan in 3 minutes.", ".V")

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

#define PODLOCKS_OPEN_WAIT (45 MINUTES) // CORSAT pod doors drop at 12:45

//This is processed each tick, but check_win is only checked 5 ticks, so we don't go crazy with scanning for mobs.
/datum/game_mode/colonialmarines/process()
	. = ..()
	if(--round_started > 0)
		return FALSE //Initial countdown, just to be safe, so that everyone has a chance to spawn before we check anything.

	if(is_in_endgame)
		check_hijack_explosions()
		check_ground_humans()

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
			select_lz(locate(/obj/structure/machinery/computer/shuttle/dropship/flight/lz1))

		// Automated bioscan / Queen Mother message
		if(world.time > bioscan_current_interval) //If world time is greater than required bioscan time.
			announce_bioscans() //Announce the results of the bioscan to both sides.
			bioscan_current_interval += bioscan_ongoing_interval //Add to the interval based on our set interval time.

		if(++round_checkwin >= 5) //Only check win conditions every 5 ticks.
			if(!(round_status_flags & ROUNDSTATUS_PODDOORS_OPEN))
				if(SSmapping.configs[GROUND_MAP].environment_traits[ZTRAIT_LOCKDOWN])
					if(world.time >= (PODLOCKS_OPEN_WAIT + round_time_lobby))

						round_status_flags |= ROUNDSTATUS_PODDOORS_OPEN

						var/input = "Security lockdown will be lifting in 30 seconds per automated lockdown protocol."
						var/name = "Automated Security Authority Announcement"
						marine_announcement(input, name, 'sound/AI/commandreport.ogg')
						for(var/i in GLOB.living_xeno_list)
							var/mob/M = i
							sound_to(M, sound(get_sfx("queen"), wait = 0, volume = 50))
							to_chat(M, SPAN_XENOANNOUNCE("The Queen Mother reaches into your mind from worlds away."))
							to_chat(M, SPAN_XENOANNOUNCE("To my children and their Queen. I sense the large doors that trap us will open in 30 seconds."))
						addtimer(CALLBACK(src, PROC_REF(open_podlocks), "map_lockdown"), 300)

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

		if(next_stat_check <= world.time)
			add_current_round_status_to_end_results((next_stat_check ? "" : "Round Start"))
			next_stat_check = world.time + 10 MINUTES

/**
 * Primes and fires off the explodey-pipes during hijack.
 */
/datum/game_mode/colonialmarines/proc/check_hijack_explosions()
	if(TIMER_COOLDOWN_CHECK(src, COOLDOWN_HIJACK_BARRAGE))
		return

	var/list/shortly_exploding_pipes = list()
	for(var/i = 1 to HIJACK_EXPLOSION_COUNT)
		shortly_exploding_pipes += pick(GLOB.mainship_pipes)

	for(var/obj/structure/pipes/exploding_pipe as anything in shortly_exploding_pipes)
		exploding_pipe.warning_explode(5 SECONDS)

	addtimer(CALLBACK(src, PROC_REF(shake_ship)), 5 SECONDS)
	TIMER_COOLDOWN_START(src, COOLDOWN_HIJACK_BARRAGE, 15 SECONDS)

#define GROUNDSIDE_XENO_MULTIPLIER 1.0

///Checks for humans groundside after hijack, spawns forsaken if requirements met
/datum/game_mode/colonialmarines/proc/check_ground_humans()
	if(TIMER_COOLDOWN_CHECK(src, COOLDOWN_HIJACK_GROUND_CHECK))
		return

	var/groundside_humans = 0
	var/groundside_xenos = 0

	for(var/mob/current_mob in GLOB.player_list)
		if(!is_ground_level(current_mob.z) || !current_mob.client || current_mob.stat == DEAD)
			continue

		if(ishuman_strict(current_mob))
			groundside_humans++
			continue

		if(isxeno(current_mob))
			groundside_xenos++
			continue

	if(groundside_humans > (groundside_xenos * GROUNDSIDE_XENO_MULTIPLIER))
		SSticker.mode.get_specific_call("Xenomorphs Groundside (Forsaken)", TRUE, FALSE)

	TIMER_COOLDOWN_START(src, COOLDOWN_HIJACK_GROUND_CHECK, 1 MINUTES)

#undef GROUNDSIDE_XENO_MULTIPLIER

/**
 * Makes the mainship shake, along with playing a klaxon sound effect.
 */
/datum/game_mode/colonialmarines/proc/shake_ship()
	for(var/mob/current_mob in GLOB.living_mob_list)
		if(!is_mainship_level(current_mob.z))
			continue
		shake_camera(current_mob, 3, 1)

	playsound_z(SSmapping.levels_by_any_trait(list(ZTRAIT_MARINE_MAIN_SHIP)), 'sound/effects/double_klaxon.ogg', volume = 10)

#undef PODLOCKS_OPEN_WAIT

// Resource Towers

/datum/game_mode/colonialmarines/ds_first_drop(obj/docking_port/mobile/marine_dropship)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_blurb_uscm)), DROPSHIP_DROP_MSG_DELAY)
	add_current_round_status_to_end_results("First Drop")

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
				SSticker.roundend_check_paused = TRUE
				round_finished = MODE_INFESTATION_M_MAJOR //Humans destroyed the xenomorphs.
				ares_conclude()
				addtimer(VARSET_CALLBACK(SSticker, roundend_check_paused, FALSE), MARINE_MAJOR_ROUND_END_DELAY)
		else if(!num_humans && !num_xenos)
			round_finished = MODE_INFESTATION_DRAW_DEATH //Both were somehow destroyed.

/datum/game_mode/colonialmarines/check_queen_status(hivenumber)
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
#define MAJORITY 0.5 // What percent do we consider a 'majority?'

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
			var/list/living_player_list = count_humans_and_xenos(EvacuationAuthority.get_affected_zlevels())
			if(living_player_list[1] && !living_player_list[2]) // If Xeno Minor but Xenos are dead and Humans are alive, see which faction is the last standing
				var/headcount = count_per_faction()
				var/living = headcount["total_headcount"]
				if ((headcount["WY_headcount"] / living) > MAJORITY)
					musical_track = pick('sound/theme/lastmanstanding_wy.ogg')
				else if ((headcount["UPP_headcount"] / living) > MAJORITY)
					musical_track = pick('sound/theme/lastmanstanding_upp.ogg')
				else if ((headcount["CLF_headcount"] / living) > MAJORITY)
					musical_track = pick('sound/theme/lastmanstanding_clf.ogg')
				else if ((headcount["marine_headcount"] / living) > MAJORITY)
					musical_track = pick('sound/theme/neutral_melancholy2.ogg') //This is the theme song for Colonial Marines the game, fitting
			else
				musical_track = pick('sound/theme/neutral_melancholy1.ogg')
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
			musical_track = 'sound/theme/neutral_hopeful2.ogg'
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
	declare_fun_facts()


	add_current_round_status_to_end_results("Round End")
	handle_round_results_statistics_output()

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

/datum/game_mode/colonialmarines/proc/add_current_round_status_to_end_results(special_round_status as text)
	var/players = GLOB.clients
	var/list/counted_humans = list(
		"Squad Marines" = list(),
		"Auxiliary Marines" = list(),
		"Non-Standard Humans" = list()
	)

	//organize our jobs in a readable and standard way
	for(var/job in ROLES_MARINES)
		counted_humans["Squad Marines"][job] = 0
	for(var/job in ROLES_USCM - ROLES_MARINES)
		counted_humans["Auxiliary Marines"][job] = 0
	for(var/job in ROLES_SPECIAL)
		counted_humans["Non-Standard Humans"][job] = 0

	var/list/counted_xenos = list()

	//organize our hives and castes in a readable and standard way | don't forget our pooled larva
	for(var/hive in ALL_XENO_HIVES)
		counted_xenos[hive] = list()
		for(var/caste in ALL_XENO_CASTES)
			counted_xenos[hive][caste] = 0
		counted_xenos[hive]["Pooled Larva"] = GLOB.hive_datum[hive].stored_larva

	//Run through all our clients
	//add up our marines by job type, surv numbers, and non-standard humans we don't care too much about
	//add up our xenos by hive and caste
	for(var/client/player_client in players)
		if(player_client.mob && player_client.mob.stat != DEAD)
			if(ishuman(player_client.mob))
				if(player_client.mob.faction == FACTION_MARINE)
					if(player_client.mob.job in (ROLES_MARINES))
						counted_humans["Squad Marines"][player_client.mob.job]++
					else
						counted_humans["Auxiliary Marines"][player_client.mob.job]++
				else
					counted_humans["Non-Standard Humans"][player_client.mob.job]++
			else if(isxeno(player_client.mob))
				var/mob/living/carbon/xenomorph/xeno = player_client.mob
				counted_xenos[xeno.hivenumber][xeno.caste_type]++

	var/list/total_data = list("special round status" = special_round_status, "round time" = duration2text(), "counted humans" = counted_humans, "counted xenos" = counted_xenos)
	running_round_stats = running_round_stats + list(total_data)

/datum/game_mode/colonialmarines/proc/handle_round_results_statistics_output()
	var/webhook = CONFIG_GET(string/round_results_webhook_url)

	if(!webhook)
		return

	var/datum/discord_embed/embed = new()
	embed.title = "[SSperf_logging.round?.id]"
	embed.description = "[round_stats.round_name]\n[round_stats.map_name]\n[end_round_message()]"

	var/list/webhook_info = list()
	webhook_info["embeds"] = list(embed.convert_to_list())

	var/list/headers = list()
	headers["Content-Type"] = "application/json"

	var/list/requests = list()

	var/datum/http_request/beginning_request = new()
	beginning_request.prepare(RUSTG_HTTP_METHOD_POST, webhook, json_encode(webhook_info), headers, "tmp/response.json")

	requests += beginning_request

	for(var/list/round_status_report in running_round_stats)
		var/special_status = round_status_report["special round status"]
		var/round_time = round_status_report["round time"]

		var/field_name = "[special_status ? "[round_time] - [special_status]" : "[round_time]"]"

		var/total_marines = 0
		var/total_squad_marines = 0

		var/squad_marine_job_text = ""
		var/list/squad_marines_job_report = round_status_report["counted humans"]["Squad Marines"]
		var/incrementer = 0
		for(var/job_type in squad_marines_job_report)
			squad_marine_job_text += "[job_type]: [squad_marines_job_report[job_type]]"
			total_marines += squad_marines_job_report[job_type]
			total_squad_marines += squad_marines_job_report[job_type]
			incrementer++
			if(incrementer < squad_marines_job_report.len)
				squad_marine_job_text += ", "

		var/auxiliary_marine_job_text = ""
		var/list/auxiliary_marines_job_report = round_status_report["counted humans"]["Auxiliary Marines"]
		incrementer = 0
		for(var/job_type in auxiliary_marines_job_report)
			auxiliary_marine_job_text += "[job_type]: [auxiliary_marines_job_report[job_type]]"
			total_marines += auxiliary_marines_job_report[job_type]
			incrementer++
			if(incrementer < auxiliary_marines_job_report.len)
				auxiliary_marine_job_text += ", "

		var/total_non_standard = 0
		var/non_standard_job_text = ""
		incrementer = 0
		var/list/non_standard_job_report = round_status_report["counted humans"]["Non-Standard Humans"]
		for(var/job_type in non_standard_job_report)
			non_standard_job_text += "[job_type]: [non_standard_job_report[job_type]]"
			total_non_standard += non_standard_job_report[job_type]
			incrementer++
			if(incrementer < non_standard_job_report.len)
				non_standard_job_text += ", "

		var/list/hive_xeno_numbers = list()
		var/list/hive_caste_texts = list()
		for(var/hive in round_status_report["counted xenos"])
			var/hive_amount = 0
			var/hive_caste_text = ""
			incrementer = 0
			var/list/per_hive_status = round_status_report["counted xenos"][hive]
			for(var/hive_caste in per_hive_status)
				hive_caste_text += "[hive_caste]: [per_hive_status[hive_caste]]"
				hive_amount += per_hive_status[hive_caste]
				incrementer++
				if(incrementer < per_hive_status.len)
					hive_caste_text += ", "
			if(hive_amount)
				hive_xeno_numbers[hive] = hive_amount
				hive_caste_texts[hive] = hive_caste_text

		var/final_text = "Marines: [total_marines]\nSquad Marines: [total_squad_marines]\n\n"
		final_text += "Marine jobs:\n[auxiliary_marine_job_text], [squad_marine_job_text]\n\n"

		if(total_non_standard)
			final_text += "Non-standard jobs:\n[non_standard_job_text]\n\n"

		for(var/hive in hive_xeno_numbers)
			final_text += "[hive]\nXenos: [hive_xeno_numbers[hive]]\n\n"
			final_text += "Xeno castes:\n[hive_caste_texts[hive]]\n"

		var/datum/discord_embed/per_report_embed = new()
		per_report_embed.title = "[field_name]"
		per_report_embed.description = "[final_text]"

		var/list/per_report_webhook_info = list()
		per_report_webhook_info["embeds"] = list(per_report_embed.convert_to_list())

		var/datum/http_request/per_report_request = new()
		per_report_request.prepare(RUSTG_HTTP_METHOD_POST, webhook, json_encode(per_report_webhook_info), headers, "tmp/response.json")
		requests += per_report_request

	var/incrementer = 1
	for(var/datum/http_request/request in requests)
		addtimer(CALLBACK(request, TYPE_PROC_REF(/datum/http_request, begin_async)), (2 * incrementer) SECONDS)
		incrementer++

#undef HIJACK_EXPLOSION_COUNT
#undef MARINE_MAJOR_ROUND_END_DELAY
#undef MAJORITY
