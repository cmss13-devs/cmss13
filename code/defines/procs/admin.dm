/proc/log_and_message_admins(message as text)
	log_admin("[key_name(usr)] [message]")
	message_admins("[key_name(usr)] [message]")

/proc/important_message_external(message)
	if(CONFIG_GET(string/important_log_channel))
		var/datum/tgs_message_content/to_send = new("")

		var/datum/tgs_chat_embed/structure/embed = new()
		embed.title = "Important Log"
		embed.description = message
		embed.timestamp = time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")
		embed.color = "#ED2939"

		to_send.embed = embed

		send2chat(to_send, CONFIG_GET(string/important_log_channel))
