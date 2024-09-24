//from base of atom/movable/onTransitZ(): (old_z, new_z)
#define COMSIG_MOVABLE_Z_CHANGED "movable_ztransit"

/// From /atom/movable/proc/launch_towards
#define COMSIG_MOVABLE_PRE_THROW "movable_pre_throw"
	#define COMPONENT_CANCEL_THROW (1<<0)
///from base of atom/movable/Moved(): (/atom, dir, forced)
#define COMSIG_MOVABLE_MOVED "movable_moved"
/// From base of atom/movable/Collide(): (atom/collide_target)
#define COMSIG_MOVABLE_COLLIDE "movable_collide"
	#define COMPONENT_SKIP_DEFAULT_COLLIDE (1<<0)
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

/// When an atom is launching from a non-launching state.
/// From base of /datum/component/launching/RegisterWithParent().
#define COMSIG_MOVABLE_LAUNCHING "movable_launching"
/// When an atom is launching and has its original launch overridden by a new one.
/// From base of /datum/component/launching/InheritComponent().
#define COMSIG_MOVABLE_LAUNCHING_OVERRIDE "movable_launching_override"
	/// Indicates a launch should be cancelled, applies for COMSIG_MOVABLE_LAUNCHING and COMSIG_MOVABLE_LAUNCHING_OVERRIDE.
	#define COMPONENT_CANCEL_LAUNCH (1<<0)

#define COMSIG_MOVABLE_PRE_LAUNCH "movable_pre_launch"
	#define COMPONENT_LAUNCH_CANCEL (1<<0)

/// shuttle crushing something
#define COMSIG_MOVABLE_SHUTTLE_CRUSH "movable_shuttle_crush"

///from base of /atom/movable/proc/set_glide_size(): (target)
#define COMSIG_MOVABLE_UPDATE_GLIDE_SIZE "movable_glide_size"

#define COMSIG_MOVABLE_TURF_ENTER "movable_turf_enter"
