/// Test that all emotes for Working Joes & Yautja have a category
/datum/unit_test/emote_panels

/datum/unit_test/emote_panels/Run()
	for(var/datum/emote/living/carbon/human/synthetic/working_joe/wj_emote as anything in subtypesof(/datum/emote/living/carbon/human/synthetic/working_joe))
		if(!initial(wj_emote.category))
			TEST_FAIL("Emote [wj_emote] did not have a category!")

	for(var/datum/emote/living/carbon/human/yautja/yautja_emote as anything in subtypesof(/datum/emote/living/carbon/human/yautja))
		if(!initial(yautja_emote.category))
			TEST_FAIL("Emote [yautja_emote] did not have a category!")
