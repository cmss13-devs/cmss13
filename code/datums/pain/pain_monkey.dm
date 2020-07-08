/datum/pain/monkey
	max_pain 			= 200

	threshold_mild 		= 20
	threshold_moderate 	= 30
	threshold_modsevere	= 50
	threshold_severe 	= 60
	threshold_very_severe = 75

/datum/pain/monkey/activate_mild()
	pain_slowdown = PAIN_SPEED_LOW
	new /datum/effects/pain/human/mild/monkey(source_mob)

/datum/pain/monkey/activate_moderate()
	pain_slowdown = PAIN_SPEED_MED
	new /datum/effects/pain/human/moderate/monkey(source_mob)

/datum/pain/monkey/activate_modsevere()
	pain_slowdown = PAIN_SPEED_SLOW
	new /datum/effects/pain/human/modsevere/monkey(source_mob)

/datum/pain/monkey/activate_severe()
	pain_slowdown = PAIN_SPEED_SLOW
	new /datum/effects/pain/human/severe/monkey(source_mob)

/datum/pain/monkey/activate_very_severe()
	pain_slowdown = PAIN_SPEED_VERYSLOW
	new /datum/effects/pain/human/very_severe/monkey(source_mob)