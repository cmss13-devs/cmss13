/datum/pain/sangheili
	max_pain = 300

	threshold_mild = null
	threshold_discomforting = null
	threshold_moderate = null
	threshold_distressing = null
	threshold_severe = null
	threshold_horrible = 200

	feels_pain = TRUE

/datum/pain/sangheili/activate_horrible()
	pain_slowdown = PAIN_SPEED_MED
	new /datum/effects/pain/human/distressing(source_mob)

/datum/pain/sangheili/oxy_kill(mob/living/source)
	return

/datum/pain/unggoy
	max_pain = 225

	threshold_mild = 25
	threshold_discomforting = 50
	threshold_moderate = 75
	threshold_distressing = 100
	threshold_severe = 125
	threshold_horrible = 150

	feels_pain = TRUE
