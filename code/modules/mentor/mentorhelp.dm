// Represents a mentorhelp thread
/datum/mentorhelp
	/// The client/player who initiated (authored) the mentorhelp thread
	var/client/author = null
	/// The author's key
	var/author_key = ""
	/// The mentor client responding to this mentorhelp thread
	var/client/mentor = null
	/// If this thread is still open
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
	author_key = thread_author.username()

/datum/mentorhelp/Destroy()
	author = null
	mentor = null
	return ..()

/*
 * Helpers
 */

/// Checks that the thread author is still around. Closes the thread if they're not
/datum/mentorhelp/proc/check_author()
	if(author)
		return author
	close()
	return

/// Checks that the thread is still open
/datum/mentorhelp/proc/check_open(client/mentor_client)
	if(!open)
		to_chat(mentor_client, SPAN_NOTICE("This mentorhelp thread is closed!"))
	return open

/// Logs the mentorhelp message to admin logs
/datum/mentorhelp/proc/log_message(msg, from_key, to_key)
	msg = strip_html(msg)
	var/log_msg = msg
	if(from_key && to_key)
		log_msg = "[SPAN_MENTORHELP("[from_key] -> [to_key]:")] [msg]"
	log_mhelp(log_msg)

/// Broadcasts mentorhelp thread actions to staff members and mentors
/datum/mentorhelp/proc/notify(text, to_thread_mentor = TRUE, to_mentors = TRUE, to_staff = TRUE)
	var/list/hitlist = list()
	if(to_thread_mentor && mentor)
		hitlist |= mentor
	for(var/client/candidate in GLOB.admins)
		if(to_mentors && CLIENT_IS_MENTOR(candidate))
			hitlist |= candidate
		else if(to_staff && CLIENT_IS_STAFF(candidate))
			hitlist |= candidate
	var/displaymsg = "[SPAN_MENTORHELP("<span class='prefix'>MENTOR LOG:</span> <span class='message'>[text]</span>")]"
	for(var/client/receiver in hitlist)
		if(istype(receiver))
			to_chat(receiver, displaymsg)

/datum/mentorhelp/proc/broadcast_request(client/opener)
	if(!opener || !open || !check_author())
		return FALSE // Invalid
	if(mentor)
		return TRUE // No need

	var/message = strip_html(input("Please enter your message:", "MentorHelp", null, null) as message|null)
	if(!message)
		return FALSE
	broadcast_unhandled(message, opener)
	return TRUE

/datum/mentorhelp/proc/broadcast_unhandled(msg, client/sender)
	if(!mentor && open)
		message_handlers(msg, sender)
		addtimer(CALLBACK(src, PROC_REF(broadcast_unhandled), msg, sender), 5 MINUTES)

/datum/mentorhelp/proc/message_handlers(msg, client/sender, client/recipient, with_sound = TRUE, staff_only = FALSE, include_keys = TRUE)
	if(!sender || !check_author())
		return

	if(recipient?.username())
		log_message(msg, sender.username(), recipient.username())
	else
		log_message(msg, sender.username(), "All mentors")

	// Sender feedback
	to_chat(sender, "[SPAN_MENTORHELP("<span class='prefix'>MentorHelp:</span> Message to [(get_client_name(recipient, sender)) ? "<a href='byond://?src=\ref[src];action=message'>[get_client_name(recipient, sender)]</a>" : "mentors"]:")] [SPAN_MENTORBODY(msg)]")

	// Recipient direct message
	if(recipient)
		if(with_sound && (recipient.prefs?.toggles_sound & SOUND_ADMINHELP))
			sound_to(recipient, 'sound/effects/mhelp.ogg')
		to_chat(recipient, wrap_message(msg, sender, recipient))

	for(var/client/admin_client in GLOB.admins)
		var/formatted = msg
		var/soundfile

		if(!admin_client || admin_client == recipient)
			continue

		// Initial broadcast
		else if(!staff_only && !recipient && CLIENT_HAS_RIGHTS(admin_client, R_MENTOR))
			formatted = wrap_message(formatted, sender, admin_client)
			soundfile = 'sound/effects/mhelp.ogg'

		// Eavesdrop
		else if(CLIENT_HAS_RIGHTS(admin_client, R_MENTOR) && (!staff_only || CLIENT_IS_STAFF(admin_client)) && admin_client != sender)
			if(include_keys)
				formatted = SPAN_MENTORHELP(get_client_name(sender, admin_client) + " -> " + get_client_name(recipient, admin_client) + ": ") + msg

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
			toggle_mark(sender)

		// Some other mentor is already taking care of this thread
		else if(mentor != sender)
			to_chat(sender, SPAN_MENTORHELP("<b>NOTICE:</b> A mentor is already handling this thread!"))
			return

	var/target = mentor
	if(sender == mentor)
		target = author

	var/message = input("Please enter your message:", "Mentor Help", null, null) as message|null
	if(message)
		message = strip_html(message)
		message_handlers(message, sender, target)
	return

