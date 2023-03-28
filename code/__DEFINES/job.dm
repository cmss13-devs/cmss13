#define get_job_playtime(client, job) (client.player_data? LAZYACCESS(client.player_data.playtimes, job)? client.player_data.playtimes[job].total_minutes MINUTES_TO_DECISECOND : 0 : 0)
#define GET_MAPPED_ROLE(title) (RoleAuthority?.role_mappings[title] ? RoleAuthority.role_mappings[title] : RoleAuthority.roles_by_name[title])
#define GET_DEFAULT_ROLE(title) (RoleAuthority?.default_roles[title] ? RoleAuthority.default_roles[title] : title)

// Squad name defines
#define SQUAD_MARINE_1 "Alpha"
#define SQUAD_MARINE_2 "Bravo"
#define SQUAD_MARINE_3 "Charlie"
#define SQUAD_MARINE_4 "Delta"
#define SQUAD_MARINE_5 "Echo"
#define SQUAD_MARINE_CRYO "Foxtrot"
#define SQUAD_SOF "SOF"

// Job name defines
#define JOB_SQUAD_MARINE "Squad Rifleman"
#define JOB_SQUAD_LEADER "Squad Leader"
#define JOB_SQUAD_ENGI "Squad Combat Technician"
#define JOB_SQUAD_MEDIC "Squad Hospital Corpsman"
#define JOB_SQUAD_SPECIALIST "Squad Weapons Specialist"
#define JOB_SQUAD_RTO "Squad Radio Telephone Operator"
#define JOB_SQUAD_SMARTGUN "Squad Smartgunner"
#define JOB_SQUAD_ROLES /datum/timelock/squad
#define JOB_SQUAD_ROLES_LIST list(JOB_SQUAD_MARINE, JOB_SQUAD_LEADER, JOB_SQUAD_ENGI, JOB_SQUAD_MEDIC, JOB_SQUAD_SPECIALIST, JOB_SQUAD_SMARTGUN, JOB_SQUAD_RTO)

var/global/list/job_squad_roles = JOB_SQUAD_ROLES_LIST

#define JOB_COLONIST "Colonist"
#define JOB_PASSENGER "Passenger"
#define JOB_SURVIVOR "Survivor"
#define JOB_SYNTH_SURVIVOR "Synth Survivor"
#define JOB_CO_SURVIVOR "CO Survivor"

#define ANY_SURVIVOR "Any Survivor"
#define CIVILIAN_SURVIVOR "Civilian Survivor"
#define SECURITY_SURVIVOR "Security Survivor"
#define SCIENTIST_SURVIVOR "Scientist Survivor"
#define MEDICAL_SURVIVOR "Medical Survivor"
#define ENGINEERING_SURVIVOR "Engineering Survivor"
#define CORPORATE_SURVIVOR "Corporate Survivor"
#define HOSTILE_SURVIVOR "Hostile Survivor" //AKA Marine Killers assuming they survive. Will do cultist survivor at some point.
#define SURVIVOR_VARIANT_LIST list(ANY_SURVIVOR, CIVILIAN_SURVIVOR, SECURITY_SURVIVOR, SCIENTIST_SURVIVOR, MEDICAL_SURVIVOR, ENGINEERING_SURVIVOR, CORPORATE_SURVIVOR, HOSTILE_SURVIVOR)

//-1 is infinite amount, these are soft caps and can be bypassed by randomization
#define MAX_SURVIVOR_PER_TYPE list(ANY_SURVIVOR = -1, CIVILIAN_SURVIVOR = -1, SECURITY_SURVIVOR = 2, SCIENTIST_SURVIVOR = 2, MEDICAL_SURVIVOR = 3, ENGINEERING_SURVIVOR = 4, CORPORATE_SURVIVOR = 2, HOSTILE_SURVIVOR = 1)

#define SPAWN_PRIORITY_VERY_HIGH 1
#define SPAWN_PRIORITY_HIGH 2
#define SPAWN_PRIORITY_MEDIUM 3
#define SPAWN_PRIORITY_LOW 4
#define SPAWN_PRIORITY_VERY_LOW 5
#define LOWEST_SPAWN_PRIORITY 5

