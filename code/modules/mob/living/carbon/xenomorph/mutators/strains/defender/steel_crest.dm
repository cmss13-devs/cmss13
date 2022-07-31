/datum/xeno_mutator/steel_crest
	name = "STRAIN: Defender - Steel Crest"
	description = "You trade a small amount of your already weak damage and your tail swipe for slightly increased headbutt knockback and damage, and the ability to slowly move and headbutt while fortified."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_DEFENDER)
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/onclick/tail_sweep,
	)
	behavior_delegate_type = /datum/behavior_delegate/defender_steel_crest
	keystone = TRUE

/datum/xeno_mutator/steel_crest/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Defender/D = MS.xeno
	D.mutation_type = DEFENDER_STEELCREST
	D.damage_modifier -= XENO_DAMAGE_MOD_VERYSMALL
	D.steelcrest = TRUE
	if(D.fortify)
		D.ability_speed_modifier += 2.5
	mutator_update_actions(D)
	MS.recalculate_actions(description, flavor_description)
	D.recalculate_stats()

/datum/behavior_delegate/defender_steel_crest
	name = "Steel Crest Defender Behavior Delegate"

/datum/behavior_delegate/defender_steel_crest/on_update_icons()
	if(bound_xeno.stat == DEAD)
		return

	if(bound_xeno.fortify)
		bound_xeno.icon_state = "[bound_xeno.mutation_type] Defender Fortify"
		return TRUE
	if(bound_xeno.crest_defense)
		bound_xeno.icon_state = "[bound_xeno.mutation_type] Defender Crest"
		return TRUE
