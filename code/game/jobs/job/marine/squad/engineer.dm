/datum/job/marine/engineer
	title = JOB_SQUAD_ENGI
	total_positions = 12
	spawn_positions = 12
	allow_additional = 1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/uscm/engineer
	entry_message_body = "You have the <a href='"+WIKI_PLACEHOLDER+"'>equipment and skill</a> to build fortifications, reroute power lines, and bunker down. Your squaddies will look to you when it comes to construction in the field of battle."

/datum/job/marine/engineer/set_spawn_positions(count)
	for(var/datum/squad/sq in GLOB.RoleAuthority.squads)
		if(sq)
			sq.max_engineers = engi_slot_formula(count)

/datum/job/marine/engineer/get_total_positions(latejoin = FALSE)
	var/real_max_positions = 0
	for(var/datum/squad/squad in GLOB.RoleAuthority.squads)
		if(squad.roundstart && squad.usable && squad.faction == FACTION_MARINE && squad.name != "Root")
			real_max_positions += squad.max_engineers

	if(real_max_positions > total_positions_so_far)
		total_positions_so_far = real_max_positions

	spawn_positions = real_max_positions

	return real_max_positions

/datum/job/marine/engineer/whiskey
	title = JOB_WO_SQUAD_ENGINEER
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/wo/marine/engineer

AddTimelock(/datum/job/marine/engineer, list(
	JOB_SQUAD_ROLES = 1 HOURS
))

/obj/effect/landmark/start/marine/engineer
	name = JOB_SQUAD_ENGI
	icon_state = "engi_spawn"
	job = /datum/job/marine/engineer

/obj/effect/landmark/start/marine/engineer/alpha
	icon_state = "engi_spawn_alpha"
	squad = SQUAD_MARINE_1

/obj/effect/landmark/start/marine/engineer/bravo
	icon_state = "engi_spawn_bravo"
	squad = SQUAD_MARINE_2

/obj/effect/landmark/start/marine/engineer/charlie
	icon_state = "engi_spawn_charlie"
	squad = SQUAD_MARINE_3

/obj/effect/landmark/start/marine/engineer/delta
	icon_state = "engi_spawn_delta"
	squad = SQUAD_MARINE_4
