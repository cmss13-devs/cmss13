/datum/tutorial/xenomorph
	category = TUTORIAL_CATEGORY_XENO
	parent_path = /datum/tutorial/xenomorph
	icon_state = "xeno" // CHANGE
	///Starting xenomorph type (caste) of type /mob/living/carbon/xenomorph/...
	var/mob/living/carbon/xenomorph/starting_xenomorph_type = /mob/living/carbon/xenomorph/drone
	///Reference to the actual xenomorph mob
	var/mob/living/carbon/xenomorph/xeno

/datum/tutorial/xenomorph/init_mob()
	var/mob/living/carbon/xenomorph/new_character = new starting_xenomorph_type(bottom_left_corner, null, XENO_HIVE_TUTORIAL)
	new_character.lastarea = get_area(bottom_left_corner)

	//Remove all actions by default, we will give actions to the player when needed.
	for(var/datum/action/action_path as anything in new_character.base_actions)
		remove_action(new_character, action_path)

	setup_xenomorph(new_character, tutorial_mob, is_late_join = FALSE) // What do we need to do here

	// We don't want people talking to other xenomorphs across tutorials
	new_character.can_hivemind_speak = FALSE

	tutorial_mob = new_character
	xeno = new_character
	RegisterSignal(tutorial_mob, COMSIG_LIVING_GHOSTED, PROC_REF(on_ghost))
	RegisterSignal(tutorial_mob, list(COMSIG_PARENT_QDELETING, COMSIG_MOB_DEATH, COMSIG_MOB_END_TUTORIAL), PROC_REF(signal_end_tutorial))
	RegisterSignal(tutorial_mob, COMSIG_MOB_LOGOUT, PROC_REF(on_logout))
	return ..()
