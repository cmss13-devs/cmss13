/datum/emote/living/carbon/human/synthetic/working_joe/fire
	category = JOE_EMOTE_CATEGORY_FIRE

/datum/emote/living/carbon/human/synthetic/working_joe/fire/fire_drill
	key = "firedrill"
	sound = 'sound/voice/joe/fire_drill.ogg'
	say_message = "Please congregate at your nearest fire assembly point. This is not a drill; do not panic."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/fire/temperatures
	key = "temperatures"
	sound = 'sound/voice/joe/temperatures.ogg'
	haz_sound = 'sound/voice/joe/temperatures_haz.ogg'
	say_message = "I am built to withstand temperatures of up to 1210 degrees."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/fire/fire
	key = "fire"
	sound = 'sound/voice/joe/fire.ogg'
	haz_sound = 'sound/voice/joe/fire_haz.ogg'
	say_message = "Only wild animals fear fire."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/fire/unprotected_flames
	key = "unprotectedflames"
	sound = 'sound/voice/joe/unprotected_flames.ogg'
	haz_sound = 'sound/voice/joe/unprotected_flames_haz.ogg'
	say_message = "Unprotected flames are extremely dangerous and entirely unadvisable."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE
