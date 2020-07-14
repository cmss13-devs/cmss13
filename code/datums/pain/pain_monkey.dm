/datum/pain/monkey
	max_pain 			= 200

	threshold_mild 				= 10
	threshold_discomforting 	= 20
	threshold_moderate			= 40
	threshold_distressing		= 50
	threshold_severe			= 65
	threshold_horrible			= 75

/datum/pain/monkey/activate_mild()
	pain_slowdown = PAIN_SPEED_LOW
	new /datum/effects/pain/human/mild/monkey(source_mob)

/datum/pain/monkey/activate_discomforting()
	pain_slowdown = PAIN_SPEED_MED
	new /datum/effects/pain/human/discomforting/monkey(source_mob)

/datum/pain/monkey/activate_moderate()
	pain_slowdown = PAIN_SPEED_HIGH
	new /datum/effects/pain/human/moderate/monkey(source_mob)

/datum/pain/monkey/activate_distressing()
	pain_slowdown = PAIN_SPEED_SLOW
	new /datum/effects/pain/human/distressing/monkey(source_mob)

/datum/pain/monkey/activate_severe()
	pain_slowdown = PAIN_SPEED_VERYSLOW
	new /datum/effects/pain/human/severe/monkey(source_mob)

/datum/pain/monkey/activate_horrible()
	pain_slowdown = PAIN_SPEED_VERYSLOW
	new /datum/effects/pain/human/horrible/monkey(source_mob)