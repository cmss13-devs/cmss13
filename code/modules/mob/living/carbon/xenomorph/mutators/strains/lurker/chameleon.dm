/datum/xeno_mutator/chameleon
	name = "STRAIN: Lurker - Chameleon"
	description = "Trade in your ability to pounce and go invisible temporarily, in order to move faster and go invisible while stalking."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_LURKER)
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/activable/pounce/lurker,
		/datum/action/xeno_action/onclick/lurker_invisibility
	)
	behavior_delegate_type = /datum/behavior_delegate/lurker_chameleon
	keystone = TRUE

/datum/xeno_mutator/chameleon/apply_mutator(datum/mutator_set/individual_mutators/mutator)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Lurker/lurker = mutator.xeno
	lurker.mutation_type = LURKER_CHAMELEON
	lurker.mutation_icon_state = LURKER_NORMAL // replace this if you add custom sprites for this
	lurker.walk_speed = DEFAULT_WALK_SPEED - 1
	lurker.speed_modifier += XENO_SPEED_FASTMOD_TIER_3
	apply_behavior_holder(lurker)
	mutator_update_actions(lurker)
	mutator.recalculate_actions(description, flavor_description)
	lurker.recalculate_stats()
	lurker.set_movement_intent(lurker.m_intent) // lazy but it works

/datum/behavior_delegate/lurker_chameleon
	name = "Chameleon Lurker Behavior Delegate"

/datum/behavior_delegate/lurker_chameleon/handle_movement_change(var/new_movement_intent)
	. = ..()
	animate(bound_xeno, alpha = new_movement_intent > MOVE_INTENT_WALK ? initial(bound_xeno.alpha) : 10, time = 0.1 SECONDS, easing = QUAD_EASING)

