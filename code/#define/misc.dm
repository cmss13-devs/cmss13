//for all defines that doesn't fit in any other file.


//dirt type for each turf types.

#define NO_DIRT				0
#define DIRT_TYPE_GROUND	1
#define DIRT_TYPE_MARS		2
#define DIRT_TYPE_SNOW		3


//wet floors

#define FLOOR_WET_WATER	1
#define FLOOR_WET_ICE	2

// Some defines for smoke spread ranking

#define SMOKE_RANK_HARMLESS		1
#define SMOKE_RANK_LOW			2
#define SMOKE_RANK_MED			3
#define SMOKE_RANK_HIGH			4
#define SMOKE_RANK_BOILER		5

//area flags

#define AREA_AVOID_BIOSCAN      1 //used to make mobs skip bioscans
#define AREA_NOTUNNEL           4 //makes it so the area can not be tunneled to

// Default number of ticks for do_after
#define DA_DEFAULT_NUM_TICKS 5

//construction flags
#define CONSTRUCTION_STATE_BEGIN    0
#define CONSTRUCTION_STATE_PROGRESS 1
#define CONSTRUCTION_STATE_FINISHED 2

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
#define INTERRUPT_OUT_OF_RANGE      (1<<8)  // By default not in INTERRUPT_ALL, should not be used in conjunction with
                                            // INTERRUPT_DIFF_TURF
#define INTERRUPT_LCLICK            (1<<9)  // Mainly for boiler globs
#define INTERRUPT_RCLICK            (1<<10)
#define INTERRUPT_SHIFTCLICK        (1<<11)
#define INTERRUPT_ALTCLICK          (1<<12)
#define INTERRUPT_CTRLCLICK         (1<<13)
#define INTERRUPT_MIDDLECLICK       (1<<14)
#define INTERRUPT_DAZED             (1<<15)

#define INTERRUPT_ALL               (INTERRUPT_DIFF_LOC|INTERRUPT_DIFF_TURF|INTERRUPT_UNCONSCIOUS|INTERRUPT_KNOCKED_DOWN|INTERRUPT_STUNNED|INTERRUPT_NEEDHAND|INTERRUPT_RESIST)
#define INTERRUPT_ALL_OUT_OF_RANGE  (INTERRUPT_ALL & (~INTERRUPT_DIFF_TURF)|INTERRUPT_OUT_OF_RANGE)
#define INTERRUPT_MOVED             (INTERRUPT_DIFF_LOC|INTERRUPT_DIFF_TURF|INTERRUPT_RESIST)
#define INTERRUPT_NO_NEEDHAND       (INTERRUPT_ALL & (~INTERRUPT_NEEDHAND))
#define INTERRUPT_INCAPACITATED     (INTERRUPT_UNCONSCIOUS|INTERRUPT_KNOCKED_DOWN|INTERRUPT_STUNNED|INTERRUPT_RESIST)
#define INTERRUPT_CLICK             (INTERRUPT_LCLICK|INTERRUPT_RCLICK|INTERRUPT_SHIFTCLICK|INTERRUPT_ALTCLICK|INTERRUPT_CTRLCLICK|INTERRUPT_MIDDLECLICK|INTERRUPT_RESIST)

// BEHAVIOR FLAGS
// These flags describe behaviors related to a given timed action.
// These behaviors are either of the person performing the action or any targets.
#define BEHAVIOR_IMMOBILE           (1<<16) // You cannot move the person while this action is being performed

// *************************************** //
//           END DO_AFTER FLAGS            //
// *************************************** //

#define PAYGRADES_MARINE list("C","E1","E2","E3","E4","E5","E6","E7","E8","E9","E9E","O1","O2","O3","O4","O5","O5E","O6","O7","O8","O9","O9E")
#define PAYGRADES_OFFICER list("O1","O2","O3","O4","O5","O5E","O6","O7","O8","O9","O9E")
#define PAYGRADES_ENLISTED list("C","E1","E2","E3","E4","E5","E6","E7","E8","E9","E9E")


// SIZES FOR ITEMS, use it for w_class

#define SIZE_TINY       1       // Helmets
#define SIZE_SMALL      2       // Armour, pouch slots/pockets
#define SIZE_MEDIUM     3       // Backpacks, belts.    Size of pistols, general magazines
#define SIZE_LARGE      4       // Size of rifles, SMGs
#define SIZE_HUGE       5       // Using Large does the same job
#define SIZE_MASSIVE    6       

// Statistics defines
#define STATISTICS_DEATH_LIST_LEN 10
