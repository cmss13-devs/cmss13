#define FTL_VARIANT "Fireteam Leader" // "I want to focus on leading the charge and managing a fireteam/become aSL"
#define RTO_VARIANT "Radio Telephone Operator" // "I want to focus on communicating with CIC, the Pilots, and others when comms are down."
#define JTAC_VARIANT "JTAC Operator" // "I want to laze and call in fire support from the Gunship Pilot or Mortar team."

/datum/job/marine/tl
	title = JOB_SQUAD_TEAM_LEADER
	total_positions = 8
	spawn_positions = 8
	allow_additional = 1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/uscm/tl
	entry_message_body = "You are the <a href='"+WIKI_PLACEHOLDER+"'>Team Leader.</a>Your task is to assist the squad leader in leading the squad as well as utilize ordnance such as orbital bombardments, CAS, and mortar as well as coordinating resupply with Requisitions and CIC. If the squad leader dies, you are expected to lead in their place."

	// job option
	job_options = list(FTL_VARIANT = "FTL", RTO_VARIANT = "RTO", JTAC_VARIANT = "JTAC")
	/// The team lead variant of the team lead role that was selected in handle_job_options
	var/teamlead_variant

/datum/job/marine/tl/handle_job_options(option)
	teamlead_variant = option
	switch(option)
		if(RTO_VARIANT)
			gear_preset = /datum/equipment_preset/uscm/tl/rto
		if(JTAC_VARIANT)
			gear_preset = /datum/equipment_preset/uscm/tl/jtac
		else
			gear_preset = /datum/equipment_preset/uscm/tl

/datum/job/marine/tl/generate_entry_conditions(mob/living/carbon/human/spawning_human)
	. = ..()
	spawning_human.important_radio_channels += JTAC_FREQ

AddTimelock(/datum/job/marine/tl, list(
	JOB_SQUAD_ROLES = 8 HOURS
))

/obj/effect/landmark/start/marine/tl
	name = JOB_SQUAD_TEAM_LEADER
	icon_state = "tl_spawn"
	job = /datum/job/marine/tl

/obj/effect/landmark/start/marine/tl/alpha
	icon_state = "tl_spawn_alpha"
	squad = SQUAD_MARINE_1

/obj/effect/landmark/start/marine/tl/bravo
	icon_state = "tl_spawn_bravo"
	squad = SQUAD_MARINE_2

/obj/effect/landmark/start/marine/tl/charlie
	icon_state = "tl_spawn_charlie"
	squad = SQUAD_MARINE_3

/obj/effect/landmark/start/marine/tl/delta
	icon_state = "tl_spawn_delta"
	squad = SQUAD_MARINE_4
