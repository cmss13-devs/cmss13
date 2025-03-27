/datum/moba_controller
	var/map_id = 0

	var/list/datum/moba_player/players
	var/list/datum/moba_player/team1 = list()
	var/list/datum/moba_queue_player/team1_data
	var/list/datum/moba_player/team2 = list()
	var/list/datum/moba_queue_player/team2_data

	// Map stuff
	var/turf/left_base
	var/turf/right_base
	var/datum/moba_scoreboard/scoreboard

	/// Game duration in deciseconds. Will only be as precise as SSmoba's `wait` var.
	var/game_duration = 0
	/// The floored level of everyone in-game. Used to determine how things like respawn timers and camp health scale. Caps at the level cap.
	var/game_level = 1

	var/team1_max_wards = 2
	var/team1_ward_count = 1
	var/team1_ward_regen_time = 120 SECONDS
	var/list/team1_wards = list()
	var/list/image/team1_ward_images = list()
	var/team1_has_drone = FALSE
	var/list/datum/moba_boon/team1_boons = list()

	var/team2_max_wards = 2
	var/team2_ward_count = 1
	var/team2_ward_regen_time = 120 SECONDS
	var/list/team2_wards = list()
	var/list/image/team2_ward_images = list()
	var/team2_has_drone = FALSE
	var/list/datum/moba_boon/team2_boons = list()

	var/game_started = FALSE

	var/list/turf/ai_waypoints_topleft = list()
	var/list/turf/ai_waypoints_topright = list()
	var/list/turf/ai_waypoints_botleft = list()
	var/list/turf/ai_waypoints_botright = list()

	var/turf/minion_spawn_topleft
	var/turf/minion_spawn_topright
	var/turf/minion_spawn_botleft
	var/turf/minion_spawn_botright

	var/turf/left_boss_spawn
	var/turf/right_boss_spawn

	/// Dict of mobs : player datums that are waiting for a player to reconnect after death
	var/list/awaiting_reconnection_dict = list()

	/// Dict of spawned bosses to their boss datums
	var/list/mob/living/simple_animal/hostile/spawned_bosses = list()

	/// List of /obj/effect/moba_reuse_object_spawner, held so that we can pass it to a /datum/moba_unused_map so that if this map gets used again, we can respawn everything
	var/list/obj/effect/moba_reuse_object_spawner/reuse_spawners = list()

	// We handle timers for game events using cooldowns and boolean flags
	COOLDOWN_DECLARE(minion_spawn_cooldown)
	var/minion_spawn_time = (1 MINUTES) / MOBA_WAVES_PER_MINUTE

	COOLDOWN_DECLARE(carp_boss_spawn_cooldown)
	var/carp_initial_spawn_time = 15 MINUTES
	var/carp_spawn_time = 7 MINUTES
	var/megacarp_alive = FALSE

	COOLDOWN_DECLARE(hivebot_boss_spawn_cooldown)
	var/hivebot_boss_spawned = FALSE
	var/hivebot_spawn_time = 7 MINUTES

	COOLDOWN_DECLARE(reaper_boss_spawn_cooldown)
	var/reaper_initial_spawn_time = 25 MINUTES
	var/reaper_spawn_time = 6 MINUTES
	var/reaper_alive = FALSE

/datum/moba_controller/New(list/team1_players, list/team2_players, id)
	. = ..()
	for(var/datum/moba_queue_player/player as anything in team1_players)
		team1 += player.player
	team1_data = team1_players
	for(var/datum/moba_queue_player/player as anything in team2_players)
		team2 += player.player
	team2_data = team2_players
	players = team1 + team2
	for(var/datum/moba_player/player as anything in players)
		RegisterSignal(player, COMSIG_MOBA_LEVEL_UP, PROC_REF(on_player_level_up))

	map_id = id
	scoreboard = new(map_id)
	COOLDOWN_START(src, carp_boss_spawn_cooldown, carp_initial_spawn_time)
	COOLDOWN_START(src, reaper_boss_spawn_cooldown, reaper_initial_spawn_time)
	COOLDOWN_START(src, hivebot_boss_spawn_cooldown, hivebot_spawn_time)

