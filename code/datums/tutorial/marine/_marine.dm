/datum/tutorial/marine
	category = TUTORIAL_CATEGORY_MARINE

/datum/tutorial/marine/init_mob()
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

	new_character.marine_snowflake_points = MARINE_TOTAL_SNOWFLAKE_POINTS
	new_character.marine_buyable_categories = MARINE_CAN_BUY_ALL

	if(tutorial_mob.mind)
		tutorial_mob.mind_initialize()
		tutorial_mob.mind.transfer_to(new_character, TRUE)
		tutorial_mob.mind.setup_human_stats()

	INVOKE_ASYNC(new_character, TYPE_PROC_REF(/mob/living/carbon/human, regenerate_icons))
	INVOKE_ASYNC(new_character, TYPE_PROC_REF(/mob/living/carbon/human, update_body), 1, 0)
	INVOKE_ASYNC(new_character, TYPE_PROC_REF(/mob/living/carbon/human, update_hair))

	tutorial_mob = new_character
	return ..()
