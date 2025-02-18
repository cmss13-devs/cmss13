/datum/moba_controller
	var/map_id = 0

	var/list/datum/moba_player/players
	var/list/datum/moba_player/team1
	var/list/datum/moba_player/team2

	// Map stuff
	var/turf/left_base
	var/turf/right_base

	// Game duration in deciseconds. Will only be as precise as SSmoba's `wait` var.
	var/game_duration = 0

	var/game_started = FALSE

	var/list/turf/ai_waypoints_topleft = list()
	var/list/turf/ai_waypoints_topright = list()
	var/list/turf/ai_waypoints_botleft = list()
	var/list/turf/ai_waypoints_botright = list()

	var/turf/minion_spawn_topleft
	var/turf/minion_spawn_topright
	var/turf/minion_spawn_botleft
	var/turf/minion_spawn_botright

	// We handle timers for game events using cooldowns and boolean flags
	COOLDOWN_DECLARE(minion_spawn_cooldown)
	var/minion_spawn_time = 30 SECONDS

/datum/moba_controller/New(list/team1_players, list/team2_players, id)
	. = ..()
	team1 = team1_players
	team2 = team2_players
	players = team1_players + team2_players

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
	for(var/datum/moba_player/player as anything in (team1 + team2))
		player.tied_client.mob.forceMove(left_base)

/datum/moba_controller/proc/handle_tick()
	if(!game_started)
		return

	if(COOLDOWN_FINISHED(src, minion_spawn_cooldown))
		spawn_minions()

	game_duration += SSmoba.wait

/datum/moba_controller/proc/spawn_minions()
	COOLDOWN_START(src, minion_spawn_cooldown, minion_spawn_time)
	INVOKE_ASYNC(src, PROC_REF(spawn_wave), minion_spawn_topleft, XENO_HIVE_MOBA_LEFT)
	INVOKE_ASYNC(src, PROC_REF(spawn_wave), minion_spawn_topright, XENO_HIVE_MOBA_RIGHT)
	INVOKE_ASYNC(src, PROC_REF(spawn_wave), minion_spawn_botleft, XENO_HIVE_MOBA_LEFT)
	INVOKE_ASYNC(src, PROC_REF(spawn_wave), minion_spawn_botright, XENO_HIVE_MOBA_RIGHT)

/datum/moba_controller/proc/spawn_wave(turf/location, side)
	if(!location || !side)
		return

	for(var/i in 1 to 1)
		var/mob/living/carbon/xenomorph/lesser_drone/moba/minion = new()
		minion.set_hive_and_update(side)
		minion.forceMove(location)
		sleep(0.5 SECONDS)
