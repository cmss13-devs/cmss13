/datum/admins/proc/create_custom_xeno(var/mob/user)
	var/datum/gene_tailor/new_panel = new
	new_panel.tgui_interact(user)
