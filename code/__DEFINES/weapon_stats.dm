#define HUMAN_UNIVERSAL_DAMAGEMULT 1

#define RECOIL_BUILDUP_VIEWPUNCH_MULTIPLIER 0.1
#define BASE_VELOCITY_BONUS 0

#define PROJ_BASE_ACCURACY_MULT 0.01
#define PROJ_BASE_DAMAGE_MULT 0.01

#define PROJ_VARIANCE_HIGH 105
#define PROJ_VARIANCE_LOW 98

/*
////ACCURACY////
Scale of 0 to 40. Used in ammunition datum, gun & attachment defines.
Adds a flat % chance assuming your initial chance to hit was 100% (which it is usually not). If you make it more than 40, you just have an insane chance to hit
So more than 40 is usually an overkill.
Accuracy determines if your bullets will hit whatever you're shooting at. Think of it as your chance to hit.
It DOES NOT control where your bullets go, that's scatter and projectile variance.

.../update_projectiles/guns/code.dm
	var/accuracy_mult //Base firearm accuracy when firing from a 2-hand, "secure", wielded, etc, whatever grip.
	var/accuracy_mult_unwielded //Base firearm accuracy when firing from hip. Both of these default to 1, with additions or subtractions from the mult vars.

.../updated_projectiles/ammo_datums.dm
	var/accuracy //This is added to the firearm's base accuracy when the specific ammo is shot.
	var/accuracy_var_low //These two vars are used for the upper and lower bounds of accuracy variance when a bullet is fired. Bullet 'wobble' if you will.
	var/accuracy_var_high

.../updated_projectiles/gun_attachables.dm
	var/accuracy_mult //Attachments ADD an additional multiplier to the base config value. Only ever use accuracy_mult config references.
	var/accuracy_mult_unwielded
*/

#define HIT_ACCURACY_TIER_1 5
#define HIT_ACCURACY_TIER_2 10
#define HIT_ACCURACY_TIER_3 15
#define HIT_ACCURACY_TIER_4 20
#define HIT_ACCURACY_TIER_5 25
#define HIT_ACCURACY_TIER_6 30
#define HIT_ACCURACY_TIER_7 35
#define HIT_ACCURACY_TIER_8 40
#define HIT_ACCURACY_TIER_9 45
#define HIT_ACCURACY_TIER_10 50
#define HIT_ACCURACY_TIER_MAX 100

#define BASE_ACCURACY_MULT 1
#define HIT_ACCURACY_MULT_TIER_1 0.05
#define HIT_ACCURACY_MULT_TIER_2 0.10
#define HIT_ACCURACY_MULT_TIER_3 0.15
#define HIT_ACCURACY_MULT_TIER_4 0.20
#define HIT_ACCURACY_MULT_TIER_5 0.25
#define HIT_ACCURACY_MULT_TIER_6 0.30
#define HIT_ACCURACY_MULT_TIER_7 0.35
#define HIT_ACCURACY_MULT_TIER_8 0.40
#define HIT_ACCURACY_MULT_TIER_9 0.45
#define HIT_ACCURACY_MULT_TIER_10 0.50

#define MOVEMENT_ACCURACY_PENALTY_MULT_TIER_1 5
#define MOVEMENT_ACCURACY_PENALTY_MULT_TIER_2 4
#define MOVEMENT_ACCURACY_PENALTY_MULT_TIER_3 3
#define MOVEMENT_ACCURACY_PENALTY_MULT_TIER_4 2
#define MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5 1
#define MOVEMENT_ACCURACY_PENALTY_MULT_TIER_6 0

/*
////SCATTER////
*/

#define SCATTER_AMOUNT_NEURO 45
#define SCATTER_AMOUNT_TIER_1 15
#define SCATTER_AMOUNT_TIER_2 10
#define SCATTER_AMOUNT_TIER_3 8
#define SCATTER_AMOUNT_TIER_4 7
#define SCATTER_AMOUNT_TIER_5 6
#define SCATTER_AMOUNT_TIER_6 5
#define SCATTER_AMOUNT_TIER_7 4
#define SCATTER_AMOUNT_TIER_8 3
#define SCATTER_AMOUNT_TIER_9 2
#define SCATTER_AMOUNT_TIER_10 1
#define SCATTER_AMOUNT_NONE 0

/*
////FULL AUTO SCATTER PEAK////
// How many shots on full auto before you hit max full auto scatter
*/

