/client/proc/toggle_noclip()
	set name = "A: Toggle Noclip"
	set category = "Admin"

	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	if(!mob)
		return

	mob.noclip = !mob.noclip
	var/msg = "[key_name(src)] has toggled noclip [mob.noclip? "on" : "off"]."
	message_admins(msg)
	log_admin(msg)

