/datum/job/command/pilot
	title = JOB_PILOT
	total_positions = 3
	spawn_positions = 2
	allow_additional = 1
	scaled = 1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Pilot Officer (PO) (Cryo)"

/datum/job/command/pilot/set_spawn_positions(var/count)
	spawn_positions = po_slot_formula(count)

/datum/job/command/pilot/get_total_positions(var/latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = po_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	return positions


/datum/job/command/pilot/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "Your job is to fly, protect, and maintain the ship's dropship. While you are an officer, your authority is limited to the dropship, where you have authority over the enlisted personnel. If you are not piloting, there is an autopilot fallback for command, but don't leave the dropship without reason."
	return ..()

AddTimelock(/datum/job/command/pilot, list(
	JOB_SQUAD_ROLES = 5 HOURS
))

/obj/effect/landmark/start/pilot
	name = JOB_PILOT
	job = /datum/job/command/pilot