#define FULL_AUTO_SCATTER_PEAK_TIER_1 10
#define FULL_AUTO_SCATTER_PEAK_TIER_2 20
#define FULL_AUTO_SCATTER_PEAK_TIER_3 30
#define FULL_AUTO_SCATTER_PEAK_TIER_4 40
#define FULL_AUTO_SCATTER_PEAK_TIER_5 50
#define FULL_AUTO_SCATTER_PEAK_TIER_6 60
#define FULL_AUTO_SCATTER_PEAK_TIER_7 70
#define FULL_AUTO_SCATTER_PEAK_TIER_8 80
#define FULL_AUTO_SCATTER_PEAK_TIER_9 90
#define FULL_AUTO_SCATTER_PEAK_TIER_10 100

/*
////RECOIL////
*/

#define RECOIL_AMOUNT_TIER_0 6
#define RECOIL_AMOUNT_TIER_1 5
#define RECOIL_AMOUNT_TIER_2 4
#define RECOIL_AMOUNT_TIER_3 3
#define RECOIL_AMOUNT_TIER_4 2
#define RECOIL_AMOUNT_TIER_5 1
#define RECOIL_OFF 0

/*
////DAMAGE////
For humans, scale of 100 to -100 (200 to 0), Aliens, well that's variable. You'll need to check the caste datums.
Damage is the amount of points and object / mob will take from a firearm or projectile before armor reduction is applied.
Only Aliens and Humans have armor reduction at this time.

Weapons are generally balanced around Aliens. So far, it's been eye-balled for about 4 years.
Be the change you want to see, go make a spread sheet with all this data enterprising coder!
As such, don't expect any values assigned to common firearms to even consider how it might run in an HvH event.

.../update_projectiles/guns/code.dm
*/

#define BASE_BULLET_DAMAGE_MULT 1
#define BULLET_DAMAGE_MULT_TIER_1 0.05
#define BULLET_DAMAGE_MULT_TIER_2 0.10
#define BULLET_DAMAGE_MULT_TIER_3 0.15
#define BULLET_DAMAGE_MULT_TIER_4 0.20
#define BULLET_DAMAGE_MULT_TIER_5 0.25
#define BULLET_DAMAGE_MULT_TIER_6 0.30
#define BULLET_DAMAGE_MULT_TIER_7 0.35
#define BULLET_DAMAGE_MULT_TIER_8 0.40
#define BULLET_DAMAGE_MULT_TIER_9 0.45
#define BULLET_DAMAGE_MULT_TIER_10 0.50

/*
////FIRE DELAY////
//How many ticks you have to wait between firing. Burst delay uses the same variable!
*/

/// Sniper/DMR Delays
#define FIRE_DELAY_TIER_AMR 30
#define FIRE_DELAY_TIER_VULTURE 20
#define FIRE_DELAY_TIER_SNIPER 15

/// Shotgun Delays
#define FIRE_DELAY_TIER_SHOTGUN_SLOW 2.5 SECONDS // Heavy or damaged shotguns, KS-23, etc.
#define FIRE_DELAY_TIER_SHOTGUN_BASE 2 SECONDS // Replaces previous shotgun value which was Tier_7 (5)*4
#define FIRE_DELAY_TIER_SHOTGUN_COLONY 1.6 SECONDS // Used by the HG shotguns.
#define FIRE_DELAY_TIER_SHOTGUN_COMBAT 1.4 SECONDS // Replaces previous combat shotgun value which was Tier_5 (7)*2 ...Wow that's confusing.
#define FIRE_DELAY_TIER_SHOTGUN_DEATHSQUAD 0.6 SECONDS // For adminspawn ERTs, MARSOC, etc.

/// General Delay Tiers
#define FIRE_DELAY_TIER_1 12
#define FIRE_DELAY_TIER_2 10
#define FIRE_DELAY_TIER_3 9
#define FIRE_DELAY_TIER_4 8
#define FIRE_DELAY_TIER_5 7
#define FIRE_DELAY_TIER_6 6
#define FIRE_DELAY_TIER_7 5
#define FIRE_DELAY_TIER_8 4
#define FIRE_DELAY_TIER_9 3.5
#define FIRE_DELAY_TIER_10 3
#define FIRE_DELAY_TIER_11 2.5
#define FIRE_DELAY_TIER_LMG 2
#define FIRE_DELAY_TIER_SG 2
#define FIRE_DELAY_TIER_SMG 1.5
#define FIRE_DELAY_TIER_12 1

