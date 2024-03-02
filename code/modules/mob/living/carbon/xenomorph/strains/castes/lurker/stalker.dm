/datum/xeno_mutator/stalker
	name = "STRAIN: Lurker - Stalker"
	description = "Вы обмениваете свою способность замедляющего удара на возможность становится невидимым в режиме ходьбы на неопределённый срок."
	flavor_description = "О н о   х о ч е т   е с т ь . . ."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_LURKER)
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/activable/pounce/lurker,
		/datum/action/xeno_action/onclick/lurker_invisibility,
		/datum/action/xeno_action/onclick/lurker_assassinate,
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/pounce/lurker/stalker,
	)
	behavior_delegate_type = /datum/behavior_delegate/lurker_stalker
	keystone = TRUE

/datum/xeno_mutator/stalker/apply_mutator(datum/mutator_set/individual_mutators/mutator)
	. = ..()
	if (. == FALSE)
		return

	var/mob/living/carbon/xenomorph/lurker/lurker = mutator.xeno
	lurker.walk_speed = DEFAULT_WALK_SPEED - 2
	lurker.health_modifier += XENO_HEALTH_MOD_SMALL
	lurker.speed_modifier += XENO_SPEED_FASTMOD_TIER_1

	apply_behavior_holder(lurker)
	mutator_update_actions(lurker)
	mutator.recalculate_actions(description, flavor_description)
	lurker.recalculate_everything()
	lurker.set_movement_intent(lurker.m_intent) // lazy but it works
	lurker.mutation_icon_state = LURKER_NORMAL // replace this if you add custom sprites for this
	lurker.mutation_type = LURKER_STALKER

/datum/behavior_delegate/lurker_stalker
	name = "Stalker Lurker Behavior Delegate"

/datum/behavior_delegate/lurker_stalker/handle_movement_change(new_movement_intent)
	. = ..()
	animate(bound_xeno, alpha = new_movement_intent > MOVE_INTENT_WALK ? initial(bound_xeno.alpha) : 15, time = 0.5 SECONDS, easing = QUAD_EASING)

/datum/action/xeno_action/activable/pounce/lurker/stalker/knockdown = TRUE

/datum/action/xeno_action/activable/pounce/lurker/stalker/knockdown_duration = 1.6
