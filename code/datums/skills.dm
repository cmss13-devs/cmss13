
/datum/skills
	var/name //the name of the skillset
	var/cqc = SKILL_CQC_DEFAULT
	var/melee_weapons = SKILL_MELEE_DEFAULT

	var/firearms = SKILL_FIREARMS_DEFAULT
	var/pistols = SKILL_PISTOLS_DEFAULT
	var/shotguns = SKILL_SHOTGUNS_DEFAULT
	var/rifles = SKILL_RIFLES_DEFAULT
	var/smgs = SKILL_SMGS_DEFAULT
	var/heavy_weapons = SKILL_HEAVY_WEAPONS_DEFAULT
	var/smartgun = SKILL_SMART_DEFAULT
	var/spec_weapons = SKILL_SPEC_DEFAULT

	var/endurance = SKILL_ENDURANCE_WEAK
	var/engineer = SKILL_ENGINEER_DEFAULT
	var/construction = SKILL_CONSTRUCTION_DEFAULT
	var/leadership = SKILL_LEAD_NOVICE
	var/medical = SKILL_MEDICAL_DEFAULT
	var/surgery = SKILL_SURGERY_DEFAULT
	var/research = SKILL_RESEARCH_DEFAULT
	var/pilot = SKILL_PILOT_DEFAULT
	var/police = SKILL_POLICE_DEFAULT
	var/powerloader = SKILL_POWERLOADER_DEFAULT
	var/large_vehicle = SKILL_LARGE_VEHICLE_DEFAULT


/*
---------------------
CIVILIAN
---------------------
*/

/datum/skills/civilian
	name = "Civilian"
	cqc = SKILL_CQC_WEAK
	firearms = SKILL_FIREARMS_UNTRAINED
	melee_weapons = SKILL_MELEE_WEAK
	endurance = SKILL_ENDURANCE_NONE

/datum/skills/civilian/survivor
	name = "Survivor"
	engineer = SKILL_ENGINEER_ENGI //to hack airlocks so they're never stuck in a room.
	construction = SKILL_CONSTRUCTION_METAL
	medical = SKILL_MEDICAL_CHEM
	endurance = SKILL_ENDURANCE_SURVIVOR

/datum/skills/civilian/survivor/doctor
	name = "Survivor Doctor"
	medical = SKILL_MEDICAL_DOCTOR
	surgery = SKILL_SURGERY_TRAINED

/datum/skills/civilian/survivor/scientist
	name = "Survivor Scientist"
	medical = SKILL_MEDICAL_MEDIC
	research = SKILL_RESEARCH_TRAINED

/datum/skills/civilian/survivor/chef
	name = "Survivor Chef"
	melee_weapons = SKILL_MELEE_TRAINED

/datum/skills/civilian/survivor/miner
	name = "Survivor Miner"
	powerloader = SKILL_POWERLOADER_TRAINED

/datum/skills/civilian/survivor/atmos
	name = "Survivor Atmos Tech"
	engineer = SKILL_ENGINEER_MT
	construction = SKILL_CONSTRUCTION_MASTER

/datum/skills/civilian/survivor/marshall
	name = "Survivor Marshall"
	cqc = SKILL_CQC_MP
	firearms = SKILL_FIREARMS_DEFAULT
	melee_weapons = SKILL_MELEE_DEFAULT
	pistols = SKILL_PISTOLS_TRAINED
	police = SKILL_POLICE_MP

/datum/skills/civilian/survivor/prisoner
	name = "Survivor Prisoner"
	cqc = SKILL_CQC_DEFAULT
	firearms = SKILL_FIREARMS_DEFAULT
	melee_weapons = SKILL_MELEE_DEFAULT
	pistols = SKILL_PISTOLS_DEFAULT

/*
---------------------
COMMAND STAFF
---------------------
*/

