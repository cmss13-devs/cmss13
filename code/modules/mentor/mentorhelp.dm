
GLOBAL_DATUM_INIT(mentorhelp_manager, /datum/mentorhelp_manager, new)

/datum/mentorhelp_manager
	var/list/active_tickets = list()
	var/list/archived_tickets = list()
	var/ticket_counter = 1

/datum/mentorhelp_manager/proc/get_ticket_by_id(id)
	if(active_tickets["[id]"])
		return active_tickets["[id]"]
	return archived_tickets["[id]"]

/datum/mentorhelp_manager/proc/get_active_ticket_by_ckey(ckey)
	if(!ckey)
		return null
	for(var/id in active_tickets)
		var/datum/mentorhelp/MH = active_tickets[id]
		if(MH && ckey(MH.author_key) == ckey)
			return MH
	return null

/datum/mentorhelp_manager/proc/create_ticket(client/author, message)
	var/datum/mentorhelp/MH = new(author)
	MH.initial_message = message
	MH.latest_message = message
	author.current_mhelp = MH
	return MH

// Represents a mentorhelp thread
/datum/mentorhelp
	var/id = 0

	// The client/player who initiated (authored) the mentorhelp thread
	var/client/author = null
	// The author's key
	var/author_key = ""

	// The mentor who's responding to this mentorhelp thread
	// If this is null, it means no mentor has responded yet
	var/client/mentor = null

	// If this thread is still open
	var/open = TRUE
	var/initial_message = ""
	var/latest_message = ""
	var/subject = ""
	var/list/ticket_interactions = list()

	var/opened_at = ""
	var/closed_at = ""

	var/time_activity = list("opened_at" = null, "closed_at" = null)

/datum/mentorhelp/New(client/thread_author)
	..()

	if(!thread_author)
		qdel(src)
		return

	var/datum/mentorhelp/existing = GLOB.mentorhelp_manager.get_active_ticket_by_ckey(thread_author.ckey)
	if(existing)
		to_chat(thread_author, SPAN_WARNING("You already have an active mentor help ticket. Please wait for a mentor to respond."))
		qdel(src)
		return

	opened_at = world.time
	time_activity["opened_at"] = "[worldtime2text(opened_at)]"

	author = thread_author
	author_key = thread_author.key
	id = GLOB.mentorhelp_manager.ticket_counter++

	GLOB.mentorhelp_manager.active_tickets["[id]"] = src

/datum/mentorhelp/Destroy()
	if(open && GLOB.mentorhelp_manager.active_tickets["[id]"] == src)
		GLOB.mentorhelp_manager.active_tickets -= "[id]"
	else if(GLOB.mentorhelp_manager.archived_tickets["[id]"] == src)
		GLOB.mentorhelp_manager.archived_tickets -= "[id]"

	author.current_mhelp = null
	author = null
	mentor = null
	return ..()

