#define STANDARD_MARINE_TO_TOTAL_SPAWN_RATIO 0.4

/datum/job/marine/standard
	title = JOB_SQUAD_MARINE
	total_positions = -1
	spawn_positions = -1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/uscm/pfc
	entry_message_body = "You are a rank-and-file Marine of the USCM, and that is your strength. What you lack alone, you gain standing shoulder to shoulder with the men and women of the corps. Ooh-rah!"

/datum/job/marine/standard/whiskey
	title = JOB_WO_SQUAD_MARINE
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/wo/marine/pfc

/obj/effect/landmark/start/marine
	name = JOB_SQUAD_MARINE
	icon_state = "marine_spawn"
	job = /datum/job/marine/standard

/datum/job/marine/standard/set_spawn_positions(var/count)
	spawn_positions =  max((round(count * STANDARD_MARINE_TO_TOTAL_SPAWN_RATIO)), 8)
