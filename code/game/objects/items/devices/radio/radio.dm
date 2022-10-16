/obj/item/device/radio
	icon = 'icons/obj/items/radio.dmi'
	name = "shortwave radio"
	suffix = "\[3\]"
	icon_state = "walkietalkie"
	item_state = "walkietalkie"
	var/on = 1 // 0 for off
	var/last_transmission
	var/frequency = PUB_FREQ //common chat
	var/traitor_frequency = 0 //tune to frequency to unlock traitor supplies
	var/canhear_range = 3 // the range which mobs can hear this radio from
	var/wires = WIRE_SIGNAL|WIRE_RECEIVE|WIRE_TRANSMIT
	var/b_stat = 0
	var/broadcasting = FALSE
	var/listening = TRUE
	var/freqlock = TRUE
	var/ignore_z = FALSE
	var/freerange = 0 // 0 - Sanitize frequencies, 1 - Full range
	var/list/channels = list() //see communications.dm for full list. First channes is a "default" for :h
	var/subspace_transmission = 0
	/// If true, subspace_transmission can be toggled at will.
	var/subspace_switchable = FALSE
	var/syndie = 0//Holder to see if it's a syndicate encrpyed radio
	var/maxf = 1499
	var/volume = RADIO_VOLUME_QUIET
	///if false it will just default to RADIO_VOLUME_QUIET every time
	var/use_volume = TRUE
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	throw_speed = SPEED_FAST
	throw_range = 9
	w_class = SIZE_SMALL

	matter = list("glass" = 25,"metal" = 75)
		//FREQ_BROADCASTING = 2

	var/datum/radio_frequency/radio_connection
	var/list/datum/radio_frequency/secure_radio_connections = new

/obj/item/device/radio/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency, RADIO_CHAT)

/obj/item/device/radio/Destroy()
	if(radio_connection)
		radio_connection.remove_listener(src)
		radio_connection = null
	if(secure_radio_connections)
		for(var/ch_name in secure_radio_connections)
			var/datum/radio_frequency/RF = secure_radio_connections[ch_name]
			if(!RF)
				continue
			RF.remove_listener(src)
			secure_radio_connections -= RF

	return ..()


/obj/item/device/radio/proc/remove_all_freq()
	for(var/X in SSradio.frequencies)
		var/datum/radio_frequency/F = SSradio.frequencies[X]
		if(F)
			F.remove_listener(src)


/obj/item/device/radio/Initialize()
	. = ..()

	if((type == /obj/item/device/radio || type == /obj/item/device/radio/off) && frequency == PUB_FREQ) // disgusting i know, but i'm not sure why a handheld radio is the parent of headsets
		var/turf/T = get_turf(src)
		if(T && is_ground_level(T.z))
			frequency = COLONY_FREQ

	set_frequency(frequency)

	for (var/ch_name in channels)
		secure_radio_connections[ch_name] = SSradio.add_object(src, radiochannels[ch_name], RADIO_CHAT)

	flags_atom |= USES_HEARING


/obj/item/device/radio/attack_self(mob/user as mob)
	..()
	user.set_interaction(src)
	tgui_interact(user)

/obj/item/device/radio/ui_state(mob/user)
	return GLOB.inventory_state

/obj/item/device/radio/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(!on)
		return UI_CLOSE

