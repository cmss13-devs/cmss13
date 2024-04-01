SUBSYSTEM_DEF(battlepass)
	name = "Battlepass"
	flags = SS_NO_FIRE
	init_order = SS_INIT_BATTLEPASS
	/// The maximum tier the battlepass goes to
	var/maximum_tier = 20
	/// What season we're currently in
	var/season = 1
	/// Dict of all marine challenges to their pick weight
	var/list/marine_challenges = list()
	/// Dict of all xeno challenges to their pick weight
	var/list/xeno_challenges = list()
	/// List of paths of all battlepass rewards for the current season, in order
	var/list/season_rewards = list()
	/// List of all paths of all premium battlepass rewards for the current season, in order
	var/list/premium_season_rewards = list()
	var/list/marine_battlepass_earners = list()
	var/list/xeno_battlepass_earners = list()

/datum/controller/subsystem/battlepass/Initialize()
	if(!fexists("config/battlepass.json"))
		return

	var/list/battlepass_data = json_load("config/battlepass.json")

	maximum_tier = battlepass_data["maximum_tier"]
	season = battlepass_data["season"]

	for(var/reward_path in battlepass_data["reward_data"])
		season_rewards += text2path(reward_path)

	for(var/reward_path in battlepass_data["premium_reward_data"])
		premium_season_rewards += text2path(reward_path)

	for(var/datum/battlepass_challenge/challenge_path as anything in subtypesof(/datum/battlepass_challenge))
		switch(initial(challenge_path.challenge_category))
			if(CHALLENGE_NONE)
				continue

			if(CHALLENGE_HUMAN)
				marine_challenges[challenge_path] = initial(challenge_path.pick_weight)

			if(CHALLENGE_XENO)
				xeno_challenges[challenge_path] = initial(challenge_path.pick_weight)

	RegisterSignal(src, COMSIG_SUBSYSTEM_POST_INITIALIZE, PROC_REF(do_postinit))

	for(var/client/client as anything in GLOB.clients)
		if(!client.owned_battlepass)
			continue

		client.owned_battlepass.verify_rewards()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/battlepass/proc/do_postinit(datum/source)
	SIGNAL_HANDLER

	UnregisterSignal(src, COMSIG_SUBSYSTEM_POST_INITIALIZE)

	for(var/client/client as anything in GLOB.clients)
		client.owned_battlepass?.check_daily_challenge_reset()

/// Returns a typepath of a challenge of the given category
/datum/controller/subsystem/battlepass/proc/get_challenge(challenge_type = CHALLENGE_NONE)
	switch(challenge_type)
		if(CHALLENGE_NONE)
			return

		if(CHALLENGE_HUMAN)
			return pick_weight(marine_challenges)

		if(CHALLENGE_XENO)
			return pick_weight(xeno_challenges)


/datum/controller/subsystem/battlepass/proc/give_sides_points(marine_points = 0, xeno_points = 0)
	if(marine_points)
		give_side_points(marine_points, marine_battlepass_earners)

	if(xeno_points)
		give_side_points(xeno_points, xeno_battlepass_earners)

/datum/controller/subsystem/battlepass/proc/save_battlepasses()
	for(var/client/player as anything in GLOB.clients)
		player.save_battlepass()

/datum/controller/subsystem/battlepass/proc/give_side_points(point_amount = 0, ckey_list)
	if(!islist(ckey_list))
		CRASH("give_side_points in SSbattlepass called without giving a list of ckeys")

	for(var/ckey in ckey_list)
		if(ckey in GLOB.directory)
			var/client/ckey_client = GLOB.directory[ckey]
			if(ckey_client.owned_battlepass)
				ckey_client.owned_battlepass.add_xp(point_amount)
		else
			if(!fexists("data/player_saves/[copytext(ckey,1,2)]/[ckey]/battlepass.sav"))
				continue

			var/savefile/ckey_save = new("data/player_saves/[copytext(ckey,1,2)]/[ckey]/battlepass.sav")

			ckey_save["xp"] += point_amount // if they're >=10 XP, it'll get sorted next time they log on

/// Proc meant for admin calling to see BP levels of all online players
/datum/controller/subsystem/battlepass/proc/output_bp_levels(mob/caller)
	var/list/levels = list(
		"1" = 0,
		"2" = 0,
		"3" = 0,
		"4" = 0,
		"5" = 0,
		"6" = 0,
		"7" = 0,
		"8" = 0,
		"9" = 0,
		"10" = 0,
		"11" = 0,
		"12" = 0,
		"13" = 0,
		"14" = 0,
		"15" = 0,
		"16" = 0,
		"17" = 0,
		"18" = 0,
		"19" = 0,
		"20" = 0,
	)
	for(var/client/player_client as anything in GLOB.clients)
		if(!player_client.owned_battlepass)
			continue

		levels["[player_client.owned_battlepass.tier]"] += 1

	to_chat(caller, SPAN_NOTICE(json_encode(levels)))
