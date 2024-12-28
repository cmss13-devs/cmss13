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
	return pick('sound/voice/growl1.ogg','sound/voice/growl2.ogg','sound/voice/growl3.ogg','sound/voice/growl4.ogg')
