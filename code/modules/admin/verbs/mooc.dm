/client/proc/mooc(msg as text)
	set category = "OOC"
	set name = "MOOC"
	
	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only staff members may talk on this channel.")
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)

	if(!msg)
		return

	log_admin("MOOC: [key_name(src)]: [msg]")

	for(var/mob/M in living_human_list)
		if(M.client && (!M.client.admin_holder || !(M.client.admin_holder.rights & R_MOD)))	// Send to marines who are non-staff
			to_chat(M, SPAN_MOOC("MOOC: [src.key]([src.admin_holder.rank]): [msg]"))

	var/list/synthetics = getsynths()
	for(var/mob/M in synthetics)
		if(M.client && !M.client.admin_holder)
			to_chat(M, SPAN_MOOC("MOOC: [src.key]([src.admin_holder.rank]): [msg]"))

	for(var/mob/dead/observer/M in GLOB.observer_list)
		if(M.client && !M.client.admin_holder)	// Send to observers who are non-staff
			to_chat(M, SPAN_MOOC("MOOC: [src.key]([src.admin_holder.rank]): [msg]"))

	for(var/client/C in GLOB.admins)	// Send to staff
		if(!(C.admin_holder.rights & R_MOD))
			continue
		to_chat(C, SPAN_MOOC("MOOC: [src.key]([src.admin_holder.rank]): [msg]"))

