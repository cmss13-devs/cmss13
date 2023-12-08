/datum/admins/var/static/create_turf_html = null

/datum/admins/proc/create_turf(mob/user)
	if (!create_turf_html)
		var/turfjs = null
		turfjs = jointext(typesof(/turf), ";")
		create_turf_html = file2text('html/create_object.html')
		create_turf_html = replacetext(create_turf_html, "null /* object types */", "\"[turfjs]\"")
		create_turf_html = replacetext(create_turf_html, "/* href token */", RawHrefToken(forceGlobal = TRUE))

	show_browser(usr, replacetext(create_turf_html, "/* ref src */", "\ref[src]"), "Create Turf", "create_turf", "size=450x525")
