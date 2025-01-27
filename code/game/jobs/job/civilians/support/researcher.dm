
//Researcher
/datum/job/civilian/researcher
	title = JOB_RESEARCHER
	total_positions = 2
	spawn_positions = 2
	scaled = 1
	supervisors = "chief medical officer"
	selection_class = "job_researcher"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/researcher
	entry_message_body = "You're a commissioned officer of the USCM. You are tasked with <a href='"+WIKI_PLACEHOLDER+"'>researching</a> and developing new medical treatments, helping your fellow doctors, and generally learning new things. Your role involves a lot of roleplaying, but you can perform the function of a regular doctor. Do not hand out things to Marines without getting permission from your supervisor."
	players_per_position = 60
	minimal_open_positions = 2
	maximal_open_positions = 3

AddTimelock(/datum/job/civilian/researcher, list(
	JOB_MEDIC_ROLES = 5 HOURS
))

/obj/effect/landmark/start/researcher
	name = JOB_RESEARCHER
	icon_state = "res_spawn"
	job = /datum/job/civilian/researcher
