//=================================================
//Self destruct, nuke, and evacuation.
#define EVACUATION_TIME_LOCK 			HOURS_1
#define DISTRESS_TIME_LOCK 				MINUTES_6
#define SHUTTLE_TIME_LOCK 				MINUTES_15
#define SHUTTLE_LOCK_COOLDOWN 			MINUTES_10
#define MONORAIL_LOCK_COOLDOWN			MINUTES_3
#define SHUTTLE_LOCK_TIME_LOCK 			MINUTES_1
#define EVACUATION_AUTOMATIC_DEPARTURE 	MINUTES_10 //All pods automatically depart in 10 minutes, unless they are full or unable to launch for some reason.
#define EVACUATION_ESTIMATE_DEPARTURE 	((evac_time + EVACUATION_AUTOMATIC_DEPARTURE - world.time) * 0.1)

#define EVACUATION_STATUS_STANDING_BY 0
#define EVACUATION_STATUS_INITIATING 1
#define EVACUATION_STATUS_IN_PROGRESS 2
#define EVACUATION_STATUS_COMPLETE 3

#define NUKE_EXPLOSION_INACTIVE 0
#define NUKE_EXPLOSION_ACTIVE	1
#define NUKE_EXPLOSION_IN_PROGRESS 2
#define NUKE_EXPLOSION_FINISHED 4
#define NUKE_EXPLOSION_GROUND_FINISHED 8

#define FLAGS_EVACUATION_DENY 1
#define FLAGS_SELF_DESTRUCT_DENY 2

#define XENO_ROUNDSTART_PROGRESS_AMOUNT 			4
#define XENO_ROUNDSTART_PROGRESS_TIME_1 			0
#define XENO_ROUNDSTART_PROGRESS_TIME_2 			MINUTES_10
//=================================================


#define IS_MODE_COMPILED(MODE) (ispath(text2path("/datum/game_mode/"+(MODE))))

#define MODE_INFESTATION		1
#define MODE_PREDATOR			2
#define MODE_NO_LATEJOIN		4
#define MODE_HAS_FINISHED		8
#define MODE_FOG_ACTIVATED 		16
#define MODE_INFECTION			32
#define MODE_HUMAN_ANTAGS		64

#define ROUNDSTATUS_FOG_DOWN 		1
#define ROUNDSTATUS_PODDOORS_OPEN	2

#define LATEJOIN_MARINES_PER_LATEJOIN_LARVA 4

#define BE_ALIEN				1
#define BE_ALIEN_AFTER_DEATH	2
#define BE_QUEEN				4
#define BE_SURVIVOR				8
#define BE_SYNTH_SURVIVOR		16
#define BE_PREDATOR				32

#define TOGGLE_IGNORE_SELF					1 	// Determines whether you will not hurt yourself when clicking yourself
#define TOGGLE_HELP_INTENT_SAFETY			2 	// Determines whether help intent will be completely harmless
#define TOGGLE_MIDDLE_MOUSE_CLICK			4 	// This toggles whether selected ability for xeno uses middle mouse clicking or shift clicking
#define TOGGLE_DIRECTIONAL_ATTACK			8 	// This toggles whether attacks for xeno use directional attacks
#define TOGGLE_AUTO_EJECT_MAGAZINE_OFF		16 	// This toggles whether guns with auto ejectors will not auto eject their magazines
												// MUTUALLY EXCLUSIVE TO TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND
#define TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND	32	// This toggles whether guns with auto ejectors will cause you to unwield your gun and put the empty magazine in your hand
												// MUTUALLY EXCLUSIVE TO TOGGLE_AUTO_EJECT_MAGAZINE
#define TOGGLE_EJECT_MAGAZINE_TO_HAND		64	// This toggles whether manuallyejecting magazines from guns will cause you to unwield your gun 
												// and put the empty magazine in your hand

//=================================================

var/list/be_special_flags = list(
	"Xenomorph" = BE_ALIEN,
	"Xenomorph after unrevivable death" = BE_ALIEN_AFTER_DEATH,
	"Survivor" = BE_SURVIVOR,
	"Synth Survivor" = BE_SYNTH_SURVIVOR,
	"Predator" = BE_PREDATOR,
	"Queen" = BE_QUEEN,
)

#define AGE_MIN 19			//youngest a character can be
#define AGE_MAX 160			//oldest a character can be
//Number of marine players against which the Marine's gear scales
#define MARINE_GEAR_SCALING_NORMAL 30
#define MAX_GEAR_COST 7 //Used in chargen for loadout limit.

#define RESOURCE_NODE_SCALE 95 //How many players minimum per extra set of resource nodes
#define RESOURCE_NODE_QUANTITY_PER_POP 11 //How many resources total per pop
#define RESOURCE_NODE_QUANTITY_MINIMUM 1120 //How many resources at the minimum

//=================================================

//Various roles and their suggested bitflags or defines.

#define ROLEGROUP_MARINE_COMMAND		1

