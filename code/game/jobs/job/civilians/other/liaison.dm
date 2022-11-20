/datum/job/civilian/liaison
	title = JOB_CORPORATE_LIAISON
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Wey-Yu corporate office"
	selection_class = "job_cl"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/liaison
	entry_message_body = "As a <a href='"+URL_WIKI_CL_GUIDE+"'>representative of Weyland-Yutani Corporation</a>, your job requires you to stay in character at all times. You are not required to follow military orders; however, you cannot give military orders. Your primary job is to observe and report back your findings to Weyland-Yutani. Follow regular game rules unless told otherwise by your superiors. Use your office fax machine to communicate with corporate headquarters or to acquire new directives. You may not receive anything back, and this is normal."
	var/mob/living/carbon/human/active_liaison

/datum/job/civilian/liaison/generate_entry_conditions(mob/living/liaison, whitelist_status)
	. = ..()
	active_liaison = liaison
	RegisterSignal(liaison, COMSIG_PARENT_QDELETING, .proc/cleanup_active_liaison)

/datum/job/civilian/liaison/proc/cleanup_active_liaison(var/mob/liaison)
	SIGNAL_HANDLER
	active_liaison = null

/obj/effect/landmark/start/liaison
	name = JOB_CORPORATE_LIAISON
	job = /datum/job/civilian/liaison
