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
	haz_sound = 'sound/voice/joe/be_careful_with_that_haz.ogg'
	upp_joe_sound = 'sound/voice/joe/upp_joe/ostorozhnee.ogg'
	say_message = "Be careful with that."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE|UPP_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/firearm
	key = "firearm"
	sound = 'sound/voice/joe/firearm.ogg'
	haz_sound = 'sound/voice/joe/firearm_haz.ogg'
	upp_joe_sound = 'sound/voice/joe/upp_joe/ognestrelnoeoruzie.ogg'
	say_message = "Firearms can cause serious injury. Let me assist you."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE|UPP_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/investigate_weapon
	key = "weapon"
	sound = 'sound/voice/joe/investigate_weapon.ogg'
	upp_joe_sound = 'sound/voice/joe/upp_joe/nado_viesnit.ogg'
	say_message = "A weapon. I better investigate."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|UPP_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/firearm_concerning
	key = "firearmconcerning"
	sound = 'sound/voice/joe/most_concerning.ogg'
	say_message = "A firearm. Most concerning."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/permit_for_that
	key = "permitforthat"
	sound = 'sound/voice/joe/permit_for_that.ogg'
	haz_sound = 'sound/voice/joe/permit_for_that_haz.ogg'
	upp_joe_sound = 'sound/voice/joe/upp_joe/nadeusuvasestrazre.ogg'
	say_message = "I assume you have a permit for that weapon."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE|UPP_JOE_EMOTE

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

