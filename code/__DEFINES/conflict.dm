//Grab levels
#define GRAB_PASSIVE 0
#define GRAB_AGGRESSIVE 1
#define GRAB_CARRY   2
#define GRAB_CHOKE   3

//Ammo defines for gun/projectile related things.

//Headshot overlay icoc states used for suicide and battlefield executions.
#define HEADSHOT_OVERLAY_LIGHT "light_headshot"
#define HEADSHOT_OVERLAY_MEDIUM "medium_headshot"
#define HEADSHOT_OVERLAY_HEAVY "heavy_headshot"

// flags_ammo_behaviour
#define AMMO_EXPLOSIVE (1<<0)
#define AMMO_ACIDIC (1<<1)
#define AMMO_XENO (1<<2)
#define AMMO_LASER (1<<3)
#define AMMO_ENERGY (1<<4)
#define AMMO_ROCKET (1<<5)
#define AMMO_SNIPER (1<<6)
/// Primarily for railgun but can be implemented for other projectiles that are for antitank and antistructure (wall/machine)
#define AMMO_ANTISTRUCT (1<<7)
#define AMMO_SKIPS_ALIENS (1<<8)
#define AMMO_IGNORE_ARMOR (1<<9)
#define AMMO_IGNORE_RESIST (1<<10)
#define AMMO_BALLISTIC (1<<11)
#define AMMO_IGNORE_COVER (1<<12)
#define AMMO_ANTIVEHICLE (1<<13)
#define AMMO_STOPPED_BY_COVER (1<<14)
#define AMMO_SPECIAL_EMBED (1<<15)
/// If the projectile hits a dense turf it'll do on_hit_turf on the turf just in front of the turf instead of on the turf itself
#define AMMO_STRIKES_SURFACE (1<<16)
/// Whether or not the bullet hits the target that was clicked or if it keeps travelling
#define AMMO_HITS_TARGET_TURF (1<<17)
#define AMMO_ALWAYS_FF (1<<18)
//                              (1<<19) unused, previously was AMMO_HOMING
/// Can't be deflected
#define AMMO_NO_DEFLECT (1<<20)
///Can only hit people with criminal status
#define AMMO_MP (1<<21)
/// Handles sentry flamers glob
#define AMMO_FLAME (1<<22)
// NOTE: Don't add flags past 1<<23, it'll break things due to BYOND limitations. You can usually use a Component instead.

/// Projectile is shrpanel which allow it to skip some collisions
#define PROJECTILE_SHRAPNEL  (1<<0)
/// Apply additional effects upon hitting clicked target
#define PROJECTILE_BULLSEYE  (1<<1)

//Gun defines for gun related thing. More in the projectile folder.

#define GUN_CAN_POINTBLANK (1<<0)
#define GUN_TRIGGER_SAFETY (1<<1)
#define GUN_UNUSUAL_DESIGN (1<<2)
#define GUN_SILENCED (1<<3)
#define GUN_CANT_EXECUTE (1<<4)
///If checking for ammo with current.mag you have to check it against numerical values, as booleans will not trigger.
#define GUN_INTERNAL_MAG (1<<5)
#define GUN_AUTO_EJECTOR (1<<6)
#define GUN_AMMO_COUNTER (1<<7)
#define GUN_BURST_FIRING (1<<8)
#define GUN_FLASHLIGHT_ON (1<<9)
#define GUN_WY_RESTRICTED (1<<10)
#define GUN_SPECIALIST (1<<11)
#define GUN_WIELDED_FIRING_ONLY (1<<12)
/// removes unwielded accuracy and scatter penalties (not recoil)
#define GUN_ONE_HAND_WIELDED (1<<13)
#define GUN_ANTIQUE (1<<14)
/// Whether the gun has been fired by its current user (reset upon `dropped()`)
#define GUN_RECOIL_BUILDUP (1<<15)
/// support weapon, bipod will grant autofire
#define GUN_SUPPORT_PLATFORM (1<<16)
/// No gun description, only base desc
#define GUN_NO_DESCRIPTION (1<<17)
// NOTE: Don't add flags past 1<<23, it'll break things due to BYOND limitations. You can usually use a Component instead.

#define USES_STREAKS (1<<0)
#define DANGEROUS_TO_ONEHAND_LEVER (1<<1)
#define MOVES_WHEN_LEVERING (1<<2)

//Gun attachable related flags.
#define ATTACH_REMOVABLE (1<<0)
#define ATTACH_ACTIVATION (1<<1)
/// for attachments that fire bullets
#define ATTACH_PROJECTILE (1<<2)
#define ATTACH_RELOADABLE (1<<3)
/// is a weapon that fires stuff
#define ATTACH_WEAPON (1<<4)
/// This attachment should override ignore if it is empty
#define ATTACH_IGNORE_EMPTY (1<<5)
/// This attachment should activate if you attack() with it attached.
#define ATTACH_MELEE (1<<6)
/// Override for attachies so you can fire them with a single hand . ONLY FOR PROJECTILES!!
#define ATTACH_WIELD_OVERRIDE (1<<7)

