/datum/job/civilian/chef
	title = JOB_MESS_SERGEANT
	total_positions = 1
	spawn_positions = 1
	selection_class = "job_ot"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	supervisors = "the auxiliary support officer"
	gear_preset = /datum/equipment_preset/uscm_ship/chef
	entry_message_body = "<a href='%WIKIURL%'>Your job is to service the marines with excellent food</a>, drinks and entertaining the shipside crew when needed. You have a lot of freedom and it is up to you, to decide what to do with it. Good luck!"

/obj/effect/landmark/start/chef
	name = JOB_MESS_SERGEANT
	icon_state = "chef_spawn"
	job = /datum/job/civilian/chef
