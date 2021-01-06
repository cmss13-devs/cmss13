/datum/random_fact
	var/message = null

/datum/random_fact/proc/announce()
	if(message)
		to_chat_spaced(world, margin_bottom = 0, html = SPAN_ROLE_BODY("|______________________|"))
		to_world(SPAN_ROLE_HEADER("FUN FACT"))
		to_world(SPAN_CENTERBOLD(message))
		to_chat_spaced(world, margin_top = 0, html = SPAN_ROLE_BODY("|______________________|"))
		return TRUE
	return FALSE
