//Intelligence Officer
/datum/job/command/intel
	title = JOB_INTEL
	supervisors = "the auxiliary support officer"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = "USCM Intelligence Officer (IO) (Cryo)"
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>Your job is to assist the marines in collecting intelligence related</a> to the current operation to better inform command of their opposition. You are in charge of gathering any data disks, folders, and notes you may find on the operational grounds and decrypt them to grant the USCM additional resources."
	players_per_position = 30
	minimal_open_positions = 1
	maximal_open_positions = 3

AddTimelock(/datum/job/command/intel, list(
	JOB_SQUAD_ROLES = 5 HOURS
))

/obj/effect/landmark/start/intel
	name = JOB_INTEL
	icon_state = "io_spawn"
	job = /datum/job/command/intel
