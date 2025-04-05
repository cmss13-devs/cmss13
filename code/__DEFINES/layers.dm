
//Defines for atom layers and planes

//the hardcoded ones are AREA_LAYER = 1, TURF_LAYER = 2, OBJ_LAYER = 3, MOB_LAYER = 4, FLY_LAYER = 5

/*=============================*\
| |
|   LAYER DEFINES |
| |
\*=============================*/

//#define AREA_LAYER 1

#define DISPLACEMENT_PLATE_RENDER_LAYER 1
#define DISPLACEMENT_PLATE_RENDER_TARGET "*DISPLACEMENT_PLATE_RENDER_TARGET"

#define UNDER_TURF_LAYER 1.99

#define TURF_LAYER 2

#define ABOVE_TURF_LAYER 2.01
#define WALL_LAYER 2.02

#define LATTICE_LAYER 2.15

#define DISPOSAL_PIPE_LAYER 2.3

#define BELOW_ATMOS_PIPE_LAYER 2.37
#define ATMOS_PIPE_SCRUBBER_LAYER 2.38
#define ATMOS_PIPE_SUPPLY_LAYER 2.39
#define ATMOS_PIPE_LAYER 2.4

#define WIRE_LAYER 2.44
#define WIRE_TERMINAL_LAYER 2.45

/// bluespace beacon, navigation beacon, etc
#define UNDERFLOOR_OBJ_LAYER 2.46
/// catwalk overlay of /turf/open/floor/plating/plating_catwalk
#define CATWALK_LAYER 2.5
/// Alien weeds and node layer
#define WEED_LAYER 2.51
/// Over weeds, such as blood
#define ABOVE_WEED_LAYER 2.518

#define ABOVE_BLOOD_LAYER 2.519

/// vents, connector ports, atmos devices that should be above pipe layer.
#define ATMOS_DEVICE_LAYER 2.52

#define ANIMAL_HIDING_LAYER 2.53

/// Right under poddoors
#define FIREDOOR_OPEN_LAYER 2.549
/// Under doors and virtually everything that's "above the floor"
#define PODDOOR_OPEN_LAYER 2.55
/// conveyor belt
#define CONVEYOR_LAYER 2.56

#define RESIN_STRUCTURE_LAYER 2.6

#define LADDER_LAYER 2.7

#define WINDOW_FRAME_LAYER 2.72

#define XENO_HIDING_LAYER 2.75

#define BELOW_TABLE_LAYER 2.79
#define TABLE_LAYER 2.8
#define ABOVE_TABLE_LAYER 2.81

/// Under all objects if opened. 2.85 due to tables being at 2.8
#define DOOR_OPEN_LAYER 2.85

///For hatches on the floor.
#define HATCH_LAYER 2.9

#define BELOW_VAN_LAYER 2.98

/// just below all items
#define BELOW_OBJ_LAYER 2.98

/// for items that should be at the bottom of the pile of items
#define LOWER_ITEM_LAYER 2.99

//#define OBJ_LAYER 3

#define ABOVE_SPECIAL_RESIN_STRUCTURE_LAYER 3.01

/// A layer above objects (like structures) but below items
#define BETWEEN_OBJECT_ITEM_LAYER 3.01

/// The layer on which items lay
#define ITEM_LAYER 3.02
/// for items that should be at the top of the pile of items
#define UPPER_ITEM_LAYER 3.03
/// just above all items
#define ABOVE_OBJ_LAYER 3.04

#define BUSH_LAYER 3.05

/// Above most items if closed
#define DOOR_CLOSED_LAYER 3.1
/// Right under poddoors
#define FIREDOOR_CLOSED_LAYER 3.189
/// Above doors which are at 3.1
#define PODDOOR_CLOSED_LAYER 3.19
/// above closed doors
#define WINDOW_LAYER 3.2
/// posters on walls
#define WALL_OBJ_LAYER 3.5
/// above windows and wall mounts so the top of the loader doesn't clip.
#define POWERLOADER_LAYER 3.6

#define BELOW_MOB_LAYER 3.75
#define LYING_DEAD_MOB_LAYER 3.76
#define LYING_BETWEEN_MOB_LAYER 3.79
#define LYING_LIVING_MOB_LAYER 3.8

/// drone (not the xeno)
#define ABOVE_LYING_MOB_LAYER 3.9

//#define MOB_LAYER 4

#define ABOVE_MOB_LAYER 4.1

/// above ABOVE_MOB_LAYER because it's used for shallow river overlays which clips with the top of large xeno sprites.
#define BIG_XENO_LAYER 4.11

/// for xenos to hide behind bushes and tall grass
#define ABOVE_XENO_LAYER 4.12
/// For facehuggers
#define FACEHUGGER_LAYER 4.13
/// For Signs above everything but below weather
#define BILLBOARD_LAYER 4.13
/// For WEATHER
#define WEATHER_LAYER 4.14

//#define FLY_LAYER 5

#define RIPPLE_LAYER 5.1
#define INTERIOR_DOOR_INSIDE_LAYER 5.19
#define INTERIOR_WALL_SOUTH_LAYER 5.2
#define INTERIOR_DOOR_LAYER 5.21
#define INTERIOR_WALLMOUNT_LAYER 5.3
#define INTERIOR_ROOF_LAYER 5.5

#define ABOVE_FLY_LAYER 6

