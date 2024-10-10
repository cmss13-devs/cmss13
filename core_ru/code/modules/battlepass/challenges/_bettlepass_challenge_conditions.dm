// Base Condition Class
/datum/battlepass_challenge_module/condition
	pick_weight = 5

	var/revers_value = FALSE

/datum/battlepass_challenge_module/condition/allow_completion(list/sub_requirements)
	var/current_pos = sub_requirements[src]
	var/datum/battlepass_challenge_module/next_module = sub_requirements[current_pos + 1]
	var/result = next_module.allow_completion(sub_requirements)
	return revers_value ? !result : result

// "With" Condition
/datum/battlepass_challenge_module/condition/with
	name = " With "
	desc = " with "
	code_name = "with"

	compatibility = list("strict" = list(), "subtyped" = list(/datum/battlepass_challenge_module/requirement/bad_buffs))

// "Without" Condition
/datum/battlepass_challenge_module/condition/without
	name = " Without "
	desc = " without "
	code_name = "without"

	compatibility = list("strict" = list(), "subtyped" = list(/datum/battlepass_challenge_module/requirement/good_buffs))

	revers_value = TRUE

// "After" Condition
/datum/battlepass_challenge_module/condition/after
	name = " After "
	desc = " after "
	code_name = "after"

	pick_weight = 0 // WIP

	compatibility = list("strict" = list(), "subtyped" = list(/datum/battlepass_challenge_module/requirement))

// "Before" Condition
/datum/battlepass_challenge_module/condition/before
	name = " Before "
	desc = " before "
	code_name = "before"

	pick_weight = 0 // WIP

	compatibility = list("strict" = list(), "subtyped" = list(/datum/battlepass_challenge_module/requirement))

	revers_value = TRUE

// "And" Condition
/datum/battlepass_challenge_module/condition/and
	name = " And "
	desc = " and "
	code_name = "and"

	compatibility = list("strict" = list(), "subtyped" = list(/datum/battlepass_challenge_module/requirement))

// "Exempt" Condition
/datum/battlepass_challenge_module/condition/exempt
	name = " Exempt "
	desc = " exempt "
	code_name = "exempt"

	pick_weight = 0 // WIP

	compatibility = list("strict" = list(), "subtyped" = list(/datum/battlepass_challenge_module/requirement))

#undef BATTLEPASS_HUMAN_CHALLENGE
#undef BATTLEPASS_XENO_CHALLENGE
#undef BATTLEPASS_CHALLENGE_WEAPON
