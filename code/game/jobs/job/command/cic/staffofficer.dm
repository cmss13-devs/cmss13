/datum/job/command/bridge
	title = JOB_SO
	total_positions = 5
	spawn_positions = 5
	allow_additional = 1
	scaled = 1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Staff Officer (SO)"

/datum/job/command/bridge/set_spawn_positions(var/count)
	spawn_positions = so_slot_formula(count)

/datum/job/command/bridge/get_total_positions(var/latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = so_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	return positions


/datum/job/command/bridge/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "Your job is to monitor the marines, man the CIC, and listen to your superior officers. You are in charge of logistics and the overwatch system. You are also in line to take command after the executive officer."
	return ..()

AddTimelock(/datum/job/command/bridge, list(
	JOB_SQUAD_LEADER = 1 HOURS,
	JOB_HUMAN_ROLES = 15 HOURS
))