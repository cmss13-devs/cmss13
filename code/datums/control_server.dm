GLOBAL_LIST_EMPTY(ckey_to_controller)

/// Allows us to communicate back to an external localhost webserver
/// This external webserver should have two endpoints, "status" which
/// can return any sort of JSON blob, and "restart" which triggers
/// a reconnection to the game via the provided external measures
/datum/control_server
	/// The client that we are connected to
	var/client/controlling

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

		window.contact = (endpoint) => {
			fetch(`http://localhost:${port}/${endpoint}`).then((response) => {
				const contentType = response.headers.get('content-type');
				if (contentType && contentType.includes('application/json')) {
					response.json().then((object) => {
						BYOND.command(`.controller ${JSON.stringify(object)}`);
					});
				}
			})
		}

		window.pong = () => {
			if (awaitingPong) {
				awaitingPong = false;
				failedPings = 0;
			}
		}

		function ping() {
			if (awaitingPong) {
				failedPings++;
				if (failedPings >= MAX_FAILED_PINGS) {
					failedPings = 0;
					window.contact('restart');
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
						window.contact('restart');
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
	src.port = port

	GLOB.ckey_to_controller[controlling.ckey] = src

/// Initialises our browser and triggers communication with the server
/datum/control_server/proc/setup()
	set waitfor = FALSE

	if(!controlling || !port)
		return

	controlling << browse(replacetext(server_html, "%SERVER_PORT%", port), "window=control-server,size=1x1,titlebar=0,can_resize=0")
	winset(controlling, "control-server", "is-visible=false")

/datum/control_server/proc/send_to_controller(endpoint)
	controlling << output(endpoint, "control-server.browser:contact")

CLIENT_VERB(control_server_input, input as text)
	set name = ".controller"

	var/datum/control_server/controller = GLOB.ckey_to_controller[ckey]
	if(!istype(controller))
		return

	controller.initialised = TRUE

CLIENT_VERB(control_server_ping)
	set name = ".controller_ping"

	var/datum/control_server/controller = GLOB.ckey_to_controller[ckey]
	if(!istype(controller))
		return

	src << output(null, "control-server.browser:pong")
