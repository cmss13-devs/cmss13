#define HEALTH_THRESHOLD_DEAD -100
#define HEALTH_THRESHOLD_CRIT -50

//Some mob defines below
#define AI_CAMERA_LUMINOSITY 6

#define BORGMESON 1
#define BORGTHERM 2
#define BORGXRAY  4

#define OVEREAT_TIME 200

//=================================================
#define ALIEN_SELECT_AFK_BUFFER 1 // How many minutes that a person can be AFK before not being allowed to be an alien.

#define HEAT_DAMAGE_LEVEL_1 2 //Amount of damage applied when your body temperature just passes the 360.15k safety point
#define HEAT_DAMAGE_LEVEL_2 4 //Amount of damage applied when your body temperature passes the 400K point
#define HEAT_DAMAGE_LEVEL_3 8 //Amount of damage applied when your body temperature passes the 1000K point

#define COLD_DAMAGE_LEVEL_1 0.2 //Amount of damage applied when your body temperature just passes the 260.15k safety point
#define COLD_DAMAGE_LEVEL_2 1.0 //Amount of damage applied when your body temperature passes the 200K point
#define COLD_DAMAGE_LEVEL_3 2 //Amount of damage applied when your body temperature passes the 120K point

//Note that gas heat damage is only applied once every FOUR ticks.
#define HEAT_GAS_DAMAGE_LEVEL_1 2 //Amount of damage applied when the current breath's temperature just passes the 360.15k safety point
#define HEAT_GAS_DAMAGE_LEVEL_2 4 //Amount of damage applied when the current breath's temperature passes the 400K point
#define HEAT_GAS_DAMAGE_LEVEL_3 8 //Amount of damage applied when the current breath's temperature passes the 1000K point

#define COLD_GAS_DAMAGE_LEVEL_1 0.2 //Amount of damage applied when the current breath's temperature just passes the 260.15k safety point
#define COLD_GAS_DAMAGE_LEVEL_2 0.6 //Amount of damage applied when the current breath's temperature passes the 200K point
#define COLD_GAS_DAMAGE_LEVEL_3 1.2 //Amount of damage applied when the current breath's temperature passes the 120K point

//=================================================

// String identifiers for associative list lookup

#define STRUCDNASIZE 27
#define UNIDNASIZE 13

//=================================================

	//2spooky
#define SKELETON 29
#define PLANT 30
//=================================================

//disabilities
#define NEARSIGHTED		1
#define EPILEPSY		2
#define COUGHING		4
#define TOURETTES		8
#define NERVOUS			16
//=================================================

//sdisabilities
#define DISABILITY_BLIND		(1<<0)
#define DISABILITY_MUTE			(1<<1)
#define DISABILITY_DEAF			(1<<2)
//=================================================

//mob/var/stat things
#define CONSCIOUS	0
#define UNCONSCIOUS	1
#define DEAD		2

//Damage things
//Way to waste perfectly good damagetype names (BRUTE) on this... If you were really worried about case sensitivity, you could have just used lowertext(damagetype) in the proc...
#define BRUTE		"brute"
#define BURN		"fire"
#define TOX			"tox"
#define OXY			"oxy"
#define CLONE		"clone"
#define CUT 		"cut"
#define BRUISE		"bruise"
#define HALLOSS		"halloss"
#define BRAIN		"brain"

//=================================================

#define STUN		"stun"
#define WEAKEN		"weaken"
#define PARALYZE	"paralize"
#define IRRADIATE	"irradiate"
#define AGONY		"agony" // Added in PAIN!
#define STUTTER		"stutter"
#define EYE_BLUR	"eye_blur"
#define DROWSY		"drowsy"
#define SLUR 		"slur"
#define DAZE 		"daze"
#define SLOW		"slow"
#define SUPERSLOW	"superslow"
//=================================================

//I hate adding defines like this but I'd much rather deal with bitflags than lists and string searches
#define BRUTELOSS 1
#define FIRELOSS 2
#define TOXLOSS 4
#define OXYLOSS 8
//=================================================

//Bitflags defining which status effects could be or are inflicted on a mob
#define CANSTUN				(1<<0)
#define CANKNOCKDOWN		(1<<1)
#define CANKNOCKOUT			(1<<2)
#define CANPUSH				(1<<3)
#define LEAPING				(1<<4)
#define PASSEMOTES			(1<<5)	//holders inside of mob that need to see emotes.
#define GODMODE				(1<<12)
#define FAKEDEATH			(1<<13)	//Replaces stuff like changeling.changeling_fakedeath
#define DISFIGURED			(1<<14)	//I'll probably move this elsewhere if I ever get wround to writing a bitflag mob-damage system
#define XENO_HOST			(1<<15)	//Tracks whether we're gonna be a baby alien's mummy.
#define IMMOBILE_ACTION		(1<<16) 	// If you are performing an action that prevents you from being pushed by your own people.
#define PERMANENTLY_DEAD	(1<<17)
#define CANDAZE				(1<<18)
#define CANSLOW				(1<<19)
#define NO_PERMANENT_DAMAGE	(1<<20)

