/// If multiple instances of the effect are allowed
#define STATUS_EFFECT_MULTIPLE 0
/// If only one instance of the effect can exist, and it can't be replaced
#define STATUS_EFFECT_UNIQUE 1
/// If only one instance of the effect can exist, and new instances replace it
#define STATUS_EFFECT_REPLACE 2
/// If there can only be one instance, and new instances just refresh the timer
#define STATUS_EFFECT_REFRESH 3

///Processing flags - used to define the speed at which the status will work
///This is fast - 0.2s between ticks (I believe!)
#define STATUS_EFFECT_FAST_PROCESS 0
///This is slower and better for more intensive status effects - 1s between ticks
#define STATUS_EFFECT_NORMAL_PROCESS 1

/////////////////
// STATUS LIST //
/////////////////

/// The affected is asleep
#define STATUS_EFFECT_SLEEPING /datum/status_effect/incapacitating/sleeping
/// The affected is resting down
#define STATUS_EFFECT_RESTING /datum/status_effect/incapacitating/resting
