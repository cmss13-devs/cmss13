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

	var/index = 1
	for(var/datum/language/L as anything in languages)
		dat += "<b>[L.name] (:[L.key])</b> ([index  == 1 ? "<b>Default Language</b>" : "<A href='?src=\ref[src];set_default_language=[L.key]'>Set As Default</A>"])<br/>[L.desc]<br/><br/>"
		index++

	show_browser(src, dat, "Known Languages", "checklanguage")

/mob/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(href_list["set_default_language"])
		var/index = 1
		for(var/datum/language/L as anything in languages)
			if(L.key == href_list["set_default_language"])
				var/language_holder = languages[1]
				languages[1] = L
				languages[index] = language_holder
				break
			index++
		to_chat(src, SPAN_NOTICE("Your default language is now: <b>[languages[1].name]</b>"))
		check_languages()
