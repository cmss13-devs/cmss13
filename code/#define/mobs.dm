//Some mob defines below
#define AI_CAMERA_LUMINOSITY 6

#define BORGMESON 1
#define BORGTHERM 2
#define BORGXRAY  4

//=================================================

#define HUMAN_STRIP_DELAY 40 //takes 40ds = 4s to strip someone.
#define POCKET_STRIP_DELAY 20

#define ALIEN_SELECT_AFK_BUFFER 1 // How many minutes that a person can be AFK before not being allowed to be an alien.

//Life variables
#define HUMAN_MAX_OXYLOSS 1 //Defines how much oxyloss humans can get per tick. A tile with no air at all (such as space) applies this value, otherwise it's a percentage of it.
#define HUMAN_CRIT_MAX_OXYLOSS 1 //The amount of damage you'll get when in critical condition. We want this to be a 5 minute deal = 300s. There are 50HP to get through, so (1/6)*last_tick_duration per second. Breaths however only happen every 3 ticks.

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

//bitflags for mutations
	// Extra powers:
#define LASER			(1<<8)	// harm intent - click anywhere to shoot lasers from eyes
#define HEAL			(1<<9)	// healing people with hands
#define SHADOW			(1<<10)	// shadow teleportation (create in/out portals anywhere) (25%)
#define SCREAM			(1<<11)	// supersonic screaming (25%)
#define EXPLOSIVE		(1<<12)	// exploding on-demand (15%)
#define REGENERATION	(1<<13)	// superhuman regeneration (30%)
#define REPROCESSOR		(1<<14)	// eat anything (50%)
#define SHAPESHIFTING	(1<<15)	// take on the appearance of anything (40%)
#define PHASING			(1<<16)	// ability to phase through walls (40%)
#define SHIELD			(1<<17)	// shielding from all projectile attacks (30%)
#define SHOCKWAVE		(1<<18)	// attack a nearby tile and cause a massive shockwave, knocking most people on their asses (25%)
#define ELECTRICITY		(1<<19)	// ability to shoot electric attacks (15%)
//=================================================

// String identifiers for associative list lookup

#define STRUCDNASIZE 27
#define UNIDNASIZE 13

	// Generic mutations:
#define	TK				1
#define COLD_RESISTANCE	2
#define XRAY			3
#define HULK			4
#define CLUMSY			5
#define FAT				6
#define HUSK			7
#define NOCLONE			8
//=================================================

	//2spooky
#define SKELETON 29
#define PLANT 30

// Other Mutations:
#define mNobreath		100 	// no need to breathe
#define mRemote			101 	// remote viewing
#define mRegen			102 	// health regen
#define mRun			103 	// no slowdown
#define mRemotetalk		104 	// remote talking
#define mMorph			105 	// changing appearance
#define mBlend			106 	// nothing (seriously nothing)
#define mHallucination	107 	// hallucinations
#define mFingerprints	108 	// no fingerprints
#define mShock			109 	// insulated hands
#define mSmallsize		110 	// table climbing
//=================================================

//disabilities
#define NEARSIGHTED		1
#define EPILEPSY		2
#define COUGHING		4
#define TOURETTES		8
#define NERVOUS			16
//=================================================

//sdisabilities
#define BLIND			1
#define MUTE			2
#define DEAF			4
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
#define CANSTUN				1
#define CANKNOCKDOWN		2
#define CANKNOCKOUT			4
#define CANPUSH				8
#define LEAPING				16
#define PASSEMOTES			32      //holders inside of mob that need to see emotes.
#define GODMODE				4096
#define FAKEDEATH			8192	//Replaces stuff like changeling.changeling_fakedeath
#define DISFIGURED			16384	//I'll probably move this elsewhere if I ever get wround to writing a bitflag mob-damage system
#define XENO_HOST			32768	//Tracks whether we're gonna be a baby alien's mummy.
#define IMMOBILE_ACTION		65536 	// If you are performing an action that prevents you from being pushed by your own people.
#define PERMANENTLY_DEAD	131072
#define CANDAZE				262144
#define CANSLOW				262144*2

