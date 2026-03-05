SUBSYSTEM_DEF(ipcheck)
	name = "IPCheck"
	flags = SS_NO_FIRE | SS_NO_INIT

	/// Cache for previously queried IP addresses and those stored in the database
	var/list/datum/ip_intel/cached_queries = list()

/// The ip intel for a given address
/datum/ip_intel
	var/result
	var/address
	var/date

/datum/controller/subsystem/ipcheck/proc/is_enabled()
	return !!length(CONFIG_GET(string/ipcheck_base)) && !!length(CONFIG_GET(string/ipcheck_apikey))

/datum/controller/subsystem/ipcheck/proc/get_address_intel_state(address, probability_override)
	if (!is_enabled())
		return IPCHECK_GOOD_IP
	var/datum/ip_intel/intel = query_address(address)
	if(isnull(intel))
		stack_trace("query_address did not return an ip intel response")
		return IPCHECK_UNKNOWN_INTERNAL_ERROR

	var/check_probability = CONFIG_GET(number/ipcheck_rating_bad)
	if(intel.result == check_probability)
		return IPCHECK_BAD_IP

	return IPCHECK_GOOD_IP

/datum/controller/subsystem/ipcheck/proc/query_address(address, allow_cached = TRUE)
	if (!is_enabled())
		return
	if(allow_cached && fetch_cached_ip_intel(address))
		return cached_queries[address]

	var/query_base = "https://[CONFIG_GET(string/ipcheck_base)]/"
	var/query = "[query_base]?q=[address]&key=[CONFIG_GET(string/ipcheck_apikey)]"

	var/datum/http_request/request = new
	request.prepare(RUSTG_HTTP_METHOD_GET, query)
	request.begin_async()

	UNTIL(request.is_complete())

	var/datum/http_response/response = request.into_response()

	var/list/data
	try
		data = json_decode(response.body)
	catch
		log_debug("IPCHECK: Error while decoding response. [response.body]")
		return

	var/datum/ip_intel/intel = new
	intel.result = data["is_vpn"]
	if(isnull(intel.result))
		return

	intel.date = time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")
	intel.address = address

	cached_queries[address] = intel
	add_intel_to_database(intel)

	return intel

/datum/entity/intel
	var/ip
	var/intel
	var/date

/datum/entity_meta/intel
	entity_type = /datum/entity/intel
	table_name = "intel"
	field_types = list(
		"ip" = DB_FIELDTYPE_STRING_SMALL,
		"intel" = DB_FIELDTYPE_INT,
		"date" = DB_FIELDTYPE_DATE,
	)

/datum/view_record/intel
	var/ip
	var/intel
	var/date

/datum/entity_view_meta/intel
	root_record_type = /datum/entity/intel
	destination_entity = /datum/view_record/intel
	fields = list(
		"ip",
		"intel",
		"date",
	)

/datum/controller/subsystem/ipcheck/proc/add_intel_to_database(datum/ip_intel/intel)
	set waitfor = FALSE //no need to make the client connection wait for this step.

	WAIT_DB_READY

	var/datum/entity/intel/query = DB_ENTITY(/datum/entity/intel)
	query.ip = intel.address
	query.intel = intel.result
	query.date = intel.date

	query.save()
	query.detach()

/datum/controller/subsystem/ipcheck/proc/fetch_cached_ip_intel(address)
	if(!SSentity_manager.ready)
		return

	var/ipcheck_cache_length = CONFIG_GET(number/ipcheck_cache_length)

	var/filter
	if(ipcheck_cache_length > 1)
		var/length_time = time2text(world.realtime - (ipcheck_cache_length * 24 HOURS), "YYYY-MM-DD hh:mm:ss")
		filter = DB_AND(
			DB_COMP("ip", DB_EQUALS, address),
			DB_COMP("date", DB_GREATER, length_time)
		)
	else
		filter = DB_COMP("ip", DB_EQUALS, address)

	var/list/datum/view_record/intel/reports = DB_VIEW(/datum/view_record/intel, filter)
	if(!length(reports))
		return null

	var/datum/view_record/intel/report = reports[1]

	var/datum/ip_intel/intel = new
	intel.result = report.intel
	intel.date = report.date
	intel.address = address

	cached_queries[address] = intel
	return TRUE

/datum/controller/subsystem/ipcheck/proc/is_exempt(client/player)
	if(player.admin_holder)
		return TRUE

	var/exempt_living_playtime = CONFIG_GET(number/ipcheck_exempt_playtime_living)
	if(exempt_living_playtime > 0)
		var/living_minutes = player.get_total_xeno_playtime() + player.get_total_human_playtime()
		if(living_minutes >= exempt_living_playtime)
			return TRUE

	return FALSE

/datum/entity/vpn_whitelist
	var/ckey
	var/admin_ckey

/datum/entity_meta/vpn_whitelist
	entity_type = /datum/entity/vpn_whitelist
	table_name = "vpn_whitelist"
	field_types = list(
		"ckey" = DB_FIELDTYPE_STRING_LARGE,
		"admin_ckey" = DB_FIELDTYPE_STRING_LARGE,
	)

/datum/view/vpn_whitelist
	var/id
	var/ckey
	var/admin_ckey

/datum/entity_view_meta/vpn_whitelist
	root_record_type = /datum/entity/vpn_whitelist
	destination_entity = /datum/view/vpn_whitelist
	fields = list(
		"id",
		"ckey",
		"admin_ckey",
	)

