/datum/job/marine/specialist
	title = JOB_SQUAD_SPECIALIST
	total_positions = 4
	spawn_positions = 4
	allow_additional = 1
	scaled = 1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_ADD_TO_SQUAD
	gear_preset = "USCM (Cryo) Squad Specialist"
	entry_message_body = "You are the very rare and valuable weapon expert, trained to use special equipment. You can serve a variety of roles, so choose carefully."

/datum/job/marine/specialist/set_spawn_positions(var/count)
	spawn_positions = spec_slot_formula(count)

/datum/job/marine/specialist/get_total_positions(var/latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = spec_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	return positions


/datum/job/marine/specialist/equipped
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = "USCM Cryo Specialist (Equipped)"

/datum/job/marine/specialist/equipped/whiskey
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = "WO Dust Raider Squad Specialist"

AddTimelock(/datum/job/marine/specialist, list(
	JOB_SQUAD_ROLES = 5 HOURS
))

/obj/effect/landmark/start/marine/spec
	name = JOB_SQUAD_SPECIALIST
	icon_state = "spec_spawn"
	job = /datum/job/marine/specialist