// =============================
// hive types

#define XENO_HIVE_NORMAL 1
#define XENO_HIVE_CORRUPTED 2
#define XENO_HIVE_ALPHA 3
#define XENO_HIVE_BETA 4
#define XENO_HIVE_ZETA 5

//=================================================

// =============================
// slowdowns

#define XENO_SLOWED_AMOUNT 0.7
#define XENO_SUPERSLOWED_AMOUNT 1.5
#define HUMAN_SLOWED_AMOUNT 1.5
#define HUMAN_SUPERSLOWED_AMOUNT 4.0

//=================================================

///////////////////HUMAN BLOODTYPES///////////////////

#define HUMAN_BLOODTYPES list("O-","O+","A-","A+","B-","B+","AB-","AB+")

///////////////////LIMB DEFINES///////////////////

#define LIMB_BLEEDING 1
#define LIMB_BROKEN 2
#define LIMB_DESTROYED 4 //limb is missing
#define LIMB_ROBOT 8
#define LIMB_SPLINTED 16
#define LIMB_NECROTIZED 32 //necrotizing limb, nerves are dead.
#define LIMB_MUTATED 64 //limb is deformed by mutations
#define LIMB_AMPUTATED 128 //limb was amputated cleanly or destroyed limb was cleaned up, thus causing no pain
#define LIMB_REPAIRED 256 //we just repaired the bone, stops the gelling after setting


/////////////////MOVE DEFINES//////////////////////
#define MOVE_INTENT_WALK        1
#define MOVE_INTENT_RUN         2
///////////////////INTERNAL ORGANS DEFINES///////////////////

#define ORGAN_ASSISTED	1
#define ORGAN_ROBOT		2


///////////////SURGERY DEFINES///////////////
#define SPECIAL_SURGERY_INVALID	"special_surgery_invalid"

#define NECRO_TREAT_MIN_DURATION 40
#define NECRO_TREAT_MAX_DURATION 60

#define HEMOSTAT_MIN_DURATION 40
#define HEMOSTAT_MAX_DURATION 60

#define BONESETTER_MIN_DURATION 60
#define BONESETTER_MAX_DURATION 80

#define BONEGEL_REPAIR_MIN_DURATION 40
#define BONEGEL_REPAIR_MAX_DURATION 60

#define FIXVEIN_MIN_DURATION 60
#define FIXVEIN_MAX_DURATION 80

#define FIX_ORGAN_MIN_DURATION 60
#define FIX_ORGAN_MAX_DURATION 80

#define RETRACTOR_MIN_DURATION 30
#define RETRACTOR_MAX_DURATION 40

#define CIRCULAR_SAW_MIN_DURATION 60
#define CIRCULAR_SAW_MAX_DURATION 80

#define INCISION_MANAGER_MIN_DURATION 60
#define INCISION_MANAGER_MAX_DURATION 80

#define SCALPEL_MIN_DURATION 40
#define SCALPEL_MAX_DURATION 60

#define CAUTERY_MIN_DURATION 60
#define CAUTERY_MAX_DURATION 80

#define AMPUTATION_MIN_DURATION 90
#define AMPUTATION_MAX_DURATION 110

#define SURGICAL_DRILL_MIN_DURATION 90
#define SURGICAL_DRILL_MAX_DURATION 110

#define IMPLANT_MIN_DURATION 60
#define IMPLANT_MAX_DURATION 80

#define REMOVE_OBJECT_MIN_DURATION 60
#define REMOVE_OBJECT_MAX_DURATION 80

#define BONECHIPS_MAX_DAMAGE 20

#define LIMB_PRINTING_TIME 550
#define LIMB_METAL_AMOUNT 125

// Surgery chance modifiers

#define SURGERY_MULTIPLIER_SMALL 	0.10
#define SURGERY_MULTIPLIER_MEDIUM 	0.20
#define SURGERY_MULTIPLIER_LARGE	0.40
#define SURGERY_MULTIPLIER_HUGE 	0.60

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

