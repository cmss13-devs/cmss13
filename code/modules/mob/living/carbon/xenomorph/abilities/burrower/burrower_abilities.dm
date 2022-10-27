// Burrower Abilities

// Burrow
/datum/action/xeno_action/activable/burrow
	name = "Burrow"
	action_icon_state = "agility_on"
	ability_name = "burrow"
	macro_path = /datum/action/xeno_action/verb/verb_burrow
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3

/datum/action/xeno_action/activable/burrow/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(X.burrow && X.mutation_type != BURROWER_IMPALER)
		X.tunnel(get_turf(A))
	else
		X.burrow()

/datum/action/xeno_action/onclick/tremor
	name = "Tremor (100)"
	action_icon_state = "stomp"
	ability_name = "tremor"
	macro_path = /datum/action/xeno_action/verb/verb_tremor
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4

/datum/action/xeno_action/onclick/tremor/use_ability()
	var/mob/living/carbon/Xenomorph/X = owner
	X.tremor()
	..()

//Spiker abilities
/datum/action/xeno_action/activable/burrowed_spikes
	name = "Burrowed Spikes"
	ability_name = "burrowed spikes"
	action_icon_state = "burrowed_spikes"
	macro_path = /datum/action/xeno_action/verb/verb_burrowed_spikes
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 10 SECONDS
	plasma_cost = 50

	// Config
	var/base_damage = 25
	var/chain_separation_delay = 0.2 SECONDS //Delay between each tile hit
	var/max_distance = 4
	var/reinforced_range_bonus = 1
	var/reinforced_damage_bonus = 10

/datum/action/xeno_action/activable/sunken_tail
	name = "Sunken Tail"
	ability_name = "sunken tail"
	action_icon_state = "sunken_tail"
	macro_path = /datum/action/xeno_action/verb/verb_sunken_tail
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 15 SECONDS
	plasma_cost = 80

	// Config
	var/base_damage = 40
	var/windup_delay = 1 SECONDS
	var/max_distance = 5
	var/reinforced_range_bonus = 3
	var/reinforced_damage_bonus = 10

/datum/action/xeno_action/activable/ensconce
	name = "Ensconce"
	ability_name = "ensconce"
	action_icon_state = "ensconce"
	macro_path = /datum/action/xeno_action/verb/verb_ensconce
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4
	xeno_cooldown = 5 SECONDS
	plasma_cost = 0

	// Config
	var/windup_delay = 1 SECONDS
	var/reinforced_vision_range = 8
