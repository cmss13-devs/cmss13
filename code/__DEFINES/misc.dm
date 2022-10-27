//for all defines that doesn't fit in any other file.

//Fullscreen overlay resolution in tiles.
#define FULLSCREEN_OVERLAY_RESOLUTION_X 15
#define FULLSCREEN_OVERLAY_RESOLUTION_Y 15

//dirt type for each turf types.

#define NO_DIRT				0
#define DIRT_TYPE_GROUND	1
#define DIRT_TYPE_MARS		2
#define DIRT_TYPE_SNOW		3
#define DIRT_TYPE_SAND		4

//wet floors

#define FLOOR_WET_WATER	1
#define FLOOR_WET_ICE	2

// Some defines for smoke spread ranking

#define SMOKE_RANK_HARMLESS		1
#define SMOKE_RANK_LOW			2
#define SMOKE_RANK_MED			3
#define SMOKE_RANK_HIGH			4
#define SMOKE_RANK_BOILER		5

// What kind of function to use for Explosions falling off.

#define EXPLOSION_FALLOFF_SHAPE_LINEAR              0
#define EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL         1
#define EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL_HALF    2

//area flags

#define AREA_AVOID_BIOSCAN (1<<0) //used to make mobs skip bioscans
#define AREA_NOTUNNEL (1<<1) //makes it so the area can not be tunneled to
#define AREA_ALLOW_XENO_JOIN (1<<2) //xenos can join whilst in this area (for admin zlevel)
#define AREA_CONTAINMENT (1<<3) // Flags the area as a containment area

// Default number of ticks for do_after
#define DA_DEFAULT_NUM_TICKS 5

//construction flags
#define CONSTRUCTION_STATE_BEGIN    0
#define CONSTRUCTION_STATE_PROGRESS 1
#define CONSTRUCTION_STATE_FINISHED 2

#define CELLS 8								//Amount of cells per row/column in grid
#define CELLSIZE (world.icon_size/CELLS)	//Size of a cell in pixel

// *************************************** //
// DO_AFTER FLAGS
// These flags denote behaviors related to timed actions.
// *************************************** //

// INTERRUPT FLAGS
// These flags define whether specific actions will be interrupted by a given timed action
#define INTERRUPT_NONE              0
#define INTERRUPT_DIFF_LOC          (1<<0)
#define INTERRUPT_DIFF_TURF         (1<<1)  // Might want to consider adding a separate flag for DIFF_COORDS
#define INTERRUPT_UNCONSCIOUS       (1<<2)  // Relevant to stat var for mobs
#define INTERRUPT_KNOCKED_DOWN      (1<<3)
#define INTERRUPT_STUNNED           (1<<4)
#define INTERRUPT_NEEDHAND          (1<<5)
#define INTERRUPT_RESIST            (1<<6)  // Allows timed actions to be cancelled upon hitting resist, on by default
#define INTERRUPT_DIFF_SELECT_ZONE  (1<<7)  // By default not in INTERRUPT_ALL (too niche)
#define INTERRUPT_OUT_OF_RANGE      (1<<8)  // By default not in INTERRUPT_ALL, should not be used in conjunction with INTERRUPT_DIFF_TURF
#define INTERRUPT_DIFF_INTENT       (1<<9)  // By default not in INTERRUPT_ALL (too niche) (Doesn't actually exist.)
#define INTERRUPT_LCLICK            (1<<10)  // Mainly for boiler globs
#define INTERRUPT_RCLICK            (1<<11)
#define INTERRUPT_SHIFTCLICK        (1<<12)
#define INTERRUPT_ALTCLICK          (1<<13)
#define INTERRUPT_CTRLCLICK         (1<<14)
#define INTERRUPT_MIDDLECLICK       (1<<15)
#define INTERRUPT_DAZED             (1<<16)
#define INTERRUPT_EMOTE             (1<<17)
#define INTERRUPT_CHANGED_LYING     (1<<18)  // By default not in INTERRUPT_ALL (too niche)

