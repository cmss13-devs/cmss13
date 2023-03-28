/datum/redis_callback/asay
	channel = "byond.asay"

/datum/redis_callback/asay/on_message(message)
	var/list/data = json_decode(message)

	if(data["source"] == "game")
		return

	var/msg = SPAN_ADMINSAY("<span class='prefix'>ADMIN:</span> <EM>[data["author"]]@[data["source"]]</EM>: <span class='message'>[strip_html(data["message"])]</span>")

	for(var/client/client in GLOB.admins)
		if(!(R_ADMIN & client.admin_holder.rights))
			continue

		to_chat(client, msg)
