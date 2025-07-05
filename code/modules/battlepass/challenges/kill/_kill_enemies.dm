/datum/battlepass_challenge/kill_enemies
	/// How many enemies need to be killed to complete the challenge
	var/enemy_kills_required = 0 as num
	/// How many enemies have been killed thus far for this challenge
	var/current_enemy_kills = 0 as num
	/// A list of valid mob paths to count towards kills
	var/list/valid_kill_paths = list()
	/// The minimum amt of kills possibly required to complete this challenge
	var/kill_requirement_lower = 0 as num
	/// The maximum amt of kills possibly required to complete this challenge
	var/kill_requirement_upper = 0 as num

/datum/battlepass_challenge/kill_enemies/New(client/owning_client)
	. = ..()
	if(!.)
		return .

	enemy_kills_required = rand(kill_requirement_lower, kill_requirement_upper)
	regenerate_desc()

/datum/battlepass_challenge/kill_enemies/on_client_login_mob(datum/source, mob/logged_in_mob)
	. = ..()
	if(!completed)
		RegisterSignal(logged_in_mob, COMSIG_MOB_KILL_TOTAL_INCREASED, PROC_REF(on_kill))

/datum/battlepass_challenge/kill_enemies/unhook_signals(mob/source)
	UnregisterSignal(source, COMSIG_MOB_KILL_TOTAL_INCREASED)

/datum/battlepass_challenge/kill_enemies/check_challenge_completed()
	return (enemy_kills_required <= current_enemy_kills)

/datum/battlepass_challenge/kill_enemies/get_completion_percent()
	return (current_enemy_kills / enemy_kills_required)

/datum/battlepass_challenge/kill_enemies/get_completion_numerator()
	return current_enemy_kills

/datum/battlepass_challenge/kill_enemies/get_completion_denominator()
	return enemy_kills_required

/datum/battlepass_challenge/kill_enemies/serialize()
	. = ..()
	.["enemy_kills_required"] = enemy_kills_required
	.["current_enemy_kills"] = current_enemy_kills
	.["valid_kill_paths"] = valid_kill_paths

/datum/battlepass_challenge/kill_enemies/deserialize(list/save_list)
	. = ..()
	enemy_kills_required = save_list["enemy_kills_required"]
	current_enemy_kills = save_list["current_enemy_kills"]
	valid_kill_paths = save_list["valid_kill_paths"]

/datum/battlepass_challenge/kill_enemies/proc/on_kill(mob/source, mob/killed_mob, datum/cause_data/cause_data)
	SIGNAL_HANDLER

	// Facehuggers and lessers have a life_value of 0, so they aren't counted
	if(is_type_in_list(killed_mob, valid_kill_paths) && killed_mob.life_value)
		current_enemy_kills++

	on_possible_challenge_completed()
