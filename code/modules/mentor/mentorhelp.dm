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

	// History of messages sent between the author and the mentor
	var/list/history = list()

/datum/mentorhelp/New(var/client/thread_author)
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
	history = null
	..()

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
/datum/mentorhelp/proc/check_open(var/client/C)
	if(!open)
		to_chat(C, SPAN_NOTICE("This mentorhelp thread is closed!"))
		return FALSE
	return TRUE

// Logs the mentorhelp message to admin logs
/datum/mentorhelp/proc/log_message(var/msg, var/from_key, var/to_key)
	msg = strip_html(msg)
	var/log_msg = msg
	if(from_key && to_key)
		log_msg = "[from_key] -> [to_key]: [msg]"

	log_mhelp(log_msg)
	history += log_msg

// Helper to message ONLY big boy staff
/datum/mentorhelp/proc/message_only_staff(var/msg, var/sound=FALSE, var/include_keys=FALSE, var/client/sender, var/client/recipient)
	var/list/current_staff = get_staff_by_category()
	var/list/staff = current_staff["admins"]

	if(staff.len)
		for(var/client/C in staff)
			// This big boy is mentoring the thread, so they don't need the eavesdrop as well
			if(C == mentor)
				continue

			if(sound && (C.prefs.toggles_sound & SOUND_ADMINHELP))
				sound_to(C, 'sound/effects/mhelp.ogg')

			var/mentor_msg = replacetext(copytext(msg, 1), "&&", "\ref[C]")
			// bobfuckhead/(bobfuckhead) -> johnmcsugma/(johnmcsugma): im stupid cant play game help
			var/keys = include_keys ? SPAN_NOTICE(key_name(sender, TRUE) + " -> " + key_name(recipient, TRUE) + ": ") : ""
			to_chat(C, "[keys][mentor_msg]")

// Helper to notify mentors and other staff of stuff
/datum/mentorhelp/proc/message_staff(var/msg, var/sound=FALSE)
	var/list/current_staff = get_staff_by_category()
	var/list/mentors = current_staff["mentors"]

	// Big boy staff is handling the thread and should get messages from here instead
	// They're prevented from getting messages in message_only_staff because it's used for eavesdrops
	// Basically they get treated as a mentor instead of staff when they're mentoring
	if(!(mentor in mentors))
		mentors += mentor

	if(mentors.len)
		for(var/client/C in mentors)
			if(sound && (C.prefs.toggles_sound & SOUND_ADMINHELP))
				sound_to(C, 'sound/effects/mhelp.ogg')

			var/mentor_msg = replacetext(copytext(msg, 1), "&&", "\ref[C]")
			to_chat(C, mentor_msg)

	message_only_staff(msg, sound)

// Sanitizes and wraps the message with some info and links, depending on the recipient
/datum/mentorhelp/proc/wrap_message(var/message, var/client/sender)
	// Like a good code chef, we prepare all the ingredients of the message before putting it all together
	var/message_title = "MentorPM"
	var/message_sender_key = "<a href='?_src_=mhelp;mhelp_key=[author.ckey];recipient_user=\ref[author];action=message'>[sender.key]</a>"
	var/message_sender_options = ""

	// The message is being sent to the mentor and should be formatted as a mentorhelp message
	if(sender == author)
		message_title = "MentorHelp"
		// If there's a mentor, let them mark it. If not, let them unmark it
		if(mentor)
			message_sender_key = "<a href='?_src_=mhelp;mhelp_key=[author.ckey];recipient_user=\ref[mentor];action=message'>[sender.key]</a>"
			// We pass \ref[mentor] because we want the mentor to send a message
			message_sender_options = " (<a href='?_src_=mhelp;mhelp_key=[author.ckey];recipient_user=\ref[mentor];action=unmark'>Unmark</a>"
		else
			// && is replaced by the mentor's reference in the message_staff proc
			// If you're curious why && was chosen, it's because & is HTML sanitized, so it can't be abused by skiddies
			message_sender_key = "<a href='?_src_=mhelp;mhelp_key=[author.ckey];recipient_user=&&;action=message'>[sender.key]</a>"
			message_sender_options = " (<a href='?_src_=mhelp;mhelp_key=[author.ckey];recipient_user=&&;action=mark'>Mark</a>"

		message_sender_options += " | <a href='?_src_=mhelp;mhelp_key=[author.ckey];recipient_user=[mentor ? "\ref[mentor]" : "&&"];action=close'>Close</a> | <a href='?_src_=mhelp;mhelp_key=[author.ckey];recipient_user=[mentor ? "\ref[mentor]" : "&&"];action=autorespond'>AutoResponse</a>)"

	var/message_header = "<font color='#009900'><b>[message_title] from [message_sender_key]: [message_sender_options]</b></font><br>"
	var/message_body = "&emsp;<font color='#DA6200'><b>[message]</b></font><br>"

	// Et voila! Beautiful wrapped mentorhelp messages
	return (message_header + message_body)

