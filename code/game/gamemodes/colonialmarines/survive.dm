/// How many smallhosts to preassigned players to spawn?
#define MONKEYS_TO_TOTAL_RATIO 1/32
/// When to start opening the podlocks identified as "map_lockdown" (takes 30s)
#define PODLOCKS_OPEN_WAIT (45 MINUTES) // CORSAT pod doors drop at 12:45
/// What percent do we consider a 'majority?' to win
#define MAJORITY 0.5

/datum/game_mode/survive
	name = GAMEMODE_SURVIVE
	config_tag = GAMEMODE_SURVIVE
	required_players = 1 //Need at least one player, but really we need 2.
	max_players = 50
	corpses_to_spawn = 0
	flags_round_type = MODE_SURVIVE|MODE_INFESTATION|MODE_FOG_ACTIVATED|MODE_NEW_SPAWN|MODE_NO_LATEJOIN
	static_comms_amount = 1
	role_mappings = list(/datum/job/civilian/survivor/unlimited = JOB_SURVIVOR)
	var/round_status_flags
	var/next_stat_check = 0
	var/list/running_round_stats = list()
	var/obj/docking_port/mobile/emergency_response/shuttle

/datum/game_mode/survive/can_start(bypass_checks)
	return TRUE

/datum/game_mode/survive/announce()
	to_chat_spaced(world, type = MESSAGE_TYPE_SYSTEM, html = SPAN_ROUNDHEADER("The current map is - [SSmapping.configs[GROUND_MAP].map_name]!"))

/datum/game_mode/survive/get_roles_list()
	return GLOB.ROLES_SURVIVE

/* Pre-setup */
/datum/game_mode/survive/pre_setup()
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
	if(!length(round_toxic_river))
		round_toxic_river = null //No tiles?
	else
		round_time_river = rand(-100,100)
		flags_round_type |= MODE_FOG_ACTIVATED

	..()

	if(!length(GLOB.observer_starts))
		var/obj/comms_poi = locate(/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms)
		var/turf/comms_turf = get_turf(comms_poi)
		new /obj/effect/landmark/observer_start(comms_turf)

	var/datum/hive_status/main_hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
	main_hive.allow_queen_evolve = FALSE
	main_hive.evolution_without_ovipositor = TRUE
	main_hive.allow_no_queen_actions = TRUE

	var/obj/structure/tunnel/tunnel
	var/i = 0
	var/turf/location
	while(length(GLOB.xeno_tunnels) && i++ < 3)
		location = get_turf(pick_n_take(GLOB.xeno_tunnels))
		tunnel = new(location)
		tunnel.id = "hole[i]"
	return TRUE

/datum/game_mode/survive/transform_queen(datum/mind/ghost_mind, turf/xeno_turf, hivenumber)
	var/turf/origin = locate(xeno_turf.x-3, xeno_turf.y-3, xeno_turf.z)
	var/datum/map_template/template = SSmapping.map_templates["Queen_Resin.dmm"]
	if(!template?.load(origin, centered=FALSE, delete=TRUE))
		stack_trace("Queen resin template failed to load!")
	..()

/* Post-setup */
//This happens after create_character, so our mob SHOULD be valid and built by now, but without job data.
//We move it later with transform_survivor but they might flicker at any start_loc spawn landmark effects then disappear.
//Xenos and survivors should not spawn anywhere until we transform them.
/datum/game_mode/survive/post_setup()
	initialize_post_marine_gear_list()
	spawn_smallhosts()

	if(SSmapping.configs[GROUND_MAP].environment_traits[ZTRAIT_BASIC_RT])
		flags_round_type |= MODE_BASIC_RT

	addtimer(CALLBACK(src, PROC_REF(mode_announcement)), 10 DECISECONDS)
	addtimer(CALLBACK(src, PROC_REF(map_announcement)), 20 SECONDS)
	addtimer(CALLBACK(SSentity_manager, TYPE_PROC_REF(/datum/controller/subsystem/entity_manager, select), /datum/entity/survivor_survival), 7 MINUTES)
	addtimer(CALLBACK(src, PROC_REF(release_the_queen)), 30 MINUTES)

	return ..()

