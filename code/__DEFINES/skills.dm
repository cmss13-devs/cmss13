
//skill defines
#define SKILL_CQC            "cqc"
#define SKILL_MELEE_WEAPONS  "melee_weapons"
#define SKILL_FIREARMS       "firearms"
#define SKILL_SPEC_WEAPONS   "spec_weapons"
#define SKILL_ENDURANCE      "endurance"
#define SKILL_ENGINEER       "engineer"
#define SKILL_CONSTRUCTION   "construction"
#define SKILL_LEADERSHIP     "leadership"
#define SKILL_MEDICAL        "medical"
#define SKILL_SURGERY        "surgery"
#define SKILL_RESEARCH       "research"
#define SKILL_ANTAG          "antag"
#define SKILL_PILOT          "pilot"
#define SKILL_POLICE         "police"
#define SKILL_POWERLOADER    "powerloader"
#define SKILL_VEHICLE        "vehicles"

//firearms skill (general knowledge of guns) (hidden skill)
//increase or decrase accuracy, recoil, and firing delay of rifles and smgs.
#define SKILL_FIREARMS_UNTRAINED 0  //civilian
#define SKILL_FIREARMS_DEFAULT   1   //marines (allow tactical reloads)
#define SKILL_FIREARMS_TRAINED   2   //special training


//spec_weapons skill
//hidden. who can and can't use specialist weapons
#define SKILL_SPEC_DEFAULT      0
#define SKILL_SPEC_ROCKET       1 //can use the demolitionist specialist gear
#define SKILL_SPEC_SCOUT        2
#define SKILL_SPEC_SNIPER       3
#define SKILL_SPEC_GRENADIER    4
#define SKILL_SPEC_PYRO         5
#define SKILL_SPEC_SMARTGUN		6 //for smartgunners
#define SKILL_SPEC_UPP      	7 //for upp
#define SKILL_SPEC_TRAINED      8 //can use all specialist gear


//construction skill
#define SKILL_CONSTRUCTION_DEFAULT		0
#define SKILL_CONSTRUCTION_TRAINED		1   //metal barricade construction (CT, mini-engis)
#define SKILL_CONSTRUCTION_ENGI			2   //plasteel barricade, windows and girder construction, building machine&computer frames, (Combat Engi, OT, etc.)
#define SKILL_CONSTRUCTION_MASTER		3   //Synths


// engineer skill
#define SKILL_ENGINEER_DEFAULT		0
#define SKILL_ENGINEER_TRAINED		1   //barricade repair && c4 use (mini-engis, specs)
#define SKILL_ENGINEER_ENGI			2   //plasteel barricade deconstruction, hacking&&planet engine fixing&&apc building, Telecomms fixing (Combat Engi, OT, etc.)
#define SKILL_ENGINEER_MASTER       3   //Synths


//medical skill
#define SKILL_MEDICAL_DEFAULT	0
#define SKILL_MEDICAL_TRAINED	1 //recognizing chemicals, using autoinjectors & hyposprays with any chemicals (SL, mini-medics)
#define SKILL_MEDICAL_MEDIC     2 //syringe use & defib use (Combat Medic, doctors)
#define SKILL_MEDICAL_DOCTOR    3 //Chemmaster use, 25% reduction in medical task (splints, defib, cpr)
#define SKILL_MEDICAL_MASTER	4 //Synths

//surgery skill
#define SKILL_SURGERY_DEFAULT   0 //Can't do surgery
#define SKILL_SURGERY_TRAINED   1 //Can do surgery (Doctors)
#define SKILL_SURGERY_EXPERT    2 //(Synths)
//higher levels means faster surgery.


//research skill
#define SKILL_RESEARCH_DEFAULT  0
#define SKILL_RESEARCH_TRAINED  1 //Allows use of research machines

//antag skill
#define SKILL_ANTAG_DEFAULT 0
#define SKILL_ANTAG_TRAINED 1

//police skill, hidden
#define SKILL_POLICE_DEFAULT    0
#define SKILL_POLICE_FLASH      1 //flash use (CE, CMO, any officer starting with a flash)
#define SKILL_POLICE_MP         2 //all police gear use, can strip someone's clothes simultaneously (MP)


//cqc skill
//higher disarm chance on humans(+5% per level)
//slight increase in punch damage.
#define SKILL_CQC_DEFAULT   0
#define SKILL_CQC_TRAINED   1
#define SKILL_CQC_MP        2 //no risk of accidental weapon discharge upon disarming (MP)
#define SKILL_CQC_EXPERT    3
#define SKILL_CQC_MASTER    5


//powerloader skill
//hidden
//proficiency with powerloader, changes powerloader speed.
#define SKILL_POWERLOADER_DEFAULT   0
#define SKILL_POWERLOADER_TRAINED	1 //
#define SKILL_POWERLOADER_MASTER	2 //Pilot, CT, Req, OT, CE


//leadership skill
#define SKILL_LEAD_NOVICE           0 //Anyone but the above. Using SL items is possible but painfully slow
#define SKILL_LEAD_BEGINNER         1 //All non-Standard Marines
#define SKILL_LEAD_TRAINED          2 //SL
#define SKILL_LEAD_EXPERT           3 //SOs
#define SKILL_LEAD_MASTER           4 //XO, CO


//melee_weapons skill
//buff to melee weapon attack damage(+25% dmg per level)
#define SKILL_MELEE_DEFAULT     0
#define SKILL_MELEE_TRAINED     1
#define SKILL_MELEE_SUPER       2


//pilot skill, hidden
#define SKILL_PILOT_DEFAULT     0
#define SKILL_PILOT_TRAINED     1 //Pilot


//endurance skill
#define SKILL_ENDURANCE_NONE        0
#define SKILL_ENDURANCE_WEAK        1
#define SKILL_ENDURANCE_TRAINED     2
#define SKILL_ENDURANCE_MASTER      3
#define SKILL_ENDURANCE_SURVIVOR    5

//multitile vehicle skills
//Can't drive
#define SKILL_VEHICLE_DEFAULT 0
//Can drive small vehicles (truck)
#define SKILL_VEHICLE_SMALL   1
//Can drive large vehicles (apc, tank)
#define SKILL_VEHICLE_LARGE   2
//Can drive all vehicles and man their guns
#define SKILL_VEHICLE_CREWMAN 3