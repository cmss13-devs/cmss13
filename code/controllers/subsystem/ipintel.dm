SUBSYSTEM_DEF(ipintel)
	name = "IPIntel"
	init_order = SS_INIT_IPINTEL
	flags = SS_NO_INIT|SS_NO_FIRE
	/// The threshold for probability to be considered a VPN and/or bad IP
	var/probability_threshold

	/// Cache for previously queried IP addresses and those stored in the database
	var/list/datum/ip_intel/cached_queries = list()
	/// The store for rate limiting
	var/list/rate_limit_minute

/// The ip intel for a given address
/datum/ip_intel
	/// If this intel was just queried, the status of the query
	var/query_status
	var/result
	var/address
	var/date

/datum/controller/subsystem/ipintel/OnConfigLoad()
	var/list/fail_messages = list()

	var/contact_email = CONFIG_GET(string/ipintel_email)

	if(!length(contact_email))
		fail_messages += "No contact email"

	if(!findtext(contact_email, "@"))
		fail_messages += "Invalid contact email"

	if(!length(CONFIG_GET(string/ipintel_base)))
		fail_messages += "Invalid query base"

	if(length(fail_messages))
		message_admins("IPIntel: Initialization failed check logs!")
		log_debug("IPIntel is not enabled because the configs are not valid: [jointext(fail_messages, ", ")]",)

/datum/controller/subsystem/ipintel/stat_entry(msg)
	return "[..()] | M: [CONFIG_GET(number/ipintel_rate_minute) - rate_limit_minute]"


/datum/controller/subsystem/ipintel/proc/is_enabled()
	return length(CONFIG_GET(string/ipintel_email)) && length(CONFIG_GET(string/ipintel_base))

/datum/controller/subsystem/ipintel/proc/get_address_intel_state(address, probability_override)
	if (!is_enabled())
		return IPINTEL_GOOD_IP
	var/datum/ip_intel/intel = query_address(address)
	if(isnull(intel))
		stack_trace("query_address did not return an ip intel response")
		return IPINTEL_UNKNOWN_INTERNAL_ERROR

	if(istext(intel))
		return intel

	if(!(intel.query_status in list("success", "cached")))
		return IPINTEL_UNKNOWN_QUERY_ERROR
	var/check_probability = probability_override || CONFIG_GET(number/ipintel_rating_bad)
	if(intel.result >= check_probability)
		return IPINTEL_BAD_IP
	return IPINTEL_GOOD_IP

/datum/controller/subsystem/ipintel/proc/is_rate_limited()
	var/static/minute_key
	var/expected_minute_key = floor(REALTIMEOFDAY / 1 MINUTES)

	if(minute_key != expected_minute_key)
		minute_key = expected_minute_key
		rate_limit_minute = 0

	if(rate_limit_minute >= CONFIG_GET(number/ipintel_rate_minute))
		return IPINTEL_RATE_LIMITED_MINUTE
	return FALSE

/datum/controller/subsystem/ipintel/proc/query_address(address, allow_cached = TRUE)
	if (!is_enabled())
		return
	if(allow_cached && fetch_cached_ip_intel(address))
		return cached_queries[address]
	var/is_rate_limited = is_rate_limited()
	if(is_rate_limited)
		return is_rate_limited
	rate_limit_minute += 1

	var/query_base = "https://[CONFIG_GET(string/ipintel_base)]/check.php?ip="
	var/query = "[query_base][address]&contact=[CONFIG_GET(string/ipintel_email)]&flags=b&format=json"

	var/datum/http_request/request = new
	request.prepare(RUSTG_HTTP_METHOD_GET, query)
	request.execute_blocking()
	var/datum/http_response/response = request.into_response()
	var/list/data = json_decode(response.body)

	var/datum/ip_intel/intel = new
	intel.query_status = data["status"]
	if(intel.query_status != "success")
		return intel
	intel.result = data["result"]
	if(istext(intel.result))
		intel.result = text2num(intel.result)
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
		"intel" = DB_FIELDTYPE_DECIMAL,
		"date" = DB_FIELDTYPE_DATE,
	)

