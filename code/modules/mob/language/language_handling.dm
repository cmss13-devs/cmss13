/mob/proc/add_language(var/language)
	var/datum/language/new_language = GLOB.all_languages[language]

	if(!istype(new_language) || (new_language in languages))
		return 0

	languages.Add(new_language)
	return 1

/mob/proc/set_languages(var/list/new_languages)
	languages = list()
	for(var/language in new_languages)
		add_language(language)


/mob/proc/remove_language(var/rem_language)
	languages.Remove(GLOB.all_languages[rem_language])
	return 0

/mob/proc/get_default_language()
	if (languages.len > 0)
		return languages[1]
	return null

// Can we speak this language, as opposed to just understanding it?
/mob/proc/can_speak(datum/language/speaking)
	return (universal_speak || (speaking in src.languages))

/mob/verb/check_languages()
	set name = "Check Known Languages"
	set category = "IC"
	set src = usr

	var/dat

	for(var/datum/language/L in languages)
		dat += "<b>[L.name] (:[L.key])</b><br/>[L.desc]<br/><br/>"

	show_browser(src, dat, "Known Languages", "checklanguage")
	return
