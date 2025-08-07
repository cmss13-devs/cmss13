/// Multiplier for Stun/KD/KO/etc durations in new backend, due to old system being based on life ticks
#define GLOBAL_STATUS_MULTIPLIER 20 // each in-code unit is worth 20ds of duration

#define HEALTH_THRESHOLD_DEAD -100
#define HEALTH_THRESHOLD_CRIT -50

//Some mob defines below
#define AI_CAMERA_LUMINOSITY 6

#define BORGMESON (1<<0)
#define BORGTHERM (1<<1)
#define BORGXRAY  (1<<2)

#define OVEREAT_TIME 200

//=================================================
#define HEAT_DAMAGE_LEVEL_1 2 //Amount of damage applied when your body temperature just passes the 360.15k safety point
#define HEAT_DAMAGE_LEVEL_2 4 //Amount of damage applied when your body temperature passes the 400K point
#define HEAT_DAMAGE_LEVEL_3 8 //Amount of damage applied when your body temperature passes the 1000K point

#define COLD_DAMAGE_LEVEL_1 0.2 //Amount of damage applied when your body temperature just passes the 260.15k safety point
#define COLD_DAMAGE_LEVEL_2 1 //Amount of damage applied when your body temperature passes the 200K point
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
#define NEARSIGHTED (1<<0)

#define NERVOUS (1<<4)
#define OPIATE_RECEPTOR_DEFICIENCY (1<<5)
//=================================================

//sdisabilities
#define DISABILITY_BLIND (1<<0)
#define DISABILITY_MUTE (1<<1)
#define DISABILITY_DEAF (1<<2)
//=================================================

//mob/var/stat things
#define CONSCIOUS 0
#define UNCONSCIOUS 1
#define DEAD 2

//Damage things
//Way to waste perfectly good damagetype names (BRUTE) on this... If you were really worried about case sensitivity, you could have just used lowertext(damagetype) in the proc...
#define BRUTE "brute"
#define BURN "fire"
#define TOX "tox"
#define OXY "oxy"
#define CLONE "clone"
#define CUT "cut"
#define BRUISE "bruise"
#define HALLOSS "halloss"
#define BRAIN "brain"

//=================================================

#define STUN "stun"
#define WEAKEN "weaken"
#define PARALYZE "paralyze"
#define IRRADIATE "irradiate"
#define AGONY "agony" // Added in PAIN!
#define STUTTER "stutter"
#define EYE_BLUR "eye_blur"
#define DROWSY "drowsy"
#define SLUR "slur"
#define DAZE "daze"
#define SLOW "slow"
#define SUPERSLOW "superslow"
#define ROOT "root"

//=================================================

//I hate adding defines like this but I'd much rather deal with bitflags than lists and string searches
#define BRUTELOSS (1<<0)
#define FIRELOSS (1<<1)
#define TOXLOSS (1<<2)
#define OXYLOSS (1<<3)
//=================================================

//Bitflags defining which status effects could be or are inflicted on a mob

#define STATUS_FLAGS_DEBILITATE (CANSTUN|CANKNOCKOUT|CANDAZE|CANSLOW|CANROOT)

#define CANSTUN (1<<0)
#define CANKNOCKDOWN (1<<1)
#define CANKNOCKOUT (1<<2)
#define CANPUSH (1<<3)
#define LEAPING (1<<4)
#define PASSEMOTES (1<<5) //holders inside of mob that need to see emotes.
#define CANROOT (1<<6)
#define GODMODE (1<<12)
#define FAKEDEATH (1<<13) //Replaces stuff like changeling.changeling_fakedeath
#define RECENTSPAWN (1<<14) // Temporarily invincible via GODMODE
#define XENO_HOST (1<<15) //Tracks whether we're gonna be a baby alien's mummy.
#define IMMOBILE_ACTION (1<<16) // If you are performing an action that prevents you from being pushed by your own people.
#define PERMANENTLY_DEAD (1<<17)
#define CANDAZE (1<<18)
#define CANSLOW (1<<19)
#define NO_PERMANENT_DAMAGE (1<<20)
#define CORRUPTED_ALLY (1<<21)
#define FAKESOUL (1<<22) // Lets things without souls pretend like they do

// =============================
// hive types

