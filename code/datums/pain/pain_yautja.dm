/datum/pain/yautja
	max_pain 			= 200

	threshold_mild 		= null
	threshold_moderate 	= null
	threshold_modsevere	= null
	threshold_severe 	= 80
	threshold_very_severe = 90

	feels_pain = FALSE

/datum/pain/yautja/activate_severe()
	. = ..()
	pain_slowdown = PAIN_SPEED_SLOW

/datum/pain/yautja/activate_very_severe()
	. = ..()
	pain_slowdown = PAIN_SPEED_SLOW