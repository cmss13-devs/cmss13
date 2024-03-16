/datum/job/command/cas_pilot
	title = JOB_CAS_PILOT
	total_positions = 1
	spawn_positions = 1
	allow_additional = TRUE
	scaled = TRUE
	supervisors = "the auxiliary support officer"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/po
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>Your job is to fly, protect, and maintain the ship's gunship.</a> While you are an officer, your authority is limited to the dropship, where you have authority over the enlisted personnel."

// Dropship Roles is both PO and DCC combined to not force people to backtrack
AddTimelock(/datum/job/command/cas_pilot, list(
	JOB_DROPSHIP_ROLES = 2 HOURS
))

/obj/effect/landmark/start/pilot
	name = JOB_CAS_PILOT
	icon_state = "po_spawn"
	job = /datum/job/command/pilot
