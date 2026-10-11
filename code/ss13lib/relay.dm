/// ss13relay support. Accepts Steam Datagram Relay connections from the SS13 launcher and forwards them to DreamDaemon. It announces itself with a Topic, both
/// periodically and immediately before each player connection it forwards, so the address the
/// announce arrives from is exactly the address relayed players arrive from.

/datum/ss13lib
	/// The address our ss13relay connects to DreamDaemon from, per its most recent announce.
	/// One relay per server: the latest announce wins.
	var/relay_address
	/// The relay's Steam details, reported to the hub for the server listing.
	var/list/relay_info
	/// world.time of the most recent valid announce.
	var/relay_last_announce = 0
	/// If we've already warned this round about a rejected announce.
	var/relay_rejection_warned = FALSE
	/// Real IPs of players who authenticated with an SS13Hub ticket, by ckey.
	var/list/hub_ips = list()

/// Handles an announce Topic from an ss13relay. `address` is the Topic's sender.
/datum/ss13lib/proc/handle_relay_announce(list/parameters, address)
#ifndef SS13LIB_RELAY_ENABLED
	return json_encode(list("status" = "rejected"))
#else
#ifndef SS13LIB_RELAY_SECRET
#error SS13LIB_RELAY_SECRET must be defined if SS13LIB_RELAY_ENABLED is defined.
#endif
	var/expected_secret
	SS13LIB_SAFELY("SS13LIB_RELAY_SECRET", expected_secret = SS13LIB_RELAY_SECRET)
	if(!length(expected_secret) || parameters["secret"] != expected_secret)
		warn_relay_rejection("[length(expected_secret) ? "wrong secret" : "SS13LIB_RELAY_SECRET is not configured"]", address)
		return json_encode(list("status" = "rejected"))

	var/static/regex/steam_id_regex = regex(@"^\d{1,20}$")
	var/steam_id = parameters["steam_id"]
	var/port = text2num(parameters["port"])
	var/ping_location = parameters["ping_location"]
	if(!istext(steam_id) || !steam_id_regex.Find(steam_id) || !port || !istext(ping_location) || !length(ping_location))
		warn_relay_rejection("malformed announce", address)
		return json_encode(list("status" = "rejected"))

	var/relay_from = normalize_relay_address(address)
	if(relay_from != relay_address || !relay_info || relay_info["steam_id"] != steam_id)
		SS13LIB_INFO_LOG("ss13relay announced from [relay_from] (SteamID [steam_id], port [port]).")

	if(relay_from != relay_address)
		world.SetConfig("env", SS13LIB_RELAY_ADDRESS_ENV, relay_from)
	relay_address = relay_from
	relay_info = list("steam_id" = steam_id, "virtual_port" = port, "ping_location" = ping_location)
	relay_last_announce = world.time
	return json_encode(list("status" = "ok"))
#endif

/// world.Reboot() keeps players connected and runs them through /client/New again in the new
/// world, without the relay reconnecting or announcing. So the relay's address is kept in a
/// process environment variable, which survives reboots (same DreamDaemon process) but not a
/// DreamDaemon restart (which drops every connection, and new connections are announced anyway).
/datum/ss13lib/proc/restore_relay_address()
#ifdef SS13LIB_RELAY_ENABLED
	var/stored = world.GetConfig("env", SS13LIB_RELAY_ADDRESS_ENV)
	if(length(stored))
		relay_address = stored
		SS13LIB_INFO_LOG("Restored ss13relay address [stored] from before the reboot.")
#endif

/// Warn once per round, since the relay retries every 60 seconds.
/datum/ss13lib/proc/warn_relay_rejection(reason, address)
	if(relay_rejection_warned)
		return
	relay_rejection_warned = TRUE
	SS13LIB_WARNING_LOG("Rejected an ss13relay announce from [address]: [reason].")

/// Topic senders may be reported with a port, and loopback may be reported as null.
/datum/ss13lib/proc/normalize_relay_address(address)
	if(!length(address))
		return "127.0.0.1"
	var/port_index = findtext(address, ":")
	if(port_index)
		return copytext(address, 1, port_index)
	return address

/// If a client is connected through our ss13relay.
/datum/ss13lib/proc/is_relayed(client/C)
#ifdef SS13LIB_RELAY_ENABLED
	if(!C || !relay_address)
		return FALSE
	var/address = C.address
	// BYOND may report loopback clients with a null address, while the relay's announce carries
	// its exact loopback address (e.g. 127.0.0.2)
	if(!length(address))
		return findtext(relay_address, "127.") == 1
	return address == relay_address
#else
	return FALSE
#endif

/// The real IP of a client: from their SS13Hub ticket if they used one, otherwise their address.
/datum/ss13lib/proc/client_address(client/C)
	if(!C)
		return null
	return hub_ips[C.ckey] || C.address

/// Relay details for our status response, if the relay has announced recently enough to still
/// be running. It announces every 60 seconds; once it stops, the hub drops it from the listing.
/datum/ss13lib/proc/relay_status()
#ifdef SS13LIB_RELAY_ENABLED
	if(relay_info && world.time - relay_last_announce < SS13LIB_RELAY_INFO_TTL)
		return relay_info
#endif
	return null

/datum/ss13lib/proc/is_ipv4(address)
	var/static/regex/ipv4_regex = regex(@"^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$")
	return istext(address) && ipv4_regex.Find(address)
