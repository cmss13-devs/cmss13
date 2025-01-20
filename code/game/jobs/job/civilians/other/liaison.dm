/datum/job/civilian/liaison
	title = JOB_CORPORATE_LIAISON
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Wey-Yu corporate office"
	selection_class = "job_cl"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/liaison
	entry_message_body = "As a <a href='"+WIKI_PLACEHOLDER+"'>representative of Weyland-Yutani Corporation</a> from the Corporate Relations Department, your job requires you to stay in character at all times. While in the AO (Area of Operation), you are subject to orders given by military personnel. On ship, you are subject to orders only by the Command and Security departments. You are not required to follow any orders but you can be arrested if you do not. Your primary job is to observe and report back your findings to Weyland-Yutani. Follow regular game rules unless told otherwise by your superiors. Use your office fax machine to communicate with corporate headquarters or to acquire new directives. You may not receive anything back, and this is normal."
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
	JOB_HUMAN_ROLES = 10 HOURS,
))
