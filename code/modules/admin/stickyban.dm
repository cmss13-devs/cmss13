// BLOCKING PROC, RUN ASYNC

/proc/stickyban_internal(ckey, address, cid, reason, linked_stickyban, datum/entity/player/banning_admin)

	if(!ckey || !address || !cid)
		CRASH("Incorrect data passed to stickyban_internal ([ckey], [address], [cid])")

	var/datum/entity/player/P = get_player_from_key(ckey)

	if(!P)
		message_admins("Tried stickybanning ckey \"[ckey]\", player entity was unable to be found. Please try again later.")
		return

	var/datum/entity/player_sticky_ban/PSB = DB_ENTITY(/datum/entity/player_sticky_ban)
	PSB.player_id = P.id
	if(reason)
		PSB.reason = reason
	PSB.address = address
	PSB.computer_id = cid
	PSB.ckey = P.ckey
	PSB.date = "[time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")]"

	if(linked_stickyban)
		PSB.linked_stickyban = linked_stickyban

	if(!reason)
		reason = "No reason given."

	if(banning_admin)
		PSB.admin_id = banning_admin.id
		if(banning_admin.owning_client)
			message_admins("[banning_admin.owning_client.ckey] has stickybanned [ckey].")

	message_admins("[ckey] (IP: [address], CID: [cid]) has been stickybanned for: \"[reason]\".")

	if(P.owning_client)
		to_chat_forced(P.owning_client, SPAN_WARNING("<BIG><B>You have been sticky banned by [banning_admin? banning_admin.ckey : "Host"].\nReason: [sanitize(reason)].</B></BIG>"))
		to_chat_forced(P.owning_client, SPAN_WARNING("This is a permanent ban"))
		QDEL_NULL(P.owning_client)

	PSB.save()

/datum/entity/player/proc/process_stickyban(address, computer_id, source_id, reason, datum/entity/player/banning_admin, list/PSB)
	if(length(PSB) > 0) // sticky ban with identical data already exists, no need for another copy
		if(banning_admin)
			to_chat(banning_admin, SPAN_WARNING("Failed to add stickyban to [ckey]. Reason: Stickyban already exists."))
		return

	stickyban_internal(ckey, address, computer_id, reason, source_id, banning_admin)


/datum/entity/player/proc/check_for_sticky_ban(address, computer_id)
	var/list/datum/view_record/stickyban_list_view/SBLW = DB_VIEW(/datum/view_record/stickyban_list_view,
		DB_OR(
			DB_COMP("ckey", DB_EQUALS, ckey),
			DB_COMP("address", DB_EQUALS, address),
			DB_COMP("computer_id", DB_EQUALS, computer_id)
		))

	if(length(SBLW) == 0)
		return

	if(stickyban_whitelisted)
		return

	return SBLW