/datum/game_mode/survive/proc/spawn_smallhosts()
	if(!GLOB.players_preassigned)
		return

	monkey_types = SSmapping.configs[GROUND_MAP].monkey_types

	if(!length(monkey_types))
		return

	var/amount_to_spawn = floor(GLOB.players_preassigned * MONKEYS_TO_TOTAL_RATIO)

	for(var/i in 0 to min(amount_to_spawn, length(GLOB.monkey_spawns)))
		var/turf/T = get_turf(pick_n_take(GLOB.monkey_spawns))
		var/monkey_to_spawn = pick(monkey_types)
		new monkey_to_spawn(T)

/datum/game_mode/survive/proc/mode_announcement()
	to_world(SPAN_ROUNDHEADER("The current game mode is - SURVIVAL!"))
	to_world(SPAN_ROUNDBODY("The colony on [SSmapping.configs[GROUND_MAP].map_name] has come under attack from alien forces."))
	to_world(SPAN_ROUNDBODY("Most survivors have already fled or perished, but maybe those left can manage to call for help."))
	to_world(SPAN_ROUNDBODY("Maybe if communications remain online long enough someone will receive the distress signal."))

/datum/game_mode/survive/proc/map_announcement()
	var/rendered_announce_text = SSmapping.configs[GROUND_MAP].survive_announce_text || "Attention. Attention. Evacuation order is in effect."
	survivor_announcement(rendered_announce_text, sound_to_play='sound/effects/siren.ogg')
	lore_announcement()

/datum/game_mode/survive/proc/lore_announcement()
	//A proc that will queue up announcements for the lore of the map.
	switch(SSmapping.configs[GROUND_MAP].map_name)
		if(MAP_TYRARGO_RIFT)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(xeno_announcement), "My children. A great battle rages across this world, a world slathered in hosts for our taking! However, these hosts fight back with great ferocity. I have directed your sub-hive to this area, you will create a mighty cordon here to cover our western flank whilst another sub-hive overtakes a stronghold to your east that is filled with thousands of hosts!\n\nIn order to aid you, I have dispatched a legion of disposable drones ahead of you, they are far less intelligent than you, but will suffice in waylaying any remaining hostile hosts to your west until you have secured yourselves.", "everything", QUEEN_MOTHER_ANNOUNCE), 20 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(xeno_announcement), "Be on guard my children. I have sensed that the petrid sewers of this so called city could be flooded by the hosts at a moments notice if the hosts restore power to the area. The button to release this putrid water is found in the metal structure the hosts call the sewer treatement plant.", "everything", QUEEN_MOTHER_ANNOUNCE), 15 MINUTES)
		if(MAP_WHITE_ANTRE_RESEARCH_FACILITY)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(survivor_announcement), "Attention! The site is experiencing a massive containment breach! Full site lockdown initiated.", "White Antre Central Announcement", 'sound/ambience/containment_breach1.ogg'), 30 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(survivor_announcement), "Attention! We think Azure-15 has lured the bulk of the K-Series off site, but we are experiencing massive power failures, the Prime hive containment zone is at risk. All surviving personnel prepa%^@!&*------", "White Antre Central Announcement", 'sound/AI/commandreport.ogg'), 65 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(survivor_announcement), "Prime hive containment blastdoor failure imminent.", "Automated Facility Announcement", 'sound/AI/commandreport.ogg'), 165 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(xeno_lore_announcement), "Something is happening. Be on guard.", "everything", QUEEN_MOTHER_ANNOUNCE, 'sound/ambience/containment_breach1.ogg'), 30 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(xeno_announcement), "Another, hostile, hive is making an escape from this metal cage, prepare yourselves as a chance to escape may occur soon.", "everything", QUEEN_MOTHER_ANNOUNCE), 1.5 MINUTES)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(xeno_announcement), "My children. I sense the hostile, putrid, hive has fled this area, but some of the hosts that entrapped you remain alive within this metal complex. Defeat these hosts to showcase your supremacy!", "everything", QUEEN_MOTHER_ANNOUNCE), 165 SECONDS)

