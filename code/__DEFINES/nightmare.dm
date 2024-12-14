// Built-in Nightmare contexts

/// Global Nightmare context: Performs any global game setup
#define NIGHTMARE_CTX_GLOBAL "global"
/// Ground Map Context: Performs actions relevant to the ground map
#define NIGHTMARE_CTX_GROUND "ground"
/// Ship Map Context: Performs actions relevant to the ship map
#define NIGHTMARE_CTX_SHIP "ship"
/// Hostile Survivor Scenarios
#define NIGHTMARE_SCENARIO_HOSTILE_SURVIVOR list("lvevent" = list("fallen_ship", "clfpods", "clfraid", "clfcrash", "clfsmugglers", "clf", "clfship"), "riot_in_progress" = list("rocinante"), "panic_room" = list("clfraid"))

// File names for use in context configs
#define NIGHTMARE_FILE_SCENARIO "scenario.json"
#define NIGHTMARE_FILE_BASE "nightmare.json"

// Token names for identifying related configs
#define NIGHTMARE_ACT_SCENARIO "scenario"
#define NIGHTMARE_ACT_BASE "base"

// Nightmare global status
#define NIGHTMARE_STATUS_STANDBY 0
#define NIGHTMARE_STATUS_RUNNING 1
#define NIGHTMARE_STATUS_DONE 2

// Nightmare task execution results
#define NIGHTMARE_TASK_OK  0
#define NIGHTMARE_TASK_ASYNC  1
#define NIGHTMARE_TASK_ERROR  2

// Nightmare task behavior flags

/// This task can not be executed
#define NIGHTMARE_TASKFLAG_DISABLED  (1<<0)
/// This task can only be executed once
#define NIGHTMARE_TASKFLAG_ONESHOT   (1<<1)
