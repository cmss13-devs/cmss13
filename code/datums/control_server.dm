GLOBAL_LIST_EMPTY(ckey_to_controller)

/datum/control_server
	var/client/controlling
	var/port

	var/initialised = FALSE

	var/static/server_html = {"
<!DOCTYPE html>
<html>
  <head>
    <script>
      window.contact = (endpoint) => {
      	const port = %SERVER_PORT%;
      	fetch(`http://localhost:${port}/${endpoint}`).then((response) => {
			const contentType = response.headers.get('content-type');
			if (contentType && contentType.includes('application/json')) {
				response.json().then((object) => {
					BYOND.command(`.controller ${JSON.stringify(object)}`);
				});
			}
		})
      }
    </script>
  </head>
</html>
"}

/datum/control_server/New(client/controlling, port)
	src.controlling = controlling
	src.port = port

	GLOB.ckey_to_controller[controlling.ckey] = src

/datum/control_server/proc/setup()
	set waitfor = FALSE

	if(!controlling || !port)
		return

	controlling << browse(replacetext(server_html, "%SERVER_PORT%", port), "window=control-server,size=1x1")
	winset(controlling, "control-server", "is-visible=false")

	sleep(5)

	send_to_controller("status")

/datum/control_server/proc/send_to_controller(endpoint)
	controlling << output(endpoint, "control-server.browser:contact")

CLIENT_VERB(control_server_input)
	set name = ".controller"

	var/datum/control_server/controller = GLOB.ckey_to_controller[ckey]
	if(!istype(controller))
		return

	controller.initialised = TRUE