#define JOB_CMO "Chief Medical Officer"
#define JOB_DOCTOR "Doctor"
#define JOB_NURSE "Nurse"
#define JOB_RESEARCHER "Researcher"
#define JOB_MEDIC_ROLES  /datum/timelock/medic
#define JOB_MEDIC_ROLES_LIST list(JOB_SQUAD_MEDIC, JOB_CMO, JOB_DOCTOR, JOB_NURSE, JOB_RESEARCHER)

#define JOB_CORPORATE_LIAISON "Corporate Liaison"
#define JOB_COMBAT_REPORTER "Combat Correspondent"
#define JOB_MESS_SERGEANT "Mess Technician"
#define JOB_SYNTH "Synthetic"
#define JOB_WORKING_JOE "Working Joe"

#define JOB_CO "Commanding Officer"
#define JOB_XO "Executive Officer"
#define JOB_SO "Staff Officer"
#define JOB_COMMAND_ROLES /datum/timelock/command
#define JOB_COMMAND_ROLES_LIST   list(JOB_CO, JOB_XO, JOB_SO)
var/global/list/job_command_roles = JOB_COMMAND_ROLES_LIST

#define JOB_PILOT "Pilot Officer"
#define JOB_DROPSHIP_CREW_CHIEF "Dropship Crew Chief"
#define JOB_CREWMAN "Vehicle Crewman"
#define JOB_INTEL "Intelligence Officer"

#define JOB_POLICE "Military Police"
#define JOB_WARDEN "Military Warden"
#define JOB_CHIEF_POLICE "Chief MP"
#define JOB_POLICE_ROLES /datum/timelock/mp
#define JOB_POLICE_ROLES_LIST    list(JOB_POLICE, JOB_WARDEN, JOB_CHIEF_POLICE)

#define JOB_SEA "Senior Enlisted Advisor"

#define JOB_CHIEF_ENGINEER "Chief Engineer"
#define JOB_MAINT_TECH "Maintenance Technician"
#define JOB_ORDNANCE_TECH "Ordnance Technician"
#define JOB_ENGINEER_ROLES   /datum/timelock/engineer
#define JOB_ENGINEER_ROLES_LIST  list(JOB_SQUAD_ENGI, JOB_MAINT_TECH, JOB_ORDNANCE_TECH, JOB_CHIEF_ENGINEER)

#define JOB_CHIEF_REQUISITION "Requisitions Officer"
#define JOB_CARGO_TECH "Cargo Technician"
#define JOB_REQUISITION_ROLES    /datum/timelock/requisition
#define JOB_REQUISITION_ROLES_LIST   list(JOB_CHIEF_REQUISITION, JOB_CARGO_TECH)

#define JOB_MARINE_RAIDER "Marine Raider"
#define JOB_MARINE_RAIDER_SL "Marine Raider Team Lead"
#define JOB_MARINE_RAIDER_CMD "Marine Raider Platoon Lead"
#define JOB_MARINE_RAIDER_ROLES_LIST list(JOB_MARINE_RAIDER, JOB_MARINE_RAIDER_SL, JOB_MARINE_RAIDER_CMD)

#define JOB_HUMAN_ROLES  /datum/timelock/human

#define JOB_XENO_ROLES   /datum/timelock/xeno
#define JOB_DRONE_ROLES /datum/timelock/drone
#define JOB_T3_ROLES /datum/timelock/tier3

#define JOB_STOWAWAY "Stowaway"

#define JOB_MARINE "USCM Marine" //generic marine
#define JOB_COLONEL "USCM Colonel"
#define JOB_GENERAL "USCM General"
#define JOB_ACMC "Assistant Commandant of the Marine Corps"
#define JOB_CMC "Commandant of the Marine Corps"

// Used to add a timelock to a job. Will be passed onto derivatives
#define AddTimelock(Path, timelockList) \
##Path/setup_requirements(list/L){\
	L += timelockList;\
	. = ..(L);\
}

// Used to add a timelock to a job. Will be passed onto derivates. Will not include the parent's timelocks.
#define OverrideTimelock(Path, timelockList) \
##Path/setup_requirements(list/L){\
	L = timelockList;\
	. = ..(L);\
}

//-------------WO roles---------------

#define JOB_WO_CO "Ground Commander"
#define JOB_WO_XO "Lieutenant Commander"
#define JOB_WO_CHIEF_POLICE "Honor Guard Squad Leader"
#define JOB_WO_SO "Veteran Honor Guard"
#define JOB_WO_CREWMAN "Honor Guard Weapons Specialist"
#define JOB_WO_POLICE "Honor Guard"

