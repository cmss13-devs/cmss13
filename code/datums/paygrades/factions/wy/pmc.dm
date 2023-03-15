/datum/paygrade/pmc
	name = "PMC Paygrade"
	fprefix = "PMC."
	pay_multiplier = 2.5 // they have money. but they sold their soul to the company. is it really worth it

//Standard PMCs
/datum/paygrade/pmc/standard
	paygrade = "PMC-OP"
	name = "Operator"
	prefix = "OPR."

/datum/paygrade/pmc/enforcer
	paygrade = "PMC-EN"
	name = "Enforcer"
	prefix = "ENF."
	pay_multiplier = 2.6

//PMC Field Specialists
/datum/paygrade/pmc/vehicle
	paygrade = "PMC-VS"
	name = "Vehicle Specialist"
	prefix = "CRW."
	pay_multiplier = 2.8

/datum/paygrade/pmc/support
	paygrade = "PMC-SS"
	name = "Support Specialist"
	prefix = "SPS."
	pay_multiplier = 2.8

/datum/paygrade/pmc/medic
	paygrade = "PMC-MS"
	name = "Medical Specialist"
	prefix = "SPM."
	pay_multiplier = 2.8

/datum/paygrade/pmc/spec
	paygrade = "PMC-WS"
	name = "Weapon Specialist"
	prefix = "SPW."
	pay_multiplier = 3

/datum/paygrade/pmc/handler
	paygrade = "PMC-XS"
	name = "Xeno Specialist"
	prefix = "SPX."
	pay_multiplier = 4

//PMC Elite
/datum/paygrade/pmc/elite
	paygrade = "PMC-ELR"
	name = "Elite Responder"
	prefix = "ELR."
	pay_multiplier = 4

/datum/paygrade/pmc/medic/elite
	paygrade = "PMC-ELM"
	name = "Elite Medic"
	prefix = "ELM."
	pay_multiplier = 4.5

/datum/paygrade/pmc/spec/elite
	paygrade = "PMC-ELG"
	name = "Elite Gunner"
	prefix = "ELG."
	pay_multiplier = 5

//PMC Command
/datum/paygrade/pmc/teamlead
	paygrade = "PMC-TL"
	name = "Team Leader"
	prefix = "TML."
	pay_multiplier = 3.5

/datum/paygrade/pmc/elitelead
	paygrade = "PMC-ETL"
	name = "Elite Team Leader"
	prefix = "ETML."
	pay_multiplier = 5.5

/datum/paygrade/pmc/doctor
	paygrade = "PMC-DOC"
	name = "Trauma Surgeon"
	prefix = "TRI."
	pay_multiplier = 4

/datum/paygrade/pmc/engineer
	paygrade = "PMC-TECH"
	name = "Corporate Technician"
	prefix = "TEC."
	pay_multiplier = 4

/datum/paygrade/pmc/director
	paygrade = "PMC-DIR"
	name = "Site Director"
	prefix = "DIR."
	pay_multiplier = 10 //it's a corpo director. money is what they care about.