#define XENO_HIVE_NORMAL "xeno_hive_normal"
#define XENO_HIVE_CORRUPTED "xeno_hive_corrupted"
#define XENO_HIVE_ALPHA "xeno_hive_alpha"
#define XENO_HIVE_BRAVO "xeno_hive_bravo"
#define XENO_HIVE_CHARLIE "xeno_hive_charlie"
#define XENO_HIVE_DELTA "xeno_hive_delta"
#define XENO_HIVE_FERAL "xeno_hive_feral"
#define XENO_HIVE_TAMED "xeno_hive_tamed"
#define XENO_HIVE_MUTATED "xeno_hive_mutated"
#define XENO_HIVE_FORSAKEN "xeno_hive_forsaken"
#define XENO_HIVE_YAUTJA "xeno_hive_yautja"
#define XENO_HIVE_RENEGADE "xeno_hive_renegade"

#define XENO_HIVE_TUTORIAL "xeno_hive_tutorial"

#define ALL_XENO_HIVES list(XENO_HIVE_NORMAL, XENO_HIVE_CORRUPTED, XENO_HIVE_ALPHA, XENO_HIVE_BRAVO, XENO_HIVE_CHARLIE, XENO_HIVE_DELTA, XENO_HIVE_FERAL, XENO_HIVE_TAMED, XENO_HIVE_MUTATED, XENO_HIVE_FORSAKEN, XENO_HIVE_YAUTJA, XENO_HIVE_RENEGADE, XENO_HIVE_TUTORIAL)

//=================================================

// =============================
// slowdowns
#define XENO_SLOWED_AMOUNT 0.7
#define XENO_SUPERSLOWED_AMOUNT 1.5
#define HUMAN_SLOWED_AMOUNT 2
#define HUMAN_SUPERSLOWED_AMOUNT 4

// Adds onto HUMAN_*****_AMOUNT
#define YAUTJA_SLOWED_AMOUNT -1.25 // 0.75s slowdown
#define YAUTJA_SUPERSLOWED_AMOUNT -3 // 1s slowdown

//=================================================

/*   MOVE DEFINES   */
#define MOVE_INTENT_WALK 1
#define MOVE_INTENT_RUN  2

/*   INTERNAL ORGAN DEFINES   */
#define ORGAN_ASSISTED 1
#define ORGAN_ROBOT 2

#define ORGAN_HEALTHY 0
#define ORGAN_LITTLE_BRUISED 1 //used by stethoscopes and penlights
#define ORGAN_BRUISED 2
#define ORGAN_BROKEN 3

//=================================================

//Languages!
#define LANGUAGE_HUMAN 1
#define LANGUAGE_ALIEN 2
#define LANGUAGE_DOG 4
#define LANGUAGE_CAT 8
#define LANGUAGE_OTHER 32768
#define LANGUAGE_UNIVERSAL 65535

//=================================================

// Mob flags.
#define KNOWS_TECHNOLOGY (1<<0) // This mob understands technology
#define SQUEEZE_UNDER_VEHICLES (1<<1)  // Only the van is supported as of now.
#define EASY_SURGERY (1<<2)  // Surgeries on this mob don't require advanced skills.
#define SURGERY_MODE_ON (1<<3)  // Mob on surgery mode, will attempt surgery when using relevant items on harm/disarm intent.
#define GIVING (1<<4) // Is currently trying to give an item to someone
#define NOBIOSCAN (1<<5)
#define HAS_SPAWNED_PET (1<<6) // Has spawned their special pet.
#define MUTINY_MUTINEER (1<<7)  // Part of the Mutiny Gang
#define MUTINY_LOYALIST (1<<8) // Allied with command.
#define MUTINY_NONCOMBAT (1<<9) // NON COMBATANT.

//=================================================

//Language flags.
#define WHITELISTED (1<<0) // Language is available if the speaker is whitelisted.
#define RESTRICTED (1<<1) // Language can only be accquired by spawning or an admin.
#define NONVERBAL (1<<2) // Language has a significant non-verbal component. Speech is garbled without line-of-sight
#define SIGNLANG (1<<3) // Language is completely non-verbal. Speech is displayed through emotes for those who can understand.
#define HIVEMIND (1<<4)  // Broadcast to all mobs with this language.
//=================================================