/*
 * Helpers
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

/datum/mentorhelp/proc/log_message(msg, from_key, to_key, include_in_ticket = TRUE, plain_msg = null, message_type = "mentor")
	var/plain_text = plain_msg || strip_html(msg)
	var/log_msg = plain_text

	var/html_msg = msg
	if(!plain_msg)
		html_msg = "[SPAN_MENTORHELP("[from_key] -> [to_key]:")] [msg]"
	else if(from_key && to_key)
		html_msg = "[SPAN_MENTORHELP("[from_key] -> [to_key]:")] [plain_text]"

	if(from_key && to_key)
		log_msg = "[from_key] -> [to_key]: [plain_text]"
	log_mhelp(log_msg)

	if(include_in_ticket)
		var/html_message = "[time_stamp()]: [html_msg]"
		var/list/structured_data = list(
			"timestamp" = worldtime2text(world.time),
			"author" = from_key || "System",
			"message" = plain_text,
			"html_message" = html_msg,
			"type" = message_type
		)

		ticket_interactions[html_message] = structured_data

		latest_message = plain_text

/datum/mentorhelp/proc/notify(text, to_thread_mentor = TRUE, to_mentors = TRUE, to_staff = TRUE, unformatted_text = null)
	var/list/hitlist = list()
	if(to_thread_mentor && mentor)
		hitlist |= mentor
	for(var/client/candidate in GLOB.admins)
		if(to_mentors && CLIENT_IS_MENTOR(candidate))
			hitlist |= candidate
		else if(to_staff && CLIENT_IS_STAFF(candidate))
			hitlist |= candidate
	var/displaymsg = "[SPAN_MENTORHELP("<span class='prefix'>MENTOR LOG:</span> <span class='message'>[text]</span>")]"
	var/html_message = "[time_stamp()]: [text]"
	var/list/structured_data = list(
		"timestamp" = worldtime2text(world.time),
		"author" = "System",
		"message" = unformatted_text || text,
		"type" = "system"
	)
	ticket_interactions[html_message] = structured_data
	for(var/client/receiver in hitlist)
		if(istype(receiver))
			to_chat(receiver, displaymsg)

	if(!to_mentors)
		latest_message = unformatted_text

/datum/mentorhelp/proc/broadcast_request(client/opener)
	if(!opener || !open || !check_author())
		return FALSE // Invalid
	if(mentor)
		return TRUE // No need

	var/message = strip_html(
			tgui_input_text(opener, "Please enter your message:", "MentorHelp", null, 500, TRUE)
		)
	if(!message)
		return FALSE
	if(!initial_message)
		initial_message = message

	latest_message = message

	broadcast_unhandled(message, opener)
	return TRUE

/datum/mentorhelp/proc/broadcast_unhandled(msg, client/sender)
	if(!mentor && open)
		message_handlers(msg, sender)
		addtimer(CALLBACK(src, PROC_REF(broadcast_unhandled), msg, sender), 5 MINUTES)

/datum/mentorhelp/proc/message_handlers(msg, client/sender, client/recipient, with_sound = TRUE, staff_only = FALSE, include_keys = TRUE)
	if(!sender || !check_author())
		return

	var/msg_type = "mentor"
	if(sender == author)
		msg_type = "legacy"
	else if(!sender)
		msg_type = "system"

	if(recipient?.key)
		log_message(msg, sender.key, recipient.key, msg_type)
	else
		log_message(msg, sender.key, "All mentors", msg_type)

	// Sender feedback
	to_chat(sender, "[SPAN_MENTORHELP("<span class='prefix'>MentorHelp:</span> Message to [(recipient?.key) ? "<a href='byond://?src=\ref[src];action=message'>[recipient.key]</a>" : "mentors"]:")] [SPAN_MENTORBODY(msg)]")

	// Recipient direct message
	if(recipient)
		if(with_sound && (recipient.prefs?.toggles_sound & SOUND_ADMINHELP))
			sound_to(recipient, 'sound/effects/mhelp.ogg')
		to_chat(recipient, wrap_message(msg, sender))

	for(var/client/admin_client in GLOB.admins)
		var/formatted = msg
		var/soundfile

		if(!admin_client || admin_client == recipient)
			continue

		// Initial broadcast
		else if(!staff_only && !recipient && CLIENT_HAS_RIGHTS(admin_client, R_MENTOR))
			formatted = wrap_message(formatted, sender)
			soundfile = 'sound/effects/mhelp.ogg'

		// Eavesdrop
		else if(CLIENT_HAS_RIGHTS(admin_client, R_MENTOR) && (!staff_only || CLIENT_IS_STAFF(admin_client)) && admin_client != sender)
			if(include_keys)
				formatted = SPAN_MENTORHELP(key_name(sender, TRUE) + " -> " + key_name(recipient, TRUE) + ": ") + msg

		else
			continue

		if(soundfile && with_sound && (admin_client.prefs?.toggles_sound & SOUND_ADMINHELP))
			sound_to(admin_client, soundfile)
		to_chat(admin_client, formatted)
	return

// Makes the sender input a message and sends it
/datum/mentorhelp/proc/input_message(client/sender)
	if(!sender || !check_open(sender))
		return

	if(sender != author)
		if(!CLIENT_IS_MENTOR(sender))
			return

		// If the mentor forgot to mark the mentorhelp, mark it for them
		if(!mentor)
			mark(sender)

		// Some other mentor is already taking care of this thread
		else if(mentor != sender)
			to_chat(sender, SPAN_MENTORHELP("<b>NOTICE:</b> A mentor is already handling this thread!"))
			return

	var/target = mentor
	if(sender == mentor)
		target = author

	var/message = tgui_input_text(sender, "Please enter your message:", "Mentor Help", null, null, TRUE)
	if(message)
		message = strip_html(message)
		message_handlers(message, sender, target)
	return

// Sanitizes and wraps the message with some info and links, depending on the sender...?
/datum/mentorhelp/proc/wrap_message(message, client/sender)
	var/message_title = "MentorPM"
	var/message_sender_key = "<a href='byond://?src=\ref[src];action=message'>[sender.key]</a>"
	var/message_sender_options = ""

	// The message is being sent to the mentor and should be formatted as a mentorhelp message
	if(sender == author)
		message_title = "MentorHelp"
		// If there's a mentor, let them mark it. If not, let them unmark it
		message_sender_options = " (<a href='byond://?src=\ref[src];action=mark'>Mark/Unmark</a>"
		message_sender_options += " | <a href='byond://?src=\ref[src];action=close'>Close</a> | <a href='byond://?src=\ref[src];action=autorespond'>AutoResponse</a>)"

	var/message_header = SPAN_MENTORHELP("<span class='prefix'>[message_title] from [message_sender_key]:</span> <span class='message'>[message_sender_options]</span><br>")
	var/message_body = "&emsp;[SPAN_MENTORBODY("<span class='message'>[message]</span>")]<br>"
	// Et voila! Beautiful wrapped mentorhelp messages
	return (message_header + message_body)

/*
 * Marking
 */

