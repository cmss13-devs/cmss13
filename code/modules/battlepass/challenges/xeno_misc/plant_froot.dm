/datum/battlepass_challenge/plant_fruit
	name = "Plant Resin Fruit"
	desc = "Plant AMOUNT resin fruits."
	challenge_category = CHALLENGE_XENO
	completion_xp = 5
	pick_weight = 8
	var/minimum = 20 as num
	var/maximum = 30 as num
	var/requirement = 0 as num
	var/filled = 0 as num

/datum/battlepass_challenge/plant_fruit/New(client/owning_client)
	. = ..()
	if(!.)
		return .

	requirement = rand(minimum, maximum)
	regenerate_desc()

/datum/battlepass_challenge/plant_fruit/regenerate_desc()
	desc = "Plant [requirement] resin fruit\s."

/datum/battlepass_challenge/plant_fruit/on_client_login_mob(datum/source, mob/logged_in_mob)
	. = ..()
	if(!completed)
		RegisterSignal(logged_in_mob, COMSIG_XENO_PLANTED_FRUIT, PROC_REF(on_sigtrigger))

/datum/battlepass_challenge/plant_fruit/unhook_signals(mob/source)
	UnregisterSignal(source, COMSIG_XENO_PLANTED_FRUIT)

/datum/battlepass_challenge/plant_fruit/check_challenge_completed()
	return (filled >= requirement)

/datum/battlepass_challenge/plant_fruit/get_completion_percent()
	return (filled / requirement)

/datum/battlepass_challenge/plant_fruit/get_completion_numerator()
	return filled

/datum/battlepass_challenge/plant_fruit/get_completion_denominator()
	return requirement

/datum/battlepass_challenge/plant_fruit/serialize()
	. = ..()
	.["requirement"] = requirement
	.["filled"] = filled

/datum/battlepass_challenge/plant_fruit/deserialize(list/save_list)
	. = ..()
	requirement = save_list["requirement"]
	filled = save_list["filled"]

/// When the xeno plants a resin node
/datum/battlepass_challenge/plant_fruit/proc/on_sigtrigger(datum/source, mob/planter)
	SIGNAL_HANDLER
	if(should_block_game_interaction(planter))
		return

	filled++
	on_possible_challenge_completed()


