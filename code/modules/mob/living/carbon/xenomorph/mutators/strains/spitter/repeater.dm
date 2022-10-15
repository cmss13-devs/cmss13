/datum/xeno_mutator/repeater
	name = "STRAIN: Spitter - Repeater"
	description = "In exchange for frenzy, spraying acid, damage over time spits, and a bit of your movement speed; you gain armor and health, and an increased acid regeneration rate. If you hit a target directly, your spit cooldown is greatly decreased!"
	flavor_description = "Blot out the sky."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_SPITTER)
	keystone = TRUE
	behavior_delegate_type = /datum/behavior_delegate/spitter_repeater
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/onclick/spitter_frenzy,
		/datum/action/xeno_action/activable/spray_acid/spitter
	)

/datum/xeno_mutator/repeater/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Spitter/spitter = MS.xeno
	spitter.mutation_type = SPITTER_REPEATER
	spitter.speed_modifier += XENO_SPEED_SLOWMOD_TIER_5
	spitter.armor_modifier += XENO_ARMOR_MOD_MED
	spitter.health_modifier += XENO_HEALTH_MOD_MED
	spitter.spit_delay_modifier -= 2 SECONDS
	apply_behavior_holder(spitter)
	mutator_update_actions(spitter)
	spitter.recalculate_everything()
	MS.recalculate_actions(description, flavor_description)

/datum/behavior_delegate/spitter_repeater/ranged_attack_additional_effects_self(atom/A)
	if(!ismob(A))
		return
	var/datum/action/xeno_action/activable/xeno_spit/spit_ability = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/activable/xeno_spit)
	spit_ability.apply_cooldown_override(spit_ability.xeno_cooldown * 0.25)
	to_chat(bound_xeno, SPAN_XENONOTICE("The acid reserves on your head flare in excitement as you bombard your target!"))
