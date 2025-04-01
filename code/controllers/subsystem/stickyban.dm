SUBSYSTEM_DEF(stickyban)
	name = "Sticky Ban"
	init_order = SS_INIT_STICKY
	flags = SS_NO_FIRE

/datum/controller/subsystem/stickyban/Initialize()
	var/list/all_bans = world.GetConfig("ban")

	for(var/existing_ban in all_bans)
		var/list/ban_data = params2list(world.GetConfig("ban", existing_ban))
		INVOKE_ASYNC(src, PROC_REF(import_sticky), existing_ban, ban_data)

	return SS_INIT_SUCCESS

/**
 * Returns a list of [/datum/view_record/stickyban]s, or null, if no stickybans are found. All arguments are optional, but you should pass at least one if you want any results.
 */
/datum/controller/subsystem/stickyban/proc/check_for_sticky_ban(ckey, address, computer_id)
	var/list/stickyban_ids = list()

	for(var/datum/view_record/stickyban_matched_ckey/matched_ckey as anything in get_impacted_ckey_records(ckey))
		stickyban_ids += matched_ckey.linked_stickyban

	for(var/datum/view_record/stickyban_matched_cid/matched_cid as anything in get_impacted_cid_records(computer_id))
		stickyban_ids += matched_cid.linked_stickyban

	for(var/datum/view_record/stickyban_matched_ip/matched_ip as anything in get_impacted_ip_records(address))
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
		if(length(get_whitelisted_ckey_records(current_sticky.id, ckey)))
			stickies -= current_sticky

	if(!length(stickies))
		return FALSE

	return stickies

/**
 * Associates an existing stickyban with a new match, either of a ckey, address, or computer_id. Or all three.
 *
 * Arguments:
 * - existing_ban_id, int, required
 * - ckey, string, optional
 * - address, string, optional
 * - computer_id, string, optional
 */
/datum/controller/subsystem/stickyban/proc/match_sticky(existing_ban_id, ckey, address, computer_id)
	if(!existing_ban_id)
		return

	if(ckey)
		add_matched_ckey(existing_ban_id, ckey)

	if(address)
		add_matched_ip(existing_ban_id, address)

	if(computer_id)
		add_matched_cid(existing_ban_id, computer_id)

/**
 * Adds a new tracked stickyban, and returns a [/datum/entity/stickyban] if it was successful. Blocking, sleeps.
 */
/datum/controller/subsystem/stickyban/proc/add_stickyban(identifier, reason, message, datum/entity/player/banning_admin, override_date)
	var/datum/entity/stickyban/new_sticky = DB_ENTITY(/datum/entity/stickyban)
	new_sticky.identifier = identifier
	new_sticky.reason = reason
	new_sticky.message = message

	if(banning_admin)
		new_sticky.adminid = banning_admin.id

	new_sticky.date = override_date ? override_date : "[time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")]"
	new_sticky.save()
	new_sticky.sync()

	return new_sticky

/// Adds a ckey match to the specified sticky ban.
/datum/controller/subsystem/stickyban/proc/add_matched_ckey(existing_ban_id, key)
	key = ckey(key)

	if(length(DB_VIEW(/datum/view_record/stickyban_matched_ckey,
		DB_AND(
			DB_COMP("linked_stickyban", DB_EQUALS, existing_ban_id),
			DB_COMP("ckey", DB_EQUALS, key)
		)
	)))
		return

	var/datum/entity/stickyban_matched_ckey/matched_ckey = DB_ENTITY(/datum/entity/stickyban_matched_ckey)

	matched_ckey.ckey = key
	matched_ckey.linked_stickyban = existing_ban_id

	matched_ckey.save()

/// Adds an IP match to the specified stickyban.
/datum/controller/subsystem/stickyban/proc/add_matched_ip(existing_ban_id, ip)
	if(length(DB_VIEW(/datum/view_record/stickyban_matched_ip,
		DB_AND(
			DB_COMP("linked_stickyban", DB_EQUALS, existing_ban_id),
			DB_COMP("ip", DB_EQUALS, ip)
		)
	)))
		return

	var/datum/entity/stickyban_matched_ip/matched_ip = DB_ENTITY(/datum/entity/stickyban_matched_ip)

	matched_ip.ip = ip
	matched_ip.linked_stickyban = existing_ban_id

	matched_ip.save()

/// Adds a CID match to the specified stickyban.
/datum/controller/subsystem/stickyban/proc/add_matched_cid(existing_ban_id, cid)
	if(length(DB_VIEW(/datum/view_record/stickyban_matched_cid,
		DB_AND(
			DB_COMP("linked_stickyban", DB_EQUALS, existing_ban_id),
			DB_COMP("cid", DB_EQUALS, cid)
		)
	)))
		return


	var/datum/entity/stickyban_matched_cid/matched_cid = DB_ENTITY(/datum/entity/stickyban_matched_cid)

	matched_cid.cid = cid
	matched_cid.linked_stickyban = existing_ban_id

	matched_cid.save()

