/datum/xeno_strain/boxer
	name = WARRIOR_BOXER
	description = "Abandon your abilities, in exchance with every blow, you gain stacks that increase your range, durability, and unleash devastating finishers to dominate close combat."
	flavor_description = "A flurry of punches, unstoppable and unyielding."
	icon_state_prefix = "boxer"

	actions_to_remove = list(

	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/hook,
		/datum/action/xeno_action/onclick/ironhide,
		/datum/action/xeno_action/activable/uppercut
	)

	behavior_delegate_type = /datum/behavior_delegate/warrior_boxer

/datum/xeno_strain/boxer/apply_strain(mob/living/carbon/xenomorph/warrior/warrior)

	warrior.health_modifier += XENO_HEALTH_MOD_VERY_LARGE / 2
	warrior.plasma_max = 0
	warrior.recalculate_everything()

/datum/behavior_delegate/warrior_boxer

	var/focus = 0
	var/max_focus = 10
	var/focus_decay_time = 5 SECONDS
	var/last_attack_time

/datum/behavior_delegate/warrior_boxer/melee_attack_additional_effects_self()
	last_attack_time = world.time
	gain_focus()

/datum/behavior_delegate/warrior_boxer/on_life()
	//we quickly focus if we are out of combat
	if (((last_attack_time + focus_decay_time) < world.time) && !(focus <= 0))
		lose_focus()

/datum/behavior_delegate/warrior_boxer/proc/lose_focus(amount = 2)
	focus = max(0, focus - amount)

/datum/behavior_delegate/warrior_boxer/proc/gain_focus(amount = 1)
	last_attack_time = world.time
	if(focus < max_focus)
		focus += amount

/datum/behavior_delegate/warrior_boxer/append_to_stat()
	. = list()
	. += "Focus: [focus]/[max_focus]"
