GLOBAL_LIST_EMPTY(ckey_to_controller)

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
						BYOND.command(`.controller ${JSON.stringify(object)}`);
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
	src.controlling = controlling
	src.controlling_ckey = controlling.ckey
	src.port = port

	GLOB.ckey_to_controller[controlling.ckey] = src

	RegisterSignal(controlling, COMSIG_PARENT_QDELETING, PROC_REF(handle_parent_qdel))
	RegisterSignal(controlling, COMSIG_CLIENT_MOB_LOGGED_IN, PROC_REF(handle_parent_login))

/datum/control_server/Destroy(force, ...)
	. = ..()

	GLOB.ckey_to_controller -= controlling_ckey

/// Initialises our browser and triggers communication with the server
/datum/control_server/proc/setup()
	set waitfor = FALSE

	if(!controlling || !port)
		return

	controlling << browse(replacetext(server_html, "%SERVER_PORT%", port), "window=control-server,size=1x1,titlebar=0,can_resize=0")
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

/client/verb/control_server_input(input as text)
	set name = ".controller"
	set hidden = TRUE
	set category = null

	var/datum/control_server/controller = GLOB.ckey_to_controller[ckey]
	if(!istype(controller))
		return

	controller.initialised = TRUE

/client/verb/control_server_ping()
	set name = ".controller_ping"
	set hidden = TRUE
	set category = null

	var/datum/control_server/controller = GLOB.ckey_to_controller[ckey]
	if(!istype(controller))
		return

	src << output(null, "control-server.browser:pong")