/// Whitelists a specific CKEY to the specified stickyban, which will allow connection, even with matching CIDs and IPs.
/datum/controller/subsystem/stickyban/proc/whitelist_ckey(existing_ban_id, key)
	key = ckey(key)

	if(!key)
		return

	var/id_to_select

	var/list/datum/view_record/stickyban_matched_ckey/existing_matches = DB_VIEW(/datum/view_record/stickyban_matched_ckey,
		DB_AND(
			DB_COMP("linked_stickyban", DB_EQUALS, existing_ban_id),
			DB_COMP("ckey", DB_EQUALS, key)
		)
	)

	if(length(existing_matches))
		var/datum/view_record/stickyban_matched_ckey/match = existing_matches[1]
		id_to_select = match.id

	var/datum/entity/stickyban_matched_ckey/whitelisted_ckey = DB_ENTITY(/datum/entity/stickyban_matched_ckey, id_to_select)

	whitelisted_ckey.ckey = key
	whitelisted_ckey.linked_stickyban = existing_ban_id
	whitelisted_ckey.whitelisted = TRUE

	whitelisted_ckey.save()

/**
 * Returns a [/list] of [/datum/view_record/stickyban_matched_ckey] where the ckey provided has not been
 * whitelisted from the stickyban, and would be prevented from joining - provided that the stickyban itself
 * remains active.
 */
/datum/controller/subsystem/stickyban/proc/get_impacted_ckey_records(key)
	key = ckey(key)

	return DB_VIEW(/datum/view_record/stickyban_matched_ckey,
			DB_AND(
				DB_COMP("ckey", DB_EQUALS, key),
				DB_COMP("whitelisted", DB_EQUALS, FALSE)
			)
		)

/**
 * Returns a [/list] of [/datum/view_record/stickyban_matched_ckey] which have been manually whitelisted by an admin and  matches the provided existing_ban_id and key.
 */
/datum/controller/subsystem/stickyban/proc/get_whitelisted_ckey_records(existing_ban_id, key)
	key = ckey(key)

	return DB_VIEW(/datum/view_record/stickyban_matched_ckey,
		DB_AND(
			DB_COMP("linked_stickyban", DB_EQUALS, existing_ban_id),
			DB_COMP("ckey", DB_EQUALS, key),
			DB_COMP("whitelisted", DB_EQUALS, TRUE),
		)
	)

/**
 * Returns a [/list] of [/datum/view_record/stickyban_matched_cid] where the impacted CID matches the CID provided.
 * Connections matching this CID will be blocked - provided the linked stickyban is active.
 */
/datum/controller/subsystem/stickyban/proc/get_impacted_cid_records(cid)
	return DB_VIEW(/datum/view_record/stickyban_matched_cid,
			DB_COMP("cid", DB_EQUALS, cid)
		)

/**
 * Returns a [/list] of [/datum/view_record/stickyban_matched_ip] where the impacted IP matches the IP provided.
 * Connections matchin this IP will be blocked - provided the linked stickyban is active.
 */
/datum/controller/subsystem/stickyban/proc/get_impacted_ip_records(ip)
	return DB_VIEW(/datum/view_record/stickyban_matched_ip,
		DB_COMP("ip", DB_EQUALS, ip)
	)

/// Legacy import from pager bans to database bans.
/datum/controller/subsystem/stickyban/proc/import_sticky(identifier, list/ban_data)
	WAIT_DB_READY

	if(ban_data["type"] != "sticky")
		handle_old_perma(identifier, ban_data)
		return

	if(!ban_data["message"])
		ban_data["message"] = "Evasion"

	add_stickyban(identifier, ban_data["reason"], ban_data["message"], override_date = "LEGACY")

/**
 * We abuse the on_insert from ndatabase here to ensure we have the synced ID of the new stickyban when applying a *lot* of associated bans. If we don't have a matching pager ban with the new sticky's identifier, we stop.
 */
/datum/entity_meta/stickyban/on_insert(datum/entity/stickyban/new_sticky)
	var/list/ban_data = params2list(world.GetConfig("ban", new_sticky.identifier))

	if(!length(ban_data))
		return

	var/list/whitelisted = list()
	if(ban_data["whitelist"])
		whitelisted = splittext(ban_data["whitelist"], ",")
		for(var/key in whitelisted)
			SSstickyban.whitelist_ckey(new_sticky.id, key)

	if(ban_data["keys"])
		var/list/keys = splittext(ban_data["keys"], ",")
		keys -= whitelisted
		for(var/key in keys)
			SSstickyban.add_matched_ckey(new_sticky.id, key)

	if(ban_data["computer_id"])
		var/list/cids = splittext(ban_data["computer_id"], ",")
		for(var/cid in cids)
			SSstickyban.add_matched_cid(new_sticky.id, cid)

	if(ban_data["IP"])
		var/list/ips = splittext(ban_data["IP"], ",")
		for(var/ip in ips)
			SSstickyban.add_matched_ip(new_sticky.id, ip)

	world.SetConfig("ban", new_sticky.identifier, null)

/// Imports permabans from the old ban.txt, and does *not* ban people that have been whitelisted.
/datum/controller/subsystem/stickyban/proc/handle_old_perma(identifier, list/ban_data)
	var/list/keys_to_ban = list()

	keys_to_ban += splittext(ban_data["keys"], ",")

	for(var/x in 1 to length(keys_to_ban))
		keys_to_ban[x] = ckey(keys_to_ban[x])

	var/list/keys = splittext(ban_data["whitelist"], ",")
	for(var/key in keys)
		keys_to_ban -= ckey(key)

	for(var/key in keys_to_ban)
		var/datum/entity/player/player_entity = get_player_from_key(key)
		if(!player_entity)
			continue

		INVOKE_ASYNC(player_entity, TYPE_PROC_REF(/datum/entity/player, add_perma_ban), ban_data["message"])

	world.SetConfig("ban", identifier, null)
