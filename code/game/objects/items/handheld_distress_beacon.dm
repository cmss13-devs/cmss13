
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

 // CMB distress beacon held by CMB Marshal for signalling distress to Anchorpoint Station
/obj/item/handheld_distress_beacon_CMB
	name = "CMB handheld distress beacon"
	desc = "An emergency beacon. This one is branded with a Colonial Marshal Bureau star and 'ANCHORPOINT STATION' is etched in stencil on the side. This device is issued to CMB Marshals and features an extended relay antenna."
	icon = 'icons/obj/items/handheld_distress_beacon.dmi'
	icon_state = "beacon_inactive"
	w_class = SIZE_SMALL

	var/active = FALSE

/obj/item/handheld_distress_beacon_CMB/get_examine_text(mob/user)
	. = ..()

	if(active)
		. += "The beacon has been activated!"

/obj/item/handheld_distress_beacon_CMB/update_icon()
	. = ..()

	if(active)
		icon_state = "beacon_active"
	else
		icon_state = initial(icon_state)

/obj/item/handheld_distress_beacon_CMB/attack_self(mob/user)
	. = ..()

	if(active)
		to_chat(user, "[src] is already active!")
		return

	for(var/client/C in GLOB.admins)
		if((R_ADMIN|R_MOD) & C.admin_holder.rights)
			playsound_client(C,'sound/effects/sos-morse-code.ogg',10)
	message_admins("[key_name(user)] has signalled CMB in distress, and requests reinforcements! [CC_MARK(user)] (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];distress_cmb=\ref[user]'>SEND MARINE QRF</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];distress_cmb_alt=\ref[user]'>SEND CMB TEAM</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];deny_cmb=\ref[user]'>DENY</A>) [ADMIN_JMP_USER(user)] [CC_REPLY(user)]")
	to_chat(user, SPAN_NOTICE("The CMB distress beacon flashes red, indicating that the device has been activated and is transmitting."))

	active = TRUE
	update_icon()