#define JOB_WO_PILOT "Mortar Crew"

#define JOB_WO_CHIEF_ENGINEER "Bunker Crew Master"
#define JOB_WO_ORDNANCE_TECH "Bunker Crew"

#define JOB_WO_CHIEF_REQUISITION "Quartermaster"
#define JOB_WO_REQUISITION "Bunker Crew Logistics"

#define JOB_WO_CMO "Head Surgeon"
#define JOB_WO_DOCTOR "Field Doctor"
#define JOB_WO_RESEARCHER "Chemist"

#define JOB_WO_CORPORATE_LIAISON "Combat Reporter"
#define JOB_WO_SYNTH "Support Synthetic"

#define JOB_WO_SQUAD_MARINE "Dust Raider Squad Rifleman"
#define JOB_WO_SQUAD_MEDIC "Dust Raider Squad Hospital Corpsman"
#define JOB_WO_SQUAD_ENGINEER "Dust Raider Squad Combat Technician"
#define JOB_WO_SQUAD_SMARTGUNNER "Dust Raider Squad Smartgunner"
#define JOB_WO_SQUAD_SPECIALIST "Dust Raider Squad Weapons Specialist"
#define JOB_WO_SQUAD_LEADER "Dust Raider Squad Leader"

//------------------------------------

//-------- PMC --------//
#define JOB_PMC "PMC Standard"
#define JOB_PMC_ENGINEER "PMC Corporate Technician"
#define JOB_PMC_MEDIC "PMC Corporate Medic"
#define JOB_PMC_DOCTOR "PMC Trauma Surgeon"
#define JOB_PMC_INVESTIGATOR "PMC Medical Investigator"
#define JOB_PMC_ELITE "PMC Elite"
#define JOB_PMC_GUNNER "PMC Support Weapons Specialist" //Renamed from Specialist to Support Specialist as it only has SG skills.
#define JOB_PMC_SNIPER "PMC Weapons Specialist" //Renamed from Sharpshooter to specialist as it uses specialist skills.
#define JOB_PMC_CREWMAN "PMC Crewman"
#define JOB_PMC_NINJA "PMC Ninja"
#define JOB_PMC_XENO_HANDLER "PMC Xeno Handler"
#define JOB_PMC_COMMANDO "PMC Commando"
#define JOB_PMC_LEADER "PMC Leader"
#define JOB_PMC_LEAD_INVEST "PMC Lead Investigator"
#define JOB_PMC_DIRECTOR "PMC Site Director"
#define JOB_PMC_SYNTH    "PMC Support Synthetic"

//-------- WY --------//

#define JOB_TRAINEE "Corporate Trainee"
#define JOB_JUNIOR_EXECUTIVE "Corporate Junior Executive"
#define JOB_EXECUTIVE "Corporate Executive"
#define JOB_SENIOR_EXECUTIVE "Corporate Senior Executive"
#define JOB_EXECUTIVE_SPECIALIST "Corporate Executive Specialist"
#define JOB_EXECUTIVE_SUPERVISOR "Corporate Executive Supervisor"
#define JOB_ASSISTANT_MANAGER "Corporate Assistant Manager"
#define JOB_DIVISION_MANAGER "Corporate Division Manager"
#define JOB_CHIEF_EXECUTIVE "Corporate Chief Executive"
#define JOB_DIRECTOR "W-Y Director"

//-------- WY Goons --------//
#define JOB_WY_GOON "WY Corporate Security"
#define JOB_WY_GOON_LEAD "WY Corporate Security Lead"

//---- Contractors ----//
#define JOB_CONTRACTOR "VAIPO Mercenary"
#define JOB_CONTRACTOR_ST "VAIPO Mercenary"
#define JOB_CONTRACTOR_MEDIC "VAIMS Medical Specialist"
#define JOB_CONTRACTOR_ENGI "VAIPO Engineering Specialist"
#define JOB_CONTRACTOR_MG "VAIPO Automatic Rifleman"
#define JOB_CONTRACTOR_TL "VAIPO Team Leader"
#define JOB_CONTRACTOR_SYN "VAIPO Support Synthetic"
#define JOB_CONTRACTOR_COV "VAISO Mercenary"
#define JOB_CONTRACTOR_COVST "VAISO Mercenary"
#define JOB_CONTRACTOR_COVMED "VAIMS Medical Specialist"
#define JOB_CONTRACTOR_COVENG "VAISO Engineering Specialist"
#define JOB_CONTRACTOR_COVMG "VAISO Automatic Rifleman"
#define JOB_CONTRACTOR_COVTL "VAISO Team Leader"
#define JOB_CONTRACTOR_COVSYN "VAISO Support Synthetic"

