//=================================================
//Self-destruct, nuke, and evacuation.
#define EVACUATION_TIME_LOCK 1 HOURS
#define DISTRESS_TIME_LOCK 6 MINUTES
#define SHUTTLE_TIME_LOCK 15 MINUTES
#define SHUTTLE_LOCK_COOLDOWN 10 MINUTES
#define MONORAIL_LOCK_COOLDOWN 3 MINUTES
#define SHUTTLE_LOCK_TIME_LOCK 1 MINUTES
#define EVACUATION_AUTOMATIC_DEPARTURE 10 MINUTES //All pods automatically depart in 10 minutes, unless they are full or unable to launch for some reason.
#define EVACUATION_ESTIMATE_DEPARTURE ((evac_time + EVACUATION_AUTOMATIC_DEPARTURE - world.time) * 0.1)

#define EVACUATION_STATUS_STANDING_BY 0
#define EVACUATION_STATUS_INITIATING 1
#define EVACUATION_STATUS_IN_PROGRESS 2
#define EVACUATION_STATUS_COMPLETE 3

#define NUKE_EXPLOSION_INACTIVE 0
#define NUKE_EXPLOSION_ACTIVE 1
#define NUKE_EXPLOSION_IN_PROGRESS 2
#define NUKE_EXPLOSION_FINISHED 4
#define NUKE_EXPLOSION_GROUND_FINISHED 8

#define FLAGS_EVACUATION_DENY 1
#define FLAGS_SELF_DESTRUCT_DENY 2

#define LIFEBOAT_LOCKED -1
#define LIFEBOAT_INACTIVE 0
#define LIFEBOAT_ACTIVE 1

#define XENO_ROUNDSTART_PROGRESS_AMOUNT 			2
#define XENO_ROUNDSTART_PROGRESS_TIME_1 			0
#define XENO_ROUNDSTART_PROGRESS_TIME_2 			15 MINUTES

#define ROUND_TIME (world.time - SSticker.round_start_time)

//=================================================


#define IS_MODE_COMPILED(MODE) (ispath(text2path("/datum/game_mode/"+(MODE))))

#define MODE_HAS_FLAG(flag) (SSticker.mode.flags_round_type & flag)
#define MODE_HAS_TOGGLEABLE_FLAG(flag) (SSticker.mode.toggleable_flags & flag)

// Gamemode Flags
#define MODE_INFESTATION (1<<0)
#define MODE_PREDATOR (1<<1)
#define MODE_NO_LATEJOIN (1<<2)
#define MODE_HAS_FINISHED (1<<3)
#define MODE_FOG_ACTIVATED (1<<4)
#define MODE_INFECTION (1<<5)
#define MODE_HUMAN_ANTAGS (1<<6)
#define MODE_NO_SPAWN (1<<7) // Disables marines from spawning in normally
#define MODE_XVX (1<<8) // Affects several castes for XvX, as well as other things (e.g. spawnpool)
#define MODE_NEW_SPAWN (1<<9) // Enables the new spawning, only works for Distress currently
#define MODE_DS_LANDED (1<<10)
#define MODE_BASIC_RT (1<<11)
#define MODE_RANDOM_HIVE (1<<12)// Makes Join-as-Xeno choose a hive to join as burrowed larva at random rather than at user's input..
#define MODE_THUNDERSTORM (1<<13)// Enables thunderstorm effects on maps that are compatible with it. (Lit exterior tiles, rain effects)
#define MODE_FACTION_CLASH (1<<14)// Disables scopes, sniper sentries, OBs, shooting corpses, dragging enemy corpses, stripping enemy corpses

