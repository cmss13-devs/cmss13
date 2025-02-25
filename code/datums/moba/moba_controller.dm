/datum/moba_controller
	var/map_id = 0

	var/list/datum/moba_player/players
	var/list/datum/moba_player/team1 = list()
	var/list/team1_data
	var/list/datum/moba_player/team2 = list()
	var/list/team2_data

	// Map stuff
	var/turf/left_base
	var/turf/right_base

	/// Game duration in deciseconds. Will only be as precise as SSmoba's `wait` var.
	var/game_duration = 0
	/// The floored level of everyone in-game. Used to determine how things like respawn timers and camp health scale. Caps at the level cap.
	var/game_level = 1

	var/game_started = FALSE

	var/list/turf/ai_waypoints_topleft = list()
	var/list/turf/ai_waypoints_topright = list()
	var/list/turf/ai_waypoints_botleft = list()
	var/list/turf/ai_waypoints_botright = list()

	var/turf/minion_spawn_topleft
	var/turf/minion_spawn_topright
	var/turf/minion_spawn_botleft
	var/turf/minion_spawn_botright

	/// Dict of mobs : player datums that are waiting for a player to reconnect after death
	var/list/awaiting_reconnection_dict = list()

	// We handle timers for game events using cooldowns and boolean flags
	COOLDOWN_DECLARE(minion_spawn_cooldown)
	var/minion_spawn_time = 30 SECONDS

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

/datum/moba_controller/Destroy(force, ...)
	left_base = null
	right_base = null
	minion_spawn_topleft = null
	minion_spawn_topright = null
	minion_spawn_botleft = null
	minion_spawn_botright = null
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

/datum/moba_controller/proc/load_in_players()
	// Finish later
	// Add an abort in case someone's missing a client
	for(var/datum/moba_player/player as anything in players)
		if(!player.tied_client)
			return FALSE

	for(var/datum/moba_queue_player/player_data as anything in team1_data)
		var/datum/moba_player/player = player_data.player
		var/mob/living/carbon/xenomorph/xeno = new player_data.caste.equivalent_xeno_path
		xeno.forceMove(left_base)
		xeno.set_hive_and_update(XENO_HIVE_MOBA_LEFT)
		xeno.AddComponent(/datum/component/moba_player, player, map_id, FALSE)
		ADD_TRAIT(xeno, TRAIT_MOBA_PARTICIPANT, TRAIT_SOURCE_INHERENT)
		player.tied_client.mob.mind.transfer_to(xeno, TRUE)
		player.tied_xeno = xeno

	for(var/datum/moba_queue_player/player_data as anything in team2_data)
		var/datum/moba_player/player = player_data.player
		player.right_team = TRUE
		var/mob/living/carbon/xenomorph/xeno = new player_data.caste.equivalent_xeno_path
		xeno.forceMove(right_base)
		xeno.set_hive_and_update(XENO_HIVE_MOBA_RIGHT)
		xeno.AddComponent(/datum/component/moba_player, player, map_id, TRUE)
		ADD_TRAIT(xeno, TRAIT_MOBA_PARTICIPANT, TRAIT_SOURCE_INHERENT)
		player.tied_client.mob.mind.transfer_to(xeno, TRUE)
		player.tied_xeno = xeno

	return TRUE

/datum/moba_controller/proc/handle_tick()
	if(!game_started)
		return

	if(COOLDOWN_FINISHED(src, minion_spawn_cooldown))
		spawn_minions()

	game_duration += SSmoba.wait

/datum/moba_controller/proc/spawn_minions()
	COOLDOWN_START(src, minion_spawn_cooldown, minion_spawn_time)
	var/list/minion_spawns = list("topleft", "topright", "botleft", "botright")
	minion_spawns = shuffle(minion_spawns)
	for(var/i in 1 to 4) // I know this looks retarded but I actually have a good reason for this
		switch(minion_spawns[i]) // If both lanes have a wave spawned simultanenously, then the wave that's spawned later will actually
			if("topleft") // always win the initial trade. Because we're randomizing it, we allow the outcome to be more coinflippy than "X side wins the initial trade 100% of the time"
				INVOKE_ASYNC(src, PROC_REF(spawn_wave), minion_spawn_topleft, XENO_HIVE_MOBA_LEFT)
			if("topright")
				INVOKE_ASYNC(src, PROC_REF(spawn_wave), minion_spawn_topright, XENO_HIVE_MOBA_RIGHT)
			if("botleft")
				INVOKE_ASYNC(src, PROC_REF(spawn_wave), minion_spawn_botleft, XENO_HIVE_MOBA_LEFT)
			if("botright")
				INVOKE_ASYNC(src, PROC_REF(spawn_wave), minion_spawn_botright, XENO_HIVE_MOBA_RIGHT)

/datum/moba_controller/proc/spawn_wave(turf/location, side)
	if(!location || !side)
		return

	for(var/i in 1 to 3)
		var/mob/living/carbon/xenomorph/lesser_drone/minion = new()
		minion.AddComponent(/datum/component/moba_minion)
		minion.set_hive_and_update(side)
		minion.forceMove(location)
		sleep(0.9 SECONDS)

/datum/moba_controller/proc/get_respawn_time()
	return (10 SECONDS) + ((game_level / MOBA_MAX_LEVEL) * (50 SECONDS)) // Starts at 10 seconds and scales to 60 over the course of the game

/datum/moba_controller/proc/start_respawn(datum/moba_player/player_datum)
	var/respawn_time = get_respawn_time()
	player_datum.tied_xeno.play_screen_text("You have died. You will respawn in [respawn_time * 0.1] seconds.", /atom/movable/screen/text/screen_text/command_order, rgb(175, 0, 175))
	addtimer(CALLBACK(src, PROC_REF(spawn_xeno), player_datum), respawn_time)

/datum/moba_controller/proc/spawn_xeno(datum/moba_player/player_datum)
	var/datum/moba_queue_player/found_playerdata
	for(var/datum/moba_queue_player/player_data as anything in (team1_data + team2_data))
		if(player_data.player == player_datum)
			found_playerdata = player_data
			break

	if(!found_playerdata.player.tied_client)
		RegisterSignal(player_datum.tied_xeno, COMSIG_MOB_LOGGED_IN, PROC_REF(move_disconnected_player_to_body))
		awaiting_reconnection_dict[player_datum.tied_xeno] = player_datum
		return

	var/mob/living/carbon/xenomorph/xeno = new found_playerdata.caste.equivalent_xeno_path
	xeno.forceMove(player_datum.right_team ? right_base : left_base)
	xeno.set_hive_and_update(player_datum.right_team ? XENO_HIVE_MOBA_RIGHT : XENO_HIVE_MOBA_LEFT)
	xeno.AddComponent(/datum/component/moba_player, found_playerdata.player, map_id, TRUE)
	ADD_TRAIT(xeno, TRAIT_MOBA_PARTICIPANT, TRAIT_SOURCE_INHERENT)
	found_playerdata.player.tied_client.mob.mind.transfer_to(xeno, TRUE)
	found_playerdata.player.tied_xeno = xeno

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
		SEND_SIGNAL(player.tied_xeno, COMSIG_MOBA_GET_LEVEL, level_list)
		total_level_count += level_list[1]

	game_level = clamp(floor(total_level_count * 0.125), 1, 12)
