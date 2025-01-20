/obj/item/device/radio/listening_bug
	name = "listening device"
	desc = "A small, and disguisable, listening device."

	icon = 'icons/obj/items/devices.dmi'
	icon_state = "voice0"
	item_state = "analyzer"

	w_class = SIZE_TINY
	volume = RADIO_VOLUME_RAISED

	broadcasting = FALSE
	listening = FALSE
	frequency = BUG_A_FREQ
	canhear_range = 2
	freqlock = TRUE
	/// If the bug is disguised or not.
	var/ready_to_disguise = FALSE
	var/disguised = FALSE
	/// Whether or not the bug can be used to listen to its own channel.
	var/prevent_snooping = FALSE
	/// The ID tag of the device, for identification.
	var/nametag = "Device"
	inherent_traits = list(TRAIT_HEARS_FROM_CONTENTS)
	/// Whether or not this listening bug plays to ghosts depending on preferences or not at all.
	var/bug_broadcast_level = LISTENING_BUG_PREF

/obj/item/device/radio/listening_bug/ui_data(mob/user)
	var/list/data = list()

	data["broadcasting"] = broadcasting
	data["listening"] = listening
	data["frequency"] = frequency
	data["freqlock"] = freqlock

	var/list/radio_channels = list()

	for(var/channel in channels)
		var/channel_key = channel_to_prefix(channel)
		radio_channels += list(list(
			"name" = channel,
			"status" = channels[channel] & FREQ_LISTENING,
			"hotkey" = channel_key))

	data["channels"] = radio_channels

	data["command"] = volume
	data["useCommand"] = use_volume
	data["subspace"] = subspace_transmission
	data["subspaceSwitchable"] = subspace_switchable
	data["headset"] = FALSE

	return data

/obj/item/device/radio/listening_bug/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	switch(action)
		if("listen")
			if(prevent_snooping)
				to_chat(usr, SPAN_WARNING("This device cannot receive transmissions!"))
				return
			listening = !listening
			return
		if("subspace")
			if(!ishuman(usr))
				return
			var/mob/living/carbon/human/user = usr
			if(!check_access(user.wear_id) && !check_access(user.get_active_hand()))
				to_chat(user, SPAN_WARNING("You need an authenticated ID card to change this function!"))
				return
			if(subspace_switchable)
				subspace_transmission = !subspace_transmission
				var/initial_prevent = initial(prevent_snooping)
				if(initial_prevent)
					prevent_snooping = TRUE
				if(!subspace_transmission)
					prevent_snooping = FALSE
					channels = list()
				return
	..()

/obj/item/device/radio/listening_bug/hear_talk(mob/M as mob, msg, verb = "says", datum/language/speaking = null)
	var/processed_verb = "[SPAN_RED("\[LSTN [nametag]\]")] [verb]"
	if(broadcasting)
		if(get_dist(src, M) <= 7)
			talk_into(M, msg, null, processed_verb, speaking, listening_device = bug_broadcast_level)

/obj/item/device/radio/listening_bug/afterattack(atom/target_atom, mob/user as mob, proximity)
	if(!ready_to_disguise)
		return ..()

	var/obj/item/target_item = target_atom
	if(!istype(target_item) || target_item.anchored || target_item.w_class >= SIZE_LARGE)
		to_chat(user, SPAN_WARNING("You cannot disguise the listening device as this object."))
		return FALSE

	var/confirm = tgui_alert(user, "Are you sure you wish to disguise the listening device as '[target_item]'?", "Confirm Choice", list("Yes","No"), 20 SECONDS)
	if(confirm != "Yes")
		return FALSE

	icon = target_item.icon
	name = target_item.name
	desc = target_item.desc
	icon_state = target_item.icon_state
	item_state = target_item.item_state
	flags_equip_slot = target_item.flags_equip_slot
	w_class = target_item.w_class
	ready_to_disguise = FALSE
	disguised = TRUE

/obj/item/device/radio/listening_bug/get_examine_text(mob/user)
	if(disguised)
		. = list()
		var/size
		switch(w_class)
			if(SIZE_TINY)
				size = "tiny"
			if(SIZE_SMALL)
				size = "small"
			if(SIZE_MEDIUM)
				size = "normal-sized"
		. += "This is a [blood_color ? blood_color != COLOR_OIL ? "bloody " : "oil-stained " : ""][icon2html(src, user)][src.name]. It is a [size] item."
		if(desc)
			. += desc
		if(desc_lore)
			. += SPAN_NOTICE("This has an <a href='byond://?src=\ref[src];desc_lore=1'>extended lore description</a>.")
	else
		. = ..()
		. += SPAN_INFO("[src] is set to frequency [get_bug_letter()].")
		if(nametag != initial(nametag))
			. += SPAN_INFO("[src]'s nametag is set to '[nametag]'")

/obj/item/device/radio/listening_bug/verb/change_disguise()
	set name = "Change Disguise"
	set category = "Object"
	set src in usr

	if(usr.is_mob_incapacitated())
		to_chat(usr, SPAN_WARNING("You cannot do this while incapacitated!"))
		return FALSE

	var/check = tgui_alert(usr, "Do you wish to change the disguise of this listening bug?", "Change Disguise?", list("Yes", "No"))
	if(check != "Yes")
		return FALSE
	if(disguised)
		var/remove_check = tgui_alert(usr, "Do you wish to remove the current disguise?", "Remove Disguise?", list("Yes","No"))
		if(remove_check == "Yes")
			icon = initial(icon)
			name = initial(name)
			desc = initial(desc)
			icon_state = initial(icon_state)
			item_state = initial(item_state)
			flags_equip_slot = initial(flags_equip_slot)
			w_class = initial(w_class)
			disguised = FALSE
			return TRUE

	to_chat(usr, SPAN_HELPFUL("You can now change the disguise of the device by selecting a normal, or smaller, sized object."))
	ready_to_disguise = TRUE
	return TRUE