/datum/skills/admiral
	name = "Admiral"
	construction = SKILL_CONSTRUCTION_PLASTEEL
	leadership = SKILL_LEAD_MASTER
	medical = SKILL_MEDICAL_MEDIC
	police = SKILL_POLICE_FLASH
	powerloader = SKILL_POWERLOADER_TRAINED
	endurance = SKILL_ENDURANCE_SURVIVOR

/datum/skills/commander
	name = "Commander"
	engineer = SKILL_ENGINEER_ENGI
	construction = SKILL_CONSTRUCTION_ADVANCED
	smartgun = SKILL_SMART_TRAINED
	leadership = SKILL_LEAD_MASTER
	medical = SKILL_MEDICAL_MEDIC
	police = SKILL_POLICE_FLASH
	powerloader = SKILL_POWERLOADER_TRAINED
	endurance = SKILL_ENDURANCE_MASTER

/datum/skills/XO
	name = "Executive Officer"
	engineer = SKILL_ENGINEER_ENGI //to fix CIC apc.
	construction = SKILL_CONSTRUCTION_PLASTEEL
	leadership = SKILL_LEAD_MASTER
	medical = SKILL_MEDICAL_MEDIC
	police = SKILL_POLICE_FLASH
	powerloader = SKILL_POWERLOADER_TRAINED
	endurance = SKILL_ENDURANCE_TRAINED

/datum/skills/SO
	name = "Staff Officer"
	construction = SKILL_CONSTRUCTION_PLASTEEL
	leadership = SKILL_LEAD_EXPERT
	medical = SKILL_MEDICAL_MEDIC
	police = SKILL_POLICE_FLASH

/datum/skills/CMO
	name = "CMO"
	cqc = SKILL_CQC_WEAK
	firearms = SKILL_FIREARMS_UNTRAINED
	leadership = SKILL_LEAD_EXPERT
	medical = SKILL_MEDICAL_CMO
	surgery = SKILL_SURGERY_MASTER
	research = SKILL_RESEARCH_TRAINED
	melee_weapons = SKILL_MELEE_WEAK
	police = SKILL_POLICE_FLASH

/datum/skills/CMP
	name = "Chief MP"
	cqc = SKILL_CQC_MP
	police = SKILL_POLICE_MP
	leadership = SKILL_LEAD_EXPERT
	endurance = SKILL_ENDURANCE_TRAINED

/datum/skills/CE
	name = "Chief Engineer"
	engineer = SKILL_ENGINEER_MT
	construction = SKILL_CONSTRUCTION_MASTER
	leadership = SKILL_LEAD_MASTER
	police = SKILL_POLICE_FLASH
	powerloader = SKILL_POWERLOADER_PRO

/datum/skills/RO
	name = "Requisition Officer"
	construction = SKILL_CONSTRUCTION_PLASTEEL
	leadership = SKILL_LEAD_EXPERT
	powerloader = SKILL_POWERLOADER_TRAINED

/*
---------------------
MILITARY NONCOMBATANT
---------------------
*/

/datum/skills/doctor
	name = "Doctor"
	cqc = SKILL_CQC_WEAK
	firearms = SKILL_FIREARMS_UNTRAINED
	medical = SKILL_MEDICAL_DOCTOR
	melee_weapons = SKILL_MELEE_WEAK
	surgery = SKILL_SURGERY_TRAINED

/datum/skills/researcher
	name = "Researcher"
	cqc = SKILL_CQC_WEAK
	firearms = SKILL_FIREARMS_UNTRAINED
	medical = SKILL_MEDICAL_DOCTOR
	melee_weapons = SKILL_MELEE_WEAK
	surgery = SKILL_SURGERY_BEGINNER
	research = SKILL_RESEARCH_TRAINED

/datum/skills/pilot
	name = "Pilot Officer"
	pilot = SKILL_PILOT_TRAINED
	powerloader = SKILL_POWERLOADER_TRAINED
	leadership = SKILL_LEAD_TRAINED
	medical = SKILL_MEDICAL_MEDIC

