#define DISGUISE_REMOVE "remove disguise"
#define DISGUISE_RADIO "radio"
#define DISGUISE_PEN "pen"
#define DISGUISE_FOUNTAIN_PEN "fountain pen"
#define DISGUISE_ACCESS_TUNER "access tuner"
#define DISGUISE_WHISTLE "whistle"
#define DISGUISE_MASS_SPEC "mass-spectrometer"
#define DISGUISE_CAMERA "camera"
#define DISGUISE_ZIPPO "zippo lighter"
#define DISGUISE_TAPE_RECORDER "tape recorder"

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
	/// What the bug is currently pretending to be.
	var/current_disguise = DISGUISE_REMOVE
	/// Whether or not the bug can be used to listen to its own channel.
	var/prevent_snooping = FALSE

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
	var/processed_verb = "[SPAN_RED("\[LSTN Device\]")] [verb]"
	if(broadcasting)
		if(get_dist(src, M) <= 7)
			talk_into(M, msg,null,processed_verb,speaking)

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

	var/list/camo_options = list(
		DISGUISE_REMOVE,DISGUISE_RADIO,DISGUISE_PEN,DISGUISE_FOUNTAIN_PEN,DISGUISE_ACCESS_TUNER,DISGUISE_WHISTLE,DISGUISE_MASS_SPEC,DISGUISE_CAMERA,DISGUISE_ZIPPO,DISGUISE_TAPE_RECORDER
	)
	camo_options -= current_disguise
	var/new_disguise = tgui_input_list(usr, "What new disguise do you wish to use?", "New Disguise", camo_options)

	if(!new_disguise || (new_disguise == current_disguise))
		return FALSE

	handle_new_disguise(new_disguise)
	return TRUE

/obj/item/device/radio/listening_bug/proc/handle_new_disguise(new_disguise)
	if(!new_disguise)
		return FALSE
	var/new_icon
	var/new_name
	var/new_desc
	var/new_icon_state
	var/new_item_state
	var/new_equip_slots
	switch(new_disguise)
		if(DISGUISE_REMOVE)
			new_name = "listening device ([get_bug_letter()])"
			new_desc = "A small, and disguisable, listening device. This one is assigned to network [get_bug_letter()]."
			if(subspace_switchable)
				new_desc += " It seems to be able to switch between subspace communications broadcasts, and shortwave-radio bursts."
			new_icon = 'icons/obj/items/devices.dmi'
			new_icon_state = "voice0"
			new_item_state = "analyzer"
			new_equip_slots = SLOT_WAIST
		if(DISGUISE_RADIO)
			new_name = "shortwave radio"
			new_desc = "A handheld radio."
			new_icon = 'icons/obj/items/radio.dmi'
			new_icon_state = "walkietalkie"
			new_item_state = "walkietalkie"
			new_equip_slots = SLOT_WAIST
		if(DISGUISE_PEN, DISGUISE_FOUNTAIN_PEN)
			new_name = new_disguise
			new_desc = "It's a normal black ink pen."
			new_icon = 'icons/obj/items/paper.dmi'
			new_icon_state = "pen"
			new_item_state = "pen"
			new_equip_slots = SLOT_WAIST|SLOT_EAR|SLOT_SUIT_STORE
			if(new_disguise == DISGUISE_FOUNTAIN_PEN)
				new_icon_state = "fountain_pen"
				new_desc = "A lavish testament to the ingenuity of ARMAT's craftsmanship, this fountain pen is a paragon of design and functionality. Detailed with golden accents and intricate mechanics, the pen allows for a swift change between a myriad of ink colors with a simple twist. A product of precision engineering, each mechanism inside the pen is designed to provide a seamless, effortless transition from one color to the next, creating an instrument of luxurious versatility."
		if(DISGUISE_ACCESS_TUNER)
			new_name = "Security Access Tuner"
			new_desc = "A small handheld tool used to override various machine functions. Primarily used to pulse Airlock and APC wires on a shortwave frequency. It contains a small data buffer as well."
			new_icon = 'icons/obj/items/devices.dmi'
			new_icon_state = "multitool"
			new_item_state = "multitool"
			new_equip_slots = 0
		if(DISGUISE_WHISTLE)
			new_name = "whistle"
			new_desc = "A metal pea-whistle. Can be blown while held, or worn in the mouth."
			new_icon = 'icons/obj/items/devices.dmi'
			new_icon_state = "whistle"
			new_item_state = "whistle"
			new_equip_slots = SLOT_FACE
		if(DISGUISE_MASS_SPEC)
			new_name = "mass-spectrometer"
			new_desc = "A hand-held mass spectrometer which identifies trace chemicals in a blood sample."
			new_icon = 'icons/obj/items/devices.dmi'
			new_icon_state = "spectrometer"
			new_item_state = "analyzer"
			new_equip_slots = SLOT_WAIST
		if(DISGUISE_CAMERA)
			new_name = "camera"
			new_desc = "A polaroid camera."
			new_icon = 'icons/obj/items/items.dmi'
			new_icon_state = "camera"
			new_item_state = "electropack"
			new_equip_slots = SLOT_WAIST
		if(DISGUISE_ZIPPO)
			new_name = "Zippo lighter"
			new_desc = "A fancy steel Zippo lighter. Ignite in style."
			new_icon = 'icons/obj/items/items.dmi'
			new_icon_state = "zippo"
			new_item_state = "zippo"
			new_equip_slots = SLOT_WAIST
		if(DISGUISE_TAPE_RECORDER)
			new_name = "tape recorder"
			new_desc = "A device that can record dialogue using magnetic tapes. It automatically translates the content in playback."
			new_icon = 'icons/obj/items/walkman.dmi'
			new_icon_state = "taperecorder_idle"
			new_item_state = "analyzer"
			new_equip_slots = 0

	current_disguise = new_disguise
	name = new_name
	desc = new_desc
	if(new_disguise != DISGUISE_REMOVE)
		desc += " Something seems wrong with it."
	icon = new_icon
	icon_state = new_icon_state
	item_state = new_item_state
	flags_equip_slot = new_equip_slots
	return TRUE

#undef DISGUISE_RADIO
#undef DISGUISE_PEN
#undef DISGUISE_FOUNTAIN_PEN
#undef DISGUISE_ACCESS_TUNER
#undef DISGUISE_WHISTLE
#undef DISGUISE_MASS_SPEC
#undef DISGUISE_CAMERA
#undef DISGUISE_ZIPPO
#undef DISGUISE_TAPE_RECORDER

/obj/item/device/radio/listening_bug/proc/get_bug_letter()
	if(!frequency)
		return "X"
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
		if(WY_FREQ, PMC_FREQ)
			return "WY"
		if(UPP_FREQ, UPP_KDO_FREQ)
			return "UPP"
		else
			return "X"


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

/obj/item/device/radio/listening_bug/radio_linked/wy
	frequency = WY_FREQ
	req_one_access = list(ACCESS_WY_EXEC, ACCESS_WY_SECURITY)

/obj/item/device/radio/listening_bug/radio_linked/upp
	frequency = UPP_FREQ
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
