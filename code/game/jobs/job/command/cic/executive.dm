//Executive Officer
/datum/job/command/executive
	title = JOB_XO
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADMIN_NOTIFY
	gear_preset = /datum/equipment_preset/uscm_ship/xo
	entry_message_body = "<a href='"+URL_WIKI_XO_GUIDE+"'>You are second in command aboard the ship,</a> and are in next in the chain of command after the commanding officer. You may need to fill in for other duties if areas are understaffed, and you are given access to do so. Make the USCM proud!"

/datum/job/command/executive/generate_entry_message(mob/living/carbon/human/H)
	return ..()

/datum/job/command/executive/generate_entry_conditions(mob/living/M, whitelist_status)
	. = ..()
	GLOB.marine_leaders[JOB_XO] = M
	RegisterSignal(M, COMSIG_PARENT_QDELETING, PROC_REF(cleanup_leader_candidate))

/datum/job/command/executive/proc/cleanup_leader_candidate(mob/M)
	SIGNAL_HANDLER
	GLOB.marine_leaders -= JOB_XO

AddTimelock(/datum/job/command/executive, list(
	JOB_COMMAND_ROLES = 5 HOURS,
))

/obj/effect/landmark/start/executive
	name = JOB_XO
	icon_state = "xo_spawn"
	job = /datum/job/command/executive
