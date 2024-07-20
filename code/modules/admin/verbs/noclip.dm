/client/proc/toggle_noclip()
	set name = "Toggle Noclip"
	set category = "Admin.Fun"

	if(!check_rights(R_MOD))
		return

	if(!mob)
		return

	mob.noclip = !mob.noclip
	var/msg = "[key_name(src)] has toggled noclip [mob.noclip? "on" : "off"]."
	message_admins(msg)
	log_admin(msg)