#define INTERRUPT_ALL               (INTERRUPT_DIFF_LOC|INTERRUPT_DIFF_TURF|INTERRUPT_UNCONSCIOUS|INTERRUPT_KNOCKED_DOWN|INTERRUPT_STUNNED|INTERRUPT_NEEDHAND|INTERRUPT_RESIST)
#define INTERRUPT_ALL_OUT_OF_RANGE  (INTERRUPT_ALL & (~INTERRUPT_DIFF_TURF)|INTERRUPT_OUT_OF_RANGE)
#define INTERRUPT_MOVED             (INTERRUPT_DIFF_LOC|INTERRUPT_DIFF_TURF|INTERRUPT_RESIST)
#define INTERRUPT_NO_NEEDHAND       (INTERRUPT_ALL & (~INTERRUPT_NEEDHAND))
#define INTERRUPT_INCAPACITATED     (INTERRUPT_UNCONSCIOUS|INTERRUPT_KNOCKED_DOWN|INTERRUPT_STUNNED|INTERRUPT_RESIST)
#define INTERRUPT_CLICK             (INTERRUPT_LCLICK|INTERRUPT_RCLICK|INTERRUPT_SHIFTCLICK|INTERRUPT_ALTCLICK|INTERRUPT_CTRLCLICK|INTERRUPT_MIDDLECLICK|INTERRUPT_RESIST)

// BEHAVIOR FLAGS
// These flags describe behaviors related to a given timed action.
// These behaviors are either of the person performing the action or any targets.
#define BEHAVIOR_IMMOBILE           (1<<18) // You cannot move the person while this action is being performed

// *************************************** //
//           END DO_AFTER FLAGS            //
// *************************************** //

// MATERIALS
#define MATERIAL_METAL     "metal"
#define MATERIAL_PLASTEEL  "plasteel"
#define MATERIAL_WOOD      "wood plank"
#define MATERIAL_CRYSTAL   "plasmagas"

// SIZES FOR ITEMS, use it for w_class
#define SIZE_TINY       1       // Helmets
#define SIZE_SMALL      2       // Armour, pouch slots/pockets
#define SIZE_MEDIUM     3       // Backpacks, belts.    Size of pistols, general magazines
#define SIZE_LARGE      4       // Size of rifles, SMGs
#define SIZE_HUGE       5       // Using Large does the same job
#define SIZE_MASSIVE    6

// Stack amounts
#define STACK_5			5
#define STACK_10		10
#define STACK_20		20
#define STACK_25		25
#define STACK_30		30
#define STACK_35		35
#define STACK_40		40
#define STACK_45		45
#define STACK_50		50

// Assembly Stages
#define ASSEMBLY_EMPTY		0
#define ASSEMBLY_UNLOCKED	1
#define ASSEMBLY_LOCKED		2

// Statistics defines
#define STATISTIC_XENO "xeno"
#define STATISTIC_HUMAN "human"

#define STATISTICS_DEATH_LIST_LEN 10

#define STATISTICS_NICHE_EXECUTION                  "Executions Made"
#define STATISTICS_NICHE_MEDALS                     "Medals Received"
#define STATISTICS_NICHE_MEDALS_GIVE                "Medals Given"
#define STATISTICS_NICHE_SHOCK                      "Times Shocked"
#define STATISTICS_NICHE_GRENADES                   "Grenades Thrown"
#define STATISTICS_NICHE_FLIGHT                     "Flights Piloted"
#define STATISTICS_NICHE_HANDCUFF                   "Handcuffs Applied"
#define STATISTICS_NICHE_PILLS                      "Pills Fed"
#define STATISTICS_NICHE_DISCHARGE                  "Accidental Discharges"
#define STATISTICS_NICHE_FULTON                     "Fultons Deployed"
#define STATISTICS_NICHE_DISK                       "Disks Decrypted"
#define STATISTICS_NICHE_UPLOAD                     "Data Uploaded"
#define STATISTICS_NICHE_CHEMS                      "Chemicals Discovered"
#define STATISTICS_NICHE_CRATES                     "Supplies Airdropped"
#define STATISTICS_NICHE_OB                         "Bombardments Fired"

#define STATISTICS_NICHE_CADES                      "Barricades Built"
#define STATISTICS_NICHE_UPGRADE_CADES 				"Barricades Upgraded"
#define STATISTICS_NICHE_REPAIR_CADES               "Barricades Repaired"
#define STATISTICS_NICHE_REPAIR_GENERATOR           "Generators Repaired"
#define STATISTICS_NICHE_REPAIR_APC                 "APCs Repaired"
#define STATISTICS_NICHE_DEFENSES_BUILT				"Defenses Built"

#define STATISTICS_NICHE_CORGI                      "Corgis Murdered"
#define STATISTICS_NICHE_CAT                        "Cats Murdered"
#define STATISTICS_NICHE_COW                        "Cows Murdered"
#define STATISTICS_NICHE_CHICKEN                    "Chickens Murdered"