/*
 *    Message sending
 */

// Send a message to either the author or the mentor
/datum/mentorhelp/proc/send_message(var/client/sender, var/message, var/raw=FALSE)
	if(!message)
		return

	// Ensure the author is still around
	if(!check_author())
		return

	// Sanitize the message first
	if(!raw)
		message = strip_html(message)
	// Wrap the message with some fluffy colors and links
	var/wrapped_message = wrap_message(message, sender)

	// Set the recipient of the message
	var/client/recipient = null
	if(sender == author)
		recipient = mentor

		if(!recipient)
			// If this is intended for a mentor, but there is no mentor handling the thread, so send it to all mentors
			message_staff(wrapped_message, TRUE)
			log_message(message, sender.key, "All mentors")
			to_chat(sender, "<font color='#009900'><b>Message to mentors:</b> </font>" + message)
			add_timer(CALLBACK(src, .proc/repeat_message, sender, message, 1), MINUTES_5) //since the message has been sanitized we can set raw to 1 here.
			return
	else if(sender == mentor)
		recipient = author

	to_chat(sender, "<font color='#009900'><b>Message to [recipient.key]:</b> </font>" + message)
	to_chat(recipient, wrapped_message)
	if(recipient.prefs.toggles_sound & SOUND_ADMINHELP)
		sound_to(recipient, 'sound/effects/mhelp.ogg')

	log_message(message, sender.key, recipient.key)
	// Staff gets to eavesdrop on every message
	message_only_staff(SPAN_NOTICE(message), FALSE, TRUE, sender, recipient)

/datum/mentorhelp/proc/repeat_message(var/client/sender, var/message, var/raw=FALSE)
	if(!mentor && open)
		send_message(sender, message, raw)
// Makes the sender input a message and sends it
/datum/mentorhelp/proc/input_message(var/client/sender)
	if(!sender)
		return
	if(!check_open(sender))
		return

	if(sender != author)
		// It's not the thread author sending the message, so make sure it's a mentor/staff sending the message
		if(!AHOLD_IS_MOD(sender.admin_holder) && !AHOLD_IS_MENTOR(sender.admin_holder))
			return

		// If the mentor forgot to mark the mentorhelp, mark it for them
		if(!mentor)
			mark(sender)
		// Some other mentor is already taking care of this thread
		else if(mentor != sender)
			to_chat(sender, SPAN_NOTICE("<b>NOTICE:</b> A mentor is already handling this thread!"))
			return

	var/message = input("Please enter your message:", "Mentor Help", null, null) as message|null
	if(!message)
		open = FALSE
		return

	send_message(sender, message)

/*
 *    Marking
 */

// Marks the mentorhelp thread and notifies the author that the thread is being responded to
/datum/mentorhelp/proc/mark(var/client/thread_mentor)
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
	if(!AHOLD_IS_MOD(thread_mentor.admin_holder) && !AHOLD_IS_MENTOR(thread_mentor.admin_holder))
		return

	mentor = thread_mentor

	to_chat(author, SPAN_NOTICE("<b>NOTICE:</b> <font style='color:red;'>[mentor.key]</font> has marked your thread and is preparing to respond."))
	message_staff(SPAN_NOTICE("<b>NOTICE:</b> <font style='color:red;'>[mentor.key]</font> has marked <font style='color:red;'>[author_key]</font>'s mentorhelp."))
	log_message("[mentor.key] marked [author_key]'s mentorhelp")