//Ammo magazine defines, for flags_magazine

#define AMMUNITION_REFILLABLE (1<<0)
#define AMMUNITION_HANDFUL (1<<1)
/// for dump_ammo_to(), boxes of handfuls like shotgun shell boxes
#define AMMUNITION_HANDFUL_BOX (1<<2)
#define AMMUNITION_HIDE_AMMO (1<<3)
#define AMMUNITION_CANNOT_REMOVE_BULLETS (1<<4)
/// If this magazine can transfer to other magazines of the same type by slapping one with the other
#define AMMUNITION_SLAP_TRANSFER (1<<5)
//Slowdown from various armors.

/// How much shoes slow you down by default. Negative values speed you up
#define SHOES_SLOWDOWN -1

#define SLOWDOWN_ARMOR_NONE 0
#define SLOWDOWN_ARMOR_SUPER_LIGHT 0.10
#define SLOWDOWN_ARMOR_VERY_LIGHT 0.20
#define SLOWDOWN_ARMOR_LIGHT 0.35
#define SLOWDOWN_ARMOR_MEDIUM 0.55
#define SLOWDOWN_ARMOR_LOWHEAVY 0.75
#define SLOWDOWN_ARMOR_HEAVY 1
#define SLOWDOWN_ARMOR_VERY_HEAVY 1.15

#define SLOWDOWN_ADS_NONE 0
#define SLOWDOWN_ADS_QUICK 0.35
#define SLOWDOWN_ADS_QUICK_MINUS 0.15 //this is stupid
#define SLOWDOWN_ADS_VERSATILE 0.50
#define SLOWDOWN_ADS_SHOTGUN 0.75
#define SLOWDOWN_ADS_RIFLE 1
#define SLOWDOWN_AMT_GREENFIRE 1.5
#define SLOWDOWN_ADS_SCOPE 1.20
#define SLOWDOWN_ADS_LMG 1.75
#define SLOWDOWN_ADS_INCINERATOR 1.75
#define SLOWDOWN_ADS_SPECIALIST 1.75
#define SLOWDOWN_ADS_MINISCOPE_DYNAMIC 1.8
#define SLOWDOWN_ADS_SUPERWEAPON 2.75

//Wield delays, in milliseconds. 10 is 1 second
#define WIELD_DELAY_NONE 0
#define WIELD_DELAY_MIN 1
#define WIELD_DELAY_VERY_FAST 2
#define WIELD_DELAY_FAST 4
#define WIELD_DELAY_NORMAL 6
#define WIELD_DELAY_SLOW 8
#define WIELD_DELAY_VERY_SLOW 10
#define WIELD_DELAY_HORRIBLE 12

///This is how long you must wait to throw again after throwing two things
#define THROW_DELAY (1.5 SECONDS)

//Explosion level thresholds. Upper bounds
#define EXPLOSION_THRESHOLD_VLOW 50
#define EXPLOSION_THRESHOLD_LOW 100
#define EXPLOSION_THRESHOLD_MLOW 150
#define EXPLOSION_THRESHOLD_MEDIUM 200
#define EXPLOSION_THRESHOLD_HIGH 300

/// how much it takes to gib a mob
#define EXPLOSION_THRESHOLD_GIB 200
/// prone mobs receive less damage from explosions
#define EXPLOSION_PRONE_MULTIPLIER 0.5

//Explosion damage multipliers for different objects
#define EXPLOSION_DAMAGE_MULTIPLIER_DOOR 15
#define EXPLOSION_DAMAGE_MULTIPLIER_WALL 15
#define EXPLOSION_DAMAGE_MULTIPLIER_WINDOW 10

//Additional explosion damage modifier for open doors
#define EXPLOSION_DAMAGE_MODIFIER_DOOR_OPEN 0.5

//Melee weapons and xenos do more damage to resin structures
#define RESIN_MELEE_DAMAGE_MULTIPLIER 8.2
#define RESIN_XENO_DAMAGE_MULTIPLIER 4

#define RESIN_EXPLOSIVE_MULTIPLIER 0.85

//Projectile block probabilities for different types of cover
#define PROJECTILE_COVERAGE_NONE 0
#define PROJECTILE_COVERAGE_MINIMAL 10
#define PROJECTILE_COVERAGE_LOW 35
#define PROJECTILE_COVERAGE_MEDIUM 60
#define PROJECTILE_COVERAGE_HIGH 85
#define PROJECTILE_COVERAGE_MAX 100
//=================================================

