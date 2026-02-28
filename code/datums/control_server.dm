/// If this client is attached to a controller, which allows for sending updates to external software
/client/var/datum/control_server/control_server

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

	/// If supported, the websocket port for software initiated events
	var/websocket_port

	/// If our software has responded successfully, and our browser has initialised
	var/initialised = FALSE

	var/static/server_html = {"
<!DOCTYPE html>
<html>

<head>
	<script>
		const port = %SERVER_PORT%;
		const websocket_port = %WEBSOCKET_PORT%;

		let ws = null;

		let saved_splitter = null;

		const onSteamOverlay = (data) => {
			if(data.active) {
				BYOND.winget("split", "splitter").then((value) => {
					saved_splitter = value;

					BYOND.winset("", {
						"split.splitter": "100",
						"map.letterbox": "false",
					})
				})
			} else if (saved_splitter !== null) {
				BYOND.winset("", {
					"split.splitter": saved_splitter.splitter,
					"map.letterbox": "true",
				})
			}
		};

		const connectWebSocket = () => {
			if (!websocket_port || websocket_port === 0) return;

			ws = new WebSocket(`ws://localhost:${websocket_port}`);

			ws.onmessage = (event) => {
				try {
					const message = JSON.parse(event.data);
					if (message.type === 'steam_overlay') {
						onSteamOverlay(message.data);
					}
				} catch (e) {
					console.error('Failed to parse WebSocket message:', e);
				}
			};

			ws.onclose = () => {
				setTimeout(connectWebSocket, 5000);
			};
		};

		document.addEventListener('DOMContentLoaded', connectWebSocket);

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

		window.pong = () => {
			if (awaitingPong) {
				awaitingPong = false;
				failedPings = 0;
			}
		}

		const ping = () => {
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
		};

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

/datum/control_server/New(client/controlling, topic_headers)
	controlling.control_server = src

	src.controlling = controlling
	src.controlling_ckey = controlling.ckey
	src.port = topic_headers["launcher_port"]
	src.websocket_port = topic_headers["websocket_port"]

	RegisterSignal(controlling, COMSIG_PARENT_QDELETING, PROC_REF(handle_parent_qdel))
	RegisterSignal(controlling, COMSIG_CLIENT_LOGGED_IN, PROC_REF(handle_client_postlogin))

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

	var/html_to_send = server_html

	html_to_send = replacetext(html_to_send, "%SERVER_PORT%", port)
	html_to_send = replacetext(html_to_send, "%WEBSOCKET_PORT%", websocket_port ? websocket_port : "0")
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

/datum/control_server/proc/handle_client_postlogin(client/logged_in)
	SIGNAL_HANDLER

	UnregisterSignal(logged_in, COMSIG_CLIENT_LOGGED_IN)

	if(!handle_parent_login(logged_in, logged_in.mob))
		RegisterSignal(controlling, COMSIG_CLIENT_MOB_LOGGED_IN, PROC_REF(handle_parent_login))

/datum/control_server/proc/handle_parent_login(client/parent, mob/new_mob)
	SIGNAL_HANDLER

	if(istype(new_mob, /mob/new_player))
		return FALSE

	UnregisterSignal(parent, COMSIG_CLIENT_MOB_LOGGED_IN)
	addtimer(CALLBACK(parent, TYPE_PROC_REF(/client, reset_graphics)), 1 DECISECONDS)
	return TRUE
