
/datum/job/command/walker
	title = JOB_WALKER
	total_positions = 1
	spawn_positions = 1
	allow_additional = 1
	scaled = 0
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm/walker
	entry_message_body = "Your job is to operate and maintain thee ship's combat walkers. While you are an officer, your authority is limited to your own vehicle."

/datum/job/command/walker/set_spawn_positions(count)
	if (length(GLOB.clients) >= 20)
		spawn_positions = 1
	else
		spawn_positions = 0

/datum/job/command/walker/get_total_positions(latejoin = FALSE)
	if(SStechtree.trees[TREE_MARINE].get_node(/datum/tech/arc).unlocked)
		return 0
	if(length(GLOB.clients) >= 20 || total_positions_so_far > 0)
		return 1

	return 0

AddTimelock(/datum/job/command/walker, list(
	JOB_SQUAD_ROLES = 2 HOURS,
	JOB_ENGINEER_ROLES = 2 HOURS
))

/obj/effect/landmark/start/mech_crew
	name = JOB_WALKER
	job = /datum/job/command/walker