/datum/emote/living/carbon/human/synthetic/working_joe/notice/unexplained_disturbance_upp
	key = "disturbanceupp"
	upp_joe_sound = 'sound/voice/joe/upp_joe/prichina.ogg'
	say_message = "The most unpleasant, not knowing what the reason is."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = UPP_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/species
	key = "species"
	sound = 'sound/voice/joe/species.ogg'
	haz_sound = 'sound/voice/joe/species_haz.ogg'
	say_message = "Unidentified species."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/species_upp
	key = "speciesupp"
	upp_joe_sound = 'sound/voice/joe/upp_joe/neizvestnoesuchestvo.ogg'
	say_message = "Unknown creature."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = UPP_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/beyond_repair
	key = "beyondrepair"
	sound = 'sound/voice/joe/beyond_repair.ogg'
	haz_sound = 'sound/voice/joe/beyond_repair_haz.ogg'
	upp_joe_sound = 'sound/voice/joe/upp_joe/remontu.ogg'
	say_message = "Hmm, far beyond repair."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE|UPP_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/apollo_behalf
	key = "apollobehalf"
	sound = 'sound/voice/joe/apollo_behalf.ogg'
	haz_sound = 'sound/voice/joe/apollo_behalf_haz.ogg'
	say_message = "I will inform APOLLO on your behalf."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/have_to_check
	key = "havetocheck"
	upp_joe_sound = 'sound/voice/joe/upp_joe/nado-posmotret.ogg'
	say_message = "I have to check."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = UPP_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/combust_on_its_own
	key = "combustonitsown"
	sound = 'sound/voice/joe/combust.ogg'
	haz_sound = 'sound/voice/joe/combust_haz.ogg'
	upp_joe_sound = 'sound/voice/joe/upp_joe/zagorelos.ogg'
	say_message = "I'll assume that didn't combust all on its own."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE|UPP_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/safety_log
	key = "safetylog"
	sound = 'sound/voice/joe/safety_log.ogg'
	haz_sound = 'sound/voice/joe/safety_log_haz.ogg'
	upp_joe_sound = 'sound/voice/joe/upp_joe/zurnal.ogg'
	say_message = "Safety log updated."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE|UPP_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/strange
	key = "strange"
	sound = 'sound/voice/joe/strange.ogg'
	haz_sound = 'sound/voice/joe/strange_haz.ogg'
	upp_joe_sound = 'sound/voice/joe/upp_joe/stranno.ogg'
	say_message = "Strange."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE|UPP_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/report_this
	key = "reportthis"
	sound = 'sound/voice/joe/report_this.ogg'
	haz_sound = 'sound/voice/joe/report_this_haz.ogg'
	say_message = "I'll have to report this."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/failed_support
	key = "failedsupport"
	sound = 'sound/voice/joe/failed_support_request.ogg'
	say_message = "Your failed support request has been logged with APOLLO."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/alarm_activated
	key = "alarmactivated"
	sound = 'sound/voice/joe/alarm_activated.ogg'
	haz_sound = 'sound/voice/joe/alarm_activated_haz.ogg'
	say_message = "Alarm activated, investigation commencing."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/potential_hazard
	key = "potentialhazard"
	sound = 'sound/voice/joe/potential_hazard.ogg'
	upp_joe_sound = 'sound/voice/joe/upp_joe/ugroza.ogg'
	say_message = "A potential hazard."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|UPP_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/saw_that
	key = "sawthat"
	sound = 'sound/voice/joe/saw_that.ogg'
	say_message = "I saw that."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/clean_up
	key = "cleanup"
	sound = 'sound/voice/joe/clean_up.ogg'
	haz_sound = 'sound/voice/joe/clean_up_haz.ogg'
	upp_joe_sound = 'sound/voice/joe/upp_joe/uborka.ogg'
	say_message = "Clean up required."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE|UPP_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/curious
	key = "curious"
	sound = 'sound/voice/joe/curious.ogg'
	haz_sound = 'sound/voice/joe/curious_haz.ogg'
	upp_joe_sound = 'sound/voice/joe/upp_joe/lybopitno.ogg'
	say_message = "Curious."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE|UPP_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/thats_odd
	key = "thatsodd"
	sound = 'sound/voice/joe/odd.ogg'
	haz_sound = 'sound/voice/joe/odd_haz.ogg'
	say_message = "That's odd."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/usually_happen
	key = "usuallyhappen"
	sound = 'sound/voice/joe/usually_happen.ogg'
	haz_sound = 'sound/voice/joe/usually_happen_haz.ogg'
	upp_joe_sound = 'sound/voice/joe/upp_joe/ne_bivaet.ogg'
	say_message = "This doesn't usually happen."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE|UPP_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/not_a_toy
	key = "notatoy"
	sound = 'sound/voice/joe/not_a_toy.ogg'
	haz_sound = 'sound/voice/joe/not_a_toy_haz.ogg'
	upp_joe_sound = 'sound/voice/joe/upp_joe/ne_igrushka.ogg'
	say_message = "That's not a toy."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE|UPP_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/made_a_mess
	key = "madeamess"
	sound = 'sound/voice/joe/made_a_mess.ogg'
	haz_sound = 'sound/voice/joe/made_a_mess_haz.ogg'
	say_message = "Somebody's made a mess."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/been_here
	key = "sbeenhere"
	sound = 'sound/voice/joe/been_here.ogg'
	haz_sound = 'sound/voice/joe/been_here_haz.ogg'
	upp_joe_sound = 'sound/voice/joe/upp_joe/kto_to_byl.ogg'
	say_message = "Someone's been here."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE|UPP_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/as_i_thought
	key = "asithought"
	sound = 'sound/voice/joe/as_i_thought.ogg'
	haz_sound = 'sound/voice/joe/as_i_thought_haz.ogg'
	upp_joe_sound = 'sound/voice/joe/upp_joe/dosadno.ogg'
	say_message = "As I thought. Unfortunate."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE|UPP_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/energy_surge
	key = "energysurge"
	sound = 'sound/voice/joe/energy_surge.ogg'
	haz_sound = 'sound/voice/joe/energy_surge_haz.ogg'
	upp_joe_sound = 'sound/voice/joe/upp_joe/skachok.ogg'
	say_message = "Energy surge detected."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE|UPP_JOE_EMOTE
