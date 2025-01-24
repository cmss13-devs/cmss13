/datum/preferences
	var/datum/tts_seed/tts_seed // and used in preferences_savefile

/datum/preferences/copy_appearance_to(mob/living/carbon/human/character, safety = 0)
	. = ..()
	if(tts_seed)
		var/datum/tts_seed/new_tts_seed = SStts220.tts_seeds[tts_seed]
		character.AddComponent(/datum/component/tts_component, new_tts_seed)
		character.tts_seed = new_tts_seed

/datum/preferences/copy_all_to(mob/living/carbon/human/character, job_title, is_late_join = FALSE, check_datacore = FALSE)
	. = ..()
	if(tts_seed)
		var/datum/tts_seed/new_tts_seed = SStts220.tts_seeds[tts_seed]
		character.AddComponent(/datum/component/tts_component, new_tts_seed)
		character.tts_seed = new_tts_seed

/mob/new_player/proc/check_tts_seed_ready()
	if((SStts220.is_enabled))
		if(!client.prefs.tts_seed)
			to_chat(usr, span_danger("Вам необходимо настроить голос персонажа! Не забудьте сохранить настройки."))
			client.prefs.ShowChoices(src)
			return FALSE
		var/datum/tts_seed/seed = SStts220.tts_seeds[client.prefs.tts_seed]
		if(!seed)
			to_chat(usr, span_danger("Выбранный голос персонажа недоступен!"))
			client.prefs.ShowChoices(src)
			return FALSE

		/*
		switch(client.donator_level)
			if(LITTLE_WORKER_TIER)
				if(LITTLE_WORKER_TTS_LEVEL >= seed.required_donator_level)
					return TRUE
			if(BIG_WORKER_TIER)
				if(BIG_WORKER_TTS_LEVEL >= seed.required_donator_level)
					return TRUE

		if(client.donator_level < seed.required_donator_level || client.donator_level > DONATOR_LEVEL_MAX)
			to_chat(usr, span_danger("Выбранный голос персонажа более недоступен на текущем уровне подписки!"))
			client.prefs.ShowChoices(src)
			return FALSE
		*/
	return TRUE
