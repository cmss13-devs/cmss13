//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/*
	The broadcaster sends processed messages to all radio devices in the game. They
	do not have to be headsets; intercoms and shortwave radios suffice.

	They receive their message from a server after the message has been logged.
*/

/obj/structure/machinery/telecomms/broadcaster
	name = "Subspace Broadcaster"
	icon = 'icons/obj/structures/props/server_equipment.dmi'
	icon_state = "broadcaster"
	desc = "A dish-shaped machine used to broadcast processed subspace signals."
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 25
	machinetype = 5
	delay = 7
	circuitboard = /obj/item/circuitboard/machine/telecomms/broadcaster
	tcomms_machine = TRUE


/*

	Here is the big, bad function that broadcasts a message given the appropriate
	parameters.

	@param connection:
		The datum generated in radio.dm, stored in signal.data["connection"].

	@param M:
		Reference to the mob/speaker, stored in signal.data["mob"]

	@param vmask:
		Boolean value if the mob is "hiding" its identity via voice mask, stored in
		signal.data["vmask"]

	@param vmessage:
		If specified, will display this as the message; such as "chimpering"
		for monkies if the mob is not understood. Stored in signal.data["vmessage"].

	@param radio:
		Reference to the radio broadcasting the message, stored in signal.data["radio"]

	@param message:
		The actual string message to display to mobs who understood mob M. Stored in
		signal.data["message"]

	@param name:
		The name to display when a mob receives the message. signal.data["name"]

	@param job:
		The name job to display for the AI when it receives the message. signal.data["job"]

	@param realname:
		The "real" name associated with the mob. signal.data["realname"]

	@param vname:
		If specified, will use this name when mob M is not understood. signal.data["vname"]

	@param data:
		If specified:
				1 -- Will only broadcast to intercoms
				2 -- Will only broadcast to intercoms and shortwave radios
				3 -- Broadcast to syndicate frequency
				4 -- AI can't track down this person. Useful for imitation broadcasts where you can't find the actual mob

	@param compression:
		If 0, the signal is audible
		If nonzero, the signal may be partially inaudible or just complete gibberish.

	@param level:
		The list of Z levels that the sending radio is broadcasting to. Having 0 in the list broadcasts on all levels

	@param freq
		The frequency of the signal

*/

