/datum/xeno_mutator/toxic
	name = "STRAIN: Sentinel - Toxic"
	description = "You trade your neurotoxin for cytotoxin, gaining a blinding spit, a faster sprint and cytotoxin infused slashing - all at a high plasma cost."
	flavor_description = "Kill them from the inside out."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_SENTINEL)
	keystone = TRUE
	behavior_delegate_type = /datum/behavior_delegate/sentinel_toxic
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/onclick/paralyzing_slash,
		/datum/action/xeno_action/activable/scattered_spit,
		/datum/action/xeno_action/activable/slowing_spit
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/blinding_spit,
		/datum/action/xeno_action/onclick/sentinel_sprint,
		/datum/action/xeno_action/onclick/toggle_toxic_slash
	)

/datum/xeno_mutator/toxic/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return
	var/mob/living/carbon/Xenomorph/Sentinel/S = MS.xeno
	S.mutation_type = SENTINEL_TOXIC
	S.health_modifier += XENO_HEALTH_MOD_MED

	mutator_update_actions(S)
	MS.recalculate_actions(description, flavor_description)

	apply_behavior_holder(S)

	S.recalculate_everything()

/datum/behavior_delegate/sentinel_toxic
	name = "Toxic Sentinel Behavior Delegate"
	var/toxic_toggle = FALSE

/datum/behavior_delegate/sentinel_toxic/melee_attack_additional_effects_target(mob/living/carbon/A)
	..()
	if (ishuman(A))
		var/mob/living/carbon/human/H = A
		if (H.stat == DEAD)
			return
	if(toxic_toggle)
		return
	if(bound_xeno.plasma_stored < 30)
		return
	A.apply_damage(5, TOX)
	bound_xeno.plasma_stored -= 20

