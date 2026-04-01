/// Gets SS13Lib or creates it if this is the first time we're accessing it
/world/proc/get_or_init_ss13lib()
#ifdef SPACEMAN_DMM
	RETURN_TYPE(/datum/ss13lib)
#endif

	var/static/datum/ss13lib/lib
	if(!lib)
		lib = new

	return lib

#ifndef SS13LIB_INIT_HANDLER
/// If the codebase doesn't start us up, start us up ourselves.
/// /static/ variables within procs are initialised early within global init order,
/// so we can begin handshaking with the hub server as early as possible
/world/proc/___ss13lib_init()
	var/static/_ = SS13LIB
#endif

/datum/ss13lib/New()
	if(!perform_handshake())
		return FALSE // unrecoverable error for SS13Lib, cannot communicate with SS13Hub

#ifndef SS13LIB_HEARTBEAT_HANDLER
/// Only perform any work here if we're set up to do so.
/// Servers can override the heartbeat loop if they use a custom
/// MC setup and don't want us running our own loop.
	heartbeat_loop()

/datum/ss13lib/proc/heartbeat_loop()
	while(TRUE)
		perform_heartbeat()
		sleep(300)
#endif
