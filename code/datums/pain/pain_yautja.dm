/datum/pain/yautja
	max_pain 			= 200

	threshold_mild 				= null
	threshold_discomforting 	= null
	threshold_moderate			= null
	threshold_distressing		= null
	threshold_severe			= null
	threshold_horrible			= 85

	feels_pain = FALSE

/datum/pain/yautja/activate_horrible()
	pain_slowdown = PAIN_SPEED_MED
	new /datum/effects/pain/human/distressing(source_mob)