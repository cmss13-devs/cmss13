// Squad name defines
#define SQUAD_NAME_1					"Alpha"
#define SQUAD_NAME_2					"Bravo"
#define SQUAD_NAME_3					"Charlie"
#define SQUAD_NAME_4					"Delta"
#define SQUAD_NAME_5					"Echo"

// Job name defines
#define JOB_SQUAD_MARINE				"Squad Marine"
#define JOB_SQUAD_LEADER				"Squad Leader"
#define JOB_SQUAD_ENGI					"Squad Engineer"
#define JOB_SQUAD_MEDIC					"Squad Medic"
#define JOB_SQUAD_SPECIALIST			"Squad Specialist"
#define JOB_SQUAD_SMARTGUN				"Squad Smartgunner"
#define JOB_SQUAD_ROLES					"Squad Roles"
#define JOB_SQUAD_ROLES_LIST            list(JOB_SQUAD_ROLES, JOB_SQUAD_MARINE, JOB_SQUAD_LEADER, JOB_SQUAD_ENGI, JOB_SQUAD_MEDIC, JOB_SQUAD_SPECIALIST, JOB_SQUAD_SMARTGUN)

var/global/list/job_squad_roles = JOB_SQUAD_ROLES_LIST

#define JOB_COLONIST					"Colonist"
#define JOB_PASSENGER					"Passenger"
#define JOB_SURVIVOR					"Survivor"

#define JOB_CMO							"Chief Medical Officer"
#define JOB_DOCTOR						"Doctor"
#define JOB_NURSE						"Nurse"
#define JOB_RESEARCHER					"Researcher"

#define JOB_CORPORATE_LIAISON			"Corporate Liaison"
#define JOB_MESS_SERGEANT				"Mess Sergeant"
#define JOB_SYNTH						"Synthetic"

#define JOB_CO							"Commanding Officer"
#define JOB_XO							"Executive Officer"
#define JOB_SO							"Staff Officer"
#define JOB_COMMAND_ROLES				"CIC Roles"
#define JOB_COMMAND_ROLES_LIST          list(JOB_COMMAND_ROLES, JOB_CO, JOB_XO, JOB_SO)
var/global/list/job_command_roles = JOB_COMMAND_ROLES_LIST
#define JOB_PILOT						"Pilot Officer"
#define JOB_CREWMAN						"Vehicle Crewman"
#define JOB_INTEL						"Intelligence Officer"
#define JOB_POLICE						"Military Police"
#define JOB_WARDEN						"Military Warden"
#define JOB_CHIEF_POLICE				"Chief MP"
#define JOB_SEA							"Senior Enlisted Advisor"

#define JOB_CHIEF_ENGINEER				"Chief Engineer"
#define JOB_MAINT_TECH					"Maintenance Technician"
#define JOB_ORDNANCE_TECH				"Ordnance Technician"

#define JOB_CHIEF_REQUISITION			"Requisitions Officer"
#define JOB_REQUISITION					"Cargo Technician"

#define JOB_STOWAWAY					"Stowaway"

//-------------WO roles---------------

#define JOB_WO_CO						"Ground Commander"
#define JOB_WO_XO						"Lieutenant Commander"
#define JOB_WO_CHIEF_POLICE				"Honor Guard Squad Leader"
#define JOB_WO_SO						"Veteran Honor Guard"
#define JOB_WO_CREWMAN					"Honor Guard Specialist"
#define JOB_WO_POLICE					"Honor Guard"

#define JOB_WO_PILOT					"Mortar Crew"

#define JOB_WO_CHIEF_ENGINEER			"Bunker Crew Master"
#define JOB_WO_ORDNANCE_TECH			"Bunker Crew"

#define JOB_WO_CHIEF_REQUISITION		"Quartermaster"
#define JOB_WO_REQUISITION				"Bunker Crew Logistics"