/datum/view/intel
	var/ip
	var/intel
	var/date

/datum/entity_view_meta/intel
	root_record_type = /datum/entity/intel
	destination_entity = /datum/view/intel
	fields = list(
		"ip",
		"intel",
		"date",
	)

/datum/controller/subsystem/ipintel/proc/add_intel_to_database(datum/ip_intel/intel)
	set waitfor = FALSE //no need to make the client connection wait for this step.
	WAIT_DB_READY

	var/datum/entity/intel/query = DB_ENTITY(/datum/entity/intel)
	query.ip = intel.address
	query.intel = intel.result
	query.date = world.realtime

	query.save()
	query.sync()

/datum/controller/subsystem/ipintel/proc/fetch_cached_ip_intel(address)
	if(!SSentity_manager.ready)
		return

	var/ipintel_cache_length = CONFIG_GET(number/ipintel_cache_length)

	var/filter
	if(ipintel_cache_length > 1)
		var/length_time = world.realtime - (ipintel_cache_length * 24 HOURS)
		filter = DB_AND(
			DB_COMP("ip", DB_EQUALS, address),
			DB_COMP("date", DB_GREATER, length_time)
		)
	else
		filter = DB_COMP("ip", DB_EQUALS, address)

	var/list/datum/view/intel/reports = DB_VIEW(/datum/view/intel, filter)
	if(!length(reports))
		return null

	var/datum/view/intel/report = reports[1]

	var/datum/ip_intel/intel = new
	intel.query_status = "cached"
	intel.result = report.intel
	intel.date = report.date
	intel.address = address
	return TRUE

/datum/controller/subsystem/ipintel/proc/is_exempt(client/player)
	if(player.admin_holder)
		return TRUE
	var/exempt_living_playtime = CONFIG_GET(number/ipintel_exempt_playtime_living)
	if(exempt_living_playtime > 0)
		var/living_minutes = player.get_total_xeno_playtime() + player.get_total_human_playtime()
		if(living_minutes > exempt_living_playtime)
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

/datum/controller/subsystem/ipintel/proc/is_whitelisted(ckey)
	var/list/datum/view/vpn_whitelist/whitelists = DB_VIEW(/datum/view/vpn_whitelist, DB_COMP("ckey", DB_EQUALS, ckey))
	. = !!length(whitelists)

/client/proc/ipintel_allow()
	set name = "Whitelist Player VPN"
	set desc = "Allow a player to connect even if they are using a VPN."
	set category = "Admin.VPN"

	if(!CLIENT_HAS_RIGHTS(src, R_BAN))
		return

	var/whitelist_ckey = ckey(tgui_input_text(src, "What's the ckey to be whitelisted?", "Whitelist VPN"))
	if(!whitelist_ckey)
		return

	if (!SSipintel.is_enabled())
		to_chat(src, "The ipintel system is not currently enabled but you can still edit the whitelists")
	if(SSipintel.is_whitelisted(whitelist_ckey))
		to_chat(src, "Player is already whitelisted.")
		return

	var/datum/entity/vpn_whitelist/whitelist = DB_ENTITY(/datum/entity/vpn_whitelist)
	whitelist.ckey = whitelist_ckey
	whitelist.admin_ckey = ckey

	whitelist.save()
	whitelist.sync()

	message_admins("IPINTEL: [key_name_admin(src)] has whitelisted '[whitelist_ckey]'")

