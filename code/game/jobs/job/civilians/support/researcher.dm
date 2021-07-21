
//Researcher
/datum/job/civilian/researcher
	title = JOB_RESEARCHER
	total_positions = 2
	spawn_positions = 2
	allow_additional = 1
	scaled = 1
	supervisors = "chief medical officer"
	selection_class = "job_researcher"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Researcher"
	entry_message_body = "You are a civilian, and are not subject to follow military chain of command, but you do work for the USCM. You are tasked with researching and developing new medical treatments, helping your fellow doctors, and generally learning new things. Your role involves a lot of roleplaying, but you can perform the function of a regular doctor. Do not hand out things to marines without getting permission from your supervisor."

/datum/job/civilian/researcher/set_spawn_positions(var/count)
	spawn_positions = rsc_slot_formula(count)

/datum/job/civilian/researcher/get_total_positions(var/latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = rsc_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

AddTimelock(/datum/job/civilian/researcher, list(
	JOB_MEDIC_ROLES = 5 HOURS
))

/obj/effect/landmark/start/researcher
	name = JOB_RESEARCHER
	job = /datum/job/civilian/researcher