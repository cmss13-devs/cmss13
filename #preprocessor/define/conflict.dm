//Grab levels
#define GRAB_PASSIVE	0
#define GRAB_AGGRESSIVE	1
#define GRAB_NECK		2
#define GRAB_KILL		3

//Ammo defines for gun/projectile related things.
#define AMMO_EXPLOSIVE 			1
#define AMMO_XENO_ACID 			2
#define AMMO_XENO_TOX			4
#define AMMO_ENERGY 			8
#define AMMO_ROCKET				16
#define AMMO_SNIPER				32
#define AMMO_INCENDIARY			64
#define AMMO_ANTISTRUCT         128 // Primarily for railgun but can be implemented for other projectiles that are for antitank and antistructure (wall/machine)
#define AMMO_SKIPS_HUMANS		256
#define AMMO_SKIPS_ALIENS 		512
#define AMMO_IS_SILENCED 		1024 //Unused right now.
#define AMMO_IGNORE_ARMOR		2048
#define AMMO_IGNORE_RESIST		4096
#define AMMO_BALLISTIC			8192
#define AMMO_IGNORE_COVER		16384
#define AMMO_SCANS_NEARBY		32768 //ammo that is scanning stuff nearby - VERY resource intensive
#define AMMO_STOPPED_BY_COVER	65536
#define AMMO_SPECIAL_EMBED      131072
#define AMMO_STRIKES_SURFACE    262144 // If the projectile hits a dense turf it'll do on_hit_turf on the turf just in front of the turf instead of on the turf itself
#define AMMO_HITS_TARGET_TURF   524288 // Whether or not the bullet hits the target that was clicked or if it keeps travelling
#define AMMO_ALWAYS_FF          1048576

//Gun defines for gun related thing. More in the projectile folder.
#define GUN_CAN_POINTBLANK		1
#define GUN_TRIGGER_SAFETY		2
#define GUN_UNUSUAL_DESIGN		4
#define GUN_SILENCED			8
#define GUN_AUTOMATIC			16
#define GUN_INTERNAL_MAG		32
#define GUN_AUTO_EJECTOR		64
#define GUN_AMMO_COUNTER		128
#define GUN_BURST_ON			256
#define GUN_BURST_FIRING		512
#define GUN_FLASHLIGHT_ON		1024
#define GUN_WY_RESTRICTED		2048
#define GUN_SPECIALIST			4096
#define GUN_WIELDED_FIRING_ONLY	8192
#define GUN_HAS_FULL_AUTO		16384
#define GUN_FULL_AUTO_ON		32768
#define GUN_ONE_HAND_WIELDED    65536 //removes one-hand accuracy penalty
#define GUN_ANTIQUE 			131072
#define GUN_RECOIL_BUILDUP      262144

//Gun attachable related flags.
#define ATTACH_REMOVABLE	1
#define ATTACH_ACTIVATION	2
#define ATTACH_PROJECTILE	4 //for attachments that fire bullets
#define ATTACH_RELOADABLE	8
#define ATTACH_WEAPON		16 //is a weapon that fires stuff
#define ATTACH_MELEE        32 //This attachment should activate if you attack() with it attached.
//Ammo magazine defines, for flags_magazine
#define AMMUNITION_REFILLABLE	1
#define AMMUNITION_HANDFUL		2
#define AMMUNITION_HIDE_AMMO    4

//Slowdown from various armors.
#define SHOES_SLOWDOWN -1.0			// How much shoes slow you down by default. Negative values speed you up
#define SLOWDOWN_ARMOR_NONE         0
#define SLOWDOWN_ARMOR_VERY_LIGHT	0.20
#define SLOWDOWN_ARMOR_LIGHT		0.35
#define SLOWDOWN_ARMOR_MEDIUM		0.55
#define SLOWDOWN_ARMOR_LOWHEAVY		0.75
#define SLOWDOWN_ARMOR_HEAVY		1
#define SLOWDOWN_ARMOR_VERY_HEAVY	1.15

#define SLOWDOWN_ADS_SMG				0.75
#define SLOWDOWN_ADS_SHOTGUN			0.75 //anything below that doesn't change anything.
#define SLOWDOWN_ADS_RIFLE				1
#define SLOWDOWN_ADS_SCOPE				1.20
#define SLOWDOWN_ADS_LMG				1.75
#define SLOWDOWN_ADS_INCINERATOR		1.75
#define SLOWDOWN_ADS_SPECIALIST			1.75
#define SLOWDOWN_ADS_MINISCOPE_DYNAMIC	2
#define SLOWDOWN_ADS_SUPERWEAPON		2.75

//Wield delays, in milliseconds. 10 is 1 second
#define WIELD_DELAY_VERY_FAST		2
#define WIELD_DELAY_FAST			4
#define WIELD_DELAY_NORMAL			6
#define WIELD_DELAY_SLOW			8
#define WIELD_DELAY_VERY_SLOW		10
#define WIELD_DELAY_HORRIBLE		12

