// Represents a mentorhelp thread
/datum/mentorhelp
	// The client/player who initiated (authored) the mentorhelp thread
	var/client/author = null
	// The author's key
	var/author_key = ""

	// The mentor who's responding to this mentorhelp thread
	// If this is null, it means no mentor has responded yet
	var/client/mentor = null

	// If this thread is still open
	var/open = TRUE

/datum/mentorhelp/New(client/thread_author)
	..()

	if(!thread_author)
		qdel(src)
		return

	// They already have a thread open
	if(thread_author.current_mhelp && thread_author.current_mhelp.open)
		qdel(src)
		return

	author = thread_author
	author_key = thread_author.key

/datum/mentorhelp/Destroy()
	author = null
	mentor = null
	return ..()

/*
 *    Helpers
 */

// Helper to check that the author is still around
// Closes the thread if they're not
/datum/mentorhelp/proc/check_author()
	if(!author)
		close()
		return FALSE
	return TRUE

// Helper to check that the thread is still open
/datum/mentorhelp/proc/check_open(client/C)
	if(!open)
		to_chat(C, SPAN_NOTICE("This mentorhelp thread is closed!"))
		return FALSE
	return TRUE

// Logs the mentorhelp message to admin logs
/datum/mentorhelp/proc/log_message(msg, from_key, to_key)
	msg = strip_html(msg)
	var/log_msg = msg
	if(from_key && to_key)
		log_msg = "[from_key] -> [to_key]: [msg]"
	log_mhelp(log_msg)

/datum/mentorhelp/proc/notify(text, to_thread_mentor = TRUE, to_mentors = TRUE, to_staff = TRUE)
	var/list/hitlist = list()
	if(to_thread_mentor && mentor)
		hitlist |= mentor
	for(var/client/candidate in GLOB.admins)
		if(to_mentors && CLIENT_HAS_RIGHTS(candidate, R_MENTOR))
			hitlist |= candidate
		else if(to_staff && CLIENT_IS_STAFF(candidate))
			hitlist |= candidate
	var/displaymsg = "<span class='admin'><span class='prefix'>MENTOR LOG:</span> <span class='message'>[text]</span></span>"
	for(var/client/receiver in hitlist)
		if(istype(receiver))
			to_chat(receiver, displaymsg)

/datum/mentorhelp/proc/broadcast_request(client/opener)
	if(!opener || !open || !check_author())
		return FALSE // Invalid
	if(mentor)
		return TRUE // No need

	var/message = strip_html(input("Please enter your message:", "Mentor Help"))
	if(!message)
		return FALSE
	broadcast_unhandled(message, opener)
	return TRUE

/datum/mentorhelp/proc/broadcast_unhandled(msg, client/sender)
	if(!mentor && open)
		message_handlers(msg, sender)
		addtimer(CALLBACK(src, .proc/broadcast_unhandled, msg, sender), 5 MINUTES)

/datum/mentorhelp/proc/message_handlers(msg, client/sender, client/recipient, with_sound = TRUE, staff_only = FALSE, include_keys = TRUE)
	if(!sender || !check_author())
		return

	if(recipient?.key)
		log_message(msg, sender.key, recipient.key)
	else
		log_message(msg, sender.key, "All mentors")

	// Sender feedback
	to_chat(sender, "<font color='#009900'><b>Message to [(recipient?.key) ? recipient.key : "mentors"]:</b> </font> [msg]")

	// Recipient direct message
	if(recipient)
		if(with_sound && (recipient.prefs?.toggles_sound & SOUND_ADMINHELP))
			sound_to(recipient, 'sound/effects/mhelp.ogg')
		to_chat(recipient, wrap_message(msg, sender))

	for(var/client/C in GLOB.admins)
		var/formatted = msg
		var/soundfile

		if(!C || C == recipient)
			continue

		// Initial broadcast
		else if(!staff_only && !recipient && CLIENT_HAS_RIGHTS(C, R_MENTOR))
			formatted = wrap_message(formatted, sender)
			soundfile = 'sound/effects/mhelp.ogg'

		// Staff eavesdrop
		else if(CLIENT_HAS_RIGHTS(C, R_MENTOR) && CLIENT_IS_STAFF(C))
			if(include_keys)
				formatted = SPAN_NOTICE(key_name(sender, TRUE) + " -> " + key_name(recipient, TRUE) + ": ") + msg

		else continue

		if(soundfile && with_sound && (C.prefs?.toggles_sound & SOUND_ADMINHELP))
			sound_to(C, soundfile)
		to_chat(C, formatted)
	return

