/datum/job/marine/leader
	title = JOB_SQUAD_LEADER
	total_positions = 4
	spawn_positions = 4
	supervisors = "the acting commanding officer"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/uscm/leader
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>You are responsible for the men and women of your squad.</a> Make sure they are on task, working together, and communicating. You are also in charge of communicating with command and letting them know about the situation first hand. Keep out of harm's way."

/datum/job/marine/leader/get_total_positions(latejoin=0)
	var/extra_slots = 0

	for(var/datum/squad/target_squad in GLOB.RoleAuthority.squads)
		if(!target_squad)
			continue

		if(target_squad.pop_lock && target_squad.pop_lock < length(GLOB.clients))
			target_squad.roles_cap = target_squad.initial_roles_cap
			extra_slots++
	return extra_slots + spawn_positions

/datum/job/marine/leader/whiskey
	title = JOB_WO_SQUAD_LEADER
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/wo/marine/sl

AddTimelock(/datum/job/marine/leader, list(
	JOB_SQUAD_ROLES = 10 HOURS
))

/obj/effect/landmark/start/marine/leader
	name = JOB_SQUAD_LEADER
	icon_state = "leader_spawn"
	job = /datum/job/marine/leader
