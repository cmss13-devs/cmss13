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

/datum/mentorhelp/Dispose()
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
	msg = sanitize(copytext(msg, 1, MAX_MESSAGE_LEN))
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
		message = sanitize(copytext(message, 1, MAX_MESSAGE_LEN))

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

// Makes the sender input a message and sends it
/datum/mentorhelp/proc/input_message(var/client/sender)
	if(!sender)
		return
	if(!check_open(sender))
		return

	if(sender != author)
		// It's not the thread author sending the message, so make sure it's a mentor/staff sending the message
		if(!sender.admin_holder || !(sender.admin_holder.rights & (R_MENTOR|R_MOD)))
			return

		// If the mentor forgot to mark the mentorhelp, mark it for them
		if(!mentor)
			mark(sender)
		// Some other mentor is already taking care of this thread
		else if(mentor != sender)
			to_chat(sender, SPAN_NOTICE("<b>NOTICE:</b> A mentor is already handling this thread!"))
			return

	var/message = input("Please enter your message:", "Mentor Help", null, null) as message|null

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
	if(!thread_mentor.admin_holder || !(thread_mentor.admin_holder.rights & (R_MENTOR|R_MOD)))
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
	if((!thread_mentor || thread_mentor != mentor) && !(thread_mentor.admin_holder && thread_mentor.admin_holder.rights & R_MOD))
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
	if(mentor && closer != mentor && !(closer.admin_holder && closer.admin_holder.rights & R_MOD))
		to_chat(closer, SPAN_NOTICE("<b>NOTICE:</b> Another mentor is handling this thread!"))
		return

	open = FALSE

	to_chat(author, SPAN_NOTICE("Your mentorhelp thread has been closed."))
	message_staff(SPAN_NOTICE("<b>NOTICE:</b> <font style='color:red;'>[author_key]</font>'s mentorhelp thread has been closed."))
	log_message("[mentor.key] closed [author_key]'s mentorhelp")

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
			var/is_staff = topic_user.admin_holder && (topic_user.admin_holder.rights & R_MOD)
			if(topic_user != author && topic_user != mentor && !is_staff)
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

	if(!responder.admin_holder || !(responder.admin_holder.rights & (R_MENTOR|R_MOD)))
		return

	// If the mentor forgot to mark the mentorhelp, mark it for them
	if(!mentor)
		mark(responder)
	else if(mentor != responder)
		to_chat(responder, SPAN_NOTICE("<b>NOTICE:</b> A mentor is already handling this thread!"))
		return

	var/choice = input("Which autoresponse option do you want to send to the player?\n\n L - A webpage link.\n A - An answer to a common question.", "Autoresponse", "--CANCEL--") in list ("--CANCEL--", "L: Discord", "L: Xeno Quickstart Guide", "L: Marine quickstart guide", "L: Current Map", "A: No plasma regen", "A: Devour as Xeno", "E: Event in progress", "R: Radios", "B: Binoculars", "D: Joining disabled", "L: Leaving the server", "M: Macros", "C: Changelog")

	if(!check_author())
		return

	if(!check_open(responder))
		return

	// i mean, pretty unlikely, but still possible
	if(!responder.admin_holder || !(responder.admin_holder.rights & (R_MENTOR|R_MOD)))
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
			msg += "Your answer can be found on the Xeno Quickstart Guide on our wiki. <a href='http://cm-ss13.com/wiki/Xeno_Quickstart_Guide'>Check it out here.</a>"
		if("L: Marine quickstart guide")
			msg += "Your answer can be found on the Marine Quickstart Guide on our wiki. <a href='http://cm-ss13.com/wiki/Marine_Quickstart_Guide'>Check it out here.</a>"
		if("L: Current Map")
			msg += "If you need a map to the current game, you can (usually) find them on the front page of our wiki in the 'Maps' section. <a href='http://cm-ss13.com/wiki/Main_Page'>Check it out here.</a> If the map is not listed, it's a new or rare map and the overview hasn't been finished yet."
		if("A: No plasma regen")
			msg += "If you have low/no plasma regen, it's most likely because you are off weeds or are currently using a passive ability, such as the Runner's 'Hide' or emitting a pheromone."
		if("A: Devour as Xeno")
			msg += "Devouring is useful to quickly transport incapacitated hosts from one place to another. In order to devour a host as a Xeno, grab the mob (CTRL+Click) and then click on yourself to begin devouring. The host can resist by breaking out of your belly, so make sure your target is incapacitated, or only have them devoured for a short time. To release your target, click 'Regurgitate' on the HUD to throw them back up."
		if("E: Event in progress")
			msg += "There is currently a special event running and many things may be changed or different, however normal rules still apply unless you have been specifically instructed otherwise by a staff member."
		if("R: Radios")
			msg += "Radios have been changed, the prefix for all squad marines is now ; to access your squad radio. Squad Medics have access to the medical channel using :m, Engineers have :e and the (acting) Squad Leader has :v for command.  Examine your radio headset to get a listing of the channels you have access to."
		if("B: Binoculars")
			msg += "To use your binoculars, take them into your hand and activate them by using Z (Hotkey Mode). Ctrl + Click on any open tile to set a laser. To switch between the lasers, Right Click the Binoculars in hand and press toggle mode or Alt + Click them. The Red laser is a CAS marker for pilots to fire upon, it must be held for the Pilot to drop ordinance on it. The green laser is a coordinate marker that will give you a longitude and a latitude to give to your Staff Officer and Requisitions Staff. They will give you access to a devastating Orbital Bombardment or to drop supplies for you and your squad. Your squad engineers can also use the coordinates to drop mortar shells on top of your enemies."
		if("D: Joining disabled")
			msg += "A staff member has disabled joining for new players as the current round is coming to an end, you can observe while it ends and wait for a new round to start."
		if("L: Leaving the server")
			msg += "If you need to leave the server as a marine, either go to cryo or ask someone to cryo you before leaving. If you are a xenomorph, find a safe place to rest and ghost before leaving."
		if("M: Macros")
			msg += "To set a macro right click the title bar, select Client->Macros. Binding unique-action to a key is useful for pumping shotguns etc; Binding load-from-attachment will activate any scopes etc; Binding resist and give to seperate keys is also handy. For more information on macros, head over to our guide, at: http://cm-ss13.com/wiki/Macros"
		if("C: Changelog")
			msg += "The answer to your question can be found in the changelog. Click the changelog button at the top-right of the screen to view it in-game, or visit https://cm-ss13.com/changelog/ to open it in your browser instead."
	msg = SPAN_NOTICE(msg)

	send_message(responder, msg, TRUE)