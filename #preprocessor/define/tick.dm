/// Percentage of tick to leave for master controller to run
#define MAPTICK_MC_MIN_RESERVE 60
/// internal_tick_usage is updated every tick by extools
#define MAPTICK_LAST_INTERNAL_TICK_USAGE ((internal_tick_usage / world.tick_lag) * 100)
/// Tick limit while running normally
#define TICK_BYOND_RESERVE 2
#define TICK_LIMIT_RUNNING (max(100 - TICK_BYOND_RESERVE - MAPTICK_LAST_INTERNAL_TICK_USAGE, MAPTICK_MC_MIN_RESERVE))
#define TICK_LIMIT_TO_RUN 78
#define TICK_LIMIT_MC 70
#define TICK_LIMIT_MC_INIT 98

#define TICK_CHECK ( world.tick_usage > CURRENT_TICKLIMIT ? stoplag() : 0 )
#define CHECK_TICK if (world.tick_usage > CURRENT_TICKLIMIT)  stoplag()