/datum/game_mode/survive/proc/initiate_evacuation()
	if(is_in_endgame)
		return

	is_in_endgame = TRUE
	force_end_at = world.time + 15 MINUTES

	release_the_queen()

	var/datum/map_template/shuttle/new_shuttle = SSmapping.shuttle_templates[MOBILE_SHUTTLE_ID_ERT_ALAMO]
	shuttle = SSshuttle.load_template_to_transit(new_shuttle)
	shuttle.control_doors("force-lock", force=TRUE, external_only=TRUE)

	var/dock_options = list()
	for(var/obj/docking_port/stationary/dock as anything in SSshuttle.stationary)
		if(!is_ground_level(dock.z))
			continue
		if(shuttle.canDock(dock) != SHUTTLE_CAN_DOCK)
			continue
		dock_options += dock

	if(!length(dock_options))
		message_admins("Auto shuttle has no lzs available.")
		return

	var/obj/docking_port/stationary/dock = pick(dock_options)
	RegisterSignal(dock, COMSIG_SHUTTLE_ARRIVAL, PROC_REF(on_shuttle_arrival))
	SSshuttle.moveShuttleToDock(shuttle, dock, TRUE)
	var/datum/emergency_call/ert = SSticker.mode.get_specific_call(/datum/emergency_call/solar_devils_full/survivor_response, TRUE, FALSE)
	shuttle.distress_beacon = ert
	survivor_announcement("[ert.arrival_message] We are enroute to [dock].")

/datum/game_mode/survive/proc/on_shuttle_arrival(obj/docking_port/stationary/port, obj/docking_port/mobile/arriving_shuttle)
	xeno_announcement(SPAN_XENOANNOUNCE("A dropship has landed. The tallhosts are escaping!"), "everything", QUEEN_MOTHER_ANNOUNCE)

/datum/game_mode/survive/proc/release_the_queen()
	if(!length(GLOB.marked_atoms_by_id["queen_bubble"]))
		return

	var/turf/current
	for(var/obj/effect/marked_atom/marker as anything in GLOB.marked_atoms_by_id["queen_bubble"])
		current = marker.loc
		current.ChangeTurf(/turf/open/auto_turf/hybrisa_auto_turf/layer1)
		qdel(marker)
	playsound(current, "acid_hit", 25, TRUE)
	GLOB.marked_atoms_by_id["queen_bubble"] = null

/datum/game_mode/survive/spawn_static_comms()
	// Force all to be broken always
	for(var/obj/effect/landmark/static_comms/tower as anything in GLOB.comm_tower_landmarks_net_one)
		tower.broken_on_spawn = TRUE
	for(var/obj/effect/landmark/static_comms/tower as anything in GLOB.comm_tower_landmarks_net_two)
		tower.broken_on_spawn = TRUE
	..()

