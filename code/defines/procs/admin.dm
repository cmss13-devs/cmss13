/proc/log_and_message_admins(message as text)
	log_admin("[key_name(usr)] [message]")
	message_admins("[key_name(usr)] [message]")

/proc/important_log_and_message_admins(message)
	log_and_message_admins(message)
	if(CONFIG_GET(string/important_log_channel))
		send2chat(new /datum/tgs_message_content(message), CONFIG_GET(string/important_log_channel))
