/datum/action/xeno_action/onclick/plasma_strike
	name = "Plasma Strike"
	action_icon_state = "lurker_inject_neuro"
	ability_name = "plasma strike"
	macro_path = /datum/action/xeno_action/verb/verb_plasma_strike
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 20 SECONDS
	plasma_cost = 150

	var/buff_duration = 8 SECONDS

/datum/action/xeno_action/onclick/claw_toss
	name = "Prime Claw Toss"
	action_icon_state = "fling"
	ability_name = "prime claw toss"
	macro_path = /datum/action/xeno_action/verb/verb_plasma_strike
	ability_primacy = XENO_PRIMARY_ACTION_4
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 15 SECONDS
	plasma_cost = 50

	var/buff_duration = 8 SECONDS

/datum/action/xeno_action/activable/tail_stab/reaper
	name = "Claw Strike"
	action_icon_state = "claw_strike"
	xeno_cooldown = 5 SECONDS
	claw_stab = TRUE
	stabbing_with_noun = "claw"
	stab_range = 3

/datum/action/xeno_action/activable/tail_stab/reaper/use_ability(atom/A)
	var/is_tossing = FALSE

	var/mob/living/carbon/Xenomorph/xeno = owner
	var/datum/behavior_delegate/base_reaper/behavior = xeno.behavior_delegate
	if(istype(behavior))
		is_tossing = behavior.claw_toss_primed

	var/target = ..()
	if(!is_tossing && iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		var/distance_from_target = get_dist(owner, carbon_target)
		if(distance_from_target < 2)
			return
		shake_camera(carbon_target, 2, 1)
		carbon_target.throw_atom(owner, distance_from_target - 1, SPEED_VERY_FAST, owner)
