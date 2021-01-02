/client/proc/toggle_noclip()
	set name = "Toggle Noclip"
	set category = "Admin.Fun"

	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	if(!mob)
		return

	mob.noclip = !mob.noclip
	var/msg = "[key_name(src)] has toggled noclip [mob.noclip? "on" : "off"]."
	message_staff(msg)
	log_admin(msg)