#define JOB_WO_CMO						"Head Surgeon"
#define JOB_WO_DOCTOR					"Field Doctor"
#define JOB_WO_RESEARCHER				"Chemist"

#define JOB_WO_CORPORATE_LIAISON		"Combat Reporter"
#define JOB_WO_SYNTH					"Support Synthetic"

//------------------------------------

//-------- PMC --------//
#define JOB_PMC							"PMC Standard"
#define JOB_PMC_ENGINEER				"PMC Mechanic"
#define JOB_PMC_DOCTOR					"PMC Triage"
#define JOB_PMC_INVESTIGATOR			"PMC Medical Investigator"
#define JOB_PMC_ELITE					"PMC Elite"
#define JOB_PMC_GUNNER					"PMC Specialist"
#define JOB_PMC_SNIPER					"PMC Sharpshooter"
#define JOB_PMC_NINJA					"PMC Ninja"
#define JOB_PMC_COMMANDO				"PMC Commando"
#define JOB_PMC_LEADER					"PMC Leader"
#define JOB_PMC_LEAD_INVEST				"PMC Lead Investigator"

//-------- UPP --------//
#define JOB_UPP							"UPP Private"
#define JOB_UPP_ENGI					"UPP Korporal Sapper"
#define JOB_UPP_MEDIC					"UPP Korporal Medic"
#define JOB_UPP_SPECIALIST				"UPP Serzhant"
#define JOB_UPP_LEADER					"UPP Master Serzhant"

#define UPP_JOB_LIST					list(JOB_UPP, JOB_UPP_ENGI, JOB_UPP_MEDIC, JOB_UPP_SPECIALIST, JOB_UPP_LEADER)

#define JOB_UPP_COMMANDO				"UPP Junior Kommando"
#define JOB_UPP_COMMANDO_MEDIC			"UPP 2nd Kommando"
#define JOB_UPP_COMMANDO_LEADER			"UPP 1st Kommando"

#define UPP_COMMANDO_JOB_LIST			list(JOB_UPP_COMMANDO, JOB_UPP_COMMANDO_MEDIC, JOB_UPP_COMMANDO_LEADER)

#define JOB_UPP_REPRESENTATIVE			"UPP Representative"

//-------- CLF --------//
#define JOB_CLF							"CLF Guerilla"
#define JOB_CLF_ENGI					"CLF Field Technician"
#define JOB_CLF_MEDIC					"CLF Field Medic"
#define JOB_CLF_SPECIALIST				"CLF Field Specialist"
#define JOB_CLF_LEADER					"CLF Cell Leader"

#define CLF_JOB_LIST					list(JOB_CLF, JOB_CLF_ENGI, JOB_CLF_MEDIC, JOB_CLF_SPECIALIST, JOB_CLF_LEADER)

//-------- RESS --------//

#define JOB_RESS_REPRESENTATIVE			"RESS Representative"

//antag jobs supported by adaptive antag vendors
#define VENDOR_ANTAG_JOBS				list(JOB_UPP, JOB_UPP_ENGI, JOB_UPP_MEDIC, JOB_UPP_SPECIALIST, JOB_UPP_LEADER, JOB_CLF, JOB_CLF_ENGI, JOB_CLF_MEDIC, JOB_CLF_SPECIALIST, JOB_CLF_LEADER)

#define JOB_PREDATOR                    "Predator"
#define JOB_XENOMORPH                   "Xenomorph"

// For colouring the ranks in the statistics menu
#define JOB_PLAYTIME_TIER_1         (10 HOURS)
#define JOB_PLAYTIME_TIER_2         (25 HOURS)
#define JOB_PLAYTIME_TIER_3         (70 HOURS)
#define JOB_PLAYTIME_TIER_4         (175 HOURS)

#define XENO_NO_AGE     -1
#define XENO_NORMAL		0
#define XENO_MATURE		1
#define XENO_ELDER		2
#define XENO_ANCIENT	3
#define XENO_PRIME	4