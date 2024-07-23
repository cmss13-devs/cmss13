/datum/emote/living/carbon/human/spit
	key = "spit"
	key_third_person = "spits"
	message = "spits on something."
	alt_message = "spits"
	sound = 'core_ru/sound/misc/spitemote.ogg'
	cooldown = 5 SECONDS
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/laugh/get_sound(mob/living/user)
	if(ishumansynth_strict(user))
		if(user.gender == MALE)
			return pick('core_ru/sound/voice/human_male_laugh_1.ogg', 'core_ru/sound/voice/human_male_laugh_2.ogg')
		else
			return pick('core_ru/sound/voice/human_female_laugh_1.ogg', 'core_ru/sound/voice/human_female_laugh_2.ogg')

/datum/emote/living/carbon/human/warcry/get_sound(mob/living/user)
	var/default_lang = user.get_default_language()
	if(ishumansynth_strict(user))
		if(user.gender == MALE)
			if(default_lang == GLOB.all_languages[LANGUAGE_RUSSIAN])
				return get_sfx("male_upp_warcry")
			else
				return get_sfx("male_warcry")
		if(user.gender == FEMALE)
			if(default_lang == GLOB.all_languages[LANGUAGE_RUSSIAN])
				return get_sfx("female_upp_warcry")
			else
				return get_sfx("female_warcry")
