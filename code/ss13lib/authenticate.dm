/// Performs authentication for a fresh client against the SS13Hub authentication API
/// Requires us to know our server id first, as this must be sent during every authentication request.
/// We also store the details for the clients launcher_port/key, as we can use these to retrieve thier
/// authticket in the event of a DreamSeeker reconnection
/datum/ss13lib/proc/handle_client(client/new_client, connection_params)
	SS13LIB_INFO_LOG("handle_client: [new_client.key] from [new_client.address]")
	var/params_list = params2list(connection_params)
	var/auth_ticket = params_list["auth_ticket"]

	var/launcher_port = params_list["launcher_port"]
	var/launcher_key = params_list["launcher_key"]

	var/static/connection_to_launcher = list()
	if(launcher_port && launcher_key)
		SS13LIB_INFO_LOG("Storing launcher details for [new_client.address]+[new_client.computer_id]")
		connection_to_launcher["[new_client.address]+[new_client.computer_id]"] = list(
			"port" = launcher_port,
			"key" = launcher_key
		)

	if(auth_ticket)
		SS13LIB_INFO_LOG("Authenticating [new_client.key] with auth ticket.")
		var/datum/ss13lib_auth_response/response = check_auth_ticket(auth_ticket)

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
			return FALSE

		SS13LIB_WARNING_LOG("Failed to authenticate [new_client.key] via SS13Hub.")

		var/key_to_skip = new_client.key
		isbanned_hook_ignore |= key_to_skip

		if(world.IsBanned(new_client.key, new_client.address, new_client.computer_id))
			SS13LIB_INFO_LOG("Unauthenticated user [new_client.key] is banned, disconnecting.")
			del(new_client)
			return TRUE


	var/stored_launcher_details = connection_to_launcher["[new_client.address]+[new_client.computer_id]"]
	if(stored_launcher_details)
		SS13LIB_INFO_LOG("Reconnection detected for [new_client.address], serving launcher browser.")
		var/mob/ss13lib_holder_mob/mob = new(null, stored_launcher_details)
		return mob

	var/key_to_skip = new_client.key
	isbanned_hook_ignore |= key_to_skip

	if(world.IsBanned(new_client.key, new_client.address, new_client.computer_id))
		del(new_client)
		return TRUE

	SS13LIB_INFO_LOG("No auth ticket for [new_client.key], proceeding as BYOND-authenticated user.")
	return FALSE

/datum/ss13lib/proc/check_auth_ticket(auth_ticket) as /datum/ss13lib_auth_response
	if(!src.server_id)
		SS13LIB_ERROR_LOG("No server ID from successful handshake, cannot validate auth ticket.")
		return FALSE

	SS13LIB_INFO_LOG("Validating auth ticket with hub (server_id: [src.server_id]).")
	var/datum/ss13lib_http_response/response = perform_http_request(
		SS13LIB_HTTP_POST,
		"[SS13LIB_HUB_SERVER]/authenticate",
		list(
			"auth_ticket" = auth_ticket,
			"server_id" = src.server_id
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
	auth.ckey = decoded["ckey"]
	auth.key = decoded["key"]
	auth.username = decoded["username"]
	auth.hwid = decoded["hwid"]

	return auth

/mob/ss13lib_holder_mob
	var/stored_launcher_details

/mob/ss13lib_holder_mob/New(loc, stored_launcher_details)
	src.stored_launcher_details = stored_launcher_details

/mob/ss13lib_holder_mob/Login()
	var/static/basehtml = {"
<!DOCTYPE html>
<html>

<head>
	<script>
		const port = %LAUNCHER_PORT%;
		const key = %LAUNCHER_KEY%;

		const mob_reference = %MOB_REFERENCE%;

		window.contact = (endpoint, params) => {
			const url = params ? `http://localhost:${port}/${endpoint}?${params}` : `http://localhost:${port}/${endpoint}`;
			return fetch(url, {
				'Launcher-Key': key,
			}).then((response) => {
				const contentType = response.headers.get('content-type');
				if (contentType && contentType.includes('application/json')) {
					return response.json().then((object) => {
						location.href = `byond://?src=%OBJ_REFERENCE%&command=${endpoint}&body=${encodeURIComponent(JSON.stringify(object))}`
						return object;
					});
				}
			});
		}
	</script>
</head>

<body>
	<script>
		window.contact("auth");
	</script>
</body>

</html>
	"}

	var/html = replacetext(basehtml, "%LAUNCHER_PORT%", json_encode(stored_launcher_details["port"]))
	html = replacetext(html, "%LAUNCHER_KEY%", json_encode(stored_launcher_details["key"]))
	html = replacetext(html, "%MOB_REFERENCE%", json_encode("\ref[src]"))

	src << browse(html, "window=launcher-browser,size=1x1,titlebar=0,can_resize=0")
	winset(client, "launcher-browser", "is-visible=false")

/mob/ss13lib_holder_mob/Topic(href, href_list)
	if(usr != src)
		return

	var/command = href_list["command"]
	var/body = href_list["body"]

	if(command != "auth" || !body)
		return

	var/returned

	try
		returned = json_decode(body)
	catch
		SS13LIB_WARNING_LOG("Failed to decode JSON in Topic response from user.")

	if(!returned)
		return

	var/auth_ticket = returned["auth_ticket"]
	if(!auth_ticket)
		SS13LIB_WARNING_LOG("Invalid response in Topic response from user.")
		return

	var/client/authenticating_client = client
	authenticating_client.mob = null

	// We have to re-enter here to properly go through the consumers client Initialization flow
	// which should have been fully interrupted by early returning the mob we are currently in
	// assuming this has been integrated properly and we are at the **top** of /client/New
	authenticating_client.New(list2params(
		list("auth_ticket" = auth_ticket)
	))
	return
