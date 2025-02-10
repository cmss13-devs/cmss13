/datum/job/logistics
	supervisors = "the auxiliary support officer"

/datum/timelock/engineer
	name = "Engineering Roles"

/datum/timelock/engineer/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_ENGINEER_ROLES_LIST

/datum/timelock/requisition
	name = "Requisition Roles"

/datum/timelock/requisition/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_REQUISITION_ROLES_LIST
