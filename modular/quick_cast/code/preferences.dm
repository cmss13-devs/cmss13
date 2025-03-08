/datum/preferences
	var/quick_cast

/datum/preferences/process_link(mob/user, list/href_list)
	if(href_list["preference"] == "quick_cast")
		quick_cast = !quick_cast
	. = ..()