#define ROLE_COMMANDING_OFFICER			1
#define ROLE_EXECUTIVE_OFFICER			2
#define ROLE_BRIDGE_OFFICER				4
#define ROLE_MILITARY_POLICE			8
#define ROLE_CORPORATE_LIAISON			16
#define ROLE_REQUISITION_OFFICER		32
#define ROLE_PILOT_OFFICER				64
#define ROLE_CHIEF_MP					128
#define ROLE_SYNTHETIC					256
#define ROLE_CREWMAN					512
#define ROLE_INTEL_OFFICER				1024
#define ROLE_SEA						2048
//=================================================

#define ROLEGROUP_MARINE_ENGINEERING 	2

#define ROLE_CHIEF_ENGINEER				1
#define ROLE_ORDNANCE_TECH			2
#define ROLE_REQUISITION_TECH			4
//=================================================

#define ROLEGROUP_MARINE_MED_SCIENCE 	4

#define ROLE_CHIEF_MEDICAL_OFFICER		1
#define ROLE_CIVILIAN_DOCTOR			2
#define ROLE_CIVILIAN_RESEARCHER		4
//=================================================

#define ROLEGROUP_MARINE_SQUAD_MARINES 	8

#define ROLE_MARINE_LEADER			1
#define ROLE_MARINE_MEDIC			2
#define ROLE_MARINE_ENGINEER		4
#define ROLE_MARINE_STANDARD		8
#define ROLE_MARINE_SPECIALIST		16
#define ROLE_MARINE_SMARTGUN		32
//=================================================

#define ROLE_ADMIN_NOTIFY			1
#define ROLE_ADD_TO_SQUAD			2
#define ROLE_ADD_TO_DEFAULT			4
#define ROLE_ADD_TO_MODE			8
#define ROLE_WHITELISTED			16
//=================================================

//Role defines, specifically lists of roles for job bans and the like.
var/global/list/ROLES_COMMAND 		= list(JOB_CO, JOB_XO, JOB_SO, JOB_INTEL, JOB_PILOT, JOB_CREWMAN, JOB_POLICE, JOB_CORPORATE_LIAISON, JOB_CHIEF_REQUISITION, JOB_CHIEF_ENGINEER, JOB_CMO, JOB_CHIEF_POLICE, JOB_SEA, JOB_SYNTH)
var/global/list/ROLES_OFFICERS		= list(JOB_CO, JOB_XO, JOB_SO, JOB_INTEL, JOB_PILOT, JOB_CREWMAN, JOB_SEA, JOB_CORPORATE_LIAISON, JOB_SYNTH, JOB_CHIEF_POLICE, JOB_POLICE)
var/global/list/ROLES_CIC			= list(JOB_CO, JOB_XO, JOB_SO)
var/global/list/ROLES_AUXIL_SUPPORT	= list(JOB_INTEL, JOB_PILOT, JOB_CREWMAN)
var/global/list/ROLES_MISC			= list(JOB_SEA, JOB_CORPORATE_LIAISON, JOB_SYNTH)
var/global/list/ROLES_POLICE		= list(JOB_CHIEF_POLICE, JOB_POLICE)
var/global/list/ROLES_ENGINEERING 	= list(JOB_CHIEF_ENGINEER, JOB_ORDNANCE_TECH)
var/global/list/ROLES_REQUISITION 	= list(JOB_CHIEF_REQUISITION, JOB_REQUISITION)
var/global/list/ROLES_MEDICAL 	  	= list(JOB_CMO, JOB_DOCTOR, JOB_RESEARCHER)
var/global/list/ROLES_MARINES	  	= list(JOB_SQUAD_LEADER, JOB_SQUAD_SPECIALIST, JOB_SQUAD_SMARTGUN, JOB_SQUAD_MEDIC, JOB_SQUAD_ENGI, JOB_SQUAD_MARINE)
var/global/list/ROLES_SQUAD_ALL	  	= list(SQUAD_NAME_1, SQUAD_NAME_2, SQUAD_NAME_3, SQUAD_NAME_4)
var/global/list/ROLES_REGULAR_ALL 	= ROLES_OFFICERS + ROLES_ENGINEERING + ROLES_REQUISITION + ROLES_MEDICAL + ROLES_MARINES
var/global/list/ROLES_UNASSIGNED  	= list(JOB_SQUAD_MARINE)
//=================================================