// Makes the sender input a message and sends it
/datum/mentorhelp/proc/input_message(client/sender)
	if(!sender || !check_open(sender))
		return
	if(sender != author)
		if(!CLIENT_HAS_RIGHTS(sender, R_MENTOR))
			return

		// If the mentor forgot to mark the mentorhelp, mark it for them
		if(!mentor)
			mark(sender)

		// Some other mentor is already taking care of this thread
		else if(mentor != sender)
			to_chat(sender, SPAN_NOTICE("<b>NOTICE:</b> A mentor is already handling this thread!"))
			return
	
	var/target = mentor
	if(sender == mentor)
		target = author

	var/message = input("Please enter your message:", "Mentor Help", null, null) as message|null
	if(message)
		message = strip_html(message)
		message_handlers(message, sender, target)
	return

// Sanitizes and wraps the message with some info and links, depending on the sender...?
/datum/mentorhelp/proc/wrap_message(message, client/sender)
	var/message_title = "MentorPM"
	var/message_sender_key = "<a href='?src=\ref[src];action=message'>[sender.key]</a>"
	var/message_sender_options = ""

	// The message is being sent to the mentor and should be formatted as a mentorhelp message
	if(sender == author)
		message_title = "MentorHelp"
		// If there's a mentor, let them mark it. If not, let them unmark it
		if(mentor)
			message_sender_options = " (<a href='?src=\ref[src];action=unmark'>Unmark</a>"
		else
			message_sender_options = " (<a href='?src=\ref[src];action=mark'>Mark</a>"
		message_sender_options += " | <a href='?src=\ref[src];action=close'>Close</a> | <a href='?src=\ref[src];action=autorespond'>AutoResponse</a>)"

	var/message_header = "<font color='#009900'><b>[message_title] from [message_sender_key]: [message_sender_options]</b></font><br>"
	var/message_body = "&emsp;<font color='#DA6200'><b>[message]</b></font><br>"

	// Et voila! Beautiful wrapped mentorhelp messages
	return (message_header + message_body)

/*
 *    Marking
 */

// Marks the mentorhelp thread and notifies the author that the thread is being responded to
/datum/mentorhelp/proc/mark(client/thread_mentor)
	if(!check_author())
		return

	if(!check_open(thread_mentor))
		return

	// Already marked
	if(mentor)
		to_chat(thread_mentor, SPAN_NOTICE("<b>NOTICE:</b> A mentor is already handling this thread!"))
		return

	if(!thread_mentor)
		return

	// Not a mentor/staff
	if(!CLIENT_HAS_RIGHTS(thread_mentor, R_MENTOR))
		return

	mentor = thread_mentor

	log_mhelp("[mentor.key] has marked [author_key]'s mentorhelp")
	notify("<font style='color:red;'>[mentor.key]</font> has marked <font style='color:red;'>[author_key]</font>'s mentorhelp.")
	to_chat(author, SPAN_NOTICE("<b>NOTICE:</b> <font style='color:red;'>[mentor.key]</font> has marked your thread and is preparing to respond."))

// Unmarks the mentorhelp thread and notifies the author that the thread is no longer being handled by a mentor
/datum/mentorhelp/proc/unmark(client/thread_mentor)
	if(!check_author())
		return

	if(!check_open(thread_mentor))
		return

	// Already not marked
	if(!mentor)
		return

	// If we're not the thread mentor and not a staff member
	if((!thread_mentor || thread_mentor != mentor) && !CLIENT_IS_STAFF(thread_mentor))
		return

	log_mhelp("[mentor.key] has unmarked [author_key]'s mentorhelp")
	notify("<font style='color:red;'>[mentor.key]</font> has unmarked <font style='color:red;'>[author_key]</font>'s mentorhelp.")
	to_chat(author, SPAN_NOTICE("<b>NOTICE:</b> <font style='color:red;'>[mentor.key]</font> has unmarked your thread and is no longer responding to it."))
	mentor = null

