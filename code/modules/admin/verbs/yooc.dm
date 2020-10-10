/client/proc/yooc(msg as text)
	set category = "OOC"
	set name = "YOOC"
	set desc = "OOC channel for Yautja players."
	
	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only staff members may talk on this channel.")
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)

	if(!msg)
		return

	var/yooc_message = "YOOC: [src.key]([src.admin_holder.rank]): [msg]"
	log_admin(yooc_message)

	// Send to preds who are non-staff
	for(var/mob/living/carbon/human/Y in yautja_mob_list)
		if(Y.client && !Y.client.admin_holder)
			to_chat(Y, SPAN_YOOC(yooc_message))

	// Send to observers
	for(var/mob/dead/observer/O in GLOB.observer_list)
		if(O.client && !O.client.admin_holder)	// Send to observers who are non-staff
			to_chat(O, SPAN_YOOC(yooc_message))

	// Send to staff
	for(var/client/C in GLOB.admins)	// Send to staff
		if(!(C.admin_holder.rights & R_MOD))
			continue
		to_chat(C, SPAN_YOOC(yooc_message))