/datum/moba_controller/Destroy(force, ...)
	left_base = null
	right_base = null
	minion_spawn_topleft = null
	minion_spawn_topright = null
	minion_spawn_botleft = null
	minion_spawn_botright = null
	left_boss_spawn = null
	right_boss_spawn = null
	SSmoba.controllers -= src
	SSmoba.controller_id_dict -= "[map_id]"
	QDEL_NULL(scoreboard)
	QDEL_LIST(team1_boons)
	QDEL_LIST(team2_boons)
	QDEL_LIST(team1_wards)
	QDEL_LIST(team2_wards)
	return ..()

/datum/moba_controller/proc/handle_map_init(turf/bottom_left_turf)
	for(var/obj/effect/landmark/moba_tunnel_spawner/tunnel_spawner in GLOB.landmarks_list)
		var/turf/tunnel_turf = get_turf(tunnel_spawner)
		qdel(tunnel_spawner)
		var/obj/structure/tunnel/moba/new_tunnel = new(tunnel_turf)
		new_tunnel.map_id = map_id

	for(var/obj/effect/landmark/moba_base/moba_base in GLOB.landmarks_list)
		if(moba_base.right_side)
			right_base = get_turf(moba_base)
		else
			left_base = get_turf(moba_base)
		qdel(moba_base)

	for(var/obj/effect/landmark/moba_hive_core/nexus in GLOB.landmarks_list)
		if(nexus.right_side)
			var/obj/effect/alien/resin/moba_hive_core/right/core = new(get_turf(nexus))
			core.map_id = map_id
		else
			var/obj/effect/alien/resin/moba_hive_core/core = new(get_turf(nexus))
			core.map_id = map_id
		qdel(nexus)

	for(var/obj/effect/moba_camp_spawner/spawner as anything in GLOB.mapless_moba_camps)
		spawner.set_map_id(map_id)

	for(var/obj/effect/moba_minion_checkpoint/checkpoint as anything in GLOB.uninitialized_moba_checkpoints)
		checkpoint.set_up_checkpoint(bottom_left_turf)

	for(var/obj/effect/landmark/moba_minion_spawner/spawner in GLOB.landmarks_list)
		if(spawner.top && spawner.left)
			minion_spawn_topleft = get_turf(spawner)
		else if(spawner.top && !spawner.left)
			minion_spawn_topright = get_turf(spawner)
		else if(!spawner.top && spawner.left)
			minion_spawn_botleft = get_turf(spawner)
		else
			minion_spawn_botright = get_turf(spawner)
		qdel(spawner)

	for(var/obj/effect/moba_reuse_object_spawner/spawner as anything in GLOB.uninitialized_moba_reuse_object_spawners)
		if(!GLOB.moba_reuse_object_spawners["[map_id]"])
			GLOB.moba_reuse_object_spawners["[map_id]"] = list()
		GLOB.moba_reuse_object_spawners["[map_id]"] += spawner
		GLOB.uninitialized_moba_reuse_object_spawners -= spawner

	var/obj/effect/landmark/moba_left_boss_spawn/left_boss_spawner = locate() in GLOB.landmarks_list
	if(left_boss_spawner)
		left_boss_spawn = get_turf(left_boss_spawner)
		qdel(left_boss_spawner)

	var/obj/effect/landmark/moba_right_boss_spawn/right_boss_spawner = locate() in GLOB.landmarks_list
	if(right_boss_spawner)
		right_boss_spawn = get_turf(right_boss_spawner)
		qdel(right_boss_spawner)