// Gamemode Toggleable Flags
#define MODE_NO_SNIPER_SENTRY (1<<0) /// Upgrade kits will no longer allow you to select long-range upgrades
#define MODE_NO_ATTACK_DEAD (1<<1) /// People will not be able to shoot at corpses
#define MODE_NO_STRIPDRAG_ENEMY (1<<2) /// Can't strip or drag dead enemies
#define MODE_STRIP_NONUNIFORM_ENEMY (1<<3) /// Can strip enemy, but not their boots, uniform, armor, helmet, or ID
#define MODE_STRONG_DEFIBS (1<<4) /// Defibs Ignore Armor
#define MODE_BLOOD_OPTIMIZATION (1<<5) /// Blood spawns without a dry timer, and do not cause footprints
#define MODE_NO_COMBAT_CAS (1<<6) /// Prevents POs and DCCs from creating combat CAS equipment
#define MODE_LZ_PROTECTION (1<<7) /// Prevents the LZ from being mortared
#define MODE_SHIPSIDE_SD (1<<8) /// Toggles whether Predators can big SD when not on the groundmap

#define ROUNDSTATUS_FOG_DOWN 1
#define ROUNDSTATUS_PODDOORS_OPEN 2

#define LATEJOIN_MARINES_PER_LATEJOIN_LARVA 3

#define BE_ALIEN_AFTER_DEATH 1
#define BE_AGENT 2

#define TOGGLE_IGNORE_SELF (1<<0) // Determines whether you will not hurt yourself when clicking yourself
#define TOGGLE_HELP_INTENT_SAFETY (1<<1) // Determines whether help intent will be completely harmless
#define TOGGLE_MIDDLE_MOUSE_CLICK (1<<2) // This toggles whether selected ability for xeno uses middle mouse clicking or shift clicking
#define TOGGLE_DIRECTIONAL_ATTACK (1<<3) // This toggles whether attacks for xeno use directional attacks
#define TOGGLE_AUTO_EJECT_MAGAZINE_OFF (1<<4) // This toggles whether guns with auto ejectors will not auto eject their magazines
												   // MUTUALLY EXCLUSIVE TO TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND
#define TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND (1<<5) // This toggles whether guns with auto ejectors will cause you to unwield your gun and put the empty magazine in your hand
												   // MUTUALLY EXCLUSIVE TO TOGGLE_AUTO_EJECT_MAGAZINE
#define TOGGLE_EJECT_MAGAZINE_TO_HAND (1<<6) // This toggles whether manuallyejecting magazines from guns will cause you to unwield your gun
												   // and put the empty magazine in your hand
#define TOGGLE_AUTOMATIC_PUNCTUATION (1<<7) // Whether your sentences will automatically be punctuated with a period
#define TOGGLE_COMBAT_CLICKDRAG_OVERRIDE (1<<8) // Whether disarm/harm intents cause clicks to trigger immediately when the mouse button is depressed.
#define TOGGLE_ALTERNATING_DUAL_WIELD (1<<9) // Whether dual-wielding fires both guns at once or swaps between them.
#define TOGGLE_FULLSCREEN (1<<10) // See /client/proc/toggle_fullscreen in client_procs.dm
#define TOGGLE_MEMBER_PUBLIC (1<<11) //determines if you get a byond logo by your name in ooc if you're a member or not
#define TOGGLE_OOC_FLAG (1<<12) // determines if your country flag appears by your name in ooc chat
#define TOGGLE_MIDDLE_MOUSE_SWAP_HANDS (1<<13) //Toggle whether middle click swaps your hands
#define TOGGLE_AMBIENT_OCCLUSION (1<<14) // toggles if ambient occlusion is turned on or off
#define TOGGLE_VEND_ITEM_TO_HAND (1<<15) // This toggles whether items from vendors will be automatically put into your hand.

//=================================================
#define SHOW_ITEM_ANIMATIONS_NONE 0 //Do not show any item pickup animations
#define SHOW_ITEM_ANIMATIONS_HALF 1 //Toggles tg-style item animations on and off, default on.
#define SHOW_ITEM_ANIMATIONS_ALL 2 //Toggles being able to see animations that occur on the same tile.
//=================================================

//=================================================
#define PAIN_OVERLAY_BLURRY 0 //Blurs your screen a varying amount depending on eye_blur.
#define PAIN_OVERLAY_IMPAIR 1 //Impairs your screen like a welding helmet does depending on eye_blur.
#define PAIN_OVERLAY_LEGACY 2 //Creates a legacy blurring effect over your screen if you have any eye_blur at all. Not recommended.
//=================================================


