/datum/round_recorder
	// Counter for how many times the game state has been snapshotted
	var/snapshots = 0
	var/last_snapshot = 0
	var/list/snapshot_deltas

	var/game_start = ""
	var/game_end = ""

	// What was the gamemode
	var/gamemode = ""
	// Which map the round was played on
	var/map = ""
	// What was the outcome of the round
	var/outcome = ""
	// Friendly name for the round
	var/round_name = ""

	// A list of all players (as mobs) to check when the game is snapshotted
	var/list/tracked_players

	// Mostly static information about each player, such as faction, name, job/other character type identifiers
	// Also contains info about snapshot numbers when the player died (if ever)
	var/list/player_info

	// Associative list of each player's history, stored as a DSV (using delimiter ;)
	var/list/player_history

// Record the start time of the game
/datum/round_recorder/proc/start_game()
	game_start = time2text(world.realtime, "DD.MM.YYYY@hh:mm:ss")

	map = map_tag
	gamemode = master_mode
	round_name = round_statistics.name

// Record the end time of the game and export the game history
/datum/round_recorder/proc/end_game()
	game_end = time2text(world.realtime, "DD.MM.YYYY@hh:mm:ss")

	outcome = ticker.mode.round_finished

	export_data()

// Begin tracking a mob if it isn't already being tracked
/datum/round_recorder/proc/track_player(var/mob/M)
	if(LAZYISIN(tracked_players, M))
		return

	if(!isliving(M))
		return

	LAZYADD(tracked_players, M)

	var/player_role = M.job
	var/player_squad = "none"
	var/player_name = M.name

	if(isXeno(M))
		// Xeno role = their caste
		var/mob/living/carbon/Xenomorph/X = M
		player_role = X.caste_name

		// Xeno name = their caste, pre-/postfix and number (because upgrades changes their name)
		var/name_prefix = ""
		var/name_postfix = ""
		if(X.client)
			name_prefix = "[X.client.xeno_prefix ? X.client.xeno_prefix : "XX"]-"
			name_postfix = X.client.xeno_postfix ? ("-" + X.client.xeno_postfix) : ""
		player_name = "[(X.hive ? X.hive.prefix : "")][player_role] ([name_prefix][X.nicknumber][name_postfix])"

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.assigned_squad)
			player_squad = H.assigned_squad.name

	LAZYSET(player_info, "[M.gid]", list(
		// The key playing the mob can change throughout the round, especially with xenos
		// So store at which snapshot each key started controlling the mob
		"keys" = list(snapshots, M.key),
		"name" = player_name,
		"faction" = M.faction,
		"role" = player_role,
		"squad" = player_squad,
		"start_snapshot" = snapshots,
		// -1 means it runs to the end
		"end_snapshot" = -1
	))

// Stops tracking a mob completely
/datum/round_recorder/proc/stop_tracking(var/mob/M)
	if(!M)
		return

	if(!(M in tracked_players))
		return

	var/list/info = LAZYACCESS(player_info, "[M.gid]")
	if(!info)
		return
	info["end_snapshot"] = snapshots
	LAZYSET(player_info, "[M.gid]", info)
	LAZYREMOVE(tracked_players, M)

// Update the key playing the given mob
/datum/round_recorder/proc/update_key(var/mob/M)
	if(!M)
		return

	// track_player takes care of adding the key info
	if(!(M in tracked_players))
		track_player(M)
		return

	var/list/info = LAZYACCESS(player_info, "[M.gid]")
	if(!info)
		return

	var/list/keys = info["keys"]
	keys += list(snapshots, M.key)

	LAZYSET(player_info, "[M.gid]", info)

// Mostly a bookkeeping proc for keeping track of the amount of snapshots and the time between them
/datum/round_recorder/proc/snapshot()
	snapshots += 1
	LAZYADD(snapshot_deltas, world.time - last_snapshot)
	last_snapshot = world.time

// Take a snapshot of a single player and add it to the player history
/datum/round_recorder/proc/snapshot_player(var/mob/M)
	LAZYINITLIST(player_info)
	var/list/history = LAZYACCESS(player_history, "[M.gid]")
	if(!history)
		history = ""

	var/pos = "0,0,0"
	var/turf/T = get_turf(M)
	if(!T)
		return

	pos = "[T.x],[T.y],[T.z]"
	history += "[pos],[M.stat],[M.is_mob_incapacitated()],[M.getBruteLoss()],[M.getFireLoss()],[M.getToxLoss()],[M.getOxyLoss()],[M.getCloneLoss()],[M.getBrainLoss()];"
	LAZYSET(player_history, "[M.gid]", history)

// Dump the game history to a data file
/datum/round_recorder/proc/export_data()
	var/list/full_data = list(
		"history_meta" = list(
			"snapshots" = snapshots,
			"start" = game_start,
			"end" = game_end
		),
		"game_info" = list(
			"name" = round_name,
			"gamemode" = gamemode,
			"map" = map,
			"outcome" = outcome
		),
		"snapshot_deltas" = snapshot_deltas,
		"player_infos" = player_info,
		"player_history" = player_history
	)
	var/data_json = json_encode(full_data)

	var/date_string = time2text(world.realtime, "YYYY/MM-Month/DD-Day")
	var/game_files = flist("data/recorded_rounds/[date_string]/")
	var/data_file = file("data/recorded_rounds/[date_string]/game[length(game_files)].json")

	data_file << data_json
