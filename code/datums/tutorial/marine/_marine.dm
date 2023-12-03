/datum/tutorial/marine
	category = TUTORIAL_CATEGORY_MARINE
	parent_path = /datum/tutorial/marine
	icon_state = "marine"

/datum/tutorial/marine/init_mob()
	var/mob/living/carbon/human/new_character = new(bottom_left_corner)
	new_character.lastarea = get_area(bottom_left_corner)

	setup_human(new_character, tutorial_mob)

	//SSround_recording.recorder.track_player(new_character) //zonenote: check if necessary

	new_character.marine_snowflake_points = MARINE_TOTAL_SNOWFLAKE_POINTS
	new_character.marine_buyable_categories = MARINE_CAN_BUY_ALL

	tutorial_mob = new_character
	RegisterSignal(tutorial_mob, COMSIG_LIVING_GHOSTED, PROC_REF(on_ghost))
	RegisterSignal(tutorial_mob, list(COMSIG_PARENT_QDELETING, COMSIG_MOB_DEATH, COMSIG_MOB_END_TUTORIAL), PROC_REF(signal_end_tutorial))
	RegisterSignal(tutorial_mob, COMSIG_MOB_LOGOUT, PROC_REF(on_logout))
	return ..()
