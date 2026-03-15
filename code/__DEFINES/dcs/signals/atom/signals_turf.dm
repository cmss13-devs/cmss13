///from /turf/Entered
#define COMSIG_MOVABLE_TURF_ENTERED "movable_turf_entered"

/// from base of turf/ChangeTurf(): (path, list/new_baseturfs, flags, list/post_change_callbacks).
/// `post_change_callbacks` is a list that signal handlers can mutate to append `/datum/callback` objects.
/// They will be called with the new turf after the turf has changed.
#define COMSIG_PRE_TURF_CHANGE "pre_turf_change"

#define COMSIG_TURF_ENTER "turf_enter"
	#define COMPONENT_TURF_ALLOW_MOVEMENT (1<<0)
	#define COMPONENT_TURF_DENY_MOVEMENT  (1<<1)
#define COMSIG_TURF_ENTERED "turf_entered"

/// Called when a bullet hits a turf
#define COMSIG_TURF_BULLET_ACT "turf_bullet_act"
	#define COMPONENT_BULLET_ACT_OVERRIDE (1<<0)

/// From /turf/closed/wall/resin/attack_alien(): (mob/living/carbon/xenomorph/X)
#define COMSIG_WALL_RESIN_XENO_ATTACK "wall_resin_attack_alien"

/// From /turf/closed/wall/resin/attackby(): (obj/item/I, mob/M)
#define COMSIG_WALL_RESIN_ATTACKBY "wall_resin_attackby"
	#define COMPONENT_CANCEL_ATTACKBY (1<<0)

///from /turf/closed/wall/proc/place_poster
#define COMSIG_POSTER_PLACED "poster_placed"

///from base of /datum/turf_reservation/proc/Release: (datum/turf_reservation/reservation)
#define COMSIG_TURF_RESERVATION_RELEASED "turf_reservation_released"

///from /turf/proc/afterShuttleMove() : (/turf/old_turf)
#define COMSIG_TURF_AFTER_SHUTTLE_MOVE "turf_after_shuttle_move"
