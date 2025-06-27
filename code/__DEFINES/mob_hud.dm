// for secHUDs and medHUDs and variants.
//The number is the location of the image on the list hud_list of humans.
// /datum/mob_hud expects these to be unique
// these need to be strings in order to make them associative lists
#define HEALTH_HUD "1" // a simple line rounding the mob's number health
#define STATUS_HUD "2" // alive, dead, diseased, etc.
#define ID_HUD "3" // the job asigned to your ID
#define WANTED_HUD "4" // wanted, released, parroled, security status
#define FACTION_HUD "8" // Any faction related HUD on humans
#define STATUS_HUD_OOC "10" // STATUS_HUD without virus db check for someone being ill.
#define STATUS_HUD_XENO_INFECTION "11" // STATUS_HUD without virus db check for someone being ill.
#define XENO_HOSTILE_ACID "12" // acid 'stacks' index
#define XENO_HOSTILE_SLOW "13" // xeno-inflicted slow. used by a bunch of MOBA xenos stuff
#define XENO_HOSTILE_TAG "14" // dancer prae 'tag'
#define XENO_HOSTILE_FREEZE "15" // Any xeno-inflifcted root
#define HEALTH_HUD_XENO "16" // health HUD for xenos
#define PLASMA_HUD "17" // indicates the plasma level of xenos.
#define PHEROMONE_HUD "18" // indicates which pheromone is active on a xeno.
#define QUEEN_OVERWATCH_HUD "19" // indicates which xeno the queen is overwatching.
#define ARMOR_HUD_XENO "20" // armor HUD for xenos
#define XENO_STATUS_HUD "21" // Whether xeno is a leader and its current upgrade level
#define ORDER_HUD "22" // If humans are affected by orders or not
#define XENO_BANISHED_HUD "23" // indicates that the xeno is banished
#define STATUS_HUD_XENO_CULTIST "24" // Whether they are a xeno cultist or not
#define HUNTER_CLAN "25" //Displays a colored icon to represent ingame Hunter Clans
#define HUNTER_HUD "26" //Displays various statuses on mobs for Hunters to identify targets
#define HOLOCARD_HUD "27" //Displays the holocards set by medical personnel
#define XENO_EXECUTE "28" // Execute thershold, vampire
#define NEW_PLAYER_HUD "29" //Makes it easy to see new players.
#define SPYCAM_HUD "30" //Remote control spy cameras.

//data HUD (medhud, sechud) defines
#define MOB_HUD_SECURITY_BASIC 1
#define MOB_HUD_SECURITY_ADVANCED 2
#define MOB_HUD_MEDICAL_BASIC 3
#define MOB_HUD_MEDICAL_ADVANCED 4
#define MOB_HUD_MEDICAL_OBSERVER 5
#define MOB_HUD_XENO_INFECTION 6
#define MOB_HUD_XENO_STATUS 7
#define MOB_HUD_XENO_HOSTILE 8
#define MOB_HUD_FACTION_MARINE 9
#define MOB_HUD_FACTION_OBSERVER 10
#define MOB_HUD_FACTION_UPP 11
#define MOB_HUD_FACTION_WY 12
#define MOB_HUD_FACTION_HC 13
#define MOB_HUD_FACTION_TWE 14
#define MOB_HUD_FACTION_IASF 15
#define MOB_HUD_FACTION_CLF 16
#define MOB_HUD_FACTION_PMC 17
#define MOB_HUD_FACTION_CMB 18
#define MOB_HUD_FACTION_NSPA 19
#define MOB_HUD_FACTION_PAP 20
#define MOB_HUD_FACTION_WO 21
#define MOB_HUD_HUNTER 22
#define MOB_HUD_HUNTER_CLAN 23
#define MOB_HUD_EXECUTE 24
#define MOB_HUD_NEW_PLAYER 25
#define MOB_HUD_SPYCAMS 26

//for SL/FTL/LZ targeting on locator huds
#define TRACKER_SL "track_sl"
#define TRACKER_FTL "track_ftl"
#define TRACKER_LZ "track_lz"
#define TRACKER_CO "track_co"
#define TRACKER_XO "track_xo"
#define TRACKER_CMP "track_cmp"
#define TRACKER_WARDEN "track_warden"
#define TRACKER_CL "track_cl"

#define TRACKER_ASL "_asl" // Alpha Squad Leader
#define TRACKER_BSL "_bsl" // Bravo Squad Leader
#define TRACKER_CSL "_csl" // Charlie Squad Leader
#define TRACKER_DSL "_dsl" // Delta Squad Leader
#define TRACKER_ESL "_esl" // Echo Squad Leader
#define TRACKER_FSL "_fsl" // Cryo Squad Leader
#define TRACKER_ISL "_isl" // Intel Squad Leader

//for tracking the queen/hivecore on xeno locator huds
#define TRACKER_QUEEN "Queen"
#define TRACKER_HIVE "Hive Core"
#define TRACKER_LEADER "Leader"
#define TRACKER_TUNNEL "Tunnel"

//These are used to manage the same HUD having multiple sources
#define HUD_SOURCE_ADMIN "admin"
