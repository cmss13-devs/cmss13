
// NSPA - (Neroid Sector Policing Authority) - TWE style Police, like the CMB but for heavy TWE focused colonies.

/datum/paygrade/nspa
	name = "NSPA Paygrade"
	pay_multiplier = 1.4 // Government work. Nice benefits.
	default_faction = FACTION_NSPA

/datum/paygrade/nspa/constable
	paygrade = PAY_SHORT_CST
	name = "Constable"
	prefix = "Cst."

/datum/paygrade/nspa/senior_constable
	paygrade = PAY_SHORT_SC
	name = "Senior Constable"
	prefix = "Sr. Cst."
	pay_multiplier = 1.6

/datum/paygrade/nspa/sergeant
	paygrade = PAY_SHORT_SGT
	name = "Sergeant"
	prefix = "Sgt."
	pay_multiplier = 1.7

/datum/paygrade/nspa/inspector
	paygrade = PAY_SHORT_INSP
	name = "Inspector"
	prefix = "Insp."
	officer_grade = GRADE_OFFICER
	pay_multiplier = 1.8

/datum/paygrade/nspa/chief_inspector
	paygrade = PAY_SHORT_CINSP
	name = "Chief Inspector"
	prefix = "Ch. Insp."
	officer_grade = GRADE_OFFICER
	pay_multiplier = 2

/datum/paygrade/nspa/commander
	paygrade = PAY_SHORT_CMD
	name = "Commander"
	prefix = "Cmdr."
	officer_grade = GRADE_OFFICER
	pay_multiplier = 3

/datum/paygrade/nspa/deputy_commissioner
	paygrade = PAY_SHORT_DCO
	name = "Deputy Commissioner"
	prefix = "Dep. Com."
	officer_grade = GRADE_OFFICER
	pay_multiplier = 4

/datum/paygrade/nspa/commissioner
	paygrade = PAY_SHORT_COM
	name = "Commissioner"
	prefix = "Com."
	officer_grade = GRADE_OFFICER
	pay_multiplier = 5
