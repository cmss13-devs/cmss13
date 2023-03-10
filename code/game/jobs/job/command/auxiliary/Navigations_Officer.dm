/datum/job/command/navigation
	title = JOB_NAVIGATIONS
	total_positions = 1
	spawn_positions = 1
	allow_additional = 1
	scaled = FALSE
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/no
	entry_message_body = "Your job is to monitor Almayer's orbital height or man the CIC if requested. Listen to your superior officers.</a> You are in charge of Navigation, Logistics and the overwatch system. You are also in line to take command after other eligible superior commissioned officers. SOP forbids you from deploying and you may not deploy unless it is modified."

/datum/job/command/navigation/set_spawn_positions(count)
	spawn_positions = so_slot_formula(count)

/datum/job/command/navigation/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = so_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

/datum/job/command/navigation/generate_entry_message(mob/living/carbon/human/H)
	return ..()

AddTimelock(/datum/job/command/navigation, list(
	JOB_PILOT = 1 HOURS,
	JOB_SO = 3 HOURS,
	JOB_HUMAN_ROLES = 15 HOURS
))

/obj/effect/landmark/start/bridge
	name = JOB_NAVIGATIONS
	job = /datum/job/command/navigation
