/datum/caste_datum/praetorian
	caste_name = "Praetorian"
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_5
	melee_damage_upper = XENO_DAMAGE_TIER_5
	max_health = XENO_HEALTH_TIER_8
	plasma_gain = XENO_PLASMA_GAIN_TIER_7
	plasma_max = XENO_PLASMA_TIER_10
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_4
	armor_deflection = XENO_ARMOR_TIER_2
	armor_hardiness_mult = XENO_ARMOR_FACTOR_CRUSHER
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_6

	evolution_allowed = FALSE
	deevolves_to = "Warrior"
	caste_desc = "The warleader of the hive."
	spit_types = list(/datum/ammo/xeno/acid/praetorian)
	acid_level = 2

	aura_strength = 3
	spit_delay = 20

	tackle_min = 2
	tackle_max = 5
	tackle_chance = 45

	behavior_delegate_type = /datum/behavior_delegate/praetorian_base

/mob/living/carbon/Xenomorph/Praetorian
	caste_name = "Praetorian"
	name = "Praetorian"
	desc = "A huge, looming beast of an alien."
	icon_source = "alien_praetorian"
	icon_size = 64
	icon_state = "Praetorian Walking"
	plasma_types = list(PLASMA_PHEROMONE,PLASMA_NEUROTOXIN)
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_BIG
	drag_delay = 6 //pulling a big dead xeno is hard
	tier = 3
	mutation_type = PRAETORIAN_NORMAL

	actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/activable/pounce/base_prae_dash,
		/datum/action/xeno_action/activable/prae_acid_ball,
		/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
	)

/datum/behavior_delegate/praetorian_base
	name = "Base Praetorian Behavior Delegate"

/datum/behavior_delegate/praetorian_base/ranged_attack_additional_effects_target(atom/A)
	if (!ishuman(A))
		return

	var/mob/living/carbon/human/H = A

	var/datum/effects/prae_acid_stacks/PAS = null 
	for (var/datum/effects/prae_acid_stacks/prae_acid_stacks in H.effects_list)
		PAS = prae_acid_stacks
		break 

	if (PAS == null)
		new /datum/effects/prae_acid_stacks(H)
		return
	else
		PAS.increment_stack_count()
		return

	H.update_xeno_hostile_hud()
