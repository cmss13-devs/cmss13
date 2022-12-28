GLOBAL_VAR(create_turf_html)
/datum/admins/proc/create_turf(var/mob/user)
	if (!GLOB.create_turf_html)
		var/turfjs = null
		turfjs = jointext(typesof(/turf), ";")
		GLOB.create_turf_html = file2text('html/create_object.html')
		GLOB.create_turf_html = replacetext(GLOB.create_turf_html, "null /* object types */", "\"[turfjs]\"")
		GLOB.create_turf_html = replacetext(GLOB.create_turf_html, "/* href token */", RawHrefToken(forceGlobal = TRUE))

	show_browser(usr, replacetext(GLOB.create_turf_html, "/* ref src */", "\ref[src]"), "Create Turf", "create_turf", "size=425x475")
