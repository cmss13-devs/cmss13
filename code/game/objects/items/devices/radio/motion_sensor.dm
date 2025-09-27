#define COOLDOWN_MOTION_SENSOR 60 SECONDS

/obj/item/device/motion_sensor
	name = "Motion Sensor"

	icon = 'icons/obj/items/new_assemblies.dmi'
	icon_state = "motion"
	desc = "A motion sensor."

	/// Alert message to report unless area based.
	var/alert_message = "ALERT: Unauthorized movement detected!"
	/// Set to true if it should report area name and not specific alert.
	var/area_based = TRUE
	/// Cooldown duration and next time.
	var/cooldown_duration = COOLDOWN_MOTION_SENSOR
	COOLDOWN_DECLARE(sensor_cooldown)
	/// The job on a mob to enter
	var/list/pass_jobs = list()
	/// The accesses on an ID card to enter
	var/pass_accesses = list()

	/// radio which broadcasts updates
	var/obj/item/device/radio/motion/transceiver
	/// the hidden mob which voices updates
	var/mob/living/silicon/voice

	var/assigned_network = "MP"
	var/assigned_channel
	var/assigned_frequency

	var/list/network_to_access = list(
		"MP" = ACCESS_MARINE_BRIG,
		"CIA" = ACCESS_CIA,
		"WY" = ACCESS_WY_EXEC,
		"WY PMC" = ACCESS_WY_PMC,
		"CLF" = ACCESS_CLF_ENGINEERING,
		"UPP" = ACCESS_UPP_ENGINEERING,
		"RMC" = ACCESS_TWE_ENGINEERING,
	)
	layer = ABOVE_BLOOD_LAYER

/obj/item/device/radio/motion
	listening = FALSE

/obj/item/device/motion_sensor/Initialize(mapload, ...)
	. = ..()
	voice = new /mob/living/silicon
	voice.name = "[name]:[serial_number]"
	voice.forceMove(src)

	transceiver = new /obj/item/device/radio/motion
	transceiver.forceMove(src)
	transceiver.subspace_transmission = TRUE
	update_tranceiver(assigned_network)
	update_icon()

/obj/item/device/motion_sensor/Destroy()
	. = ..()
	QDEL_NULL(transceiver)
	QDEL_NULL(voice)

/obj/item/device/motion_sensor/update_icon()
	if(anchored)
		icon_state = "[icon_state]_active"
		name = "[name] (ACTIVE)"
	else
		icon_state = initial(icon_state)
		name = initial(name)

/obj/item/device/motion_sensor/Crossed(mob/living/passer)
	if(!anchored)//Not working if it isn't on the floor.
		return FALSE
	if(!transceiver || !voice)//Can't send if there's no radio or voice
		return FALSE
	if(!COOLDOWN_FINISHED(src, sensor_cooldown))//Don't want alerts spammed.
		return FALSE
	if(!passer)
		return FALSE
	if(!(ishuman(passer) || isxeno(passer)))
		return FALSE
	if(HAS_TRAIT(passer, TRAIT_CLOAKED))
		return FALSE
	if(pass_jobs)
		if(passer.job in pass_jobs)
			return FALSE
		if(isxeno(passer) && (JOB_XENOMORPH in pass_jobs))
			return FALSE
	if(allowed(passer))
		return FALSE
	send_alert(passer)
	return TRUE

/obj/item/device/motion_sensor/proc/send_alert(mob/living/passer, message_override)
	var/broadcast_message = alert_message
	if(area_based)
		var/area_name = get_area_name(src, TRUE)
		broadcast_message = "ALERT: Unauthorized movement detected in [area_name]!"
	if(message_override)
		broadcast_message = message_override
	broadcast_message = strip_improper(broadcast_message)
	transceiver.talk_into(voice, "[broadcast_message]", assigned_channel)
	playsound(loc, "sound/machines/beepalert.ogg", 20)
	COOLDOWN_START(src, sensor_cooldown, cooldown_duration)

	return TRUE

/obj/item/device/motion_sensor/get_examine_text(mob/user)
	. = ..()
	if(allowed(user))
		. += SPAN_ORANGE("It is set to the '[assigned_network]' network.")