//Species flags.
#define NO_BLOOD (1<<0)
#define NO_BREATHE (1<<1)
#define NO_CLONE_LOSS (1<<2)
#define NO_SLIP (1<<3)
#define NO_POISON (1<<4)
#define NO_CHEM_METABOLIZATION (1<<5) //Prevents reagents from acting on_mob_life().
#define HAS_SKIN_TONE (1<<6)
#define HAS_SKIN_COLOR (1<<7)
#define HAS_LIPS (1<<8)
#define HAS_UNDERWEAR (1<<9)
#define IS_WHITELISTED (1<<10)
#define IS_SYNTHETIC (1<<11)
#define NO_NEURO (1<<12)
#define SPECIAL_BONEBREAK (1<<13) //species do not get their bonebreak chance modified by endurance
#define NO_SHRAPNEL (1<<14)
#define HAS_HARDCRIT (1<<15)
#define NO_OVERLAYS (1<<16) // Stop OnMob overlays from appearing on sprite

//=================================================

//Some on_mob_life() procs check for alien races.
#define IS_XENOS 5
#define IS_YAUTJA 6
#define IS_HORROR 7
//=================================================

//Mob sizes
#define MOB_SIZE_SMALL 0
#define MOB_SIZE_HUMAN 1
#define MOB_SIZE_XENO_VERY_SMALL 1.5
#define MOB_SIZE_XENO_SMALL 2
#define MOB_SIZE_XENO 3
#define MOB_SIZE_BIG 4
#define MOB_SIZE_IMMOBILE 5 // if you are not supposed to be able to moved AT ALL then you get this flag


//defines for the busy icons when the mob does something that takes time using do_after proc
#define NO_BUSY_ICON 0
#define BUSY_ICON_GENERIC 1
#define BUSY_ICON_MEDICAL 2
#define BUSY_ICON_BUILD 3
#define BUSY_ICON_FRIENDLY 4
#define BUSY_ICON_HOSTILE 5

#define EMOTE_ICON_HIGHFIVE  6
#define EMOTE_ICON_FISTBUMP  7
#define EMOTE_ICON_HEADBUTT  8
#define EMOTE_ICON_TAILSWIPE 9
#define EMOTE_ICON_ROCK_PAPER_SCISSORS 10
#define EMOTE_ICON_ROCK 11
#define EMOTE_ICON_PAPER 12
#define EMOTE_ICON_SCISSORS 13

#define ACTION_RED_POWER_UP 14
#define ACTION_GREEN_POWER_UP 15
#define ACTION_BLUE_POWER_UP 16
#define ACTION_PURPLE_POWER_UP 17

#define BUSY_ICON_CLIMBING 18

#define EMOTE_ICON_WALLBOOSTING 19

//defins for datum/hud

#define HUD_STYLE_STANDARD 1
#define HUD_STYLE_REDUCED 2
#define HUD_STYLE_NOHUD 3
#define HUD_VERSIONS 3


//Blood levels
#define BLOOD_VOLUME_MAXIMUM 600
#define BLOOD_VOLUME_NORMAL 560
#define BLOOD_VOLUME_SAFE 501
#define BLOOD_VOLUME_OKAY 336
#define BLOOD_VOLUME_BAD 224
#define BLOOD_VOLUME_SURVIVE 122


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
#define EMOTING_HIGH_FIVE  (1<<0)
#define EMOTING_FIST_BUMP  (1<<1)
#define EMOTING_HEADBUTT   (1<<2)
#define EMOTING_TAIL_SWIPE (1<<3)
#define EMOTING_ROCK_PAPER_SCISSORS (1<<4)
#define EMOTING_WALL_BOOSTING (1<<5)

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

GLOBAL_LIST_INIT(default_onmob_icons, list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/items_lefthand_64.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/items_righthand_64.dmi',
		WEAR_WAIST = 'icons/mob/humans/onmob/clothing/belts/belts.dmi',
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/backpacks.dmi',
		WEAR_L_EAR = 'icons/mob/humans/onmob/clothing/ears.dmi',
		WEAR_R_EAR = 'icons/mob/humans/onmob/clothing/ears.dmi',
		WEAR_EYES = 'icons/mob/humans/onmob/clothing/glasses/glasses.dmi',
		WEAR_ID = 'icons/mob/humans/onmob/ids.dmi',
		WEAR_BODY = 'icons/mob/humans/onmob/clothing/uniforms/misc_ert_colony.dmi',
		WEAR_JACKET = 'icons/mob/humans/onmob/clothing/suits/misc_ert.dmi',
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats.dmi',
		WEAR_FEET = 'icons/mob/humans/onmob/clothing/feet.dmi',
		WEAR_FACE = 'icons/mob/humans/onmob/clothing/masks/masks.dmi',
		WEAR_HANDCUFFED = 'icons/mob/humans/onmob/cuffs.dmi',
		WEAR_LEGCUFFED = 'icons/mob/humans/onmob/cuffs.dmi',
		WEAR_HANDS = 'icons/mob/humans/onmob/clothing/hands.dmi',
		WEAR_J_STORE = 'icons/mob/humans/onmob/clothing/suit_storage/misc.dmi',
		WEAR_ACCESSORIES = 'icons/mob/humans/onmob/clothing/accessory/ties.dmi'
		))

