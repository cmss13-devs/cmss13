/datum/paygrade/cia
	name = "CIA Paygrade"
	pay_multiplier = 2 // CIA are well paid
	default_faction = FACTION_CIA

/datum/paygrade/cia/officer
	paygrade = PAY_SHORT_CIA_O
	name = "Officer"
	prefix = "Off."

/datum/paygrade/cia/officer/senior
	paygrade = PAY_SHORT_CIA_SO
	name = "Senior Officer"
	prefix = "Sr. Off."
	officer_grade = GRADE_OFFICER
	pay_multiplier = 2.2

/datum/paygrade/cia/agent
	paygrade = PAY_SHORT_CIA_A
	name = "Agent"
	prefix = "Agt."
	pay_multiplier = 2.4

/datum/paygrade/cia/int_analyst
	paygrade = PAY_SHORT_CIA_IA
	name = "Intelligence Analyst"
	prefix = "C"
	pay_multiplier = 2.4

/datum/paygrade/cia/spec_agent
	paygrade = PAY_SHORT_CIA_SA
	name = "Special Agent"
	prefix = "SpAgt."
	pay_multiplier = 2.8

/datum/paygrade/cia/administrator
	paygrade = PAY_SHORT_CIA_ADM
	name = "Administrator"
	prefix = "Admn."
	officer_grade = GRADE_OFFICER
	pay_multiplier = 3

/datum/paygrade/cia/senior_admin
	paygrade = PAY_SHORT_CIA_SADM
	name = "Senior Administrator"
	prefix = "SAdmn."
	officer_grade = GRADE_OFFICER
	pay_multiplier = 3.3

/datum/paygrade/cia/acting_commissioner
	paygrade = PAY_SHORT_CIA_ACOM
	name = "Acting Commissioner"
	prefix = "ACom."
	officer_grade = GRADE_OFFICER
	pay_multiplier = 3.5

/datum/paygrade/cia/commissioner
	paygrade = PAY_SHORT_CIA_COM
	name = "Commissioner"
	prefix = "Com."
	officer_grade = GRADE_FLAG
	pay_multiplier = 4

/datum/paygrade/cia/director_general
	paygrade = PAY_SHORT_CIA_DG
	name = "Director General"
	prefix = "DG."
	officer_grade = GRADE_FLAG
	pay_multiplier = 8

/datum/paygrade/cia/secretary_general
	paygrade = PAY_SHORT_CIA_SG
	name = "Secretary General"
	prefix = "SG."
	officer_grade = GRADE_FLAG
	pay_multiplier = 10

/datum/paygrade/cia/grs
	fprefix = "GRS."
	paygrade = PAY_SHORT_GRS_OPR
	name = "Operator"
	prefix = "Opr."
	pay_multiplier = 2.8

/datum/paygrade/cia/grs/medic
	paygrade = PAY_SHORT_GRS_MED
	name = "Medical Operator"
	prefix = "MedOpr."
	pay_multiplier = 3

/datum/paygrade/cia/grs/technical
	paygrade = PAY_SHORT_GRS_ENG
	name = "Technical Operator"
	prefix = "TechOpr."
	pay_multiplier = 3

/datum/paygrade/cia/grs/heavy
	paygrade = PAY_SHORT_GRS_HVY
	name = "Heavy Operator"
	prefix = "HvyOpr."
	pay_multiplier = 3.3

/datum/paygrade/cia/grs/sniper
	paygrade = PAY_SHORT_GRS_SNP
	name = "Advanced Marksman"
	prefix = "AdvMrk."
	pay_multiplier = 3.3

/datum/paygrade/cia/grs/leader
	paygrade = PAY_SHORT_GRS_TL
	name = "Team Leader"
	prefix = "TL."
	pay_multiplier = 3.5
	officer_grade = GRADE_OFFICER



