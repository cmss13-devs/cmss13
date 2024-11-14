/*
The /tg/ codebase allows mixing of hardcoded and dynamically-loaded z-levels.
Z-levels can be reordered as desired and their properties are set by "traits".
See map_config.dm for how a particular station's traits may be chosen.
The list DEFAULT_MAP_TRAITS at the bottom of this file should correspond to
the maps that are hardcoded, as set in maps/_basemap.dm. SSmapping is
responsible for loading every non-hardcoded z-level.


Multi-Z stations are supported and multi-Z mining and away missions would
require only minor tweaks.
*/

// helpers for modifying jobs, used in various job_changes.dm files
#define MAP_JOB_CHECK if(SSmapping.configs[GROUND_MAP].map_name != JOB_MODIFICATION_MAP_NAME) { return; }
#define MAP_JOB_CHECK_BASE if(SSmapping.configs[GROUND_MAP].map_name != JOB_MODIFICATION_MAP_NAME) { return ..(); }
#define MAP_REMOVE_JOB(jobpath) /datum/job/##jobpath/map_check() { return (SSmapping.configs[GROUND_MAP].map_name != JOB_MODIFICATION_MAP_NAME) && ..() }

#define SPACERUIN_MAP_EDGE_PAD 15

// traits
// boolean - marks a level as having that property if present
#define ZTRAIT_STATION "Station"
#define ZTRAIT_RESERVED "Transit/Reserved"
#define ZTRAIT_GROUND "Ground"
#define ZTRAIT_MARINE_MAIN_SHIP "Marine Main Ship"
#define ZTRAIT_ADMIN "Admin"
#define ZTRAIT_AWAY  "Away"
#define ZTRAIT_INTERIORS "Interiors"
#define ZTRAIT_TECHTREE "TechTree"

#define ZTRAIT_FOG "Fog"
#define ZTRAIT_LOCKDOWN "Lockdown"
#define ZTRAIT_BASIC_RT "BasicRT"
#define ZTRAIT_IN_SPACE "InSpace" // Is our ground_level considered in space or on a space station

// boolean - weather types that occur on the level
#define ZTRAIT_SNOWSTORM "weather_snowstorm"
#define ZTRAIT_ASHSTORM "weather_ashstorm"
#define ZTRAIT_ACIDRAIN "weather_acidrain"
#define ZTRAIT_SANDSTORM "weather_sandstorm"

/// number - bombcap is multiplied by this before being applied to bombs
#define ZTRAIT_BOMBCAP_MULTIPLIER "Bombcap Multiplier"

/// number - default gravity if there's no gravity generators or area overrides present
#define ZTRAIT_GRAVITY "Gravity"

// numeric offsets - e.g. {"Down": -1} means that chasms will fall to z - 1 rather than oblivion
#define ZTRAIT_UP "Up"
#define ZTRAIT_DOWN "Down"

// enum - how space transitions should affect this level

#define ZTRAIT_LINKAGE "Linkage"
/// UNAFFECTED if absent - no space transitions
#define UNAFFECTED null
/// SELFLOOPING - space transitions always self-loop
#define SELFLOOPING "Self"
/// CROSSLINKED - mixed in with the cross-linked space pool
#define CROSSLINKED "Cross"

// string - type path of the z-level's baseturf (defaults to space)
#define ZTRAIT_BASETURF "Baseturf"

// default trait definitions, used by SSmapping
#define ZTRAITS_MAIN_SHIP list(ZTRAIT_MARINE_MAIN_SHIP = TRUE)
#define ZTRAITS_GROUND list(ZTRAIT_GROUND = TRUE)
#define ZTRAITS_ADMIN list(ZTRAIT_ADMIN = TRUE)
#define ZTRAITS_SPACE list(ZTRAIT_LINKAGE = CROSSLINKED, ZTRAIT_SPACE_RUINS = TRUE)
#define ZTRAITS_INTERIORS list(ZTRAIT_INTERIORS = TRUE)

#define DL_NAME "name"
#define DL_TRAITS "traits"
#define DECLARE_LEVEL(NAME, TRAITS) list(DL_NAME = NAME, DL_TRAITS = TRAITS)

// must correspond to _basemap.dm for things to work correctly

#define DEFAULT_MAP_TRAITS list(\
	DECLARE_LEVEL("CentCom", ZTRAITS_ADMIN),\
)

// Camera lock flags

#define CAMERA_LOCK_SHIP (1<<0)
#define CAMERA_LOCK_GROUND (1<<1)
#define CAMERA_LOCK_ADMIN (1<<2)

///Reserved/Transit turf type

/// What the turf is when not being used
#define RESERVED_TURF_TYPE /turf/open/space/basic

//Ruin Generation

/// How many times we try to fit the ruin somewhere until giving up (really should just swap to some packing algo)
#define PLACEMENT_TRIES 100

#define PLACE_DEFAULT "random"
#define PLACE_SAME_Z "same"
#define PLACE_SPACE_RUIN "space"
#define PLACE_LAVA_RUIN "lavaland"


#define GROUND_MAP "ground_map"
#define SHIP_MAP "ship_map"
#define ALL_MAPTYPES list(GROUND_MAP, SHIP_MAP)
#define OVERRIDE_MAPS_TO_FILENAME list(GROUND_MAP = "next_map_override.dmm", SHIP_MAP = "next_ship_override.dmm")
#define MAP_TO_FILENAME list(GROUND_MAP = "data/next_map.json", SHIP_MAP = "data/next_ship.json")
#define HUNTERSHIPS_TEMPLATE_PATH "maps/predship/huntership.dmm"
#define OVERRIDE_DEFAULT_MAP_CONFIG list(GROUND_MAP = "maps/override_ground.json", SHIP_MAP = "maps/override_ship.json")

// traity things
#define MAP_COLD "COLD"

#define MAP_ARMOR_STYLE_DEFAULT "default"
#define MAP_ARMOR_STYLE_ICE "ice"
#define MAP_ARMOR_STYLE_JUNGLE "jungle"
#define MAP_ARMOR_STYLE_PRISON "prison"

/// A map key that corresponds to being one exclusively for Space.
#define SPACE_KEY "space"

#define SENTRY_TOP_LEFT "top_left"
#define SENTRY_TOP_RIGHT "top_right"
#define SENTRY_BOTTOM_LEFT "bottom_left"
#define SENTRY_BOTTOM_RIGHT "bottom_right"
