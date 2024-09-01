/datum/redis_callback/ooc
	channel = "byond.round"

/datum/redis_callback/ooc/on_message(message)
	var/list/data = json_decode(message)

	if(data["source"] == SSredis.instance_name)
		return

	var/msg = "<font color='[data["color"]]'><span class='ooc linkify'><span class='prefix'>OOC: [data["author"]]@[data["source"]]</span>: <span class='message'>[strip_html(data["message"], MAX_BOOK_MESSAGE_LEN)]</span></span></font>"

	for(var/client/C in GLOB.clients)
		if(C.prefs.toggles_chat & CHAT_OOC)
			to_chat(C, msg)
