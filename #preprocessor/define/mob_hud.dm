// for secHUDs and medHUDs and variants.
//The number is the location of the image on the list hud_list of humans.
// /datum/mob_hud expects these to be unique
// these need to be strings in order to make them associative lists
#define HEALTH_HUD			"1" // a simple line rounding the mob's number health
#define STATUS_HUD			"2" // alive, dead, diseased, etc.
#define ID_HUD				"3" // the job asigned to your ID
#define WANTED_HUD			"4" // wanted, released, parroled, security status
#define IMPLOYAL_HUD		"5" // loyality implant
#define IMPCHEM_HUD			"6" // chemical implant
#define IMPTRACK_HUD		"7" // tracking implant
#define SPECIALROLE_HUD 	"8" // AntagHUD image
#define SQUAD_HUD			"9" // squad hud showing who's leader, medic, etc for each squad.
#define STATUS_HUD_OOC		"10" // STATUS_HUD without virus db check for someone being ill.
#define STATUS_HUD_XENO_INFECTION		"11" // STATUS_HUD without virus db check for someone being ill.
#define XENO_HOSTILE_ACID   "12" // acid 'stacks' index
#define XENO_HOSTILE_SLOW   "13" // xeno-inflicted slow. used by a bunch of MOBA xenos stuff
#define XENO_HOSTILE_TAG    "14" // dancer prae 'tag'
#define XENO_HOSTILE_FREEZE "15" // Any xeno-inflifcted root

#define HEALTH_HUD_XENO		"16" // health HUD for xenos
#define PLASMA_HUD			"17" // indicates the plasma level of xenos.
#define PHEROMONE_HUD		"18" // indicates which pheromone is active on a xeno.
#define QUEEN_OVERWATCH_HUD	"19" // indicates which xeno the queen is overwatching.
#define ARMOR_HUD_XENO		"20" // armor HUD for xenos
#define XENO_STATUS_HUD     "21" // Whether xeno is a leader and its current upgrade level
#define ORDER_HUD			"22" // If humans are affected by orders or not
#define XENO_BANISHED_HUD   "23" // indicates that the xeno is banished
#define STATUS_HUD_XENO_CULTIST "24" // Whether they are a xeno cultist or not



//data HUD (medhud, sechud) defines
#define MOB_HUD_SECURITY_BASIC		1
#define MOB_HUD_SECURITY_ADVANCED	2
#define MOB_HUD_MEDICAL_BASIC		3
#define MOB_HUD_MEDICAL_ADVANCED	4
#define MOB_HUD_MEDICAL_OBSERVER	5
#define MOB_HUD_XENO_INFECTION		6
#define MOB_HUD_XENO_STATUS			7
#define MOB_HUD_SQUAD				8
#define MOB_HUD_XENO_HOSTILE		9

