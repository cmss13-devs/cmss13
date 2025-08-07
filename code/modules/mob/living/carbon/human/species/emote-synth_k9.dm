/datum/emote/living/carbon/human/synthetic/synth_k9/New()  //K9's are blacklisted from human emotes on emote.dm, we need to not block the new emotes below
	. = ..()

//Synth K9 Emotes
/datum/emote/living/carbon/human/synthetic/synth_k9
	species_type_allowed_typecache = list(/datum/species/synthetic/synth_k9)
	species_type_blacklist_typecache = list()
	keybind_category = CATEGORY_SYNTH_EMOTE
	volume = 75

//Standard Bark
/datum/emote/living/carbon/human/synthetic/synth_k9/bark
	key = "bark"
	key_third_person = "barks"
	message = "barks."
	audio_cooldown = 3 SECONDS
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/synth_k9/bark/get_sound(mob/living/user)
	return pick('sound/voice/barkstrong1.ogg','sound/voice/barkstrong2.ogg','sound/voice/barkstrong3.ogg')

//Threatening Growl
/datum/emote/living/carbon/human/synthetic/synth_k9/growl
	key = "growl"
	key_third_person = "growls"
	message = "growls."
	audio_cooldown = 3 SECONDS
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/synth_k9/growl/get_sound(mob/living/user)
	return pick('sound/voice/doggrowl1.ogg','sound/voice/doggrowl2.ogg','sound/voice/doggrowl3.ogg')

//Plaintive Whine
/datum/emote/living/carbon/human/synthetic/synth_k9/whine
	key = "whine"
	key_third_person = "whines"
	message = "whines."
	audio_cooldown = 3 SECONDS
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/synth_k9/whine/get_sound(mob/living/user)
	return pick('sound/voice/dogwhine1.ogg','sound/voice/dogwhine2.ogg','sound/voice/dogwhine3.ogg')

//Wagging Tail
/datum/emote/living/carbon/human/synthetic/synth_k9/tail
	key = "tail"
	key_third_person = "wags their tail"
	message = "wags their tail."
	emote_type = EMOTE_VISIBLE
