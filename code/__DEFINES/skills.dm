
//skill defines
#define SKILL_CQC "cqc"
#define SKILL_MELEE_WEAPONS "melee_weapons"
#define SKILL_FIREARMS "firearms"
#define SKILL_SPEC_WEAPONS "spec_weapons"
#define SKILL_ENDURANCE "endurance"
#define SKILL_ENGINEER "engineer"
#define SKILL_CONSTRUCTION "construction"
#define SKILL_LEADERSHIP "leadership"
#define SKILL_OVERWATCH "overwatch"
#define SKILL_MEDICAL "medical"
#define SKILL_SURGERY "surgery"
#define SKILL_RESEARCH "research"
#define SKILL_ANTAG "antag"
#define SKILL_PILOT "pilot"
#define SKILL_NAVIGATIONS "navigations"
#define SKILL_POLICE "police"
#define SKILL_POWERLOADER "powerloader"
#define SKILL_VEHICLE "vehicles"
#define SKILL_JTAC "jtac"
#define SKILL_EXECUTION "execution"
#define SKILL_INTEL "intel"
#define SKILL_DOMESTIC "domestics"
#define SKILL_FIREMAN "fireman"

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------IMPORTANT--MAX--SHOULD--BE--EQUAL--TO--HIGHEST--POSSIBLE--SKILL------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

//firearms skill (general knowledge of guns) (hidden skill)
//increase or decrase accuracy, recoil, and firing delay of rifles and smgs.
#define SKILL_FIREARMS_CIVILIAN 0  //civilian
#define SKILL_FIREARMS_TRAINED 1   //marines (allow tactical reloads)
#define SKILL_FIREARMS_EXPERT 2   //special training
#define SKILL_FIREARMS_MAX 2

//spec_weapons skill
//hidden. who can and can't use specialist weapons
#define SKILL_SPEC_DEFAULT 0
/// Is trained to use specialist gear, but hasn't picked a kit.
#define SKILL_SPEC_TRAINED 1
/// Is trained to use specialist gear & HAS picked a kit. (Functionally same as SPEC_ROCKET)
#define SKILL_SPEC_KITTED 2
/// Can use RPG
#define SKILL_SPEC_ROCKET 2
/// Can use thermal cloaks and custom M4RA rifle
#define SKILL_SPEC_SCOUT 3
/// Can use sniper rifles and camo suits
#define SKILL_SPEC_SNIPER 4
/// Can use the rotary grenade launcher and heavy armor
#define SKILL_SPEC_GRENADIER 5
/// Can use heavy flamers
#define SKILL_SPEC_PYRO 6
/// Can use smartguns
#define SKILL_SPEC_SMARTGUN 7
/// UPP special training
#define SKILL_SPEC_UPP 8
/// Can use ALL specialist weapons
#define SKILL_SPEC_ALL 9

//construction skill
#define SKILL_CONSTRUCTION_DEFAULT 0
#define SKILL_CONSTRUCTION_TRAINED 1   //metal barricade construction (CT, mini-engis)
#define SKILL_CONSTRUCTION_ENGI 2   //plasteel barricade, windows and girder construction, building machine&computer frames, (Combat Engi, OT, etc.)
#define SKILL_CONSTRUCTION_MASTER 3   //Synths
#define SKILL_CONSTRUCTION_MAX 3

// engineer skill
#define SKILL_ENGINEER_DEFAULT 0
#define SKILL_ENGINEER_NOVICE 1   //barricade repair && c4 use (mini-engis, specs)
#define SKILL_ENGINEER_TRAINED 2   //plasteel barricade deconstruction, hacking&&planet engine fixing&&apc building, Telecomms fixing  (OT, etc.)
#define SKILL_ENGINEER_ENGI 3      // Slightly faster at everything (Combat Technicians)
#define SKILL_ENGINEER_MASTER 4   //Synths
#define SKILL_ENGINEER_MAX 4

//medical skill
#define SKILL_MEDICAL_DEFAULT 0
#define SKILL_MEDICAL_TRAINED 1 //recognizing chemicals, using autoinjectors & hyposprays with any chemicals (SL, mini-medics)
#define SKILL_MEDICAL_MEDIC 2 //syringe use & defib use (Combat Medic, doctors)
#define SKILL_MEDICAL_DOCTOR 3 //Chemmaster use, 25% reduction in medical task (splints, defib, cpr)
#define SKILL_MEDICAL_MASTER 4
#define SKILL_MEDICAL_MAX 4

//surgery skill
#define SKILL_SURGERY_DEFAULT 0 //Can't do surgery
#define SKILL_SURGERY_NOVICE 1 //Can use autodocs and perform basic surgery (Nurses, Medics, PO)
#define SKILL_SURGERY_TRAINED 2 //Can do all surgeries (Doctors)
#define SKILL_SURGERY_EXPERT 3
#define SKILL_SURGERY_MAX 3
//higher levels means faster surgery.


//research skill
#define SKILL_RESEARCH_DEFAULT 0
#define SKILL_RESEARCH_TRAINED 1 //Allows use of research machines
#define SKILL_RESEARCH_MAX 1

