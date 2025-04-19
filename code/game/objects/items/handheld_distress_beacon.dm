
///handheld distress beacons used by goon chem retrieval team to call for PMC back up
/obj/item/handheld_distress_beacon
	name = "\improper PMC handheld distress beacon"
	desc = "A standard handheld distress beacon. Generally used by teams who may be out of regular communications range but must signal for assistance. This one is branded with a Weyland Yutani symbol and sold en masse to colonies across the Neroid Sector."
	icon = 'icons/obj/items/devices.dmi'
	icon_state = "beacon_inactive"
	w_class = SIZE_SMALL

	///The beacons faction that will be sent in message_admins
	var/beacon_type = "PMC beacon"
	///Tells the user who the beacon will be sent to IC
	var/recipient = "the USCSS Royce"
	///The name of the ERT that will be passed to get_specific_call
	var/list/ert_paths = list(/datum/emergency_call/pmc/chem_retrieval) // "Weyland-Yutani PMC (Chemical Investigation Squad)"
	///The clickable version that will be sent in message_admins
	var/list/ert_short_names = list("SEND PMCs")
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
		return FALSE
	var/reason = tgui_input_text(user, "What is the reason for activating this beacon?", "Distress Reason")
	if(!reason)
		return FALSE

	active = TRUE
	update_icon()

	if(!ert_paths || !ert_short_names || (length(ert_paths) != length(ert_short_names))) //Make sure they are greater than 0, and both are same length
		to_chat(user, SPAN_BOLDWARNING("[src] is broken!"))
		CRASH("[src] was improperly set, and has been disabled.") //For the runtime logs

	var/beacon_call_buttons
	for(var/current_ert_num in 1 to length(ert_paths))
		beacon_call_buttons += "(<A href='byond://?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];distress_handheld=\ref[user];ert_name=[ert_paths[current_ert_num]]'>[ert_short_names[current_ert_num]]</A>) "

	for(var/client/admin_client in GLOB.admins)
		if((R_ADMIN|R_MOD) & admin_client.admin_holder.rights)
			playsound_client(admin_client,'sound/effects/sos-morse-code.ogg', 10)
	message_admins("[key_name(user)] has used a [beacon_type] for the reason '[SPAN_ORANGE(reason)]'! [CC_MARK(user)] [beacon_call_buttons](<A href='byond://?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];deny_distress_handheld=\ref[user]'>DENY</A>) [ADMIN_JMP_USER(user)] [CC_REPLY(user)]")
	to_chat(user, SPAN_NOTICE("A distress beacon request has been sent to [recipient]."))

/// CMB distress beacon held by CMB Marshal for signalling distress to Anchorpoint Station
/obj/item/handheld_distress_beacon/cmb
	name = "\improper CMB handheld distress beacon"
	desc = "An emergency beacon. This one is branded with a Colonial Marshal Bureau star and 'ANCHORPOINT STATION' is etched in stencil on the side. This device is issued to CMB Marshals and features an extended relay antenna."

	beacon_type = "CMB beacon"
	recipient = "Anchorpoint Station"
	// "CMB - Patrol Team - Marshals in Distress (Friendly)", "CMB - Anchorpoint Station Colonial Marine QRF (Friendly)", "CMB - Riot Control Unit - Marshals in Distress (Friendly)"
	ert_paths = list(/datum/emergency_call/cmb/alt, /datum/emergency_call/cmb/anchorpoint, /datum/emergency_call/cmb/riot_control/alt)
	ert_short_names = list("SEND CMB", "SEND QRF", "SEND CMB RIOT")

// Corporate Lawyer beacon available for 50 points at the CLs briefcase
/obj/item/handheld_distress_beacon/lawyer
	name = "\improper Corporate Affairs Division handheld beacon"
	desc = "An encoded beacon. This one is branded with the Weyland-Yutani slogan, 'Building Better Worlds since 2099'. Etched in stencil on the side is 'FOR CONTRACT BREAKERS ONLY'. This one is branded with the Corporate Affairs Division symbol and provided to most Executives situated in UA or TWE space."

	beacon_type = "Lawyer beacon"
	recipient = "the Corporate Affairs Division"
	ert_paths = list(/datum/emergency_call/inspection_wy/lawyer) // "Lawyers - Corporate"
	ert_short_names = list("SEND LAWYERS")

// Corporate Security Bodyguard beacon available for 50 points at the CLs briefcase
/obj/item/handheld_distress_beacon/bodyguard
	name = "\improper Corporate Security Division handheld beacon"
	desc = "An standard Corporate Security beacon. This one is branded with the Weyland-Yutani slogan, 'Building Better Worlds since 2099'. This one is branded with the Corporate Security Division symbol and provided to Executives stationed in very dangerous sites across the entire Galaxy."

	beacon_type = "Bodyguard beacon"
	recipient = "the Corporate Security Division"
	ert_paths = list(/datum/emergency_call/wy_bodyguard, /datum/emergency_call/wy_bodyguard/goon, /datum/emergency_call/wy_bodyguard/pmc/sec, /datum/emergency_call/wy_bodyguard/pmc, /datum/emergency_call/wy_bodyguard/commando, /datum/emergency_call/wy_bodyguard/android) // "Weyland-Yutani Goon (Executive Bodyguard Detail)"
	ert_short_names = list("SEND W-Y GUARD", "SEND GOON", "SEND PMC RIOT", "SEND PMC", "SEND COMMANDO", "SEND COMBAT ANDROID")

// Provost office distress beacon held by Inspectors+
/obj/item/handheld_distress_beacon/provost
	name = "\improper Provost Office handheld beacon"
	desc = "A standard Provost Office beacon branded with the Provost Office symbol, provided to personnel for emergencies. It features an extended relay antenna and calls a squadron of Provost enforcers."

	beacon_type = "Provost Enforcers beacon"
	recipient = "the USS Superintendent"
	ert_paths = list(/datum/emergency_call/provost_enforcer) // "USCM Provost Enforcers"
	ert_short_names = list("SEND ENFORCERS")