GLOBAL_LIST_INIT(default_xeno_onmob_icons, list(
		/mob/living/carbon/xenomorph/runner = 'icons/mob/xenos/onmob/runner.dmi',
		/mob/living/carbon/xenomorph/praetorian = 'icons/mob/xenos/onmob/praetorian.dmi',
		/mob/living/carbon/xenomorph/drone = 'icons/mob/xenos/onmob/drone.dmi',
		/mob/living/carbon/xenomorph/warrior = 'icons/mob/xenos/onmob/warrior.dmi',
		/mob/living/carbon/xenomorph/defender = 'icons/mob/xenos/onmob/defender.dmi',
		/mob/living/carbon/xenomorph/sentinel = 'icons/mob/xenos/onmob/sentinel.dmi',
		/mob/living/carbon/xenomorph/spitter = 'icons/mob/xenos/onmob/spitter.dmi'
		))

// species names
#define SPECIES_HUMAN "Human"
#define SPECIES_YAUTJA "Yautja"
#define SPECIES_SYNTHETIC "Synthetic"
#define SPECIES_SYNTHETIC_K9 "Synthetic K9"
#define SPECIES_MONKEY "Monkey"
#define SPECIES_ZOMBIE "Zombie"

#define ALL_LIMBS list("head","chest","groin","l_leg","l_foot","r_leg","r_foot","l_arm","l_hand","r_arm","r_hand")
#define MOVEMENT_LIMBS list("l_leg", "l_foot", "r_leg", "r_foot")
#define HANDLING_LIMBS list("l_arm","l_hand", "r_arm", "r_hand")
#define EXTREMITY_LIMBS list("l_leg","l_foot","r_leg","r_foot","l_arm","l_hand","r_arm","r_hand")
#define CORE_LIMBS list("chest","head","groin")

#define SYMPTOM_ACTIVATION_PROB 3

// Body position defines.
/// Mob is standing up, usually associated with lying_angle value of 0.
#define STANDING_UP 0
/// Mob is lying down, usually associated with lying_angle values of 90 or 270.
#define LYING_DOWN 1

/// Possible value of [/atom/movable/buckle_lying]. If set to a different (positive-or-zero) value than this, the buckling thing will force a lying angle on the buckled.
#define NO_BUCKLE_LYING -1

// ====================================
// /mob/living  /tg/  mobility_flags
// These represent in what capacity the mob is capable of moving
// Because porting this is underway, NOT ALL FLAGS ARE CURRENTLY IN.

/// can move
#define MOBILITY_MOVE (1<<0)
/// can, and is, standing up
#define MOBILITY_STAND (1<<1)
/// can rest
#define MOBILITY_REST (1<<7)
/// can lie down
#define MOBILITY_LIEDOWN (1<<8)

#define MOBILITY_FLAGS_DEFAULT (MOBILITY_MOVE | MOBILITY_STAND)
#define MOBILITY_FLAGS_LYING_CAPABLE_DEFAULT (MOBILITY_MOVE | MOBILITY_STAND | MOBILITY_LIEDOWN)
#define MOBILITY_FLAGS_CARBON_DEFAULT (MOBILITY_MOVE | MOBILITY_STAND | MOBILITY_REST | MOBILITY_LIEDOWN)
#define MOBILITY_FLAGS_REST_CAPABLE_DEFAULT (MOBILITY_MOVE | MOBILITY_STAND | MOBILITY_REST | MOBILITY_LIEDOWN)

/// Sleeps for X and will perform return if A is qdeleted or a dead mob.
#define SLEEP_CHECK_DEATH(X, A) \
	sleep(X); \
	if(QDELETED(A)) return; \
	if(ismob(A)) { \
		var/mob/sleep_check_death_mob = A; \
		if(sleep_check_death_mob.stat == DEAD) return; \
	}