/obj/item/device/motion_sensor/attackby(obj/item/hit_item, mob/user)
	if(istype(hit_item, /obj/item/card/id))
		if(!allowed(user))
			to_chat(user, SPAN_WARNING("Access Denied."))
			return FALSE
		if(anchored)
			to_chat(user, SPAN_WARNING("You cannot update this device while it is active!"))
			return FALSE
		var/obj/item/card/id/id_card = hit_item
		if(tgui_alert(user, "Do you wish to change the network?", "Change Network?", list("Yes", "No")) == "Yes")
			var/list/the_options = list("None")
			for(var/network in network_to_access)
				to_chat(user, SPAN_HELPFUL("Checking '[network]'."))
				if(network_to_access[network] in id_card.access)
					to_chat(user, SPAN_HELPFUL("Adding '[network]'."))
					the_options += network
				else
					to_chat(user, SPAN_HELPFUL("Ignoring '[network]'."))
			var/new_net = tgui_input_list(user, "Which new network do you want to use?", "New Network", the_options, 20 SECONDS)
			if(!new_net || new_net == "None")
				to_chat(user, SPAN_WARNING("No new network selected!"))
				return FALSE
			update_tranceiver(new_net)
			return TRUE

	else if(HAS_TRAIT(hit_item, TRAIT_TOOL_MULTITOOL))
		var/delay_time = 2 SECONDS
		if(!allowed(user) && anchored)
			delay_time = 15 SECONDS
			send_alert(user, "Tampering Detected!")

		if(!do_after(user, delay_time, INTERRUPT_ALL, BUSY_ICON_BUILD))
			return FALSE
		if(anchored)
			anchored = FALSE
			pixel_y = 0
			pixel_x = 0
			update_icon()
		else
			anchored = TRUE
			update_icon()
			var/chosen_dir = tgui_input_list(user, "Which corner do you wish to place the sensor?", "Location", list("North-West", "North-East", "South-West", "South-East"), 5 SECONDS, default = "North-West")
			switch(chosen_dir)
				if("North-West")
					pixel_y = 8
					pixel_x = -8
				if("North-East")
					pixel_y = 8
					pixel_x = 8
				if("South-West")
					pixel_y = -8
					pixel_x = -8
				if("South-East")
					pixel_y = -8
					pixel_x = 8
	else
		. = ..()

/obj/item/device/motion_sensor/check_access(obj/item/item_to_check)
	if(!islist(pass_accesses))
		return TRUE//something's very wrong
	if(!item_to_check)
		return FALSE

	var/list/access_list = item_to_check.GetAccess()
	if(LAZYLEN(pass_accesses))
		for(var/access_to_check in pass_accesses)
			if(access_to_check in access_list)
				return TRUE
		return FALSE
	return TRUE

/obj/item/device/motion_sensor/proc/update_tranceiver(new_network = "MP")
	switch(new_network)
		if("MP")
			assigned_channel = RADIO_CHANNEL_MP
			assigned_frequency = SEC_FREQ
			pass_accesses = list(ACCESS_MARINE_BRIG, ACCESS_MARINE_CO)
		if("WY")
			assigned_channel = RADIO_CHANNEL_WY
			assigned_frequency = WY_FREQ
			pass_accesses = list(ACCESS_WY_GENERAL, ACCESS_WY_EXEC)
		if("WY PMC")
			assigned_channel = RADIO_CHANNEL_PMC_CCT
			assigned_frequency = PMC_CCT_FREQ
			pass_accesses = list(ACCESS_WY_PMC, ACCESS_WY_PMC_TL)
		if("CIA")
			assigned_channel = RADIO_CHANNEL_CIA
			assigned_frequency = CIA_FREQ
			pass_accesses = list(ACCESS_CIA)
		if("CLF")
			assigned_channel = RADIO_CHANNEL_CLF_CCT
			assigned_frequency = CLF_CCT_FREQ
			pass_accesses = list(ACCESS_CLF_GENERAL, ACCESS_CLF_SECURITY, ACCESS_CLF_ENGINEERING)
		if("UPP")
			assigned_channel = RADIO_CHANNEL_UPP_CCT
			assigned_frequency = UPP_CCT_FREQ
			pass_accesses = list(ACCESS_UPP_GENERAL, ACCESS_UPP_SECURITY, ACCESS_UPP_ENGINEERING)
		if("RMC")
			assigned_channel = RADIO_CHANNEL_ROYAL_MARINE
			assigned_frequency = RMC_FREQ
			pass_accesses = list(ACCESS_TWE_GENERAL, ACCESS_TWE_SECURITY, ACCESS_TWE_ENGINEERING)
		else
			return FALSE

	assigned_network = new_network
	if(transceiver)
		transceiver.set_frequency(assigned_frequency)
		transceiver.config(list("[assigned_channel]" = TRUE))
		balloon_alert_to_viewers("network settings updated")
	return TRUE


/obj/item/device/motion_sensor/mp
	assigned_network = "MP"

/obj/item/device/motion_sensor/cia
	assigned_network = "CIA"

/obj/item/device/motion_sensor/wy
	assigned_network = "WY"

/obj/item/device/motion_sensor/wy_pmc
	assigned_network = "WY PMC"

/obj/item/device/motion_sensor/clf
	assigned_network = "CLF"

/obj/item/device/motion_sensor/upp
	assigned_network = "UPP"

/obj/item/device/motion_sensor/rmc
	assigned_network = "RMC"