var/list/be_special_flags = list(
	"Xenomorph after unrevivable death" = BE_ALIEN_AFTER_DEATH,
	"Agent" = BE_AGENT,
)

#define AGE_MIN 19 //youngest a character can be
#define AGE_MAX 90 //oldest a character can be //no. you are not allowed to be 160.
//Number of marine players against which the Marine's gear scales
#define MARINE_GEAR_SCALING_NORMAL 30
#define MAX_GEAR_COST 7 //Used in chargen for loadout limit.

#define RESOURCE_NODE_SCALE 95 //How many players minimum per extra set of resource nodes
#define RESOURCE_NODE_QUANTITY_PER_POP 11 //How many resources total per pop
#define RESOURCE_NODE_QUANTITY_MINIMUM 1120 //How many resources at the minimum

//=================================================

#define ROLE_ADMIN_NOTIFY 1
#define ROLE_ADD_TO_SQUAD 2
#define ROLE_ADD_TO_DEFAULT 4
#define ROLE_WHITELISTED 16
#define ROLE_NO_ACCOUNT 32
#define ROLE_CUSTOM_SPAWN 64
//=================================================

//Role defines, specifically lists of roles for job bans, crew manifests and the like.
var/global/list/ROLES_COMMAND = list(JOB_CO, JOB_XO, JOB_SO, JOB_INTEL, JOB_PILOT, JOB_DROPSHIP_CREW_CHIEF, JOB_CREWMAN, JOB_POLICE, JOB_CORPORATE_LIAISON, JOB_COMBAT_REPORTER, JOB_CHIEF_REQUISITION, JOB_CHIEF_ENGINEER, JOB_CMO, JOB_CHIEF_POLICE, JOB_SEA, JOB_SYNTH, JOB_WARDEN)

#define ROLES_OFFICERS list(JOB_CO, JOB_XO, JOB_SO, JOB_INTEL, JOB_PILOT, JOB_DROPSHIP_CREW_CHIEF, JOB_SEA, JOB_CORPORATE_LIAISON, JOB_COMBAT_REPORTER, JOB_SYNTH, JOB_CHIEF_POLICE, JOB_WARDEN, JOB_POLICE)
var/global/list/ROLES_CIC = list(JOB_CO, JOB_XO, JOB_SO, JOB_WO_CO, JOB_WO_XO)
var/global/list/ROLES_AUXIL_SUPPORT = list(JOB_INTEL, JOB_PILOT, JOB_DROPSHIP_CREW_CHIEF, JOB_WO_CHIEF_POLICE, JOB_WO_SO, JOB_WO_CREWMAN, JOB_WO_POLICE, JOB_WO_PILOT)
var/global/list/ROLES_MISC = list(JOB_SYNTH, JOB_WORKING_JOE, JOB_SEA, JOB_CORPORATE_LIAISON, JOB_COMBAT_REPORTER, JOB_MESS_SERGEANT, JOB_WO_CORPORATE_LIAISON, JOB_WO_SYNTH)
var/global/list/ROLES_POLICE = list(JOB_CHIEF_POLICE, JOB_WARDEN, JOB_POLICE)
var/global/list/ROLES_ENGINEERING = list(JOB_CHIEF_ENGINEER, JOB_ORDNANCE_TECH, JOB_MAINT_TECH, JOB_WO_CHIEF_ENGINEER, JOB_WO_ORDNANCE_TECH)
var/global/list/ROLES_REQUISITION = list(JOB_CHIEF_REQUISITION, JOB_CARGO_TECH, JOB_WO_CHIEF_REQUISITION, JOB_WO_REQUISITION)
var/global/list/ROLES_MEDICAL = list(JOB_CMO, JOB_RESEARCHER, JOB_DOCTOR, JOB_NURSE, JOB_WO_CMO, JOB_WO_RESEARCHER, JOB_WO_DOCTOR)
var/global/list/ROLES_MARINES = list(JOB_SQUAD_LEADER, JOB_SQUAD_RTO, JOB_SQUAD_SPECIALIST, JOB_SQUAD_SMARTGUN, JOB_SQUAD_MEDIC, JOB_SQUAD_ENGI, JOB_SQUAD_MARINE)
var/global/list/ROLES_SQUAD_ALL = list(SQUAD_MARINE_1, SQUAD_MARINE_2, SQUAD_MARINE_3, SQUAD_MARINE_4, SQUAD_MARINE_5, SQUAD_MARINE_CRYO)

