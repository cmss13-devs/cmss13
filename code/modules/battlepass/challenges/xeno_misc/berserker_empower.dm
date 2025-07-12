/datum/battlepass_challenge/berserker_rage
	name = "Max Berserker Rage"
	desc = "As a Berserker Ravager, enter maximum berserker rage AMOUNT times."
	challenge_category = CHALLENGE_XENO
	completion_xp = 5
	pick_weight = 6
	/// The minimum possible amount of times rage needs to be entered
	var/minimum_rages = 2 as num
	/// The maximum
	var/maximum_rages = 4 as num
	var/rage_requirement = 0 as num
	var/completed_rages = 0 as num

/datum/battlepass_challenge/berserker_rage/New(client/owning_client)
	. = ..()
	if(!.)
		return .

	rage_requirement = rand(minimum_rages, maximum_rages)
	regenerate_desc()

/datum/battlepass_challenge/berserker_rage/regenerate_desc()
	desc = "As a Berserker Ravager, enter maximum berserker rage [rage_requirement] time\s."

/datum/battlepass_challenge/berserker_rage/on_client_login_mob(datum/source, mob/logged_in_mob)
	. = ..()
	if(!completed)
		RegisterSignal(logged_in_mob, COMSIG_XENO_RAGE_MAX, PROC_REF(on_rage_max))

/datum/battlepass_challenge/berserker_rage/unhook_signals(mob/source)
	UnregisterSignal(source, COMSIG_XENO_RAGE_MAX)

/datum/battlepass_challenge/berserker_rage/check_challenge_completed()
	return (completed_rages >= rage_requirement)

/datum/battlepass_challenge/berserker_rage/get_completion_percent()
	return (completed_rages / rage_requirement)

/datum/battlepass_challenge/berserker_rage/get_completion_numerator()
	return completed_rages

/datum/battlepass_challenge/berserker_rage/get_completion_denominator()
	return rage_requirement

/datum/battlepass_challenge/berserker_rage/serialize()
	. = ..()
	.["rage_requirement"] = rage_requirement
	.["completed_rages"] = completed_rages

/datum/battlepass_challenge/berserker_rage/deserialize(list/save_list)
	. = ..()
	rage_requirement = save_list["rage_requirement"]
	completed_rages = save_list["completed_rages"]

/// When the xeno plants a resin node
/datum/battlepass_challenge/berserker_rage/proc/on_rage_max(datum/source)
	SIGNAL_HANDLER

	completed_rages++
	on_possible_challenge_completed()


