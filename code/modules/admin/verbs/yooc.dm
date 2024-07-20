/client/proc/yooc(msg as text)
	set category = "OOC.OOC"
	set name = "YOOC"
	set desc = "OOC channel for Yautja players."

	if(!check_client_rights(src, R_MOD, FALSE))
		to_chat(src, "Only staff members may talk on this channel.")
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)

	if(!msg)
		return

	var/yooc_message = "YOOC: [key]([admin_holder.admin_rank.rank]): [msg]"
	log_admin(yooc_message)

	msg = process_chat_markup(msg, list("*"))

	// Send to preds who are non-staff
	for(var/mob/living/carbon/human/Y in GLOB.yautja_mob_list)
		if(Y.client && !Y.client.admin_holder)
			to_chat_spaced(Y, margin_top = 0.5, margin_bottom = 0.5, html = SPAN_YOOC(yooc_message))

	// Send to observers
	for(var/mob/dead/observer/O in GLOB.observer_list)
		if(O.client && !O.client.admin_holder) // Send to observers who are non-staff
			to_chat_spaced(O, margin_top = 0.5, margin_bottom = 0.5, html = SPAN_YOOC(yooc_message))

	// Send to staff
	for(var/client/C in GLOB.admins) // Send to staff
		if(!check_client_rights(C, R_MOD, FALSE))
			continue
		to_chat_spaced(C, margin_top = 0.5, margin_bottom = 0.5, html = SPAN_YOOC(yooc_message))
