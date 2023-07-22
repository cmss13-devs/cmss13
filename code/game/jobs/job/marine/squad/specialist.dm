/datum/job/marine/specialist
	title = JOB_SQUAD_SPECIALIST
	total_positions = 4
	spawn_positions = 4
	allow_additional = 1
	scaled = 1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/uscm/spec
	entry_message_body = "<a href='"+URL_WIKI_SPEC_GUIDE+"'>You are the very rare and valuable weapon expert</a>, trained to use special equipment. You can serve a variety of roles, so choose carefully."

/datum/job/marine/specialist/set_spawn_positions(count)
	spawn_positions = spec_slot_formula(count)

/datum/job/marine/specialist/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = spec_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions


/datum/job/marine/specialist/whiskey
	title = JOB_WO_SQUAD_SPECIALIST
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/wo/marine/spec

AddTimelock(/datum/job/marine/specialist, list(
	JOB_SQUAD_ROLES = 5 HOURS
))

/obj/effect/landmark/start/marine/spec
	name = JOB_SQUAD_SPECIALIST
	icon_state = "spec_spawn"
	job = /datum/job/marine/specialist

/obj/effect/landmark/start/marine/spec/alpha
	icon_state = "spec_spawn_alpha"
	squad = SQUAD_MARINE_1

/obj/effect/landmark/start/marine/spec/bravo
	icon_state = "spec_spawn_bravo"
	squad = SQUAD_MARINE_2

/obj/effect/landmark/start/marine/spec/charlie
	icon_state = "spec_spawn_charlie"
	squad = SQUAD_MARINE_3

/obj/effect/landmark/start/marine/spec/delta
	icon_state = "spec_spawn_delta"
	squad = SQUAD_MARINE_4
