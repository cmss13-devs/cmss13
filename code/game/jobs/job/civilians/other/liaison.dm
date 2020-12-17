/datum/job/civilian/liaison
	title = JOB_CORPORATE_LIAISON
	total_positions = 1
	spawn_positions = 1
	supervisors = "the W-Y corporate office"
	selection_class = "job_cl"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Corporate Liaison (CL)"

/datum/job/civilian/liaison/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "As a representative of Weston-Yamada Corporation, your job requires you to stay in character at all times. You are not required to follow military orders; however, you cannot give military orders. Your primary job is to observe and report back your findings to Weston-Yamada. Follow regular game rules unless told otherwise by your superiors. Use your office fax machine to communicate with corporate headquarters or to acquire new directives. You may not receive anything back, and this is normal."
	return ..()

/datum/job/civilian/liaison/nightmare
	flags_startup_parameters = NO_FLAGS
	gear_preset = "Nightmare USCM Corporate Liaison"

/datum/job/civilian/liaison/nightmare/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "It was just a regular day in the office when the higher up decided to send you in to this hot mess. If only you called in sick that day... The W-Y mercs were hired to protect some important science experiment, and W-Y expects you to keep them in line. These are hardened killers, and you write on paper for a living. It won't be easy, that's for damn sure. Best to let the mercs do the killing and the dying, but remind them who pays the bills."
	return ..()

/obj/effect/landmark/start/liaison
	name = JOB_CORPORATE_LIAISON
	job = /datum/job/civilian/liaison
