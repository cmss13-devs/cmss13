
/datum/job/command/walker
	title = JOB_WALKER
	total_positions = 1
	spawn_positions = 1
	allow_additional = 1
	scaled = 0
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm/walker
	entry_message_body = "Your job is to operate and maintain thee ship's combat walkers. While you are an officer, your authority is limited to your own vehicle."

AddTimelock(/datum/job/command/walker, list(
	JOB_SQUAD_ROLES = 2 HOURS,
	JOB_ENGINEER_ROLES = 2 HOURS
))

/obj/effect/landmark/start/mech_crew
	name = JOB_CREWMAN
	job = /datum/job/command/walker
