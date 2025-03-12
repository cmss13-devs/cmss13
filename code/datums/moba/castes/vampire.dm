/datum/moba_caste/vampire
	equivalent_caste_path = /datum/caste_datum/lurker
	equivalent_xeno_path = /mob/living/carbon/xenomorph/lurker
	name = "Vampire"
	desc = {"
		Aggressive melee combat caste focused on lifesteal and scaling.<br>
		<b>P:</b> Gain permanent stacks of bloodlust from landing your abilities. Every 5 stacks of bloodlust grants lifesteal.<br>
		<b>1:</b> Rush towards a target.<br>
		<b>2:</b> Slash in a wide area in front of you, healing for each target hit.<br>
		<b>3:</b> Quickly stab a target with your tail, ignoring some armor.<br>
		<b>U:</b> Headbite a low-health target, executing them and healing a large amount of health.
	"}
	category = MOBA_ARCHETYPE_FIGHTER
	icon_state = "drone"
	ideal_roles = list(MOBA_LANE_TOP, MOBA_LANE_JUNGLE)
	starting_health = 500
	ending_health = 2000
	starting_health_regen = 1.5
	ending_health_regen = 6
	starting_plasma = 400
	ending_plasma = 800
	starting_plasma_regen = 1.2
	ending_plasma_regen = 3.6
	starting_armor = 0
	ending_armor = 20
	starting_acid_armor = 0
	ending_acid_armor = 15
	speed = 0.8
	attack_delay_modifier = 0
	starting_attack_damage = 40
	ending_attack_damage = 65
	abilities_to_add = list(

	)


/datum/action/xeno_action/activable/pounce/rush/moba
	name = "Rush"
	action_icon_state = "pounce"
	action_text = "rush"
	macro_path = /datum/action/xeno_action/verb/verb_rush
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 6 SECONDS
	plasma_cost = 0

	// Config options
	distance = 4
	knockdown = FALSE
	freeze_self = FALSE

/datum/action/xeno_action/activable/pounce/rush/moba/proc/a()
