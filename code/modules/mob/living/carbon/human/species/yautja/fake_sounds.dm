/datum/emote/living/carbon/human/yautja/fake_sound
	category = YAUTJA_EMOTE_CATEGORY_FAKESOUND

/datum/emote/living/carbon/human/yautja/fake_sound/aliengrowl
	override_say = "Xenomorph growl"
	key = "aliengrowl"

/datum/emote/living/carbon/human/yautja/fake_sound/aliengrowl/get_sound(mob/living/user)
	return pick('sound/voice/alien_growl1.ogg', 'sound/voice/alien_growl2.ogg')

/datum/emote/living/carbon/human/yautja/fake_sound/alienhelp
	override_say = "Xenomorph needs help"
	key = "alienhelp"

/datum/emote/living/carbon/human/yautja/fake_sound/alienhelp/get_sound(mob/living/user)
	return pick('sound/voice/alien_help1.ogg', 'sound/voice/alien_help2.ogg')

/datum/emote/living/carbon/human/yautja/fake_sound/malescream
	override_say = "Human scream (male)"
	key = "malescream"
	sound = "male_scream"

/datum/emote/living/carbon/human/yautja/fake_sound/femalescream
	override_say = "Human scream (female)"
	key = "femalescream"
	sound = "female_scream"
