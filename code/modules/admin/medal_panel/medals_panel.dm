/client/proc/cmd_admin_medals_panel()
	set name = "Medals Panel"
	set category = "Admin.Panels"

	if(!check_rights(R_MOD))
		return

	GLOB.medals_panel.tgui_interact(mob)
