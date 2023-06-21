
///handheld distress beacons used by goon chem retrieval team to call for PMC back up
/obj/item/handheld_distress_beacon
	name = "handheld distress beacon"
	desc = "A standard handheld distress beacon. Generally used by teams who may be out of regular communications range but must signal for assistance. This one is branded with a Weyland Yutani symbol and sold en masse to colonies across the Neroid Sector."
	icon = 'icons/obj/items/handheld_distress_beacon.dmi'
	icon_state = "beacon_inactive"
	w_class = SIZE_SMALL

	var/active = FALSE

/obj/item/handheld_distress_beacon/get_examine_text(mob/user)
	. = ..()

	if(active)
		. += "The beacon has been activated!"

/obj/item/handheld_distress_beacon/update_icon()
	. = ..()

	if(active)
		icon_state = "beacon_active"
	else
		icon_state = initial(icon_state)

/obj/item/handheld_distress_beacon/attack_self(mob/user)
	. = ..()

	if(active)
		to_chat(user, "[src] is already active!")
		return

	for(var/client/C in GLOB.admins)
		if((R_ADMIN|R_MOD) & C.admin_holder.rights)
			playsound_client(C,'sound/effects/sos-morse-code.ogg',10)
	message_admins("[key_name(user)] has requested a PMC Distress Beacon! [CC_MARK(user)] (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];distress_pmc=\ref[user]'>SEND</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];ccdeny_pmc=\ref[user]'>DENY</A>) [ADMIN_JMP_USER(user)] [CC_REPLY(user)]")
	to_chat(user, SPAN_NOTICE("A distress beacon request has been sent to the USCSS Royce."))

	active = TRUE
	update_icon()