// Unmarks the mentorhelp thread and notifies the author that the thread is no longer being handled by a mentor
/datum/mentorhelp/proc/unmark(var/client/thread_mentor)
	if(!check_author())
		return

	if(!check_open(thread_mentor))
		return

	// Already not marked
	if(!mentor)
		return

	// If we're not the thread mentor and not a staff member
	if((!thread_mentor || thread_mentor != mentor) && !AHOLD_IS_MOD(thread_mentor.admin_holder))
		return

	to_chat(author, SPAN_NOTICE("<b>NOTICE:</b> <font style='color:red;'>[mentor.key]</font> has unmarked your thread and is no longer responding to it."))
	message_staff(SPAN_NOTICE("<b>NOTICE:</b> <font style='color:red;'>[mentor.key]</font> has unmarked <font style='color:red;'>[author_key]</font>'s mentorhelp."))
	log_message("[mentor.key] unmarked [author_key]'s mentorhelp")
	mentor = null

/*
 *    Misc.
 */

// Closes the thread and notifies the author/mentor that it has been closed
/datum/mentorhelp/proc/close(var/client/closer)
	if(!open)
		return

	// Thread was closed because the author is gone
	if(!author)
		message_staff(SPAN_NOTICE("<b>NOTICE:</b> <font style='color:red;'>[author_key]</font>'s mentorhelp thread has been closed due to the author disconnecting."))
		log_message("[author_key]'s mentorhelp thread was closed because of a disconnection")
		return

	// Make sure it's being closed by staff or the mentor handling the thread
	if(mentor && closer && closer != mentor && !AHOLD_IS_MOD(closer.admin_holder))
		to_chat(closer, SPAN_NOTICE("<b>NOTICE:</b> Another mentor is handling this thread!"))
		return

	open = FALSE

	to_chat(author, SPAN_NOTICE("Your mentorhelp thread has been closed."))
	message_staff(SPAN_NOTICE("<b>NOTICE:</b> <font style='color:red;'>[author_key]</font>'s mentorhelp thread has been closed."))
	if(!closer)
		return

	log_message("[closer.key] closed [author_key]'s mentorhelp")

// We handle all clicks and links and yadda internally
/datum/mentorhelp/Topic(var/href, var/list/href_list)
	var/client/topic_user = locate(href_list["recipient_user"])
	if(!topic_user)
		return

	switch(href_list["action"])
		if("message")
			input_message(topic_user)
		if("autorespond")
			autoresponse(topic_user)
		if("mark")
			mark(topic_user)
		if("unmark")
			unmark(topic_user)
		if("close")
			// Via href, the only ones who can close the thread is the author, mentor or staff
			if(topic_user != author && topic_user != mentor && !AHOLD_IS_MOD(topic_user.admin_holder))
				return
			close(topic_user)

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

	if(!AHOLD_IS_MOD(responder.admin_holder) && !AHOLD_IS_MENTOR(responder.admin_holder))
		return

	// If the mentor forgot to mark the mentorhelp, mark it for them
	if(!mentor)
		mark(responder)
	else if(mentor != responder)
		to_chat(responder, SPAN_NOTICE("<b>NOTICE:</b> A mentor is already handling this thread!"))
		return

	var/choice = input("Which autoresponse option do you want to send to the player?\n\n L - A webpage link.\n A - An answer to a common question.", "Autoresponse", "--CANCEL--") in list ("--CANCEL--", "L: Discord", "L: Xeno Quickstart Guide", "L: Marine quickstart guide", "L: Current Map", "A: No plasma regen", "A: Devour as Xeno", "T: Tunnel", "E: Event in progress", "R: Radios", "B: Binoculars", "D: Joining disabled", "L: Leaving the server", "M: Macros", "C: Changelog", "H: Clear Cache")

	if(!check_author())
		return

	if(!check_open(responder))
		return

	// i mean, pretty unlikely, but still possible
	if(!AHOLD_IS_MOD(responder.admin_holder) && !AHOLD_IS_MENTOR(responder.admin_holder))
		return

	// Re-mark if they unmarked it while the dialog was open (???)
	if(!mentor)
		mark(responder)
	else if(mentor != responder)
		to_chat(responder, SPAN_NOTICE("<b>NOTICE:</b> A mentor is already handling this thread!"))
		return

	if(choice == "--CANCEL--")
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

	send_message(responder, msg, TRUE)