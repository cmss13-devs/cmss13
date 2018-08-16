//Skills

/datum/skills/honor_guard
	name = "Honor Guard"
	large_vehicle = SKILL_LARGE_VEHICLE_TRAINED
	powerloader = SKILL_POWERLOADER_DABBLING
	cqc = SKILL_CQC_MP
	smgs = SKILL_SMGS_TRAINED
	rifles = SKILL_RIFLES_TRAINED
	shotguns = SKILL_SHOTGUNS_TRAINED
	firearms = SKILL_FIREARMS_TRAINED

/datum/skills/honor_guard/vet
	name = "Honor Guard Verteran"
	large_vehicle = SKILL_LARGE_VEHICLE_TRAINED
	powerloader = SKILL_POWERLOADER_DABBLING
	leadership = SKILL_LEAD_EXPERT

/datum/skills/honor_guard/spec
	name = "Honor Guard Specialist"
	large_vehicle = SKILL_LARGE_VEHICLE_TRAINED
	powerloader = SKILL_POWERLOADER_DABBLING
	leadership = SKILL_LEAD_TRAINED
	heavy_weapons = SKILL_HEAVY_WEAPONS_TRAINED
	spec_weapons = SKILL_SPEC_TRAINED

/datum/skills/honor_guard/lead
	name = "Honor Guard Squad Leader"
	engineer = SKILL_ENGINEER_ENGI //to fix CIC apc.
	construction = SKILL_CONSTRUCTION_PLASTEEL
	leadership = SKILL_LEAD_MASTER
	medical = SKILL_MEDICAL_MEDIC
	police = SKILL_POLICE_FLASH
	powerloader = SKILL_POWERLOADER_TRAINED
	smartgun = SKILL_SMART_TRAINED

/datum/skills/mortar_crew
	name = "Mortar Crew"
	engineer = SKILL_ENGINEER_ENGI
	construction = SKILL_CONSTRUCTION_ADVANCED
	leadership = SKILL_LEAD_BEGINNER
	powerloader = SKILL_POWERLOADER_TRAINED