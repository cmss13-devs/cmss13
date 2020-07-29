var/datum/subsystem/chat/SSchat

#define MAX_DEQUEUE 10 // dequeue no more than this amount of messages, to prevent noone getting a message due to high load

/datum/chat_item
	var/target
	var/message

/datum/subsystem/chat
	name = "Chat"
	flags = SS_FIRE_IN_LOBBY | SS_POST_FIRE_TIMING
	wait = 2
	priority = SS_PRIORITY_CHAT
	init_order = SS_INIT_CHAT

	var/list/processQueue = list()
	var/list/processQueue_current = list()
	var/list/chatQueue = list()


/datum/subsystem/chat/New()
	NEW_SS_GLOBAL(SSchat)

/datum/subsystem/chat/stat_entry()
	..("P:[processQueue.len]; C:[processQueue_current.len]")

/datum/subsystem/chat/fire()
	for(var/datum/chat_item/item in processQueue_current)
		de_queue(item.target, item.message)
		processQueue_current -= item
		if(MC_TICK_CHECK)
			return

	if(processQueue_current.len==0)
		processQueue_current = processQueue
		processQueue = list()

	for(var/i in chatQueue)
		var/client/C = i
		var/msg = url_encode(json_encode(list("message"=chatQueue[C])))
		C << output(msg, "browseroutput:output")
		chatQueue -= C

		if(MC_TICK_CHECK)
			return

/datum/subsystem/chat/proc/queue(var/target, var/message)
	if(!target || !message)
		return
	
	if(!istext(message))
		CRASH("to_chat called with invalid input type ([message])")
		return

	var/datum/chat_item/ci = new()
	ci.target = target
	ci.message = message

	processQueue.Add(ci)

/datum/subsystem/chat/proc/de_queue_single(var/target, var/encoded_message, var/clean_message)
	var/client/C
	if (istype(target, /client))
		C = target
	else if (istype(target, /mob))
		var/mob/M = target
		C = M.client
	else if (istype(target, /datum/mind))
		var/datum/mind/M = target
		if (M.current)
			C = M.current.client

	if(!istype(C))
		return

	if(C.chatOutput && C.chatOutput.oldChat || !C.chatOutput)
		C << clean_message
		return

	if (C.chatOutput && !C.chatOutput.loaded && islist(C.chatOutput.messageQueue))
		C.chatOutput.messageQueue += encoded_message
		return

	chatQueue[C] += encoded_message

/datum/subsystem/chat/proc/de_queue(var/target, var/message)
	#define GCHAT_UNDEFINED_LIST 0
	#define GCHAT_CLIENT_LIST 1
	#define GCHAT_MOB_LIST 2
	#define GCHAT_MIND_LIST 3

	var/type_of_list = GCHAT_UNDEFINED_LIST

	if(target == world)
		target = clients
		type_of_list = GCHAT_CLIENT_LIST

	var/clean_message = message

	//Some macros remain in the string even after parsing and fuck up the eventual output
	message = replacetextEx(message, "\n", "<br>")
	message += "<br>"

	var/encoded_message = message

	//Grab us a client if possible
	if(islist(target))		
		
		for(var/T in target)
			var/client/C

			if(type_of_list == GCHAT_UNDEFINED_LIST)
				if (istype(T, /client))
					type_of_list = GCHAT_CLIENT_LIST
				else if (istype(T, /mob))
					type_of_list = GCHAT_MOB_LIST
				else if (istype(T, /datum/mind))
					type_of_list = GCHAT_MIND_LIST
				else
					continue
			
			if(type_of_list == GCHAT_CLIENT_LIST)
				C = T
			
			if(type_of_list == GCHAT_MOB_LIST)
				var/mob/M = T
				if(!istype(M))
					continue
				C = M.client
			
			if(type_of_list == GCHAT_MOB_LIST)
				var/datum/mind/M = T
				if(!istype(M))
					continue
				if(M.current)
					C = M.current.client

			if(!C || !istype(C))
				continue

			// If they are using the old chat, send it the old way
			if(C.chatOutput && C.chatOutput.oldChat || !C.chatOutput)
				C << clean_message
				continue
			
			if (C.chatOutput && !C.chatOutput.loaded && C.chatOutput.messageQueue && islist(C.chatOutput.messageQueue))
				//Client sucks at loading things, put their messages in a queue
				C.chatOutput.messageQueue += message
				continue

			chatQueue[C] += encoded_message
		#undef GCHAT_UNDEFINED_LIST
		#undef GCHAT_CLIENT_LIST
		#undef GCHAT_MOB_LIST
		#undef GCHAT_MIND_LIST
	else
		de_queue_single(target, encoded_message, clean_message)
