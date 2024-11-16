/datum/paygrade/provost
	name = "Provost Paygrade"
	pay_multiplier = 2
	default_faction = FACTION_MARINE

/datum/paygrade/provost/inspector
	paygrade = PAY_SHORT_PVI
	name = "Provost Inspector"
	prefix = "Insp."
	rank_pin = /obj/item/clothing/accessory/ranks/special/insp
	officer_grade = GRADE_FLAG //Not really a flag officer, but they have special access to things for their job.

/datum/paygrade/provost/inspector/chief
	paygrade = PAY_SHORT_PVCI
	name = "Provost Chief Inspector"
	prefix = "Chief Insp."
	rank_pin = /obj/item/clothing/accessory/ranks/special/insp
	officer_grade = GRADE_FLAG //Not really a flag officer, but they have special access to things for their job.

/datum/paygrade/provost/marshal/deputy
	paygrade = PAY_SHORT_PVDM
	name = "Provost Deputy Marshal"
	prefix = "Dep. Marshal"
	officer_grade = GRADE_FLAG

/datum/paygrade/provost/marshal
	paygrade = PAY_SHORT_PVM
	name = "Provost Marshal"
	prefix = "Marshal"
	officer_grade = GRADE_FLAG

/datum/paygrade/provost/sectormarshal
	paygrade = PAY_SHORT_PVSM
	name = "Provost Sector Marshal"
	prefix = "S. Marshal"
	officer_grade = GRADE_FLAG

/datum/paygrade/provost/chiefmarshal
	paygrade = PAY_SHORT_PVCM
	name = "Provost Chief Marshal"
	prefix = "Chief Marshal"
	officer_grade = GRADE_FLAG
