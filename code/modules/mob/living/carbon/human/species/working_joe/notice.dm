/datum/emote/living/carbon/human/synthetic/working_joe/notice
	category = JOE_EMOTE_CATEGORY_NOTICE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/report
	key = "report"
	sound = 'sound/voice/joe/report.ogg'
	haz_sound = 'sound/voice/joe/report_haz.ogg'
	say_message = "Logging report to APOLLO."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/detailed_report
	key = "detailedreport"
	sound = 'sound/voice/joe/detailed_report.ogg'
	haz_sound = 'sound/voice/joe/detailed_report_haz.ogg'
	say_message = "APOLLO will require a detailed report."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/be_careful
	key = "careful"
	sound = 'sound/voice/joe/be_careful_with_that.ogg'
	say_message = "Be careful with that."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/firearm
	key = "firearm"
	sound = 'sound/voice/joe/firearm.ogg'
	haz_sound = 'sound/voice/joe/firearm_haz.ogg'
	say_message = "Firearms can cause serious injury. Let me assist you."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/investigate_weapon
	key = "weapon"
	sound = 'sound/voice/joe/investigate_weapon.ogg'
	say_message = "A weapon. I better investigate."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/firearm_concerning
	key = "firearmconcerning"
	sound = 'sound/voice/joe/most_concerning.ogg'
	say_message = "A firearm. Most concerning."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/permit_for_that
	key = "permitforthat"
	sound = 'sound/voice/joe/permit_for_that.ogg'
	say_message = "I assume you have a permit for that weapon."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/invest_disturbance
	key = "investigatedisturbance"
	haz_sound = 'sound/voice/joe/investigating_disturbance_haz.ogg'
	say_message = "Investigating disturbance."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/unexplained_disturbance
	key = "disturbance"
	haz_sound = 'sound/voice/joe/disturbance_haz.ogg'
	say_message = "Unexplained disturbances are most troubling."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/species
	key = "species"
	sound = 'sound/voice/joe/species.ogg'
	haz_sound = 'sound/voice/joe/species_haz.ogg'
	say_message = "Unidentified species."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/beyond_repair
	key = "beyondrepair"
	sound = 'sound/voice/joe/beyond_repair.ogg'
	haz_sound = 'sound/voice/joe/beyond_repair_haz.ogg'
	say_message = "Hmm, far beyond repair."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/apollo_behalf
	key = "apollobehalf"
	sound = 'sound/voice/joe/apollo_behalf.ogg'
	haz_sound = 'sound/voice/joe/apollo_behalf_haz.ogg'
	say_message = "I will inform APOLLO on your behalf."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/combust_on_its_own
	key = "combustonitsown"
	sound = 'sound/voice/joe/combust.ogg'
	say_message = "I'll assume that didn't combust all on its own."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/safety_log
	key = "safetylog"
	sound = 'sound/voice/joe/safety_log.ogg'
	say_message = "Safety log updated."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/strange
	key = "strange"
	sound = 'sound/voice/joe/strange.ogg'
	say_message = "Strange."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/report_this
	key = "reportthis"
	sound = 'sound/voice/joe/report_this.ogg'
	say_message = "I'll have to report this."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/failed_support
	key = "failedsupport"
	sound = 'sound/voice/joe/failed_support_request.ogg'
	say_message = "Your failed support request has been logged with APOLLO."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/alarm_activated
	key = "alarmactivated"
	sound = 'sound/voice/joe/alarm_activated.ogg'
	say_message = "Alarm activated, investigation commencing."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/potential_hazard
	key = "potentialhazard"
	sound = 'sound/voice/joe/potential_hazard.ogg'
	say_message = "A potential hazard."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/saw_that
	key = "sawthat"
	sound = 'sound/voice/joe/saw_that.ogg'
	say_message = "I saw that."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
