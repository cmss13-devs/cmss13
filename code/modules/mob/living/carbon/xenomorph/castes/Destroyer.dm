/datum/caste_datum/destroyer
	caste_type = XENO_CASTE_DESTROYER
	caste_desc = "The end of the line."
	tier = 1

	// All to change
	melee_damage_lower = XENO_DAMAGE_TIER_6
	melee_damage_upper = XENO_DAMAGE_TIER_8
	melee_vehicle_damage = XENO_DAMAGE_TIER_5
	max_health = XENO_HEALTH_DESTROYER
	plasma_gain = XENO_PLASMA_GAIN_TIER_3
	plasma_max = XENO_PLASMA_TIER_10
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_7
	armor_deflection = XENO_ARMOR_FACTOR_TIER_5
	speed = XENO_SPEED_TIER_1

	evolves_to = null
	deevolves_to = null
	can_vent_crawl = FALSE

	behavior_delegate_type = /datum/behavior_delegate/destroyer_base

	tackle_min = 2
	tackle_max = 4

	minimap_icon = "defender"

	fire_immunity = FIRE_IMMUNITY_NO_DAMAGE

/mob/living/carbon/xenomorph/destroyer
	caste_type = XENO_CASTE_DESTROYER
	name = XENO_CASTE_DESTROYER
	desc = "A massive alien covered in spines and armoured plates."
	icon = 'icons/mob/xenos/destroyer.dmi'
	icon_size = 64
	icon_state = "Destroyer Walking"
	plasma_types = list(PLASMA_CHITIN)
	pixel_x = -16
	old_x = -16
	tier = 4
	small_explosives_stun = FALSE
	counts_for_slots = FALSE
	tackle_min = 5
	tackle_max = 8
	tackle_chance = 10

	claw_type = CLAW_TYPE_VERY_SHARP
	age = -1

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/onclick/rend,
		/datum/action/xeno_action/activable/doom,
		/datum/action/xeno_action/activable/destroy,
		/datum/action/xeno_action/onclick/destroyer_shield,
	)

	//Change these
	mutation_icon_state = DEFENDER_NORMAL
	mutation_type = DEFENDER_NORMAL

	icon_xeno = 'icons/mob/xenos/destroyer.dmi'
	//icon_xenonid = ''

	//weed_food_icon = ''
	weed_food_states = list()
	weed_food_states_flipped = list()

/datum/behavior_delegate/destroyer_base
	name = "Base Destroyer Behavior Delegate"
	///reward for hitting shots instead of spamming acid ball

/// Knocks down hostiles and deals damage, knocks down allies for a much shorter time
/datum/behavior_delegate/destroyer_base/on_collide(atom/movable/movable_atom)
	if(isxeno_human(movable_atom))
		var/mob/living/carbon/carbon = movable_atom

		if(isxeno(carbon))
			var/mob/living/carbon/xenomorph/xeno = carbon
			if(xeno.hivenumber == bound_xeno.hivenumber)
				xeno.KnockDown((5 DECISECONDS) / GLOBAL_STATUS_MULTIPLIER)
			else
				xeno.KnockDown((1 SECONDS) / GLOBAL_STATUS_MULTIPLIER)
		else
			//Review damage and knockdown
			carbon.apply_armoured_damage(20)
			carbon.KnockDown((1 SECONDS) / GLOBAL_STATUS_MULTIPLIER)

/datum/behavior_delegate/destroyer_base/melee_attack_additional_effects_self()
	..()
	to_chat(world, "Attack self")