/*
////RANGE RELATED////
*/

#define DAMAGE_FALLOFF_BLANK 30
#define DAMAGE_FALLOFF_TIER_1 10
#define DAMAGE_FALLOFF_TIER_2 9
#define DAMAGE_FALLOFF_TIER_3 8
#define DAMAGE_FALLOFF_TIER_4 7
#define DAMAGE_FALLOFF_TIER_5 6
#define DAMAGE_FALLOFF_TIER_6 5
#define DAMAGE_FALLOFF_TIER_7 4
#define DAMAGE_FALLOFF_TIER_8 3
#define DAMAGE_FALLOFF_TIER_9 2
#define DAMAGE_FALLOFF_TIER_9_5 1.5
#define DAMAGE_FALLOFF_TIER_10 1

#define DAMAGE_BUILDUP_TIER_1 1
#define DAMAGE_BUILDUP_TIER_2 2
#define DAMAGE_BUILDUP_TIER_3 3

//Defaulting to the legacy damage falloff method
#define EFFECTIVE_RANGE_OFF 0

#define EFFECTIVE_RANGE_MIN_TIER_1 10
#define EFFECTIVE_RANGE_MIN_TIER_2 9
#define EFFECTIVE_RANGE_MIN_TIER_3 8
#define EFFECTIVE_RANGE_MIN_TIER_4 7
#define EFFECTIVE_RANGE_MIN_TIER_5 6
#define EFFECTIVE_RANGE_MIN_TIER_6 5
#define EFFECTIVE_RANGE_MIN_TIER_7 4
#define EFFECTIVE_RANGE_MIN_TIER_8 3
#define EFFECTIVE_RANGE_MIN_TIER_9 2
#define EFFECTIVE_RANGE_MIN_TIER_10 1

#define EFFECTIVE_RANGE_MAX_TIER_1 3
#define EFFECTIVE_RANGE_MAX_TIER_2 6
#define EFFECTIVE_RANGE_MAX_TIER_3 9
#define EFFECTIVE_RANGE_MAX_TIER_4 12
#define EFFECTIVE_RANGE_MAX_TIER_5 15
#define EFFECTIVE_RANGE_MAX_TIER_6 18
#define EFFECTIVE_RANGE_MAX_TIER_7 21
#define EFFECTIVE_RANGE_MAX_TIER_8 24
#define EFFECTIVE_RANGE_MAX_TIER_9 27
#define EFFECTIVE_RANGE_MAX_TIER_10 30

/*
////BURST AMOUNT////
*/

#define BURST_AMOUNT_TIER_1 1
#define BURST_AMOUNT_TIER_2 2
#define BURST_AMOUNT_TIER_3 3
#define BURST_AMOUNT_TIER_4 4
#define BURST_AMOUNT_TIER_5 5
#define BURST_AMOUNT_TIER_6 6

/*
////EXTRA////
*/

//How quickly we reset our accuracy after firing.
#define SETTLE_ACCURACY_MULTIPLIER 4

//How quickly scatter settles after firing.
#define SETTLE_SCATTER_MULTIPLIER 2

/*
////SHRAPNEL CHANCE////
// % chance for shrapnel generation when getting hit by something.
*/

#define SHRAPNEL_CHANCE_TIER_1 10
#define SHRAPNEL_CHANCE_TIER_2 20
#define SHRAPNEL_CHANCE_TIER_3 30
#define SHRAPNEL_CHANCE_TIER_4 40
#define SHRAPNEL_CHANCE_TIER_5 50
#define SHRAPNEL_CHANCE_TIER_6 60
#define SHRAPNEL_CHANCE_TIER_7 70
#define SHRAPNEL_CHANCE_TIER_8 80
#define SHRAPNEL_CHANCE_TIER_9 90
#define SHRAPNEL_CHANCE_TIER_10 100

/*
////AMMO TRAVEL SPEED////
//How many tiles it travels per tick.
*/

#define AMMO_SPEED_TIER_1 1
#define AMMO_SPEED_TIER_2 2
#define AMMO_SPEED_TIER_3 3
#define AMMO_SPEED_TIER_4 4
#define AMMO_SPEED_TIER_5 5
#define AMMO_SPEED_TIER_6 6