/obj/item/device/radio/listening_bug/proc/get_bug_letter()
	switch(frequency)
		if(BUG_A_FREQ)
			return "A"
		if(BUG_B_FREQ)
			return "B"
		if(SEC_FREQ)
			return "MP"
		if(PVST_FREQ)
			return "PVST"
		if(HC_FREQ)
			return "HC"
		if(WY_FREQ, PMC_CCT_FREQ)
			return "WY"
		if(PMC_CMD_FREQ)
			return "WYC"
		if(UPP_CCT_FREQ, UPP_KDO_FREQ)
			return "UPP"
		else
			return "X"

#define OPTION_REMOVE "Remove Tag"
#define OPTION_NEW "New Tag"

/obj/item/device/radio/listening_bug/verb/set_nametag()
	set name = "Set Nametag"
	set category = "Object"
	set src in usr

	if(usr.is_mob_incapacitated())
		to_chat(usr, SPAN_WARNING("You cannot do this while incapacitated!"))
		return FALSE

	var/check = tgui_alert(usr, "Do you wish to change the name tag of this listening bug?", "Change Name tag?", list("Yes", "No"))
	if(check != "Yes")
		return FALSE


	var/new_nametag
	var/remove
	if(nametag != initial(nametag))
		remove = tgui_alert(usr, "Do you wish to remove the current nametag?", "Remove Nametag", list("Yes", "No"))
	if(remove == "Yes")
		new_nametag = initial(nametag)
	else
		new_nametag = tgui_input_text(usr, "What new name tag do you wish to use?", "New Name", initial(nametag), 6)

	if(!new_nametag || (new_nametag == nametag))
		return FALSE

	nametag = new_nametag
	log_game("[key_name(usr)] set a listening device nametag to [new_nametag].")
	return TRUE

#undef OPTION_REMOVE
#undef OPTION_NEW

/obj/item/device/radio/listening_bug/freq_a
	frequency = BUG_A_FREQ

/obj/item/device/radio/listening_bug/freq_b
	frequency = BUG_B_FREQ

/obj/item/device/radio/listening_bug/radio_linked
	prevent_snooping = TRUE
	subspace_transmission = TRUE
	subspace_switchable = TRUE

/obj/item/device/radio/listening_bug/radio_linked/mp
	frequency = SEC_FREQ
	req_one_access = list(ACCESS_MARINE_BRIG)

/obj/item/device/radio/listening_bug/radio_linked/hc
	frequency = HC_FREQ
	req_one_access = list(ACCESS_MARINE_CO)
/obj/item/device/radio/listening_bug/radio_linked/hc/pvst
	frequency = PVST_FREQ

/obj/item/device/radio/listening_bug/radio_linked/cia
	frequency = CIA_FREQ
	req_one_access = list(ACCESS_CIA)

/obj/item/device/radio/listening_bug/radio_linked/wy
	frequency = WY_FREQ
	req_one_access = list(ACCESS_WY_EXEC, ACCESS_WY_SECURITY)

/obj/item/device/radio/listening_bug/radio_linked/wy/pmc
	frequency = PMC_CCT_FREQ
	req_one_access = list(ACCESS_WY_EXEC, ACCESS_WY_SECURITY)

/obj/item/device/radio/listening_bug/radio_linked/upp
	frequency = UPP_CCT_FREQ
	req_one_access = list(ACCESS_UPP_COMMANDO, ACCESS_UPP_SECURITY)

/obj/item/device/radio/listening_bug/radio_linked/upp/commando
	frequency = UPP_KDO_FREQ
	req_one_access = list(ACCESS_UPP_COMMANDO)


// ENCRYPTION KEYS FOR LISTENING IN!
//REQURIES SUBSPACE ACTIVATION ON THE BUGS FIRST!
/obj/item/device/encryptionkey/listening_bug
	desc = "A small encryption key for listening to a secret broadcasting device! Unlikely to work if the device is not using subspace communications!"
	icon_state = "stripped_key"

/obj/item/device/encryptionkey/listening_bug/freq_a
	name = "Listening Bug Encryption Key (A)"
	channels = list(RADIO_CHANNEL_BUG_A = TRUE)

/obj/item/device/encryptionkey/listening_bug/freq_b
	name = "Listening Bug Encryption Key (B)"
	channels = list(RADIO_CHANNEL_BUG_B = TRUE)



///An automatically active bug used to listen to things by a Fax Responder.
/obj/item/device/radio/listening_bug/radio_linked/fax
	name = "Comms Relay Device"
	subspace_switchable = FALSE
	broadcasting = TRUE
	bug_broadcast_level = LISTENING_BUG_NEVER //Don't want fax responder devices broadcasting to ghosts because it will duplicate a lot of messages every round all the time.

/obj/item/device/radio/listening_bug/radio_linked/fax/wy
	frequency = FAX_WY_FREQ
	req_one_access = list(ACCESS_WY_SENIOR_LEAD)

/obj/item/device/radio/listening_bug/radio_linked/fax/uscm_pvst
	frequency = FAX_USCM_PVST_FREQ
	req_one_access = list(ACCESS_MARINE_CO)

/obj/item/device/radio/listening_bug/radio_linked/fax/uscm_hc
	frequency = FAX_USCM_HC_FREQ
	req_one_access = list(ACCESS_MARINE_CO)
