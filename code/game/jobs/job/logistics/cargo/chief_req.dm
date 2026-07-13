/datum/job/logistics/requisition
	title = JOB_CHIEF_REQUISITION
	selection_class = "job_qm"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/qm
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>Your job</a> is to dispense supplies to the marines, including weapon attachments. Your cargo techs can help you out, but you have final say in your department. Make sure they're not goofing off. While you may request paperwork for supplies, do not go out of your way to screw with marines, unless you want to get deposed. A happy ship is a well-functioning ship."
	var/mob/living/carbon/human/active_chief_requisition

/datum/job/logistics/requisition/generate_entry_conditions(mob/living/chief_requisition, whitelist_status)
	. = ..()
	active_chief_requisition = chief_requisition
	RegisterSignal(chief_requisition, COMSIG_PARENT_QDELETING, PROC_REF(cleanup_active_chief_requisition))

/datum/job/logistics/requisition/proc/cleanup_active_chief_requisition(mob/chief_requisition)
	SIGNAL_HANDLER
	active_chief_requisition = null

/datum/job/logistics/requisition/get_active_player_on_job()
	return active_chief_requisition

AddTimelock(/datum/job/logistics/requisition, list(
	JOB_REQUISITION_ROLES = 10 HOURS,
))

/obj/effect/landmark/start/requisition
	name = JOB_CHIEF_REQUISITION
	icon_state = "ro_spawn"
	job = /datum/job/logistics/requisition
