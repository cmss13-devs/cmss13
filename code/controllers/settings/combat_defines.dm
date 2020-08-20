#define HUMAN_UNIVERSAL_DAMAGEMULT 1.0

#define RECOIL_BUILDUP_VIEWPUNCH_MULTIPLIER 0.1

/* THE SOOPER SEKRIT WEAPON CONFIG.

////PART 1: UNDERSTANDING HOW TO READ THE VARIABLES.////

//MULT VARIABLES//
On variables with (mult) in the name, a high value is better, a low value is worse. The base config on all multiplication variables SHOULD BE 1.

1 = 100%

We add or subtract the other defined values from that base value in the WEAPON config (Not ammo, but also ammo, context dependent. Welcome to Hell.)
The actual multiplication happens further down the line through Byond magicks. In short, don't actually multiply values by the multiplier values. Only add or subtract.
EX:

config.base_example_mult (1) + config.min_example_mult (0.05) = 1.05 => 105%


//SHRAPNEL CHANCE & ARMOR PENETRATION//
These are % variables. Its out of 100. Real braindead.

//NAMING CONVENTIONS//
There are none, but going forward, you should follow this example:

min_example_var = 1
mlow_example_var = 2
low_example_var = 3
hlow_example_var = 4
etc..

Append (m) or (h) for small numeric variations off of a new value.
Always define a new value unless you want to tweak things globally (probably a bad idea)

Sometimes there's a huge variance between high_example_var and ultra_example_var.
There's no theory to this, sorry if you thought there was. Most of the super values are unused anyway.
However, should you need a value that's inbetween them, define a newone following the just described naming conventions.

//EVERYTHING ELSE//
If it wasn't mentioned, it is probably self evident.
A good rule of thumb would be High = Bad, Low = Good.
Except for accuracy. Otherway around.
Take a peak at the actual weapons to see how things work if you're confused.

Happy developing future codermans.
*/

////PART TWO, BREAKING DOWN HOW EACH VARIABLE GETS USED & DEFINING THEM////

/*
////SETUP///
These variables are multipliers established for the projectile system itself.
DON'T TOUCH 'EM.
*/

/datum/configuration
	var/proj_base_accuracy_mult = 0.01
	var/proj_base_damage_mult = 0.01

	var/proj_variance_high = 105
	var/proj_variance_low = 98

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
	var/min_hit_accuracy = 2
	var/low_hit_accuracy = 7
	var/med_hit_accuracy = 13
	var/hmed_hit_accuracy = 21
	var/high_hit_accuracy = 27
	var/max_hit_accuracy = 40

	var/base_hit_accuracy_mult = 1 //Multiplication settings for accuracy. Only ever add or subtract from the base value.
	var/min_hit_accuracy_mult = 0.05
	var/low_hit_accuracy_mult = 0.13
	var/med_hit_accuracy_mult = 0.19
	var/hmed_hit_accuracy_mult = 0.24
	var/high_hit_accuracy_mult = 0.37
	var/max_hit_accuracy_mult = 0.50

	var/no_movement_accuracy_penalty_mult = 0
	var/low_movement_accuracy_penalty_mult = 1
	var/mlow_movement_accuracy_penalty_mult = 2
	var/med_movement_accuracy_penalty_mult = 3
	var/high_movement_accuracy_penalty_mult = 5
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
	var/no_hit_damage = 0 * HUMAN_UNIVERSAL_DAMAGEMULT
	var/base_hit_damage = 10 * HUMAN_UNIVERSAL_DAMAGEMULT//Self evident.
	var/min_hit_damage = 15 * HUMAN_UNIVERSAL_DAMAGEMULT
	var/mlow_hit_damage = 18 * HUMAN_UNIVERSAL_DAMAGEMULT
	var/low_hit_damage = 23 * HUMAN_UNIVERSAL_DAMAGEMULT
	var/hlow_hit_damage = 25 * HUMAN_UNIVERSAL_DAMAGEMULT
	var/hlmed_hit_damage = 27 * HUMAN_UNIVERSAL_DAMAGEMULT
	var/lmed_hit_damage = 30 * HUMAN_UNIVERSAL_DAMAGEMULT
	var/lmed_plus_hit_damage = 34 * HUMAN_UNIVERSAL_DAMAGEMULT
	var/med_hit_damage = 37 * HUMAN_UNIVERSAL_DAMAGEMULT // Old M41 damage
	var/hmed_hit_damage = 41 * HUMAN_UNIVERSAL_DAMAGEMULT //  M41A-MK2 (Stock Pulse Rifle) for reference
	var/lhigh_hit_damage = 46 * HUMAN_UNIVERSAL_DAMAGEMULT
	var/high_hit_damage = 54 * HUMAN_UNIVERSAL_DAMAGEMULT
	var/mhigh_hit_damage = 61 * HUMAN_UNIVERSAL_DAMAGEMULT
	var/max_hit_damage = 70 * HUMAN_UNIVERSAL_DAMAGEMULT
	var/super_hit_damage = 97 * HUMAN_UNIVERSAL_DAMAGEMULT
	var/ultra_hit_damage = 122 * HUMAN_UNIVERSAL_DAMAGEMULT

	var/base_hit_damage_mult = 1 //Multiplication settings for damage. Only ever add or subtract from the base value.
	var/min_hit_damage_mult = 0.06
	var/low_hit_damage_mult = 0.12
	var/med_hit_damage_mult = 0.21
	var/hmed_hit_damage_mult = 0.28
	var/high_hit_damage_mult = 0.35
	var/max_hit_damage_mult = 0.45

