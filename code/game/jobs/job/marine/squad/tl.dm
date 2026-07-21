/datum/job/marine/tl
	title = JOB_SQUAD_TEAM_LEADER
	total_positions = 6
	spawn_positions = 6
	allow_additional = 1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/uscm/tl
	entry_message_body = "You are the <a href='"+WIKI_PLACEHOLDER+"'>Team Leader.</a>Your task is to assist the squad leader in leading the squad as well as utilize ordnance such as orbital bombardments, CAS, and mortar as well as coordinating resupply with Requisitions and CIC. If the squad leader dies, you are expected to lead in their place."

/datum/job/marine/tl/generate_entry_conditions(mob/living/carbon/human/spawning_human)
	. = ..()
	spawning_human.important_radio_channels += JTAC_FREQ

/datum/job/marine/tl/get_total_positions(latejoin=0)
	var/extra_slots = 0

	for(var/datum/squad/target_squad in GLOB.RoleAuthority.squads)
		if(!target_squad)
			continue

		if(target_squad.pop_lock && target_squad.pop_lock < length(GLOB.clients))
			target_squad.roles_cap = target_squad.initial_roles_cap
			extra_slots++

	return extra_slots + spawn_positions

AddTimelock(/datum/job/marine/tl, list(
	JOB_SQUAD_ROLES = 8 HOURS
))

/obj/effect/landmark/start/marine/tl
	name = JOB_SQUAD_TEAM_LEADER
	icon_state = "tl_spawn"
	job = /datum/job/marine/tl
