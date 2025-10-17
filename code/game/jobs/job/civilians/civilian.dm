/datum/job/civilian
	gear_preset = /datum/equipment_preset/colonist

/datum/timelock/medic
	name = "Medical Roles"

/datum/timelock/medic/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_MEDIC_ROLES_LIST

/datum/timelock/doctor
	name = "Doctor Roles"

/datum/timelock/doctor/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_DOCTOR_ROLES_LIST

/datum/timelock/research
	name = "Research Roles"

/datum/timelock/research/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_RESEARCH_ROLES_LIST

/datum/timelock/corporate
	name = "Corporate Roles"

/datum/timelock/corporate/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_CORPORATE_ROLES_LIST


/datum/timelock/civil
	name = "Civil Roles"

/datum/timelock/civil/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_CIVIL_ROLES_LIST
