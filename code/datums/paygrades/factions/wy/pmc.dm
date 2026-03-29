/datum/paygrade/pmc
	name = "PMC Paygrade"
	fprefix = "PMC."
	pay_multiplier = 2.5 // they have money. but they sold their soul to the company. is it really worth it
	default_faction = FACTION_PMC

//Standard PMCs
/datum/paygrade/pmc/standard
	paygrade = PAY_SHORT_PMC_OP
	name = "Operator"
	prefix = "OPR."

/datum/paygrade/pmc/enforcer
	paygrade = PAY_SHORT_PMC_EN
	name = "Enforcer"
	prefix = "ENF."
	pay_multiplier = 2.6

//PMC Field Specialists
/datum/paygrade/pmc/vehicle
	paygrade = PAY_SHORT_PMC_VS
	name = "Vehicle Specialist"
	prefix = "SPV."
	pay_multiplier = 2.8

/datum/paygrade/pmc/support
	paygrade = PAY_SHORT_PMC_SS
	name = "Support Specialist"
	prefix = "SPS."
	pay_multiplier = 2.8

/datum/paygrade/pmc/medic
	paygrade = PAY_SHORT_PMC_MS
	name = "Medical Specialist"
	prefix = "SPM."
	pay_multiplier = 2.8

/datum/paygrade/pmc/spec
	paygrade = PAY_SHORT_PMC_WS
	name = "Weapon Specialist"
	prefix = "SPW."
	pay_multiplier = 3

/datum/paygrade/pmc/crowd_control
	paygrade = PAY_SHORT_PMC_CCS
	name = "Crowd Control Specialist"
	prefix = "SPCC."
	pay_multiplier = 4

//PMC Support Staff
/datum/paygrade/pmc/doctor
	paygrade = PAY_SHORT_PMC_DOC
	name = "Trauma Surgeon"
	prefix = "Dr."
	pay_multiplier = 4
	officer_grade = GRADE_OFFICER

/datum/paygrade/pmc/engineer
	paygrade = PAY_SHORT_PMC_TEC
	name = "Corporate Technician"
	prefix = "TEC."
	pay_multiplier = 4

//PMC Command
/datum/paygrade/pmc/teamlead
	paygrade = PAY_SHORT_PMC_TL
	name = "Team Leader"
	prefix = "TML."
	pay_multiplier = 3.5
	officer_grade = GRADE_OFFICER

/datum/paygrade/pmc/field_op_leader
	paygrade = PAY_SHORT_PMC_FOL
	name = "Field Operations Leader"
	prefix = "FOL."
	pay_multiplier = 6
	officer_grade = GRADE_FLAG

/datum/paygrade/pmc/director
	paygrade = PAY_SHORT_PMC_DIR
	name = "Site Director"
	prefix = "DIR."
	pay_multiplier = 10 //it's a corpo director. money is what they care about.
	officer_grade = GRADE_FLAG
