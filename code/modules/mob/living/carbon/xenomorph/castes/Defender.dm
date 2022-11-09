/datum/caste_datum/defender
	caste_type = XENO_CASTE_DEFENDER
	caste_desc = "A sturdy front line combatant."
	tier = 1

	melee_damage_lower = XENO_DAMAGE_TIER_2
	melee_damage_upper = XENO_DAMAGE_TIER_3
	melee_vehicle_damage = XENO_DAMAGE_TIER_3
	max_health = XENO_HEALTH_TIER_6
	plasma_gain = XENO_PLASMA_GAIN_TIER_9
	plasma_max = XENO_PLASMA_TIER_1
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_7
	armor_deflection = XENO_ARMOR_TIER_4
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_6

	evolves_to = list(XENO_CASTE_WARRIOR)
	deevolves_to = list("Larva")
	can_vent_crawl = 0

	behavior_delegate_type = /datum/behavior_delegate/defender_base

	tackle_min = 2
	tackle_max = 4

/mob/living/carbon/Xenomorph/Defender
	caste_type = XENO_CASTE_DEFENDER
	name = XENO_CASTE_DEFENDER
	desc = "A alien with an armored head crest."
	icon = 'icons/mob/hostiles/defender.dmi'
	icon_size = 64
	icon_state = "Defender Walking"
	plasma_types = list(PLASMA_CHITIN)
	pixel_x = -16
	old_x = -16
	tier = 1
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab/slam,
		/datum/action/xeno_action/onclick/toggle_crest,
		/datum/action/xeno_action/activable/headbutt,
		/datum/action/xeno_action/onclick/tail_sweep,
		/datum/action/xeno_action/activable/fortify,
	)
	mutation_type = DEFENDER_NORMAL
	icon_xeno = 'icons/mob/hostiles/defender.dmi'
	icon_xenonid = 'icons/mob/xenonids/defender.dmi'

/mob/living/carbon/Xenomorph/Defender/handle_special_state()
	if(fortify)
		return TRUE
	if(crest_defense)
		return TRUE
	return FALSE

/mob/living/carbon/Xenomorph/Defender/handle_special_wound_states(severity)
	. = ..()
	if(fortify)
		return "Defender_fortify_[severity]"
	if(crest_defense)
		return "Defender_crest_[severity]"

/datum/behavior_delegate/defender_base
	name = "Base Defender Behavior Delegate"

/datum/behavior_delegate/defender_base/on_update_icons()
	if(bound_xeno.stat == DEAD)
		return

	if(bound_xeno.fortify)
		bound_xeno.icon_state = "[bound_xeno.mutation_type] Defender Fortify"
		return TRUE
	if(bound_xeno.crest_defense)
		bound_xeno.icon_state = "[bound_xeno.mutation_type] Defender Crest"
		return TRUE
