/*
Intelligence Analyst: The classic "tourist" business casual look of
Vietnam-era CIA. Casual clothing, civilian rank, modifiable job.
- USCM Liaison: A (**real**) military officer who works with the CIA as
a military liaison, though not in an outright public way. Can be either
O-2 or O-3.
- Marine Raider: A CIA agent operating as a Marine Raider. They're on
the same side, just possibly with differing objectives.
- UPP Soldier: A UPP grunt recruited as a CIA informant.
- UPP Senior Officer: A UPP _Starshiy Leytenant_ officer recruited as a
CIA informant.
- CLF Engineer: A CLF field technician recruited as a CIA informant.
*/

/datum/equipment_preset/cia
	//name = "CIA"
	assignment = JOB_CIA_RU

/datum/equipment_preset/cia/officer
	//name = "CIA Agent (USCM Liaison - 1st Lieutenant)"
	assignment = JOB_CIA_LIAISON_RU

/datum/equipment_preset/cia/officer/o3
	//name = "CIA Agent (USCM Liaison - Captain)"
	assignment = JOB_CIA_LIAISON_RU

/datum/equipment_preset/uscm/marsoc/low_threat/cia
	//name = "CIA Agent (Marine Raider Advisor)"
	assignment = JOB_CIA_RAIDER_RU

/datum/equipment_preset/clf/engineer/cia
	//name = "CIA Spy (CLF Engineer)"
	assignment = JOB_CIA_CLF_RU

/datum/equipment_preset/upp/soldier/dressed/cia
	//name = "CIA Spy (UPP Soldier)"
	assignment = JOB_CIA_UPP_RU

/datum/equipment_preset/upp/officer/senior/dressed/cia
	//name = "CIA Spy (UPP Senior Officer)"
	assignment = JOB_CIA_UPP_OFFICER_RU