var/global/list/ROLES_XENO = list(JOB_XENOMORPH_QUEEN, JOB_XENOMORPH)
var/global/list/ROLES_WHITELISTED = list(JOB_SYNTH_SURVIVOR, JOB_CO_SURVIVOR, JOB_PREDATOR)
var/global/list/ROLES_SPECIAL = list(JOB_SURVIVOR)

var/global/list/ROLES_REGULAR_ALL = ROLES_CIC + ROLES_POLICE + ROLES_AUXIL_SUPPORT + ROLES_MISC + ROLES_ENGINEERING + ROLES_REQUISITION + ROLES_MEDICAL + ROLES_MARINES + ROLES_SPECIAL + ROLES_WHITELISTED + ROLES_XENO - ROLES_WO
var/global/list/ROLES_FACTION_CLASH = ROLES_REGULAR_ALL - ROLES_XENO - ROLES_SPECIAL - ROLES_WHITELISTED + JOB_PREDATOR

var/global/list/ROLES_UNASSIGNED = list(JOB_SQUAD_MARINE)
var/global/list/ROLES_WO = list(JOB_WO_CO, JOB_WO_XO, JOB_WO_CORPORATE_LIAISON, JOB_WO_SYNTH, JOB_WO_CHIEF_POLICE, JOB_WO_SO, JOB_WO_CREWMAN, JOB_WO_POLICE, JOB_WO_PILOT, JOB_WO_CHIEF_ENGINEER, JOB_WO_ORDNANCE_TECH, JOB_WO_CHIEF_REQUISITION, JOB_WO_REQUISITION, JOB_WO_CMO, JOB_WO_DOCTOR, JOB_WO_RESEARCHER, JOB_WO_SQUAD_MARINE, JOB_WO_SQUAD_MEDIC, JOB_WO_SQUAD_ENGINEER, JOB_WO_SQUAD_SMARTGUNNER, JOB_WO_SQUAD_SPECIALIST, JOB_WO_SQUAD_LEADER)
//Role lists used for switch() checks in show_blurb_uscm(). Cosmetic, determines ex. "Engineering, USS Almayer", "2nd Bat. 'Falling Falcons'" etc.
#define BLURB_USCM_COMBAT JOB_CO, JOB_XO, JOB_SO, JOB_WO_CO, JOB_WO_XO, JOB_WO_CHIEF_POLICE, JOB_WO_SO, JOB_WO_CREWMAN, JOB_WO_POLICE, JOB_SEA,\
						JOB_SQUAD_LEADER, JOB_SQUAD_RTO, JOB_SQUAD_SPECIALIST, JOB_SQUAD_SMARTGUN, JOB_SQUAD_MEDIC, JOB_SQUAD_ENGI, JOB_SQUAD_MARINE
#define BLURB_USCM_FLIGHT JOB_PILOT, JOB_DROPSHIP_CREW_CHIEF
#define BLURB_USCM_MP JOB_CHIEF_POLICE, JOB_WARDEN, JOB_POLICE
#define BLURB_USCM_ENGI JOB_CHIEF_ENGINEER, JOB_ORDNANCE_TECH, JOB_MAINT_TECH, JOB_WO_CHIEF_ENGINEER, JOB_WO_ORDNANCE_TECH, JOB_WO_PILOT
#define BLURB_USCM_MEDICAL JOB_CMO, JOB_RESEARCHER, JOB_DOCTOR, JOB_NURSE, JOB_WO_CMO, JOB_WO_RESEARCHER, JOB_WO_DOCTOR
#define BLURB_USCM_REQ JOB_CHIEF_REQUISITION, JOB_CARGO_TECH, JOB_WO_CHIEF_REQUISITION, JOB_WO_REQUISITION
#define BLURB_USCM_WY JOB_CORPORATE_LIAISON

