/datum/effects/crit
	effect_name = "hardcrit"
	duration = 30
	flags = INF_DURATION | NO_PROCESS_ON_DEATH | DEL_ON_UNDEFIBBABLE

/datum/effects/crit/validate_atom(atom/A)
	if(isobj(A))
		return FALSE
	. = ..()