// =============================
// hive types

#define XENO_HIVE_NORMAL "xeno_hive_normal"
#define XENO_HIVE_CORRUPTED "xeno_hive_corrupted"
#define XENO_HIVE_ALPHA "xeno_hive_alpha"
#define XENO_HIVE_BRAVO "xeno_hive_bravo"
#define XENO_HIVE_CHARLIE "xeno_hive_charlie"
#define XENO_HIVE_DELTA "xeno_hive_delta"
#define XENO_HIVE_SUBMISSIVE "xeno_hive_submissive"

//=================================================

// =============================
// slowdowns
#define XENO_SLOWED_AMOUNT 0.7
#define XENO_SUPERSLOWED_AMOUNT 1.5
#define HUMAN_SLOWED_AMOUNT 2.0
#define HUMAN_SUPERSLOWED_AMOUNT 4.0

// Adds onto HUMAN_*****_AMOUNT
#define YAUTJA_SLOWED_AMOUNT -1.25 // 0.75s slowdown
#define YAUTJA_SUPERSLOWED_AMOUNT -3 // 1s slowdown

//=================================================

///////////////////INTERNAL ORGANS DEFINES///////////////////
#define ORGAN_ASSISTED	1
#define ORGAN_ROBOT		2

//=================================================

//Languages!
#define LANGUAGE_HUMAN		1
#define LANGUAGE_ALIEN		2
#define LANGUAGE_DOG		4
#define LANGUAGE_CAT		8
#define LANGUAGE_BINARY		16
#define LANGUAGE_OTHER		32768
#define LANGUAGE_UNIVERSAL	65535

//=================================================

// Mob flags.
#define KNOWS_TECHNOLOGY		(1<<0)	// This mob understands technology
#define SQUEEZE_UNDER_VEHICLES 	(1<<1)  // Only the van is supported as of now.

//=================================================

//Language flags.
#define WHITELISTED 1  		// Language is available if the speaker is whitelisted.
#define RESTRICTED 2   		// Language can only be accquired by spawning or an admin.
#define NONVERBAL 4    		// Language has a significant non-verbal component. Speech is garbled without line-of-sight
#define SIGNLANG 8     		// Language is completely non-verbal. Speech is displayed through emotes for those who can understand.
#define HIVEMIND 16         // Broadcast to all mobs with this language.
//=================================================

//Species flags.
#define NO_BLOOD                 (1<<0)
#define NO_BREATHE               (1<<1)
#define NO_CLONE_LOSS            (1<<2)
#define NO_SLIP                  (1<<3)
#define NO_POISON                (1<<4)
#define NO_CHEM_METABOLIZATION   (1<<5) //Prevents reagents from acting on_mob_life().
#define HAS_SKIN_TONE            (1<<6)
#define HAS_SKIN_COLOR           (1<<7)
#define HAS_LIPS                 (1<<8)
#define HAS_UNDERWEAR            (1<<9)
#define IS_WHITELISTED           (1<<10)
#define IS_SYNTHETIC             (1<<11)
#define NO_NEURO                 (1<<12)
#define SPECIAL_BONEBREAK        (1<<13) //species do not get their bonebreak chance modified by endurance
#define NO_SHRAPNEL              (1<<14)
#define HAS_HARDCRIT             (1<<15)

//=================================================

//Some on_mob_life() procs check for alien races.
#define IS_XENOS 5
#define IS_YAUTJA 6
#define IS_HORROR 7
//=================================================

//Mob sizes
#define MOB_SIZE_SMALL			0
#define MOB_SIZE_HUMAN			1
#define MOB_SIZE_XENO_SMALL 	2
#define MOB_SIZE_XENO			3
#define MOB_SIZE_BIG			4
#define MOB_SIZE_IMMOBILE		5 // if you are not supposed to be able to moved AT ALL then you get this flag


//defines for the busy icons when the mob does something that takes time using do_after proc
#define NO_BUSY_ICON		0
#define BUSY_ICON_GENERIC	1
#define BUSY_ICON_MEDICAL	2
#define BUSY_ICON_BUILD		3
#define BUSY_ICON_FRIENDLY	4
#define BUSY_ICON_HOSTILE	5

#define EMOTE_ICON_HIGHFIVE  6
#define EMOTE_ICON_FISTBUMP  7
#define EMOTE_ICON_HEADBUTT  8
#define EMOTE_ICON_TAILSWIPE 9

#define ACTION_RED_POWER_UP		10
#define ACTION_GREEN_POWER_UP	11
#define ACTION_BLUE_POWER_UP	12

//defins for datum/hud

#define HUD_STYLE_STANDARD	1
#define HUD_STYLE_REDUCED	2
#define HUD_STYLE_NOHUD		3
#define HUD_VERSIONS		3