//=================================================
#define WHITELIST_YAUTJA_UNBLOODED	1
#define WHITELIST_YAUTJA_BLOODED	2
#define WHITELIST_YAUTJA_ELITE		4
#define WHITELIST_YAUTJA_ELDER		8
#define WHITELIST_YAUTJA_COUNCIL	16
#define WHITELIST_PREDATOR			(WHITELIST_YAUTJA_UNBLOODED|WHITELIST_YAUTJA_BLOODED|WHITELIST_YAUTJA_ELITE|WHITELIST_YAUTJA_ELDER|WHITELIST_YAUTJA_COUNCIL)
#define WHITELIST_COMMANDER			32
#define WHITELIST_COMMANDER_COUNCIL	64
#define WHITELIST_SYNTHETIC			128
#define WHITELIST_SYNTHETIC_COUNCIL	256
#define WHITELIST_ARCTURIAN			512
#define WHITELIST_MENTOR			1024
#define WHITELIST_ALL				(WHITELIST_YAUTJA_UNBLOODED|WHITELIST_YAUTJA_BLOODED|WHITELIST_YAUTJA_ELITE|WHITELIST_YAUTJA_ELDER|WHITELIST_COMMANDER|WHITELIST_SYNTHETIC|WHITELIST_ARCTURIAN|WHITELIST_MENTOR)
//=================================================

// Objective priorities
#define OBJECTIVE_NO_VALUE 0
#define OBJECTIVE_LOW_VALUE 10
#define OBJECTIVE_MEDIUM_VALUE 20
#define OBJECTIVE_HIGH_VALUE 30
#define OBJECTIVE_EXTREME_VALUE 50
#define OBJECTIVE_ABSOLUTE_VALUE 100
//=================================================

// Required prereqs
#define PREREQUISITES_NONE 0
#define PREREQUISITES_ONE 1
#define PREREQUISITES_QUARTER 2
#define PREREQUISITES_MAJORITY 3
#define PREREQUISITES_ALL 4

// Functionality flags
#define OBJ_PREREQS_CANT_FAIL 1
#define OBJ_DO_NOT_TREE 2
#define OBJ_REQUIRES_POWER 4
#define OBJ_REQUIRES_COMMS 8
#define OBJ_DEAD_END 16
#define OBJ_PROCESS_ON_DEMAND 32
#define OBJ_CRITICAL 64 // does failing this constitute a loss?
#define OBJ_CAN_BE_UNCOMPLETED 128
#define OBJ_FAILABLE 256

// Display flags
#define OBJ_DISPLAY_AT_END 1 // show it on the round end screen
#define OBJ_DISPLAY_WHEN_INACTIVE 2
#define OBJ_DISPLAY_WHEN_COMPLETE 4
#define OBJ_DISPLAY_HIDDEN 8

// Faction names
#define FACTION_NEUTRAL "Neutral"
#define FACTION_MARINE "USCM"
#define FACTION_SURVIVOR "Survivor"
#define FACTION_UPP "UPP"
#define FACTION_CLF "CLF"
#define FACTION_PMC "PMC"
#define FACTION_DEATHSQUAD "Death Squad"
#define FACTION_MERCENARY "Mercenary"
#define FACTION_FREELANCER "Freelancer"
#define FACTION_HEFA "HEFA Order"
#define FACTION_DUTCH "Dutch's Dozen"
#define FACTION_PIRATE "Pirate"
#define FACTION_GLADIATOR "Gladiator"
#define FACTION_PIZZA "Pizza Delivery"
#define FACTION_SOUTO "Souto Man"
#define FACTION_COLONIST "Colonist"
#define FACTION_YAUTJA "Yautja"
#define FACTION_ZOMBIE "Zombie"

#define FACTION_LIST_HUMANOID list(FACTION_MARINE, FACTION_PMC, FACTION_DEATHSQUAD, FACTION_CLF, FACTION_UPP, FACTION_FREELANCER, FACTION_SURVIVOR, FACTION_NEUTRAL, FACTION_COLONIST, FACTION_MERCENARY, FACTION_DUTCH, FACTION_HEFA, FACTION_GLADIATOR, FACTION_PIRATE, FACTION_PIZZA, FACTION_SOUTO, FACTION_YAUTJA, FACTION_ZOMBIE)
#define FACTION_LIST_ERT list(FACTION_PMC, FACTION_DEATHSQUAD, FACTION_CLF, FACTION_UPP, FACTION_FREELANCER, FACTION_MERCENARY, FACTION_DUTCH, FACTION_HEFA, FACTION_GLADIATOR, FACTION_PIRATE, FACTION_PIZZA, FACTION_SOUTO)

// Xenomorphs
#define FACTION_PREDALIEN "Predalien"

#define FACTION_XENOMORPH "Xenomorph"
#define FACTION_XENOMORPH_CORRPUTED "Corrupted Xenomoprh"
#define FACTION_XENOMORPH_ALPHA "Alpha Xenomorph"
#define FACTION_XENOMORPH_BETA "Beta Xenomorph"
#define FACTION_XENOMORPH_ZETA "Zeta Xenomorph"

#define FACTION_LIST_XENOMORPH list(FACTION_XENOMORPH, FACTION_XENOMORPH_CORRPUTED, FACTION_XENOMORPH_ALPHA, FACTION_XENOMORPH_BETA, FACTION_XENOMORPH_ZETA)

// ERT Proportions

#define ERT_PMC_GUNNER_FRACTION 0.5 //50% gunners, 50% snipers among PMCs