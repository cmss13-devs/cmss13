#define HUMAN_UNIVERSAL_DAMAGEMULT 1.0

#define RECOIL_BUILDUP_VIEWPUNCH_MULTIPLIER 0.1


#define PROJ_BASE_ACCURACY_MULT	 	0.01
#define PROJ_BASE_DAMAGE_MULT		0.01

#define PROJ_VARIANCE_HIGH	105
#define PROJ_VARIANCE_LOW	98

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

#define HIT_ACCURACY_TIER_1		5
#define HIT_ACCURACY_TIER_2		10
#define HIT_ACCURACY_TIER_3		15
#define HIT_ACCURACY_TIER_4		20
#define HIT_ACCURACY_TIER_5		25
#define HIT_ACCURACY_TIER_6		30
#define HIT_ACCURACY_TIER_7 	35
#define HIT_ACCURACY_TIER_8 	40
#define HIT_ACCURACY_TIER_9 	45
#define HIT_ACCURACY_TIER_10 	50

#define BASE_ACCURACY_MULT 1
#define HIT_ACCURACY_MULT_TIER_1 	0.05
#define HIT_ACCURACY_MULT_TIER_2 	0.10
#define HIT_ACCURACY_MULT_TIER_3 	0.15
#define HIT_ACCURACY_MULT_TIER_4 	0.20
#define HIT_ACCURACY_MULT_TIER_5 	0.25
#define HIT_ACCURACY_MULT_TIER_6 	0.30
#define HIT_ACCURACY_MULT_TIER_7 	0.35
#define HIT_ACCURACY_MULT_TIER_8 	0.40
#define HIT_ACCURACY_MULT_TIER_9 	0.45
#define HIT_ACCURACY_MULT_TIER_10 	0.50

#define MOVEMENT_ACCURACY_PENALTY_MULT_TIER_1 5
#define MOVEMENT_ACCURACY_PENALTY_MULT_TIER_2 4
#define MOVEMENT_ACCURACY_PENALTY_MULT_TIER_3 3
#define MOVEMENT_ACCURACY_PENALTY_MULT_TIER_4 2
#define MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5 1
#define MOVEMENT_ACCURACY_PENALTY_MULT_TIER_6 0

/*
////SCATTER////
*/

#define SCATTER_AMOUNT_NEURO 40
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

/*
////FULL AUTO SCATTER PEAK////
// How many shots on full auto before you hit max full auto scatter
*/

#define FULL_AUTO_SCATTER_PEAK_TIER_1	10
#define FULL_AUTO_SCATTER_PEAK_TIER_2	20
#define FULL_AUTO_SCATTER_PEAK_TIER_3	30
#define FULL_AUTO_SCATTER_PEAK_TIER_4	40
#define FULL_AUTO_SCATTER_PEAK_TIER_5	50
#define FULL_AUTO_SCATTER_PEAK_TIER_6	60
#define FULL_AUTO_SCATTER_PEAK_TIER_7	70
#define FULL_AUTO_SCATTER_PEAK_TIER_8	80
#define FULL_AUTO_SCATTER_PEAK_TIER_9	90
#define FULL_AUTO_SCATTER_PEAK_TIER_10	100

/*
////RECOIL////
*/

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

#define BULLET_DAMAGE_OFF 	0
#define BULLET_DAMAGE_TIER_1 	5 * HUMAN_UNIVERSAL_DAMAGEMULT
#define BULLET_DAMAGE_TIER_2 	10 * HUMAN_UNIVERSAL_DAMAGEMULT
#define BULLET_DAMAGE_TIER_3 	15 * HUMAN_UNIVERSAL_DAMAGEMULT
#define BULLET_DAMAGE_TIER_4 	20 * HUMAN_UNIVERSAL_DAMAGEMULT
#define BULLET_DAMAGE_TIER_5 	25 * HUMAN_UNIVERSAL_DAMAGEMULT
#define BULLET_DAMAGE_TIER_6 	30 * HUMAN_UNIVERSAL_DAMAGEMULT
#define BULLET_DAMAGE_TIER_7 	35 * HUMAN_UNIVERSAL_DAMAGEMULT
#define BULLET_DAMAGE_TIER_8 	40 * HUMAN_UNIVERSAL_DAMAGEMULT
#define BULLET_DAMAGE_TIER_9 	45 * HUMAN_UNIVERSAL_DAMAGEMULT
#define BULLET_DAMAGE_TIER_10 	50 * HUMAN_UNIVERSAL_DAMAGEMULT
#define BULLET_DAMAGE_TIER_11 	55 * HUMAN_UNIVERSAL_DAMAGEMULT
#define BULLET_DAMAGE_TIER_12 	60 * HUMAN_UNIVERSAL_DAMAGEMULT
#define BULLET_DAMAGE_TIER_13 	65 * HUMAN_UNIVERSAL_DAMAGEMULT
#define BULLET_DAMAGE_TIER_14 	70 * HUMAN_UNIVERSAL_DAMAGEMULT
#define BULLET_DAMAGE_TIER_15 	75 * HUMAN_UNIVERSAL_DAMAGEMULT
#define BULLET_DAMAGE_TIER_16 	80 * HUMAN_UNIVERSAL_DAMAGEMULT
#define BULLET_DAMAGE_TIER_17 	85 * HUMAN_UNIVERSAL_DAMAGEMULT
#define BULLET_DAMAGE_TIER_18 	90 * HUMAN_UNIVERSAL_DAMAGEMULT
#define BULLET_DAMAGE_TIER_19 	95 * HUMAN_UNIVERSAL_DAMAGEMULT
#define BULLET_DAMAGE_TIER_20 	100 * HUMAN_UNIVERSAL_DAMAGEMULT