//Language flags.
#define WHITELISTED 1  		// Language is available if the speaker is whitelisted.
#define RESTRICTED 2   		// Language can only be accquired by spawning or an admin.
#define NONVERBAL 4    		// Language has a significant non-verbal component. Speech is garbled without line-of-sight
#define SIGNLANG 8     		// Language is completely non-verbal. Speech is displayed through emotes for those who can understand.
#define HIVEMIND 16         // Broadcast to all mobs with this language.
//=================================================

//Species flags.
#define NO_BLOOD 1
#define NO_BREATHE 2
#define NO_SCAN 4
#define NO_PAIN 8
#define NO_SLIP 16
#define NO_POISON 32
#define NO_CHEM_METABOLIZATION 64 //Prevents reagents from acting on_mob_life().
#define HAS_SKIN_TONE 128
#define HAS_SKIN_COLOR 256
#define HAS_LIPS 512
#define HAS_UNDERWEAR 1024
#define IS_PLANT 2048
#define IS_WHITELISTED 4096
#define IS_SYNTHETIC 8192

//=================================================

//Some on_mob_life() procs check for alien races.
#define IS_XENOS 5
#define IS_YAUTJA 6
#define IS_HORROR 7
//=================================================

//Mob sizes
#define MOB_SIZE_SMALL			0
#define MOB_SIZE_HUMAN			1
#define MOB_SIZE_XENO			2
#define MOB_SIZE_BIG			3
#define MOB_SIZE_IMMOBILE		4 // if you are not supposed to be able to move AT ALL then you get this flag


//defines for the busy icons when the mob does something that takes time using do_after proc
#define NO_BUSY_ICON		0
#define BUSY_ICON_GENERIC	1
#define BUSY_ICON_MEDICAL	2
#define BUSY_ICON_BUILD		3
#define BUSY_ICON_FRIENDLY	4
#define BUSY_ICON_HOSTILE	5


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

#define HUMAN_MAX_PALENESS	30 //this is added to human skin tone to get value of pale_max variable


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


//forcesay types
#define SUDDEN 0
#define GRADUAL 1
#define PAINFUL 2
#define EXTREMELY_PAINFUL 3

// Xeno hivemind HREFs
#define XENO_OVERWATCH_TARGET_HREF "xeno_overwatch_href"
#define XENO_OVERWATCH_SRC_HREF "xeno_overwatch_src_href"

// xeno abilities cooldown

#define CRUSHER_STOMP_COOLDOWN 200
#define CRUSHER_EARTHQUAKE_COOLDOWN 400

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

// Hivelord strain flags
#define HIVELORD_NORMAL		"Normal"

// Carrier strain flags
#define CARRIER_NORMAL 		"Normal"
#define CARRIER_EGGSACS		"Eggsac"

// Burrower strain flags
#define BURROWER_NORMAL 	"Normal"
#define BURROWER_TREMOR		"Tremor"

// Sentinel strain flags
#define SENTINEL_NORMAL		"Normal"

// Spitter strain flags
#define SPITTER_NORMAL		"Normal"
#define SPITTER_VOMITER		"Vomiter"

// Boiler strain flags
#define BOILER_NORMAL		"Normal"
#define BOILER_RAILGUN		"Railgun"
#define BOILER_SHATTER  	"Shatter"

// Runner strain flags
#define RUNNER_NORMAL		"Normal"

// Lurker strain flags
#define LURKER_NORMAL		"Normal"

// Ravager strain flags
#define RAVAGER_NORMAL 		"Normal"
#define RAVAGER_VETERAN 	"Veteran"
#define RAVAGER_HEDGEHOG 	"Hedgehog"

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
#define PRAETORIAN_ROYALGUARD "Royal Guard"
#define PRAETORIAN_DANCER	  "Dancer"
#define PRAETORIAN_OPPRESSOR  "Oppressor"

// Praetorian strain flags
#define PRAE_SCREECH_BUFFED  	1
#define PRAE_DANCER_STATSBUFFED 2
#define PRAE_DANCER_TAILATTACK_TYPE	4 // 0 = damage, 1 = pull/abduct
#define PRAE_ROYALGUARD_ACIDSPRAY_TYPE 4 // 0 = cone, 1 = line

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
