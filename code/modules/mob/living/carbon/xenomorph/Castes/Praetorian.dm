/datum/caste_datum/praetorian
	caste_name = "Praetorian"
	upgrade_name = "Young"
	tier = 3
	upgrade = 0

	melee_damage_lower = XENO_DAMAGE_MEDIUM
	melee_damage_upper = XENO_DAMAGE_MEDIUM
	max_health = XENO_HEALTH_VERYHIGH
	plasma_gain = XENO_PLASMA_GAIN_HIGHMED
	plasma_max = XENO_PLASMA_VERYHIGH
	xeno_explosion_resistance = XENO_HEAVY_EXPLOSIVE_ARMOR
	armor_deflection = XENO_LOWMED_ARMOR
	armor_hardiness_mult = XENO_ARMOR_FACTOR_CRUSHER
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_HIGH
	speed_mod = XENO_SPEED_MOD_LARGE

	tackle_chance = 45
	evolution_allowed = FALSE
	deevolves_to = "Warrior"
	spit_delay = 25
	caste_desc = "The warleader of the hive."
	spit_types = list(/datum/ammo/xeno/acid/praetorian)
	acid_level = 2
	aura_strength = 1

	behavior_delegate_type = /datum/behavior_delegate/praetorian_base

	
/datum/caste_datum/praetorian/mature
	upgrade_name = "Mature"
	caste_desc = "The warleader of the hive. It looks a little stronger."
	upgrade = 1
	aura_strength = 2.0
	tackle_chance = 50
	spit_delay = 20

/datum/caste_datum/praetorian/elder
	upgrade_name = "Elder"
	caste_desc = "The warleader of the hive. It looks pretty strong."
	upgrade = 2
	aura_strength = 3
	spit_delay = 20
	tackle_chance = 55

/datum/caste_datum/praetorian/ancient
	upgrade_name = "Ancient"
	caste_desc = "Dread it, run from it, death arrives all the same."
	upgrade = 3
	aura_strength = 4
	spit_delay = 15
	tackle_chance = 55

/datum/caste_datum/praetorian/primordial
	upgrade_name = "Primordial"
	caste_desc = "Why is this thing bigger than a dropship?!"
	upgrade = 4
	melee_damage_lower = 50
	melee_damage_upper = 60
	plasma_gain = 0.05
	plasma_max = 1500
	spit_delay = 0
	armor_deflection = 60
	tackle_chance = 60
	speed = -0.9
	aura_strength = 5.0
	max_health = XENO_UNIVERSAL_HPMULT * 350

/mob/living/carbon/Xenomorph/Praetorian
	caste_name = "Praetorian"
	name = "Praetorian"
	desc = "A huge, looming beast of an alien."
	icon = 'icons/mob/xenos/xenomorph_64x64.dmi'
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
