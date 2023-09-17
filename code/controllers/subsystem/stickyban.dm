SUBSYSTEM_DEF(sticky_ban)
	name = "Sticky Ban"
	init_order = SS_INIT_STICKY
	flags = SS_NO_FIRE

	var/list/active_sticky

/datum/controller/subsystem/sticky_ban/Initialize()
	for(var/existing_ban in world.GetConfig("ban"))
		var/ckey = ckey(existing_ban)

		var/list/ban_data = params2list(world.GetConfig("ban", existing_ban))

		if(ckey != existing_ban)
			if(!ban_data["database_ban"])
				import_sticky(code = existing_ban, ban_data = ban_data)
			continue

		if(!ban_data["database_ban"])
			import_sticky(ckey, ban_data)

		world.SetConfig("ban", existing_ban, null)

/datum/controller/subsystem/sticky_ban/proc/import_sticky(ckey, code, list/ban_data)
	if(!ban_data["message"])
		ban_data["message"] = "Evasion"

	if(!ckey)
		var/list/keys = splittext(ban_data["keys"], ",")
		ckey = keys[1]

	var/datum/entity/stickyban/new_sticky = DB_ENTITY(/datum/entity/stickyban)
	new_sticky.ckey = ckey

	new_sticky.reason = ban_data["reason"]
	new_sticky.message = ban_data["message"]
	new_sticky.sticky = ban_data["sticky"]

	new_sticky.date = "LEGACY"

	new_sticky.save()

	if(ban_data["keys"])
		var/list/keys = splittext(ban_data["keys"], ",")
		for(var/key in keys)
			var/datum/entity/stickyban_matched_ckey/matched_ckey = DB_ENTITY(/datum/entity/stickyban_matched_ckey)

			matched_ckey.ckey = key
			matched_ckey.linked_stickyban = new_sticky.id

			matched_ckey.save()

	if(ban_data["whitelist"])
		var/list/keys = splittext(ban_data["whitelist"], ",")
		for(var/key in keys)
			var/datum/entity/stickyban_matched_ckey/whitelisted_ckey = DB_ENTITY(/datum/entity/stickyban_matched_ckey)

			whitelisted_ckey.ckey = key
			whitelisted_ckey.linked_stickyban = new_sticky.id
			whitelisted_ckey.whitelisted = TRUE

			whitelisted_ckey.save()

	if(ban_data["computer_id"])
		var/list/cids = splittext(ban_data["computer_id"], ",")
		for(var/cid in cids)
			var/datum/entity/stickyban_matched_cid/matched_cid = DB_ENTITY(/datum/entity/stickyban_matched_cid)

			matched_cid.cid = cid
			matched_cid.linked_stickyban = new_sticky.id

			matched_cid.save()

	if(ban_data["IP"])
		var/list/ips = splittext(ban_data["IP"], ",")
		for(var/ip in ips)
			var/datum/entity/stickyban_matched_ip/matched_ip = DB_ENTITY(/datum/entity/stickyban_matched_ip)

			matched_ip.ip = ip
			matched_ip.linked_stickyban = new_sticky.id

			matched_ip.save()


