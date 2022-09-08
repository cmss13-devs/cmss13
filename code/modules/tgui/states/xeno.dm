/**
 * tgui state: hive_state
 *
 * Checks that the user is part of a hive.
 *
 */

GLOBAL_LIST_INIT(hive_state, setup_hive_states())

/proc/setup_hive_states()
	. = list()
	for(var/hivenumber in GLOB.hive_datum)
		var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
		.[hive.internal_faction] = new/datum/ui_state/hive_state(hive.hivenumber)

/datum/ui_state/hive_state
	var/hivenumber
	var/datum/hive_status/hive

/datum/ui_state/hive_state/New(var/hive_to_assign)
	. = ..()
	hivenumber = hive_to_assign
	hive = GLOB.hive_datum[hive_to_assign]

/datum/ui_state/hive_state/can_use_topic(src_object, mob/user)
	if(hive.is_ally(user))
		return UI_INTERACTIVE
	return UI_CLOSE

/**
 * tgui state: hive_state_king
 *
 * Checks that the user is part of a hive and is the leading king of that hive.
 *
 */

GLOBAL_LIST_INIT(hive_state_king, setup_hive_king_states())

/proc/setup_hive_king_states()
	. = list()
	for(var/hivenumber in GLOB.hive_datum)
		var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
		.[hive.internal_faction] = new/datum/ui_state/hive_state/king(hive.hivenumber)

/datum/ui_state/hive_state/king/can_use_topic(src_object, mob/user)
	. = ..()
	if(. == UI_CLOSE)
		return

	if(hive.living_xeno_king == user)
		return UI_INTERACTIVE
	return UI_UPDATE
