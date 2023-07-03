/// Test that all working joe emotes have a category
/datum/unit_test/wj_emotes

/datum/unit_test/wj_emotes/Run()
	for(var/datum/emote/living/carbon/human/synthetic/working_joe/emote as anything in subtypesof(/datum/emote/living/carbon/human/synthetic/working_joe))
		if(!initial(emote.category))
			TEST_FAIL("Emote [emote] did not have a category!")
