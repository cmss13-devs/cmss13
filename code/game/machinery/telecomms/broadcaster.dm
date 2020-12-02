//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/*
	The broadcaster sends processed messages to all radio devices in the game. They
	do not have to be headsets; intercoms and station-bounced radios suffice.

	They receive their message from a server after the message has been logged.
*/

/obj/structure/machinery/telecomms/broadcaster
	name = "Subspace Broadcaster"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "broadcaster"
	desc = "A dish-shaped machine used to broadcast processed subspace signals."
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 25
	machinetype = 5
	delay = 7
	circuitboard = /obj/item/circuitboard/machine/telecomms/broadcaster
	tcomms_machine = TRUE


/**

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
				2 -- Will only broadcast to intercoms and station-bounced radios
				3 -- Broadcast to syndicate frequency
				4 -- AI can't track down this person. Useful for imitation broadcasts where you can't find the actual mob

	@param compression:
		If 0, the signal is audible
		If nonzero, the signal may be partially inaudible or just complete gibberish.

	@param level:
		The list of Z levels that the sending radio is broadcasting to. Having 0 in the list broadcasts on all levels

	@param freq
		The frequency of the signal

**/

/proc/Broadcast_Message(var/datum/radio_frequency/connection, var/mob/M,
						var/vmask, var/vmessage, var/obj/item/device/radio/radio,
						var/message, var/name, var/job, var/realname, var/vname,
						var/data, var/compression, var/list/level, var/freq, var/verbage = "says", var/datum/language/speaking = null)

	/* ###### Prepare the radio connection ###### */
	var/display_freq = freq
	var/comm_title = ""
	var/list/obj/item/device/radio/radios = list()

	var/atom/radio_loc = radio.loc

	// --- Broadcast only to intercom devices ---
	if(data == RADIO_FILTER_TYPE_INTERCOM)
		for (var/obj/item/device/radio/intercom/R in connection.devices["[RADIO_CHAT]"])
			var/atom/loc = R.loc
			if(R.receive_range(display_freq, level) > -1 && OBJECTS_CAN_REACH(loc, radio_loc))
				radios += R

	// --- Broadcast only to intercoms and station-bounced radios ---
	else if(data == RADIO_FILTER_TYPE_INTERCOM_AND_BOUNCER)
		for (var/obj/item/device/radio/R in connection.devices["[RADIO_CHAT]"])
			if(istype(R, /obj/item/device/radio/headset))
				continue
			var/atom/loc = R.loc
			if(R.receive_range(display_freq, level) > -1 && OBJECTS_CAN_REACH(loc, radio_loc))
				radios += R

	// --- Broadcast to antag radios! ---
	else if(data == RADIO_FILTER_TYPE_ANTAG_RADIOS)
		for(var/antag_freq in ANTAG_FREQS)
			var/datum/radio_frequency/antag_connection = SSradio.return_frequency(antag_freq)
			for (var/obj/item/device/radio/R in antag_connection.devices["[RADIO_CHAT]"])
				var/atom/loc = R.loc
				if(R.receive_range(display_freq, level) > -1 && OBJECTS_CAN_REACH(loc, radio_loc))
					radios += R

	// --- Broadcast to ALL radio devices ---
	else
		for (var/obj/item/device/radio/R in connection.devices["[RADIO_CHAT]"])
			var/atom/loc = R.loc
			if(R.receive_range(display_freq, level) > -1 && OBJECTS_CAN_REACH(loc, radio_loc))
				radios += R

	// Get a list of mobs who can hear from the radios we collected.
	var/list/receive = get_mobs_in_radio_ranges(radios)

	/* ###### Organize the receivers into categories for displaying the message ###### */

  	// Understood the message:
	var/list/heard_masked 	= list() // masked name or no real name
	var/list/heard_normal 	= list() // normal message

	// Did not understand the message:
	var/list/heard_voice 	= list() // voice message	(ie "chimpers")
	var/list/heard_garbled	= list() // garbled message (ie "f*c* **u, **i*er!")
	var/list/heard_gibberish= list() // completely screwed over message (ie "F%! (O*# *#!<>&**%!")

	var/command = 0 //Is this a commander? This var actually sets the message size. 2 is normal, 3 is big, 4 is OMGHUGE

	if(M)
		if(isAI(M))
			command = 3
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(skillcheck(H, SKILL_LEADERSHIP, SKILL_LEAD_TRAINED))
				command = 3

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
			command = 3

	for (var/mob/R in receive)
		/* --- Loop through the receivers and categorize them --- */
		if (R.client && !(R.client.prefs.toggles_chat & CHAT_RADIO)) //Adminning with 80 people on can be fun when you're trying to talk and all you can hear is radios.
			continue
		if(istype(R, /mob/new_player)) // we don't want new players to hear messages. rare but generates runtimes.
			continue
		// Ghosts hearing all radio chat don't want to hear syndicate intercepts, they're duplicates
		if(data == 3 && istype(R, /mob/dead/observer) && R.client && (R.client.prefs.toggles_chat & CHAT_GHOSTRADIO))
			continue
		// --- Check for compression ---
		if(compression > 0)
			heard_gibberish += R
			continue

		//This is hacky as fuck, but I'm not going to dig into telecomms to do it all properly.
		//We can't do this via the broadcasters since Sulaco is multi-Z.
		if(display_freq == PUB_FREQ && M.loc && R.loc) //We actually have z levels to check.
			var/atom/Am = get_turf(M) //Getting turfs, just to be safe.
			var/atom/Ar = get_turf(R)
			if(!Am || !Ar || !is_mainship_level(Am.z) || !is_mainship_level(Ar.z))
				continue //If listener and receiver are on different zs, and one of those zs is 1.

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
		var/part_a = "<span class='radio'><span class='name'>" // goes in the actual output
		var/freq_text
		if(comm_title != "" && comm_title)
			freq_text = "[get_frequency_name(display_freq)] ([comm_title])"
		else
			freq_text = get_frequency_name(display_freq)

		// --- Some more pre-message formatting ---
		var/part_b_extra = ""
		if(data == 3) // intercepted radio message
			part_b_extra = " <i>(Intercepted)</i>"
		var/part_b = "</span><b> [htmlicon(radio, (heard_masked + heard_normal + heard_voice + heard_garbled + heard_gibberish))]\[[freq_text]\][part_b_extra]</b> <span class='message'>" // Tweaked for security headsets -- TLE

		// Antags!
		if (display_freq in ANTAG_FREQS)
			part_a = "<span class='syndradio'><span class='name'>"
		// centcomm channels (deathsquid and ert)
		else if (display_freq in CENT_FREQS)
			part_a = "<span class='centradio'><span class='name'>"
		// command channel
		else if (display_freq == COMM_FREQ)
			part_a = "<span class='comradio'><span class='name'>"
		// AI private channel
		else if (display_freq == AI_FREQ)
			part_a = "<span class='airadio'><span class='name'>"

		// department radio formatting (poorly optimized, ugh)
		else if (display_freq == SEC_FREQ)
			part_a = "<span class='secradio'><span class='name'>"
		else if (display_freq == ENG_FREQ)
			part_a = "<span class='engradio'><span class='name'>"
		else if (display_freq == MED_FREQ)
			part_a = "<span class='medradio'><span class='name'>"
		else if (display_freq == SUP_FREQ) // cargo
			part_a = "<span class='supradio'><span class='name'>"
		else if (display_freq == JTAC_FREQ)
			part_a = "<span class='jtacradio'><span class='name'>"
		else if (display_freq == INTEL_FREQ)
			part_a = "<span class='intelradio'><span class='name'>"
		else if (display_freq == WY_FREQ)
			part_a = "<span class='wyradio'><span class='name'>"


		else if (display_freq == ALPHA_FREQ)
			part_a = "<span class='alpharadio'><span class='name'>"
		else if (display_freq == BRAVO_FREQ)
			part_a = "<span class='bravoradio'><span class='name'>"
		else if (display_freq == CHARLIE_FREQ)
			part_a = "<span class='charlieradio'><span class='name'>"
		else if (display_freq == DELTA_FREQ)
			part_a = "<span class='deltaradio'><span class='name'>"

		// If all else fails and it's a dept_freq, color me purple!
		else if (display_freq in DEPT_FREQS)
			part_a = "<span class='deptradio'><span class='name'>"

		// --- Filter the message; place it in quotes apply a verb ---


		/* ###### Send the message ###### */

	  	/* --- Process all the mobs that heard a masked voice (understood) --- */
		if (length(heard_masked))
			for (var/mob/R in heard_masked)
				R.hear_radio(message,verbage, speaking, part_a, part_b, M, 0, name, command)

		/* --- Process all the mobs that heard the voice normally (understood) --- */
		if (length(heard_normal))
			for (var/mob/R in heard_normal)
				R.hear_radio(message, verbage, speaking, part_a, part_b, M, 0, realname, command)

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
