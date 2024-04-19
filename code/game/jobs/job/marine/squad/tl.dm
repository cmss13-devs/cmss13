/datum/job/marine/tl
	title = JOB_SQUAD_TEAM_LEADER
	total_positions = 4
	spawn_positions = 4
	allow_additional = 1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/uscm/tl
	entry_message_body = "You are the <a href='"+WIKI_PLACEHOLDER+"'>Team Leader.</a>Your task is to assist the squad leader in leading the squad as well as utilize ordnance such as orbital bombardments, CAS, and mortar as well as coordinating resupply with Requisitions and CIC. If the squad leader dies, you are expected to lead in their place."

/datum/job/marine/tl/generate_entry_conditions(mob/living/carbon/human/spawning_human)
	. = ..()
	spawning_human.important_radio_channels += JTAC_FREQ

/datum/job/marine/tl/get_total_positions(latejoin = FALSE)
	var/real_max_positions = 0
	for(var/datum/squad/squad in GLOB.RoleAuthority.squads)
		if(squad.roundstart && squad.usable && squad.faction == FACTION_MARINE && squad.name != "Root")
			real_max_positions += squad.max_tl

	if(real_max_positions > total_positions_so_far)
		total_positions_so_far = real_max_positions

	spawn_positions = real_max_positions

	return real_max_positions

AddTimelock(/datum/job/marine/tl, list(
	JOB_SQUAD_ROLES = 3 HOURS
))

/obj/effect/landmark/start/marine/tl
	name = JOB_SQUAD_TEAM_LEADER
	icon_state = "tl_spawn"
	job = /datum/job/marine/tl

/obj/effect/landmark/start/marine/tl/alpha
	icon_state = "tl_spawn_alpha"
	squad = SQUAD_MARINE_1

/obj/effect/landmark/start/marine/tl/bravo
	icon_state = "tl_spawn_bravo"
	squad = SQUAD_MARINE_2

/obj/effect/landmark/start/marine/tl/charlie
	icon_state = "tl_spawn_charlie"
	squad = SQUAD_MARINE_3

/obj/effect/landmark/start/marine/tl/delta
	icon_state = "tl_spawn_delta"
	squad = SQUAD_MARINE_4
