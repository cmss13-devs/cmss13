/proc/log_and_message_admins(message as text)
	log_admin("[key_name(usr)] " + message)
	message_admins("[key_name(usr)] " + message)

/proc/log_and_message_staff(message as text)
	log_admin("[key_name(usr)] [message]")
	message_staff("[key_name(usr)] [message]")
