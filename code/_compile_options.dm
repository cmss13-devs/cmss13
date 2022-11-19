#ifndef PRELOAD_RSC				//set to:
#define PRELOAD_RSC	1			//	0 to allow using external resources or on-demand behaviour;
#endif							//	1 to use the default behaviour;
								//	2 for preloading absolutely everything;

//Update this whenever you need to take advantage of more recent byond features
#define MIN_COMPILER_VERSION 514
// Current supported version 1556, but flat out won't build under 1532, error before DM does
#define MIN_COMPILER_BUILD 1556
#if DM_VERSION < MIN_COMPILER_VERSION || DM_BUILD < MIN_COMPILER_BUILD
//Don't forget to update this part
#error Your version of BYOND is too out-of-date to compile this project. Go to https://secure.byond.com/download and update.
#error You need version 514.1556 or higher
#endif

// If this is uncommented, will attempt to load prof.dll (windows) or libprof.so (unix)
// byond-tracy is not shipped with CM code. Build it yourself here: https://github.com/mafemergency/byond-tracy/
//#define BYOND_TRACY
