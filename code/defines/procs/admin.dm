/proc/important_message_external(message, title, list/datum/tgs_chat_embed/field/fields)
	if(CONFIG_GET(string/important_log_channel))
		var/datum/tgs_message_content/to_send = new("")

		var/datum/tgs_chat_embed/structure/embed = new()
		embed.title = title ? title : "Important Log"
		embed.description = message
		embed.timestamp = time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")
		embed.colour = "#ED2939"
		if(length(fields))
			embed.fields = fields

		to_send.embed = embed

		send2chat(to_send, CONFIG_GET(string/important_log_channel))
