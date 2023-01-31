/obj/item/device/radio/listening_bug
	name = "Listening Device"
	desc = "A small listening device"

	w_class = SIZE_TINY
	volume = RADIO_VOLUME_RAISED

	broadcasting = FALSE
	listening = FALSE
	frequency = BUG_A_FREQ
	canhear_range = 7
	freqlock = TRUE


/obj/item/device/radio/listening_bug/ui_data(mob/user)
	var/list/data = list()

	data["broadcasting"] = src.broadcasting
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

/obj/item/device/radio/listening_bug/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("broadcast")
			broadcasting = !broadcasting
			. = TRUE
		if("channel")
			var/channel = params["channel"]
			if(!(channel in channels))
				return
			if(channels[channel] & FREQ_LISTENING)
				channels[channel] &= ~FREQ_LISTENING
			else
				channels[channel] |= FREQ_LISTENING
			. = TRUE
		if("command")
			use_volume = !use_volume
			. = TRUE