//This is processed each tick, but check_win is only checked 5 ticks, so we don't go crazy with scanning for mobs.
/datum/game_mode/survive/process()
	. = ..()
	if(--round_started > 0)
		return FALSE //Initial countdown, just to be safe, so that everyone has a chance to spawn before we check anything.

	if(!round_finished)
		// Automated bioscan / Queen Mother message
		if(world.time > bioscan_current_interval) //If world time is greater than required bioscan time.
			announce_bioscans() //Announce the results of the bioscan to both sides.
			bioscan_current_interval += bioscan_ongoing_interval //Add to the interval based on our set interval time.

		if(++round_checkwin >= 5) //Only check win conditions every 5 ticks.
			if(!(round_status_flags & ROUNDSTATUS_PODDOORS_OPEN))
				if(SSmapping.configs[GROUND_MAP].environment_traits[ZTRAIT_LOCKDOWN])
					if(world.time >= (PODLOCKS_OPEN_WAIT + round_time_lobby))

						round_status_flags |= ROUNDSTATUS_PODDOORS_OPEN

						for(var/i in GLOB.living_xeno_list)
							var/mob/M = i
							sound_to(M, sound(get_sfx("queen"), wait = 0, volume = 50))
							to_chat(M, SPAN_XENOANNOUNCE("The Queen Mother reaches into your mind from worlds away."))
							to_chat(M, SPAN_XENOANNOUNCE("To my children and their Queen. I sense the large doors that trap us will open in 30 seconds."))
						addtimer(CALLBACK(src, PROC_REF(open_podlocks), "map_lockdown"), 300)

			if(GLOB.round_should_check_for_win)
				check_win()
			round_checkwin = 0

		if(!MODE_HAS_MODIFIER(/datum/gamemode_modifier/lz_weeding) && world.time >= SSticker.round_start_time + round_time_resin)
			MODE_SET_MODIFIER(/datum/gamemode_modifier/lz_weeding, TRUE)

		if(next_stat_check <= world.time)
			add_current_round_status_to_end_results((next_stat_check ? "" : "Round Start"))
			next_stat_check = world.time + 10 MINUTES

/datum/game_mode/survive/get_affected_zlevels()
	if(is_in_endgame)
		return SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND, ZTRAIT_RESERVED))
	return SSmapping.levels_by_trait(ZTRAIT_GROUND)

/**
 * Checks to see who won
 */
/datum/game_mode/survive/check_win()
	if(SSticker.current_state != GAME_STATE_PLAYING)
		return
	if(ROUND_TIME < 10 MINUTES)
		return

	if(SShijack?.sd_detonated)
		round_finished = MODE_SURVIVE_DRAW_DEATH // Self destruction.
		return

	var/list/living_player_list = count_humans_and_xenos(get_affected_zlevels())
	var/num_humans = living_player_list[1]
	var/num_xenos = living_player_list[2]

	if(!num_humans && num_xenos)
		round_finished = MODE_SURVIVE_X_MAJOR //No humans remain alive.
	else if(num_humans && !num_xenos)
		round_finished = MODE_SURVIVE_S_MAJOR //Humans destroyed the xenomorphs.
	else if(!num_humans && !num_xenos)
		round_finished = MODE_SURVIVE_DRAW_DEATH //Both were somehow destroyed.
	else if(force_end_at && world.time > force_end_at)
		round_finished = MODE_SURVIVE_X_MINOR // Times up.
	else if(is_in_endgame)
		var/list/ground_list = count_humans_and_xenos(SSmapping.levels_by_trait(ZTRAIT_GROUND))
		var/num_humans_ground = ground_list[1]
		//var/num_xenos_ground = ground_list[2]
		if(!num_humans_ground)
			round_finished = MODE_SURVIVE_S_EXTRACT //Evacuation successfully took place.

/datum/game_mode/survive/count_humans_and_xenos(list/z_levels = SSmapping.levels_by_any_trait(list(ZTRAIT_GROUND, ZTRAIT_RESERVED, ZTRAIT_MARINE_MAIN_SHIP)))
	. = ..()
	if(.[2] != 0) // index 2 = num_xenos
		return .

	// Ensure there is no queen
	var/datum/hive_status/hive
	for(var/cur_number in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_number]
		if(hive.need_round_end_check && !hive.can_delay_round_end())
			continue
		if(hive.living_xeno_queen && !should_block_game_interaction(hive.living_xeno_queen.loc))
			var/turf/queen_turf = get_turf(hive.living_xeno_queen)
			if(queen_turf?.z in z_levels)
				//Some Queen is alive, we shouldn't end the game yet
				.[2]++
	return .

/**
 * Checks if the round is over
 */
/datum/game_mode/survive/check_finished()
	if(round_finished)
		return TRUE
	return FALSE

/**
 * Announces the end of the game with all relevant information stated
 */
