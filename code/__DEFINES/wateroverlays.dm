#define DEPTH_LAND 0
#define DEPTH_COAST_DEPTHLESS -0.01
#define DEPTH_COAST_SHALLOW -5
#define DEPTH_COAST_INTERMEDIATE -7
#define DEPTH_SHALLOW -11
#define DEPTH_INTERMEDIATE -15
#define DEPTH_DEEP -21

// START: defines for /datum/water_overlay_config

// ⣿⣿⣿⣿⣿⣿ RESTING_BEHAVIOUR POSSIBLE VALUES:
/// if set to this, even when resting the overlay used while standing will be used.
#define WATER_OVERLAY_CONFIG_RESTING_USE_DEFAULT "resting_use_default"
/// if set to this, when resting no overlay at all is used
#define WATER_OVERLAY_CONFIG_RESTING_NONE "resting_no"
/// if set to this, uses a singlular resting overlay and singular resting splash
#define WATER_OVERLAY_CONFIG_RESTING_SOME "resting_some"
/// if set to this, will use two resting resting overlays and splashes, one for each laydown direction
#define WATER_OVERLAY_CONFIG_RESTING_ANGLED "resting_angled"
/// if set to this, will use the immerse overlay when resting
#define WATER_OVERLAY_CONFIG_RESTING_IMMERSE "resting_immerse"

// ⣿⣿⣿⣿⣿⣿ IMMERSE_BEHAVIOUR POSSIBLE VALUES:
/// if set to this, will never completely cover mob
#define WATER_OVERLAY_CONFIG_IMMERSE_NONE "immerse_no"
/// if set to this, will completely cover mob anytime its resting
#define WATER_OVERLAY_CONFIG_IMMERSE_WHEN_RESTING_ALWAYS "immerse_resting_always"
/// if set to this, will completely cover mob when resting at immerse_at_depth
#define WATER_OVERLAY_CONFIG_IMMERSE_WHEN_RESTING_DEPTHED "immerse_resting_depthed"
/// if set to this, will completely cover mob anytime its in water
#define WATER_OVERLAY_CONFIG_IMMERSE_ALWAYS "immerse_always"
/// if set to this, will completely cover mob at immerse_at_depth
#define WATER_OVERLAY_CONFIG_IMMERSE_DEPTHED "immerse_always"

// END: defines for /datum/water_overlay_config
