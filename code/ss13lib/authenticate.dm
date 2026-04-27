/// Performs authentication for a fresh client against the SS13Hub authentication API
/// Requires us to know our server id first, as this must be sent during every authentication request.
/// We also store the details for the clients launcher_port/key, as we can use these to retrieve their
/// auth ticket in the event of a DreamSeeker reconnection
/datum/ss13lib/proc/handle_client(client/new_client, connection_params)
	SS13LIB_INFO_LOG("handle_client: [new_client.key] from [new_client.address]")
	var/params_list = params2list(connection_params)
	var/auth_ticket = params_list["auth_ticket"]

	var/launcher_port = params_list["launcher_port"]
	var/launcher_key = params_list["launcher_key"]

	if(auth_ticket)
		SS13LIB_INFO_LOG("Authenticating [new_client.key] with auth ticket.")
		var/datum/ss13lib_auth_response/response = check_auth_ticket(auth_ticket, new_client.address)

		if(response)
			var/resolved_key = response.key ? response.key : "[response.username][SS13LIB_CKEY_SUFFIX]"
			isbanned_hook_ignore |= resolved_key

			SS13LIB_INFO_LOG("Auth succeeded for [new_client.key], resolved key: [resolved_key]")

			var/is_banned = world.IsBanned(resolved_key, new_client.address, new_client.computer_id)
			if(is_banned)
				SS13LIB_INFO_LOG("Authenticated user [resolved_key] is banned, disconnecting.")
				del(new_client)
				return TRUE

#ifdef SS13LIB_CLIENT_INFO
			SS13LIB_CLIENT_INFO(new_client) = response
#endif

			new_client.key = resolved_key
			setup_launcher(new_client, launcher_port, launcher_key)
			return FALSE

		SS13LIB_WARNING_LOG("Failed to authenticate [new_client.key] via SS13Hub.")

		var/key_to_skip = new_client.key
		isbanned_hook_ignore |= key_to_skip

		if(world.IsBanned(new_client.key, new_client.address, new_client.computer_id))
			SS13LIB_INFO_LOG("Unauthenticated user [new_client.key] is banned, disconnecting.")
			del(new_client)
			return TRUE

		return FALSE

	var/hash = "[new_client.address]+[new_client.computer_id]"
	if(is_guest(new_client.key) && (hash in connection_details_has_launcher))
		SS13LIB_INFO_LOG("Reconnection detected for [new_client.address], serving launcher browser.")

		new_client.mob = new /mob/ss13lib_holder_mob(null)
		return new_client.mob

	var/key_to_skip = new_client.key
	isbanned_hook_ignore |= key_to_skip

	if(world.IsBanned(new_client.key, new_client.address, new_client.computer_id))
		del(new_client)
		return TRUE

	SS13LIB_INFO_LOG("No auth ticket for [new_client.key], proceeding as BYOND-authenticated user.")
	return FALSE

/datum/ss13lib/proc/check_auth_ticket(auth_ticket, client_ip) as /datum/ss13lib_auth_response
	if(!src.server_id)
		SS13LIB_ERROR_LOG("No server ID from successful handshake, cannot validate auth ticket.")
		return FALSE

	SS13LIB_INFO_LOG("Validating auth ticket with hub (server_id: [src.server_id]).")
	var/datum/ss13lib_http_response/response = perform_http_request(
		SS13LIB_HTTP_POST,
		"[SS13LIB_HUB_SERVER]/authenticate",
		list(
			"auth_ticket" = auth_ticket,
			"server_id" = src.server_id,
			"client_ip" = client_ip
		)
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
	auth.key = decoded["key"]
	auth.username = decoded["username"]
	auth.created_at = decoded["created_at"]
	auth.hwid = decoded["hwid"]
	auth.discord_id = decoded["discord_id"]
	auth.steam_id = decoded["steam_id"]

	return auth

/// We create a browser that will communicate with the launcher to grab our auth ticket
/// and then rejoin the game with .url to avoid re-entering /client/New() with a client.
/// We assume that we have already successfully created a normal launcher datum
/mob/ss13lib_holder_mob/Login()
	SS13LIB_INFO_LOG("[ckey] logging into holder mob.")

	var/static/basehtml = @{"
<!DOCTYPE html>
<html>

<head></head>

<body>
	<script>
		(function() {
			const port = localStorage.getItem('port');
			const key = localStorage.getItem('key');

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

	src << browse(basehtml, "window=ss13lib-reconnection-launcher,size=1x1,titlebar=0,can_resize=0")
	winset(client, "ss13lib-reconnection-launcher", "is-visible=false")
