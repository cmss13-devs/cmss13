/datum/job/civilian
	gear_preset = /datum/equipment_preset/colonist

/datum/timelock/medic
	name = "Medical Roles"

/datum/timelock/medic/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_MEDIC_ROLES_LIST

/datum/timelock/medbay
	name = "Medbay Roles"

/datum/timelock/medbay/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_MEDBAY_ROLES_LIST
