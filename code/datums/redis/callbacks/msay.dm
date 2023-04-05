/datum/redis_callback/msay
	channel = "byond.msay"

/datum/redis_callback/msay/on_message(message)
	var/list/data = json_decode(message)

	if(data["source"] == SSredis.instance_name)
		return

	var/msg = "<span class='mod'><span class='prefix'>[data["rank"]]:</span> <EM>[data["author"]]@[data["source"]]</EM>: <span class='message'>[strip_html(data["message"])]</span></span>"

	for(var/client/client in GLOB.admins)
		if(!(R_MOD & client.admin_holder.rights))
			continue

		to_chat(client, msg)
