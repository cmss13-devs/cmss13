/**
 * tgui state: powered_machinery_state
 *
 * Checks that the machinery is operable, user isn't incapacitated, and that their loc is a turf
 */
GLOBAL_DATUM_INIT(powered_machinery_state, /datum/ui_state/powered_machinery_state, new)

/datum/ui_state/powered_machinery_state
	var/turf_check = FALSE

/datum/ui_state/powered_machinery_state/New(loc, no_turfs = FALSE)
	..()
	turf_check = no_turfs

/datum/ui_state/powered_machinery_state/can_use_topic(src_object, mob/user)
	. = UI_CLOSE
	if(user.stat != CONSCIOUS)
		return UI_CLOSE
	var/dist = get_dist(src_object, user)
	if(user.is_mob_incapacitated(TRUE) || (turf_check && !isturf(user.loc)) || (dist > 1))
		return UI_CLOSE
	// We're just assuming we're properly being called on machinery
	var/obj/structure/machinery/src_machinery = src_object
	if(src_machinery.inoperable())
		return UI_CLOSE
	return UI_INTERACTIVE