/datum/moba_controller/proc/handle_map_reuse_init(datum/unused_moba_map/unused_map)
	for(var/obj/effect/moba_reuse_object_spawner/spawner as anything in GLOB.moba_reuse_object_spawners["[map_id]"])
		var/turf/spawner_turf = get_turf(spawner)
		var/obj/found_object = locate(spawner.path_to_spawn) in spawner_turf
		if(found_object)
			qdel(found_object)
		new spawner.path_to_spawn(spawner_turf)

	left_base = unused_map.left_base
	right_base = unused_map.right_base
	ai_waypoints_botleft = unused_map.ai_waypoints_botleft
	ai_waypoints_botright = unused_map.ai_waypoints_botright
	ai_waypoints_topleft = unused_map.ai_waypoints_topleft
	ai_waypoints_topright = unused_map.ai_waypoints_topright
	minion_spawn_botleft = unused_map.minion_spawn_botleft
	minion_spawn_botright = unused_map.minion_spawn_botright
	minion_spawn_topleft = unused_map.minion_spawn_topleft
	minion_spawn_topright = unused_map.minion_spawn_topright
	left_boss_spawn = unused_map.left_boss_spawn
	right_boss_spawn = unused_map.right_boss_spawn

/datum/moba_controller/proc/load_in_players()
	for(var/datum/moba_player/player as anything in players)
		if(!player.tied_client)
			return FALSE

	for(var/datum/moba_queue_player/player_data as anything in team1_data)
		var/datum/moba_player/player = player_data.player
		var/mob/living/carbon/xenomorph/xeno = new player_data.caste.equivalent_xeno_path
		xeno.forceMove(left_base)
		xeno.set_hive_and_update(XENO_HIVE_MOBA_LEFT)
		xeno.AddComponent(/datum/component/moba_player, player, map_id, FALSE)
		xeno.got_evolution_message = TRUE
		ADD_TRAIT(xeno, TRAIT_MOBA_PARTICIPANT, TRAIT_SOURCE_INHERENT)
		ADD_TRAIT(xeno, TRAIT_MOBA_MAP_PARTICIPANT(map_id), TRAIT_SOURCE_INHERENT)
		player.tied_client.mob.mind.transfer_to(xeno, TRUE)
		player.set_tied_xeno(xeno)

	for(var/datum/moba_queue_player/player_data as anything in team2_data)
		var/datum/moba_player/player = player_data.player
		player.right_team = TRUE
		var/mob/living/carbon/xenomorph/xeno = new player_data.caste.equivalent_xeno_path
		xeno.forceMove(right_base)
		xeno.set_hive_and_update(XENO_HIVE_MOBA_RIGHT)
		xeno.AddComponent(/datum/component/moba_player, player, map_id, TRUE)
		xeno.got_evolution_message = TRUE
		ADD_TRAIT(xeno, TRAIT_MOBA_PARTICIPANT, TRAIT_SOURCE_INHERENT)
		ADD_TRAIT(xeno, TRAIT_MOBA_MAP_PARTICIPANT(map_id), TRAIT_SOURCE_INHERENT)
		player.tied_client.mob.mind.transfer_to(xeno, TRUE)
		player.set_tied_xeno(xeno)

	start_game()
	return TRUE

/datum/moba_controller/proc/start_game()
	for(var/datum/moba_player_slot/player as anything in team1_data)
		if(istype(player.caste, /datum/moba_caste/drone) && !team1_has_drone)
			team1_has_drone = TRUE
			team1_max_wards += 1
			team1_ward_regen_time -= 20 SECONDS
			update_team1_ward_text()
			break

	for(var/datum/moba_player_slot/player as anything in team2_data)
		if(istype(player.caste, /datum/moba_caste/drone) && !team2_has_drone)
			team2_has_drone = TRUE
			team2_max_wards += 1
			team2_ward_regen_time -= 20 SECONDS
			update_team2_ward_text()
			break

	if(team1_ward_count <= team1_max_wards)
		addtimer(CALLBACK(src, PROC_REF(regenerate_team1_ward)), team1_ward_regen_time, TIMER_UNIQUE|TIMER_OVERRIDE)

	if(team2_ward_count <= team2_max_wards)
		addtimer(CALLBACK(src, PROC_REF(regenerate_team2_ward)), team2_ward_regen_time, TIMER_UNIQUE|TIMER_OVERRIDE)

	game_started = TRUE

