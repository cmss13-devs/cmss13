//Cargo Tech. Don't ask why this is in engineering
/datum/job/logistics/tech/cargo
	title = JOB_CARGO_TECH
	total_positions = 2
	spawn_positions = 2
	allow_additional = 1
	scaled = 1
	supervisors = "the requisitions officer"
	selection_class = "job_ct"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Cargo Technician (CT)"

/datum/job/logistics/tech/cargo/set_spawn_positions(var/count)
	spawn_positions = ct_slot_formula(count)

/datum/job/logistics/tech/cargo/get_total_positions(var/latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = ct_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	return positions


/datum/job/logistics/tech/cargo/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "Your job is to dispense supplies to the marines, including weapon attachments. Stay in your department when possible to ensure the marines have full access to the supplies they may require. Listen to the radio in case someone requests a supply drop via the overwatch system."
	return ..()