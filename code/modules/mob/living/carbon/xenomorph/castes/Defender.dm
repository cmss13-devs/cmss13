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

	available_strains = list(/datum/xeno_strain/steel_crest)
	behavior_delegate_type = /datum/behavior_delegate/defender_base

	tackle_min = 2
	tackle_max = 4

	minimum_evolve_time = 4 MINUTES

	minimap_icon = "defender"

/mob/living/carbon/xenomorph/defender
	caste_type = XENO_CASTE_DEFENDER
	name = XENO_CASTE_DEFENDER
	desc = "A alien with an armored crest."
	icon = 'icons/mob/xenos/defender.dmi'
	icon_size = 64
	icon_state = "Defender Walking"
	plasma_types = list(PLASMA_CHITIN)
	pixel_x = -16
	old_x = -16
	tier = 1
	organ_value = 1000

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab/slam,
		/datum/action/xeno_action/onclick/toggle_crest,
		/datum/action/xeno_action/activable/headbutt,
		/datum/action/xeno_action/onclick/tail_sweep,
		/datum/action/xeno_action/activable/fortify,
		/datum/action/xeno_action/onclick/tacmap,
	)

	icon_xeno = 'icons/mob/xenos/defender.dmi'
	icon_xenonid = 'icons/mob/xenonids/defender.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Defender_1","Defender_2","Defender_3")
	weed_food_states_flipped = list("Defender_1","Defender_2","Defender_3")

/mob/living/carbon/xenomorph/defender/handle_special_state()
	if(fortify)
		return TRUE
	if(crest_defense)
		return TRUE
	return FALSE

/mob/living/carbon/xenomorph/defender/handle_special_wound_states(severity)
	. = ..()
	if(fortify)
		return "Defender_fortify_[severity]"
	if(crest_defense)
		return "Defender_crest_[severity]"

/mob/living/carbon/xenomorph/defender/handle_special_backpack_states()
	. = ..()
	if(fortify)
		return " Fortify"
	if(crest_defense)
		return " Crest"

/datum/behavior_delegate/defender_base
	name = "Base Defender Behavior Delegate"

/datum/behavior_delegate/defender_base/on_update_icons()
	if(bound_xeno.stat == DEAD)
		return

	if(bound_xeno.fortify && bound_xeno.health > 0)
		bound_xeno.icon_state = "[bound_xeno.get_strain_icon()] Defender Fortify"
		return TRUE
	if(bound_xeno.crest_defense && bound_xeno.health > 0)
		bound_xeno.icon_state = "[bound_xeno.get_strain_icon()] Defender Crest"
		return TRUE