/datum/moba_controller/proc/handle_tick()
	if(!game_started)
		return

	if(COOLDOWN_FINISHED(src, minion_spawn_cooldown))
		spawn_minions()

	if(COOLDOWN_FINISHED(src, carp_boss_spawn_cooldown) && !megacarp_alive)
		megacarp_alive = TRUE
		spawn_boss(/datum/moba_boss/megacarp)

	if(COOLDOWN_FINISHED(src, hivebot_boss_spawn_cooldown) && !hivebot_boss_spawned)
		hivebot_boss_spawned = TRUE
		spawn_boss(/datum/moba_boss/hivebot)

	if(COOLDOWN_FINISHED(src, reaper_boss_spawn_cooldown) && !reaper_alive)
		reaper_alive = TRUE
		var/mob/living/simple_animal/hostile/hivebot/bot = locate() in spawned_bosses
		if(bot)
			qdel(spawned_bosses[bot])
			spawned_bosses -= bot
			qdel(bot) // If you didn't kill the hivebot in like 15m idk what to tell you

		spawn_boss(/datum/moba_boss/reaper)

	game_duration += SSmoba.wait

/datum/moba_controller/proc/spawn_minions()
	COOLDOWN_START(src, minion_spawn_cooldown, minion_spawn_time)
	var/wave_maxhp = /datum/caste_datum/lesser_drone::max_health * min(1 + round(game_duration / 6000, 0.1), 3) // scales up to 3x max HP over 20 minutes
	var/wave_slashdamage = /datum/caste_datum/lesser_drone::melee_damage_upper * min(1 + (round(game_duration / 6000, 0.1) * 1.5), 4) // scales up to 4x melee damage over 20 minutes
	var/list/minion_spawns = list("topleft", "topright", "botleft", "botright")
	minion_spawns = shuffle(minion_spawns)
	for(var/i in 1 to 4) // I know this looks retarded but I actually have a good reason for this
		switch(minion_spawns[i]) // If both lanes have a wave spawned simultanenously, then the wave that's spawned later will actually
			if("topleft") // always win the initial trade. Because we're randomizing it, we allow the outcome to be more coinflippy than "X side wins the initial trade 100% of the time"
				INVOKE_ASYNC(src, PROC_REF(spawn_wave), minion_spawn_topleft, XENO_HIVE_MOBA_LEFT, wave_maxhp, wave_slashdamage)
			if("topright")
				INVOKE_ASYNC(src, PROC_REF(spawn_wave), minion_spawn_topright, XENO_HIVE_MOBA_RIGHT, wave_maxhp, wave_slashdamage)
			if("botleft")
				INVOKE_ASYNC(src, PROC_REF(spawn_wave), minion_spawn_botleft, XENO_HIVE_MOBA_LEFT, wave_maxhp, wave_slashdamage)
			if("botright")
				INVOKE_ASYNC(src, PROC_REF(spawn_wave), minion_spawn_botright, XENO_HIVE_MOBA_RIGHT, wave_maxhp, wave_slashdamage)

/datum/moba_controller/proc/spawn_wave(turf/location, side, wave_maxhp, wave_slashdamage)
	if(!location || !side)
		return

	for(var/i in 1 to MOBA_MINIONS_PER_WAVE)
		var/mob/living/carbon/xenomorph/lesser_drone/minion = new()
		minion.setMaxHealth(wave_maxhp)
		minion.melee_damage_lower = wave_slashdamage
		minion.melee_damage_upper = wave_slashdamage
		minion.set_hive_and_update(side)
		minion.AddComponent(/datum/component/moba_minion, map_id, MOBA_GOLD_PER_WAVE / MOBA_MINIONS_PER_WAVE, 55)
		minion.forceMove(location)
		SEND_SIGNAL(src, COMSIG_MOBA_MINION_SPAWNED, minion)
		sleep(0.9 SECONDS)

/datum/moba_controller/proc/get_respawn_time()
	return floor((10 SECONDS) + (((game_level - 1) / (MOBA_MAX_LEVEL - 1)) * (50 SECONDS))) // Starts at 10 seconds and scales to 60 over the course of the game

