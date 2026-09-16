#define DEPTH_LAND 0
#define DEPTH_COAST_SHALLOW -2
#define DEPTH_COAST_INTERMEDIATE -4
#define DEPTH_SHALLOW -8
#define DEPTH_INTERMEDIATE -12
#define DEPTH_DEEP -18

#define WATER_OVERLAY_CONFIG_RESTING_USE_DEFAULT "resting_use_default"	//even when resting default overlay is used
#define WATER_OVERLAY_CONFIG_RESTING_NONE "resting_no"	//when resting no overlay at all is used
#define WATER_OVERLAY_CONFIG_RESTING_SOME "resting_some"	//uses resting overlays and splashes
#define WATER_OVERLAY_CONFIG_RESTING_ANGLED "resting_angled"	//has two resting resting overlays and splashes, one for each direction it can lay down in
#define WATER_OVERLAY_CONFIG_RESTING_IMMERSE "resting_immerse"	//in case we want WATER_OVERLAY_CONFIG_IMMERSE_DEPTHED but also while resting

#define WATER_OVERLAY_CONFIG_IMMERSE_NONE "immerse_no"	//never completely covered
#define WATER_OVERLAY_CONFIG_IMMERSE_WHEN_RESTING_ALWAYS "immerse_when_resting_always"	//will completely cover mob anytime its resting
#define WATER_OVERLAY_CONFIG_IMMERSE_WHEN_RESTING_DEPTHED "immerse_when_resting_depthed"	//will completely cover mob when resting at immerse_at_depth
#define WATER_OVERLAY_CONFIG_IMMERSE_ALWAYS "immerse_always"	//will completely cover mob anytime its in water
#define WATER_OVERLAY_CONFIG_IMMERSE_DEPTHED "immerse_always"	//will completely cover mob at immerse_at_depth
