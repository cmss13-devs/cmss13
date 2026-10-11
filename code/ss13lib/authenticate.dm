/// Performs authentication for a fresh client against the SS13Hub authentication API
/// Requires us to know our server id first, as this must be sent during every authentication request.
/// We also store the details for the clients launcher_port/key, as we can use these to retrieve their
/// auth ticket in the event of a DreamSeeker reconnection
/datum/ss13lib/proc/handle_client(client/new_client, connection_params)
	SS13LIB_INFO_LOG("handle_client: [new_client.key] from [new_client.address]")
	var/params_list = params2list(connection_params)

	var/auth_ticket = params_list[SS13LIB_AUTH_TICKET_CODE]

	if(auth_ticket && !auth_method_enabled("hub"))
		SS13LIB_INFO_LOG("Rejecting [new_client.key]: Hub authentication is disabled.")
		del(new_client)
		return TRUE

	var/launcher_port = params_list["launcher_port"]
	var/launcher_key = params_list["launcher_key"]
	var/relayed = is_relayed(new_client)

	if(auth_ticket)
		SS13LIB_INFO_LOG("Authenticating [new_client.key] with auth ticket[relayed ? " (relayed)" : ""].")
		var/datum/ss13lib_auth_response/response = check_auth_ticket(auth_ticket, new_client.address, relayed)

		if(response && relayed && !is_ipv4(response.ip))
			SS13LIB_WARNING_LOG("Hub returned no usable IP for relayed client [new_client.key], treating authentication as failed.")
			response = null

		if(response)
			var/resolved_key = response.key ? response.key : "[response.username][SS13LIB_CKEY_SUFFIX]"

			SS13LIB_INFO_LOG("Auth succeeded for [new_client.key], resolved key: [resolved_key]")

			var/real_ip = is_ipv4(response.ip) ? response.ip : new_client.address
			var/is_banned = world.IsBanned(resolved_key, real_ip, new_client.computer_id, new_client.connection)
			if(is_banned)
				SS13LIB_INFO_LOG("Authenticated user [resolved_key] is banned, disconnecting.")
				del(new_client)
				return TRUE

#ifdef SS13LIB_CLIENT_INFO
			SS13LIB_SAFELY("SS13LIB_CLIENT_INFO", SS13LIB_CLIENT_INFO(new_client) = response)
#endif

			new_client.key = resolved_key
			if(is_ipv4(response.ip))
				hub_ips[new_client.ckey] = response.ip
			setup_launcher(new_client, launcher_port, launcher_key)
			return FALSE

		SS13LIB_WARNING_LOG("Failed to authenticate [new_client.key] via SS13Hub.")

		if(relayed)
			return hold_relayed_client(new_client, "had a ticket that failed to validate", launcher_port, launcher_key)

		if(!auth_method_enabled("byond"))
			SS13LIB_WARNING_LOG("Rejecting [new_client.key]: Hub authentication failed and BYOND authentication is disabled.")
			del(new_client)
			return TRUE

		if(reject_hub_suffix(new_client))
			return TRUE

		var/key_to_skip = new_client.key
		isbanned_hook_ignore |= key_to_skip

		if(world.IsBanned(new_client.key, new_client.address, new_client.computer_id, new_client.connection))
			SS13LIB_INFO_LOG("Unauthenticated user [new_client.key] is banned, disconnecting.")
			del(new_client)
			return TRUE

		return FALSE

	if(relayed)
		return hold_relayed_client(new_client, "had no ticket", launcher_port, launcher_key)

	var/hash = "[new_client.address]+[new_client.computer_id]"
	if(is_guest(new_client.key) && (hash in connection_details_has_launcher))
		SS13LIB_INFO_LOG("Reconnection detected for [new_client.address], serving launcher browser.")

		var/mob/ss13lib_holder_mob/holder = new(null)
		holder.launcher_port = launcher_port
		holder.launcher_key = launcher_key
		new_client.mob = holder
		return holder
	if(!auth_method_enabled("byond"))
		SS13LIB_INFO_LOG("Rejecting [new_client.key]: BYOND authentication is disabled.")
		del(new_client)
		return TRUE

	if(reject_hub_suffix(new_client))
		return TRUE

	var/key_to_skip = new_client.key
	isbanned_hook_ignore |= key_to_skip

	if(world.IsBanned(new_client.key, new_client.address, new_client.computer_id, new_client.connection))
		del(new_client)
		return TRUE

	SS13LIB_INFO_LOG("No auth ticket for [new_client.key], proceeding as BYOND-authenticated user.")
	return FALSE

/datum/ss13lib/proc/auth_method_enabled(method)
#ifdef SS13LIB_AUTH_METHODS
	// If the codebase's list fails, only accept SS13Hub tickets rather than open up BYOND-key logins
	var/list/methods = list("hub")
	SS13LIB_SAFELY("SS13LIB_AUTH_METHODS", methods = SS13LIB_AUTH_METHODS)
	return method in methods
#else
	return TRUE
#endif

