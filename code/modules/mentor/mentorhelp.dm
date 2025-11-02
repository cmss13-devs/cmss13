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

	var/list/messages = list() //SS220 EDIT

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
	GLOB.mentorhelp_tickets += src //SS220 EDIT

/datum/mentorhelp/Destroy()
	GLOB.mentorhelp_tickets -= src //SS220 EDIT
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
	// SS220 EDIT - START
	var/message_entry = list(
		"sender" = sender.key,
		"recipient" = recipient?.key || "All mentors",
		"text" = msg,
		"timestamp" = world.time
	)
	messages += list(message_entry)
	// SS220 EDIT - END

	if(recipient?.key)
		log_message(msg, sender.key, recipient.key)
	else
		log_message(msg, sender.key, "Всем менторам") //SS220 EDIT

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
				//SS220 EDIT - START
				C << browse(null, "window=mentorchat_[REF(src)]")
		if("open_chat")
			if(!check_open(C) || !CLIENT_IS_MENTOR(C))
				return
			show_chat_window(C)
		if("send_chat_message")
			if(!check_open(C))
				to_chat(C, SPAN_MENTORHELP("Этот тикет закрыт!"))
				return
			if(C != author && C != mentor && !CLIENT_IS_STAFF(C))
				to_chat(C, SPAN_MENTORHELP("Вы не можете отправлять сообщения в этот тикет!"))
				return
			var/message = strip_html(href_list["chat_msg"])
			if(!message || !length(trim(message)))
				to_chat(C, SPAN_MENTORHELP("Сообщение не может быть пустым!"))
				return
			var/client/recipient = (C == author) ? mentor : author
			if(!recipient && C == author)
				recipient = null
			if(C != author && !mentor)
				mark(C)
			else if(C != author && mentor != C)
				to_chat(C, SPAN_MENTORHELP("<b>УВЕДОМЛЕНИЕ:</b> Другой ментор уже отвечает на этот тикет!"))
				return
			message_handlers(message, C, recipient)
			show_chat_window(C)
			if(recipient && recipient != C)
				show_chat_window(recipient)
				//SS220 EDIT - END
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
//SS220 EDIT START
/client/verb/mentor_view_open_tickets()
	set name = "View Open Tickets"
	set category = "Admin.Mentor"
	if(!check_rights(R_MENTOR))
		return

	var/html = "<html><head>"
	html += "<meta charset='UTF-8'>"
	html += "<style>"
	html += "body { background-color: #2b2b2b; color: #e0e0e0; font-family: Arial, sans-serif; }"
	html += "h2 { color: #ffb02e; }"
	html += "table { width: 100%; border-collapse: collapse; }"
	html += "th, td { padding: 8px; text-align: left; border: 1px solid #444; }"
	html += "th { background-color: #3a3a3a; color: #ffb02e; }"
	html += "tr:nth-child(even) { background-color: #333; }"
	html += "tr:nth-child(odd) { background-color: #2b2b2b; }"
	html += "a { color: #ffb02e; text-decoration: none; }"
	html += "a:hover { text-decoration: underline; }"
	html += "i { color: #888; }"
	html += ".auto-response-btn { color: #ff8800; margin-left: 10px; }"
	html += ".auto-response-btn:hover { color: #cc6600; text-decoration: underline; }"
	html += "</style></head><body>"
	html += "<h2>Open MentorHelp Tickets</h2>"
	html += "<table>"
	html += "<tr><th>Sender</th><th>Mentor</th><th>Status</th><th>Actions</th></tr>"
	var/open_count = 0
	for(var/datum/mentorhelp/MH in GLOB.mentorhelp_tickets)
		if(MH.open)
			open_count++
			html += "<tr>"
			html += "<td>[MH.author_key]</td>"
			html += "<td>[MH.mentor ? MH.mentor.key : "None"]</td>"
			html += "<td>[MH.open ? "Open" : "Closed"]"
			html += "<td>"
			html += "<a href='byond://?src=\ref[MH];action=open_chat'>Message</a>"
			if(MH.open)
				html += " <a href='byond://?src=\ref[MH];action=autorespond' class='auto-response-btn'>AutoResponse</a>"
			html += "</td>"
			html += "</tr>"
	html += "</table>"
	html += "<i>Total open tickets: [open_count]</i>"
	html += "</body></html>"

	usr << browse(html, "window=mentoropentickets;size=600x500")