#define STATISTICS_NICHE_SURGERY_BONES              "Bones Mended"
#define STATISTICS_NICHE_SURGERY_IB                 "Internal Bleedings Stopped"
#define STATISTICS_NICHE_SURGERY_BRAIN              "Brains Mended"
#define STATISTICS_NICHE_SURGERY_EYE                "Eyes Mended"
#define STATISTICS_NICHE_SURGERY_LARVA              "Larvae Removed"
#define STATISTICS_NICHE_SURGERY_SHRAPNEL           "Shrapnel Removed"
#define STATISTICS_NICHE_SURGERY_AMPUTATE           "Limbs Amputated"
#define STATISTICS_NICHE_SURGERY_ORGAN_REPAIR       "Organs Repaired"
#define STATISTICS_NICHE_SURGERY_ORGAN_ATTACH       "Organs Implanted"
#define STATISTICS_NICHE_SURGERY_ORGAN_REMOVE       "Organs Harvested"

#define STATISTICS_NICHE_DESTRUCTION_WALLS          "Walls Destroyed"
#define STATISTICS_NICHE_DESTRUCTION_DOORS          "Doors Destroyed"
#define STATISTICS_NICHE_DESTRUCTION_WINDOWS        "Windows Destroyed"

//Multiplier for turning points into cash
#define DEFCON_TO_MONEY_MULTIPLIER 10000
#define SUPPLY_TO_MONEY_MUPLTIPLIER 100

//Force the config directory to be something other than "config"
#define OVERRIDE_CONFIG_DIRECTORY_PARAMETER "config-directory"

//Gun categories, currently used for firing while dualwielding.
#define GUN_CATEGORY_HANDGUN 1
#define GUN_CATEGORY_SMG 2
#define GUN_CATEGORY_RIFLE 3
#define GUN_CATEGORY_SHOTGUN 4
#define GUN_CATEGORY_HEAVY 5

/**
 * Get the ultimate area of `A`, similarly to [get_turf].
 *
 * Use instead of `A.loc.loc`.
 */
#define get_area(A) (isarea(A) ? A : get_step(A, 0)?.loc)

//https://secure.byond.com/docs/ref/info.html#/atom/var/mouse_opacity
#define MOUSE_OPACITY_TRANSPARENT 0
#define MOUSE_OPACITY_ICON 1
#define MOUSE_OPACITY_OPAQUE 2

//Misc text define. Does 4 spaces. Used as a makeshift tabulator.
#define FOURSPACES "&nbsp;&nbsp;&nbsp;&nbsp;"

#define CLIENT_FROM_VAR(I) (ismob(I) ? I:client : (istype(I, /client) ? I : (istype(I, /datum/mind) ? I:current?:client : null)))

#define to_chat_forced(Target, Message) to_chat_immediate(Target, Message)

#define to_world(Message) to_chat(world, Message)

//world/proc/shelleo
#define SHELLEO_ERRORLEVEL 1
#define SHELLEO_STDOUT 2
#define SHELLEO_STDERR 3

// Shuttles
#define isshuttleturf(T) (length(T.baseturfs) && (/turf/baseturf_skipover/shuttle in T.baseturfs))

//Luma coefficients suggested for HDTVs. If you change these, make sure they add up to 1.
#define LUMA_R 0.213
#define LUMA_G 0.715
#define LUMA_B 0.072

//Automatic punctuation
#define ENDING_PUNCT list(".", "-", "?", "!")

//ghost vision mode pref settings
#define GHOST_VISION_LEVEL_NO_NVG		"No Night Vision"
#define GHOST_VISION_LEVEL_MID_NVG		"Half Night Vision"
#define GHOST_VISION_LEVEL_FULL_NVG		"Full Night Vision"

//Ghost orbit types:
#define GHOST_ORBIT_CIRCLE "circular"
#define GHOST_ORBIT_TRIANGLE "triangular"
#define GHOST_ORBIT_HEXAGON "hexagonal"
#define GHOST_ORBIT_SQUARE "square"
#define GHOST_ORBIT_PENTAGON "pentagonal"

//Command message cooldown defines:
#define COOLDOWN_COMM_MESSAGE		30 SECONDS
#define COOLDOWN_COMM_MESSAGE_LONG	1 MINUTES
#define COOLDOWN_COMM_REQUEST		5 MINUTES
#define COOLDOWN_COMM_CENTRAL		30 SECONDS
#define COOLDOWN_COMM_DESTRUCT		5 MINUTES

// filters
#define AMBIENT_OCCLUSION filter(type="drop_shadow", x=0, y=-2, size=4, border=4, color="#04080FAA")