/// Returns the name of a client based on who's asking for it, and how much information they're allowed.
/datum/mentorhelp/proc/get_client_name(client/target, client/reader)
	if(CLIENT_IS_STAFF(reader))
		return key_name(target)
	if(target == author)
		if(target.mob)
			return target.mob.name
		return "*Private Key*"
	if(!mentor)
		return FALSE
	if(target == mentor)
		return target.username()

// Sanitizes and wraps the message with some info and links, depending on the sender...?
/datum/mentorhelp/proc/wrap_message(message, client/sender, client/recipient)
	var/message_title = "MentorPM"
	var/message_sender_name = "<a href='byond://?src=\ref[src];action=message'>[get_client_name(sender, recipient)]</a>"
	var/message_sender_options = ""

	// The message is being sent to the mentor and should be formatted as a mentorhelp message
	if(sender == author)
		message_title = "MentorHelp"
		// If there's a mentor, let them mark it. If not, let them unmark it
		message_sender_options = " (<a href='byond://?src=\ref[src];action=toggle_mark'>Mark/Unmark</a>"
		message_sender_options += " | <a href='byond://?src=\ref[src];action=close'>Close</a>"
		message_sender_options += " | <a href='byond://?src=\ref[src];action=follow'>Follow</a>"
		message_sender_options += " | <a href='byond://?src=\ref[src];action=friend'>Friend</a>"
		message_sender_options += " | <a href='byond://?src=\ref[src];action=autorespond'>AutoResponse</a>)"

	var/message_header = SPAN_MENTORHELP("<span class='prefix'>[message_title] from [message_sender_name]:</span> <span class='message'>[message_sender_options]</span><br>")
	var/message_body = "&emsp;[SPAN_MENTORBODY("<span class='message'>[message]</span>")]<br>"
	// Et voila! Beautiful wrapped mentorhelp messages
	return (message_header + message_body)

/*
 * Marking
 */

// Marks the mentorhelp thread and notifies the author that the thread is being responded to
/datum/mentorhelp/proc/toggle_mark(client/thread_mentor)
	if(!thread_mentor)
		return

	if(!CLIENT_IS_MENTOR(thread_mentor))
		return

	if(!check_author())
		return

	if(!check_open(thread_mentor))
		return

	if(!mentor)
		mentor = thread_mentor
		log_mhelp("[mentor.username()] has marked [author_key]'s mentorhelp")
		notify("<font style='color:red;'>[mentor.username()]</font> has marked <font style='color:red;'>[get_client_name(author)]</font>'s mentorhelp.")
		to_chat(author, SPAN_NOTICE("<b>NOTICE:</b> <font style='color:red;'>[mentor.username()]</font> has marked your thread and is preparing to respond."))
		return

	// Already marked
	if(mentor != thread_mentor)
		to_chat(thread_mentor, SPAN_MENTORHELP("<b>NOTICE:</b> A mentor is already handling this thread!"))
		return

	// the mentor exists, and is us, and we no longer want that to be the case
	log_mhelp("[mentor.username()] has unmarked [author_key]'s mentorhelp")
	notify("<font style='color:red;'>[mentor.username()]</font> has unmarked <font style='color:red;'>[get_client_name(author)]</font>'s mentorhelp.")
	to_chat(author, SPAN_NOTICE("<b>NOTICE:</b> <font style='color:red;'>[mentor.username()]</font> has unmarked your thread and is no longer responding to it."))
	mentor = null

/*
 * Misc.
 */

