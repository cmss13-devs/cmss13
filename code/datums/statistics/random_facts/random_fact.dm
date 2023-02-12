/datum/random_fact
	var/message = null

	var/check_human = TRUE
	var/check_xeno = TRUE

/datum/random_fact/New(set_check_human = TRUE, set_check_xeno = TRUE)
	. = ..()
	check_human = set_check_human
	check_xeno = set_check_xeno

/datum/random_fact/proc/announce()
	if(message)
		to_world(SPAN_CENTERBOLD(message))
		return TRUE
	return FALSE
