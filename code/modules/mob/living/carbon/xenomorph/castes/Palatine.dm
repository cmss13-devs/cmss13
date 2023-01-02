/datum/caste_datum/palatine
	caste_type = XENO_CASTE_PALATINE
	tier = 0

	melee_damage_lower = XENO_DAMAGE_TIER_7
	melee_damage_upper = XENO_DAMAGE_TIER_8
	melee_vehicle_damage = XENO_DAMAGE_TIER_9
	max_health = XENO_HEALTH_IMMORTAL
	plasma_gain = XENO_PLASMA_GAIN_TIER_8
	plasma_max = XENO_PLASMA_TIER_10
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_6
	armor_deflection = XENO_ARMOR_TIER_5
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_5

	evolution_allowed = FALSE
	deevolves_to = list()
	caste_desc = "The guard of the Queen Mother"
	spit_types = list(/datum/ammo/xeno/toxin/queen, /datum/ammo/xeno/acid/spatter)
	acid_level = 3

	aura_strength = 3
	spit_delay = 20

	tackle_min = 2
	tackle_max = 5
	tackle_chance = 45

	behavior_delegate_type = /datum/behavior_delegate/palatine_base

/mob/living/carbon/Xenomorph/Palatine
	caste_type = XENO_CASTE_PALATINE
	name = XENO_CASTE_PALATINE
	desc = "What god did you anger..."
	icon_size = 64
	icon_state = "Normal Palatine Walking"
	plasma_types = list(PLASMA_ROYAL,PLASMA_CHITIN,PLASMA_PHEROMONE,PLASMA_NEUROTOXIN)
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_BIG
	drag_delay = 6 //pulling a big dead xeno is hard
	tier = 0
	mutation_type = "Normal"

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/corrosive_acid/strong,
		/datum/action/xeno_action/activable/xeno_spit/palatine_macro,
		/datum/action/xeno_action/onclick/shift_spits,
		/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
		/datum/action/xeno_action/onclick/palatine_roar,//Mac1
		/datum/action/xeno_action/onclick/palatine_change_roar,
		/datum/action/xeno_action/activable/prae_abduct/palatine_macro,//Mac2
		/datum/action/xeno_action/activable/prae_retrieve,//Mac3
		/datum/action/xeno_action/activable/warden_heal,//Mac4
		/datum/action/xeno_action/onclick/prae_switch_heal_type,//Mac5
		/datum/action/xeno_action/onclick/emit_pheromones,
	)

	icon_xeno = 'icons/mob/xenos/palatine.dmi'
	icon_xenonid = 'icons/mob/xenos/palatine.dmi'

/datum/behavior_delegate/palatine_base
	name = "Base Palatine Behavior Delegate"

	var/thirst = 0
	var/max_thirst = 10

/datum/behavior_delegate/palatine_base/append_to_stat()
	. = list()
	. += "Bloodthirst: [thirst]/[max_thirst]"

/datum/behavior_delegate/palatine_base/on_kill_mob(mob/M)
	. = ..()

	thirst = min(thirst + 1, max_thirst)

/datum/behavior_delegate/palatine_base/melee_attack_modify_damage(original_damage, mob/living/carbon/A)
	if(!isCarbonSizeHuman(A))
		return
//	var/mob/living/carbon/human/H = A

	return original_damage + thirst * 2.5