/datum/skills/MP
	name = "Military Police"
	cqc = SKILL_CQC_MP
	police = SKILL_POLICE_MP
	endurance = SKILL_ENDURANCE_TRAINED

/datum/skills/MT
	name = "Maintenance Technician"
	engineer = SKILL_ENGINEER_MT
	construction = SKILL_CONSTRUCTION_MASTER
	powerloader = SKILL_POWERLOADER_MASTER

/datum/skills/CT
	name = "Cargo Technician"
	construction = SKILL_CONSTRUCTION_METAL
	powerloader = SKILL_POWERLOADER_PRO

/*
---------------------
SYNTHETIC
---------------------
*/

/datum/skills/synthetic
	name = "Synthetic"
	cqc = SKILL_CQC_MASTER
	engineer = SKILL_ENGINEER_MT
	construction = SKILL_CONSTRUCTION_MASTER
	firearms = SKILL_FIREARMS_TRAINED
	smartgun = SKILL_SMART_TRAINED
	spec_weapons = SKILL_SPEC_TRAINED
	leadership = SKILL_LEAD_EXPERT
	medical = SKILL_MEDICAL_CMO
	surgery = SKILL_SURGERY_MASTER
	research = SKILL_RESEARCH_TRAINED
	melee_weapons = SKILL_MELEE_SUPER
	pilot = SKILL_PILOT_TRAINED
	pistols = SKILL_PISTOLS_TRAINED
	smgs = SKILL_SMGS_TRAINED
	rifles = SKILL_RIFLES_TRAINED
	shotguns = SKILL_SHOTGUNS_TRAINED
	heavy_weapons = SKILL_HEAVY_WEAPONS_TRAINED
	police = SKILL_POLICE_MP
	powerloader = SKILL_POWERLOADER_MASTER
	large_vehicle = SKILL_LARGE_VEHICLE_TRAINED

/datum/skills/early_synthetic
	name = "Early Synthetic"
	cqc = SKILL_MELEE_TRAINED
	engineer = SKILL_ENGINEER_MT
	construction = SKILL_CONSTRUCTION_MASTER
	firearms = SKILL_FIREARMS_TRAINED
	smartgun = SKILL_SMART_TRAINED
	spec_weapons = SKILL_SPEC_TRAINED
	medical = SKILL_MEDICAL_DOCTOR
	surgery = SKILL_SURGERY_EXPERT
	research = SKILL_RESEARCH_TRAINED
	melee_weapons = SKILL_MELEE_SUPER
	pilot = SKILL_PILOT_TRAINED
	police = SKILL_POLICE_MP
	powerloader = SKILL_POWERLOADER_TRAINED
	large_vehicle = SKILL_LARGE_VEHICLE_TRAINED

/*
------------------------------
United States Colonial Marines
------------------------------
*/

/datum/skills/pfc
	name = "Private"
	//same as default

/datum/skills/pfc/crafty
	name = "Crafty Private"
	construction = SKILL_CONSTRUCTION_METAL
	engineer = SKILL_ENGINEER_METAL

/datum/skills/combat_medic
	name = "Combat Medic"
	leadership = SKILL_LEAD_BEGINNER
	medical = SKILL_MEDICAL_MEDIC

/datum/skills/combat_medic/crafty
	name = "Crafty Combat Medic"
	construction = SKILL_CONSTRUCTION_METAL
	engineer = SKILL_ENGINEER_METAL

/datum/skills/combat_engineer
	name = "Combat Engineer"
	engineer = SKILL_ENGINEER_ENGI
	construction = SKILL_CONSTRUCTION_ADVANCED
	leadership = SKILL_LEAD_BEGINNER

/datum/skills/smartgunner
	name = "Squad Smartgunner"
	smartgun = SKILL_SMART_TRAINED
	leadership = SKILL_LEAD_BEGINNER

