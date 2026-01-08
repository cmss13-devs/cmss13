/datum/job/command/pilot/cas_pilot
	title = JOB_CAS_PILOT
	total_positions = 1
	spawn_positions = 1
	allow_additional = TRUE
	scaled = TRUE
	supervisors = "the auxiliary support officer"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/gp
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>Your job is to fly, protect, and maintain the ship's gunship.</a> While you are an officer, your authority is limited to the dropship, where you have authority over the enlisted personnel."
	var/mob/living/carbon/human/active_cas_pilot

/datum/job/command/pilot/cas_pilot/generate_entry_conditions(mob/living/cas_pilot, whitelist_status)
	. = ..()
	active_cas_pilot = cas_pilot
	RegisterSignal(cas_pilot, COMSIG_PARENT_QDELETING, PROC_REF(cleanup_active_cas_pilot))

/datum/job/command/pilot/cas_pilot/proc/cleanup_active_cas_pilot(mob/cas_pilot)
	SIGNAL_HANDLER
	active_cas_pilot = null

/datum/job/command/pilot/cas_pilot/get_active_player_on_job()
	return active_cas_pilot

/datum/job/command/pilot/whiskey
	total_positions = 2
	spawn_positions = 2

// Dropship Roles is both DP, GP and DCC combined to not force people to backtrack
AddTimelock(/datum/job/command/pilot/cas_pilot, list(
	JOB_DROPSHIP_ROLES = 2 HOURS
))

/obj/effect/landmark/start/pilot/cas_pilot
	name = JOB_CAS_PILOT
	icon_state = "cas_spawn"
	job = /datum/job/command/pilot/cas_pilot
