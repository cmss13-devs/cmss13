/datum/job/marine/engineer
	title = JOB_SQUAD_ENGI
	total_positions = 12
	spawn_positions = 12
	allow_additional = 1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/uscm/engineer
	entry_message_body = "You have the <a href='"+WIKI_PLACEHOLDER+"'>equipment and skill</a> to build fortifications, reroute power lines, and bunker down. Your squaddies will look to you when it comes to construction in the field of battle."

/datum/job/marine/engineer/set_spawn_positions(count)
	for(var/datum/squad/target_squad in GLOB.RoleAuthority.squads)
		if(target_squad && target_squad.dynamic_scaling)
			target_squad.roles_cap[title] = engi_slot_formula(count)

/datum/job/marine/engineer/get_total_positions(latejoin=0)
	var/slots = engi_slot_formula(get_total_marines())

	if(slots <= total_positions_so_far)
		slots = total_positions_so_far
	else
		total_positions_so_far = slots

	var/extra_slots = 0

	for(var/datum/squad/target_squad in GLOB.RoleAuthority.squads)
		if(!target_squad)
			continue

		if(target_squad.pop_lock && target_squad.pop_lock < length(GLOB.clients))
			target_squad.roles_cap = target_squad.initial_roles_cap

		if(target_squad.dynamic_scaling)
			if(latejoin)
				target_squad.roles_cap[title] = slots
		else
			extra_slots += target_squad.roles_cap[title]
	return slots * 2 + extra_slots

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
