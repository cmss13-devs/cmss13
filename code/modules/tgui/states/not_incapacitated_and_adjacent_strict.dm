/**
 * tgui state: not_incapacitated_and_adjacent_strict state
 *
 * Checks that the user isn't incapacitated and that they are adjacent and always does ui_close
 *
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

GLOBAL_DATUM_INIT(not_incapacitated_and_adjacent_strict_state, /datum/ui_state/not_incapacitated_and_adjacent_strict_state, new)

/**
 * tgui state: not_incapacitated_turf_state
 *
 * Checks that the user isn't incapacitated and that their loc is a turf
 */

GLOBAL_DATUM_INIT(not_incapacitated_and_adjacent_turf_strict_state, /datum/ui_state/not_incapacitated_and_adjacent_strict_state, new(no_turfs = TRUE))

/datum/ui_state/not_incapacitated_and_adjacent_strict_state
	var/turf_check = FALSE

/datum/ui_state/not_incapacitated_and_adjacent_strict_state/New(loc, no_turfs = FALSE)
	..()
	turf_check = no_turfs

/datum/ui_state/not_incapacitated_and_adjacent_strict_state/can_use_topic(src_object, mob/user)
	if(user.stat != CONSCIOUS)
		return UI_CLOSE
	var/dist = get_dist(src_object, user)
	if(user.is_mob_incapacitated(TRUE) || (turf_check && !isturf(user.loc)) || (dist > 1))
		return UI_CLOSE
	return UI_INTERACTIVE