/datum/game_mode/survive/declare_completion()
	announce_ending()
	var/musical_track
	var/end_icon = "draw"
	switch(round_finished)
		if(MODE_SURVIVE_X_MAJOR)
			musical_track = pick('sound/theme/sad_loss1.ogg','sound/theme/sad_loss2.ogg')
			end_icon = "xeno_major"
			if(GLOB.round_statistics && GLOB.round_statistics.current_map)
				GLOB.round_statistics.current_map.total_xeno_slaughters++
				GLOB.round_statistics.current_map.total_xeno_slaughter_majors++
		if(MODE_SURVIVE_S_MAJOR)
			musical_track = pick('sound/theme/winning_triumph1.ogg','sound/theme/winning_triumph2.ogg','sound/theme/winning_triumph3.ogg')
			end_icon = "marine_major"
			if(GLOB.round_statistics && GLOB.round_statistics.current_map)
				GLOB.round_statistics.current_map.total_survivor_victories++
				GLOB.round_statistics.current_map.total_survivor_majors++
		if(MODE_SURVIVE_X_MINOR)
			var/list/living_player_list = count_humans_and_xenos(get_affected_zlevels())
			end_icon = "xeno_minor"
			if(living_player_list[1] && !living_player_list[2]) // If Xeno Minor but Xenos are dead and Humans are alive, see which faction is the last standing
				var/static/list/faction_victories = list(
					"WY_headcount" = list(
						"musical_track" = 'sound/theme/lastmanstanding_wy.ogg',
						"end_icon" = "wy_major",
						"name" = "Weyland-Yutani",
					),
					"UPP_headcount" = list(
						"musical_track" = 'sound/theme/lastmanstanding_upp.ogg',
						"end_icon" = "upp_major",
						"name" = "Union of Progressive Peoples",
					),
					"CLF_headcount" = list(
						"musical_track" = 'sound/theme/lastmanstanding_clf.ogg',
						"end_icon" = "clf_major",
						"name" = "Colonial Liberation Front",
					),
					"TWE_headcount" = list(
						"musical_track" = 'sound/theme/lastmanstanding_twe.ogg',
						"end_icon" = "twe_major",
						"name" = "Three World Empire",
					),
					"marine_headcount" = list(
						"musical_track" = 'sound/theme/neutral_melancholy2.ogg', // This is the theme song for Colonial Marines the game, fitting
						"end_icon" = "xeno_minor",
					),
				)
				var/list/headcount = count_per_faction()
				var/living = headcount["total_headcount"]
				for(var/faction in faction_victories)
					if((headcount[faction] / living) <= MAJORITY)
						continue
					var/list/victory = faction_victories[faction]
					musical_track = victory["musical_track"]
					end_icon = victory["end_icon"]
					var/faction_name = victory["name"]
					if(faction_name)
						var/victory_message = "3rd party victory: [faction_name]"
						log_game(victory_message)
						message_admins(victory_message)
					break
			else
				musical_track = pick('sound/theme/neutral_melancholy1.ogg')
			if(GLOB.round_statistics && GLOB.round_statistics.current_map)
				GLOB.round_statistics.current_map.total_xeno_slaughters++
		if(MODE_SURVIVE_S_EXTRACT)
			musical_track = pick('sound/theme/neutral_hopeful1.ogg','sound/theme/neutral_hopeful2.ogg')
			end_icon = "marine_minor"
			if(GLOB.round_statistics && GLOB.round_statistics.current_map)
				GLOB.round_statistics.current_map.total_survivor_victories++
		if(MODE_SURVIVE_DRAW_DEATH)
			end_icon = "draw"
			musical_track = 'sound/theme/neutral_hopeful2.ogg'
			if(GLOB.round_statistics && GLOB.round_statistics.current_map)
				GLOB.round_statistics.current_map.total_survivor_draws++
		else
			end_icon = "draw"
			musical_track = 'sound/theme/neutral_hopeful2.ogg'
	send_end_round_music(musical_track)
	if(GLOB.round_statistics)
		GLOB.round_statistics.game_mode = name
		GLOB.round_statistics.round_length = world.time
		GLOB.round_statistics.round_result = round_finished
		GLOB.round_statistics.end_round_player_population = length(GLOB.clients)

		GLOB.round_statistics.log_round_statistics()

	for(var/mob/mob as anything in GLOB.alive_human_list)
		SEND_SIGNAL(mob, COMSIG_HUMAN_FINISHED_ROUND)

	calculate_end_statistics()
	show_end_statistics(end_icon)

	declare_completion_announce_xenomorphs()
	declare_completion_announce_predators()
	addtimer(CALLBACK(src, PROC_REF(declare_completion_announce_colony_joes)), 2 SECONDS)
	declare_completion_announce_medal_awards()
	declare_fun_facts()


	add_current_round_status_to_end_results("Round End")
	handle_round_results_statistics_output()

	GLOB.round_statistics?.save()

	return 1

