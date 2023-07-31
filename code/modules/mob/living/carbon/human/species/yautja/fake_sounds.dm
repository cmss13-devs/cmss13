/datum/emote/living/carbon/human/yautja/fake_sound
	category = YAUTJA_EMOTE_CATEGORY_FAKESOUND

/datum/emote/living/carbon/human/yautja/fake_sound/aliengrowl
	key = "aliengrowl"

/datum/emote/living/carbon/human/yautja/fake_sound/aliengrowl/get_sound(mob/living/user)
	return pick('sound/voice/alien_growl1.ogg', 'sound/voice/alien_growl2.ogg')

/datum/emote/living/carbon/human/yautja/fake_sound/alienhelp
	key = "alienhelp"

/datum/emote/living/carbon/human/yautja/fake_sound/alienhelp/get_sound(mob/living/user)
	return pick('sound/voice/alien_help1.ogg', 'sound/voice/alien_help2.ogg')

/datum/emote/living/carbon/human/yautja/fake_sound/malescream
	key = "malescream"
	sound = "male_scream"

/datum/emote/living/carbon/human/yautja/fake_sound/femalescream
	key = "femalescream"
	sound = "female_scream"
