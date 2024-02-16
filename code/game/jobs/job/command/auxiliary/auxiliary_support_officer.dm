/datum/job/command/auxiliary_officer
	title = JOB_AUXILIARY_OFFICER
	total_positions = 1
	spawn_positions = 1
	supervisors = "the acting commander"
	allow_additional = TRUE
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/auxiliary_officer
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>Your job is to oversee</a> the hangar crew, the intel officers, the engineering department, and requisitions bay. You have many responsibilities to oversee, but ensure you are delegating to your subordinates. You will find great relief in coordinating with the department heads under you, rather than their subordinates. You are 3rd in line for Acting Commander, behind the Executive Officer."

AddTimelock(/datum/job/command/auxiliary_officer, list(
	JOB_REQUISITION_ROLES = 6 HOURS,
	JOB_ENGINEER_ROLES = 12 HOURS,
	JOB_JOB_MAINT_TECH = 3 HOURS,
	JOB_ORDNANCE_TECH = 6 HOURS,
	JOB_AUXILIARY_ROLES = 9 HOURS
))

/obj/effect/landmark/start/auxiliary_officer
	name = JOB_AUXILIARY_OFFICER
	job = /datum/job/command/auxiliary_officer

/datum/timelock/auxiliary
	name = "Auxiliary Roles"

/datum/timelock/auxiliary/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_AUXILIARY_ROLES_LIST