// Marks the mentorhelp thread and notifies the author that the thread is being responded to
/datum/mentorhelp/proc/mark(client/thread_mentor)
	if(!check_author())
		return

	if(!check_open(thread_mentor))
		return

	// Already marked
	if(mentor)
		if(mentor == thread_mentor)
			to_chat(thread_mentor, SPAN_MENTORHELP("<b>NOTICE:</b> You are already handling this thread!"))
			return
		var/choice = tgui_alert(thread_mentor, "This mentorhelp is already claimed by [mentor.key]. Do you want to override and take over?", "Claim Mentorhelp", list("Override", "Cancel"))
		if(choice != "Override")
			return
		var/client/prev_mentor = mentor
		mentor = thread_mentor

		log_mhelp("[mentor.key] has overridden [prev_mentor.key] on [author_key]'s mentorhelp")
		notify(SPAN_MENTORHELP("[mentor.key] has overridden [prev_mentor.key] on [author_key]'s mentorhelp."),
			unformatted_text = "[mentor.key] has overridden [prev_mentor.key] on [author_key]'s mentorhelp.")
		to_chat(author, SPAN_MENTORHELP("NOTICE: [mentor.key] has taken over your thread and is preparing to respond."))
		return

	if(!thread_mentor)
		return

	// Not a mentor/staff
	if(!CLIENT_IS_MENTOR(thread_mentor))
		return

	mentor = thread_mentor

	log_mhelp("[mentor.key] has marked [author_key]'s mentorhelp")
	notify(SPAN_MENTORHELP("[mentor.key] has marked [author_key]'s mentorhelp."),
		unformatted_text = "[mentor.key] has marked [author_key]'s mentorhelp.")
	to_chat(author, SPAN_MENTORHELP("NOTICE: [mentor.key] has marked your thread and is preparing to respond."))

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
	notify(SPAN_MENTORHELP("[mentor.key] has unmarked [author_key]'s mentorhelp."),
		unformatted_text = "[mentor.key] has unmarked [author_key]'s mentorhelp.")
	to_chat(author, SPAN_MENTORHELP("NOTICE: [mentor.key] has unmarked your thread and is no longer responding to it."))
	mentor = null

/*
 * Misc.
 */

/datum/mentorhelp/proc/reopen()
	if(!check_author())
		return

	if(open)
		to_chat(usr, SPAN_WARNING("This ticket is already open!"))
		return

	if(GLOB.mentorhelp_manager.get_active_ticket_by_ckey(author_key))
		to_chat(usr, SPAN_WARNING("This user already has an open mentor ticket. Please close it first or use the existing one."), confidential = TRUE)
		return FALSE


	if(!author && author_key)
		for(var/client/C in GLOB.clients)
			if(C.ckey == author_key)
				author = C
				break

	var/datum/mentorhelp/existing_mh = GLOB.mentorhelp_manager.get_active_ticket_by_ckey(author_key)
	if(existing_mh && existing_mh != src)
		if(tgui_alert(usr, "[author_key] already has an open mentorhelp thread. Would you like to close it and reopen this one?", "Existing Mentorhelp Found", list("Yes", "No")) == "Yes")
			existing_mh.close(usr.client)
		else
			to_chat(usr, SPAN_NOTICE("Using the existing mentorhelp thread for [author_key]."), confidential = TRUE)
			return FALSE

	open = TRUE
	closed_at = null
	time_activity["closed_at"] = null


	if(GLOB.mentorhelp_manager.archived_tickets["[id]"] == src)
		GLOB.mentorhelp_manager.archived_tickets -= "[id]"
		GLOB.mentorhelp_manager.active_tickets["[id]"] = src

	if(author)
		author.current_mhelp = src

	log_mhelp("[usr.key] reopened [author_key]'s mentorhelp thread")
	notify("<font style='color:green;'>[usr.key]</font> has reopened this mentorhelp thread.",
		unformatted_text = "[usr.key] has reopened this mentorhelp thread.")

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
		to_chat(closer, SPAN_MENTORHELP("<b>NOTICE:</b> Another mentor is handling this thread!"))
		return

	if(!open)
		return

	mentor = null
	open = FALSE

	if(GLOB.mentorhelp_manager.active_tickets["[id]"] == src)
		GLOB.mentorhelp_manager.active_tickets -= "[id]"
		GLOB.mentorhelp_manager.archived_tickets["[id]"] = src

	if(closer)
		log_mhelp("[closer.key] closed [author_key]'s mentorhelp")
		if(closer == author)
			to_chat(author, SPAN_NOTICE("You have closed your mentorhelp thread."))
			notify("<font style='color:red;'>[author_key]</font> closed their mentorhelp thread.",
				unformatted_text = "[author_key] closed their mentorhelp thread.")
			return
	to_chat(author, SPAN_NOTICE("Your mentorhelp thread has been closed."))
	notify("<font style='color:red;'>[author_key]</font>'s mentorhelp thread has been closed.",
			unformatted_text = "[author_key]'s mentorhelp thread has been closed.")
	closed_at = world.time
	time_activity["closed_at"] = "[worldtime2text(closed_at)]"

	// Clear the client reference if they're still connected
	if(author && author.current_mhelp == src)
		author.current_mhelp = null

