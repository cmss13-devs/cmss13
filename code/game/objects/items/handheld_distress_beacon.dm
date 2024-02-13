
///handheld distress beacons used by goon chem retrieval team to call for PMC back up
/obj/item/handheld_distress_beacon
	name = "\improper PMC handheld distress beacon"
	desc = "A standard handheld distress beacon. Generally used by teams who may be out of regular communications range but must signal for assistance. This one is branded with a Weyland Yutani symbol and sold en masse to colonies across the Neroid Sector."
	icon = 'icons/obj/items/handheld_distress_beacon.dmi'
	icon_state = "beacon_inactive"
	w_class = SIZE_SMALL

	///The beacons faction that will be sent in message_admins
	var/beacon_type = "PMC beacon"
	///Tells the user who the beacon will be sent to IC
	var/recipient = "the USCSS Royce"
	///The name of the ERT that will be passed to get_specific_call
	var/list/ert_full_name = list("Weyland-Yutani PMC (Chemical Investigation Squad)")
	///The clickable version that will be sent in message_admins
	var/list/ert_short_name = list("SEND PMCs")
	///Whether beacon can be used, or has already been used
	var/active = FALSE

/obj/item/handheld_distress_beacon/get_examine_text(mob/user)
	. = ..()

	if(active)
		. += "The beacon has been activated!"

/obj/item/handheld_distress_beacon/update_icon()
	. = ..()

	if(active)
		icon_state = "beacon_active"
		return
	icon_state = initial(icon_state)

/obj/item/handheld_distress_beacon/attack_self(mob/user)
	. = ..()

	if(active)
		to_chat(user, "[src] is already active!")
		return
	active = TRUE
	update_icon()

	if(!ert_full_name || !ert_short_name || (length(ert_full_name) != length(ert_short_name))) //Make sure they are greater than 0, and both are same length
		to_chat(user, SPAN_BOLDWARNING("[src] is broken!"))
		CRASH("[src] was improperly set, and has been disabled.") //For the runtime logs

	var/beacon_call_buttons
	for(var/current_ert_num in 1 to length(ert_full_name))
		beacon_call_buttons += "(<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];distress_handheld=\ref[user];ert_name=[ert_full_name[current_ert_num]]'>[ert_short_name[current_ert_num]]</A>) "

	for(var/client/admin_client in GLOB.admins)
		if((R_ADMIN|R_MOD) & admin_client.admin_holder.rights)
			playsound_client(admin_client,'sound/effects/sos-morse-code.ogg',10)
	message_admins("[key_name(user)] has used a [beacon_type]! [CC_MARK(user)] [beacon_call_buttons](<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];deny_distress_handheld=\ref[user]'>DENY</A>) [ADMIN_JMP_USER(user)] [CC_REPLY(user)]")
	to_chat(user, SPAN_NOTICE("A distress beacon request has been sent to [recipient]."))

/// CMB distress beacon held by CMB Marshal for signalling distress to Anchorpoint Station
/obj/item/handheld_distress_beacon/cmb
	name = "\improper CMB handheld distress beacon"
	desc = "An emergency beacon. This one is branded with a Colonial Marshal Bureau star and 'ANCHORPOINT STATION' is etched in stencil on the side. This device is issued to CMB Marshals and features an extended relay antenna."

	beacon_type = "CMB beacon"
	recipient = "Anchorpoint Station"
	ert_full_name = list("CMB - Patrol Team - Marshals in Distress (Friendly)", "CMB - Anchorpoint Station Colonial Marine QRF (Friendly)")
	ert_short_name = list("SEND CMB", "SEND QRF")
