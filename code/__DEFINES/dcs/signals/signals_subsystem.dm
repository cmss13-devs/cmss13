// Subsystem signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

///Subsystem signals
///From base of datum/controller/subsystem/Initialize
#define COMSIG_SUBSYSTEM_POST_INITIALIZE "subsystem_post_initialize"

///from /datum/controller/subsystem/radio/get_available_tcomm_zs(): (list/tcomms)
#define COMSIG_SSRADIO_GET_AVAILABLE_TCOMMS_ZS "ssradio_get_available_tcomms_zs"
