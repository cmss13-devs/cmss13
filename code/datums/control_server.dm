/// Allows us to communicate back to an external localhost webserver
/// This external webserver should have two endpoints, "status" which
/// can return any sort of JSON blob, and "restart" which triggers
/// a reconnection to the game via the provided external measures
/datum/control_server
	/// The client that we are connected to
	var/client/controlling

	/// The ckey of the client we are connected to
	var/controlling_ckey

	/// The port that their external software is running on
	var/port

	/// If our software has responded successfully, and our browser has initialised
	var/initialised = FALSE

	var/static/server_html = {"
<!DOCTYPE html>
<html>

<head>
	<script>
		const port = %SERVER_PORT%;

		let failedPings = 0;
		let awaitingPong = false;

		const MAX_FAILED_PINGS = 3;
		const PING_INTERVAL = 2000;
		const PONG_TIMEOUT = 1500;

		window.contact = (endpoint, params) => {
			const url = params ? `http://localhost:${port}/${endpoint}?${params}` : `http://localhost:${port}/${endpoint}`;
			return fetch(url).then((response) => {
				const contentType = response.headers.get('content-type');
				if (contentType && contentType.includes('application/json')) {
					return response.json().then((object) => {
						location.href = `byond://?src=%OBJ_REFERENCE%&command=${endpoint}&body=${encodeURIComponent(JSON.stringify(object))}`
						return object;
					});
				}
			});
		}

		window.reconnect = () => {
			window.contact('get-url').then((response) => {
				if (response?.url) {
					BYOND.command(`.url ${response.url}`)
				}
			});
		}

		function ping() {
			if (awaitingPong) {
				failedPings++;
				if (failedPings >= MAX_FAILED_PINGS) {
					failedPings = 0;
					window.reconnect();
					return;
				}
			}
			awaitingPong = true;
			location.href = "byond://?src=%OBJ_REFERENCE%&command=ping"
			BYOND.command('.controller_ping');
			setTimeout(() => {
				if (awaitingPong) {
					failedPings++;
					awaitingPong = false;
					if (failedPings >= MAX_FAILED_PINGS) {
						failedPings = 0;
						window.reconnect();
					}
				}
			}, PONG_TIMEOUT);
		}

		setInterval(ping, PING_INTERVAL);
	</script>
</head>

<body>
	<script>
		window.contact("status");
	</script>
</body>

</html>
"}

/datum/control_server/New(client/controlling, port)
	controlling.control_server = src

	src.controlling = controlling
	src.controlling_ckey = controlling.ckey
	src.port = port

	RegisterSignal(controlling, COMSIG_PARENT_QDELETING, PROC_REF(handle_parent_qdel))
	RegisterSignal(controlling, COMSIG_CLIENT_MOB_LOGGED_IN, PROC_REF(handle_parent_login))

/datum/control_server/Destroy(force, ...)
	. = ..()

	controlling.control_server = null
	controlling = null

/datum/control_server/Topic(href, href_list)
	if(!usr?.client)
		return FALSE

	if(usr.client.control_server != src)
		return FALSE

	if(!initialised)
		initialised = TRUE

	if(href_list["command"] == "ping")
		usr << output(null, "control-server.browser:pong")

/// Initialises our browser and triggers communication with the server
/datum/control_server/proc/setup()
	set waitfor = FALSE

	if(!controlling || !port)
		return

	var/html_to_send = replacetext(server_html, "%SERVER_PORT%", port)
	html_to_send = replacetext(html_to_send, "%OBJ_REFERENCE%", "\ref[src]")

	controlling << browse(html_to_send, "window=control-server,size=1x1,titlebar=0,can_resize=0")
	winset(controlling, "control-server", "is-visible=false")

/datum/control_server/proc/restart(reason = "Unknown")
	send_to_controller("restart", list("reason" = reason))

/datum/control_server/proc/send_to_controller(endpoint, params)
	var/params_string = list2params(params)

	controlling << output(list2params(list(endpoint, params_string)), "control-server.browser:contact")

/datum/control_server/proc/handle_parent_qdel()
	SIGNAL_HANDLER

	qdel(src)

/datum/control_server/proc/handle_parent_login(client/parent, mob/new_mob)
	SIGNAL_HANDLER

	addtimer(CALLBACK(parent, TYPE_PROC_REF(/client, enable_hardware_graphics)), 1 SECONDS)
