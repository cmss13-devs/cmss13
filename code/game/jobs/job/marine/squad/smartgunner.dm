/datum/job/marine/smartgunner
	title = JOB_SQUAD_SMARTGUN
	total_positions = 4
	spawn_positions = 4
	allow_additional = 1
	scaled = 1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/uscm/sg
	entry_message_body = "You are the smartgunner. Your task is to provide heavy weapons support."

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
	else
		total_positions_so_far = positions
	return positions

/datum/job/marine/smartgunner/whiskey
	title = JOB_WO_SQUAD_SMARTGUNNER
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/wo/marine/sg

AddTimelock(/datum/job/marine/smartgunner, list(
	JOB_SQUAD_ROLES = 5 HOURS
))

/obj/effect/landmark/start/marine/smartgunner
	name = JOB_SQUAD_SMARTGUN
	icon_state = "smartgunner_spawn"
	job = /datum/job/marine/smartgunner

/obj/effect/landmark/start/marine/smartgunner/alpha
	icon_state = "smartgunner_spawn_alpha"
	squad = SQUAD_MARINE_1

/obj/effect/landmark/start/marine/smartgunner/bravo
	icon_state = "smartgunner_spawn_bravo"
	squad = SQUAD_MARINE_2

/obj/effect/landmark/start/marine/smartgunner/charlie
	icon_state = "smartgunner_spawn_charlie"
	squad = SQUAD_MARINE_3

/obj/effect/landmark/start/marine/smartgunner/delta
	icon_state = "smartgunner_spawn_delta"
	squad = SQUAD_MARINE_4
