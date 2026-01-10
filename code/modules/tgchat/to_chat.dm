/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * Circumvents the message queue and sends the message
 * to the recipient (target) as soon as possible.
 */
/proc/to_chat_immediate(
	target,
	html,
	type = null,
	text = null,
	avoid_highlighting = FALSE,
	// FIXME: These flags are now pointless and have no effect
	handle_whitespace = TRUE,
	trailing_newline = TRUE,
	confidential = FALSE
)
	// Useful where the integer 0 is the entire message. Use case is enabling to_chat(target, some_boolean) while preventing to_chat(target, "")
	html = "[html]"
	text = "[text]"

	if(!target)
		return
	if(!html && !text)
		CRASH("Empty or null string in to_chat proc call.")
	if(target == world)
		target = GLOB.clients

	var/list/true_targets = list()
	if(target == GLOB.admins)
		for(var/admin in target)
			var/client/admin_client = CLIENT_FROM_VAR(admin)
			if(CLIENT_IS_STAFF(admin_client))
				true_targets += admin_client
		target = true_targets

	// Build a message
	var/message = list()
	if(type)
		message["type"] = type
	if(text)
		message["text"] = text
	if(html)
		message["html"] = html
	if(avoid_highlighting)
		message["avoidHighlighting"] = avoid_highlighting
	// send it immediately
	SSchat.send_immediate(target, message)

/**
 * Sends the message to the recipient (target).
 *
 * Recommended way to write to_chat calls:
 * ```
 * to_chat(client,
 *  type = MESSAGE_TYPE_INFO,
 *  html = "You have found <strong>[object]</strong>")
 * ```
 */
/proc/to_chat(
	target,
	html,
	type = null,
	text = null,
	avoid_highlighting = FALSE,
	// FIXME: These flags are now pointless and have no effect
	handle_whitespace = TRUE,
	trailing_newline = TRUE,
	confidential = FALSE
)
	//if(isnull(Master) || !SSchat?.initialized || !MC_RUNNING(SSchat.init_stage))
	if(Master.current_runlevel == RUNLEVEL_INIT || !SSchat?.initialized)
		to_chat_immediate(target, html, type, text, avoid_highlighting)
		return

	// Useful where the integer 0 is the entire message. Use case is enabling to_chat(target, some_boolean) while preventing to_chat(target, "")
	html = "[html]"
	text = "[text]"

	if(!target)
		return
	if(!html && !text)
		CRASH("Empty or null string in to_chat proc call.")
	if(target == world)
		target = GLOB.clients
	// Build a message
	var/message = list()
	if(type)
		message["type"] = type
	if(text)
		message["text"] = text
	if(html)
		message["html"] = html
	if(avoid_highlighting)
		message["avoidHighlighting"] = avoid_highlighting
	SSchat.queue(target, message)

/proc/announce_dchat(message, atom/target)
	var/jmp_message = message
	for(var/mob/dead/observer/observer as anything in GLOB.observer_list)
		if(target)
			jmp_message = "[message] [OBSERVER_JMP(observer, target)]"
		to_chat(observer, FONT_SIZE_LARGE(SPAN_DEADSAY("<b>ALERT:</b> [jmp_message]")))
