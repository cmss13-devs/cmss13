/datum/job/command/pilot
	title = JOB_PILOT
	total_positions = 2
	spawn_positions = 2
	allow_additional = TRUE
	scaled = TRUE
	supervisors = "the auxiliary support officer"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/po
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>Your job is to fly, protect, and maintain the ship's dropship.</a> You have authority over your assigned dropship and personnel within its walls, as long as it does not conflict with Standard Operating Procedure, or Marine Law. If you are not piloting, there is an autopilot fallback for command, but don't leave the dropship without reason. You should notify the Acting Commander if you are incapacitated or cannot continue your duties. You are 8th in line for Acting Commander, behind the Chief Engineer"

// Dropship Roles is both PO and DCC combined to not force people to backtrack
AddTimelock(/datum/job/command/pilot, list(
	JOB_DROPSHIP_ROLES = 2 HOURS
))

/obj/effect/landmark/start/pilot
	name = JOB_PILOT
	icon_state = "po_spawn"
	job = /datum/job/command/pilot
