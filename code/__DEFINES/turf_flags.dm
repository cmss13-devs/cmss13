//turf_flags values
/// Marks a turf as organic. Used for alien wall and membranes.
#define TURF_ORGANIC (1<<0)
/// If a turf is an usused reservation turf awaiting assignment
#define UNUSED_RESERVATION_TURF (1<<1)
/// If a turf is a reserved turf
#define RESERVATION_TURF (1<<2)
#define TURF_DEBRISED (1<<3)
#define TURF_HULL (1<<4)
#define TURF_BURNABLE (1<<5)
#define TURF_BURNT (1<<6)
#define TURF_BREAKABLE (1<<7)
#define TURF_BROKEN (1<<8)

//ChangeTurf options to change its behavior
#define CHANGETURF_DEFER_CHANGE (1<<0)
/// This flag prevents changeturf from gathering air from nearby turfs to fill the new turf with an approximation of local air
#define CHANGETURF_IGNORE_AIR (1<<1)
#define CHANGETURF_FORCEOP (1<<2)
/// A flag for PlaceOnTop to just instance the new turf instead of calling ChangeTurf. Used for uninitialized turfs NOTHING ELSE
#define CHANGETURF_SKIP (1<<3)

