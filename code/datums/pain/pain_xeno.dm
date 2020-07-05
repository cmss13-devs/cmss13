/datum/pain/xeno
	current_pain 		= null
	max_pain 			= 1000

	threshold_mild 		= 50
	threshold_moderate 	= 60
	threshold_modsevere	= 70
	threshold_severe 	= 80
	threshold_very_severe = 90

/datum/pain/xeno/apply_pain(var/amount = 0, var/type = BRUTE)
	return FALSE