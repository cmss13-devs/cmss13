//Chief Medical Officer
/datum/job/civilian
	department_flag = ROLEGROUP_MARINE_MED_SCIENCE
	minimal_player_age = 7

/datum/job/civilian/colonist
	title = "Colonist"
	//comm_title = "CLN"
	//access = list(ACCESS_IFF_MARINE)

/datum/job/civilian/passenger
	title = "Passenger"
	//comm_title = "PAS"
	//access = list(ACCESS_IFF_MARINE)

/datum/job/civilian/professor
	title = "Chief Medical Officer"
	flag = ROLE_CHIEF_MEDICAL_OFFICER
	total_positions = 1
	spawn_positions = 1
	supervisors = "the acting commander"
	selection_color = "#99FF99"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Chief Medical Officer (CMO)"

	generate_entry_message()
		. = {"You are a civilian, and are not subject to follow military chain of command, but you do work for the USCM.
You have final authority over the medical department, medications, and treatments.
Make sure that the doctors and nurses are doing their jobs and keeping the marines healthy and strong."}


//Doctor
/datum/job/civilian/doctor
	title = "Doctor"
	flag = ROLE_CIVILIAN_DOCTOR
	total_positions = 6
	spawn_positions = 6
	allow_additional = 1	
	scaled = 1
	supervisors = "the chief medical officer"
	selection_color = "#BBFFBB"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Doctor"

	set_spawn_positions(var/count)
		spawn_positions = doc_slot_formula(count)

	get_total_positions(var/latejoin = 0)
		return (latejoin ? doc_slot_formula(get_total_marines()) : spawn_positions)


	generate_entry_message(mob/living/carbon/human/H)
		. = {"You are a civilian, and are not subject to follow military chain of command, but you do work for the USCM.
You are tasked with keeping the marines healthy and strong, usually in the form of surgery.
You are also an expert when it comes to medication and treatment. If you do not know what you are doing, adminhelp so a mentor can assist you."}

//Researcher
/datum/job/civilian/researcher
	title = "Researcher"
	flag = ROLE_CIVILIAN_RESEARCHER
	total_positions = 2
	spawn_positions = 2
	allow_additional = 1
	scaled = 1
	supervisors = "chief medical officer"
	selection_color = "#BBFFBB"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Researcer"

	set_spawn_positions(var/count)
		spawn_positions = rsc_slot_formula(count)

	get_total_positions(var/latejoin = 0)
		return (latejoin ? rsc_slot_formula(get_total_marines()) : spawn_positions)

	generate_entry_message(mob/living/carbon/human/H)
		. = {"You are a civilian, and are not subject to follow military chain of command, but you do work for the USCM.
You are tasked with researching and developing new medical treatments, helping your fellow doctors, and generally learning new things.
Your role involves a lot of roleplaying, but you can perform the function of a regular doctor. Do not hand out things to marines without getting permission from your supervisor."}

//Liaison
/datum/job/civilian/liaison
	title = "USCM Corporate Liaison"
	flag = ROLE_CORPORATE_LIAISON
	department_flag = ROLEGROUP_MARINE_COMMAND
	total_positions = 1
	spawn_positions = 1
	supervisors = "the W-Y corporate office"
	selection_color = "#ffeedd"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Corporate Liaison"

	generate_entry_message(mob/living/carbon/human/H)
		. = {"As a representative of Weyland-Yutani Corporation, your job requires you to stay in character at all times.
You are not required to follow military orders; however, you cannot give military orders.
Your primary job is to observe and report back your findings to Weyland-Yutani. Follow regular game rules unless told otherwise by your superiors.
Use your office fax machine to communicate with corporate headquarters or to acquire new directives. You may not receive anything back, and this is normal."}

	generate_entry_conditions(mob/living/carbon/human/H)
		if(ticker && H.mind) ticker.liaison = H.mind //TODO Look into CL tracking in game mode.


/datum/job/civilian/liaison/nightmare
	flags_startup_parameters = NOFLAGS
	gear_preset = "Nightmare USCM Corporate Liaison"

	generate_entry_message(mob/living/carbon/human/H)
		. = {"It was just a regular day in the office when the higher up decided to send you in to this hot mess. If only you called in sick that day...
The W-Y mercs were hired to protect some important science experiment, and W-Y expects you to keep them in line.
These are hardened killers, and you write on paper for a living. It won't be easy, that's for damn sure.
Best to let the mercs do the killing and the dying, but remind them who pays the bills."}


/datum/job/civilian/synthetic
	title = "Synthetic"
	flag = ROLE_SYNTHETIC
	department_flag = ROLEGROUP_MARINE_COMMAND
	total_positions = 1
	spawn_positions = 1
	allow_additional = 1
	supervisors = "the acting commander"
	selection_color = "#aaee55"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED
	flags_whitelist = WHITELIST_SYNTHETIC
	gear_preset = "USCM Synthetic"

	generate_entry_message()
		. = {"You are a Synthetic! You are held to a higher standard and are required to obey not only the Server Rules but Marine Law and Synthetic Rules. Failure to do so may result in your White-list Removal.
Your primary job is to support and assist all USCM Departments and Personnel on-board.
In addition, being a Synthetic gives you knowledge in every field and specialization possible on-board the ship.
As a Synthetic you answer to the acting commander. Special circumstances may change this!"}
