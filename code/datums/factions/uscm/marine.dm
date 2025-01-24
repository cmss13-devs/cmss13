/datum/faction/uscm/marine
	name = "Colonial Marines"
	code_identificator = FACTION_MARINE

	faction_iff_tag_type = /obj/item/faction_tag/uscm/marine

	role_mappings = list(
		MODE_NAME_EXTENDED = list(),
		MODE_NAME_DISTRESS_SIGNAL = list(),
		MODE_NAME_FACTION_CLASH = list(),
		MODE_NAME_WISKEY_OUTPOST = list(
			/datum/job/command/commander/whiskey = JOB_CO,
			/datum/job/command/executive/whiskey = JOB_XO,
			/datum/job/civilian/synthetic/whiskey = JOB_SYNTH,
			/datum/job/command/warrant/whiskey = JOB_CHIEF_POLICE,
			/datum/job/command/bridge/whiskey = JOB_SO,
			/datum/job/command/tank_crew/whiskey = JOB_TANK_CREW,
			/datum/job/command/police/whiskey = JOB_POLICE,
			/datum/job/command/pilot/whiskey = JOB_CAS_PILOT,
			/datum/job/logistics/requisition/whiskey = JOB_CHIEF_REQUISITION,
			/datum/job/civilian/professor/whiskey = JOB_CMO,
			/datum/job/civilian/doctor/whiskey = JOB_DOCTOR,
			/datum/job/civilian/researcher/whiskey = JOB_RESEARCHER,
			/datum/job/logistics/engineering/whiskey = JOB_CHIEF_ENGINEER,
			/datum/job/logistics/maint/whiskey = JOB_MAINT_TECH,
			/datum/job/logistics/cargo/whiskey = JOB_CARGO_TECH,
			/datum/job/civilian/liaison/whiskey = JOB_CORPORATE_LIAISON,
			/datum/job/marine/leader/whiskey = JOB_SQUAD_LEADER,
			/datum/job/marine/specialist/whiskey = JOB_SQUAD_SPECIALIST,
			/datum/job/marine/smartgunner/whiskey = JOB_SQUAD_SMARTGUN,
			/datum/job/marine/medic/whiskey = JOB_SQUAD_MEDIC,
			/datum/job/marine/engineer/whiskey = JOB_SQUAD_ENGI,
			/datum/job/marine/standard/whiskey = JOB_SQUAD_MARINE,
		),
		MODE_NAME_HUNTER_GAMES = list(),
		MODE_NAME_HIVE_WARS = list(),
		MODE_NAME_INFECTION = list(),
	)
	roles_list = list(
		MODE_NAME_EXTENDED = list(JOB_CO, JOB_XO, JOB_SO, JOB_WO_CO, JOB_WO_XO,JOB_CHIEF_POLICE, JOB_WARDEN, JOB_POLICE, JOB_AUXILIARY_OFFICER, JOB_SEA, JOB_INTEL, JOB_CAS_PILOT, JOB_DROPSHIP_PILOT, JOB_DROPSHIP_CREW_CHIEF, JOB_TANK_CREW, JOB_SYNTH, JOB_WORKING_JOE, JOB_CORPORATE_LIAISON, JOB_COMBAT_REPORTER, JOB_MESS_SERGEANT, JOB_CHIEF_ENGINEER, JOB_ORDNANCE_TECH, JOB_MAINT_TECH, JOB_WO_CHIEF_ENGINEER, JOB_CHIEF_REQUISITION, JOB_CARGO_TECH, JOB_CMO, JOB_RESEARCHER, JOB_DOCTOR, JOB_NURSE, JOB_SQUAD_LEADER, JOB_SQUAD_TEAM_LEADER, JOB_SQUAD_SPECIALIST, JOB_SQUAD_SMARTGUN, JOB_SQUAD_MEDIC, JOB_SQUAD_ENGI, JOB_SQUAD_MARINE),
		MODE_NAME_DISTRESS_SIGNAL = list(JOB_CO, JOB_XO, JOB_SO, JOB_WO_CO, JOB_WO_XO,JOB_CHIEF_POLICE, JOB_WARDEN, JOB_POLICE, JOB_AUXILIARY_OFFICER, JOB_SEA, JOB_INTEL, JOB_CAS_PILOT, JOB_DROPSHIP_PILOT, JOB_DROPSHIP_CREW_CHIEF, JOB_TANK_CREW, JOB_SYNTH, JOB_WORKING_JOE, JOB_CORPORATE_LIAISON, JOB_COMBAT_REPORTER, JOB_MESS_SERGEANT, JOB_CHIEF_ENGINEER, JOB_ORDNANCE_TECH, JOB_MAINT_TECH, JOB_WO_CHIEF_ENGINEER, JOB_CHIEF_REQUISITION, JOB_CARGO_TECH, JOB_CMO, JOB_RESEARCHER, JOB_DOCTOR, JOB_NURSE, JOB_SQUAD_LEADER, JOB_SQUAD_TEAM_LEADER, JOB_SQUAD_SPECIALIST, JOB_SQUAD_SMARTGUN, JOB_SQUAD_MEDIC, JOB_SQUAD_ENGI, JOB_SQUAD_MARINE),
		MODE_NAME_FACTION_CLASH = list(JOB_CO, JOB_XO, JOB_SO, JOB_WO_CO, JOB_WO_XO,JOB_CHIEF_POLICE, JOB_WARDEN, JOB_POLICE, JOB_AUXILIARY_OFFICER, JOB_SEA, JOB_INTEL, JOB_CAS_PILOT, JOB_DROPSHIP_PILOT, JOB_DROPSHIP_CREW_CHIEF, JOB_TANK_CREW, JOB_SYNTH, JOB_WORKING_JOE, JOB_CORPORATE_LIAISON, JOB_COMBAT_REPORTER, JOB_MESS_SERGEANT, JOB_CHIEF_ENGINEER, JOB_ORDNANCE_TECH, JOB_MAINT_TECH, JOB_WO_CHIEF_ENGINEER, JOB_CHIEF_REQUISITION, JOB_CARGO_TECH, JOB_CMO, JOB_RESEARCHER, JOB_DOCTOR, JOB_NURSE, JOB_SQUAD_LEADER, JOB_SQUAD_TEAM_LEADER, JOB_SQUAD_SPECIALIST, JOB_SQUAD_SMARTGUN, JOB_SQUAD_MEDIC, JOB_SQUAD_ENGI, JOB_SQUAD_MARINE),
		MODE_NAME_WISKEY_OUTPOST = list(JOB_WO_CO, JOB_WO_XO, JOB_WO_CORPORATE_LIAISON, JOB_WO_SYNTH, JOB_WO_CHIEF_POLICE, JOB_WO_SO, JOB_WO_CREWMAN, JOB_WO_POLICE, JOB_WO_PILOT, JOB_WO_CHIEF_ENGINEER, JOB_WO_ORDNANCE_TECH, JOB_WO_CHIEF_REQUISITION, JOB_WO_REQUISITION, JOB_WO_CMO, JOB_WO_DOCTOR, JOB_WO_RESEARCHER, JOB_WO_SQUAD_MARINE, JOB_WO_SQUAD_MEDIC, JOB_WO_SQUAD_ENGINEER, JOB_WO_SQUAD_SMARTGUNNER, JOB_WO_SQUAD_SPECIALIST, JOB_WO_SQUAD_LEADER),
		MODE_NAME_HUNTER_GAMES = list(),
		MODE_NAME_HIVE_WARS = list(),
		MODE_NAME_INFECTION = list(JOB_CO, JOB_XO, JOB_SO, JOB_WO_CO, JOB_WO_XO,JOB_CHIEF_POLICE, JOB_WARDEN, JOB_POLICE, JOB_AUXILIARY_OFFICER, JOB_SEA, JOB_INTEL, JOB_CAS_PILOT, JOB_DROPSHIP_PILOT, JOB_DROPSHIP_CREW_CHIEF, JOB_TANK_CREW, JOB_SYNTH, JOB_WORKING_JOE, JOB_CORPORATE_LIAISON, JOB_COMBAT_REPORTER, JOB_MESS_SERGEANT, JOB_CHIEF_ENGINEER, JOB_ORDNANCE_TECH, JOB_MAINT_TECH, JOB_WO_CHIEF_ENGINEER, JOB_CHIEF_REQUISITION, JOB_CARGO_TECH, JOB_CMO, JOB_RESEARCHER, JOB_DOCTOR, JOB_NURSE, JOB_SQUAD_LEADER, JOB_SQUAD_TEAM_LEADER, JOB_SQUAD_SPECIALIST, JOB_SQUAD_SMARTGUN, JOB_SQUAD_MEDIC, JOB_SQUAD_ENGI, JOB_SQUAD_MARINE),
	)
	coefficient_per_role = list(
		JOB_CO = 2,
		JOB_XO = 1.5,
		JOB_SO = 1,
		JOB_INTEL = 0.5,
		JOB_PILOT = 0.25,
		JOB_DROPSHIP_CREW_CHIEF = 0.75,
		JOB_CREWMAN = 2.5,
		JOB_POLICE = 0.25,
		JOB_CORPORATE_LIAISON = 0.25,
		JOB_CHIEF_REQUISITION = 0.5,
		JOB_CHIEF_ENGINEER = 1,
		JOB_CMO = 1,
		JOB_CHIEF_POLICE = 0.75,
		JOB_SEA = 0.25,
		JOB_SYNTH = 4,
		JOB_WARDEN = 0.75,
		JOB_ORDNANCE_TECH = 1.5,
		JOB_MAINT_TECH = 0.75,
		JOB_WORKING_JOE = 1,
		JOB_MESS_SERGEANT = 0.25,
		JOB_CARGO_TECH = 0.5,
		JOB_RESEARCHER = 1,
		JOB_DOCTOR = 1.25,
		JOB_NURSE = 0.75,
		JOB_SQUAD_LEADER = 1.5,
		JOB_SQUAD_RTO = 1,
		JOB_SQUAD_SPECIALIST = 3,
		JOB_SQUAD_SMARTGUN = 2,
		JOB_SQUAD_MEDIC = 1.5,
		JOB_SQUAD_ENGI = 1.25,
		JOB_SQUAD_MARINE = 1,
	)
	weight_act = list(
		MODE_NAME_EXTENDED = TRUE,
		MODE_NAME_DISTRESS_SIGNAL = TRUE,
		MODE_NAME_FACTION_CLASH = TRUE,
		MODE_NAME_WISKEY_OUTPOST = TRUE,
		MODE_NAME_HUNTER_GAMES = FALSE,
		MODE_NAME_HIVE_WARS = FALSE,
		MODE_NAME_INFECTION = TRUE,
	)

