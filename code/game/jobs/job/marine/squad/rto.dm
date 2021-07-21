/datum/job/marine/rto
	title = JOB_SQUAD_RTO
	total_positions = 8
	spawn_positions = 8
	allow_additional = 1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_ADD_TO_SQUAD
	gear_preset = "USCM (Cryo) Squad RT Operator"

/datum/job/marine/rto/generate_entry_conditions(mob/living/carbon/human/H)
	. = ..()
	H.important_radio_channels += JTAC_FREQ

AddTimelock(/datum/job/marine/rto, list(
	JOB_SQUAD_ROLES = 8 HOURS
))

/obj/effect/landmark/start/marine/rto
	name = JOB_SQUAD_RTO
	icon_state = "rto_spawn"
	job = /datum/job/marine/rto
