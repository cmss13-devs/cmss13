/// Each client possesses an instanced /datum/battlepass
/datum/battlepass
	/// The current battlepass tier the user is at
	/// Max tier is stored on the master battlepass the server owns
	var/tier = 1 as num

	/// How much XP the user has in the current tier
	var/xp = 0 as num

	/// How much XP you need to go up a tier
	var/xp_tierup = 10 as num

	/// If the user has paid for a premium battlepass
	//var/premium = FALSE // (:

	/// List of personal daily challenges
	var/list/datum/battlepass_challenge/daily_challenges = list()

	/// When challenges were last updated, formatted as a UNIX timestamp
	var/daily_challenges_last_updated = 0 as num

	/// Weakref to the owning client
	var/datum/weakref/owning_client

/datum/battlepass/proc/add_xp(xp_amount)
	xp += xp_amount
	if(xp >= xp_tierup)
		xp -= xp_tierup
		tier++
		on_tier_up()

/datum/battlepass/proc/on_tier_up()
	// todo: add a sufficiently annoying visual popup
	return

/// Check if it's been 24h since daily challenges were last assigned
/datum/battlepass/proc/check_daily_challenge_reset()
	// Clients can connect before the SS is initialized
	if(!SSbattlepass?.initialized)
		return

	// 86400 seconds (24*60^2) is one day

	if((daily_challenges_last_updated + (24 * 60 * 60)) <= rustg_unix_timestamp())
		reset_daily_challenges()
		return TRUE
	return FALSE

/// Give the battlepass a new set of daily challenges
/datum/battlepass/proc/reset_daily_challenges()
	if(!owning_client)
		return

	// We give the player 1 marine challenge, 1 xeno challenge, and eventually 1 general challenge
	QDEL_LIST(daily_challenges)

	var/gotten_path = SSbattlepass.get_challenge(CHALLENGE_HUMAN)
	var/datum/battlepass_challenge/human_challenge = new gotten_path(owning_client.resolve())
	RegisterSignal(human_challenge, COMSIG_BATTLEPASS_CHALLENGE_COMPLETED, PROC_REF(on_challenge_complete))
	daily_challenges += human_challenge

	gotten_path = SSbattlepass.get_challenge(CHALLENGE_XENO)
	var/datum/battlepass_challenge/xeno_challenge = new gotten_path(owning_client.resolve())
	RegisterSignal(xeno_challenge, COMSIG_BATTLEPASS_CHALLENGE_COMPLETED, PROC_REF(on_challenge_complete))
	daily_challenges += xeno_challenge

	daily_challenges_last_updated = rustg_unix_timestamp()

/// Returns a list of all daily challenges formatted for a savefile
/datum/battlepass/proc/serialize_daily_challenges()
	. = list()
	for(var/datum/battlepass_challenge/challenge as anything in daily_challenges)
		. += list(challenge.serialize())

/// Provided a list of lists for daily challenges, load daily challenges from the lists
/datum/battlepass/proc/load_daily_challenges(list/challenge_data)
	if(!owning_client)
		return

	for(var/list/entry as anything in challenge_data)
		if(!("type" in entry))
			continue

		var/path = entry["type"]
		var/datum/battlepass_challenge/challenge = new path()
		daily_challenges += challenge
		RegisterSignal(challenge, COMSIG_BATTLEPASS_CHALLENGE_COMPLETED, PROC_REF(on_challenge_complete))
		challenge.deserialize(entry)

/// Called whenever a challenge is completed
/datum/battlepass/proc/on_challenge_complete(datum/battlepass_challenge/challenge)
	SIGNAL_HANDLER

	if(!owning_client)
		return

	var/client/resolved_client = owning_client.resolve()
	challenge.completed = TRUE
	challenge.unhook_signals(resolved_client.mob)

/datum/battlepass/proc/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Battlepass")
		ui.open()

/datum/battlepass/ui_state(mob/user)
	return GLOB.always_state

/datum/tutorial_menu/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/battlepass),
	)

/datum/battlepass/ui_data(mob/user)
	var/list/data = list()

	data["tier"] = tier
	data["xp"] = xp
	data["xp_tierup"] = xp_tierup

	return data

/datum/battlepass/ui_static_data(mob/user)
	var/list/data = list()

	data["season"] = SSbattlepass.season

	data["rewards"] = list()

	var/i = 1
	for(var/datum/battlepass_reward/reward_path as anything in SSbattlepass.season_rewards)
		data["rewards"] += list(list(
			"name" = initial(reward_path.name),
			"icon_state" = (initial(reward_path.icon_state) + "32x32"),
			"tier" = i,
		))
		i++

	return data

/datum/battlepass/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("emote")
			return
