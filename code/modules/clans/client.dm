/client/proc/is_yautja_ancient(query_permissions)
	if(query_permissions)
		if(query_permissions & CLAN_PERMISSION_ADMIN_ANCIENT)
			return TRUE
		return FALSE
	if(clan_info?.permissions & CLAN_PERMISSION_ADMIN_ANCIENT)
		return TRUE
	return FALSE

/client/proc/is_authorized_clan_member(clan_id, warn)
	if(!clan_info)
		if(warn)
			to_chat(src, SPAN_WARNING("You do not have a yautja whitelist!"))
		return FALSE

	if(clan_id)
		if(is_yautja_ancient())
			return TRUE
		if(clan_id != clan_info.clan_id)
			if(warn)
				to_chat(src, SPAN_WARNING("You do not have permission to perform actions on this clan!"))
			return FALSE
	return TRUE

/client/proc/has_clan_permission(permission_flag, clan_id, warn)
	if(!is_authorized_clan_member(clan_id, warn))
		return FALSE

	if(!(clan_info.permissions & permission_flag))
		if(warn)
			to_chat(src, SPAN_WARNING("You do not have the necessary permissions to perform this action!"))
		return FALSE

	return TRUE

/client/proc/has_clan_position(needed_position, clan_id, warn)
	if(!is_authorized_clan_member(clan_id, warn))
		return FALSE

	if(is_yautja_ancient() || (clan_info.clan_rank >= CLAN_RANK_LEADER_INT))
		return TRUE

	if(clan_info.clan_ancillary == needed_position)
		return TRUE
	if(clan_info.clan_rank >= needed_position)
		return TRUE

	if(warn)
		log_debug("Needed Position: [needed_position], Needed Clan ID: [clan_id]")
		log_debug("Clan Rank: [clan_info.clan_rank], Ancillary: [clan_info.clan_ancillary? clan_info.clan_ancillary : "N/A"]")
		to_chat(src, SPAN_WARNING("You do not have the necessary position to perform this action!"))
	return FALSE

/datum/entity/clan_player/proc/can_be_ancillary(required_rank, needed_clan_id)
	if(needed_clan_id != clan_id)
		log_debug("Needed clan match fail.")
		return FALSE

	if(clan_rank < required_rank)
		log_debug("Clan rank match fail.")
		return FALSE
	return TRUE
