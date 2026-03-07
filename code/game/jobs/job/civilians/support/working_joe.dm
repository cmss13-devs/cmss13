#define STANDARD_VARIANT "Working Joe"
#define HAZMAT_VARIANT "Hazmat Joe"

/datum/job/civilian/working_joe
	title = JOB_WORKING_JOE
	total_positions = 6
	spawn_positions = 6
	allow_additional = TRUE
	scaled = TRUE
	supervisors = "ARES and APOLLO"
	selection_class = "job_working_joe"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_WHITELISTED|ROLE_CUSTOM_SPAWN
	flags_whitelist = WHITELIST_JOE
	gear_preset = /datum/equipment_preset/synth/working_joe
	gets_emergency_kit = FALSE

	job_options = list(STANDARD_VARIANT = "JOE", HAZMAT_VARIANT = "HAZ")
	var/standard = TRUE

/datum/job/civilian/working_joe/check_whitelist_status(mob/user)
	if(user.client.check_whitelist_status(WHITELIST_SYNTHETIC))
		return TRUE

	return ..()

/datum/job/civilian/working_joe/handle_job_options(option)
	if(option != HAZMAT_VARIANT)
		standard = TRUE
		gear_preset = /datum/equipment_preset/synth/working_joe
	else
		standard = FALSE
		gear_preset = /datum/equipment_preset/synth/working_joe/engi

/datum/job/civilian/working_joe/set_spawn_positions(count)
	spawn_positions = working_joe_slot_formula(count)

/datum/job/civilian/working_joe/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = working_joe_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

/datum/job/civilian/working_joe/generate_entry_message(mob/living/carbon/human/H)
	if(standard)
		. = {"You are a <a href='[generate_wiki_link()]'>Working Joe.</a> You are held to a higher standard and are required to obey not only the Server Rules but Marine Law, Roleplay Expectations and Synthetic Rules. Your primary task is to maintain the cleanliness of the ship, putting things in their proper place. Alternatively, your primary task may be to assist with manual labor in limited capacity, or clerical duties. Your capacities are limited, but you have all the equipment you need, and the central AI has a plan! Stay in character at all times. Use the APOLLO link to communicate with your uplink!"}
	else
		. = {"You are a <a href='[generate_wiki_link()]'>Working Joe</a> for Hazardous Environments! You are held to a higher standard and are required to obey not only the Server Rules but Marine Law, Roleplay Expectations and Synthetic Rules. You are a variant of the Working Joe built for tougher environments and fulfill the specific duty of dangerous repairs or maintenance. Your primary task is to maintain the reactor, SMES and AI Core. Your secondary task is to respond to hazardous environments, such as an atmospheric breach or biohazard spill, and assist with repairs when ordered to by either an AI Mainframe, or a Commissioned Officer. You should not be seen outside of emergencies besides in Engineering and the AI Core! Stay in character at all times. Use the APOLLO link to communicate with your uplink!"}

/datum/job/civilian/working_joe/announce_entry_message(mob/living/carbon/human/H)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(ares_apollo_talk), "[H.real_name] has been activated."), 1.5 SECONDS)
	return ..()

/obj/effect/landmark/start/working_joe
	name = JOB_WORKING_JOE
	icon_state = "wj_spawn"
	job = /datum/job/civilian/working_joe

/datum/job/civilian/working_joe/generate_entry_conditions(mob/living/M, whitelist_status)
	. = ..()

	if(SSticker.mode)
		SSticker.mode.initialize_joe(M)

/datum/job/civilian/working_joe/colony
	title = JOB_COLONY_JOE
	total_positions = 3
	spawn_positions = 0
	scaled = FALSE
	gear_preset = /datum/equipment_preset/synth/working_joe/colony

/datum/job/civilian/working_joe/colony/handle_job_options(option)
	if(option != HAZMAT_VARIANT)
		standard = TRUE
		gear_preset = /datum/equipment_preset/synth/working_joe/colony
	else
		standard = FALSE
		gear_preset = /datum/equipment_preset/synth/working_joe/engi/colony

/datum/job/civilian/working_joe/colony/generate_entry_message(mob/living/carbon/human/H)
	. = {"You are a <a href='[generate_wiki_link()]'>Colony Working Joe.</a> You are held to a higher standard and are required to obey not only the Server Rules but Roleplay Expectations and Synthetic Rules. Your primary task is to maintain the cleanliness of the colony, putting things in their proper place. Alternatively, your primary task may be to assist with manual labor in limited capacity, or clerical duties. Your capacities are limited, but you have all the equipment you need, and the central AI has a plan! Stay in character at all times. Use the ARTEMIS link to communicate with your uplink!"}

