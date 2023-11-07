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
	canhear_range = 7
	freqlock = TRUE
	var/current_disguise = DISGUISE_REMOVE

/obj/item/device/radio/listening_bug/ui_data(mob/user)
	var/list/data = list()

	data["broadcasting"] = src.broadcasting
	data["listening"] = src.listening
	data["frequency"] = src.frequency
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

/obj/item/device/radio/listening_bug/freq_a
	frequency = BUG_A_FREQ

/obj/item/device/radio/listening_bug/freq_b
	frequency = BUG_B_FREQ

/obj/item/device/radio/listening_bug/freq_c
	frequency = BUG_C_FREQ

/obj/item/device/radio/listening_bug/freq_d
	frequency = BUG_D_FREQ

/obj/item/device/radio/listening_bug/freq_e
	frequency = BUG_E_FREQ

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
			new_name = "listening device"
			new_desc = "A small, and disguisable, listening device."
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
				new_desc = "A lavish testament to the ingenuity of ARMAT's craftsmanship, this fountain pen is a paragon of design and functionality. Detailed with golden accents and intricate mechanics, the pen allows for a swift change between a myriad of ink colors with a simple twist. A product of precision engineering, each mechanism inside the pen is designed to provide a seamless, effortless transition from one color to the next, creating an instrument of luxurious versatility"
		if(DISGUISE_ACCESS_TUNER)
			new_name = "Security Access Tuner"
			new_desc = "A small handheld tool used to override various machine functions. Primarily used to pulse Airlock and APC wires on a shortwave frequency. It contains a small data buffer as well."
			new_icon = 'icons/obj/items/devices.dmi'
			new_icon_state = "multitool"
			new_item_state = "multitool"
			new_equip_slots = 0
		if(DISGUISE_WHISTLE)
			new_name = "whistle"
			new_desc = "A metal pea-whistle. Can be blown while held, or worn in the mouth"
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
