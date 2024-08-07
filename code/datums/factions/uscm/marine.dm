/datum/faction/uscm/marine
	name = NAME_FACTION_MARINE
	faction_name = FACTION_MARINE

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
		MODE_NAME_WISKEY_OUTPOST = ROLES_WO_USCM,
		MODE_NAME_HUNTER_GAMES = list(),
		MODE_NAME_HIVE_WARS = list(),
		MODE_NAME_INFECTION = ROLES_REGULAR_USCM
	)

/datum/faction/uscm/marine/additional_join_status(mob/new_player/user, dat = "")
	if(SSevacuation)
		switch(SSevacuation.evac_status)
			if(EVACUATION_STATUS_INITIATING)
				dat += "<font color='red'><b>[replacetext(user.client.auto_lang(LANGUAGE_LOBBY_EVAC_STARTED), "###MAIN_SHIP###", "[MAIN_SHIP_NAME]")]</b></font><br>"
			if(EVACUATION_STATUS_COMPLETE)
				dat += "<font color='red'>[replacetext(user.client.auto_lang(LANGUAGE_LOBBY_EVAC_FINISHED), "###MAIN_SHIP###", "[MAIN_SHIP_NAME]")]</font><br>"
	. = ..()