/*
////ARMOR PENETRATION////
//See Neth's armor comments for how this works. Higher is better.
*/

#define ARMOR_PENETRATION_TIER_1 5
#define ARMOR_PENETRATION_TIER_2 10
#define ARMOR_PENETRATION_TIER_3 15
#define ARMOR_PENETRATION_TIER_4 20
#define ARMOR_PENETRATION_TIER_5 25
#define ARMOR_PENETRATION_TIER_6 30
#define ARMOR_PENETRATION_TIER_7 35
#define ARMOR_PENETRATION_TIER_8 40
#define ARMOR_PENETRATION_TIER_9 45
#define ARMOR_PENETRATION_TIER_10 50

/*
////EXTRA PROJECTILES////
//Extra bullets to shoot when you shoot. Mostly for shotguns.
*/

#define EXTRA_PROJECTILES_TIER_1 1
#define EXTRA_PROJECTILES_TIER_2 2
#define EXTRA_PROJECTILES_TIER_3 3
#define EXTRA_PROJECTILES_TIER_4 4
#define EXTRA_PROJECTILES_TIER_5 5
#define EXTRA_PROJECTILES_TIER_6 6
#define EXTRA_PROJECTILES_TIER_7 7
#define EXTRA_PROJECTILES_TIER_8 8
#define EXTRA_PROJECTILES_TIER_9 9
#define EXTRA_PROJECTILES_TIER_10 10

/*
////PROJECTILE VARIANCE////
//How much do we want to make a value variable? Used for accuracy, damage variance. Used in ammo_datums.dm
*/

#define PROJECTILE_VARIANCE_TIER_1 18
#define PROJECTILE_VARIANCE_TIER_2 16
#define PROJECTILE_VARIANCE_TIER_3 14
#define PROJECTILE_VARIANCE_TIER_4 12
#define PROJECTILE_VARIANCE_TIER_5 10
#define PROJECTILE_VARIANCE_TIER_6 8
#define PROJECTILE_VARIANCE_TIER_7 6
#define PROJECTILE_VARIANCE_TIER_8 4
#define PROJECTILE_VARIANCE_TIER_9 2
#define PROJECTILE_VARIANCE_TIER_10 0

/*
////FLAMER STUFF////
Burn level = How much damage do we want to deal? Simple
Burn time = How long do we want our flames to last?
Fire Variant = Markers for special fire types that behave outside of chemfire constraints. Comment general notes.
*/

#define BURN_LEVEL_TIER_1 10
#define BURN_LEVEL_TIER_2 15
#define BURN_LEVEL_TIER_3 20
#define BURN_LEVEL_TIER_4 25
#define BURN_LEVEL_TIER_5 30
#define BURN_LEVEL_TIER_6 35
#define BURN_LEVEL_TIER_7 40
#define BURN_LEVEL_TIER_8 45
#define BURN_LEVEL_TIER_9 50

#define BURN_TIME_INSTANT 1
#define BURN_TIME_TIER_1 10
#define BURN_TIME_TIER_2 20
#define BURN_TIME_TIER_3 30
#define BURN_TIME_TIER_4 40
#define BURN_TIME_TIER_5 50

///Default fire behavior: No associated values.
#define FIRE_VARIANT_DEFAULT 0
///"Type B" Armor Shredding Greenfire: Burn Time T5, Burn Level T2, Slows on Tile, Increased Tile Damage, Easier Extinguishing.
#define FIRE_VARIANT_TYPE_B 1
// Lowers burn damage to humans
#define HUMAN_BURN_DIVIDER 5

//gun.dm durabilty flags
#define GUN_DURABILITY_MAX 100
#define GUN_DURABILITY_HIGH 80
#define GUN_DURABILITY_MEDIUM 50
#define GUN_DURABILITY_LOW 20
#define GUN_DURABILITY_BROKEN 0

