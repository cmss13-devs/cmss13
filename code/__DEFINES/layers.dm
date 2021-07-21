
//defines for atom layers

//the hardcoded ones are AREA_LAYER = 1, TURF_LAYER = 2, OBJ_LAYER = 3, MOB_LAYER = 4, FLY_LAYER = 5

//#define AREA_LAYER 1

#define UNDER_TURF_LAYER 1.99

#define TURF_LAYER 2

#define ABOVE_TURF_LAYER 2.01
#define INTERIOR_WALL_NORTH_LAYER 2.02

#define LATTICE_LAYER 2.15

#define DISPOSAL_PIPE_LAYER 2.3

#define BELOW_ATMOS_PIPE_LAYER 2.37
#define ATMOS_PIPE_SCRUBBER_LAYER 2.38
#define ATMOS_PIPE_SUPPLY_LAYER 2.39
#define ATMOS_PIPE_LAYER 2.4

#define WIRE_LAYER 2.44
#define WIRE_TERMINAL_LAYER 2.45

#define UNDERFLOOR_OBJ_LAYER 2.46 //bluespace beacon, navigation beacon, etc

#define CATWALK_LAYER 2.5 //catwalk overlay of /turf/open/floor/plating/plating_catwalk

#define WEED_LAYER 2.51	// Alien weeds and node layer

#define ABOVE_WEED_LAYER 2.518	// Over weeds, such as blood

#define ABOVE_BLOOD_LAYER 2.519

#define ATMOS_DEVICE_LAYER 2.52 //vents, connector ports, atmos devices that should be above pipe layer.

#define ANIMAL_HIDING_LAYER 2.53

#define FIREDOOR_OPEN_LAYER 2.549		//Right under poddoors
#define PODDOOR_OPEN_LAYER 2.55		//Under doors and virtually everything that's "above the floor"

#define CONVEYOR_LAYER 2.56 //conveyor belt

#define RESIN_STRUCTURE_LAYER 2.6

#define LADDER_LAYER 2.7

#define WINDOW_FRAME_LAYER 2.72

#define XENO_HIDING_LAYER 2.75

#define BELOW_TABLE_LAYER 2.79
#define TABLE_LAYER 2.8
#define ABOVE_TABLE_LAYER 2.81

#define DOOR_OPEN_LAYER 2.85	//Under all objects if opened. 2.85 due to tables being at 2.8

#define BELOW_VAN_LAYER	2.98
#define BELOW_OBJ_LAYER 2.98 //just below all items

#define LOWER_ITEM_LAYER 2.99 //for items that should be at the bottom of the pile of items

//#define OBJ_LAYER 3

#define ABOVE_SPECIAL_RESIN_STRUCTURE_LAYER 3.01

#define UPPER_ITEM_LAYER 3.01 //for items that should be at the top of the pile of items

#define ABOVE_OBJ_LAYER 3.02 //just above all items

#define BUSH_LAYER 3.05

#define DOOR_CLOSED_LAYER 3.1	//Above most items if closed
#define FIREDOOR_CLOSED_LAYER 3.189		//Right under poddoors
#define PODDOOR_CLOSED_LAYER 3.19	//Above doors which are at 3.1

#define WINDOW_LAYER 3.2 //above closed doors

#define WALL_OBJ_LAYER 3.5 //posters on walls

#define POWERLOADER_LAYER 3.6 //above windows and wall mounts so the top of the loader doesn't clip.

#define BELOW_MOB_LAYER 		3.75
#define LYING_DEAD_MOB_LAYER	3.76
#define LYING_BETWEEN_MOB_LAYER 3.79
#define LYING_LIVING_MOB_LAYER	3.8

#define ABOVE_LYING_MOB_LAYER 3.9 //drone (not the xeno)

//#define MOB_LAYER 4

#define ABOVE_MOB_LAYER 4.1

#define BIG_XENO_LAYER 4.11	//above ABOVE_MOB_LAYER because it's used for shallow river overlays
							//which clips with the top of large xeno sprites.

#define ABOVE_XENO_LAYER 4.12	//for xenos to hide behind bushes and tall grass

#define FACEHUGGER_LAYER 4.13	// For facehuggers

#define INTERIOR_WALL_SOUTH_LAYER 5.2
#define INTERIOR_DOOR_LAYER       5.21

//#define FLY_LAYER 5

#define RIPPLE_LAYER 5.1

#define ABOVE_FLY_LAYER 6

#define AREAS_LAYER 999 //for areas, so they appear above everything else on map file.

#define ABOVE_LIGHTING_PLANE 16

#define BELOW_FULLSCREEN_LAYER 16.9 //blip from motion detector
#define FULLSCREEN_LAYER 17
#define FULLSCREEN_WEATHER_LAYER 17.01 // Weather
#define FULLSCREEN_IMPAIRED_LAYER 17.02 //visual impairment from wearing welding helmet, etc.
#define FULLSCREEN_DRUGGY_LAYER 17.03
#define FULLSCREEN_BLURRY_LAYER 17.04
#define FULLSCREEN_FLASH_LAYER 17.05 //flashed
#define FULLSCREEN_DAMAGE_LAYER 17.1 //red circles when hurt
#define FULLSCREEN_BLIND_LAYER 17.15 //unconscious
#define FULLSCREEN_PAIN_LAYER	17.2 //pain flashes
#define FULLSCREEN_CRIT_LAYER 17.25 //in critical

#define HUD_LAYER 19
#define ABOVE_HUD_LAYER 20

#define CINEMATIC_LAYER 21

