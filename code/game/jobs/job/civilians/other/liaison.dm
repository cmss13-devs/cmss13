/datum/job/civilian/liaison
	title = JOB_CORPORATE_LIAISON
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Wey-Yu corporate office"
	selection_class = "job_cl"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/liaison
	entry_message_body = "As a representative of Weyland-Yutani Corporation, your job requires you to stay in character at all times. You are not required to follow military orders; however, you cannot give military orders. Your primary job is to observe and report back your findings to Weyland-Yutani. Follow regular game rules unless told otherwise by your superiors. Use your office fax machine to communicate with corporate headquarters or to acquire new directives. You may not receive anything back, and this is normal."
	var/mob/living/carbon/human/active_liaison

/datum/job/civilian/liaison/generate_entry_conditions(mob/living/liaison, whitelist_status)
	. = ..()
	active_liaison = liaison
	RegisterSignal(liaison, COMSIG_PARENT_QDELETING, .proc/cleanup_active_liaison)

/datum/job/civilian/liaison/proc/cleanup_active_liaison(var/mob/liaison)
	SIGNAL_HANDLER
	active_liaison = null

/datum/job/civilian/liaison/nightmare
	flags_startup_parameters = NO_FLAGS
	gear_preset = /datum/equipment_preset/uscm_ship/liaison/nightmare
	entry_message_body = "It was just a regular day in the office when the higher up decided to send you in to this hot mess. If only you called in sick that day... The Wey-Yu mercs were hired to protect some important science experiment, and Wey-Yu expects you to keep them in line. These are hardened killers, and you write on paper for a living. It won't be easy, that's for damn sure. Best to let the mercs do the killing and the dying, but remind them who pays the bills."

/obj/effect/landmark/start/liaison
	name = JOB_CORPORATE_LIAISON
	job = /datum/job/civilian/liaison