/*
////FLAMER STUFF////
Burn level = How much damage do we want to deal? Simple
Burn time = How long do we want our flames to last?
*/


	var/min_burnlevel = 10 * HUMAN_UNIVERSAL_DAMAGEMULT
	var/low_burnlevel = 15 * HUMAN_UNIVERSAL_DAMAGEMULT
	var/med_burnlevel = 30 * HUMAN_UNIVERSAL_DAMAGEMULT //This tickles aliens, really hurts humans.
	var/high_burnlevel = 40 * HUMAN_UNIVERSAL_DAMAGEMULT
	var/max_burnlevel = 50 * HUMAN_UNIVERSAL_DAMAGEMULT

	var/instant_burntime = 1 //For gel fuel.
	var/min_burntime = 10
	var/low_burntime = 20
	var/med_burntime = 30
	var/high_burntime = 40
	var/max_burntime = 50

	var/tactical_damage_falloff = 0.8 //MK221 Tactical, auto-shotty.
	var/reg_damage_falloff = 1 //in config it was 0.89 but referenced wrong var
	var/med_damage_falloff = 2
	var/buckshot_v2_damage_falloff = 3
	var/buckshot_damage_falloff = 5 //ditto but 18.3 (!!!)
	var/extra_damage_falloff = 10 //ditto but 9.75

	var/reg_damage_buildup = 1
	var/med_damage_buildup = 2
	var/high_damage_buildup = 3

	var/no_effective_range_min = 0 //Default so no weapon starts off with a minimum effective range
	var/min_effective_range_min = 1
	var/reg_effective_range_min = 4
	var/med_effective_range_min = 7 //Half a screen

	var/no_effective_range_max = 0 //Default so no weapon starts off with a maximum effective range, defaulting to the legacy damage falloff method
	var/min_effective_range_max = 3
	var/reg_effective_range_max = 6
	var/med_effective_range_max = 9
	var/high_effective_range_max = 22 //One full screen over

	var/min_burst_value = 1 //How many boolets exit your gun when you burst fire.
	var/low_burst_value = 2
	var/med_burst_value = 3
	var/high_burst_value = 4
	var/mhigh_burst_value = 5
	var/max_burst_value = 6

	var/min_fire_delay = 1 //How many ticks you have to wait between firing. Burst delay uses the same variable!
	var/mlow_fire_delay = 2
	var/low_fire_delay = 3
	var/lmed_fire_delay = 3.5
	var/med_fire_delay = 4
	var/high_fire_delay = 5
	var/mhigh_fire_delay = 6
	var/max_fire_delay = 7

	var/min_scatter_value = 1
	var/mlow_scatter_value = 2
	var/low_scatter_value = 3
	var/lmed_scatter_value = 4 
	var/med_scatter_value = 5 //SMG 2-hand, for reference.
	var/hmed_scatter_value = 6
	var/high_scatter_value = 7
	var/mhigh_scatter_value = 8
	var/max_scatter_value = 10 //Buckshot, for reference.
	var/super_scatter_value = 15
	var/ultra_scatter_value = 20
	var/giga_scatter_value = 40

	// How many shots on full auto before you hit max full auto scatter
	var/low_scatter_peak = 10
	var/med_scatter_peak = 20
	var/hmed_scatter_peak = 30
	var/high_scatter_peak = 40
	var/ultra_scatter_peak = 60
	var/giga_scatter_peak = 100

	var/no_recoil_value = 0
	var/min_recoil_value = 1 //Sliding scale of recoil 1-5. You can go higher, but it just gets silly.
	var/low_recoil_value = 2
	var/med_recoil_value = 3
	var/high_recoil_value = 4
	var/max_recoil_value = 5

	var/min_shrapnel_chance = 3 // % chance for shrapnel generation when getting hit by something.
	var/low_shrapnel_chance = 9
	var/med_shrapnel_chance = 24
	var/high_shrapnel_chance = 45
	var/max_shrapnel_chance = 75
