
//Researcher
/datum/job/civilian/researcher
	title = JOB_RESEARCHER
	total_positions = 2
	spawn_positions = 2
	allow_additional = 1
	scaled = 1
	supervisors = "the chief medical officer and the Wey-Yu corporate office"
	selection_class = "job_researcher"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/researcher
	entry_message_body = "You're a researcher contracted by Weyland-Yutani to work onboard the Almayer. You are tasked with <a href='"+WIKI_PLACEHOLDER+"'>research</a> and development, and you should be taking every opportunity this operation will throw at you to discover new things. Your role involves a lot of roleplaying, and you have the skills to work as a medical doctor if the situation requires. Any new discovery must be kept away from marine hands unless the distribution has been authorized by your supervisor. You do not answer to the Corporate Liaison."

/datum/job/civilian/researcher/set_spawn_positions(count)
	spawn_positions = rsc_slot_formula(count)

/datum/job/civilian/researcher/get_total_positions(latejoin = 0)
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
	icon_state = "res_spawn"
	job = /datum/job/civilian/researcher