/// Closes the thread and notifies the author/mentor that it has been closed
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

	open = FALSE
	if(closer)
		log_mhelp("[closer.username()] closed [author_key]'s mentorhelp")
		if(closer == author)
			to_chat(author, SPAN_NOTICE("You have closed your mentorhelp thread."))
			notify("<font style='color:red;'>[get_client_name(author)]</font> closed their mentorhelp thread.")
			return
	to_chat(author, SPAN_NOTICE("Your mentorhelp thread has been closed."))
	notify("<font style='color:red;'>[get_client_name(author)]</font>'s mentorhelp thread has been closed.")

/// Follows the thread author as an aghost, with movement restrictions
/datum/mentorhelp/proc/follow(client/mentor_client)
	if(!mentor_client)
		return

	if(!check_rights(R_MOD|R_MENTOR))
		return

	if(!check_author())
		return

	if(!check_open(mentor_client))
		return

	if(!ismob(author.mob))
		to_chat(mentor_client, SPAN_NOTICE("<b>NOTICE:</b> Thread author is still in the lobby!"))
		return

	log_mhelp("[mentor_client.username()] has begun orbiting [author_key] as a ghost")
	notify("<font style='color:red;'>[mentor_client.username()]</font> is following <font style='color:red;'>[get_client_name(author)]</font> as a ghost.")

	var/mob/dead/observer/mentor_ghost = mentor_client.mob
	if(!isobserver(mentor_client.mob))
		mentor_ghost = mentor_client.mob.ghostize(TRUE, TRUE)
		RegisterSignal(mentor_ghost, COMSIG_OBSERVER_DISCONNECTED, PROC_REF(handle_mghost_disconnect))
	mentor_ghost.do_observe(author.mob)

/// Called when the mentor aghost is no longer following its target, and needs to be recalled
/datum/mentorhelp/proc/handle_mghost_disconnect(mob/dead/observer/mghost)
	SIGNAL_HANDLER

	if(isobserver(mghost))
		mghost.reenter_corpse()

	UnregisterSignal(mghost, COMSIG_OBSERVER_DISCONNECTED)

/// Spawns the mentor as an imaginary friend, bypassing the mob selection process
/datum/mentorhelp/proc/handle_imaginary_friend(client/mentor_client, mob/befriended_mob)
	if(!mentor_client)
		return

	if(!check_rights(R_MOD|R_MENTOR))
		return

	if(!mentor_client.mob)
		return

	var/mob/mentor_mob = mentor_client.mob

	if(!mentor)
		to_chat(mentor_client, SPAN_WARNING("You must mark this mentorhelp before becoming an imaginary friend."))
		return

	if(mentor != mentor_client)
		to_chat(mentor_client, SPAN_NOTICE("Another mentor has already marked this thread."))
		return

	if(istype(mentor_mob, /mob/camera/imaginary_friend))
		to_chat(mentor_client, SPAN_WARNING("You are already an imaginary friend!"))
		return

	if(!befriended_mob)
		return

	var/mob/camera/imaginary_friend/friend = new(get_turf(befriended_mob), befriended_mob)
	friend.aghosted_original_mob = mentor_mob.mind?.original
	mentor_mob.mind?.transfer_to(friend)

	log_admin("[key_name(friend)] started being imaginary friend of [key_name(befriended_mob)].")
	message_admins("[key_name_admin(friend)] started being imaginary friend of [key_name_admin(befriended_mob)].")

/datum/mentorhelp/Topic(href, list/href_list)
	if(!usr)
		return
	var/client/mentor_client = usr.client

	if(!mentor_client)
		return

	switch(href_list["action"])
		if("message")
			input_message(mentor_client)
		if("autorespond")
			autoresponse(mentor_client)
		if("toggle_mark")
			toggle_mark(mentor_client)
		if("close")
			if(mentor_client == author || mentor_client == mentor || CLIENT_IS_STAFF(mentor_client))
				close(mentor_client)
		if("follow")
			follow(mentor_client)
		if("friend")
			handle_imaginary_friend(mentor_client, author.mob)

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
		toggle_mark(responder)
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
		toggle_mark(responder)
	else if(mentor != responder)
		to_chat(responder, SPAN_NOTICE("<b>NOTICE:</b> A mentor is already handling this thread!"))
		return

	var/msg = "[SPAN_ORANGE(SPAN_BOLD("- MentorHelp marked as [response.title]! -"))]<br>"
	msg += "[SPAN_ORANGE(response.message)]"

	message_handlers(msg, responder, author)
