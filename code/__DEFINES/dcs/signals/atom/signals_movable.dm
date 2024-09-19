//from base of atom/movable/onTransitZ(): (old_z, new_z)
#define COMSIG_MOVABLE_Z_CHANGED "movable_ztransit"

/// From /atom/movable/proc/launch_towards
#define COMSIG_MOVABLE_PRE_THROW "movable_pre_throw"
	#define COMPONENT_CANCEL_THROW (1<<0)
/// From /atom/movable/proc/Moved(): (/atom, /list/atom, dir, forced)
#define COMSIG_MOVABLE_MOVED "movable_moved"
/// From /atom/movable/proc/moved_to_nullspace(): (/atom, /list/atom, dir, forced)
#define COMSIG_MOVABLE_MOVED_TO_NULLSPACE "movable_moved_to_nullspace"
/// From /atom/movable/Move(): (atom/NewLoc)
#define COMSIG_MOVABLE_PRE_MOVE "movable_pre_move"
	#define COMPONENT_CANCEL_MOVE (1<<0)
/// From /turf/open/gm/river/Entered(): (turf/open/gm/river/river, covered)
#define COMSIG_MOVABLE_ENTERED_RIVER "movable_entered_river"
/// From /atom/movable/proc/doMove: I think it only works with forceMove so watch out
#define COMSIG_MOVABLE_FORCEMOVE_PRE_CROSSED "movable_forcemove_pre_crossed"
	#define COMPONENT_IGNORE_CROSS (1<<0)

///from /mob/living/carbon/xenomorph/start_pulling(): (mob/living/carbon/xenomorph/X)
#define COMSIG_MOVABLE_XENO_START_PULLING "movable_xeno_start_pulling"
	#define COMPONENT_ALLOW_PULL (1<<0)

#define COMSIG_MOVABLE_PULLED "movable_pulled"
	#define COMPONENT_IGNORE_ANCHORED (1<<0)

#define COMSIG_MOVABLE_PRE_LAUNCH "movable_pre_launch"
	#define COMPONENT_LAUNCH_CANCEL (1<<0)

/// shuttle crushing something
#define COMSIG_MOVABLE_SHUTTLE_CRUSH "movable_shuttle_crush"

/// Any special handling after being transported via shuttle, especially if dependent on multiple shuttle turfs
/// that could have been changed after shuttle move
#define COMSIG_MOVABLE_AFTER_SHUTTLE_MOVE "movable_after_shuttle_move"

///from base of /atom/movable/proc/set_glide_size(): (target)
#define COMSIG_MOVABLE_UPDATE_GLIDE_SIZE "movable_glide_size"

#define COMSIG_MOVABLE_TURF_ENTER "movable_turf_enter"
