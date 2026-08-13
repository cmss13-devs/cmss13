// Subsystem signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

///Subsystem signals

/// Fired by SSexplosion_waves when reaching a synchronization checkpoint
#define COMSIG_SS_EXPLOSION_WAVES_CHECKPOINT_REACHED "ss_explosion_waves_checkpoint_reached"

///From base of datum/controller/subsystem/Initialize
#define COMSIG_SUBSYSTEM_POST_INITIALIZE "subsystem_post_initialize"