/datum/mentor/proc/show_open_tickets(mob/user)

/datum/mentorhelp/proc/show_chat_window(client/user)
	if(!check_author() || !check_open(user))
		return

	var/html = "<html><head>"
	html += "<meta charset='UTF-8'>"
	html += "<style>"
	html += "* { box-sizing: border-box; }"
	html += "body { background-color: #2b2b2b; color: #e0e0e0; font-family: Arial, sans-serif; margin: 0; padding: 10px; overflow-y: auto; }"
	html += "h3 { color: #ffb02e; margin: 0; display: inline-block; }"
	html += ".header { display: flex; align-items: center; padding: 10px 0; width: 100%; }"
	html += ".close-btn-container { margin-left: auto; }"
	html += ".close-btn { padding: 5px 10px; background-color: #ff4444; color: #fff; border: none; cursor: pointer; text-decoration: none; }"
	html += ".close-btn:hover { background-color: #cc3333; }"
	html += ".message { margin: 5px 0; padding: 5px; background-color: #333; border-radius: 5px; }"
	html += ".sender { color: #ffb02e; font-weight: bold; }"
	html += ".timestamp { color: #888; font-size: 0.8em; }"
	html += ".input-container { margin-top: 10px; position: sticky; bottom: 10px; background-color: #2b2b2b; padding: 5px 0; display: flex; align-items: center; width: 100%; }"
	html += "input { flex-grow: 1; padding: 8px; background-color: #444; color: #e0e0e0; border: 1px solid #666; margin-right: 5px; height: 34px; }"
	html += "button { padding: 8px 10px; background-color: #ffb02e; color: #fff; border: none; cursor: pointer; height: 34px; margin-left: auto; }"
	html += "button:hover { background-color: #0099cc; }"
	html += "</style>"
	html += "<script>"

	html += "function resizeMessagesArea() {"
	html += "   var headerHeight = document.querySelector(\".header\").offsetHeight;"
	html += "   var inputHeight = document.querySelector(\".input-container\").offsetHeight;"
	html += "   var windowHeight = window.innerHeight;"
	html += "   document.body.style.minHeight = windowHeight + \"px\";"
	html += "}"
	html += "window.addEventListener(\"resize\", resizeMessagesArea);"

	html += "window.onload = function() {"
	html += "   resizeMessagesArea();"
	html += "   window.scrollTo(0, document.body.scrollHeight);"
	html += "};"
	html += "</script>"
	html += "</head><body>"

	html += "<div class='header'>"
	html += "<h3>MentorChat</h3>"
	html += "<div class='close-btn-container'>"
	if(user == author || user == mentor || CLIENT_IS_STAFF(user))
		html += "<a href='byond://?src=\ref[src];action=close' class='close-btn'>Close Ticket</a>"
	html += "</div>"
	html += "</div>"

	if(length(messages) == 0)
		html += "<i>No messages yet. Start chatting below!</i>"
	else
		for(var/list/msg in messages)
			var/time_formatted = time2text(msg["timestamp"], "hh:mm:ss")
			html += "<div class='message'>"
			html += "<span class='timestamp'>[time_formatted]</span> "
			html += "<span class='sender'>[msg["sender"]]</span> - [msg["recipient"]]: "
			html += "[msg["text"]]"
			html += "</div>"

	html += "<div class='input-container'>"
	html += "<form action='byond://?src=\ref[src]' method='get' style='display: flex; width: 100%;'>"
	html += "<input type='hidden' name='src' value='\ref[src]'>"
	html += "<input type='hidden' name='action' value='send_chat_message'>"
	html += "<input type='text' id='chat_msg' name='chat_msg' placeholder='Type your message...'>"
	html += "<button type='submit'>Send</button>"
	html += "</form>"
	html += "</div>"

	html += "</body></html>"

	user << browse(html, "window=mentorchat_[REF(src)];size=1000x600")

/client/verb/mentorhelp_open_chat()
	set name = "Open Mentor Chat"
	set category = "Admin.Mentor"

	var/datum/mentorhelp/MH
	for(var/datum/mentorhelp/ticket in GLOB.mentorhelp_tickets)
		if(ticket.author == src && ticket.open)
			MH = ticket
			break

	if(!MH)
		to_chat(src, SPAN_MENTORHELP("У вас нет открытых тикетов"))
		return

	MH.show_chat_window(src)
	//SS220 EDIT END