/datum/skills/specialist
	name = "Squad Specialist"
	cqc = SKILL_CQC_TRAINED
	construction = SKILL_CONSTRUCTION_METAL
	engineer = SKILL_ENGINEER_METAL //to use c4 in scout set.
	smartgun = SKILL_SMART_TRAINED
	leadership = SKILL_LEAD_BEGINNER
	spec_weapons = SKILL_SPEC_TRAINED
	melee_weapons = SKILL_MELEE_TRAINED
	endurance = SKILL_ENDURANCE_TRAINED

/datum/skills/SL
	name = "Squad Leader"
	cqc = SKILL_CQC_TRAINED
	construction = SKILL_CONSTRUCTION_PLASTEEL
	engineer = SKILL_ENGINEER_PLASTEEL
	leadership = SKILL_LEAD_TRAINED
	medical = SKILL_MEDICAL_CHEM
	endurance = SKILL_ENDURANCE_TRAINED

/datum/skills/intel
	name = "Intelligence Officer"
	engineer = SKILL_ENGINEER_ENGI
	leadership = SKILL_LEAD_TRAINED
	cqc = SKILL_CQC_TRAINED
	melee_weapons = SKILL_MELEE_TRAINED


/*
-------------------------
COLONIAL LIBERATION FRONT
-------------------------
*/

//NOTE: The CLF have less firearms skill, but compensate with additional civilian skills and resourcefulness

/datum/skills/clf
	name = "CLF Fighter"
	leadership = SKILL_LEAD_BEGINNER
	firearms = SKILL_FIREARMS_UNTRAINED
	construction = SKILL_CONSTRUCTION_MASTER
	engineer = SKILL_ENGINEER_MT
	medical = SKILL_MEDICAL_MEDIC
	powerloader = SKILL_POWERLOADER_TRAINED
	large_vehicle = SKILL_LARGE_VEHICLE_TRAINED
	police = SKILL_POLICE_MP
	smartgun = SKILL_SMART_TRAINED
	spec_weapons = SKILL_SPEC_TRAINED

/datum/skills/clf/combat_medic
	name = "CLF Medic"
	medical = SKILL_MEDICAL_CMO
	surgery = SKILL_SURGERY_MASTER

/datum/skills/clf/leader
	name = "CLF Leader"
	firearms = SKILL_FIREARMS_DEFAULT
	cqc = SKILL_CQC_TRAINED
	leadership = SKILL_LEAD_TRAINED

/*
-----------
FREELANCERS
-----------
*/

//NOTE: Freelancer training is similar to the USCM's, but with additional construction skills

/datum/skills/freelancer
	name = "Freelancer Private"
	construction = SKILL_CONSTRUCTION_PLASTEEL
	engineer = SKILL_ENGINEER_ENGI

/datum/skills/freelancer/combat_medic
	name = "Freelancer Medic"
	leadership = SKILL_LEAD_BEGINNER
	medical = SKILL_MEDICAL_MEDIC

/datum/skills/freelancer/SL
	name = "Freelancer Leader"
	cqc = SKILL_CQC_TRAINED
	leadership = SKILL_LEAD_TRAINED
	medical = SKILL_MEDICAL_CHEM

/*
--------------------------
UNITED PROGRESSIVE PEOPLES
--------------------------
*/

//NOTE: UPP training is similar to the USCM's, but with additional construction skills

/datum/skills/upp
	name = "UPP Private"
	construction = SKILL_CONSTRUCTION_PLASTEEL
	engineer = SKILL_ENGINEER_ENGI
	endurance = SKILL_ENDURANCE_MASTER

/datum/skills/upp/combat_medic
	name = "UPP Medic"
	leadership = SKILL_LEAD_BEGINNER
	medical = SKILL_MEDICAL_MEDIC
	endurance = SKILL_ENDURANCE_MASTER

/datum/skills/upp/specialist
	name = "UPP Specialist"
	cqc = SKILL_CQC_TRAINED
	smartgun = SKILL_SMART_TRAINED
	leadership = SKILL_LEAD_BEGINNER
	spec_weapons = SKILL_SPEC_TRAINED
	melee_weapons = SKILL_MELEE_TRAINED
	endurance = SKILL_ENDURANCE_MASTER

