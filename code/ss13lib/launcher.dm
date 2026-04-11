/datum/ss13lib
	/// The most recent launcher datum for a given ckey, post authentication
	var/list/ckey_to_launcher = list()

	/// If a (cid + ip) combination has been set up with a launcher. This allows us
	/// to be able to determine if a user reconnecting with no parameters should
	/// have their login restored
	var/list/connection_details_has_launcher = list()

/datum/ss13lib/proc/setup_launcher(client/setup_client, port, key)
	var/hash = "[setup_client.address]+[setup_client.computer_id]"
	var/has_existing = (hash in connection_details_has_launcher)

	if(!port || !key)
		if(!has_existing)
			return FALSE
		// port/key are null, but we've seen this connection before — the launcher
		// browser will restore from localStorage

	var/datum/ss13lib_launcher/launcher = new
	launcher.setup(setup_client, port, key)

	ckey_to_launcher[setup_client.ckey] = launcher
	connection_details_has_launcher |= key

	return TRUE

/// Allows for communication with the launcher via the control server
/// secured via the provided key in connection parameters
/datum/ss13lib_launcher
	/// The ckey of the client that we are bound to
	var/attached_ckey
	/// The textref of the client mob that we are bound to
	var/attached_ref

	/// If we are communicating successfully with the launcher
	var/initialised = FALSE

	var/static/html = @{"
<!DOCTYPE html>
<html>

<head>
	<script>
		const port = %LAUNCHER_PORT% || localStorage.getItem('port');
		const key = %LAUNCHER_KEY% || localStorage.getItem('key');

		if(port) localStorage.setItem('port', port);
		if(key) localStorage.setItem('key', key);

		window.contact = (endpoint, params) => {
			if(!port || !key) return;
			const url = params ? `http://localhost:${port}/${endpoint}?${params}` : `http://localhost:${port}/${endpoint}`;
			return fetch(url, {
				headers: { 'Launcher-Key': key },
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
		window.contact("status");
	</script>
</body>

</html>
	"}

/datum/ss13lib_launcher/proc/setup(client/attached_client, port, key)
	set waitfor = FALSE

	SS13LIB_INFO_LOG("Creating launcher for [attached_client].")

	if(!attached_client)
		return

	src.attached_ckey = attached_client.ckey
	src.attached_ref = "\ref[attached_client]"

	var/html_to_send = html

	html_to_send = replacetext(html_to_send, "%LAUNCHER_PORT%", json_encode(port))
	html_to_send = replacetext(html_to_send, "%LAUNCHER_KEY%", json_encode(key))
	html_to_send = replacetext(html_to_send, "%OBJ_REFERENCE%", "\ref[src]")

	attached_client << browse(html_to_send, "window=ss13lib-launcher,size=1x1,titlebar=0,can_resize=0")
	winset(attached_client, "ss13lib-launcher", "is-visible=false")

	return TRUE

/datum/ss13lib_launcher/Topic(href, href_list)
	if(!usr?.client)
		return FALSE

	if(usr.ckey != attached_ckey)
		return

	if(!initialised)
		initialised = TRUE

/// Weakref looks up our client, if they still exist, and our textref is still the same client
/datum/ss13lib_launcher/proc/get_client()
	if(!attached_ckey || !attached_ref)
		return FALSE

	var/client/potential = locate(attached_ref)
	if(!potential || potential.ckey != attached_ckey)
		return FALSE

	return potential

/// Sends a command to the launcher, to perform some specific action
/datum/ss13lib_launcher/proc/send_to_controller(endpoint, params)
	var/params_string = list2params(params)

	var/client/attached = get_client()
	if(!attached)
		return

	attached << output(list2params(list(endpoint, params_string)), "ss13lib-launcher.browser:contact")

/// Indicate to the client that we are restarting, which forces a hard restart
/datum/ss13lib_launcher/proc/restart(reason = "Unknown")
	send_to_controller("restart", list("reason" = reason))
