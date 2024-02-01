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


/proc/check_for_sticky_ban(ckey, address, computer_id)
	var/list/stickyban_ids = list()

	var/list/datum/view_record/stickyban_matched_ckey/ckeys = DB_VIEW(/datum/view_record/stickyban_matched_ckey,
		DB_AND(
			DB_COMP("ckey", DB_EQUALS, ckey),
			DB_COMP("whitelisted", DB_EQUALS, FALSE)
		)
	)

	for(var/datum/view_record/stickyban_matched_ckey/matched_ckey as anything in ckeys)
		stickyban_ids += matched_ckey.linked_stickyban

	var/list/datum/view_record/stickyban_matched_cid/cids = DB_VIEW(/datum/view_record/stickyban_matched_cid,
		DB_COMP("cid", DB_EQUALS, computer_id)
	)

	for(var/datum/view_record/stickyban_matched_cid/matched_cid as anything in cids)
		stickyban_ids += matched_cid.linked_stickyban

	var/list/datum/view_record/stickyban_matched_cid/ips = DB_VIEW(/datum/view_record/stickyban_matched_ip,
		DB_COMP("ip", DB_EQUALS, address)
	)

	for(var/datum/view_record/stickyban_matched_ip/matched_ip as anything in ips)
		stickyban_ids += matched_ip.linked_stickyban

	if(!length(stickyban_ids))
		return FALSE

	var/list/datum/view_record/stickyban/stickies = DB_VIEW(/datum/view_record/stickyban,
		DB_AND(
			DB_COMP("id", DB_IN, stickyban_ids),
			DB_COMP("active", DB_EQUALS, TRUE)
		)
	)

	for(var/datum/view_record/stickyban/current_sticky in stickies)
		var/list/datum/view_record/stickyban_matched_ckey/whitelisted_ckeys = DB_VIEW(/datum/view_record/stickyban_matched_ckey,
			DB_AND(
				DB_COMP("linked_stickyban", DB_EQUALS, current_sticky.id),
				DB_COMP("ckey", DB_EQUALS, ckey),
				DB_COMP("whitelisted", DB_EQUALS, TRUE),
			)
		)

		if(length(whitelisted_ckeys))
			stickies -= current_sticky

	if(!length(stickies))
		return FALSE

	return stickies

/client/verb/check_stickyban()
	check_for_sticky_ban(input("ckey"), input("ip"), input("id"))

	to_world("boowah")
