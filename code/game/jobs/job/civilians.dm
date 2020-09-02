/datum/job/civilian
	department_flag = ROLEGROUP_MARINE_MED_SCIENCE
	gear_preset = "Colonist"

/datum/job/civilian/colonist
	title = JOB_COLONIST

/datum/job/civilian/survivor
	title = JOB_SURVIVOR
	minimum_playtimes = list(
		JOB_SQUAD_ROLES = HOURS_3
	)

/datum/job/civilian/passenger
	title = JOB_PASSENGER

/datum/job/civilian/professor
	title = JOB_CMO
	flag = ROLE_CHIEF_MEDICAL_OFFICER
	total_positions = 1
	spawn_positions = 1
	supervisors = "the acting commanding officer"
	selection_class = "job_cmo"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Chief Medical Officer (CMO)"
	minimum_playtimes = list(
		JOB_DOCTOR = HOURS_6
	)

/datum/job/civilian/professor/generate_entry_message()
	entry_message_body = "You are a civilian, and are not subject to follow military chain of command, but you do work for the USCM. You have final authority over the medical department, medications, and treatments. Make sure that the doctors and nurses are doing their jobs and keeping the marines healthy and strong."
	return ..()

/datum/job/civilian/nurse
	title = JOB_NURSE
	flag = ROLE_CIVILIAN_NURSE
	total_positions = 1
	spawn_positions = 1
	supervisors = "the chief medical officer"
	selection_class = "job_doctor"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Nurse"
	minimum_playtimes = list(
		JOB_SQUAD_ROLES = HOURS_3
	)

/datum/job/civilian/nurse/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "You are a civilian, and are not subject to follow military chain of command, but you do work for the USCM. You are tasked with keeping the marines healthy and strong. You are also an expert when it comes to medication and treatment, but you do not know anything about surgery. Focus on assisting doctors and triaging wounded marines."
	return ..()

//Doctor
/datum/job/civilian/doctor
	title = JOB_DOCTOR
	flag = ROLE_CIVILIAN_DOCTOR
	total_positions = 6
	spawn_positions = 6
	allow_additional = 1	
	scaled = 1
	supervisors = "the chief medical officer"
	selection_class = "job_doctor"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Doctor"
	minimum_playtimes = list(
		JOB_SQUAD_ROLES = HOURS_3
	)

/datum/job/civilian/doctor/set_spawn_positions(var/count)
	spawn_positions = doc_slot_formula(count)

/datum/job/civilian/doctor/get_total_positions(var/latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = doc_slot_formula(get_total_marines())
		if(total_positions_in_round < positions)
			total_positions_in_round = positions
		else
			positions = total_positions_in_round
	return positions

/datum/job/civilian/doctor/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "You are a civilian, and are not subject to follow military chain of command, but you do work for the USCM. You are tasked with keeping the marines healthy and strong, usually in the form of surgery. You are also an expert when it comes to medication and treatment. If you do not know what you are doing, mentorhelp so a mentor can assist you."
	return ..()

//Researcher
/datum/job/civilian/researcher
	title = JOB_RESEARCHER
	flag = ROLE_CIVILIAN_RESEARCHER
	total_positions = 2
	spawn_positions = 2
	allow_additional = 1
	scaled = 1
	supervisors = "chief medical officer"
	selection_class = "job_researcher"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Researcher"
	minimum_playtimes = list(
		JOB_DOCTOR = HOURS_3
	)

/datum/job/civilian/researcher/set_spawn_positions(var/count)
	spawn_positions = rsc_slot_formula(count)

/datum/job/civilian/researcher/get_total_positions(var/latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = rsc_slot_formula(get_total_marines())
		if(total_positions_in_round < positions)
			total_positions_in_round = positions
		else
			positions = total_positions_in_round
	return positions

/datum/job/civilian/researcher/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "You are a civilian, and are not subject to follow military chain of command, but you do work for the USCM. You are tasked with researching and developing new medical treatments, helping your fellow doctors, and generally learning new things. Your role involves a lot of roleplaying, but you can perform the function of a regular doctor. Do not hand out things to marines without getting permission from your supervisor."
	return ..()

//Liaison
/datum/job/civilian/liaison
	title = JOB_CORPORATE_LIAISON
	flag = ROLE_CORPORATE_LIAISON
	department_flag = ROLEGROUP_MARINE_COMMAND
	total_positions = 1
	spawn_positions = 1
	supervisors = "the W-Y corporate office"
	selection_class = "job_cl"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Corporate Liaison (CL)"
	minimum_playtimes = list(
		JOB_SQUAD_ROLES = HOURS_3
	)

/datum/job/civilian/liaison/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "As a representative of Weston-Yamada Corporation, your job requires you to stay in character at all times. You are not required to follow military orders; however, you cannot give military orders. Your primary job is to observe and report back your findings to Weston-Yamada. Follow regular game rules unless told otherwise by your superiors. Use your office fax machine to communicate with corporate headquarters or to acquire new directives. You may not receive anything back, and this is normal."
	return ..()

/datum/job/civilian/liaison/generate_entry_conditions(mob/living/carbon/human/H)
	if(ticker && H.mind) ticker.liaison = H.mind //TODO Look into CL tracking in game mode.

/datum/job/civilian/liaison/nightmare
	flags_startup_parameters = NO_FLAGS
	gear_preset = "Nightmare USCM Corporate Liaison"

/datum/job/civilian/liaison/nightmare/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "It was just a regular day in the office when the higher up decided to send you in to this hot mess. If only you called in sick that day... The W-Y mercs were hired to protect some important science experiment, and W-Y expects you to keep them in line. These are hardened killers, and you write on paper for a living. It won't be easy, that's for damn sure. Best to let the mercs do the killing and the dying, but remind them who pays the bills."
	return ..()

/datum/job/civilian/synthetic
	title = JOB_SYNTH
	flag = ROLE_SYNTHETIC
	department_flag = ROLEGROUP_MARINE_COMMAND
	total_positions = 2
	spawn_positions = 1
	allow_additional = 1
	scaled = 1
	supervisors = "the acting commanding officer"
	selection_class = "job_synth"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED
	flags_whitelist = WHITELIST_SYNTHETIC
	gear_preset = "USCM Synthetic"
	minimum_playtimes = list()

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
		if(total_positions_in_round < positions)
			total_positions_in_round = positions
		else
			positions = total_positions_in_round
	return positions

/datum/job/civilian/synthetic/generate_entry_message()
	entry_message_body = "You are a Synthetic! You are held to a higher standard and are required to obey not only the Server Rules but Marine Law and Synthetic Rules. Failure to do so may result in your White-list Removal. Your primary job is to support and assist all USCM Departments and Personnel on-board. In addition, being a Synthetic gives you knowledge in every field and specialization possible on-board the ship. As a Synthetic you answer to the acting commanding officer. Special circumstances may change this!"
	return ..()
