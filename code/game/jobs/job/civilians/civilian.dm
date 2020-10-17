/datum/job/civilian
	gear_preset = "Colonist"

/datum/timelock/medic
	name = "Medical Roles"

/datum/timelock/medic/New(name, time_required, list/roles)
	. = ..()
	roles = JOB_MEDIC_ROLES_LIST