//Blood levels
#define BLOOD_VOLUME_MAXIMUM	600
#define BLOOD_VOLUME_NORMAL		560
#define BLOOD_VOLUME_SAFE		501
#define BLOOD_VOLUME_OKAY		336
#define BLOOD_VOLUME_BAD		224
#define BLOOD_VOLUME_SURVIVE	122


//diseases
#define SPECIAL -1
#define NON_CONTAGIOUS 0
#define BLOOD 1
#define CONTACT_FEET 2
#define CONTACT_HANDS 3
#define CONTACT_GENERAL 4
#define AIRBORNE 5

#define SCANNER 1
#define PANDEMIC 2

//emote flags
#define EMOTING_HIGH_FIVE  1
#define EMOTING_FIST_BUMP  2
#define EMOTING_HEADBUTT   3
#define EMOTING_TAIL_SWIPE 4

//forcesay types
#define SUDDEN 0
#define GRADUAL 1
#define PAINFUL 2
#define EXTREMELY_PAINFUL 3

// Xeno hivemind HREFs
#define XENO_OVERWATCH_TARGET_HREF "target_ref"
#define XENO_OVERWATCH_SRC_HREF "user_ref"

// xeno abilities cooldown

#define CANNOT_HOLD_EGGS 0
#define CAN_HOLD_TWO_HANDS 1
#define CAN_HOLD_ONE_HAND 2

//	------------	//
//	STRAIN FLAGS	//
//	------------	//

// Queen strain flags
#define QUEEN_NORMAL		"Normal"

// Drone strain flags
#define DRONE_NORMAL		"Normal"
#define DRONE_HEALER		"Healer"
#define DRONE_GARDENER		"Gardener"

// Hivelord strain flags
#define HIVELORD_NORMAL		"Normal"
#define HIVELORD_RESIN_WHISPERER "Resin Whisperer"

// Carrier strain flags
#define CARRIER_NORMAL 		"Normal"
#define CARRIER_SHAMAN		"Shaman"

// Burrower strain flags
#define BURROWER_NORMAL 	"Normal"
#define BURROWER_TREMOR		"Tremor"

// Sentinel strain flags
#define SENTINEL_NORMAL		"Normal"
#define SENTINEL_SCATTERSPIT "Scatterspitter"

// Spitter strain flags
#define SPITTER_NORMAL		"Normal"

// Boiler strain flags
#define BOILER_NORMAL		"Normal"
#define BOILER_TRAPPER 		"Trapper"

// Runner strain flags
#define RUNNER_NORMAL		"Normal"
#define RUNNER_ACIDER		"Acider"

// Lurker strain flags
#define LURKER_NORMAL		"Normal"

// Ravager strain flags
#define RAVAGER_NORMAL 		"Normal"
#define RAVAGER_HEDGEHOG 	"Hedgehog"
#define RAVAGER_BERSERKER   "Berserker"

// Defender strain flags
#define DEFENDER_NORMAL 	"Normal"
#define DEFENDER_STEELCREST "Steelcrest"

// Warrior strain flags
#define WARRIOR_NORMAL		"Normal"
#define WARRIOR_BOXER		"Boxer"

// Crusher strain flags
#define CRUSHER_NORMAL		"Normal"

// Praetorian strain flags
#define PRAETORIAN_NORMAL	  "Normal"
#define PRAETORIAN_VANGUARD	"Vanguard"
#define PRAETORIAN_DANCER	  "Dancer"
#define PRAETORIAN_WARDEN 	  "Warden"
#define PRAETORIAN_OPPRESSOR  "Oppressor"

var/list/default_onmob_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/items_lefthand_0.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/items_righthand_0.dmi',
		WEAR_WAIST = 'icons/mob/humans/onmob/belt.dmi',
		WEAR_BACK = 'icons/mob/humans/onmob/back.dmi',
		WEAR_EAR = 'icons/mob/humans/onmob/ears.dmi',
		WEAR_EYES = 'icons/mob/humans/onmob/eyes.dmi',
		WEAR_ID = 'icons/mob/mob.dmi',
		WEAR_BODY = 'icons/mob/humans/onmob/uniform_0.dmi',
		WEAR_JACKET = 'icons/mob/humans/onmob/suit_0.dmi',
		WEAR_HEAD = 'icons/mob/humans/onmob/head_0.dmi',
		WEAR_FEET = 'icons/mob/humans/onmob/feet.dmi',
		WEAR_FACE = 'icons/mob/humans/onmob/mask.dmi',
		WEAR_HANDCUFFED = 'icons/mob/mob.dmi',
		WEAR_LEGCUFFED = 'icons/mob/mob.dmi',
		WEAR_HANDS = 'icons/mob/humans/onmob/hands.dmi',
		WEAR_J_STORE = 'icons/mob/humans/onmob/suit_slot.dmi',
		WEAR_ACCESSORIES = 'icons/mob/humans/onmob/ties.dmi'
		)

// species names
#define SPECIES_HUMAN "Human"
#define SPECIES_YAUTJA "Yautja"
#define SPECIES_MONKEY "Monkey"
