/datum/job/marine/driver
	title = JOB_SQUAD_DRIVER
	total_positions = 8
	spawn_positions = 8
	allow_additional = 1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/uscm/driver
	entry_message_body = "Your job is to operate and maintain the ship's armored vehicles.</a> You are in charge of representing the armored presence amongst the marines during the operation, as well as maintaining and repairing your own vehicles."
	flags_startup_parameters = ROLE_ADD_TO_SQUAD

	job_options = list("Private" = "PVT", "Private First Class" = "PFC")

/datum/job/marine/driver/filter_job_option(mob/job_applicant)
	. = ..()

	var/list/filtered_job_options = list(job_options[1])

	if(job_applicant?.client?.prefs)
		if(get_job_playtime(job_applicant.client, JOB_SQUAD_DRIVER) >= JOB_PLAYTIME_TIER_1)
			filtered_job_options += list(job_options[2])

	return filtered_job_options

/datum/job/marine/driver/set_spawn_positions(count)
	spawn_positions = driver_slot_formula(count)

/datum/job/marine/driver/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = driver_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

AddTimelock(/datum/job/marine/driver, list(
	JOB_SQUAD_ROLES = 5 HOURS
))

/obj/effect/landmark/start/marine/driver
	name = JOB_SQUAD_DRIVER
	icon_state = "leader_spawn"
	job = /datum/job/marine/driver

/obj/effect/landmark/start/marine/driver/alpha
	icon_state = "leader_spawn_alpha"
	squad = SQUAD_MARINE_1

/obj/effect/landmark/start/marine/driver/bravo
	icon_state = "leader_spawn_bravo"
	squad = SQUAD_MARINE_2

/obj/effect/landmark/start/marine/driver/charlie
	icon_state = "leader_spawn_charlie"
	squad = SQUAD_MARINE_3

/obj/effect/landmark/start/marine/driver/delta
	icon_state = "leader_spawn_delta"
	squad = SQUAD_MARINE_4
