
//skill defines
#define SKILL_CQC            "cqc"
#define SKILL_MELEE_WEAPONS  "melee_weapons"
#define SKILL_FIREARMS       "firearms"
#define SKILL_PISTOLS        "pistols"
#define SKILL_SHOTGUNS       "shotguns"
#define SKILL_RIFLES         "rifles"
#define SKILL_SMGS           "smgs"
#define SKILL_HEAVY_WEAPONS  "heavy_weapons"
#define SKILL_SMARTGUN       "smartgun"
#define SKILL_SPEC_WEAPONS   "spec_weapons"
#define SKILL_ENDURANCE      "endurance"
#define SKILL_ENGINEER       "engineer"
#define SKILL_CONSTRUCTION   "construction"
#define SKILL_LEADERSHIP     "leadership"
#define SKILL_MEDICAL        "medical"
#define SKILL_SURGERY        "surgery"
#define SKILL_RESEARCH       "research"
#define SKILL_PILOT          "pilot"
#define SKILL_POLICE         "police"
#define SKILL_POWERLOADER    "powerloader"
#define SKILL_VEHICLE        "vehicles"
#define SKILL_SURVIVAL       "survival"
#define SKILL_READING        "reading"

//firearms skill (general knowledge of guns) (hidden skill)
//increase or decrase accuracy, recoil, and firing delay of rifles and smgs.
#define SKILL_FIREARMS_UNTRAINED 0  //civilian
#define SKILL_FIREARMS_DEFAULT   1   //marines (allow tactical reloads)
#define SKILL_FIREARMS_TRAINED   2   //special training

//pistols skill
//increase or decrase accuracy, recoil, and firing delay of pistols and revolvers.
#define SKILL_PISTOLS_DEFAULT   0   //marines
#define SKILL_PISTOLS_TRAINED   1   //special training

//smgs skill
//increase or decrase accuracy, recoil, and firing delay of submachineguns.
#define SKILL_SMGS_DEFAULT  0   //marines
#define SKILL_SMGS_TRAINED  1   //special training

//rifles skill
//increase or decrase accuracy, recoil, and firing delay of rifles.
#define SKILL_RIFLES_DEFAULT    0   //marines
#define SKILL_RIFLES_TRAINED    1   //special training

//shotguns skill
//increase or decrase accuracy, recoil, and firing delay of shotguns.
#define SKILL_SHOTGUNS_DEFAULT  0   //marines
#define SKILL_SHOTGUNS_TRAINED  1   //special training

//heavy weapons skill
//increase or decrase accuracy, recoil, and firing delay of heavy weapons (non spec weapons, e.g. flamethrower).
#define SKILL_HEAVY_WEAPONS_DEFAULT 	0	//marines
#define SKILL_HEAVY_WEAPONS_TRAINED		1	//special training



//smartgun skill
//increase or decrase accuracy, recoil, and firing delay for smartgun, and whether we can use smartguns at all.
#define SKILL_SMART_DEFAULT        -4 //big negative so the effects are far worse than pistol/rifle untrained
#define SKILL_SMART_USE            -3 //can use smartgun
#define SKILL_SMART_TRAINED         0 //default for smartgunner
#define SKILL_SMART_EXPERT          1
#define SKILL_SMART_MASTER          2



//spec_weapons skill
//hidden. who can and can't use specialist weapons
#define SKILL_SPEC_DEFAULT      0
#define SKILL_SPEC_ROCKET       1 //can use the demolitionist specialist gear
#define SKILL_SPEC_SCOUT        2
#define SKILL_SPEC_SNIPER       3
#define SKILL_SPEC_GRENADIER    4
#define SKILL_SPEC_PYRO         5
#define SKILL_SPEC_TRAINED      6 //can use all specialist gear



