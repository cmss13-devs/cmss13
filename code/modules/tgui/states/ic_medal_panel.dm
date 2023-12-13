/**
 * tgui state: ic_medal_state_check
 *
 * Snowflake check for the IcMedalPanel. Checks that the user is not incapacitated, and that they're adjacent to the thing that originally called this.
 */

GLOBAL_DATUM_INIT(ic_medal_state_check, /datum/ui_state/ic_medal_state_check, new)

/datum/ui_state/ic_medal_state_check/can_use_topic(datum/ic_medal_panel/src_object, mob/user)
	if(user.stat != CONSCIOUS)
		return UI_CLOSE
	if(!istype(src_object))
		return UI_CLOSE
	if(!src_object.user_locs[user])
		return UI_CLOSE
	var/dist = get_dist(src_object.user_locs[user], user)
	if(user.is_mob_incapacitated(TRUE))
		return UI_DISABLED
	if(istype(src_object.user_locs[user], /obj/item))
		if(!(src_object.user_locs[user] in user))
			return UI_DISABLED
	else if((dist > 1))
		return UI_DISABLED

	return UI_INTERACTIVE