//-------- UPP --------//
#define JOB_UPP "UPP Private"
#define JOB_UPP_CONSCRIPT "UPP Conscript"
#define JOB_UPP_ENGI "UPP Korporal Sapper"
#define JOB_UPP_MEDIC "UPP Korporal Medic"
#define JOB_UPP_SPECIALIST "UPP Serzhant"
#define JOB_UPP_LEADER "UPP Master Serzhant"
#define JOB_UPP_POLICE "UPP Politsiya"
#define JOB_UPP_LT_OFFICER "UPP Leytenant"
#define JOB_UPP_LT_DOKTOR "UPP Leytenant Doktor"
#define JOB_UPP_SRLT_OFFICER "UPP Senior Leytenant"
#define JOB_UPP_KPT_OFFICER "UPP Kapitan"
#define JOB_UPP_MAY_OFFICER "UPP Mayjor"
#define JOB_UPP_KOL_OFFICER "UPP Kolonel"

#define JOB_UPP_COMBAT_SYNTH "UPP Combat Synthetic"

#define UPP_JOB_LIST list(JOB_UPP, JOB_UPP_ENGI, JOB_UPP_MEDIC, JOB_UPP_SPECIALIST, JOB_UPP_LEADER, JOB_UPP_POLICE, JOB_UPP_LT_OFFICER, JOB_UPP_LT_DOKTOR, JOB_UPP_SRLT_OFFICER, JOB_UPP_KPT_OFFICER, JOB_UPP_KOL_OFFICER, JOB_UPP_COMBAT_SYNTH)

#define JOB_UPP_COMMANDO "UPP Junior Kommando"
#define JOB_UPP_COMMANDO_MEDIC "UPP 2nd Kommando"
#define JOB_UPP_COMMANDO_LEADER "UPP 1st Kommando"

#define UPP_COMMANDO_JOB_LIST list(JOB_UPP_COMMANDO, JOB_UPP_COMMANDO_MEDIC, JOB_UPP_COMMANDO_LEADER)

#define JOB_UPP_REPRESENTATIVE "UPP Representative"

#define JOB_UPP_CREWMAN "UPP Tank Crewman"

//-------- CLF --------//
#define JOB_CLF "CLF Guerilla"
#define JOB_CLF_ENGI "CLF Field Technician"
#define JOB_CLF_MEDIC "CLF Field Medic"
#define JOB_CLF_SPECIALIST "CLF Field Specialist"
#define JOB_CLF_LEADER "CLF Cell Leader"
#define JOB_CLF_COMMANDER "CLF Cell Commander"
#define JOB_CLF_SYNTH "CLF Multipurpose Synthetic"

#define CLF_JOB_LIST list(JOB_CLF, JOB_CLF_ENGI, JOB_CLF_MEDIC, JOB_CLF_SPECIALIST, JOB_CLF_LEADER, JOB_CLF_COMMANDER, JOB_CLF_SYNTH)

//-------- TWE --------//
#define JOB_TWE_REPRESENTATIVE "TWE Representative"

#define JOB_TWE_YONTO "RMC Yonto"
#define JOB_TWE_SANTO "RMC Santo"
#define JOB_TWE_NITO "RMC Nito"
#define JOB_TWE_ITTO "RMC Itto"

#define TWE_COMMANDO_JOB_LIST list(JOB_TWE_YONTO, JOB_TWE_SANTO, JOB_TWE_NITO, JOB_TWE_ITTO)

#define JOB_TWE_SEAMAN "TWE Seaman"
#define JOB_TWE_LSEAMAN "TWE Leading Seaman"
#define JOB_TWE_SO "TWE Standing Officer"
#define JOB_TWE_WO "TWE Warrant Officer"
#define JOB_TWE_CPT "TWE Captain"
#define JOB_TWE_ADM "TWE Admiral"
#define JOB_TWE_GADM "TWE Grand Admiral"
#define JOB_TWE_ER "TWE Emperor"

