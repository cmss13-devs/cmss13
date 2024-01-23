/datum/xeno_strain/steel_crest
	name = DEFENDER_STEELCREST
	description = "You trade your tail sweep and a small amount of your slash damage for slightly increased headbutt knockback and damage and the ability to slowly move and headbutt while fortified. Along with this, you gain a unique ability to accumulate damage, and use it to recover a slight amount of health and refresh your tail slam."
	flavor_description = "To handle yourself, use your head. To handle others, use your head."
	xeno_icon_state = DEFENDER_STEELCREST

	actions_to_remove = list(
		/datum/action/xeno_action/activable/headbutt,
		/datum/action/xeno_action/activable/fortify,
		/datum/action/xeno_action/onclick/tail_sweep,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/headbutt/steel_crest,
		/datum/action/xeno_action/activable/fortify/steel_crest,
		/datum/action/xeno_action/onclick/soak,
	)

	behavior_delegate_type = /datum/behavior_delegate/defender_steel_crest

/datum/xeno_strain/steel_crest/apply_strain(mob/living/carbon/xenomorph/defender/defender)
	defender.damage_modifier -= XENO_DAMAGE_MOD_VERY_SMALL
	if(defender.fortify)
		defender.ability_speed_modifier += 2.5
	defender.recalculate_stats()

/datum/behavior_delegate/defender_steel_crest
	name = "Steel Crest Defender Behavior Delegate"

/datum/behavior_delegate/defender_steel_crest/on_update_icons()
	if(bound_xeno.stat == DEAD)
		return

	if(bound_xeno.fortify)
		bound_xeno.icon_state = "[bound_xeno.get_strain_icon()] Steelcrest Defender Fortify"
		return TRUE
	if(bound_xeno.crest_defense)
		bound_xeno.icon_state = "[bound_xeno.get_strain_icon()] Steelcrest Defender Crest"
		return TRUE
