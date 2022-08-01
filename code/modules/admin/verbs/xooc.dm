/client/proc/xooc(msg as text)
	set category = "OOC.OOC"
	set name = "XOOC"

	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only staff members may talk on this channel.")
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)

	if(!msg)
		return

	log_admin("XOOC: [key_name(src)] : [msg]")

	msg = process_chat_markup(msg, list("*"))

	for(var/mob/living/carbon/M in GLOB.alive_mob_list)
		if(M.client && M.hivenumber && (!M.client.admin_holder || !(M.client.admin_holder.rights & R_MOD)))	// Send to xenos who are non-staff
			to_chat(M, SPAN_XOOC("XOOC: [src.key]([src.admin_holder.rank]): [msg]"))

	for(var/mob/dead/observer/M in GLOB.observer_list)
		if(M.client && !M.client.admin_holder)	// Send to observers who are non-staff
			to_chat(M, SPAN_XOOC("XOOC: [src.key]([src.admin_holder.rank]): [msg]"))

	for(var/client/C in GLOB.admins)	// Send to staff
		if(!(C.admin_holder.rights & R_MOD))
			continue

		to_chat_spaced(C, margin_top = 0.5, margin_bottom = 0.5, html = SPAN_XOOC("XOOC: [src.key]([src.admin_holder.rank]): [msg]"))