/datum/job/civilian/working_joe/colony/generate_entry_conditions(mob/living/joe, whitelist_status)
	. = ..()

	if(SSticker.mode)
		SSticker.mode.initialize_colony_joe(joe)

/datum/job/civilian/working_joe/colony/announce_entry_message(mob/living/carbon/human/H, datum/money_account/M, whitelist_status)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(ares_artemis_talk), "[H.real_name] has been activated."), 1.5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(send_entry_message), H, M, whitelist_status), 1.4 SECONDS)
	return

/datum/job/civilian/working_joe/colony/proc/send_entry_message(mob/living/carbon/human/H, datum/money_account/M, whitelist_status)
	if(H && H.loc && H.client)
		var/title_given
		title_given = lowertext(disp_title)

		var/entrydisplay = boxed_message("\
			[SPAN_ROLE_BODY("|______________________|")] \n\
			[SPAN_ROLE_HEADER("You are \a [title_given]")] \n\
			[SPAN_ROLE_BODY("[generate_entry_message(H)]<br>[M ? "Your account number is: <b>[M.account_number]</b>. Your account pin is: <b>[M.remote_access_pin]</b>." : "You do not have a bank account."]")] \n\
			[SPAN_ROLE_BODY("|______________________|")] \
		")
		to_chat_spaced(H, html = entrydisplay)

/obj/effect/landmark/start/working_joe/colony
	name = JOB_COLONY_JOE
	icon_state = "wj_spawn"
	job = /datum/job/civilian/working_joe/colony

/datum/job/antag/upp/dzho_automaton
	title = JOB_UPP_JOE
	total_positions = 3 //Number is actually based on information from Colonial Marines_Operations Manual, 1IVAN/3 starts to lag if it is connected to more than 3.
	spawn_positions = 3
	allow_additional = TRUE
	scaled = FALSE
	supervisors = "1VAN/3 and UPP command staff"
	gear_preset = /datum/equipment_preset/synth/working_joe/upp
	flags_startup_parameters = ROLE_WHITELISTED

	flags_whitelist =  WHITELIST_JOE

/datum/job/antag/upp/dzho_automaton/check_whitelist_status(mob/user)
	if(user.client.check_whitelist_status(WHITELIST_SYNTHETIC))
		return TRUE

	return ..()

/datum/job/antag/upp/dzho_automaton/generate_entry_message(mob/living/carbon/human/H)
	. = {"You are a <a>Dzho Automaton.</a> You are held to a higher standard and are required to obey not only the Server Rules but UPP Law, Roleplay Expectations and Synthetic Rules. Your primary task is to maintain the ship, patrol and other tasks given to you by UPP officer staff. Alternatively, your primary task may be to assist with manual labor in limited capacity, or clerical duties. You can perform brig duties and security duties if needed. You have a firearm permit and can use lethal force where applicable. Your capacities are limited, but you have all the equipment you need, and the central AI has a plan! Stay in character at all times.!"}

/datum/job/antag/upp/dzho_automaton/colony
	title = JOB_UPP_COLONY_JOE
	total_positions = 3
	spawn_positions = 0
	supervisors = "1VAN/3 and UPP command staff"
	gear_preset = /datum/equipment_preset/synth/working_joe/upp/colony

/datum/job/antag/upp/dzho_automaton/colony/generate_entry_message(mob/living/carbon/human/H)
	. = {"You are a <a>Colony Dzho Automaton.</a> You are held to a higher standard and are required to obey not only the Server Rules but Roleplay Expectations and Synthetic Rules. Your primary task is to maintain the colony, patrol and other tasks given to you by UPP colony administration. Alternatively, your primary task may be to assist with manual labor in limited capacity, or clerical duties. As you are a civillian model, all firearm capabilities have been removed. Your capacities are limited, but you have all the equipment you need, and the central AI has a plan! Stay in character at all times.!"}

/obj/effect/landmark/start/dzho_automaton/colony
	name = JOB_UPP_COLONY_JOE
	icon_state = "wj_spawn"
	job = /datum/job/antag/upp/dzho_automaton/colony