/proc/Broadcast_Message(datum/radio_frequency/connection, mob/M,
						vmask, vmessage, obj/item/device/radio/radio,
						message, name, job, realname, vname,
						data, compression, list/level, freq, verbage = "says",
						datum/language/speaking = null, volume = RADIO_VOLUME_QUIET, listening_device = NOT_LISTENING_BUG)

	/* ###### Prepare the radio connection ###### */
	var/display_freq = freq
	var/comm_title = ""
	var/list/obj/item/device/radio/radios = list()

	var/atom/radio_loc = radio.loc

	// --- Broadcast only to intercom devices ---
	if(data == RADIO_FILTER_TYPE_INTERCOM)
		for (var/datum/weakref/device_ref as anything in connection.devices["[RADIO_CHAT]"])
			var/obj/item/device/radio/intercom/R = device_ref.resolve()
			if(!R)
				continue
			var/atom/loc = R.loc
			if(R.receive_range(display_freq, level) > -1 && OBJECTS_CAN_REACH(loc, radio_loc))
				radios += R

	// --- Broadcast only to intercoms and shortwave radios ---
	else if(data == RADIO_FILTER_TYPE_INTERCOM_AND_BOUNCER)
		for (var/datum/weakref/device_ref as anything in connection.devices["[RADIO_CHAT]"])
			var/obj/item/device/radio/R = device_ref.resolve()
			if(!R)
				continue
			if(istype(R, /obj/item/device/radio/headset))
				continue
			var/atom/loc = R.loc
			if(R.receive_range(display_freq, level) > -1 && OBJECTS_CAN_REACH(loc, radio_loc))
				radios += R

	/* Currently unused, but leaving incase someone revives agents or another use for it.
	// --- Broadcast to antag radios! ---
	else if(data == RADIO_FILTER_TYPE_ANTAG_RADIOS)
		for(var/antag_freq in ANTAG_FREQS)
			var/datum/radio_frequency/antag_connection = SSradio.return_frequency(antag_freq)
			for (var/obj/item/device/radio/R in antag_connection.devices["[RADIO_CHAT]"])
				var/atom/loc = R.loc
				if(R.receive_range(display_freq, level) > -1 && OBJECTS_CAN_REACH(loc, radio_loc))
					radios += R
	*/

	// --- Broadcast to ALL radio devices ---
	else
		for (var/datum/weakref/device_ref as anything in connection.devices["[RADIO_CHAT]"])
			var/obj/item/device/radio/R = device_ref.resolve()
			if(!R)
				continue
			var/atom/loc = R.loc
			if(R.receive_range(display_freq, level) > -1 && OBJECTS_CAN_REACH(loc, radio_loc))
				radios += R

	// Get a list of mobs who can hear from the radios we collected.
	var/list/receive = get_mobs_in_radio_ranges(radios)

	/* ###### Organize the receivers into categories for displaying the message ###### */

	// Understood the message:
	var/list/heard_masked = list() // masked name or no real name
	var/list/heard_normal = list() // normal message

	// Did not understand the message:
	var/list/heard_voice = list() // voice message (ie "chimpers")
	var/list/heard_garbled = list() // garbled message (ie "f*c* **u, **i*er!")
	var/list/heard_gibberish= list() // completely screwed over message (ie "F%! (O*# *#!<>&**%!")

	if(M)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(skillcheck(H, SKILL_LEADERSHIP, SKILL_LEAD_EXPERT))
				volume = max(volume, RADIO_VOLUME_CRITICAL)
			else if(HAS_TRAIT(M, TRAIT_LEADERSHIP))
				volume = max(volume, RADIO_VOLUME_IMPORTANT)

			comm_title = H.comm_title //Set up [CO] and stuff after frequency
			if(H.assigned_squad)
				if(freq != H.assigned_squad.radio_freq)
					comm_title = H.assigned_squad.name + " " + comm_title
				else
					if(H.assigned_fireteam)
						if(H.assigned_squad.fireteam_leaders[H.assigned_fireteam] == H)
							comm_title = H.comm_title + " [H.assigned_fireteam] TL"
						else
							comm_title = H.comm_title + " [H.assigned_fireteam]"


		else if(istype(M,/mob/living/silicon/decoy/ship_ai))
			volume = RADIO_VOLUME_CRITICAL

	for (var/mob/R in receive)
		var/is_ghost = istype(R, /mob/dead/observer)
		/* --- Loop through the receivers and categorize them --- */
		if (R.client && !(R.client.prefs.toggles_chat & CHAT_RADIO)) //Adminning with 80 people on can be fun when you're trying to talk and all you can hear is radios.
			continue
		if(istype(R, /mob/new_player)) // we don't want new players to hear messages. rare but generates runtimes.
			continue
		// Ghosts hearing all radio chat don't want to hear syndicate intercepts, they're duplicates
		if(data == 3 && is_ghost && R.client && (R.client.prefs.toggles_chat & CHAT_GHOSTRADIO))
			continue
		if(is_ghost && ((listening_device && !(R.client.prefs.toggles_chat & CHAT_LISTENINGBUG)) || listening_device == LISTENING_BUG_NEVER))
			continue
		// --- Check for compression ---
		if(compression > 0)
			heard_gibberish += R
			continue

		// --- Can understand the speech ---
		if (!M || R.say_understands(M))
			// - Not human or wearing a voice mask -
			if (!M || !ishuman(M) || vmask)
				heard_masked += R
			// - Human and not wearing voice mask -
			else
				heard_normal += R

		// --- Can't understand the speech ---
		else
			// - The speaker has a prespecified "voice message" to display if not understood -
			if (vmessage)
				heard_voice += R
			// - Just display a garbled message -
			else
				heard_garbled += R



	/* ###### Begin formatting and sending the message ###### */
	if (length(heard_masked) || length(heard_normal) || length(heard_voice) || length(heard_garbled) || length(heard_gibberish))

		/* --- Some miscellaneous variables to format the string output --- */
		var/part_a = "<span class='[SSradio.get_frequency_span(display_freq)]'><span class='name'>" // goes in the actual output
		var/freq_text
		if(comm_title != "" && comm_title)
			freq_text = "[get_frequency_name(display_freq)] ([comm_title])"
		else
			freq_text = get_frequency_name(display_freq)

		// --- Some more pre-message formatting ---
		var/part_b_extra = ""
		if(data == 3) // intercepted radio message
			part_b_extra = " <i>(Intercepted)</i>"
		var/part_b = "</span><b> [icon2html(radio, (heard_masked + heard_normal + heard_voice + heard_garbled + heard_gibberish))]\[[freq_text]\][part_b_extra]</b> <span class='message'>" // Tweaked for security headsets -- TLE

		if(display_freq in M.important_radio_channels)
			volume = RADIO_VOLUME_IMPORTANT

		// --- Filter the message; place it in quotes apply a verb ---

		/* ###### Send the message ###### */

		/* --- Process all the mobs that heard a masked voice (understood) --- */
		if (length(heard_masked))
			for (var/mob/R in heard_masked)
				R.hear_radio(message,verbage, speaking, part_a, part_b, M, 0, name, volume)

		/* --- Process all the mobs that heard the voice normally (understood) --- */
		if (length(heard_normal))
			for (var/mob/R in heard_normal)
				R.hear_radio(message, verbage, speaking, part_a, part_b, M, 0, realname, volume)

		/* --- Process all the mobs that heard the voice normally (did not understand) --- */
		if (length(heard_voice))
			for (var/mob/R in heard_voice)
				R.hear_radio(message,verbage, speaking, part_a, part_b, M,0, vname, 0)

		/* --- Process all the mobs that heard a garbled voice (did not understand) --- */
			// Displays garbled message (ie "f*c* **u, **i*er!")
		if (length(heard_garbled))
			for (var/mob/R in heard_garbled)
				R.hear_radio(message, verbage, speaking, part_a, part_b, M, 1, vname, 0)


		/* --- Complete gibberish. Usually happens when there's a compressed message --- */
		if (length(heard_gibberish))
			for (var/mob/R in heard_gibberish)
				R.hear_radio(message, verbage, speaking, part_a, part_b, M, 1, 0)
