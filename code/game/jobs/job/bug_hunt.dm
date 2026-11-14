/datum/job/command/commander/bug_hunt
	title = JOB_PLATOON_COMMANDER
	role_ban_alternative = JOB_CO
	total_positions = 1
	spawn_positions = 1
	gear_preset = /datum/equipment_preset/uscm_co/bug_hunt

/datum/job/command/commander/bug_hunt/New()
	. = ..()
	flags_startup_parameters |= ROLE_ADD_TO_SQUAD
	gear_preset_whitelist = list()

/datum/job/command/commander/bug_hunt/get_whitelist_status(client/player)
	return WHITELIST_NORMAL

/datum/job/command/executive/bug_hunt
	title = JOB_OPERATIONS_OFFICER
	role_ban_alternative = JOB_XO
	total_positions = 1
	spawn_positions = 1
	gear_preset = /datum/equipment_preset/uscm_ship/xo/bug_hunt
	supervisors = "the platoon commander"

/datum/job/command/executive/bug_hunt/New()
	. = ..()
	flags_startup_parameters |= ROLE_ADD_TO_SQUAD

/datum/job/marine/leader/bug_hunt
	title = JOB_PLATOON_SERGEANT
	role_ban_alternative = JOB_SQUAD_LEADER
	total_positions = 1
	spawn_positions = 1
	gear_preset = /datum/equipment_preset/uscm/leader/bug_hunt
	supervisors = "the platoon commander and operations officer"

/datum/job/marine/tl/bug_hunt
	title = JOB_RECON_SECTION_LEADER
	role_ban_alternative = JOB_SQUAD_TEAM_LEADER
	total_positions = 2
	spawn_positions = 2
	gear_preset = /datum/equipment_preset/uscm/tl/bug_hunt
	supervisors = "the platoon sergeant"
	entry_message_body = "Lead your section in locating and destroying the xenomorph hive cores. Keep your marines together, and be prepared to assume command if the Platoon Sergeant is incapacitated."

/datum/job/marine/medic/bug_hunt
	title = JOB_RECON_CORPSMAN
	role_ban_alternative = JOB_SQUAD_MEDIC
	total_positions = 3
	spawn_positions = 3
	gear_preset = /datum/equipment_preset/uscm/medic/bug_hunt
	supervisors = "the platoon sergeant and your section leader"

/datum/job/marine/medic/bug_hunt/set_spawn_positions(count)
	return

/datum/job/marine/medic/bug_hunt/get_total_positions(latejoin)
	return latejoin ? total_positions : spawn_positions

/datum/job/marine/engineer/bug_hunt
	title = JOB_RECON_ENGINEER
	role_ban_alternative = JOB_SQUAD_ENGI
	total_positions = 3
	spawn_positions = 3
	gear_preset = /datum/equipment_preset/uscm/engineer/bug_hunt
	supervisors = "the platoon sergeant and your section leader"

/datum/job/marine/engineer/bug_hunt/set_spawn_positions(count)
	return

/datum/job/marine/engineer/bug_hunt/get_total_positions(latejoin)
	return latejoin ? total_positions : spawn_positions

/datum/job/command/tank_crew/bug_hunt
	title = JOB_RECON_CREWMAN
	role_ban_alternative = JOB_TANK_CREW
	allow_additional = FALSE
	scaled = FALSE
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/uscm/tank/bug_hunt/equipped
	supervisors = "the platoon commander and operations officer"

/datum/job/command/tank_crew/bug_hunt/get_total_positions(latejoin)
	return latejoin ? total_positions : spawn_positions

/datum/job/marine/smartgunner/bug_hunt
	title = JOB_RECON_SMARTGUNNER
	role_ban_alternative = JOB_SQUAD_SMARTGUN
	total_positions = 2
	spawn_positions = 2
	scaled = FALSE
	gear_preset = /datum/equipment_preset/uscm/sg/bug_hunt
	supervisors = "the platoon sergeant and your section leader"

/datum/job/marine/smartgunner/bug_hunt/set_spawn_positions(count)
	return

/datum/job/marine/smartgunner/bug_hunt/get_total_positions(latejoin)
	return latejoin ? total_positions : spawn_positions

/datum/job/marine/standard/bug_hunt
	title = JOB_RECON_RIFLEMAN
	role_ban_alternative = JOB_SQUAD_MARINE
	total_positions = -1
	spawn_positions = -1
	gear_preset = /datum/equipment_preset/uscm/pfc/bug_hunt
	supervisors = "the platoon sergeant and your section leader"

/datum/job/marine/standard/bug_hunt/set_spawn_positions(count)
	return

/datum/job/civilian/synthetic/bug_hunt
	title = JOB_RECON_SYNTHETIC
	role_ban_alternative = JOB_SYNTH
	total_positions = 1
	spawn_positions = 1
	scaled = FALSE
	gear_preset = /datum/equipment_preset/synth/uscm/bug_hunt/equipped
	supervisors = "the platoon commander and operations officer"

/datum/job/civilian/synthetic/bug_hunt/New()
	. = ..()
	flags_startup_parameters |= ROLE_ADD_TO_SQUAD
	gear_preset_whitelist = list()

/datum/job/civilian/synthetic/bug_hunt/get_whitelist_status(client/player)
	return WHITELIST_NORMAL

/datum/job/civilian/synthetic/bug_hunt/set_spawn_positions(count)
	return

/datum/job/civilian/synthetic/bug_hunt/get_total_positions(latejoin)
	return latejoin ? total_positions : spawn_positions