/datum/game_mode/survive/announce_ending()
	if(GLOB.round_statistics)
		GLOB.round_statistics.track_round_end()
	log_game("Round end result: [round_finished]")
	to_chat_spaced(world, margin_top = 2, type = MESSAGE_TYPE_SYSTEM, html = SPAN_ROUNDHEADER("|Round Complete:[round_finished]|"))
	to_chat_spaced(world, type = MESSAGE_TYPE_SYSTEM, html = SPAN_ROUNDBODY("Thus ends the story of the brave men and women on [SSmapping.configs[GROUND_MAP].map_name].\nThe game-mode was: [GLOB.master_mode]!\n[CONFIG_GET(string/endofroundblurb)]"))

/datum/game_mode/survive/end_round_message()
	switch(round_finished)
		if(MODE_SURVIVE_X_MAJOR)
			return "Round has ended. Xeno Major Victory."
		if(MODE_SURVIVE_S_MAJOR)
			return "Round has ended. Survivor Major Victory."
		if(MODE_SURVIVE_X_MINOR)
			return "Round has ended. Xeno Minor Victory."
		if(MODE_SURVIVE_S_EXTRACT)
			return "Round has ended. Survivor Extraction Victory."
		if(MODE_SURVIVE_DRAW_DEATH)
			return "Round has ended. Draw."
	return "Round has ended in a strange way."

/datum/game_mode/survive/proc/add_current_round_status_to_end_results(special_round_status as text)
	var/players = GLOB.clients
	var/list/counted_humans = list()

	//organize our jobs in a readable and standard way
	for(var/job in GLOB.ROLES_SPECIAL)
		counted_humans[job] = 0

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
				counted_humans[player_client.mob.job]++
			else if(isxeno(player_client.mob))
				var/mob/living/carbon/xenomorph/xeno = player_client.mob
				counted_xenos[xeno.hivenumber][xeno.caste_type]++

	var/list/total_data = list("special round status" = special_round_status, "round time" = duration2text(), "counted humans" = counted_humans, "counted xenos" = counted_xenos)
	running_round_stats = running_round_stats + list(total_data)

/datum/game_mode/survive/proc/handle_round_results_statistics_output()
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

		var/total_non_standard = 0
		var/non_standard_job_text = ""
		var/incrementer = 0
		var/list/non_standard_job_report = round_status_report["counted humans"]
		for(var/job_type in non_standard_job_report)
			non_standard_job_text += "[job_type]: [non_standard_job_report[job_type]]"
			total_non_standard += non_standard_job_report[job_type]
			incrementer++
			if(incrementer < length(non_standard_job_report))
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
				if(incrementer < length(per_hive_status))
					hive_caste_text += ", "
			if(hive_amount)
				hive_xeno_numbers[hive] = hive_amount
				hive_caste_texts[hive] = hive_caste_text

		var/final_text = ""

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

#undef MONKEYS_TO_TOTAL_RATIO
#undef PODLOCKS_OPEN_WAIT
#undef MAJORITY
