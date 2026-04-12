/datum/job/command/tank_crew
	title = JOB_TANK_CREW
	total_positions = 4
	spawn_positions = 4
	allow_additional = TRUE
	scaled = FALSE
	supervisors = "the acting commanding officer"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm/tank
	entry_message_body = "Your job is to operate and maintain the ship's armored vehicles. You are in charge of representing the armored presence amongst the marines during the operation, as well as maintaining and repairing your own vehicles."

/datum/job/command/tank_crew/set_spawn_positions(count)
	spawn_positions = 4

/datum/job/command/tank_crew/get_total_positions(latejoin = FALSE)
	return 4

/obj/effect/landmark/start/tank_crew
	name = JOB_TANK_CREW
	icon_state = "vc_spawn"
	job = /datum/job/command/tank_crew
