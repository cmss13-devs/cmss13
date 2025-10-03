/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * tgui state: human_adjacent_state
 *
 * In addition to default checks, only allows interaction for a
 * human adjacent user within two tiles.
 */

GLOBAL_DATUM_INIT(human_adjacent_two_state, /datum/ui_state/human_adjacent_two_state, new)

/datum/ui_state/human_adjacent_two_state/New(loc, no_turfs = FALSE)
	..()

/datum/ui_state/human_adjacent_two_state/can_use_topic(src_object, mob/user)
	if(user.stat != CONSCIOUS)
		return UI_CLOSE
	var/dist = get_dist(src_object, user)
	if(user.is_mob_incapacitated(TRUE) || (dist > 2))
		return UI_DISABLED
	return UI_INTERACTIVE
