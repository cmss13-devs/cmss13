/client/proc/xooc(msg as text)
	set category = "OOC.OOC"
	set name = "XOOC"

	if(!check_rights(R_MOD))
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)

	if(!msg)
		return

	log_admin("XOOC: [key_name(src)] : [msg]")

	msg = process_chat_markup(msg, list("*"))

	for(var/mob/living/carbon/M in GLOB.alive_mob_list)
		if(M.client && M.hivenumber && !check_client_rights(M.client, R_MOD, FALSE)) // Send to xenos who are non-staff
			to_chat(M, SPAN_XOOC("XOOC: [key]([admin_holder.admin_rank.rank]): [msg]"))

	for(var/mob/dead/observer/M in GLOB.observer_list)
		if(M.client && !M.client.admin_holder) // Send to observers who are non-staff
			to_chat(M, SPAN_XOOC("XOOC: [key]([admin_holder.admin_rank.rank]): [msg]"))

	for(var/client/C in GLOB.admins) // Send to staff
		if(!check_client_rights(C, R_MOD, FALSE))
			continue

		to_chat_spaced(C, margin_top = 0.5, margin_bottom = 0.5, html = SPAN_XOOC("XOOC: [key]([admin_holder.admin_rank.rank]): [msg]"))