/*
////SHELL RANGES////
Shell ranges = tiles.
A range of 7 is screen max.
~12 is miniscope/IFF
~18 is railscope.
We don't really use the higher values, but they're there.
*/
	var/min_shell_range = 4 //How many tiles should our gun/bullet stay accurate? Maps are generally 256x256, so keep that in mind. Player screen width is 7x7 tiles.
	var/close_shell_range = 5
	var/near_shell_range = 7
	var/lshort_shell_range = 9
	var/short_shell_range = 11
	var/hshort_shell_range = 13
	var/moderate_shell_range = 16
	var/lnorm_shell_range = 19
	var/norm_shell_range = 22
	var/hnorm_shell_range = 25
	var/long_shell_range = 33
	var/max_shell_range = 44

	var/slow_shell_speed = 1 //How many tiles it travels per tick.
	var/reg_shell_speed = 2
	var/fast_shell_speed = 3
	var/super_shell_speed = 4
	var/ultra_shell_speed = 6

	var/min_armor_penetration = 5 //See Neth's armor comments for how this works. Higher is better.
	var/vlow_armor_penetration = 8 
	var/mlow_armor_penetration = 12
	var/low_armor_penetration = 23
	var/hlow_armor_penetration = 26
	var/med_armor_penetration = 31
	var/hmed_armor_penetration = 36
	var/high_armor_penetration = 48
	var/mhigh_armor_penetration = 66
	var/max_armor_penetration = 87

	var/min_proj_extra = 1 //Extra bullets to shoot when you shoot. Mostly for shotguns.
	var/low_proj_extra = 2
	var/med_proj_extra = 3
	var/high_proj_extra = 5
	var/max_proj_extra = 8

	var/min_proj_variance = 1 //How much do we want to make a value variable? Used for accuracy, damage variance. Used in ammo_datums.dm
	var/low_proj_variance = 3
	var/med_proj_variance = 7
	var/high_proj_variance = 9
	var/max_proj_variance = 12

	//weapon settling multiplier
	var/weapon_settle_accuracy_multiplier = 4 //How quickly we reset our accuracy after firing.
	var/weapon_settle_scatter_multiplier = 2 //How quickly scatter settles after firing.

	//roundstart stuff
	var/xeno_number_divider = 4 //What weight do we want to give towards considering roundstart survivors & xenos from readied players.
	var/surv_number_divider = 20

	var/datum/combat_configuration/marine_melee //This is all used in the new fancy xeno & marine armor code. See Neth's documentation on what these do.
	var/datum/combat_configuration/marine_ranged
	var/datum/combat_configuration/marine_ranged_stats
	var/datum/combat_configuration/marine_explosive
	var/datum/combat_configuration/marine_fire
	var/datum/combat_configuration/marine_organ_damage

	var/datum/combat_configuration/xeno_melee
	var/datum/combat_configuration/xeno_ranged
	var/datum/combat_configuration/xeno_ranged_stats
	var/datum/combat_configuration/xeno_explosive
	var/datum/combat_configuration/xeno_explosive_small
	var/datum/combat_configuration/xeno_fire

/*
////SLOWDOWN MODS////
*/
	var/slowdown_none = 0
	var/slowdown_low = 0.10
	var/slowdown_med = 0.25
	var/slowdown_high = 0.40


/datum/configuration/proc/load_combat_config() //Translate of our config vars into datums for ease of usage within the armor equations.
	marine_melee = new /datum/combat_configuration/marine/melee()
	marine_ranged = new /datum/combat_configuration/marine/ranged()
	marine_ranged_stats = new /datum/combat_configuration/marine/ranged/stats()
	marine_explosive = new /datum/combat_configuration/marine/explosive()
	marine_fire = new /datum/combat_configuration/marine/fire()
	marine_organ_damage = new /datum/combat_configuration/marine/organ_damage()

	xeno_melee = new /datum/combat_configuration/xeno/melee()
	xeno_ranged = new /datum/combat_configuration/xeno/ranged()
	xeno_ranged_stats = new /datum/combat_configuration/xeno/ranged/stats()
	xeno_explosive = new /datum/combat_configuration/xeno/explosive()
	xeno_explosive_small = new /datum/combat_configuration/xeno/explosive/small()
	xeno_fire = new /datum/combat_configuration/xeno/fire()

