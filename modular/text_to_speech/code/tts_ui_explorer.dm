/datum/tts_seeds_explorer
	var/name = "Эксплорер TTS голосов"
	var/phrases = TTS_PHRASES

/datum/tts_seeds_explorer/ui_state(mob/user)
	return GLOB.always_state

/datum/tts_seeds_explorer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TTSSeedsExplorer", name)
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/tts_seeds_explorer/ui_data(mob/user)
	var/list/data = list()
	data["selected_seed"] = user.client.prefs.tts_seed
	// data["donator_level"] = user.client.donator_level
	data["character_gender"] = user.client.prefs.gender

	return data

/datum/tts_seeds_explorer/ui_static_data(mob/user)
	var/list/data = list()

	var/list/providers = list()
	for(var/_provider in SStts220.tts_providers)
		var/datum/tts_provider/provider = SStts220.tts_providers[_provider]
		providers += list(list(
			"name" = provider.name,
			"is_enabled" = provider.is_enabled,
		))
	data["providers"] = providers

	var/list/seeds = list()
	for(var/_seed in SStts220.tts_seeds)
		var/datum/tts_seed/seed = SStts220.tts_seeds[_seed]
		seeds += list(list(
			"name" = seed.name,
			"value" = seed.value,
			"category" = seed.category,
			"gender" = seed.gender,
			"provider" = initial(seed.provider.name),
			// "required_donator_level" = seed.required_donator_level,
		))
	data["seeds"] = seeds
	data["phrases"] = phrases

	return data

/datum/tts_seeds_explorer/ui_act(action, list/params)
	if(..())
		return
	. = TRUE

	switch(action)
		if("listen")
			var/phrase = params["phrase"]
			var/seed_name = params["seed"]

			if(!(phrase in phrases))
				return
			if(!(seed_name in SStts220.tts_seeds))
				return

			INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(tts_cast), null, usr, phrase, SStts220.tts_seeds[seed_name], FALSE)
		if("select_voice")
			var/seed_name = params["seed"]

			if(!(seed_name in SStts220.tts_seeds))
				return
			// var/datum/tts_seed/seed = SStts220.tts_seeds[seed_name]
			// if(usr.client.donator_level < seed.required_donator_level)
			// 	return

			usr.client.prefs.tts_seed = seed_name
		else
			return FALSE
