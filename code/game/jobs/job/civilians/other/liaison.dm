/datum/job/civilian/liaison
	title = JOB_CORPORATE_LIAISON
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Weyland-Yutani public relations office"
	selection_class = "job_cl"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/liaison
	entry_message_body = "As a <a href='"+WIKI_PLACEHOLDER+"'>representative of Weyland-Yutani Corporation</a>, your job requires you to stay in character at all times, and is a roleplay-centric role. As a civilian, you are not expected to obey military orders, and you are unable to give them. Although you are not expected to follow orders, you are still within the reach of SOP and Marine Law. Your primary goal is to observe, record, and interact with marines on behalf of the company. You may report back to the company with a fax machine in your office to receive directives, or inform the company. Although you may fax them, you may not receive anything back, which is normal. You are free to make up your own directives which support the company or ulterior motive, though they must remain within the rules."
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