/client/proc/ipintel_revoke()
	set name = "Dewhitelist Player VPN"
	set desc = "Revoke a player's VPN whitelist."
	set category = "Admin.VPN"

	if(!CLIENT_HAS_RIGHTS(src, R_BAN))
		return

	var/dewhitelist_ckey = ckey(tgui_input_text(src, "What's the ckey to be de-whitelisted?", "Dewhitelist VPN"))
	if(!dewhitelist_ckey)
		return


	if (!SSipintel.is_enabled())
		to_chat(src, "The ipintel system is not currently enabled but you can still edit the whitelists")
	if(!SSipintel.is_whitelisted(dewhitelist_ckey))
		to_chat(src, "Player is not whitelisted.")
		return

	var/list/datum/view/vpn_whitelist/whitelists = DB_VIEW(/datum/view/vpn_whitelist, DB_COMP("ckey", DB_EQUALS, dewhitelist_ckey))
	if(!length(whitelists))
		to_chat(src, "Player is not whitelisted.")
		return

	for(var/datum/view/vpn_whitelist/whitelist in whitelists)
		var/datum/entity/vpn_whitelist/db_whitelist = DB_ENTITY(/datum/entity/vpn_whitelist, whitelist.id)
		db_whitelist.delete()

	message_admins("IPINTEL: [key_name_admin(src)] has revoked the VPN whitelist for '[dewhitelist_ckey]'")

/client/proc/check_ip_intel()
	if (!SSipintel.is_enabled())
		return
	if(SSipintel.is_exempt(src) || SSipintel.is_whitelisted(ckey))
		return

	var/intel_state = SSipintel.get_address_intel_state(address)
	var/reject_bad_intel = CONFIG_GET(flag/ipintel_reject_bad)
	var/reject_unknown_intel = CONFIG_GET(flag/ipintel_reject_unknown)
	var/reject_rate_limited = CONFIG_GET(flag/ipintel_reject_rate_limited)

	var/connection_rejected = FALSE
	var/datum/ip_intel/intel = SSipintel.cached_queries[address]
	switch(intel_state)
		if(IPINTEL_BAD_IP)
			log_access("IPINTEL: [ckey] was flagged as a VPN with [intel.result * 100]% likelihood.")
			if(reject_bad_intel)
				to_chat_immediate(src, SPAN_BOLDNOTICE("Your connection has been detected as a VPN."))
				connection_rejected = TRUE
			else
				message_admins("IPINTEL: [key_name_admin(src)] has been flagged as a VPN with [intel.result * 100]% likelihood.")

		if(IPINTEL_RATE_LIMITED_DAY, IPINTEL_RATE_LIMITED_MINUTE)
			log_access("IPINTEL: [ckey] was unable to be checked due to the rate limit.")
			if(reject_rate_limited)
				to_chat_immediate(src, SPAN_BOLDNOTICE("New connections are not being allowed at this time."))
				connection_rejected = TRUE
			else
				message_admins("IPINTEL: [key_name_admin(src)] was unable to be checked due to rate limiting.")

		if(IPINTEL_UNKNOWN_INTERNAL_ERROR, IPINTEL_UNKNOWN_QUERY_ERROR)
			log_access("IPINTEL: [ckey] unable to be checked due to an error.")
			if(reject_unknown_intel)
				to_chat_immediate(src, SPAN_BOLDNOTICE("Your connection cannot be processed at this time."))
				connection_rejected = TRUE
			else
				message_admins("IPINTEL: [key_name_admin(src)] was unable to be checked due to an error.")

	if(!connection_rejected)
		return

	var/list/contact_where = list()
	var/forum_url = CONFIG_GET(string/forumurl)
	if(forum_url)
		contact_where += list("<a href='[forum_url]'>Forums</a>")
	var/appeal_url = CONFIG_GET(string/banappeals)
	if(appeal_url)
		contact_where += list("<a href='[appeal_url]'>Ban Appeals</a>")

	var/message_string = "Your connection has been rejected at this time. If you believe this is in error or have any questions please contact an admin"
	if(length(contact_where))
		message_string += " at [english_list(contact_where)]"
	else
		message_string += " somehow."
	message_string += "."

	to_chat_immediate(src, SPAN_USERDANGER(message_string))
	qdel(src)