/datum/moba_controller/proc/start_respawn(datum/moba_player/player_datum)
	var/respawn_time = get_respawn_time()
	if(player_datum.tied_client)
		player_datum.get_tied_xeno().play_screen_text("You have died. You will respawn in [respawn_time * 0.1] seconds.", /atom/movable/screen/text/screen_text/command_order, rgb(175, 0, 175))
	addtimer(CALLBACK(src, PROC_REF(spawn_xeno), player_datum), respawn_time)

/datum/moba_controller/proc/spawn_xeno(datum/moba_player/player_datum)
	var/datum/moba_queue_player/found_playerdata
	for(var/datum/moba_queue_player/player_data as anything in (team1_data + team2_data))
		if(player_data.player == player_datum)
			found_playerdata = player_data
			break

	if(!found_playerdata.player.tied_client)
		RegisterSignal(player_datum.get_tied_xeno(), COMSIG_MOB_LOGGED_IN, PROC_REF(move_disconnected_player_to_body))
		awaiting_reconnection_dict[player_datum.get_tied_xeno()] = player_datum
		return

	var/mob/living/carbon/xenomorph/xeno = new found_playerdata.caste.equivalent_xeno_path
	xeno.forceMove(player_datum.right_team ? right_base : left_base)
	xeno.set_hive_and_update(player_datum.right_team ? XENO_HIVE_MOBA_RIGHT : XENO_HIVE_MOBA_LEFT)
	var/datum/component/moba_player/player_comp = xeno.AddComponent(/datum/component/moba_player, found_playerdata.player, map_id, TRUE)
	xeno.got_evolution_message = TRUE
	ADD_TRAIT(xeno, TRAIT_MOBA_PARTICIPANT, TRAIT_SOURCE_INHERENT)
	found_playerdata.player.tied_client.mob.mind.transfer_to(xeno, TRUE)

	qdel(found_playerdata.player.get_tied_xeno())

	found_playerdata.player.set_tied_xeno(xeno)
	for(var/datum/moba_boon/boon as anything in (player_datum.right_team ? team2_boons : team1_boons))
		boon.on_friendly_spawn(xeno, player_datum, player_comp)

/datum/moba_controller/proc/move_disconnected_player_to_body(mob/source)
	SIGNAL_HANDLER

	UnregisterSignal(source, COMSIG_MOB_LOGGED_IN)
	spawn_xeno(awaiting_reconnection_dict[source])
	awaiting_reconnection_dict -= source

/datum/moba_controller/proc/on_player_level_up(datum/source, level)
	SIGNAL_HANDLER

	var/total_level_count = 0
	for(var/datum/moba_player/player as anything in players)
		var/list/level_list = list()
		SEND_SIGNAL(player.get_tied_xeno(), COMSIG_MOBA_GET_LEVEL, level_list)
		total_level_count += level_list[1]

	game_level = clamp(floor(total_level_count * (1 / MOBA_TOTAL_PLAYERS)), 1, 12)

/datum/moba_controller/proc/end_game(losing_hive)
	set waitfor = FALSE

	if(!losing_hive)
		return

	var/winning_hive = (losing_hive == XENO_HIVE_MOBA_LEFT) ? XENO_HIVE_MOBA_RIGHT : XENO_HIVE_MOBA_LEFT
	var/datum/hive_status/hive = GLOB.hive_datum[winning_hive]

	for(var/datum/moba_player/player as anything in players)
		if(!player.tied_client)
			continue

		player.get_tied_xeno().play_screen_text("[hive.name] wins.", /atom/movable/screen/text/screen_text/command_order, rgb(175, 0, 175))

	sleep(5 SECONDS)

	for(var/datum/moba_player/player as anything in players)
		player.get_tied_xeno().send_to_lobby()

	QDEL_LIST(team1_wards)
	QDEL_LIST(team2_wards)
	team1_ward_images.Cut()
	team2_ward_images.Cut()

	SSmoba.unused_maps += new /datum/unused_moba_map(src)
	qdel(src)

/datum/moba_controller/proc/use_team1_ward()
	if(team1_ward_count <= team1_max_wards)
		addtimer(CALLBACK(src, PROC_REF(regenerate_team1_ward)), team1_ward_regen_time, TIMER_UNIQUE|TIMER_OVERRIDE)
	team1_ward_count--
	update_team1_ward_text()

