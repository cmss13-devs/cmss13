/datum/job/command/vehicle_crewmen
	title = JOB_TANKCREW
	total_positions = 2
	spawn_positions = 2
	allow_additional = 1
	scaled = 0
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm/tank
	entry_message_body = "Your job is to operate and maintain the ship's armored vehicles. </a> You are in charge of representing the armored presence amongst the marines during the operation, as well as maintaining and repairing your own vehicles."


/obj/effect/landmark/start/vehicle_crewmen
	name = JOB_TANKCREW
	job = /datum/job/command/vehicle_crewmen
