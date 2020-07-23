/datum/effects/pain
	effect_name = "pain"		//Name of the effect
	duration = 30
	flags = INF_DURATION | NO_PROCESS_ON_DEATH | DEL_ON_UNDEFIBBABLE

/datum/effects/pain/validate_atom(var/atom/A)
	if(isobj(A))
		return FALSE
	. = ..()