/datum/moba_controller/proc/regenerate_team1_ward()
	if(team1_ward_count >= team1_max_wards)
		return

	team1_ward_count++
	if(team1_ward_count < team1_max_wards)
		addtimer(CALLBACK(src, PROC_REF(regenerate_team1_ward)), team1_ward_regen_time, TIMER_UNIQUE|TIMER_OVERRIDE)
	update_team1_ward_text()

/datum/moba_controller/proc/update_team1_ward_text()
	for(var/datum/moba_player/player in team1)
		if(player.get_tied_xeno()?.hud_used)
			player.get_tied_xeno().hud_used.locate_marker.maptext = "<span class='maptext'>Team Wards: <b>[team1_ward_count]</b>/<b>[team1_max_wards]</b></span>"

/datum/moba_controller/proc/add_team1_ward(obj/effect/alien/resin/construction/ward/ward)
	var/image/ward_icon = image('icons/obj/structures/alien/structures.dmi', get_turf(ward), "resin_ward")
	ward_icon.alpha = 160
	ward_icon.color = GLOB.hive_datum[XENO_HIVE_MOBA_LEFT].color
	team1_wards += ward
	team1_ward_images[ward] = ward_icon
	for(var/datum/moba_player/player as anything in team1)
		if(!player.tied_client)
			continue

		player.tied_client.images += ward_icon

/datum/moba_controller/proc/remove_team1_ward(obj/effect/alien/resin/construction/ward/ward)
	var/image/ward_icon = team1_ward_images[ward]
	team1_wards -= ward
	team1_ward_images -= ward
	for(var/datum/moba_player/player as anything in team1)
		if(!player.tied_client)
			continue

		player.tied_client.images -= ward_icon

/datum/moba_controller/proc/use_team2_ward()
	if(team2_ward_count <= team2_max_wards)
		addtimer(CALLBACK(src, PROC_REF(regenerate_team2_ward)), team2_ward_regen_time, TIMER_UNIQUE|TIMER_OVERRIDE)
	team2_ward_count--
	update_team2_ward_text()

/datum/moba_controller/proc/regenerate_team2_ward()
	if(team2_ward_count >= team2_max_wards)
		return

	team2_ward_count++
	if(team2_ward_count < team2_max_wards)
		addtimer(CALLBACK(src, PROC_REF(regenerate_team2_ward)), team2_ward_regen_time, TIMER_UNIQUE|TIMER_OVERRIDE)
	update_team2_ward_text()

/datum/moba_controller/proc/update_team2_ward_text()
	for(var/datum/moba_player/player in team2)
		if(player.get_tied_xeno()?.hud_used)
			player.get_tied_xeno().hud_used.locate_marker.maptext = "<span class='maptext'>Team Wards: <b>[team2_ward_count]</b>/<b>[team2_max_wards]</b></span>"

/datum/moba_controller/proc/add_team2_ward(obj/effect/alien/resin/construction/ward/ward)
	var/image/ward_icon = image('icons/obj/structures/alien/structures.dmi', get_turf(ward), "resin_ward")
	ward_icon.alpha = 160
	ward_icon.color = GLOB.hive_datum[XENO_HIVE_MOBA_RIGHT].color
	team2_wards += ward
	team2_ward_images[ward] = ward_icon
	for(var/datum/moba_player/player as anything in team2)
		if(!player.tied_client)
			continue

		player.tied_client.images += ward_icon

/datum/moba_controller/proc/remove_team2_ward(obj/effect/alien/resin/construction/ward/ward)
	var/image/ward_icon = team1_ward_images[ward]
	team2_wards -= ward
	team2_ward_images -= ward
	for(var/datum/moba_player/player as anything in team2)
		if(!player.tied_client)
			continue

		player.tied_client.images -= ward_icon

