/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * tgui state: not_incapacitated_and_inventory_state
 *
 * Checks that the user isn't incapacitated and the obj is in their inventory
 */

GLOBAL_DATUM_INIT(not_incapacitated_and_inventory_state, /datum/ui_state/not_incapacitated_and_inventory_state, new)

/**
 * tgui state: not_incapacitated_and_inventory_turf_state
 *
 * Checks that the user isn't incapacitated and that their loc is a turf and the obj is in their inventory
 */

GLOBAL_DATUM_INIT(not_incapacitated_and_inventory_turf_state, /datum/ui_state/not_incapacitated_and_inventory_state, new(no_turfs = TRUE))

/datum/ui_state/not_incapacitated_and_inventory_state
	var/turf_check = FALSE

/datum/ui_state/not_incapacitated_and_inventory_state/New(loc, no_turfs = FALSE)
	..()
	turf_check = no_turfs

/datum/ui_state/not_incapacitated_and_inventory_state/can_use_topic(src_object, mob/user)
	if(user.stat != CONSCIOUS || !(src_object in user))
		return UI_CLOSE
	if(user.is_mob_incapacitated(TRUE) || (turf_check && !isturf(user.loc)))
		return UI_DISABLED
	return UI_INTERACTIVE