/datum/skills/upp/SL
	name = "UPP Leader"
	cqc = SKILL_CQC_TRAINED
	leadership = SKILL_LEAD_TRAINED
	medical = SKILL_MEDICAL_CHEM
	endurance = SKILL_ENDURANCE_MASTER

/*
----------------------------
Private Military Contractors
----------------------------
*/

//NOTE: Compared to the USCM, PMCs have additional firearms training, construction skills and policing skills

/datum/skills/pmc
	name = "PMC Private"
	firearms = SKILL_FIREARMS_TRAINED
	police = SKILL_POLICE_MP
	construction = SKILL_CONSTRUCTION_PLASTEEL
	engineer = SKILL_ENGINEER_ENGI
	endurance = SKILL_ENDURANCE_MASTER

/datum/skills/pmc/smartgunner
	name = "PMC Smartgunner"
	smartgun = SKILL_SMART_TRAINED
	leadership = SKILL_LEAD_BEGINNER
	endurance = SKILL_ENDURANCE_MASTER

/datum/skills/pmc/specialist
	name = "PMC Specialist"
	cqc = SKILL_CQC_TRAINED
	smartgun = SKILL_SMART_TRAINED
	leadership = SKILL_LEAD_BEGINNER
	spec_weapons = SKILL_SPEC_TRAINED
	melee_weapons = SKILL_MELEE_TRAINED
	endurance = SKILL_ENDURANCE_MASTER

/datum/skills/pmc/SL
	name = "PMC Leader"
	cqc = SKILL_CQC_TRAINED
	leadership = SKILL_LEAD_TRAINED
	medical = SKILL_MEDICAL_CHEM
	endurance = SKILL_ENDURANCE_MASTER

/*
---------------------
SPEC-OPS
---------------------
*/

/datum/skills/commando
	name = "Commando"
	cqc = 3
	engineer = SKILL_ENGINEER_ENGI
	construction = SKILL_CONSTRUCTION_PLASTEEL
	firearms = SKILL_FIREARMS_TRAINED
	leadership = SKILL_LEAD_BEGINNER
	medical = SKILL_MEDICAL_CHEM
	melee_weapons = SKILL_MELEE_TRAINED
	pistols = SKILL_PISTOLS_TRAINED
	smgs = SKILL_SMGS_TRAINED
	rifles = SKILL_RIFLES_TRAINED
	shotguns = SKILL_SHOTGUNS_TRAINED
	heavy_weapons = SKILL_HEAVY_WEAPONS_TRAINED
	endurance = SKILL_ENDURANCE_SURVIVOR

/datum/skills/commando/medic
	name = "Commando Medic"
	medical = SKILL_MEDICAL_MEDIC

/datum/skills/commando/leader
	name ="Commando Leader"
	leadership = SKILL_LEAD_TRAINED

/datum/skills/commando/deathsquad
	name = "Deathsquad"
	cqc = SKILL_CQC_MASTER
	smartgun = SKILL_SMART_MASTER
	spec_weapons = SKILL_SPEC_TRAINED
	medical = SKILL_MEDICAL_MEDIC

/datum/skills/spy
	name = "Spy"
	cqc = SKILL_CQC_TRAINED
	firearms = SKILL_FIREARMS_TRAINED
	pistols = SKILL_PISTOLS_TRAINED
	smgs = SKILL_SMGS_TRAINED
	rifles = SKILL_RIFLES_TRAINED
	shotguns = SKILL_SHOTGUNS_TRAINED
	heavy_weapons = SKILL_HEAVY_WEAPONS_TRAINED
	engineer = SKILL_ENGINEER_MT
	construction = SKILL_CONSTRUCTION_ADVANCED
	leadership = SKILL_LEAD_BEGINNER
	medical = SKILL_MEDICAL_CHEM
	powerloader = SKILL_POWERLOADER_TRAINED