//gun innate durability loss defines, note that GUN_DURABILITY_LOSS_NONE also disables misfiring
#define GUN_DURABILITY_LOSS_NONE 0
#define GUN_DURABILITY_LOSS_DEFAULT 0.05
#define GUN_DURABILITY_LOSS_INSUBSTANTIAL 0.15
#define GUN_DURABILITY_LOSS_LOW 0.20
#define GUN_DURABILITY_LOSS_FAIR 0.35
#define GUN_DURABILITY_LOSS_MEDIUM 0.40
#define GUN_DURABILITY_LOSS_HIGH 0.55
#define GUN_DURABILITY_LOSS_SEVERE 0.60
#define GUN_DURABILITY_LOSS_CRITICAL 0.65
#define GUN_DURABILITY_LOSS_DESTRUCTIVE 0.70
#define GUN_DURABILITY_LOSS_SCOUT 10
#define GUN_DURABILITY_LOSS_SNIPER 25
#define GUN_DURABILITY_LOSS_SMARTGUN 1
#define GUN_DURABILITY_LOSS_GUARANTEED 100

//gun innate unjam chance
#define GUN_UNJAM_CHANCE_INSUBSTANTIAL 25
#define GUN_UNJAM_CHANCE_LOW 50
#define GUN_UNJAM_CHANCE_FAIR 75
#define GUN_UNJAM_CHANCE_MEDIUM 85
#define GUN_UNJAM_CHANCE_HIGH 90
#define GUN_UNJAM_CHANCE_DEFAULT 95
#define GUN_UNJAM_CHANCE_RELIABLE 100
#define GUN_UNJAM_CHANCE_SCOUT 69

//gun innate jam chance
#define GUN_JAM_CHANCE_INSUBSTANTIAL 0.01
#define GUN_JAM_CHANCE_LOW 0.05
#define GUN_JAM_CHANCE_FAIR 0.10
#define GUN_JAM_CHANCE_MEDIUM 0.15
#define GUN_JAM_CHANCE_HIGH 0.20
#define GUN_JAM_CHANCE_SEVERE 0.25
#define GUN_JAM_CHANCE_CRITICAL 0.30
#define GUN_JAM_CHANCE_SCOUT 0.25
#define GUN_JAM_CHANCE_SNIPER 0.05


//bullet durability loss defines
#define BULLET_DURABILITY_LOSS_INSUBSTANTIAL 0.05
#define BULLET_DURABILITY_LOSS_LOW 0.10
#define BULLET_DURABILITY_LOSS_FAIR 0.15
#define BULLET_DURABILITY_LOSS_MEDIUM 0.20
#define BULLET_DURABILITY_LOSS_HIGH 0.25
#define BULLET_DURABILITY_LOSS_SEVERE 0.30
#define BULLET_DURABILITY_LOSS_CRITICAL 0.35
#define BULLET_DURABILITY_LOSS_SMALL_RUBBER 0.35
#define BULLET_DURABILITY_LOSS_LONG_RUBBER 0.50
#define BULLET_DURABILITY_LOSS_SPECIAL 0.50

//bullet durability damage defines
#define BULLET_DURABILITY_DAMAGE_DEFAULT 1
#define BULLET_DURABILITY_DAMAGE_INSUBSTANTIAL 2
#define BULLET_DURABILITY_DAMAGE_LOW 3
#define BULLET_DURABILITY_DAMAGE_FAIR 4
#define BULLET_DURABILITY_DAMAGE_MEDIUM 5
#define BULLET_DURABILITY_DAMAGE_HIGH 6
#define BULLET_DURABILITY_DAMAGE_SEVERE 7
#define BULLET_DURABILITY_DAMAGE_CRITICAL 8
#define BULLET_DURABILITY_DAMAGE_DESTRUCTIVE 9
#define BULLET_DURABILITY_DAMAGE_SPECIAL 10


//magazine jamming loss defines
#define MAG_JAM_MOD_PISTOL_LOW 0.05
#define MAG_JAM_MOD_PISTOL_FAIR 0.10
#define MAG_JAM_MOD_PISTOL_MEDIUM 0.15
#define MAG_JAM_MOD_PISTOL_HIGH 0.20
#define MAG_JAM_MOD_PISTOL_CRITICAL 0.30
#define MAG_JAM_MOD_PISTOL_RUBBER 0.25

#define MAG_JAM_MOD_RIFLE_INSUBSTANTIAL 0.10
#define MAG_JAM_MOD_RIFLE_LOW 0.15
#define MAG_JAM_MOD_RIFLE_FAIR 0.20
#define MAG_JAM_MOD_RIFLE_MEDIUM 0.25
#define MAG_JAM_MOD_RIFLE_HIGH 0.30
#define MAG_JAM_MOD_RIFLE_CRITICAL 0.35
#define MAG_JAM_MOD_RIFLE_RUBBER 0.50