//=================================================

#define WHITELIST_NORMAL "Normal"
#define WHITELIST_COUNCIL "Council"
#define WHITELIST_LEADER "Leader"

var/global/list/whitelist_hierarchy = list(WHITELIST_NORMAL, WHITELIST_COUNCIL, WHITELIST_LEADER)

//=================================================
#define WHITELIST_YAUTJA (1<<0)
///Old holders of YAUTJA_ELDER
#define WHITELIST_YAUTJA_LEGACY (1<<1)
#define WHITELIST_YAUTJA_COUNCIL (1<<2)
///Old holders of YAUTJA_COUNCIL for 3 months
#define WHITELIST_YAUTJA_COUNCIL_LEGACY (1<<3)
#define WHITELIST_YAUTJA_LEADER (1<<4)
#define WHITELIST_PREDATOR (WHITELIST_YAUTJA|WHITELIST_YAUTJA_LEGACY|WHITELIST_YAUTJA_COUNCIL|WHITELIST_YAUTJA_COUNCIL_LEGACY|WHITELIST_YAUTJA_LEADER)

#define WHITELIST_COMMANDER (1<<5)
#define WHITELIST_COMMANDER_COUNCIL (1<<6)
///Old holders of COMMANDER_COUNCIL for 3 months
#define WHITELIST_COMMANDER_COUNCIL_LEGACY (1<<7)
#define WHITELIST_COMMANDER_LEADER (1<<8)

#define WHITELIST_JOE (1<<9)
#define WHITELIST_SYNTHETIC (1<<10)
#define WHITELIST_SYNTHETIC_COUNCIL (1<<11)
///Old holders of SYNTHETIC_COUNCIL for 3 months
#define WHITELIST_SYNTHETIC_COUNCIL_LEGACY (1<<12)
#define WHITELIST_SYNTHETIC_LEADER (1<<13)

#define WHITELIST_MENTOR (1<<14)
#define WHITELISTS_GENERAL (WHITELIST_YAUTJA|WHITELIST_COMMANDER|WHITELIST_SYNTHETIC|WHITELIST_MENTOR|WHITELIST_JOE)
#define WHITELISTS_COUNCIL (WHITELIST_YAUTJA_COUNCIL|WHITELIST_COMMANDER_COUNCIL|WHITELIST_SYNTHETIC_COUNCIL)
#define WHITELISTS_LEGACY_COUNCIL (WHITELIST_YAUTJA_COUNCIL_LEGACY|WHITELIST_COMMANDER_COUNCIL_LEGACY|WHITELIST_SYNTHETIC_COUNCIL_LEGACY)
#define WHITELISTS_LEADER (WHITELIST_YAUTJA_LEADER|WHITELIST_COMMANDER_LEADER|WHITELIST_SYNTHETIC_LEADER)

#define WHITELIST_EVERYTHING (WHITELISTS_GENERAL|WHITELISTS_COUNCIL|WHITELISTS_LEADER)

#define isCouncil(A) (RoleAuthority.roles_whitelist[A.ckey] & (WHITELIST_YAUTJA_COUNCIL | WHITELIST_SYNTHETIC_COUNCIL | WHITELIST_COMMANDER_COUNCIL))

//=================================================

// Objective priorities
#define OBJECTIVE_NO_VALUE 0
#define OBJECTIVE_LOW_VALUE 0.1
#define OBJECTIVE_MEDIUM_VALUE 0.2
#define OBJECTIVE_HIGH_VALUE 0.35
#define OBJECTIVE_EXTREME_VALUE 0.7
#define OBJECTIVE_ABSOLUTE_VALUE 1.4
#define OBJECTIVE_POWER_VALUE 5