/datum/mentorhelp/proc/Respond(msg, client/mentor)
	if(!check_author())
		return

	if(!check_open())
		return

	if(!CLIENT_IS_MENTOR(mentor))
		return

	message_handlers(msg, mentor, author)

	return TRUE

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
			if(!mentor)
				mark(C)
			else
				unmark(C)
		if("close")
			if(C == author || C == mentor || CLIENT_IS_STAFF(C))
				close(C)

/*
 * Autoresponse
 * Putting this here cause it's long and ugly
 */

// responder is the guy responding to the thread, i.e. the mentor triggering the autoresponse
/datum/mentorhelp/proc/autoresponse(client/responder)
	if(!check_author())
		return

	if(!check_open(responder))
		return

	if(!CLIENT_IS_MENTOR(responder))
		return

	// If the mentor forgot to mark the mentorhelp, mark it for them
	if(!mentor)
		mark(responder)
	else if(mentor != responder)
		to_chat(responder, SPAN_NOTICE("<b>NOTICE:</b> A mentor is already handling this thread!"))
		return

	var/choice = tgui_input_list(usr, "Which autoresponse option do you want to send to the player?", "Autoresponse", GLOB.mentorreplies)
	var/datum/autoreply/mentor/response = GLOB.mentorreplies[choice]

	if(!response || !istype(response))
		return

	if(!check_author())
		return

	if(!check_open(responder))
		return

	if(!CLIENT_IS_MENTOR(responder))
		return

	// Re-mark if they unmarked it while the dialog was open (???)
	if(!mentor)
		mark(responder)
	else if(mentor != responder)
		to_chat(responder, SPAN_NOTICE("<b>NOTICE:</b> A mentor is already handling this thread!"))
		return

	var/msg = "- MentorHelp marked as [response.title]! -"
	msg += "[response.message]"

	message_handlers(msg, responder, author)


/proc/message_mentors(message)
	for(var/client/C in GLOB.clients)
		if(CLIENT_IS_MENTOR(C))
			to_chat(C, message)
	return TRUE

/proc/mentorhelp_by_id(id)
	if(!id)
		return null
	return GLOB.mentorhelp_manager.get_ticket_by_id(id)


/datum/mentorhelp/proc/set_subject(subject, client/responder)
	if(!CLIENT_IS_MENTOR(responder))
		return
	src.subject = sanitize(subject)
	return TRUE

/datum/mentorhelp/proc/defer_to_admins(client/deferrer)
	if(!check_author())
		return

	if(!check_open(deferrer))
		return

	if(!CLIENT_IS_MENTOR(deferrer))
		return

	if(mentor && mentor != deferrer)
		to_chat(deferrer, SPAN_WARNING("This ticket is currently marked by [mentor.key]. Please override their mark to interact with this ticket!"))
		return

	if(author.current_ticket)
		to_chat(deferrer, SPAN_WARNING("This user already has an active adminhelp ticket. Please close it first or use the existing one."))
		return

	var/options = tgui_alert(deferrer, "Use the first message in this ticket, or a custom option?", "Defer to Admins", list("First Message", "Custom"))
	if(!options)
		return

	var/message = ""
	switch(options)
		if("First Message")
			message = initial_message
		if("Custom")
			message = tgui_input_text(deferrer, "Text to Send to Admins", "Defer to Admins")

	if(!message)
		return

	new /datum/admin_help(message, author, FALSE)

	notify("<font style='color:red;'>[deferrer.key]</font> deferred this ticket to admins.",
		unformatted_text = "[deferrer.key] deferred this ticket to admins.")
	to_chat(author, SPAN_MENTORHELP("Your ticket has been deferred to Admins."))
	log_mhelp("[deferrer.key] deferred [author_key]'s mentorhelp to admins.")

	close(deferrer)

