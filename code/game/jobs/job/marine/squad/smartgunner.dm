/datum/job/marine/smartgunner
	title = JOB_SQUAD_SMARTGUN
	total_positions = 4
	spawn_positions = 4
	allow_additional = 1
	scaled = 1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_ADD_TO_SQUAD
	gear_preset = "USCM (Cryo) Smartgunner"

/datum/job/marine/smartgunner/generate_entry_message()
	entry_message_body = "You are the smartgunner. Your job is to provide heavy weapons support."
	return ..()

/datum/job/marine/smartgunner/set_spawn_positions(var/count)
	spawn_positions = sg_slot_formula(count)

/datum/job/marine/smartgunner/get_total_positions(var/latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = sg_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	return positions

/datum/job/marine/smartgunner/equipped
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = "USCM Smartgunner"

/datum/job/marine/smartgunner/equipped/whiskey
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = "WO Dust Raider Squad Smartgunner"

AddTimelock(/datum/job/marine/smartgunner, list(
	JOB_SQUAD_ROLES = 5 HOURS
))

/obj/effect/landmark/start/marine/smartgunner
	name = JOB_SQUAD_SMARTGUN
	icon_state = "smartgunner_spawn"
	job = /datum/job/marine/smartgunner