/datum/faction/uscm/marine/additional_join_status_info(user)
	. = ""
	if(SShijack)
		switch(SShijack.evac_status)
			if(EVACUATION_STATUS_INITIATED)
				. += "<font color='red'><b>The [MAIN_SHIP_NAME] is being evacuated.</b></font><br>"


/datum/faction/uscm/marine/custom_faction_job_fill(mob/new_player/user)
	. = ""
	var/roles_show = FLAG_SHOW_ALL_JOBS
	for(var/i in GLOB.RoleAuthority.roles_for_mode)
		var/datum/job/J = GLOB.RoleAuthority.roles_for_mode[i]
		if(!GLOB.RoleAuthority.check_role_entry(src, J, src, TRUE))
			continue
		var/active = 0
		// Only players with the job assigned and AFK for less than 10 minutes count as active
		for(var/mob/M in GLOB.player_list)
			if(M.client && M.job == J.title)
				active++
		if(roles_show & FLAG_SHOW_CIC && GLOB.ROLES_CIC.Find(J.title))
			. += "Command:<br>"
			roles_show ^= FLAG_SHOW_CIC

		else if(roles_show & FLAG_SHOW_AUXIL_SUPPORT && GLOB.ROLES_AUXIL_SUPPORT.Find(J.title))
			. += "<hr>Auxiliary Combat Support:<br>"
			roles_show ^= FLAG_SHOW_AUXIL_SUPPORT

		else if(roles_show & FLAG_SHOW_MISC && GLOB.ROLES_MISC.Find(J.title))
			. += "<hr>Other:<br>"
			roles_show ^= FLAG_SHOW_MISC

		else if(roles_show & FLAG_SHOW_POLICE && GLOB.ROLES_POLICE.Find(J.title))
			. += "<hr>Military Police:<br>"
			roles_show ^= FLAG_SHOW_POLICE

		else if(roles_show & FLAG_SHOW_ENGINEERING && GLOB.ROLES_ENGINEERING.Find(J.title))
			. += "<hr>Engineering:<br>"
			roles_show ^= FLAG_SHOW_ENGINEERING

		else if(roles_show & FLAG_SHOW_REQUISITION && GLOB.ROLES_REQUISITION.Find(J.title))
			. += "<hr>Requisitions:<br>"
			roles_show ^= FLAG_SHOW_REQUISITION

		else if(roles_show & FLAG_SHOW_MEDICAL && GLOB.ROLES_MEDICAL.Find(J.title))
			. += "<hr>Medbay:<br>"
			roles_show ^= FLAG_SHOW_MEDICAL

		else if(roles_show & FLAG_SHOW_MARINES && GLOB.ROLES_MARINES.Find(J.title))
			. += "<hr>Marines:<br>"
			roles_show ^= FLAG_SHOW_MARINES

		. += "<a href='byond://?src=\ref[src];lobby_choice=SelectedJob;antag=0;job_selected=[J.title]'>[J.disp_title] ([J.current_positions]) (Active: [active])</a><br>"
