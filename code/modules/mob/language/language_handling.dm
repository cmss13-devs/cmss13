/mob/proc/add_language(language)
	var/datum/language/new_language = GLOB.all_languages[language]

	if(!istype(new_language) || (new_language in languages))
		return 0

	languages.Add(new_language)
	return 1

/mob/proc/set_languages(list/new_languages)
	languages = list()
	for(var/language in new_languages)
		add_language(language)


/mob/proc/remove_language(rem_language)
	languages.Remove(GLOB.all_languages[rem_language])
	return 0

/mob/proc/get_default_language()
	if (length(languages) > 0)
		return languages[1]
	return null

// Can we speak this language, as opposed to just understanding it?
/mob/proc/can_speak(datum/language/speaking)
	return (universal_speak || (speaking in src.languages))

/mob/verb/check_languages()
	set name = "Check Known Languages"
	set category = "IC"
	set src = usr

	if(!mob_language_menu)
		create_language_menu()

	mob_language_menu.tgui_interact(src)

/datum/language_menu
	var/mob/target_mob

/datum/language_menu/New(mob/target)
	. = ..()
	target_mob = target

/datum/language_menu/Destroy(force, ...)
	target_mob = null

	SStgui.close_uis(src)
	return ..()

/datum/language_menu/tgui_interact(mob/user, datum/tgui/ui)
	if(!target_mob)
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "LanguageMenu", "Language Menu")
		ui.open()

/datum/language_menu/ui_data(mob/user)
	var/list/data = list()

	var/list/languagedata = list()

	for(var/datum/language/L as anything in target_mob.languages)
		languagedata += list(list(
			"name" = L.name,
			"desc" = L.desc,
			"key" = L.key
		))

	data["languages"] = languagedata

	return data

/datum/language_menu/ui_state(mob/user)
	return GLOB.always_state

/datum/language_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("set_default_language")
			var/index = 1
			for(var/datum/language/L as anything in target_mob.languages)
				if(L.key == params["key"])
					var/language_holder = target_mob.languages[1]
					target_mob.languages[1] = L
					target_mob.languages[index] = language_holder
					break
				index++
			. = TRUE
