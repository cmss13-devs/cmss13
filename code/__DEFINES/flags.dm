#define HAS_FLAG(variable, flag) ((variable) & (flag))

// better bitfield macros
#define ENABLE_BITFIELD(variable, flag) ((variable) |= (flag))
#define DISABLE_BITFIELD(variable, flag) ((variable) &= ~(flag))
#define CHECK_BITFIELD(variable, flag) ((variable) & (flag))
#define TOGGLE_BITFIELD(variable, flag) ((variable) ^= (flag))

//check if all bitflags specified are present
#define CHECK_MULTIPLE_BITFIELDS(flagvar, flags) (((flagvar) & (flags)) == (flags))

/*
	These defines are specific to the atom/flags_1 bitmask
*/
#define ALL (~0) //For convenience.
#define NONE 0

/* Directions */
///All the cardinal direction bitflags.
#define ALL_CARDINALS (NORTH|SOUTH|EAST|WEST)

// for /datum/var/datum_flags
#define DF_USE_TAG		(1<<0)
#define DF_VAR_EDITED	(1<<1)
#define DF_ISPROCESSING (1<<2)
