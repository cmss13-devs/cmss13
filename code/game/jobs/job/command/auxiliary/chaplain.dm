/datum/job/command/auxiliary/chaplain
	title = JOB_CHAPLAIN
	total_positions = 1
	spawn_positions = 1
	allow_additional = TRUE
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/chaplain
	entry_message_body = "You are charged with helping the marines of the USS Almayer find spiritual peace and providing a safe space for them to talk and address their sins. Further, you are responsible for ensuring the last rites are given to the dead and dying."

AddTimelock(/datum/job/command/auxiliary/chaplain, list(
	JOB_AUXILIARY_ROLES = 5 HOURS,
))

/obj/effect/landmark/start/chaplain
	name = JOB_CHAPLAIN
	job = /datum/job/command/auxiliary/chaplain
	icon_state = "chp_spawn"

