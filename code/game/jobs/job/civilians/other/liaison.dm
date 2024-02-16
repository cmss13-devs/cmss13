/datum/job/civilian/liaison
	title = JOB_CORPORATE_LIAISON
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Wey-Yu corporate office"
	selection_class = "job_cl"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/liaison
	entry_message_body = "As a <a href='"+WIKI_PLACEHOLDER+"'>representative of Weyland-Yutani Corporation</a>, your job requires you to stay in character at all times and is a roleplay-centric role. As a civilian, you are not expected to follow military orders. However, you may still be arrested for failing to abide by Standard Operating Procedure, or Marine Law. Your primary job is to observe, interact, and report back your findings to Weyland-Yutani. Follow regular game rules unless told otherwise by your superiors or administrative staff. Use your office fax machine to communicate with corporate headquarters, or to acquire new directives. You may not receive anything back, and this is normal. You are free to make up your own directives, as long as they are within the bounds of the rules."
	var/mob/living/carbon/human/active_liaison

/datum/job/civilian/liaison/generate_entry_conditions(mob/living/liaison, whitelist_status)
	. = ..()
	active_liaison = liaison
	RegisterSignal(liaison, COMSIG_PARENT_QDELETING, PROC_REF(cleanup_active_liaison))

/datum/job/civilian/liaison/proc/cleanup_active_liaison(mob/liaison)
	SIGNAL_HANDLER
	active_liaison = null

/obj/effect/landmark/start/liaison
	name = JOB_CORPORATE_LIAISON
	icon_state = "cl_spawn"
	job = /datum/job/civilian/liaison

AddTimelock(/datum/job/civilian/liaison, list(
	JOB_HUMAN_ROLES = 21 HOURS,
))
