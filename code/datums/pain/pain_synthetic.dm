/datum/pain/synthetic
	max_pain 			= 250

	threshold_mild 				= null
	threshold_discomforting 	= null
	threshold_moderate			= null
	threshold_distressing		= null
	threshold_severe			= null
	threshold_horrible			= 85

	feels_pain = FALSE

/datum/pain/synthetic/activate_horrible()
	pain_slowdown = PAIN_SPEED_MED

/datum/pain/synthetic/early_synthetic
	max_pain 			= 300