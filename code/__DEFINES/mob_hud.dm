// for secHUDs and medHUDs and variants.
// The number is the location of the image on the list hud_list of mobs.
// /datum/mob_hud expects these to be unique
// these need to be strings in order to make them associative lists

/// HUMAN HUDs
#define STATUS_HUD_OOC "1" // STATUS_HUD without virus db check for someone being ill.
#define HEALTH_HUD "2" // a simple line rounding the mob's number health
#define STATUS_HUD "3" // alive, dead, diseased, etc.
#define STATUS_HUD_XENO_INFECTION "4" // STATUS_HUD without virus db check for someone being ill.
#define ID_HUD "5" // the job asigned to your ID
#define WANTED_HUD "6" // wanted, released, parroled, security status
#define FACTION_HUD "7" // Any faction related HUD on humans
#define ORDER_HUD "8" // If humans are affected by orders or not
#define STATUS_HUD_XENO_CULTIST "9" // Whether they are a xeno cultist or not

/// XENO HUDs
#define XENO_STATUS_HUD "10" // Whether xeno is a leader and its current upgrade level
#define XENO_HOSTILE_ACID "11" // acid 'stacks' index
#define XENO_HOSTILE_SLOW "12" // xeno-inflicted slow. used by a bunch of MOBA xenos stuff
#define XENO_HOSTILE_TAG "13" // dancer prae 'tag'
#define XENO_HOSTILE_FREEZE "14" // Any xeno-inflifcted root
#define HEALTH_HUD_XENO "15" // health HUD for xenos
#define PLASMA_HUD "16" // indicates the plasma level of xenos.
#define PHEROMONE_HUD "17" // indicates which pheromone is active on a xeno.
#define ARMOR_HUD_XENO "18" // armor HUD for xenos
#define QUEEN_OVERWATCH_HUD "19" // indicates which xeno the queen is overwatching.
#define XENO_BANISHED_HUD "20" // indicates that the xeno is banished

/// YAUTJA HUDs
#define HUNTER_CLAN "25" //Displays a colored icon to represent ingame Hunter Clans
#define HUNTER_HUD "26" //Displays various statuses on mobs for Hunters to identify targets

//data HUD (medhud, sechud) defines
#define MOB_HUD_SECURITY_BASIC 1
#define MOB_HUD_SECURITY_ADVANCED 2
#define MOB_HUD_MEDICAL_BASIC 3
#define MOB_HUD_MEDICAL_ADVANCED 4
#define MOB_HUD_MEDICAL_OBSERVER 5
#define MOB_HUD_XENO_INFECTION 6
#define MOB_HUD_XENO_STATUS 7
#define MOB_HUD_XENO_HOSTILE 8
#define MOB_HUD_FACTION_USCM 9
#define MOB_HUD_FACTION_OBSERVER 10
#define MOB_HUD_FACTION_UPP 11
#define MOB_HUD_FACTION_WY 12
#define MOB_HUD_FACTION_TWE 13
#define MOB_HUD_FACTION_CLF 14
#define MOB_HUD_FACTION_PMC 15
#define MOB_HUD_HUNTER 16
#define MOB_HUD_HUNTER_CLAN 17
#define MOB_HUD_FACTION_VAI 18

//for SL/FTL/LZ targeting on locator huds
#define TRACKER_SL "track_sl"
#define TRACKER_FTL "track_ftl"
#define TRACKER_LZ "track_lz"
#define TRACKER_CO "track_co"
#define TRACKER_XO "track_xo"
#define TRACKER_CL "track_cl"

#define TRACKER_ASL "_asl" // Alpha Squad Leader
#define TRACKER_BSL "_bsl" // Bravo Squad Leader
#define TRACKER_CSL "_csl" // Charlie Squad Leader
#define TRACKER_DSL "_dsl" // Delta Squad Leader
#define TRACKER_ESL "_esl" // Echo Squad Leader
#define TRACKER_FSL "_fsl" // Cryo Squad Leader

//for tracking the queen/hivecore on xeno locator huds
#define TRACKER_QUEEN "Queen"
#define TRACKER_HIVE "Hive Core"
