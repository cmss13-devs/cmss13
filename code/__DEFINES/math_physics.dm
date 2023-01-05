#define PI 3.141592653

// The TRUE circle constant!
#define TAU (PI * 2)

//"fancy" math for calculating time in ms from tick_usage percentage and the length of ticks
//percent_of_tick_used * (ticklag * 100(to convert to ms)) / 100(percent ratio)
//collapsed to percent_of_tick_used * tick_lag
#define TICK_DELTA_TO_MS(percent_of_tick_used) ((percent_of_tick_used) * world.tick_lag)
#define TICK_USAGE_TO_MS(starting_tickusage) (TICK_DELTA_TO_MS(world.tick_usage-starting_tickusage))


#define MEGAWATT 1000000
#define TEN_MEGAWATTS 10000000
#define HUNDRED_MEGAWATTS 100000000
#define GIGAWATT 1000000000

#define GAS_CRITICAL_TEMPERATURE     132.65    // K. The critical point temperature for air.

#define QUANTIZE(variable)		(round(variable, 0.0001))

#define INFINITY 1.#INF

#define SPEED_OF_LIGHT 3e8 //not exact but hey!
#define SPEED_OF_LIGHT_SQ 9e+16

#define MELTPOINT_GLASS   (1500+T0C)
#define MELTPOINT_STEEL   (1510+T0C)
#define MELTPOINT_SILICON 1687 // KELVIN
#define MELTPOINT_PLASTIC (180+T0C)
#define MELTPOINT_SNOW	304.15	//about 30°C

// The highest number supported is a signed 32-bit floating point number.
// Integers beyond the 24 bit range are represented as single-precision floating points, and thus will lose accuracy beyond the range of +/- 16777216
#define SHORT_REAL_LIMIT 16777216
