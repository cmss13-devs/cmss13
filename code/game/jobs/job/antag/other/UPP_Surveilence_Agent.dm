/datum/job/antag/UPP_Surveilence_Agent
	title = JOB_UPP_SURVEILENCE
	total_positions = 3
	spawn_positions = 3
	allow_additional = 1
	scaled = 1
	selection_class = "job_UPP_surveilence"
	supervisors = "UPP High Command"
	gear_preset = /datum/equipment_preset/upp/soldier

	handle_spawn_and_equip = TRUE

/obj/effect/landmark/start/surveilence
	name = JOB_UPP_SURVEILENCE
	icon_state = "surveilence_spawn"
	job = /datum/job/antag/UPP_Surveilence_Agent
