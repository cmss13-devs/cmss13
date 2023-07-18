//Chief Staff Officer
/datum/job/command/operations
	title = JOB_CSO
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADMIN_NOTIFY
	gear_preset = /datum/equipment_preset/uscm_ship/xo

/datum/job/command/operations/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "<a href='[URL_WIKI_XO_GUIDE]'>You are third in command aboard the [MAIN_SHIP_NAME],</a> and are in next in the chain of command after the Commanding Officer and Executive Officer. Where applicable, you must abide by the <a href='[URL_WIKI_CO_RULES]'>Commanding Officer Code of Conduct</a>. You are the chief combat advisor to the CO, and assist them in planning and operations."
	return ..()

/datum/job/command/operations/generate_entry_conditions(mob/living/M, whitelist_status)
	. = ..()
	GLOB.marine_leaders[JOB_CSO] = M
	RegisterSignal(M, COMSIG_PARENT_QDELETING, PROC_REF(cleanup_leader_candidate))

/datum/job/command/operations/proc/cleanup_leader_candidate(mob/M)
	SIGNAL_HANDLER
	GLOB.marine_leaders -= JOB_CSO

AddTimelock(/datum/job/command/operations, list(
	JOB_COMMAND_ROLES = 5 HOURS,
))

/obj/effect/landmark/start/operations
	name = JOB_CSO
	icon_state = "xo_spawn"
	job = /datum/job/command/operations
