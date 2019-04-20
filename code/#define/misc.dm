//for all defines that doesn't fit in any other file.


//dirt type for each turf types.

#define NO_DIRT				0
#define DIRT_TYPE_GROUND	1
#define DIRT_TYPE_MARS		2
#define DIRT_TYPE_SNOW		3


//wet floors

#define FLOOR_WET_WATER	1
#define FLOOR_WET_LUBE	2
#define FLOOR_WET_ICE	3

// Some defines for smoke spread ranking

#define SMOKE_RANK_HARMLESS		1
#define SMOKE_RANK_LOW			2
#define SMOKE_RANK_MED			3
#define SMOKE_RANK_HIGH			4
#define SMOKE_RANK_BOILER		5

//flag for skipping bioscans

#define AREA_AVOID_BIOSCAN      1

// Default number of ticks for do_after
#define DA_DEFAULT_NUM_TICKS 5

// *************************************** //
// DO_AFTER FLAGS
// These flags denote behaviors related to timed actions.
// *************************************** //

// INTERRUPT FLAGS
// These flags define whether specific actions will be interrupted by a given timed action
#define INTERRUPT_NONE 0
#define INTERRUPT_DIFF_LOC (1<<0)
#define INTERRUPT_DIFF_TURF (1<<1) // Might want to consider adding a separate flag for DIFF_COORDS
#define INTERRUPT_UNCONSCIOUS (1<<2) // Relevant to stat var for mobs
#define INTERRUPT_KNOCKED_DOWN (1<<3)
#define INTERRUPT_STUNNED (1<<4)
#define INTERRUPT_NEEDHAND (1<<5)
#define INTERRUPT_RESIST (1<<6) // Allows timed actions to be cancelled upon hitting resist, on by default
#define INTERRUPT_DIFF_SELECT_ZONE (1<<7)   // By default not in INTERRUPT_ALL (too niche)
#define INTERRUPT_OUT_OF_RANGE (1<<8)   // By default not in INTERRUPT_ALL, should not be used in conjunction with
                                        // INTERRUPT_DIFF_TURF
#define INTERRUPT_ALL (INTERRUPT_DIFF_LOC|INTERRUPT_DIFF_TURF|INTERRUPT_UNCONSCIOUS|INTERRUPT_KNOCKED_DOWN|INTERRUPT_STUNNED|INTERRUPT_NEEDHAND|INTERRUPT_RESIST)
#define INTERRUPT_ALL_OUT_OF_RANGE (INTERRUPT_ALL & (~INTERRUPT_DIFF_TURF))|INTERRUPT_OUT_OF_RANGE
#define INTERRUPT_ALL_BUILD INTERRUPT_ALL
#define INTERRUPT_NO_NEEDHAND (INTERRUPT_ALL & (~INTERRUPT_NEEDHAND))
#define INTERRUPT_INCAPACITATED (INTERRUPT_UNCONSCIOUS|INTERRUPT_KNOCKED_DOWN|INTERRUPT_STUNNED)

// BEHAVIOR FLAGS
// These flags describe behaviors related to a given timed action.
// These behaviors are either of the person performing the action or any targets.
#define BEHAVIOR_IMMOBILE (1<<9) // You cannot move the person while this action is being performed

// END DO_AFTER FLAGS //
