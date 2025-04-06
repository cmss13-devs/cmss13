/datum/job/command/pilot/operations_pilot
	title = JOB_OPERATIONS_PILOT
	total_positions = 1
	spawn_positions = 1
	supervisors = "the auxiliary support officer"
	flags_startup_parameters = ROLE_HIDDEN
	gear_preset = /datum/equipment_preset/uscm_ship/op
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>Your job is to fly, protect, and maintain the AD-19D blackfoot.</a> While you are an officer, your authority is limited to the vtol, where you have authority over the enlisted personnel."

/obj/effect/landmark/start/pilot/operations_pilot
	name = JOB_OPERATIONS_PILOT
	icon_state = "dp_spawn"
	job = /datum/job/command/pilot/operations_pilot
