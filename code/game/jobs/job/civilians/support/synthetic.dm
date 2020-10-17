/datum/job/civilian/synthetic
	title = JOB_SYNTH
	total_positions = 2
	spawn_positions = 1
	allow_additional = 1
	scaled = 1
	supervisors = "the acting commanding officer"
	selection_class = "job_synth"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED|ROLE_CUSTOM_SPAWN
	flags_whitelist = WHITELIST_SYNTHETIC
	gear_preset = "USCM Synthetic"

/datum/job/civilian/synthetic/New()
	. = ..()
	gear_preset_whitelist = list(
		"[JOB_SYNTH][WHITELIST_NORMAL]" = "USCM Synthetic",
		"[JOB_SYNTH][WHITELIST_COUNCIL]" = "USCM Synthetic Councillor",
		"[JOB_SYNTH][WHITELIST_LEADER]" = "USCM Synthetic Councillor"
	)

/datum/job/civilian/synthetic/get_whitelist_status(var/list/roles_whitelist, var/client/player)
	. = ..()
	if(!.)
		return

	if(roles_whitelist[player.ckey] & WHITELIST_SYNTHETIC_LEADER)
		return get_desired_status(player.prefs.synth_status, WHITELIST_LEADER)
	else if(roles_whitelist[player.ckey] & WHITELIST_SYNTHETIC_COUNCIL)
		return get_desired_status(player.prefs.synth_status, WHITELIST_COUNCIL)
	else if(roles_whitelist[player.ckey] & WHITELIST_SYNTHETIC)
		return get_desired_status(player.prefs.synth_status, WHITELIST_NORMAL)

/datum/job/civilian/synthetic/set_spawn_positions(var/count)
	spawn_positions = synth_slot_formula(count)

/datum/job/civilian/synthetic/get_total_positions(var/latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = synth_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	return positions


/datum/job/civilian/synthetic/generate_entry_message()
	entry_message_body = "You are a Synthetic! You are held to a higher standard and are required to obey not only the Server Rules but Marine Law and Synthetic Rules. Failure to do so may result in your White-list Removal. Your primary job is to support and assist all USCM Departments and Personnel on-board. In addition, being a Synthetic gives you knowledge in every field and specialization possible on-board the ship. As a Synthetic you answer to the acting commanding officer. Special circumstances may change this!"
	return ..()
