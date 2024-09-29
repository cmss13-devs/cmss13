/client/proc/cmd_admin_tacmaps_panel()
	set name = "Tacmaps Panel"
	set category = "Admin.Panels"

	if(!check_rights(R_ADMIN|R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	GLOB.tacmap_admin_panel.tgui_interact(mob)