/*
 *    Misc.
 */

// Closes the thread and notifies the author/mentor that it has been closed
/datum/mentorhelp/proc/close(client/closer)
	if(!open)
		return

	// Thread was closed because the author is gone
	if(!author)
		notify("<font style='color:red;'>[author_key]</font>'s mentorhelp thread has been closed due to the author disconnecting.")
		log_mhelp("[author_key]'s mentorhelp thread was closed because of a disconnection")
		return

	// Make sure it's being closed by staff or the mentor handling the thread
	if(mentor && closer && (closer != mentor) && (closer != author) && !CLIENT_IS_STAFF(closer))
		to_chat(closer, SPAN_NOTICE("<b>NOTICE:</b> Another mentor is handling this thread!"))
		return

	open = FALSE
	if(closer)
		log_mhelp("[closer.key] closed [author_key]'s mentorhelp")
		if(closer == author)
			to_chat(author, SPAN_NOTICE("You have closed your mentorhelp thread."))
			notify("<font style='color:red;'>[author_key]</font> closed their mentorhelp thread.")
			return
	to_chat(author, SPAN_NOTICE("Your mentorhelp thread has been closed."))
	notify("<font style='color:red;'>[author_key]</font>'s mentorhelp thread has been closed.")

/datum/mentorhelp/Topic(href, list/href_list)
	if(!usr)
		return
	var/client/C = usr.client
	if(!istype(C))
		return

	switch(href_list["action"])
		if("message")
			input_message(C)
		if("autorespond")
			autoresponse(C)
		if("mark")
			mark(C)
		if("unmark")
			unmark(C)
		if("close")
			if(C == author || C == mentor || CLIENT_IS_STAFF(C))
				close(C)

/*
 *    Autoresponse
 *    Putting this here cause it's long and ugly
 */

