/datum/preferences
	var/xeno_customization_visibility

/datum/preferences/process_link(mob/user, list/href_list)
	if(href_list["preference"] == "xeno_customization_visibility")
		var/choice = tgui_input_list(user, "What is your lore preference?", "Xeno Customization Visibility", GLOB.xeno_customization_visibility_options)
		if(!choice)
			return
		xeno_customization_visibility = choice
		SEND_SIGNAL(user, COMSIG_XENO_CUSTOMIZATION_VISIBILITY)
	. = ..()