#define BASE_BULLET_DAMAGE_MULT 1
#define BULLET_DAMAGE_MULT_TIER_1 	0.05
#define BULLET_DAMAGE_MULT_TIER_2 	0.10
#define BULLET_DAMAGE_MULT_TIER_3 	0.15
#define BULLET_DAMAGE_MULT_TIER_4 	0.20
#define BULLET_DAMAGE_MULT_TIER_5 	0.25
#define BULLET_DAMAGE_MULT_TIER_6 	0.30
#define BULLET_DAMAGE_MULT_TIER_7 	0.35
#define BULLET_DAMAGE_MULT_TIER_8 	0.40
#define BULLET_DAMAGE_MULT_TIER_9 	0.45
#define BULLET_DAMAGE_MULT_TIER_10 	0.50

/*
////FIRE DELAY////
//How many ticks you have to wait between firing. Burst delay uses the same variable!
*/

#define FIRE_DELAY_TIER_1 	10
#define FIRE_DELAY_TIER_2 	9
#define FIRE_DELAY_TIER_3 	8
#define FIRE_DELAY_TIER_4 	7
#define FIRE_DELAY_TIER_5 	6
#define FIRE_DELAY_TIER_6 	5
#define FIRE_DELAY_TIER_7 	4
#define FIRE_DELAY_TIER_8 	3
#define FIRE_DELAY_TIER_9 	2
#define FIRE_DELAY_TIER_10 	1

/*
////RANGE RELATED////
*/

#define DAMAGE_FALLOFF_TIER_1 	10
#define DAMAGE_FALLOFF_TIER_2 	9
#define DAMAGE_FALLOFF_TIER_3 	8
#define DAMAGE_FALLOFF_TIER_4 	7
#define DAMAGE_FALLOFF_TIER_5 	6
#define DAMAGE_FALLOFF_TIER_6 	5
#define DAMAGE_FALLOFF_TIER_7 	4
#define DAMAGE_FALLOFF_TIER_8 	3
#define DAMAGE_FALLOFF_TIER_9 	2
#define DAMAGE_FALLOFF_TIER_10 	1

#define DAMAGE_BUILDUP_TIER_1	1
#define DAMAGE_BUILDUP_TIER_2	2
#define DAMAGE_BUILDUP_TIER_3	3

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

#define SHRAPNEL_CHANCE_TIER_1		10
#define SHRAPNEL_CHANCE_TIER_2		20
#define SHRAPNEL_CHANCE_TIER_3		30
#define SHRAPNEL_CHANCE_TIER_4		40
#define SHRAPNEL_CHANCE_TIER_5		50
#define SHRAPNEL_CHANCE_TIER_6		60
#define SHRAPNEL_CHANCE_TIER_7		70
#define SHRAPNEL_CHANCE_TIER_8		80
#define SHRAPNEL_CHANCE_TIER_9		90
#define SHRAPNEL_CHANCE_TIER_10		100

/*
////AMMO TRAVEL SPEED////
//How many tiles it travels per tick.
*/

#define AMMO_SPEED_TIER_1	1
#define AMMO_SPEED_TIER_2	2
#define AMMO_SPEED_TIER_3	3
#define AMMO_SPEED_TIER_4	4
#define AMMO_SPEED_TIER_5	5
#define AMMO_SPEED_TIER_6	6

/*
////ARMOR PENETRATION////
//See Neth's armor comments for how this works. Higher is better.
*/

#define ARMOR_PENETRATION_TIER_1 	5
#define ARMOR_PENETRATION_TIER_2 	10
#define ARMOR_PENETRATION_TIER_3 	15
#define ARMOR_PENETRATION_TIER_4 	20
#define ARMOR_PENETRATION_TIER_5 	25
#define ARMOR_PENETRATION_TIER_6 	30
#define ARMOR_PENETRATION_TIER_7 	35
#define ARMOR_PENETRATION_TIER_8 	40
#define ARMOR_PENETRATION_TIER_9 	45
#define ARMOR_PENETRATION_TIER_10 	50

/*
////EXTRA PROJECTILES////
//Extra bullets to shoot when you shoot. Mostly for shotguns.
*/

#define EXTRA_PROJECTILES_TIER_1	1
#define EXTRA_PROJECTILES_TIER_2	2
#define EXTRA_PROJECTILES_TIER_3	3
#define EXTRA_PROJECTILES_TIER_4	4
#define EXTRA_PROJECTILES_TIER_5	5
#define EXTRA_PROJECTILES_TIER_6	6
#define EXTRA_PROJECTILES_TIER_7	7
#define EXTRA_PROJECTILES_TIER_8	8
#define EXTRA_PROJECTILES_TIER_9	9
#define EXTRA_PROJECTILES_TIER_10	10

/*
////PROJECTILE VARIANCE////
//How much do we want to make a value variable? Used for accuracy, damage variance. Used in ammo_datums.dm
*/

#define PROJECTILE_VARIANCE_TIER_1	18
#define PROJECTILE_VARIANCE_TIER_2	16
#define PROJECTILE_VARIANCE_TIER_3	14
#define PROJECTILE_VARIANCE_TIER_4	12
#define PROJECTILE_VARIANCE_TIER_5	10
#define PROJECTILE_VARIANCE_TIER_6	8
#define PROJECTILE_VARIANCE_TIER_7	6
#define PROJECTILE_VARIANCE_TIER_8	4
#define PROJECTILE_VARIANCE_TIER_9	2
#define PROJECTILE_VARIANCE_TIER_10	0

/*
////FLAMER STUFF////
Burn level = How much damage do we want to deal? Simple
Burn time = How long do we want our flames to last?
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