// Objective states
#define OBJECTIVE_INACTIVE (1<<0)
#define OBJECTIVE_ACTIVE (1<<1)
#define OBJECTIVE_COMPLETE (1<<2)

// Functionality flags
#define OBJECTIVE_DO_NOT_TREE (1<<0) // Not part of the 'clue' tree
#define OBJECTIVE_DEAD_END (1<<1) // Should this objective unlock zero clues?
#define OBJECTIVE_START_PROCESSING_ON_DISCOVERY (1<<2) // Should this objective process() every subsystem 'tick' once its breadcrumb trail of clues have been finished?

/// Misc. defines for objectives
#define APC_SCORE_INTERVAL 10 MINUTES

//=================================================

// Faction names
#define FACTION_NEUTRAL "Neutral"
#define FACTION_MARINE "USCM"
#define FACTION_SURVIVOR "Survivor"
#define FACTION_UPP "UPP"
#define FACTION_TWE "TWE"
#define FACTION_WY "Wey-Yu"
#define FACTION_CLF "CLF"
#define FACTION_PMC "PMC"
#define FACTION_CONTRACTOR "VAI"
#define FACTION_WY_DEATHSQUAD "WY Death Squad"
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
#define FACTION_MONKEY "Monkey" // Nanu

#define FACTION_LIST_MARINE list(FACTION_MARINE)
#define FACTION_LIST_HUMANOID list(FACTION_MARINE, FACTION_PMC, FACTION_WY, FACTION_WY_DEATHSQUAD, FACTION_CLF, FACTION_CONTRACTOR, FACTION_UPP, FACTION_FREELANCER, FACTION_SURVIVOR, FACTION_NEUTRAL, FACTION_COLONIST, FACTION_MERCENARY, FACTION_DUTCH, FACTION_HEFA, FACTION_GLADIATOR, FACTION_PIRATE, FACTION_PIZZA, FACTION_SOUTO, FACTION_YAUTJA, FACTION_ZOMBIE)
#define FACTION_LIST_ERT list(FACTION_PMC, FACTION_WY_DEATHSQUAD, FACTION_CLF, FACTION_CONTRACTOR, FACTION_UPP, FACTION_FREELANCER, FACTION_MERCENARY, FACTION_DUTCH, FACTION_HEFA, FACTION_GLADIATOR, FACTION_PIRATE, FACTION_PIZZA, FACTION_SOUTO)
#define FACTION_LIST_WY list(FACTION_PMC, FACTION_WY_DEATHSQUAD, FACTION_WY)
#define FACTION_LIST_MARINE_WY list(FACTION_MARINE, FACTION_PMC, FACTION_WY_DEATHSQUAD, FACTION_WY)
#define FACTION_LIST_MARINE_UPP list(FACTION_MARINE, FACTION_UPP)
#define FACTION_LIST_MARINE_TWE list(FACTION_MARINE, FACTION_TWE)

// Xenomorphs
#define FACTION_PREDALIEN "Predalien"

#define FACTION_XENOMORPH "Xenomorph"
#define FACTION_XENOMORPH_CORRPUTED "Corrupted Xenomoprh"
#define FACTION_XENOMORPH_ALPHA "Alpha Xenomorph"
#define FACTION_XENOMORPH_BRAVO "Bravo Xenomorph"
#define FACTION_XENOMORPH_CHARLIE "Charlie Xenomorph"
#define FACTION_XENOMORPH_DELTA "Delta Xenomorph"

#define FACTION_LIST_XENOMORPH list(FACTION_XENOMORPH, FACTION_XENOMORPH_CORRPUTED, FACTION_XENOMORPH_ALPHA, FACTION_XENOMORPH_BRAVO, FACTION_XENOMORPH_CHARLIE, FACTION_XENOMORPH_DELTA)


// global vars to prevent spam of the "one xyz alive" messages

var/global/last_ares_callout

var/global/last_qm_callout
