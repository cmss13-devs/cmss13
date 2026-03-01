// **United States Aerospace Force Survivors**

/datum/equipment_preset/survivor/usasf //abstract
	name = "USASF Enlisted"
	//job_title = JOB_SURVIVOR

	skills = /datum/skills/military/survivor/usasf
	languages = list(LANGUAGE_ENGLISH)
	idtype = /obj/item/card/id/dogtag/usasf
	faction = FACTION_SURVIVOR
	faction_group = list(FACTION_MARINE, FACTION_SURVIVOR)
	origin_override = ORIGIN_USASF
	paygrades = list(PAY_SHORT_NE3 = JOB_PLAYTIME_TIER_0, PAY_SHORT_NE4 = JOB_PLAYTIME_TIER_1)
	job_title  = JOB_ARMY_TROOPER
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
	)

	minimap_icon = "surv"
	minimap_background = "background_civilian"

	survivor_variant = CIVILIAN_SURVIVOR

/datum/equipment_preset/survivor/usasf/crew
	name = "USASF Ground Crew"
	job_title  = JOB_USASF_CREW
	assignment = JOB_USASF_CREW

/datum/equipment_preset/survivor/usasf/crew/chaplain
	name = "USASF Chaplain"
	job_title = JOB_USASF_CHAPLAIN
	assignment = JOB_USASF_CHAPLAIN
	survivor_variant = CIVILIAN_SURVIVOR
	paygrades = list(PAY_SHORT_NO1 = JOB_PLAYTIME_TIER_0, PAY_SHORT_NO2 = JOB_PLAYTIME_TIER_1)

/datum/equipment_preset/survivor/usasf/crew/hangar_tech
	name = "USASF Hangar Technician"
	job_title  = JOB_USASF_HANGARTECH
	assignment = JOB_USASF_HANGARTECH
	skills = /datum/skills/military/survivor/usasf/technician

/datum/equipment_preset/survivor/usasf/crew/mess_tech
	name = "USASF Mess Technician"
	survivor_variant = ENGINEERING_SURVIVOR
	skills = /datum/skills/military/survivor/usasf/technician

/datum/equipment_preset/survivor/usasf/crew/cargo_tech
	name = "USASF Cargo Technician"
	job_title = JOB_USASF_CARGOTECH
	assignment = JOB_USASF_CARGOTECH
	survivor_variant = ENGINEERING_SURVIVOR
	skills = /datum/skills/military/survivor/usasf/technician

/datum/equipment_preset/survivor/usasf/crew/medical //abstract
	name = "USASF Medical Staff"
	skills = /datum/skills/military/survivor/usasf/medical
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_MEDBAY,
	)

	survivor_variant = MEDICAL_SURVIVOR

/datum/equipment_preset/survivor/usasf/crew/medical/nurse
	name = "USASF Nurse"
	job_title = JOB_USASF_NURSE
	assignment = JOB_USASF_NURSE
	paygrades = list(PAY_SHORT_NO2 = JOB_PLAYTIME_TIER_0, PAY_SHORT_NO3 = JOB_PLAYTIME_TIER_1)

/datum/equipment_preset/survivor/usasf/crew/medical/doctor
	name = "USASF Doctor"
	job_title = JOB_USASF_DOCTOR
	assignment = JOB_USASF_DOCTOR
	paygrades = list(PAY_SHORT_NO3 = JOB_PLAYTIME_TIER_0, PAY_SHORT_NO4 = JOB_PLAYTIME_TIER_1)

/datum/equipment_preset/survivor/usasf/security
	name = "USASF Security Defender"
	job_title = JOB_USASF_SECURITY_DEFENDER
	assignment = JOB_USASF_SECURITY_DEFENDER
	skills = /datum/skills/military/survivor/usasf/security
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_CHINESE) // needed to communicate with alpha-tech staff
	paygrades = list(PAY_SHORT_NE3 = JOB_PLAYTIME_TIER_0, PAY_SHORT_NE4 = JOB_PLAYTIME_TIER_1)
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_BRIG,
		ACCESS_CIVILIAN_COMMAND,
	)

	survivor_variant = SECURITY_SURVIVOR

/datum/equipment_preset/survivor/usasf/officer
	name = "USASF Officer"
	job_title = JOB_USASF_OFFICER
	assignment = JOB_USASF_OFFICER
	skills = /datum/skills/military/survivor/usasf/officer
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_CHINESE) // needed to communicate with alpha-tech staff
	idtype = /obj/item/card/id/gold/usasf
	paygrades = list(PAY_SHORT_NO2 = JOB_PLAYTIME_TIER_0, PAY_SHORT_NO3 = JOB_PLAYTIME_TIER_1)
	access = list(
		ACCESS_CIVILIAN_PUBLIC,
		ACCESS_CIVILIAN_ENGINEERING,
		ACCESS_CIVILIAN_LOGISTICS,
		ACCESS_CIVILIAN_MEDBAY,
		ACCESS_CIVILIAN_COMMAND,
	)

/datum/equipment_preset/survivor/usasf/officer/off_duty

/datum/equipment_preset/survivor/usasf/officer/pilot
	name = "USASF Pilot"
	job_title = JOB_USASF_PILOT
	assignment = JOB_USASF_PILOT
	skills = /datum/skills/military/survivor/usasf/pilot
	paygrades = list(PAY_SHORT_NO3 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/survivor/usasf/officer/co
	name = "USASF Aerospace Base Commander"
	job_title = JOB_USASF_CO
	assignment = JOB_USASF_CO
	skills = /datum/skills/commander
	paygrades = list(PAY_SHORT_NO5 = JOB_PLAYTIME_TIER_0) // Major equivalent

/datum/equipment_preset/synth/usasf // only thing that needs to be parented to something else
	name = "USASF Synthetic"
	paygrades = list(PAY_SHORT_NE7 = JOB_PLAYTIME_TIER_0)
	faction_group = list(FACTION_MARINE, FACTION_SURVIVOR)
	assignment = JOB_USASF_SYNTHETIC
	job_title  = JOB_USASF_SYNTHETIC
	idtype = /obj/item/card/id/gold