/// blip from motion detector
#define BELOW_FULLSCREEN_LAYER 16.9
#define FULLSCREEN_LAYER 17
/// Weather
#define FULLSCREEN_WEATHER_LAYER 17.01
/// visual impairment from wearing welding helmet, etc.
#define FULLSCREEN_IMPAIRED_LAYER 17.02
#define FULLSCREEN_DRUGGY_LAYER 17.03
#define FULLSCREEN_BLURRY_LAYER 17.04
/// flashed
#define FULLSCREEN_FLASH_LAYER 17.05
/// red circles when hurt
#define FULLSCREEN_DAMAGE_LAYER 17.1
/// unconscious
#define FULLSCREEN_BLIND_LAYER 17.15
/// pain flashes
#define FULLSCREEN_PAIN_LAYER 17.2
/// Vulture sniper/spotter scope
#define FULLSCREEN_VULTURE_SCOPE_LAYER 17.21
/// in critical
#define FULLSCREEN_CRIT_LAYER 17.25

#define HUD_LAYER 19
#define ABOVE_HUD_LAYER 20
#define CINEMATIC_LAYER 21
#define TACMAP_LAYER 22
#define INTRO_LAYER 26

/// for areas, so they appear above everything else on map file.
#define AREAS_LAYER 999

//Float layers. These layer over normal layers, but a high float layer will layer over a lower float layer (i.e. -1 over -2)
#define BELOW_FLOAT_LAYER -2
#define STANDARD_FLOAT_LAYER -1
#define ABOVE_FLOAT_LAYER -0.9
#define HIGH_FLOAT_LAYER -0.8
#define VERY_HIGH_FLOAT_LAYER -0.7

//---------- EMISSIVES -------------
//Layering order of these is not particularly meaningful.
//Important part is the seperation of the planes for control via plane_master

/// This plane masks out lighting to create an "emissive" effect, ie for glowing lights in otherwise dark areas.
#define EMISSIVE_PLANE 90
/// The render target used by the emissive layer.
#define EMISSIVE_RENDER_TARGET "*EMISSIVE_PLANE"
/// The layer you should use if you _really_ don't want an emissive overlay to be blocked.
#define EMISSIVE_LAYER_UNBLOCKABLE 9999

#define LIGHTING_BACKPLANE_LAYER 14.5

#define LIGHTING_RENDER_TARGET "LIGHT_PLANE"

#define SHADOW_RENDER_TARGET "SHADOW_RENDER_TARGET"

/// Plane for balloon text (text that fades up)
#define BALLOON_CHAT_PLANE 110
/// Bubble for typing indicators
#define TYPING_LAYER 500

#define O_LIGHTING_VISUAL_PLANE 120
#define O_LIGHTING_VISUAL_LAYER 16
#define O_LIGHTING_VISUAL_RENDER_TARGET "O_LIGHT_VISUAL_PLANE"

#define LIGHTING_PRIMARY_LAYER 15	//The layer for the main lights of the station
#define LIGHTING_PRIMARY_DIMMER_LAYER 15.1	//The layer that dims the main lights of the station
#define LIGHTING_SECONDARY_LAYER 16	//The colourful, usually small lights that go on top

#define LIGHTING_SHADOW_LAYER 17	//Where the shadows happen

#define ABOVE_LIGHTING_PLANE 150
#define ABOVE_LIGHTING_LAYER 18

/*=============================*\
| |
|   PLANE DEFINES |
| |
\*=============================*/

/// NEVER HAVE ANYTHING BELOW THIS PLANE ADJUST IF YOU NEED MORE SPACE
#define LOWEST_EVER_PLANE -200

#define OPEN_SPACE_PLANE_END -20
// Do no put anything between these two, adjust more z level support as needed
#define OPEN_SPACE_PLANE_START -9

#define OPENSPACE_BACKDROP_PLANE -8

/// Floor plane, self explanatory. Used for Ambient Occlusion filter
#define FLOOR_PLANE -7
/// Game Plane, where most of the game objects reside
#define GAME_PLANE -6
/// Above Game Plane. For things which are above game objects, but below screen effects.
#define ABOVE_GAME_PLANE -5
/// Roof plane, disappearing when entering buildings
#define ROOF_PLANE -4

/// To keep from conflicts with SEE_BLACKNESS internals
#define BLACKNESS_PLANE 0

#define GHOST_PLANE 80

///--------------- FULLSCREEN RUNECHAT BUBBLES ------------
#define LIGHTING_PLANE 100
#define EXTERIOR_LIGHTING_PLANE 101
#define NVG_PLANE 110

///Popup Chat Messages
#define RUNECHAT_PLANE 501

#define RENDER_PLANE_GAME 990
#define RENDER_PLANE_NON_GAME 995

#define ESCAPE_MENU_PLANE 997

#define RENDER_PLANE_MASTER 999

//-------------------- HUD ---------------------
#define FULLSCREEN_PLANE 900

/// HUD layer defines
#define HUD_PLANE 1000
#define ABOVE_HUD_PLANE 1100
#define TACMAP_PLANE 1150
#define ABOVE_TACMAP_PLANE 1151
#define CINEMATIC_PLANE 1200


/// Plane master controller keys
#define PLANE_MASTERS_GAME "plane_masters_game"
#define PLANE_MASTERS_NON_MASTER "plane_masters_non_master"