//Explosion level thresholds. Upper bounds
#define EXPLOSION_THRESHOLD_VLOW	50
#define EXPLOSION_THRESHOLD_LOW		100
#define EXPLOSION_THRESHOLD_MLOW	150
#define EXPLOSION_THRESHOLD_MEDIUM	200
#define EXPLOSION_THRESHOLD_HIGH	300

#define EXPLOSION_THRESHOLD_GIB		200 //how much it takes to gib a mob
#define EXPLOSION_PRONE_MULTIPLIER	0.5 //prone mobs recieve less damage from explosions

//Explosion damage multipliers for different objects
#define EXPLOSION_DAMAGE_MULTIPLIER_DOOR     	15
#define EXPLOSION_DAMAGE_MULTIPLIER_WALL		15
#define EXPLOSION_DAMAGE_MULTIPLIER_WINDOW		10

//Additional explosion damage modifier for open doors
#define EXPLOSION_DAMAGE_MODIFIER_DOOR_OPEN		0.5

//Melee weapons and xenos do more damage to resin structures
#define RESIN_MELEE_DAMAGE_MULTIPLIER	8.2
#define RESIN_XENO_DAMAGE_MULTIPLIER    4

#define RESIN_EXPLOSIVE_MULTIPLIER 0.5

//Projectile block probabilities for different types of cover
#define PROJECTILE_COVERAGE_LOW			35
#define PROJECTILE_COVERAGE_MEDIUM		60
#define PROJECTILE_COVERAGE_HIGH		85
//=================================================

#define FALLOFF_PER_TILE 0.01 //1 % per 1 tile per 1 normalcy
#define FALLOFF_DISTANCE_POWER 1.4

#define ARMOR_MELEE 1
#define ARMOR_BULLET 2
#define ARMOR_LASER 4
#define ARMOR_ENERGY 8
#define ARMOR_BOMB 16
#define ARMOR_BIO 32
#define ARMOR_RAD 64
#define ARMOR_INTERNALDAMAGE 128

#define ARMOR_SHARP_INTERNAL_PENETRATION 10

// Related to damage that ANTISTRUCT ammo types deal to structures
#define ANTISTRUCT_DMG_MULT_BARRICADES 1.45
#define ANTISTRUCT_DMG_MULT_WALL 2.5
#define ANTISTRUCT_DMG_MULT_TANK 1.5

// human armor
#define CLOTHING_ARMOR_NONE 0
#define CLOTHING_ARMOR_LOW 10
#define CLOTHING_ARMOR_MEDIUMLOW 15
#define CLOTHING_ARMOR_MEDIUM 20
#define CLOTHING_ARMOR_MEDIUMHIGH 25
#define CLOTHING_ARMOR_HIGH 30
#define CLOTHING_ARMOR_HIGHPLUS 35
#define CLOTHING_ARMOR_VERYHIGH 40
#define CLOTHING_ARMOR_ULTRAHIGH 50
#define CLOTHING_ARMOR_HARDCORE 100

//OB timings
#define OB_TRAVEL_TIMING 12 SECONDS
#define OB_CRASHING_DOWN 1 SECONDS
//=================================================

//Health of various items
#define HEALTH_WALL 						3000
#define HEALTH_WALL_REINFORCED 				9000
#define HEALTH_WALL_XENO 					900
#define HEALTH_WALL_XENO_THICK 				1350
#define HEALTH_WALL_XENO_MEMBRANE 			300
#define HEALTH_WALL_XENO_MEMBRANE_THICK 	600

#define HEALTH_DOOR 		    2000
#define HEALTH_DOOR_XENO 	    600
#define HEALTH_DOOR_XENO_THICK 	900

#define HEALTH_RESIN_XENO_STICKY 45
#define HEALTH_RESIN_XENO_FAST 30

#define THROWFORCE_COEFF            0.02 // Coefficient of throwforce when calculating damage from an atom colliding with a mob
#define MOB_SIZE_COEFF              20 // Coefficient of mobsize when calculating damage from a mob colliding with a dense atom
#define THROW_SPEED_DENSE_COEFF     0.2 // Coefficient of throwspeed when calculating damage from a mob colliding with a dense atom
#define THROW_SPEED_IMPACT_COEFF    0.05 // Coefficient of throwspeed when calculating damage from an atom colliding with a mob

#define THROW_MODE_OFF      0
#define THROW_MODE_NORMAL   1
#define THROW_MODE_HIGH     2

#define XENO_ACID_BARRICADE_DAMAGE 8

#define MOLOTOV_POTENCY_MAX 20
#define MOLOTOV_TIME_MAX    20

#define GUN_LOW_AMMO_PERCENTAGE 0.25 // A gun filled with this percentage of it's total ammo or lower is considered to have low ammo

// Fire
#define MAX_FIRE_STACKS 45
#define MIN_FIRE_STACKS -20
#define XENO_FIRE_RESIST_AMOUNT -10
#define HUMAN_FIRE_RESIST_AMOUNT -10
#define HUNTER_FIRE_RESIST_AMOUNT -25

// Organ damage chance
#define DMG_ORGAN_DAM_PROB_MULT (2/9)   // The multiplier to damage when calculating organ damage probability
#define BRUTE_ORGAN_DAM_PROB_MULT (0.05) // The multiplier to existing brute damage when calculating organ damage probability