/datum/skills/ninja
	name = "Ninja"
	cqc = SKILL_CQC_MASTER
	construction = SKILL_CONSTRUCTION_METAL
	leadership = SKILL_LEAD_BEGINNER
	medical = SKILL_MEDICAL_CHEM
	melee_weapons = SKILL_MELEE_SUPER

/*
---------------------
MISCELLANEOUS
---------------------
*/

/datum/skills/mercenary
	name = "Mercenary"
	cqc = 3
	engineer = SKILL_ENGINEER_ENGI
	construction = SKILL_CONSTRUCTION_PLASTEEL
	firearms = SKILL_FIREARMS_TRAINED
	leadership = SKILL_LEAD_BEGINNER
	medical = SKILL_MEDICAL_CHEM
	melee_weapons = SKILL_MELEE_TRAINED
	pistols = SKILL_PISTOLS_TRAINED
	smgs = SKILL_SMGS_TRAINED
	rifles = SKILL_RIFLES_TRAINED
	shotguns = SKILL_SHOTGUNS_TRAINED
	heavy_weapons = SKILL_HEAVY_WEAPONS_TRAINED
	spec_weapons = SKILL_SPEC_TRAINED

/datum/skills/tank_crew
	name = "Tank Crew"
	large_vehicle = SKILL_LARGE_VEHICLE_TRAINED
	leadership = SKILL_LEAD_EXPERT
	powerloader = SKILL_POWERLOADER_DABBLING
	engineer = SKILL_ENGINEER_MT
	leadership = SKILL_LEAD_TRAINED

/datum/skills/gladiator
	name = "Gladiator"
	cqc = SKILL_CQC_MP
	melee_weapons = SKILL_MELEE_TRAINED
	firearms = SKILL_FIREARMS_UNTRAINED
	leadership = SKILL_LEAD_NOVICE
	medical = SKILL_MEDICAL_CHEM
	endurance = SKILL_ENDURANCE_SURVIVOR

/datum/skills/gladiator/champion
	name = "Gladiator Champion"
	cqc = SKILL_CQC_MASTER
	melee_weapons = SKILL_MELEE_SUPER
	leadership = SKILL_LEAD_TRAINED
	medical = SKILL_MEDICAL_MEDIC
	endurance = SKILL_ENDURANCE_SURVIVOR

/datum/skills/gladiator/champion/leader
	name = "Gladiator Leader"
	leadership = SKILL_LEAD_MASTER //Spartacus!
	endurance = SKILL_ENDURANCE_SURVIVOR

/datum/skills/yautja/warrior
	name = "Yautja Warrior"
	cqc = SKILL_CQC_MASTER
	engineer = SKILL_ENGINEER_MT
	construction = SKILL_CONSTRUCTION_MASTER
	medical = SKILL_MEDICAL_CMO
	surgery = SKILL_SURGERY_MASTER
	pistols = SKILL_PISTOLS_TRAINED
	smgs = SKILL_SMGS_TRAINED
	rifles = SKILL_RIFLES_TRAINED
	police = SKILL_POLICE_MP

/datum/skills/dutch
	name = "Dutch"
	cqc = SKILL_CQC_MASTER
	melee_weapons = SKILL_MELEE_SUPER
	engineer = SKILL_ENGINEER_ENGI
	construction = SKILL_CONSTRUCTION_PLASTEEL
	firearms = SKILL_FIREARMS_TRAINED
	leadership = SKILL_LEAD_EXPERT
	medical = SKILL_MEDICAL_CHEM
	pistols = SKILL_PISTOLS_TRAINED
	smgs = SKILL_SMGS_TRAINED
	rifles = SKILL_RIFLES_TRAINED
	shotguns = SKILL_SHOTGUNS_TRAINED
	heavy_weapons = SKILL_HEAVY_WEAPONS_TRAINED
	spec_weapons = SKILL_SPEC_TRAINED
	endurance = SKILL_ENDURANCE_SURVIVOR