/// Relayed players must authenticate with an SS13Hub ticket, make them reauthenticate in the holder mob
/datum/ss13lib/proc/hold_relayed_client(client/new_client, reason, launcher_port, launcher_key)
	SS13LIB_INFO_LOG("Relayed connection from [new_client.key] [reason], waiting for the launcher to supply a ticket.")
	var/mob/ss13lib_holder_mob/holder = new(null)
	holder.disconnect_after = SS13LIB_RELAY_HOLDER_TIMEOUT
	holder.launcher_port = launcher_port
	holder.launcher_key = launcher_key
	new_client.mob = holder
	return holder

/datum/ss13lib/proc/check_auth_ticket(auth_ticket, client_ip, relayed = FALSE) as /datum/ss13lib_auth_response
	if(!src.server_id)
		SS13LIB_ERROR_LOG("No server ID from successful handshake, cannot validate auth ticket.")
		return FALSE

	var/list/body = list(
		"auth_ticket" = auth_ticket,
		"server_id" = src.server_id,
		"client_ip" = length(client_ip) ? client_ip : "127.0.0.1",
	)
	// The relay's address can't match the IP the ticket was requested from, so the hub skips
	// that comparison for relayed clients and the player's real IP comes back as `ip`
	if(relayed)
		body["relayed"] = TRUE

	SS13LIB_INFO_LOG("Validating auth ticket with hub (server_id: [src.server_id]).")
	var/datum/ss13lib_http_response/response = perform_http_request(
		SS13LIB_HTTP_POST,
		"[SS13LIB_HUB_SERVER]/authenticate",
		body,
	)

	if(!response || response.errored)
		SS13LIB_ERROR_LOG("Failed to communicate with authentication server (status: [response?.status_code]).")
		return FALSE

	SS13LIB_INFO_LOG("Auth server responded with status [response.status_code].")

	var/decoded

	try
		decoded = json_decode(response.body)
	catch(var/exception/decode_error)
		SS13LIB_ERROR_LOG("Failed to decode JSON response from server: [decode_error.name]")
		SS13LIB_ERROR_LOG("Response body: [response.body]")
		return FALSE

	if(!decoded || !length(decoded))
		SS13LIB_ERROR_LOG("Failed to parse JSON response from server.")
		return FALSE

	if(!decoded["username"])
		SS13LIB_ERROR_LOG("Server responded with an invalid result: [response.body]")
		return FALSE

	SS13LIB_INFO_LOG("Auth ticket validated, username: [decoded["username"]]")

	var/datum/ss13lib_auth_response/auth = new
	auth.user_id = decoded["user_id"]
	auth.key = decoded["key"]
	auth.username = decoded["username"]
	auth.created_at = decoded["created_at"]
	auth.hwid = decoded["hwid"]
	auth.hwid_uniqueness = decoded["hwid_uniqueness"]
	auth.discord_id = decoded["discord_id"]
	auth.steam_id = decoded["steam_id"]
	auth.steam_limited = decoded["steam_limited"]
	auth.ip = decoded["ip"]

	return auth

/// We create a browser that will communicate with the launcher to grab our auth ticket
/// and then rejoin the game with .url to avoid re-entering /client/New() with a client.
/// We assume that we have already successfully created a normal launcher datum
/mob/ss13lib_holder_mob
	/// If set, disconnect the client after this long (deciseconds) if they're still here, i.e.
	/// the launcher never supplied a ticket. Used for relayed clients, which can't fall back to
	/// BYOND-key authentication.
	var/disconnect_after
	/// The launcher's control server port and key from the connection parameters, if present.
	/// DreamSeeker keeps its connection URL when reconnecting, so these reach the launcher that
	/// started it even when the browser's localStorage doesn't have them (e.g. a new DreamSeeker).
	var/launcher_port
	var/launcher_key

/mob/ss13lib_holder_mob/Login()
	SS13LIB_INFO_LOG("[ckey] logging into holder mob.")

	var/static/basehtml = @{"
<!DOCTYPE html>
<html>

<head></head>

<body>
	<script>
		(function() {
			const port = %LAUNCHER_PORT% || localStorage.getItem('port');
			const key = %LAUNCHER_KEY% || localStorage.getItem('key');

			if(!port || !key) {
				return;
			}

			fetch(`http://localhost:${port}/auth-ticket`, {
					headers: { 'Launcher-Key': key },
			}).then((response) => {
				const contentType = response.headers.get('content-type');
				if (contentType && contentType.includes('application/json')) {
					return response.json().then((returned) => {
						BYOND.winget(null, "url").then((url) => {
							BYOND.command(`.url ${url.url}?auth_ticket=${returned["auth_ticket"]}`)
						})
					});
				}
			});
		})();
	</script>
</body>

</html>
	"}

	var/html = replacetext(basehtml, "%LAUNCHER_PORT%", json_encode(launcher_port))
	html = replacetext(html, "%LAUNCHER_KEY%", json_encode(launcher_key))
	src << browse(html, "window=ss13lib-reconnection-launcher,size=1x1,titlebar=0,can_resize=0")
	winset(client, "ss13lib-reconnection-launcher", "is-visible=false")

	if(disconnect_after)
		disconnect_if_still_holding()

/mob/ss13lib_holder_mob/proc/disconnect_if_still_holding()
	set waitfor = FALSE
	sleep(disconnect_after)
	if(!client)
		return
	SS13LIB_INFO_LOG("[ckey] received no ticket from the launcher, disconnecting.")
	src << "This connection requires the SS13 launcher. Please reconnect through the launcher."
	del(client)
