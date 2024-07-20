/datum/redis_callback/asay
	channel = "byond.asay"

/datum/redis_callback/asay/on_message(message)
	var/list/data = json_decode(message)

	if(data["source"] == SSredis.instance_name)
		return

	var/msg = SPAN_MOD("<span class='prefix'>[data["rank"]]:</span> <EM>[data["author"]]@[data["source"]]</EM>: <span class='message'>[strip_html(data["message"])]</span>")

	for(var/client/client in GLOB.admins)
		if(!check_client_rights(client, R_ADMIN, FALSE) && check_client_rights(client, R_MOD, FALSE))
			continue

		to_chat(client, msg)