/datum/controller/subsystem/ipcheck/proc/is_whitelisted(ckey)
	var/list/datum/view/vpn_whitelist/whitelists = DB_VIEW(/datum/view/vpn_whitelist, DB_COMP("ckey", DB_EQUALS, ckey))
	return !!length(whitelists)

/client/proc/ipcheck_allow()
	set name = "Whitelist Player VPN"
	set desc = "Allow a player to connect even if they are using a VPN."
	set category = "Admin.VPN"

	if(!CLIENT_HAS_RIGHTS(src, R_BAN))
		return

	var/whitelist_ckey = ckey(tgui_input_text(src, "What's the ckey to be whitelisted?", "Whitelist VPN"))
	if(!whitelist_ckey)
		return

	if (!SSipcheck.is_enabled())
		to_chat(src, "The ipcheck system is not currently enabled but you can still edit the whitelists.")
	if(SSipcheck.is_whitelisted(whitelist_ckey))
		to_chat(src, "Player is already whitelisted.")
		return

	var/datum/entity/vpn_whitelist/whitelist = DB_ENTITY(/datum/entity/vpn_whitelist)
	whitelist.ckey = whitelist_ckey
	whitelist.admin_ckey = ckey

	whitelist.save()
	whitelist.sync()

	message_admins("IPCHECK: [key_name_admin(src)] has whitelisted '[whitelist_ckey]'")

/client/proc/ipcheck_revoke()
	set name = "Dewhitelist Player VPN"
	set desc = "Revoke a player's VPN whitelist."
	set category = "Admin.VPN"

	if(!CLIENT_HAS_RIGHTS(src, R_BAN))
		return

	var/dewhitelist_ckey = ckey(tgui_input_text(src, "What's the ckey to be de-whitelisted?", "Dewhitelist VPN"))
	if(!dewhitelist_ckey)
		return


	if (!SSipcheck.is_enabled())
		to_chat(src, "The ipcheck system is not currently enabled but you can still edit the whitelists.")
	if(!SSipcheck.is_whitelisted(dewhitelist_ckey))
		to_chat(src, "Player is not whitelisted.")
		return

	var/list/datum/view/vpn_whitelist/whitelists = DB_VIEW(/datum/view/vpn_whitelist, DB_COMP("ckey", DB_EQUALS, dewhitelist_ckey))
	if(!length(whitelists))
		to_chat(src, "Player is not whitelisted.")
		return

	for(var/datum/view/vpn_whitelist/whitelist in whitelists)
		var/datum/entity/vpn_whitelist/db_whitelist = DB_ENTITY(/datum/entity/vpn_whitelist, whitelist.id)
		db_whitelist.delete()

	message_admins("IPCHECK: [key_name_admin(src)] has revoked the VPN whitelist for '[dewhitelist_ckey]'")

/client/proc/check_ip_vpn()
	set waitfor = FALSE

	WAIT_DB_READY

	if(!player_entity)
		player_entity = setup_player_entity(ckey)

	if(!SSipcheck.is_enabled(src))
		return

	if(SSipcheck.is_exempt(src) || SSipcheck.is_whitelisted(ckey))
		return

	if(check_localhost_status())
		return

	var/static/queries_today
	if(isnull(queries_today))
		var/list/datum/view_record/intel/intels = DB_VIEW(/datum/view_record/intel, DB_COMP("date", DB_GREATER, time2text(world.realtime - 24 HOURS, "YYYY-MM-DD hh:mm:ss")))
		queries_today = length(intels)

	var/day_limit = CONFIG_GET(number/ipcheck_rate_day)

	if(queries_today == day_limit)
		message_admins("IPCheck has been disabled due to exceeding the day ratelimit.")
		queries_today++

	if(queries_today > day_limit)
		log_access("IPCHECK: [ckey] unable to be checked due to ratelimiting.")
		if(CONFIG_GET(flag/ipcheck_reject_rate_limited))
			to_chat_immediate(src, SPAN_BOLDNOTICE("Your connection cannot be processed at this time."))
			qdel(src)
			return TRUE
		return

	var/intel_state = SSipcheck.get_address_intel_state(address)
	queries_today++

	var/connection_rejected = FALSE
	switch(intel_state)
		if(IPCHECK_BAD_IP)
			if(CONFIG_GET(flag/ipcheck_reject_bad))
				log_access("IPCHECK: [ckey] ([address]) was flagged as a VPN and disconnected.")
				to_chat_immediate(src, SPAN_BOLDNOTICE("Your connection has been detected as a VPN."))
				connection_rejected = TRUE
			else
				log_access("IPCHECK: [ckey] ([address]) was flagged as a VPN and allowed to connect.")
				message_admins("IPCHECK: [key_name_admin(src)] has been flagged as a VPN.")

		if(IPCHECK_UNKNOWN_INTERNAL_ERROR)
			if(CONFIG_GET(flag/ipcheck_reject_unknown))
				log_access("IPCHECK: [ckey] ([address]) unable to be checked due to an error and disconnected.")
				to_chat_immediate(src, SPAN_BOLDNOTICE("Your connection cannot be processed at this time."))
				connection_rejected = TRUE
			else
				log_access("IPCHECK: [ckey] ([address]) unable to be checked due to an error and was allowed to connect.")
				message_admins("IPCHECK: [key_name_admin(src)] was unable to be checked due to an error.")

	if(!connection_rejected)
		return

	var/message_string = "Your connection has been rejected at this time: [CONFIG_GET(string/ipcheck_fail_message)]"

	to_chat_immediate(src, SPAN_USERDANGER(message_string))
	qdel(src)
	return TRUE