/datum/moba_controller/proc/spawn_boss(boss_datum_type)
	var/datum/moba_boss/boss_datum = new boss_datum_type
	var/turf/boss_spawn_loc = boss_datum.right_spawn ? right_boss_spawn : left_boss_spawn
	var/mob/living/simple_animal/hostile/boss = new boss_datum.boss_type(boss_spawn_loc)
	spawned_bosses[boss] = boss_datum
	RegisterSignal(boss, COMSIG_PARENT_QDELETING, PROC_REF(on_boss_qdel))
	boss.AddComponent(/datum/component/moba_simplemob, new_map_id = map_id, boss_simplemob = TRUE)
	RegisterSignal(boss, COMSIG_MOB_DEATH, PROC_REF(on_boss_kill))

	for(var/datum/moba_player/player as anything in players)
		if(!player.tied_client)
			continue

		playsound_client(player.tied_client, 'sound/voice/alien_distantroar_3.ogg', player.get_tied_xeno().loc, 25, FALSE)
		//player.get_tied_xeno().play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>The Hivemind Senses:</u></span><br>" + "The megacarp has spawned at <b>Right Side Robotics</b>!", /atom/movable/screen/text/screen_text/command_order, rgb(175, 0, 175))
		player.get_tied_xeno().play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>The Hivemind Senses:</u></span><br>" + boss_datum.spawn_text, /atom/movable/screen/text/screen_text/command_order, rgb(175, 0, 175))

/datum/moba_controller/proc/on_boss_kill(mob/living/simple_animal/hostile/source, datum/cause_data/cause)
	SIGNAL_HANDLER

	var/datum/moba_player/killer
	var/datum/hive_status/killing_hive
	if(cause?.weak_mob)
		var/mob/living/carbon/xenomorph/killer_xeno = cause.weak_mob.resolve()
		for(var/datum/moba_player/player as anything in team1)
			if(player.get_tied_xeno() != killer_xeno)
				continue

			killer = player
			killing_hive = GLOB.hive_datum[XENO_HIVE_MOBA_LEFT]
			break

		for(var/datum/moba_player/player as anything in team2)
			if(player.get_tied_xeno() != killer_xeno)
				continue

			killer = player
			killing_hive = GLOB.hive_datum[XENO_HIVE_MOBA_RIGHT]
			break

	var/message
	if(!killing_hive)
		message = "Both teams have failed to kill the [source.name]! Tell Zonespace how this happened please!"
	else
		message = "The [source.name] has been killed by the <b>[killing_hive.name]</b>!"

	message_team1(message, 'sound/voice/alien_distantroar_3.ogg')
	message_team2(message, 'sound/voice/alien_distantroar_3.ogg')

	var/datum/moba_boss/boss_datum = spawned_bosses[source]
	if(boss_datum)
		boss_datum.on_boss_kill(source, killer, killing_hive, src)
		qdel(boss_datum)
	spawned_bosses -= source

/datum/moba_controller/proc/on_boss_qdel(mob/living/simple_animal/hostile/source, force)
	SIGNAL_HANDLER

	qdel(spawned_bosses[source])
	spawned_bosses -= source

/datum/moba_controller/proc/message_team1(message, sound = 'sound/voice/alien_distantroar_3.ogg')
	for(var/datum/moba_player/player as anything in team1)
		if(!player.tied_client)
			continue

		var/mob/living/carbon/xenomorph/xeno = player.get_tied_xeno()
		if(!xeno)
			continue

		if(sound)
			playsound_client(player.tied_client, sound, xeno.loc, 25, FALSE)
		xeno.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>The Hivemind Senses:</u></span><br>[message]", /atom/movable/screen/text/screen_text/command_order, rgb(175, 0, 175))

/datum/moba_controller/proc/message_team2(message, sound = 'sound/voice/alien_distantroar_3.ogg')
	for(var/datum/moba_player/player as anything in team2)
		if(!player.tied_client)
			continue

		var/mob/living/carbon/xenomorph/xeno = player.get_tied_xeno()
		if(!xeno)
			continue

		if(sound)
			playsound_client(player.tied_client, sound, xeno.loc, 25, FALSE)
		xeno.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>The Hivemind Senses:</u></span><br>[message]", /atom/movable/screen/text/screen_text/command_order, rgb(175, 0, 175))
