//Intelligence Officer
/datum/job/command/intel
	title = JOB_INTEL
	total_positions = 3
	spawn_positions = 3
	allow_additional = 1
	scaled = 1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Intelligence Officer (IO) (Cryo)"

/datum/job/command/intel/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "Your job is to assist the marines in collecting intelligence related to the current operation to better inform command of their opposition. You are in charge of gathering any data disks, folders, and notes you may find on the operational grounds in order to decrypt any data in order to further the DEFCON status."
	return ..()

/datum/job/command/intel/set_spawn_positions(var/count)
	spawn_positions = int_slot_formula(count)

/datum/job/command/intel/get_total_positions(var/latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = int_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	return positions

AddTimelock(/datum/job/command/intel, list(
	JOB_SQUAD_ROLES = 5 HOURS
))

/obj/effect/landmark/start/intel
	name = JOB_INTEL
	job = /datum/job/command/intel
