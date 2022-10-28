/datum/job/command/pilot
	title = JOB_PILOT
	total_positions = 2
	spawn_positions = 2
	allow_additional = TRUE
	scaled = TRUE
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/po
	entry_message_body = "<a href='"+URL_WIKI_PO_GUIDE+"'>Your job is to fly, protect, and maintain the ship's dropship.</a> While you are an officer, your authority is limited to the dropship, where you have authority over the enlisted personnel. If you are not piloting, there is an autopilot fallback for command, but don't leave the dropship without reason."

AddTimelock(/datum/job/command/pilot, list(
	JOB_SQUAD_ROLES = 5 HOURS
))

/obj/effect/landmark/start/pilot
	name = JOB_PILOT
	job = /datum/job/command/pilot