/// 1 % per 1 tile per 1 normalcy
#define FALLOFF_PER_TILE 0.01
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
#define CLOTHING_ARMOR_VERYLOW 5
#define CLOTHING_ARMOR_LOW 10
#define CLOTHING_ARMOR_MEDIUMLOW 15
#define CLOTHING_ARMOR_MEDIUM 20
#define CLOTHING_ARMOR_MEDIUMHIGH 25
#define CLOTHING_ARMOR_HIGH 30
#define CLOTHING_ARMOR_HIGHPLUS 35
#define CLOTHING_ARMOR_VERYHIGH 40
#define CLOTHING_ARMOR_VERYHIGHPLUS 45
#define CLOTHING_ARMOR_ULTRAHIGH 50
#define CLOTHING_ARMOR_ULTRAHIGHPLUS 55
#define CLOTHING_ARMOR_GIGAHIGH 70
#define CLOTHING_ARMOR_GIGAHIGHPLUS 75
#define CLOTHING_ARMOR_GIGAHIGHDOUBLEPLUSGOOD 80
#define CLOTHING_ARMOR_HARDCORE 100

#define UNIFORM_NO_SENSORS 0
#define UNIFORM_HAS_SENSORS 1
#define UNIFORM_FORCED_SENSORS 2

#define EYE_PROTECTION_NEGATIVE -1
#define EYE_PROTECTION_NONE 0
#define EYE_PROTECTION_FLAVOR 1
#define EYE_PROTECTION_FLASH 2
#define EYE_PROTECTION_WELDING 3

#define SENSOR_MODE_OFF 0
#define SENSOR_MODE_BINARY 1
#define SENSOR_MODE_DAMAGE 2
#define SENSOR_MODE_LOCATION 3

//OB timings
#define OB_TRAVEL_TIMING 12 SECONDS
#define OB_CRASHING_DOWN 1 SECONDS
#define OB_CLUSTER_DURATION 45 SECONDS
//=================================================

//Health of various items
#define HEALTH_WALL 3000
#define HEALTH_WALL_REINFORCED 9000
#define HEALTH_WALL_XENO 900
#define HEALTH_WALL_XENO_WEAK 100
#define HEALTH_WALL_XENO_THICK 1350
#define HEALTH_WALL_XENO_MEMBRANE 300
#define HEALTH_WALL_XENO_REFLECTIVE 300
#define HEALTH_WALL_XENO_MEMBRANE_THICK 600

#define HEALTH_DOOR 1200
#define HEALTH_DOOR_XENO 600
#define HEALTH_DOOR_XENO_THICK 900

#define HEALTH_RESIN_PILLAR 2200
#define HEALTH_RESIN_XENO_ACID_PILLAR 300
#define HEALTH_RESIN_XENO_SHIELD_PILLAR 300
#define HEALTH_RESIN_XENO_SPIKE 45
#define HEALTH_RESIN_XENO_STICKY 45
#define HEALTH_RESIN_XENO_FAST 30

/// Coefficient of throwforce when calculating damage from an atom colliding with a mob
#define THROWFORCE_COEFF 0.02
/// Coefficient of mobsize when calculating damage from a mob colliding with a dense atom
#define MOB_SIZE_COEFF 20
/// Coefficient of throwspeed when calculating damage from a mob colliding with a dense atom
#define THROW_SPEED_DENSE_COEFF 0.2
/// Coefficient of throwspeed when calculating damage from an atom colliding with a mob
#define THROW_SPEED_IMPACT_COEFF 0.05

#define THROW_MODE_OFF   0
#define THROW_MODE_NORMAL   1
#define THROW_MODE_HIGH  2

#define XENO_ACID_GAS_BARRICADE_DAMAGE 8.5
#define XENO_ACID_HMG_DAMAGE 10

#define MOLOTOV_POTENCY_MAX 20
#define MOLOTOV_TIME_MAX 20

/// A gun filled with this percentage of it's total ammo or lower is considered to have low ammo
#define GUN_LOW_AMMO_PERCENTAGE 0.25

// Fire
#define MAX_FIRE_STACKS 45
#define MIN_FIRE_STACKS -20
#define XENO_FIRE_RESIST_AMOUNT -10
#define HUMAN_FIRE_RESIST_AMOUNT -10
#define HUNTER_FIRE_RESIST_AMOUNT -25

// Organ damage chance

/// The multiplier to damage when calculating organ damage probability
#define DMG_ORGAN_DAM_PROB_MULT (2/9)
/// The multiplier to existing brute damage when calculating organ damage probability
#define BRUTE_ORGAN_DAM_PROB_MULT (0.05)
