//from base of atom/movable/onTransitZ(): (old_z, new_z)
#define COMSIG_MOVABLE_Z_CHANGED "movable_ztransit"

/// From /atom/movable/proc/launch_towards
#define COMSIG_MOVABLE_PRE_THROW "movable_pre_throw"
	#define COMPONENT_CANCEL_THROW (1<<0)
///from base of atom/movable/Moved(): (/atom, dir, forced)
#define COMSIG_MOVABLE_MOVED "movable_moved"
/// From /atom/movable/Move(): (atom/NewLoc)
#define COMSIG_MOVABLE_PRE_MOVE "movable_pre_move"
	#define COMPONENT_CANCEL_MOVE (1<<0)
/// From /turf/open/gm/river/Entered(): (turf/open/gm/river/river, covered)
#define COMSIG_MOVABLE_ENTERED_RIVER "movable_entered_river"

///from /mob/living/carbon/xenomorph/start_pulling(): (mob/living/carbon/xenomorph/X)
#define COMSIG_MOVABLE_XENO_START_PULLING "movable_xeno_start_pulling"
	#define COMPONENT_ALLOW_PULL (1<<0)

#define COMSIG_MOVABLE_PULLED "movable_pulled"
	#define COMPONENT_IGNORE_ANCHORED (1<<0)

#define COMSIG_MOVABLE_PRE_LAUNCH "movable_pre_launch"
	#define COMPONENT_LAUNCH_CANCEL (1<<0)

/// shuttle crushing something
#define COMSIG_MOVABLE_SHUTTLE_CRUSH "movable_shuttle_crush"

///from base of /atom/movable/proc/set_glide_size(): (target)
#define COMSIG_MOVABLE_UPDATE_GLIDE_SIZE "movable_glide_size"

#define COMSIG_MOVABLE_TURF_ENTER "movable_turf_enter"