/obj/item/device/radio/tgui_interact(mob/user, datum/tgui/ui, datum/ui_state/state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Radio", "Radio")
		ui.open()

/obj/item/device/radio/ui_data(mob/user)
	var/list/data = list()

	data["broadcasting"] = src.broadcasting
	data["listening"] = src.listening
	data["frequency"] = src.frequency
	data["minFrequency"] = freerange ? MIN_FREE_FREQ : MIN_FREQ
	data["maxFrequency"] = freerange ? MAX_FREE_FREQ : MAX_FREQ
	data["freqlock"] = freqlock
	data["channels"] = list()
	for(var/channel in channels)
		data["channels"][channel] = channels[channel] & FREQ_LISTENING
	data["command"] = volume
	data["useCommand"] = use_volume
	data["subspace"] = subspace_transmission
	data["subspaceSwitchable"] = subspace_switchable
	data["headset"] = FALSE

	return data

/obj/item/device/radio/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("frequency")
			if(freqlock)
				return
			var/tune = params["tune"]
			var/adjust = text2num(params["adjust"])
			if(adjust)
				tune = frequency + adjust * 10
				. = TRUE
			else if(text2num(tune) != null)
				tune = tune * 10
				. = TRUE
			if(.)
				set_frequency(sanitize_frequency(tune))
		if("listen")
			listening = !listening
			. = TRUE
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
		if("subspace")
			if(subspace_switchable)
				subspace_transmission = !subspace_transmission
				if(!subspace_transmission)
					channels = list()
				//else
				//	recalculateChannels()
				. = TRUE

/obj/item/device/radio/proc/text_wires()
	if (!b_stat)
		return ""
	return {"
			<hr>
			Green Wire: <A href='byond://?src=\ref[src];wires=4'>[(wires & 4) ? "Cut" : "Mend"] Wire</A><BR>
			Red Wire:   <A href='byond://?src=\ref[src];wires=2'>[(wires & 2) ? "Cut" : "Mend"] Wire</A><BR>
			Blue Wire:  <A href='byond://?src=\ref[src];wires=1'>[(wires & 1) ? "Cut" : "Mend"] Wire</A><BR>
			"}


/obj/item/device/radio/proc/text_sec_channel(var/chan_name, var/chan_stat)
	var/list = !!(chan_stat&FREQ_LISTENING)!=0
	var/channel_key
	for(var/key in department_radio_keys)
		if(department_radio_keys[key] == chan_name)
			channel_key = key
			break
	return {"
			<tr><td><B>[chan_name]</B>	[channel_key]</td>
			<td><A href='byond://?src=\ref[src];ch_name=[chan_name];listen=[!list]'>[list ? "Engaged" : "Disengaged"]</A></td></tr>
			"}

// Interprets the message mode when talking into a radio, possibly returning a connection datum
/obj/item/device/radio/proc/handle_message_mode(mob/living/M as mob, message, message_mode)
	// If a channel isn't specified, send to common.
	if(!message_mode || message_mode == "headset")
		return radio_connection

	// Otherwise, if a channel is specified, look for it.
	if(channels && channels.len)
		if (message_mode == "department" ) // Department radio shortcut
			message_mode = channels[1]

		if (channels[message_mode]) // only broadcast if the channel is set on
			return secure_radio_connections[message_mode]

	// If we were to send to a channel we don't have, drop it.
	return null

/obj/item/device/radio/talk_into(mob/living/M as mob, message, channel, var/verb = "says", var/datum/language/speaking = null)
	if(!on) return // the device has to be on
	//  Fix for permacell radios, but kinda eh about actually fixing them.
	if(!M || !message) return

	//  Uncommenting this. To the above comment:
	// 	The permacell radios aren't suppose to be able to transmit, this isn't a bug and this "fix" is just making radio wires useless. -Giacom
	if(!(src.wires & WIRE_TRANSMIT)) // The device has to have all its wires and shit intact
		return

	M.last_target_click = world.time

	/* Quick introduction:
		This new radio system uses a very robust FTL signaling technology unoriginally
		dubbed "subspace" which is somewhat similar to 'blue-space' but can't
		actually transmit large mass. Headsets are the only radio devices capable
		of sending subspace transmissions to the Communications Satellite.

		A headset sends a signal to a subspace listener/receiver elsewhere in space,
		the signal gets processed and logged, and an audible transmission gets sent
		to each individual headset.
	*/

	//#### Grab the connection datum ####//
	var/datum/radio_frequency/connection = handle_message_mode(M, message, channel)
	if(!istype(connection))
		return
	if(!connection)
		return

	var/turf/position = get_turf(src)
	if(QDELETED(position))
		return

	//#### Tagging the signal with all appropriate identity values ####//

	// ||-- The mob's name identity --||
	var/displayname = M.name	// grab the display name (name you get when you hover over someone's icon)
	var/real_name = M.real_name // mob's real name
	var/voicemask = 0 // the speaker is wearing a voice mask

	var/jobname // the mob's "job"
	// --- Human: use their actual job ---
	if(ishuman(M))
		jobname = M:get_assignment()
	// --- Carbon Nonhuman ---
	else if(iscarbon(M)) // Nonhuman carbon mob
		jobname = "No id"
	// --- AI ---
	else if(isAI(M))
		jobname = "AI"
	// --- Cyborg ---
	else if(isrobot(M))
		jobname = "Cyborg"
	// --- Unidentifiable mob ---
	else
		jobname = "Unknown"

	// --- Modifications to the mob's identity ---
	// The mob is disguising their identity:
	if(ishuman(M) && M.GetVoice() != real_name)
		displayname = M.GetVoice()
		jobname = "Unknown"
		voicemask = 1

	var/transmit_z = position.z
	// If the mob is inside a vehicle interior, send the message from the vehicle's z, not the interior z
	if(transmit_z == GLOB.interior_manager.interior_z)
		var/datum/interior/I = GLOB.interior_manager.get_interior_by_coords(position.x, position.y)
		if(I && I.exterior)
			transmit_z = I.exterior.z

	var/list/target_zs = list(transmit_z)
	if(ignore_z)
		target_zs = SSmapping.levels_by_trait(ZTRAIT_ADMIN) //this area always has comms

	/* ###### Intercoms and shortwave radios ###### */
	var/filter_type = RADIO_FILTER_TYPE_INTERCOM_AND_BOUNCER
	if(subspace_transmission)
		filter_type = RADIO_FILTER_TYPE_ALL
		if(!src.ignore_z)
			target_zs = get_target_zs(connection.frequency)
			if (isnull(target_zs))
				//We don't have a radio connection on our Z-level, abort!
				return

	/* --- Intercoms can only broadcast to other intercoms, but shortwave radios can broadcast to shortwave radios and intercoms --- */
	if(istype(src, /obj/item/device/radio/intercom))
		filter_type = RADIO_FILTER_TYPE_INTERCOM

	if(use_volume)
		Broadcast_Message(connection, M, voicemask, pick(M.speak_emote),
						src, message, displayname, jobname, real_name, M.voice_name,
						filter_type, 0, target_zs, connection.frequency, verb, speaking, volume)
	else
		Broadcast_Message(connection, M, voicemask, pick(M.speak_emote),
						src, message, displayname, jobname, real_name, M.voice_name,
						filter_type, 0, target_zs, connection.frequency, verb, speaking, RADIO_VOLUME_QUIET)

/obj/item/device/radio/proc/get_target_zs(var/frequency)
	var/turf/position = get_turf(src)
	if(QDELETED(position))
		return

	var/transmit_z = position.z
	// If the mob is inside a vehicle interior, send the message from the vehicle's z, not the interior z
	if(transmit_z == GLOB.interior_manager.interior_z)
		var/datum/interior/I = GLOB.interior_manager.get_interior_by_coords(position.x, position.y)
		if(I && I.exterior)
			transmit_z = I.exterior.z

	var/list/target_zs = list(transmit_z)
	if(ignore_z)
		target_zs = SSmapping.levels_by_trait(ZTRAIT_ADMIN) //this area always has comms


	if(subspace_transmission)
		if(!src.ignore_z)
			target_zs = SSradio.get_available_tcomm_zs(frequency)
			if(!(transmit_z in target_zs))
				//We don't have a connection ourselves!
				return null
	return target_zs

/obj/item/device/radio/hear_talk(mob/M as mob, msg, var/verb = "says", var/datum/language/speaking = null)
	if (broadcasting)
		if(get_dist(src, M) <= canhear_range)
			talk_into(M, msg,null,verb,speaking)


/*
/obj/item/device/radio/proc/accept_rad(obj/item/device/radio/R as obj, message)

	if ((R.frequency == frequency && message))
		return 1
	else if

	else
		return null
	return
*/


/obj/item/device/radio/proc/receive_range(freq, level)
	// check if this radio can receive on the given frequency, and if so,
	// what the range is in which mobs will hear the radio
	// returns: -1 if can't receive, range otherwise

	if (!(wires & WIRE_RECEIVE))
		return -1
	if(!listening)
		return -1
	if(!(0 in level))
		var/turf/position = get_turf(src)
		if(QDELETED(position))
			return FALSE
		var/receive_z = position.z
		// Use vehicle's z if we're inside a vehicle interior
		if(position.z == GLOB.interior_manager.interior_z)
			var/datum/interior/I = GLOB.interior_manager.get_interior_by_coords(position.x, position.y)
			if(I && I.exterior)
				receive_z = I.exterior.z
		if(src.ignore_z == TRUE)
			receive_z = SSmapping.levels_by_trait(ZTRAIT_ADMIN)[1] //this area always has comms

		if(!position || !(receive_z in level))
			return -1
	if(freq in ANTAG_FREQS)
		if(!(src.syndie))//Checks to see if it's allowed on that frequency, based on the encryption keys
			return -1
	if (!on)
		return -1
	if (!freq) //received on main frequency
		if (!listening)
			return -1
	else
		var/accept = (freq==frequency && listening)
		if (!accept)
			for (var/ch_name in channels)
				var/datum/radio_frequency/RF = secure_radio_connections[ch_name]
				if (RF.frequency==freq && (channels[ch_name]&FREQ_LISTENING))
					accept = 1
					break
		if (!accept)
			return -1
	return canhear_range

/obj/item/device/radio/proc/send_hear(freq, level)
	var/range = receive_range(freq, level)
	if(range > -1)
		var/list/hearers
		var/list/mobs = get_mobs_in_view(canhear_range, src)
		var/list/radios = get_radios_in_view(canhear_range, src)
		hearers += mobs
		hearers += radios
		return hearers


/obj/item/device/radio/get_examine_text(mob/user)
	. = ..()
	if ((in_range(src, user) || loc == user))
		if (b_stat)
			. += SPAN_NOTICE("[src] can be attached and modified!")
		else
			. += SPAN_NOTICE("[src] can not be modified or attached!")


/obj/item/device/radio/attackby(obj/item/W as obj, mob/user as mob)
	..()
	user.set_interaction(src)
	if (!HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
		return
	b_stat = !( b_stat )
	if(!istype(src, /obj/item/device/radio/beacon))
		if (b_stat)
			user.show_message(SPAN_NOTICE("The radio can now be attached and modified!"))
		else
			user.show_message(SPAN_NOTICE("The radio can no longer be modified or attached!"))
		updateDialog()
			//Foreach goto(83)
		add_fingerprint(user)
		return
	else return

/obj/item/device/radio/emp_act(severity)
	broadcasting = FALSE
	listening = FALSE
	for (var/ch_name in channels)
		channels[ch_name] = 0
	..()

///////////////////////////////
//////////Borg Radios//////////
///////////////////////////////
//Giving borgs their own radio to have some more room to work with -Sieve

/obj/item/device/radio/borg
	var/mob/living/silicon/robot/myborg = null // Cyborg which owns this radio. Used for power checks
	var/obj/item/device/encryptionkey/keyslot = null//Borg radios can handle a single encryption key
	var/shut_up = 0
	icon = 'icons/obj/items/robot_component.dmi' // Cyborgs radio icons should look like the component.
	icon_state = "radio"
	canhear_range = 3

/obj/item/device/radio/borg/talk_into()
	..()
	if (isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		var/datum/robot_component/C = R.components["radio"]
		R.cell_use_power(C.active_usage)

/obj/item/device/radio/borg/attackby(obj/item/W as obj, mob/user as mob)
//	..()
	user.set_interaction(src)
	if (!(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER) || (istype(W, /obj/item/device/encryptionkey))))
		return

	if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
		if(keyslot)


			for(var/ch_name in channels)
				SSradio.remove_object(src, radiochannels[ch_name])
				secure_radio_connections[ch_name] = null


			if(keyslot)
				var/turf/T = get_turf(user)
				if(T)
					keyslot.forceMove(T)
					keyslot = null

			recalculateChannels()
			to_chat(user, "You pop out the encryption key in the radio!")

		else
			to_chat(user, "This radio doesn't have any encryption keys!")

	if(istype(W, /obj/item/device/encryptionkey/))
		if(keyslot)
			to_chat(user, "The radio can't hold another key!")
			return

		if(!keyslot)
			if(user.drop_held_item())
				W.forceMove(src)
				keyslot = W

		recalculateChannels()

	return

/obj/item/device/radio/borg/proc/recalculateChannels()
	src.channels = list()
	src.syndie = 0

	var/mob/living/silicon/robot/D = src.loc
	if(D.module)
		for(var/ch_name in D.module.channels)
			if(ch_name in src.channels)
				continue
			src.channels += ch_name
			src.channels[ch_name] += D.module.channels[ch_name]
	if(keyslot)
		for(var/ch_name in keyslot.channels)
			if(ch_name in src.channels)
				continue
			src.channels += ch_name
			src.channels[ch_name] += keyslot.channels[ch_name]

		if(keyslot.syndie)
			src.syndie = 1


	for (var/ch_name in src.channels)
		secure_radio_connections[ch_name] = SSradio.add_object(src, radiochannels[ch_name],  RADIO_CHAT)

	SStgui.update_uis(src)

/obj/item/device/radio/borg/Topic(href, href_list)
	if(usr.stat || !on)
		return
	if (href_list["mode"])
		if(subspace_transmission != 1)
			subspace_transmission = 1
			to_chat(usr, "Subspace Transmission is disabled")
		else
			subspace_transmission = 0
			to_chat(usr, "Subspace Transmission is enabled")
		if(subspace_transmission == 1)//Simple as fuck, clears the channel list to prevent talking/listening over them if subspace transmission is disabled
			channels = list()
		else
			recalculateChannels()
	if (href_list["shutup"]) // Toggle loudspeaker mode, AKA everyone around you hearing your radio.
		shut_up = !shut_up
		if(shut_up)
			canhear_range = 0
		else
			canhear_range = 3

	..()

/obj/item/device/radio/borg/interact(mob/user as mob)
	if(!on)
		return

	var/dat = "<html><head><title>[src]</title></head><body><TT>"
	dat += {"
				Speaker: [listening ? "<A href='byond://?src=\ref[src];listen=0'>Engaged</A>" : "<A href='byond://?src=\ref[src];listen=1'>Disengaged</A>"]<BR>
				Frequency:
				<A href='byond://?src=\ref[src];freq=-10'>-</A>
				<A href='byond://?src=\ref[src];freq=-2'>-</A>
				[format_frequency(frequency)]
				<A href='byond://?src=\ref[src];freq=2'>+</A>
				<A href='byond://?src=\ref[src];freq=10'>+</A><BR>
				<A href='byond://?src=\ref[src];mode=1'>Toggle Broadcast Mode</A><BR>
				<A href='byond://?src=\ref[src];shutup=1'>Toggle Loudspeaker</A><BR>
				"}

	if(!subspace_transmission)//Don't even bother if subspace isn't turned on
		for (var/ch_name in channels)
			dat+=text_sec_channel(ch_name, channels[ch_name])
	dat+={"[text_wires()]</TT></body></html>"}
	show_browser(user, dat, name, "radio")
	return


/obj/item/device/radio/proc/config(op)
	for (var/ch_name in channels)
		SSradio.remove_object(src, radiochannels[ch_name])
	secure_radio_connections = new
	channels = op
	for (var/ch_name in op)
		secure_radio_connections[ch_name] = SSradio.add_object(src, radiochannels[ch_name],  RADIO_CHAT)

/obj/item/device/radio/off
	listening = 0



//MARINE RADIO

/obj/item/device/radio/marine
	frequency = PUB_FREQ
