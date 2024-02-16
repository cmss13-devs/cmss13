/datum/job/command/bridge
	title = JOB_SO
	total_positions = 4
	spawn_positions = 4
	allow_additional = 1
	scaled = FALSE
	supervisors = "the acting commander"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/so
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>Your job is to monitor the Marines via overwatch, man the CIC, and listen to your Acting Commander.</a> You are in charge of managing one or many squads, or delegated duties handed out by the Acting Commander. You are 6th in line for Acting Commander, behind the Chief Medical Officer."

/datum/job/command/bridge/set_spawn_positions(count)
	spawn_positions = so_slot_formula(count)

/datum/job/command/bridge/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = so_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

/datum/job/command/bridge/generate_entry_message(mob/living/carbon/human/H)
	return ..()

AddTimelock(/datum/job/command/bridge, list(
	JOB_SQUAD_LEADER = 9 HOURS,
	JOB_SQUAD_LEADERSHIP_ROLES = 12 HOURS,
	JOB_HUMAN_ROLES = 24 HOURS
))

/obj/effect/landmark/start/bridge
	name = JOB_SO
	icon_state = "so_spawn"
	job = /datum/job/command/bridge
