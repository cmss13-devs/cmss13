/datum/faction/uscm/marine
	name = NAME_FACTION_MARINE
	faction_name = FACTION_MARINE
	faction_iff_tag_type = /obj/item/faction_tag/uscm/marine
	objectives = list("objective" = 40, "close" = 30, "medium" = 25, "far" = 10, "science" = 20) // TODO: Other way???
	objectives_active = TRUE

	role_mappings = list(
		MODE_NAME_EXTENDED = list(),
		MODE_NAME_DISTRESS_SIGNAL = list(),
		MODE_NAME_FACTION_CLASH = list(),
		MODE_NAME_HUMAN_WARS = list(
			/datum/job/civilian/liaison/combat_reporter/cm = JOB_CORPORATE_LIAISON
		),
		MODE_NAME_CRASH = list(
			/datum/job/command/commander/crash = JOB_CO,
			/datum/job/civilian/synthetic/crash = JOB_SYNTH,
			/datum/job/logistics/engineering/crash = JOB_CHIEF_ENGINEER,
			/datum/job/civilian/professor/crash = JOB_CMO,
			/datum/job/uscm/squad/leader/crash = JOB_SQUAD_LEADER,
			/datum/job/uscm/squad/specialist/crash = JOB_SQUAD_SPECIALIST,
			/datum/job/uscm/squad/smartgunner/crash = JOB_SQUAD_SMARTGUN,
			/datum/job/uscm/squad/medic/crash = JOB_SQUAD_MEDIC,
			/datum/job/uscm/squad/engineer/crash = JOB_SQUAD_ENGI,
			/datum/job/uscm/squad/standard/crash = JOB_SQUAD_MARINE
		),
		MODE_NAME_WISKEY_OUTPOST = list(
			/datum/job/command/commander/whiskey = JOB_CO,
			/datum/job/command/executive/whiskey = JOB_XO,
			/datum/job/civilian/synthetic/whiskey = JOB_SYNTH,
			/datum/job/command/warrant/whiskey = JOB_CHIEF_POLICE,
			/datum/job/command/bridge/whiskey = JOB_SO,
			/datum/job/command/tank_crew/whiskey = JOB_CREWMAN,
			/datum/job/command/police/whiskey = JOB_POLICE,
			/datum/job/command/pilot/whiskey = JOB_PILOT,
			/datum/job/logistics/requisition/whiskey = JOB_CHIEF_REQUISITION,
			/datum/job/civilian/professor/whiskey = JOB_CMO,
			/datum/job/civilian/doctor/whiskey = JOB_DOCTOR,
			/datum/job/civilian/researcher/whiskey = JOB_RESEARCHER,
			/datum/job/logistics/engineering/whiskey = JOB_CHIEF_ENGINEER,
			/datum/job/logistics/otech/maint/whiskey = JOB_MAINT_TECH,
			/datum/job/logistics/cargo/whiskey = JOB_CARGO_TECH,
			/datum/job/uscm/squad/leader/whiskey = JOB_SQUAD_LEADER,
			/datum/job/uscm/squad/specialist/whiskey = JOB_SQUAD_SPECIALIST,
			/datum/job/uscm/squad/smartgunner/whiskey = JOB_SQUAD_SMARTGUN,
			/datum/job/uscm/squad/medic/whiskey = JOB_SQUAD_MEDIC,
			/datum/job/uscm/squad/engineer/whiskey = JOB_SQUAD_ENGI,
			/datum/job/uscm/squad/standard/whiskey = JOB_SQUAD_MARINE
		),
		MODE_NAME_HUNTER_GAMES = list(),
		MODE_NAME_HIVE_WARS = list(),
		MODE_NAME_INFECTION = list()
	)
	roles_list = list(
		MODE_NAME_EXTENDED = ROLES_REGULAR_USCM,
		MODE_NAME_DISTRESS_SIGNAL = ROLES_REGULAR_USCM,
		MODE_NAME_FACTION_CLASH = ROLES_REGULAR_USCM,
		MODE_NAME_HUMAN_WARS = ROLES_HVH_USCM,
		MODE_NAME_CRASH = ROLES_CRASH_USCM,
		MODE_NAME_WISKEY_OUTPOST = ROLES_WO_USCM,
		MODE_NAME_HUNTER_GAMES = list(),
		MODE_NAME_HIVE_WARS = list(),
		MODE_NAME_INFECTION = ROLES_REGULAR_USCM
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
		JOB_SQUAD_SPECIALIST = 2,
		JOB_SQUAD_SMARTGUN = 1.75,
		JOB_SQUAD_MEDIC = 1.5,
		JOB_SQUAD_ENGI = 1.25,
		JOB_SQUAD_MARINE = 1
	)
	weight_act = list(
		MODE_NAME_EXTENDED = TRUE,
		MODE_NAME_DISTRESS_SIGNAL = TRUE,
		MODE_NAME_FACTION_CLASH = TRUE,
		MODE_NAME_HUMAN_WARS = TRUE,
		MODE_NAME_CRASH = TRUE,
		MODE_NAME_WISKEY_OUTPOST = TRUE,
		MODE_NAME_HUNTER_GAMES = FALSE,
		MODE_NAME_HIVE_WARS = FALSE,
		MODE_NAME_INFECTION = TRUE
	)

/datum/faction/uscm/marine/additional_join_status(mob/new_player/user, dat = "")
	if(SSevacuation)
		switch(SSevacuation.evac_status)
			if(EVACUATION_STATUS_INITIATING)
				dat += "<font color='red'><b>[replacetext(user.client.auto_lang(LANGUAGE_LOBBY_EVAC_STARTED), "###MAIN_SHIP###", "[MAIN_SHIP_NAME]")]</b></font><br>"
			if(EVACUATION_STATUS_COMPLETE)
				dat += "<font color='red'>[replacetext(user.client.auto_lang(LANGUAGE_LOBBY_EVAC_FINISHED), "###MAIN_SHIP###", "[MAIN_SHIP_NAME]")]</font><br>"
	. = ..()