// responder is the guy responding to the thread, i.e. the mentor triggering the autoresponse
/datum/mentorhelp/proc/autoresponse(var/client/responder)
	if(!check_author())
		return

	if(!check_open(responder))
		return

	if(!CLIENT_HAS_RIGHTS(responder, R_MENTOR))
		return

	// If the mentor forgot to mark the mentorhelp, mark it for them
	if(!mentor)
		mark(responder)
	else if(mentor != responder)
		to_chat(responder, SPAN_NOTICE("<b>NOTICE:</b> A mentor is already handling this thread!"))
		return

	var/choice = tgui_input_list(usr, "Which autoresponse option do you want to send to the player?\n\n L - A webpage link.\n A - An answer to a common question.", "Autoresponse", list ("L: Discord", "L: Xeno Quickstart Guide", "L: Marine Quickstart Guide", "L: Current Map", "A: No plasma regen", "A: Devour as Xeno", "T: Tunnel", "E: Event in progress", "R: Radios", "B: Binoculars", "D: Joining disabled", "L: Leaving the server", "M: Macros", "C: Changelog", "H: Clear Cache"))
	if(!choice)
		return

	if(!check_author())
		return

	if(!check_open(responder))
		return

	if(!CLIENT_HAS_RIGHTS(responder, R_MENTOR))
		return

	// Re-mark if they unmarked it while the dialog was open (???)
	if(!mentor)
		mark(responder)
	else if(mentor != responder)
		to_chat(responder, SPAN_NOTICE("<b>NOTICE:</b> A mentor is already handling this thread!"))
		return

	var/msg = "Autoresponse: <font color='#009900'>'[choice]'</font>. "
	switch(choice)
		if("L: Discord")
			msg += "You can join our Discord server by using <a href='https://discordapp.com/invite/TByu8b5'>this link</a>!"
		if("L: Xeno Quickstart Guide")
			msg += "Your answer can be found on the Xeno Quickstart Guide on our wiki. <a href='[URL_WIKI_XENO_QUICKSTART]'>Check it out here.</a>"
		if("L: Marine Quickstart Guide")
			msg += "Your answer can be found on the Marine Quickstart Guide on our wiki. <a href='[URL_WIKI_MARINE_QUICKSTART]'>Check it out here.</a>"
		if("L: Current Map")
			msg += "If you need a map overview of the current round, use Current Map verb in OOC tab to check name of the map. Then open our <a href='[URL_WIKI_LANDING]'>wiki front page</a> and look for the map overview in the 'Maps' section. If the map is not listed, it's a new or rare map and the overview hasn't been finished yet."
		if("A: No plasma regen")
			msg += "If you have low/no plasma regen, it's most likely because you are off weeds or are currently using a passive ability, such as the Runner's 'Hide' or emitting a pheromone."
		if("A: Devour as Xeno")
			msg += "Devouring is useful to quickly transport incapacitated hosts from one place to another. In order to devour a host as a Xeno, grab the mob (CTRL+Click) and then click on yourself to begin devouring. The host can break out of your belly, which will result in your death so make sure your target is incapacitated. After approximately 1 minute host will be automatically regurgitated. To release your target voluntary, click 'Regurgitate' on the HUD to throw them back up."
		if("T: Tunnel")
			msg += "Click on the tunnel to enter it. While being in the tunnel, Alt + Click it to exit, Ctrl + Click to choose a destination."
		if("E: Event in progress")
			msg += "There is currently a special event running and many things may be changed or different, however normal rules still apply unless you have been specifically instructed otherwise by a staff member."
		if("R: Radios")
			msg += "Take your headset in hand and activate it by clicking it or pressing \"Page Down\" or \"Z\" (in Hotkey Mode). This will open window with all available channels, which also contains channel keys. Marine headsets have their respective squad channels available on \";\" key. Ship crew headsets have access to the Almayer public comms on \";\" and their respective department channel on \":h\"."
		if("B: Binoculars")
			msg += "Binoculars allow you to increase distance of your view in direction you are looking. To zoom in, take them into your hand and activate them by pressing \"Page Down\" or \"Z\" (in Hotkey Mode) or clicking them while they are in your hand.\nRangefinders allow you to get tile coordinates (longitude and latitude) by lasing it while zoomed in (produces a GREEN laser). Ctrl + Click on any open tile to start lasing. Ctrl + Click on your rangefinders to stop lasing without zooming out. Coordinates can be used by Staff Officers to send supply drops or to perform Orbital Bombardment. You also can use them to call mortar fire if there are engineers with a mortar. \nLaser Designators have a second mode (produces a RED laser) that allows highlighting targets for Close Air Support performed by dropship pilots. They also have a fixed ID number that is shown on the pilot's weaponry console. Examine the laser designator to check its ID. Red laser must be maintained as long as needed in order for the dropship pilot to bomb the designated area. To switch between lasing modes, Alt + Click the laser designator. Alternatively, Right + Click it in hand and click \"Toggle Mode\"."
		if("D: Joining disabled")
			msg += "Joining for new players is disabled for the current round due to either a staff member or and automatic setting during the end of the round. You can observe while it ends and wait for a new round to start."
		if("L: Leaving the server")
			msg += "If you need to leave the server as a marine, either go to cryo or ask someone to cryo you before leaving. If you are a xenomorph, find a safe place to rest and ghost before leaving, that will instantly unlock your xeno for observers to join."
		if("M: Macros")
			msg += "This <a href='[URL_WIKI_MACROS]'>guide</a> explains how to set up macros including examples of most common and useful ones."
		if("C: Changelog")
			msg += "The answer to your question can be found in the changelog. Click the changelog button at the top-right of the screen to view it in-game, or visit <a href='[URL_CHANGELOG]'>changelog page</a> on our wiki instead."
		if("H: Clear Cache")
			msg += "In order to clear cache, you need to click on gear icon located in upper-right corner of your BYOND client and select preferences. Switch to Games tab and click Clear Cache button. In some cases you need to manually delete cache. To do that, select Advanced tab and click Open User Directory and delete \"cache\" folder there."
	msg = SPAN_NOTICE(msg)
	message_handlers(msg, responder, author)
