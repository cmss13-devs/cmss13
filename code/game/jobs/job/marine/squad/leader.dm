/datum/job/marine/leader
	title = JOB_SQUAD_LEADER
	total_positions = 4
	spawn_positions = 4
	supervisors = "the acting commanding officer"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_ADD_TO_SQUAD
	gear_preset = "USCM (Cryo) Squad Leader"

/datum/job/marine/leader/generate_entry_message()
	entry_message_body = "You are responsible for the men and women of your squad. Make sure they are on task, working together, and communicating. You are also in charge of communicating with command and letting them know about the situation first hand. Keep out of harm's way."
	return ..()

/datum/job/marine/leader/equipped
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = "USCM Cryo Squad Leader (Equipped)"

/datum/job/marine/leader/equipped/whiskey
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = "WO Dust Raider Squad Leader"

AddTimelock(/datum/job/marine/leader, list(
	JOB_SQUAD_ROLES = 10 HOURS
))

/obj/effect/landmark/start/marine/leader
	name = JOB_SQUAD_LEADER
	icon_state = "leader_spawn"
	job = /datum/job/marine/leader
