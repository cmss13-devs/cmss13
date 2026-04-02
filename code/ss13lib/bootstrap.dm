/// Gets SS13Lib or creates it if this is the first time we're accessing it
/world/proc/get_or_init_ss13lib()
#ifdef SPACEMAN_DMM
	RETURN_TYPE(/datum/ss13lib)
#endif

	var/static/datum/ss13lib/lib
	if(!lib)
		lib = new /datum/ss13lib
		lib.start()

	while(!lib.ready)
		sleep(world.tick_lag)

	return lib

#ifndef SS13LIB_EXTERNAL_INIT
/// If the codebase doesn't start us up, start us up ourselves.
/// /static/ variables within procs are initialised early within global init order,
/// so we can begin handshaking with the hub server as early as possible
/world/proc/___ss13lib_init()
	var/static/_ = SS13LIB
#endif

/datum/ss13lib/proc/start()
	SS13LIB_INFO_LOG("SS13Lib v[SS13LIB_VERSION] starting.")
	if(!perform_handshake())
		return FALSE
	SS13LIB_INFO_LOG("SS13Lib initialised successfully.")
	ready = TRUE

#ifndef SS13LIB_EXTERNAL_HEARTBEAT
/// Only perform any work here if we're set up to do so.
/// Servers can override the heartbeat loop if they use a custom
/// MC setup and don't want us running our own loop.
	heartbeat_loop()

/datum/ss13lib/proc/heartbeat_loop()
	while(TRUE)
		perform_heartbeat()
		sleep(300)
#endif