//antag skill
#define SKILL_ANTAG_DEFAULT 0
#define SKILL_ANTAG_AGENT 1
#define SKILL_ANTAG_HUNTER 2
#define SKILL_ANTAG_MAX 2

//police skill, hidden
#define SKILL_POLICE_DEFAULT 0
#define SKILL_POLICE_FLASH 1 //flash use (CE, CMO, any officer starting with a flash)
#define SKILL_POLICE_SKILLED 2 //all police gear use, can strip someone's clothes simultaneously (MP)
#define SKILL_POLICE_MAX 2


//cqc skill
//higher disarm chance on humans(+5% per level)
//slight increase in punch damage.
#define SKILL_CQC_DEFAULT 0
#define SKILL_CQC_TRAINED 1
#define SKILL_CQC_SKILLED 2 //no risk of accidental weapon discharge upon disarming (MP)
#define SKILL_CQC_EXPERT 3
#define SKILL_CQC_MASTER 5
#define SKILL_CQC_MAX 5


//execution skill
//roles with the execution skill can perform battlefield executions (i.e. mateba and deagle)
//should be restricted to CO/general/W-Y execs maybe

#define SKILL_EXECUTION_DEFAULT 0
#define SKILL_EXECUTION_TRAINED 1
#define SKILL_EXECUTION_MAX 1

//powerloader skill
//hidden
//proficiency with powerloader, changes powerloader speed.
#define SKILL_POWERLOADER_DEFAULT 0
#define SKILL_POWERLOADER_TRAINED 1 //
#define SKILL_POWERLOADER_MASTER 2 //Pilot, CT, Req, OT, CE
#define SKILL_POWERLOADER_MAX 2

//leadership skill
#define SKILL_LEAD_NOVICE 0 //Anyone but the above. Using SL items is possible but painfully slow
#define SKILL_LEAD_TRAINED 1 //SL
#define SKILL_LEAD_EXPERT 2 //SOs
#define SKILL_LEAD_MASTER 3 //XO, CO
#define SKILL_LEAD_MAX 3

//overwatch skill
#define SKILL_OVERWATCH_DEFAULT 0
#define SKILL_OVERWATCH_TRAINED 1 //Allows use of overwatch consoles
#define SKILL_OVERWATCH_MAX 1


//JTAC skill
#define SKILL_JTAC_NOVICE 0 //Anyone but those following.
#define SKILL_JTAC_BEGINNER 1 //All non-Standard Marines
#define SKILL_JTAC_TRAINED 2 //SL
#define SKILL_JTAC_EXPERT 3 //SOs
#define SKILL_JTAC_MASTER 4 //XO, CO
#define SKILL_JTAC_MAX 4


//melee_weapons skill
//buff to melee weapon attack damage(+25% dmg per level)
#define SKILL_MELEE_DEFAULT 0
#define SKILL_MELEE_TRAINED 1
#define SKILL_MELEE_SUPER 2
#define SKILL_MELEE_MAX 2


//pilot skill, hidden
#define SKILL_PILOT_DEFAULT 0
#define SKILL_PILOT_TRAINED 1 // DCC
#define SKILL_PILOT_EXPERT 2 // Pilot
#define SKILL_PILOT_MASTER 3 // OP, Synth
#define SKILL_PILOT_MAX 3

//Navigations skill - for seting orbital alt
#define SKILL_NAVIGATIONS_DEFAULT 0
#define SKILL_NAVIGATIONS_TRAINED 1
#define SKILL_NAVIGATIONS_MAX 1

//endurance skill - Leaving surv for ease of change
#define SKILL_ENDURANCE_NONE 0
#define SKILL_ENDURANCE_WEAK 1
#define SKILL_ENDURANCE_SURVIVOR 2
#define SKILL_ENDURANCE_TRAINED 2
#define SKILL_ENDURANCE_MASTER 3
#define SKILL_ENDURANCE_EXPERT 4
#define SKILL_ENDURANCE_MAX 5

//domestic skill, how well you work cleaning equipment and cooking stuff
#define SKILL_DOMESTIC_NONE 0
#define SKILL_DOMESTIC_TRAINED 1
#define SKILL_DOMESTIC_MASTER 2
#define SKILL_DOMESTIC_MAX 2

//multitile vehicle skills
//Can't drive
#define SKILL_VEHICLE_DEFAULT 0
//Can drive small vehicles (truck)
#define SKILL_VEHICLE_SMALL 1
//Can drive large vehicles (apc, tank)
#define SKILL_VEHICLE_LARGE 2
//Can drive all vehicles and man their guns
#define SKILL_VEHICLE_CREWMAN 3
//MAX skill
#define SKILL_VEHICLE_MAX 3

// Intel skills
#define SKILL_INTEL_NOVICE 0
#define SKILL_INTEL_TRAINED 1
#define SKILL_INTEL_EXPERT 2
#define SKILL_INTEL_MAX 2

// Fireman carry - Separated from police skills for further rebalances. Determines how fast you carry someone.
#define SKILL_FIREMAN_DEFAULT 0
#define SKILL_FIREMAN_TRAINED 1
#define SKILL_FIREMAN_SKILLED 2
#define SKILL_FIREMAN_EXPERT 3
#define SKILL_FIREMAN_MASTER 5
#define SKILL_FIREMAN_MAX 5
