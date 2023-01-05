/datum/pain/xeno
	current_pain 		= null
	max_pain 			= 1000

	threshold_mild 				= null
	threshold_discomforting 	= null
	threshold_moderate			= null
	threshold_distressing		= null
	threshold_severe			= null
	threshold_horrible			= null

/datum/pain/xeno/apply_pain(var/amount = 0, var/type = BRUTE)
	return FALSE