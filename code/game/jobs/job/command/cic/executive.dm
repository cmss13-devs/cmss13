//Executive Officer
/datum/job/command/executive
	title = JOB_XO
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_ADMIN_NOTIFY
	gear_preset = "USCM Executive Officer (XO)"
	entry_message_body = "You are second in command aboard the ship, and are in next in the chain of command after the commanding officer. You may need to fill in for other duties if areas are understaffed, and you are given access to do so. Make the USCM proud!"

/datum/job/command/executive/generate_entry_message(mob/living/carbon/human/H)
	return ..()

/datum/job/command/executive/generate_entry_conditions(mob/living/M, whitelist_status)
	. = ..()
	GLOB.roundstart_leaders += M
	RegisterSignal(M, COMSIG_PARENT_QDELETING, .proc/cleanup_leader_candidate)

/datum/job/command/executive/proc/cleanup_leader_candidate(var/mob/M)
	SIGNAL_HANDLER
	GLOB.roundstart_leaders -= M

AddTimelock(/datum/job/command/executive, list(
	JOB_COMMAND_ROLES = 5 HOURS
))

/obj/effect/landmark/start/executive
	name = JOB_XO
	job = /datum/job/command/executive
