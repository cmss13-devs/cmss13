/client/proc/mooc(msg as text)
	set category = "OOC.OOC"
	set name = "MOOC"

	if(!check_rights(R_MOD))
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)

	if(!msg)
		return

	log_admin("MOOC: [key_name(src)]: [msg]")

	msg = process_chat_markup(msg, list("*"))

	for(var/i in GLOB.alive_human_list)
		var/mob/M = i
		if(!check_client_rights(M.client, R_MOD, FALSE)) // Send to marines who are non-staff
			to_chat_spaced(M, margin_top = 0.5, margin_bottom = 0.5, html = SPAN_MOOC("MOOC: [src.key]([src.admin_holder.admin_rank.rank]): [msg]"))

	for(var/mob/M in GLOB.human_mob_list)
		if(issynth(M) && M.client && !M.client.admin_holder)
			to_chat_spaced(M, margin_top = 0.5, margin_bottom = 0.5, html = SPAN_MOOC("MOOC: [src.key]([src.admin_holder.admin_rank.rank]): [msg]"))

	for(var/mob/dead/observer/M in GLOB.observer_list)
		if(M.client && !M.client.admin_holder) // Send to observers who are non-staff
			to_chat_spaced(M, margin_top = 0.5, margin_bottom = 0.5, html = SPAN_MOOC("MOOC: [src.key]([src.admin_holder.admin_rank.rank]): [msg]"))

	for(var/client/C in GLOB.admins) // Send to staff
		if(!check_client_rights(C, R_MOD, FALSE))
			continue
		to_chat_spaced(C, margin_top = 0.5, margin_bottom = 0.5, html = SPAN_MOOC("MOOC: [src.key]([src.admin_holder.admin_rank.rank]): [msg]"))

