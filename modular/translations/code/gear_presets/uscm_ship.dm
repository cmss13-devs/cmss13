/datum/equipment_preset/uscm_ship
	//name = "USCM (ship roles)"
	//assignment = FACTION_MARINE_RU

/datum/equipment_preset/uscm_ship/liaison
	//name = "USCM Corporate Liaison (CL)"
	assignment = JOB_CORPORATE_LIAISON_RU

/datum/equipment_preset/uscm_ship/reporter
	//name = "Combat Correspondent (Press)"
	assignment = JOB_CIVILIAN_REPORTER_RU

/datum/equipment_preset/uscm_ship/reporter_uscm
	//name = "Combat Correspondent"
	assignment = JOB_MILITARY_REPORTER_RU

/datum/equipment_preset/uscm_ship/reporter/field
	name = "Field Correspondent"
	assignment = JOB_COMBAT_REPORTER_RU

/datum/equipment_preset/uscm_ship/reporter/field/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/reporter/blue(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/soft/trucker(new_human), WEAR_HEAD)
	. = ..()

/datum/equipment_preset/uscm_ship/chief_engineer
	//name = "USCM Chief Engineer (CE)"
	assignment = JOB_CHIEF_ENGINEER_RU

/datum/equipment_preset/uscm_ship/maint
	//name = "USCM Maintenance Technician (MT)"
	assignment = JOB_MAINT_TECH_RU

/datum/equipment_preset/uscm_ship/ordn
	//name = "USCM Ordnance Technician (OT)"
	assignment = JOB_ORDNANCE_TECH_RU

/datum/equipment_preset/uscm_ship/qm
	//name = "USCM Quartermaster (QM)"
	assignment = JOB_CHIEF_REQUISITION_RU

/datum/equipment_preset/uscm_ship/cargo
	//name = "USCM Cargo Technician (CT)"
	assignment = JOB_CARGO_TECH_RU

/datum/equipment_preset/uscm_ship/commander
	//name = "USCM Commanding Officer (CO)"
	assignment = JOB_CO_RU

/datum/equipment_preset/uscm_ship/commander/visitor
	//name = "USCM Observer (Major) (VO)"
	assignment = JOB_USCM_OBSV_RU

/datum/equipment_preset/uscm_ship/commander/council
	//name = "USCM Commanding Officer (CO+)"
	assignment = JOB_CO_RU

/datum/equipment_preset/uscm_ship/commander/council/plus
	//name = "USCM Commanding Officer (CO++)"
	assignment = JOB_CO_RU

/datum/equipment_preset/uscm_ship/xo
	//name = "USCM Executive Officer (XO)"
	assignment = JOB_XO_RU

/datum/equipment_preset/uscm_ship/so
	//name = "USCM Staff Officer (SO)"
	assignment = JOB_SO_RU

/datum/equipment_preset/uscm_ship/sea
	//name = "USCM Senior Enlisted Advisor (SEA)"
	assignment = JOB_SEA_RU

/datum/equipment_preset/uscm_ship/auxiliary_officer
	//name = "USCM Auxiliary Support Officer (ASO)"
	assignment = JOB_AUXILIARY_OFFICER_RU

/datum/equipment_preset/uscm_ship/gp
	//name = "USCM Gunship Pilot (GP) (Cryo)"
	assignment = JOB_CAS_PILOT_RU

/datum/equipment_preset/uscm_ship/gp/full
	//name = "USCM Gunship Pilot (GP)"
	assignment = JOB_CAS_PILOT_RU

/datum/equipment_preset/uscm_ship/dp
	//name = "USCM Dropship Pilot (DP) (Cryo)"
	assignment = JOB_DROPSHIP_PILOT_RU

/datum/equipment_preset/uscm_ship/dp/full
	//name = "USCM Dropship Pilot (DP)"
	assignment = JOB_DROPSHIP_PILOT_RU

/datum/equipment_preset/uscm_ship/dcc
	//name = "USCM Dropship Crew Chief (DCC) (Cryo)"
	assignment = JOB_DROPSHIP_CREW_CHIEF_RU

/datum/equipment_preset/uscm_ship/dcc/full
	//name = "USCM Dropship Crew Chief (DCC)"
	assignment = JOB_DROPSHIP_CREW_CHIEF_RU

/datum/equipment_preset/uscm_ship/officer
	//name = "USCM Officer (USCM Command)"
	assignment = "USCM Officer_RU"

/datum/equipment_preset/uscm_ship/chef
	//name = "USCM Mess Technician (MST)"
	assignment = JOB_MESS_SERGEANT_RU
