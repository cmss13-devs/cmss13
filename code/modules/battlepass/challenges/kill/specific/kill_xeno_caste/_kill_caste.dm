/datum/battlepass_challenge/kill_enemies/xenomorphs/caste
	name = "Kill Xenomorphs - Caste"
	desc = "Kill AMOUNT CASTEs as a human."
	challenge_category = CHALLENGE_NONE
	/// Possible xenoes to pick from
	var/list/possible_xeno_castes = list()

/datum/battlepass_challenge/kill_enemies/xenomorphs/caste/New(client/owning_client)
	. = ..()
	if(!.)
		return .

	valid_kill_paths = list(pick(possible_xeno_castes))
	regenerate_desc()

/datum/battlepass_challenge/kill_enemies/xenomorphs/caste/regenerate_desc()
	var/mob/xeno_path = valid_kill_paths[1]
	desc = "Kill [enemy_kills_required] [initial(xeno_path.name)]\s as a human."
