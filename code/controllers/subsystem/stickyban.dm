SUBSYSTEM_DEF(stickyban)
	name = "Sticky Ban"
	init_order = SS_INIT_STICKY
	flags = SS_NO_FIRE

/datum/controller/subsystem/stickyban/Initialize()
	set waitfor = FALSE

	WAIT_DB_READY

	var/list/all_bans = world.GetConfig("ban")
	for(var/existing_ban in all_bans)

		var/list/ban_data = params2list(world.GetConfig("ban", existing_ban))

		if(!ban_data["database_ban"])
			INVOKE_ASYNC(src, PROC_REF(import_sticky), existing_ban, ban_data)
			continue

		world.SetConfig("ban", existing_ban, null)

/datum/controller/subsystem/stickyban/proc/check_for_sticky_ban(ckey, address, computer_id)
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


/datum/controller/subsystem/stickyban/proc/match_sticky(existing_ban_id, ckey, address, computer_id)
	if(!existing_ban_id)
		return

	if(ckey)
		var/datum/view_record/stickyban_matched_ckey/matched_ckey = DB_VIEW(/datum/view_record/stickyban_matched_ckey,
			DB_AND(
				DB_COMP("linked_stickyban", DB_EQUALS, existing_ban_id),
				DB_COMP("ckey", DB_EQUALS, ckey)
			)
		)

		if(!length(matched_ckey))
			add_matched_ckey(existing_ban_id, ckey)

	if(address)
		var/datum/view_record/stickyban_matched_ip/matched_ip = DB_VIEW(/datum/view_record/stickyban_matched_ip,
			DB_AND(
				DB_COMP("linked_stickyban", DB_EQUALS, existing_ban_id),
				DB_COMP("ip", DB_EQUALS, address)
			)
		)

		if(!length(matched_ip))
			add_matched_ip(existing_ban_id, address)

	if(computer_id)
		var/datum/view_record/stickyban_matched_cid/matched_cid = DB_VIEW(/datum/view_record/stickyban_matched_cid,
			DB_AND(
				DB_COMP("linked_stickyban", DB_EQUALS, existing_ban_id),
				DB_COMP("cid", DB_EQUALS, computer_id)
			)
		)

		if(!length(matched_cid))
			add_matched_cid(existing_ban_id, computer_id)

/datum/controller/subsystem/stickyban/proc/add_stickyban(identifier, reason, message, datum/entity/player/banning_admin, override_date)
	var/datum/entity/stickyban/new_sticky = DB_ENTITY(/datum/entity/stickyban)
	new_sticky.identifier = identifier

	new_sticky.reason = reason
	new_sticky.message = message

	if(banning_admin)
		new_sticky.adminid = banning_admin.id

	new_sticky.date = override_date ? override_date : "[time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")]"
	new_sticky.save()

	return new_sticky


/datum/controller/subsystem/stickyban/proc/add_matched_ckey(existing_ban_id, key)
	var/datum/entity/stickyban_matched_ckey/matched_ckey = DB_ENTITY(/datum/entity/stickyban_matched_ckey)

	matched_ckey.ckey = ckey(key)
	matched_ckey.linked_stickyban = existing_ban_id

	matched_ckey.save()

/datum/controller/subsystem/stickyban/proc/add_matched_ip(existing_ban_id, ip)
	var/datum/entity/stickyban_matched_ip/matched_ip = DB_ENTITY(/datum/entity/stickyban_matched_ip)

	matched_ip.ip = ip
	matched_ip.linked_stickyban = existing_ban_id

	matched_ip.save()

/datum/controller/subsystem/stickyban/proc/add_matched_cid(existing_ban_id, cid)
	var/datum/entity/stickyban_matched_cid/matched_cid = DB_ENTITY(/datum/entity/stickyban_matched_cid)

	matched_cid.cid = cid
	matched_cid.linked_stickyban = existing_ban_id

	matched_cid.save()

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

/datum/controller/subsystem/stickyban/proc/import_sticky(identifier, list/ban_data)
	if(ban_data["type"] != "sticky")
		handle_old_perma(identifier, ban_data)
		return

	if(!ban_data["message"])
		ban_data["message"] = "Evasion"

	add_stickyban(identifier, ban_data["reason"], ban_data["message"], override_date = "LEGACY")

/datum/entity_meta/stickyban/on_insert(datum/entity/stickyban/new_sticky)
	var/list/ban_data = params2list(world.GetConfig("ban", new_sticky.identifier))

	if(!length(ban_data))
		return

	if(ban_data["keys"])
		var/list/keys = splittext(ban_data["keys"], ",")
		for(var/key in keys)
			SSstickyban.add_matched_ckey(new_sticky.id, key)

	if(ban_data["whitelist"])
		var/list/keys = splittext(ban_data["whitelist"], ",")
		for(var/key in keys)
			SSstickyban.whitelist_ckey(new_sticky.id, key)

	if(ban_data["computer_id"])
		var/list/cids = splittext(ban_data["computer_id"], ",")
		for(var/cid in cids)
			SSstickyban.add_matched_cid(new_sticky.id, cid)

	if(ban_data["IP"])
		var/list/ips = splittext(ban_data["IP"], ",")
		for(var/ip in ips)
			SSstickyban.add_matched_ip(new_sticky.id, ip)

	world.SetConfig("ban", new_sticky.identifier, null)

/proc/handle_old_perma(identifier, list/ban_data)
	var/list/keys_to_ban = list()

	keys_to_ban += splittext(ban_data["keys"], ",")

	var/list/keys = splittext(ban_data["whitelist"], ",")
	for(var/key in keys)
		keys_to_ban -= ckey(key)

	for(var/key in keys_to_ban)
		var/datum/entity/player/player_entity = get_player_from_key(key)
		if(!player_entity)
			continue

		INVOKE_ASYNC(player_entity, TYPE_PROC_REF(/datum/entity/player, add_perma_ban), ban_data["message"])

	world.SetConfig("ban", identifier, null)
