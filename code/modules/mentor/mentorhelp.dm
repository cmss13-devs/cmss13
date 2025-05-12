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
		to_chat(C, SPAN_NOTICE("Этот тикет в \"MentorHelp\" закрыт!")) //SS220 - EDIT
		return FALSE
	return TRUE

// Logs the mentorhelp message to admin logs
/datum/mentorhelp/proc/log_message(msg, from_key, to_key)
	msg = strip_html(msg)
	var/log_msg = msg
	if(from_key && to_key)
		log_msg = "[SPAN_MENTORHELP("[from_key] -> [to_key]:")] [msg]"
	log_mhelp(log_msg)

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

	var/message = strip_html(input("Сообщение:", "MentorHelp", null, null) as message|null) //SS220 - EDIT
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

	if(recipient?.key)
		log_message(msg, sender.key, recipient.key)
	else
		log_message(msg, sender.key, "Всем менторам") //SS220 - EDIT

	// Sender feedback
	to_chat(sender, "[SPAN_MENTORHELP("<span class='prefix'>MentorHelp:</span> сообщение [(recipient?.key) ? "<a href='byond://?src=\ref[src];action=message'>[recipient.key]</a>" : "менторам"]:")] [SPAN_MENTORBODY(msg)]") //SS220 - EDIT

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
			to_chat(sender, SPAN_MENTORHELP("<b>УВЕДОМЛЕНИЕ:</b> Ментор читает ваш тикет!")) //SS220 - EDIT
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
	var/message_sender_key = "<a href='byond://?src=\ref[src];action=message'>[sender.key]</a>"
	var/message_sender_options = ""

	// The message is being sent to the mentor and should be formatted as a mentorhelp message
	if(sender == author)
		message_title = "MentorHelp"
		// If there's a mentor, let them mark it. If not, let them unmark it
		message_sender_options = " (<a href='byond://?src=\ref[src];action=mark'>Mark/Unmark</a>"
		message_sender_options += " | <a href='byond://?src=\ref[src];action=close'>Close</a> | <a href='byond://?src=\ref[src];action=autorespond'>AutoResponse</a>)"

	var/message_header = SPAN_MENTORHELP("<span class='prefix'>[message_title] от [message_sender_key]:</span> <span class='message'>[message_sender_options]</span><br>") //SS220 - EDIT
	var/message_body = "&emsp;[SPAN_MENTORBODY("<span class='message'>[message]</span>")]<br>" //SS220 - EDIT
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
		to_chat(thread_mentor, SPAN_MENTORHELP("<b>УВЕДОМЛЕНИЕ:</b> Ментор читает ваш тикет!")) //SS220 - EDIT
		return

	if(!thread_mentor)
		return

	// Not a mentor/staff
	if(!CLIENT_IS_MENTOR(thread_mentor))
		return

	mentor = thread_mentor

	log_mhelp("[mentor.key] начал отвечать на тикет [author_key] в \"MentorHelp\".") //SS220 - EDIT
	notify("<font style='color:red;'>[mentor.key]</font> начал отвечать на тикет <font style='color:red;'>[author_key]</font> в \"MentorHelp\".") //SS220 - EDIT
	to_chat(author, SPAN_NOTICE("<b>УВЕДОМЛЕНИЕ:</b> <font style='color:red;'>[mentor.key]</font> начал отвечать на ваш тикет.")) //SS220 - EDIT

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

	log_mhelp("[mentor.key] перестал отвечать на тикет [author_key] в \"MentorHelp\".") //SS220 - EDIT
	notify("<font style='color:red;'>[mentor.key]</font> перестал отвечать на тикет <font style='color:red;'><a href='byond://?src=\ref[src];action=message'>[author_key]</a></font> в \"MentorHelp\".") //SS220 - EDIT
	to_chat(author, SPAN_NOTICE("<b>УВЕДОМЛЕНИЕ:</b> <font style='color:red;'>[mentor.key]</font> перестал отвечать на ваш тикет.")) //SS220 - EDIT
	mentor = null

/*
 * Misc.
 */

// Closes the thread and notifies the author/mentor that it has been closed
/datum/mentorhelp/proc/close(client/closer)
	if(!open)
		return

	// Thread was closed because the author is gone
	if(!author)
		notify("<font style='color:red;'>[author_key]</font> тикет в \"MentorHelp\" был закрыт, в связи с потерей соединения с пользователем.") //SS220 - EDIT
		log_mhelp("[author_key] тикет в \"MentorHelp\" был закрыт, в связи с потерей соединения с пользователем") //SS220 - EDIT
		return

	// Make sure it's being closed by staff or the mentor handling the thread
	if(mentor && closer && (closer != mentor) && (closer != author) && !CLIENT_IS_STAFF(closer))
		to_chat(closer, SPAN_MENTORHELP("<b>УВЕДОМЛЕНИЕ:</b> другой ментор уже ответил на этот тикет!")) //SS220 - EDIT
		return

	open = FALSE
	if(closer)
		log_mhelp("[closer.key] closed [author_key]'s mentorhelp")
		if(closer == author)
			to_chat(author, SPAN_NOTICE("Вы закрыли тикет в \"MentorHelp\".")) //SS220 - EDIT
			notify("<font style='color:red;'>[author_key]</font> закрыл свой тикет в \"MentorHelp\".") //SS220 - EDIT
			return
	to_chat(author, SPAN_NOTICE("Ваш тикет в \"MentorHelp\" был закрыт.")) //SS220 - EDIT
	notify("<font style='color:red;'>[author_key]</font> тикет в \"MentorHelp\" был закрыт.") //SS220 - EDIT

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
		to_chat(responder, SPAN_NOTICE("<b>УВЕДОМЛЕНИЕ:</b> Ментор начал отвечать на этот тикет!")) //SS220 - EDIT
		return

	var/choice = tgui_input_list(usr, "Выберите шаблон для ответа игроку.", "Autoresponse", GLOB.mentorreplies) //SS220 - EDIT
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
		to_chat(responder, SPAN_NOTICE("<b>УВЕДОМЛЕНИЕ:</b> Ментор прочитал ваш тикет!")) //SS220 - EDIT
		return

	var/msg = "[SPAN_ORANGE(SPAN_BOLD("Ментор отметил вопрос как: \"[response.title]\"!"))]<br>" //SS220 - EDIT
	msg += "[SPAN_ORANGE(response.message)]"

	message_handlers(msg, responder, author)
