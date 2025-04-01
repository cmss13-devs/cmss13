/datum/tutorial/ss13
	category = TUTORIAL_CATEGORY_SS13
	parent_path = /datum/tutorial/ss13
	icon_state = "ss13"

/datum/tutorial/ss13/init_mob()
	tutorial_mob.close_spawn_windows()

	var/mob/living/carbon/human/new_character = new(bottom_left_corner)
	new_character.lastarea = get_area(bottom_left_corner)

	tutorial_mob.client.prefs.copy_all_to(new_character)

	if(tutorial_mob.client.prefs.be_random_body)
		var/datum/preferences/rand_prefs = new()
		rand_prefs.randomize_appearance(new_character)

	new_character.job = tutorial_mob.job
	new_character.name = tutorial_mob.real_name
	new_character.voice = tutorial_mob.real_name

	new_character.sec_hud_set_ID()
	new_character.hud_set_squad()

	SSround_recording.recorder.track_player(new_character)

	if(tutorial_mob.mind)
		tutorial_mob.mind_initialize()
		tutorial_mob.mind.transfer_to(new_character, TRUE)
		tutorial_mob.mind.setup_human_stats()

	INVOKE_ASYNC(new_character, TYPE_PROC_REF(/mob/living/carbon/human, regenerate_icons))
	INVOKE_ASYNC(new_character, TYPE_PROC_REF(/mob/living/carbon/human, update_body), 1, 0)
	INVOKE_ASYNC(new_character, TYPE_PROC_REF(/mob/living/carbon/human, update_hair))

	tutorial_mob = new_character
	RegisterSignal(tutorial_mob, COMSIG_LIVING_GHOSTED, PROC_REF(on_ghost))
	RegisterSignal(tutorial_mob, list(COMSIG_PARENT_QDELETING, COMSIG_MOB_DEATH, COMSIG_MOB_END_TUTORIAL), PROC_REF(signal_end_tutorial))
	RegisterSignal(tutorial_mob, COMSIG_MOB_LOGOUT, PROC_REF(on_logout))
	arm_equipment(tutorial_mob, /datum/equipment_preset/tutorial/fed)
	return ..()
