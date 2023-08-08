/datum/job/command
	selection_class = "job_command"
	supervisors = "the acting commander"
	total_positions = 1
	spawn_positions = 1

/datum/job/command/auxiliary
	supervisors = "the auxiliary support officer"

/datum/timelock/command
	name = "Command Roles"

/datum/timelock/command/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_COMMAND_ROLES_LIST

/datum/timelock/mp
	name = "MP Roles"

/datum/timelock/mp/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_POLICE_ROLES_LIST

/datum/timelock/human
	name = "Human Roles"

/datum/timelock/human/can_play(client/C)
	return C.get_total_human_playtime() >= time_required

/datum/timelock/human/get_role_requirement(client/C)
	return time_required - C.get_total_human_playtime()