#define TWE_OFFICER_JOB_LIST list(JOB_TWE_SEAMAN, JOB_TWE_LSEAMAN, JOB_TWE_SO, JOB_TWE_WO, JOB_TWE_CPT, JOB_TWE_ADM, JOB_TWE_GADM, JOB_TWE_ER)

//-------- PROVOST --------//
#define JOB_PROVOST_ENFORCER "Provost Enforcer"
#define JOB_PROVOST_TML "Provost Team Leader"
#define JOB_PROVOST_ADVISOR "Provost Advisor"
#define JOB_PROVOST_INSPECTOR "Provost Inspector"
#define JOB_PROVOST_MARSHAL "Provost Marshal"
#define JOB_PROVOST_SMARSHAL "Provost Sector Marshal"
#define JOB_PROVOST_CMARSHAL "Provost Chief Marshal"

#define PROVOST_JOB_LIST list(JOB_PROVOST_ENFORCER, JOB_PROVOST_TML, JOB_PROVOST_ADVISOR, JOB_PROVOST_INSPECTOR, JOB_PROVOST_MARSHAL, JOB_PROVOST_SMARSHAL, JOB_PROVOST_CMARSHAL)

#define JOB_RIOT "Riot Control"
#define JOB_RIOT_CHIEF "Chief Riot Control"

//-------- UAAC --------//
#define JOB_TIS_IO "UAAC-TIS Intelligence Officer"
#define JOB_TIS_SA "UAAC-TIS Special Agent"

#define TIS_JOB_LIST list(JOB_TIS_SA, JOB_TIS_IO)

//-------- DUTCH'S DOZEN --------//
#define JOB_DUTCH_ARNOLD "Dutch's Dozen - Dutch"
#define JOB_DUTCH_RIFLEMAN "Dutch's Dozen - Rifleman"
#define JOB_DUTCH_MINIGUNNER "Dutch's Dozen - Minigunner"
#define JOB_DUTCH_FLAMETHROWER "Dutch's Dozen - Flamethrower"
#define JOB_DUTCH_MEDIC "Dutch's Dozen - Medic"

#define DUTCH_JOB_LIST list(JOB_DUTCH_ARNOLD, JOB_DUTCH_RIFLEMAN, JOB_DUTCH_MINIGUNNER, JOB_DUTCH_FLAMETHROWER, JOB_DUTCH_MEDIC)

#define JOB_PREDATOR "Predator"
#define JOB_XENOMORPH    "Xenomorph"
#define JOB_XENOMORPH_QUEEN  "Queen"

// For colouring the ranks in the statistics menu
#define JOB_PLAYTIME_TIER_1  (10 HOURS)
#define JOB_PLAYTIME_TIER_2  (25 HOURS)
#define JOB_PLAYTIME_TIER_3  (70 HOURS)
#define JOB_PLAYTIME_TIER_4  (175 HOURS)

#define XENO_NO_AGE  -1
#define XENO_NORMAL 0
#define XENO_MATURE 1
#define XENO_ELDER 2
#define XENO_ANCIENT 3
#define XENO_PRIME 4

/// For monthly time tracking
#define JOB_OBSERVER "Observer"
#define TIMELOCK_JOB(role_id, hours) new/datum/timelock(role_id, hours, role_id)

//For displaying groups of jobs. Used by new player's latejoin menu and by crew manifest.
#define FLAG_SHOW_CIC 1
#define FLAG_SHOW_AUXIL_SUPPORT 2
#define FLAG_SHOW_MISC 4
#define FLAG_SHOW_POLICE 8
#define FLAG_SHOW_ENGINEERING 16
#define FLAG_SHOW_REQUISITION 32
#define FLAG_SHOW_MEDICAL 64
#define FLAG_SHOW_MARINES 128
#define FLAG_SHOW_ALL_JOBS FLAG_SHOW_CIC|FLAG_SHOW_AUXIL_SUPPORT|FLAG_SHOW_MISC|FLAG_SHOW_POLICE|FLAG_SHOW_ENGINEERING|FLAG_SHOW_REQUISITION|FLAG_SHOW_MEDICAL|FLAG_SHOW_MARINES
