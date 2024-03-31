/client
	/// Reference to the client's battlepass
	var/datum/battlepass/owned_battlepass

/client/New()
	. = ..()
	init_battlepass()

/client/Destroy()
	save_battlepass()
	return ..()

/client/proc/init_battlepass()
	if(fexists("data/player_saves/[copytext(ckey,1,2)]/[ckey]/battlepass.sav"))
		load_battlepass()
		return

	owned_battlepass = new()
	owned_battlepass.owning_client = WEAKREF(src)
	owned_battlepass.tier = 1
	owned_battlepass.xp = 0
	owned_battlepass.daily_challenges_last_updated = 0
	owned_battlepass.check_daily_challenge_reset()
	owned_battlepass.previous_on_tier_up_tier = owned_battlepass.tier

/client/proc/load_battlepass()
	var/savefile/battlepass_save = new("data/player_saves/[copytext(ckey,1,2)]/[ckey]/battlepass.sav")

	owned_battlepass = new()
	owned_battlepass.owning_client = WEAKREF(src)
	owned_battlepass.tier = battlepass_save["tier"]
	owned_battlepass.xp = battlepass_save["xp"]
	owned_battlepass.check_tier_up(FALSE)
	owned_battlepass.daily_challenges_last_updated = battlepass_save["daily_challenges_last_updated"]
	owned_battlepass.load_daily_challenges(battlepass_save["daily_challenges"])
	owned_battlepass.check_daily_challenge_reset()
	owned_battlepass.load_rewards(battlepass_save["rewards"])
	owned_battlepass.previous_on_tier_up_tier = battlepass_save["previous_on_tier_up_tier"]
	if(SSbattlepass.initialized)
		owned_battlepass.verify_rewards()

/client/proc/save_battlepass()
	var/savefile/battlepass_save = new("data/player_saves/[copytext(ckey,1,2)]/[ckey]/battlepass.sav")

	battlepass_save["tier"] = owned_battlepass.tier
	battlepass_save["xp"] = owned_battlepass.xp
	battlepass_save["daily_challenges_last_updated"] = owned_battlepass.daily_challenges_last_updated
	battlepass_save["daily_challenges"] = owned_battlepass.serialize_daily_challenges()
	battlepass_save["rewards"] = owned_battlepass.serialize_rewards()
	battlepass_save["previous_on_tier_up_tier"] = owned_battlepass.previous_on_tier_up_tier