//construction skill
#define SKILL_CONSTRUCTION_DEFAULT  0
#define SKILL_CONSTRUCTION_METAL    1   //metal barricade construction (CT)
#define SKILL_CONSTRUCTION_PLASTEEL 2   //plasteel barricade,(Req)(combat engi)
#define SKILL_CONSTRUCTION_ADVANCED 3   //windows and girder construction
#define SKILL_CONSTRUCTION_MASTER   4   //building machine&computer frames (OT, CE)




// engineer skill
#define SKILL_ENGINEER_DEFAULT  0
#define SKILL_ENGINEER_METAL    1   //barricade repair && c4 use
#define SKILL_ENGINEER_PLASTEEL 2   //plasteel barricade deconstruction
#define SKILL_ENGINEER_ENGI     3   //hacking&&planet engine fixing&&apc building (combat engi)
#define SKILL_ENGINEER_OT       4   //Telecomms fixing, faster engine fixing (OT)
//higher levels give faster Almayer engine repair.


//medical skill
#define SKILL_MEDICAL_DEFAULT   0
#define SKILL_MEDICAL_CHEM      1 //recognizing chemicals, using autoinjectors & hyposprays with any chemicals (SL)
#define SKILL_MEDICAL_MEDIC     2 //syringe use & defib use (Combat Medic)
#define SKILL_MEDICAL_DOCTOR    3
#define SKILL_MEDICAL_CMO       4
//higher levels means faster syringe use and better defibrillation


//surgery skill
#define SKILL_SURGERY_DEFAULT   0
#define SKILL_SURGERY_BEGINNER  1 //can do surgery (Researcher)
#define SKILL_SURGERY_TRAINED   2 //(Doctor)
#define SKILL_SURGERY_EXPERT    3 //(Gen-1 Synths)
#define SKILL_SURGERY_MASTER    4 //(CMO)
//higher levels means faster surgery.

//research skill
#define SKILL_RESEARCH_DEFAULT  0
#define SKILL_RESEARCH_TRAINED  1 //Allows use of research machines


//police skill, hidden
#define SKILL_POLICE_DEFAULT    0
#define SKILL_POLICE_FLASH      1 //flash use (CE, CMO, any officer starting with a flash)
#define SKILL_POLICE_MP         2 //all police gear use, can strip someone's clothes simultaneously (MP)


//cqc skill
//higher disarm chance on humans(+5% per level)
//slight increase in punch damage.
#define SKILL_CQC_WEAK      -1
#define SKILL_CQC_DEFAULT   0
#define SKILL_CQC_TRAINED   1
#define SKILL_CQC_MP        2 //no risk of accidental weapon discharge upon disarming (MP)
#define SKILL_CQC_EXPERT    3
#define SKILL_CQC_MASTER    5


//powerloader skill
//hidden
//proficiency with powerloader, changes powerloader speed.
#define SKILL_POWERLOADER_DEFAULT   0
#define SKILL_POWERLOADER_DABBLING  1 //Pilot
#define SKILL_POWERLOADER_TRAINED   2 //CT, Req
#define SKILL_POWERLOADER_PRO       3 //OT
#define SKILL_POWERLOADER_MASTER    4 //CE


//leadership skill
#define SKILL_LEAD_NOVICE           0 //Anyone but the above. Using SL items is possible but painfully slow
#define SKILL_LEAD_BEGINNER         1 //All non-Standard Marines
#define SKILL_LEAD_TRAINED          2 //SL
#define SKILL_LEAD_EXPERT           3 //SOs
#define SKILL_LEAD_MASTER           4 //XO, CO


//melee_weapons skill
//buff to melee weapon attack damage(+30% dmg per level)
#define SKILL_MELEE_WEAK       -1
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
//survival skill
//allows special mechanics like crafting improvised stuff
#define SKILL_SURVIVAL_NONE     0
#define SKILL_SURVIVAL_NOVICE   1
#define SKILL_SURVIVAL_SURVIVOR 2
//reading skill
//for faster intel processing
#define SKILL_READING_NONE		0
#define SKILL_READING_TRAINED	1
#define SKILL_READING_EXPERT	2