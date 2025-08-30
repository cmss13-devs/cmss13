/datum/paygrade/wy_sec
	name = "Corporate Security Paygrade"
	pay_multiplier = 1
	default_faction = FACTION_WY

/datum/paygrade/wy_sec/standard
	paygrade = PAY_SHORT_WY_SEC
	name = "Corporate Security Officer"
	prefix = "Off."

/datum/paygrade/wy_sec/specialist
	paygrade = PAY_SHORT_WY_SEC_SPEC
	name = "Senior Corporate Security Officer"
	prefix = "Sr. Off."
	pay_multiplier = 2

/datum/paygrade/wy_sec/leader
	paygrade = PAY_SHORT_WY_SEC_LEAD
	name = "Corporate Security Sergeant"
	prefix = "CSSgt."
	pay_multiplier = 3

/datum/paygrade/wy_sec/bodyguard
	paygrade = PAY_SHORT_WY_SEC_PPO
	name = "Personal Protection Officer"
	prefix = "PPO."
	pay_multiplier = 3

/datum/paygrade/wy_sec/bodyguard/grade_2
	paygrade = PAY_SHORT_WY_SEC_PPS
	name = "Personal Protection Specialist"
	prefix = "PPS."
	pay_multiplier = 3.3

/datum/paygrade/wy_sec/bodyguard/grade_3
	paygrade = PAY_SHORT_WY_SEC_PPC
	name = "Personal Protection Coordinator"
	prefix = "PPC."
	pay_multiplier = 4
