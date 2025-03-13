/datum/preferences
	var/screentips = TRUE

/datum/preferences/process_link(mob/user, list/href_list)
	if(href_list["preference"] == "screentips")
		screentips = !screentips
		user?.hud_used?.screentips_enabled = screentips
	. = ..()
