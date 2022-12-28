GLOBAL_VAR(create_mob_html)

/datum/admins/proc/create_mob(var/mob/user)
	if (!GLOB.create_mob_html)
		var/mobjs = null
		mobjs = jointext(typesof(/mob), ";")
		GLOB.create_mob_html = file2text('html/create_object.html')
		GLOB.create_mob_html = replacetext(GLOB.create_mob_html, "null /* object types */", "\"[mobjs]\"")
		GLOB.create_mob_html = replacetext(GLOB.create_mob_html, "/* href token */", RawHrefToken(forceGlobal = TRUE))

	show_browser(user, replacetext(GLOB.create_mob_html, "/* ref src */", "\ref[src]"), "Create Mob", "create_mob", "size=425x475")
