/datum/caste_datum/praetorian
	caste_type = XENO_CASTE_PRAETORIAN
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_5
	melee_damage_upper = XENO_DAMAGE_TIER_5
	melee_vehicle_damage = XENO_DAMAGE_TIER_7
	max_health = XENO_HEALTH_TIER_9
	plasma_gain = XENO_PLASMA_GAIN_TIER_5
	plasma_max = XENO_PLASMA_TIER_8
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_4
	armor_deflection = XENO_ARMOR_TIER_2
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_6

	evolution_allowed = FALSE
	deevolves_to = list(XENO_CASTE_WARRIOR, XENO_CASTE_SPITTER)
	caste_desc = "The warleader of the hive."
	spit_types = list(/datum/ammo/xeno/acid/praetorian)
	acid_level = 2

	aura_strength = 3

	tackle_min = 2
	tackle_max = 5
	tackle_chance = 45

	available_strains = list(
		/datum/xeno_strain/dancer,
		/datum/xeno_strain/oppressor,
		/datum/xeno_strain/vanguard,
		/datum/xeno_strain/valkyrie,
	)
	behavior_delegate_type = /datum/behavior_delegate/praetorian_base

	minimum_evolve_time = 15 MINUTES

	minimap_icon = "praetorian"

	royal_caste = TRUE

/mob/living/carbon/xenomorph/praetorian
	caste_type = XENO_CASTE_PRAETORIAN
	name = XENO_CASTE_PRAETORIAN
	desc = "A huge, looming beast of an alien."
	icon_size = 64
	icon_state = "Praetorian Walking"
	plasma_types = list(PLASMA_PHEROMONE,PLASMA_NEUROTOXIN)
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_BIG
	drag_delay = 6 //pulling a big dead xeno is hard
	tier = 3
	organ_value = 3000

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/activable/xeno_spit/praetorian,
		/datum/action/xeno_action/activable/pounce/base_prae_dash,
		/datum/action/xeno_action/activable/prae_acid_ball,
		/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
		/datum/action/xeno_action/onclick/tacmap,
	)

	icon_xeno = 'icons/mob/xenos/castes/tier_3/praetorian.dmi'
	icon_xenonid = 'icons/mob/xenonids/castes/tier_3/praetorian.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Praetorian_1","Praetorian_2","Praetorian_3")
	weed_food_states_flipped = list("Praetorian_1","Praetorian_2","Praetorian_3")

	skull = /obj/item/skull/praetorian
	pelt = /obj/item/pelt/praetorian

/datum/behavior_delegate/praetorian_base
	name = "Base Praetorian Behavior Delegate"
	///reward for hitting shots instead of spamming acid ball
	var/reward_shield = 15

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

/datum/behavior_delegate/praetorian_base/ranged_attack_additional_effects_self(atom/A)
	if(!ismob(A))
		return
	bound_xeno.add_xeno_shield(reward_shield, XENO_SHIELD_SOURCE_BASE_PRAE, add_shield_on = TRUE, max_shield = 45)
	to_chat(bound_xeno, SPAN_NOTICE("Your exoskeleton shimmers for a fraction of a second as the acid coats your target."))
	return
