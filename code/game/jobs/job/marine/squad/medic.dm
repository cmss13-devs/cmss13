/datum/job/marine/medic
	title = JOB_SQUAD_MEDIC
	total_positions = 16
	spawn_positions = 16
	allow_additional = 1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/uscm/medic
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>You tend the wounds of your squad mates</a> and make sure they are healthy and active. You may not be a fully-fledged doctor, but you stand between life and death when it matters."

/datum/job/marine/medic/set_spawn_positions(count)
	for(var/datum/squad/target_squad in GLOB.RoleAuthority.squads)
		if(target_squad && target_squad.dynamic_scaling)
			target_squad.roles_cap[title] = medic_slot_formula(count)

/datum/job/marine/medic/get_total_positions(latejoin=0)
	var/slots = medic_slot_formula(get_total_marines())

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

/datum/job/marine/medic/whiskey
	title = JOB_WO_SQUAD_MEDIC
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/wo/marine/medic

AddTimelock(/datum/job/marine/medic, list(
	JOB_MEDIC_ROLES = 1 HOURS,
	JOB_SQUAD_ROLES = 1 HOURS
))

/obj/effect/landmark/start/marine/medic
	name = JOB_SQUAD_MEDIC
	icon_state = "medic_spawn"
	job = /datum/job/marine/medic
