SUBSYSTEM_DEF(stickyban)
	name = "Sticky Ban"
	init_order = SS_INIT_STICKY
	flags = SS_NO_FIRE

	var/list/active_sticky

/datum/controller/subsystem/stickyban/Initialize()
	var/list/all_bans = world.GetConfig("ban")
	for(var/existing_ban in all_bans)

		var/list/ban_data = params2list(world.GetConfig("ban", existing_ban))

		if(!ban_data["database_ban"])
			import_sticky(existing_ban, ban_data)
			continue

		world.SetConfig("ban", existing_ban, null)

/datum/controller/subsystem/stickyban/proc/import_sticky(identifier, list/ban_data)
	if(ban_data["type"] == "sticky")
		handle_old_perma(identifier, ban_data)
		return

	if(!ban_data["message"])
		ban_data["message"] = "Evasion"

	var/datum/entity/stickyban/new_sticky = DB_ENTITY(/datum/entity/stickyban)
	new_sticky.identifier = identifier

	new_sticky.reason = ban_data["reason"]
	new_sticky.message = ban_data["message"]

	new_sticky.date = "LEGACY"
	new_sticky.save()
	new_sticky.detach()

/datum/entity_meta/stickyban/on_insert(datum/entity/stickyban/new_sticky)
	var/list/ban_data = params2list(world.GetConfig("ban", new_sticky.identifier))

	if(ban_data["keys"])
		var/list/keys = splittext(ban_data["keys"], ",")
		for(var/key in keys)
			var/datum/entity/stickyban_matched_ckey/matched_ckey = DB_ENTITY(/datum/entity/stickyban_matched_ckey)

			matched_ckey.ckey = key
			matched_ckey.linked_stickyban = new_sticky.id

			matched_ckey.save()
			matched_ckey.detach()

	if(ban_data["whitelist"])
		var/list/keys = splittext(ban_data["whitelist"], ",")
		for(var/key in keys)
			var/datum/entity/stickyban_matched_ckey/whitelisted_ckey = DB_ENTITY(/datum/entity/stickyban_matched_ckey)

			whitelisted_ckey.ckey = key
			whitelisted_ckey.linked_stickyban = new_sticky.id
			whitelisted_ckey.whitelisted = TRUE

			whitelisted_ckey.save()
			whitelisted_ckey.detach()

	if(ban_data["computer_id"])
		var/list/cids = splittext(ban_data["computer_id"], ",")
		for(var/cid in cids)
			var/datum/entity/stickyban_matched_cid/matched_cid = DB_ENTITY(/datum/entity/stickyban_matched_cid)

			matched_cid.cid = cid
			matched_cid.linked_stickyban = new_sticky.id

			matched_cid.save()
			matched_cid.detach()

	if(ban_data["IP"])
		var/list/ips = splittext(ban_data["IP"], ",")
		for(var/ip in ips)
			var/datum/entity/stickyban_matched_ip/matched_ip = DB_ENTITY(/datum/entity/stickyban_matched_ip)

			matched_ip.ip = ip
			matched_ip.linked_stickyban = new_sticky.id

			matched_ip.save()
			matched_ip.detach()

	world.SetConfig("ban", new_sticky.identifier, null)

/proc/handle_old_perma(identifier, list/ban_data)
	var/list/keys_to_ban = list()

	keys_to_ban += splittext(ban_data["keys"], ",")

	var/list/keys = splittext(ban_data["whitelist"], ",")
	for(var/key in keys)
		keys_to_ban -= key

	for(var/key in keys_to_ban)
		var/datum/entity/player/player_entity = get_player_from_key(key)
		if(player_entity)
			continue

		player_entity.is_permabanned = TRUE
		player_entity.permaban_admin = "AdminBot"
		player_entity.permaban_date = "IMPORT"
		player_entity.permaban_reason = ban_data["message"]
