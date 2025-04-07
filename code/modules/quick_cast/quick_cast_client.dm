/client
	var/atom/hovered_over
	var/atom/last_hover_over_params

/atom/MouseEntered(location, control, params)
	. = ..()
	var/client/client = usr.client
	client.last_hover_over_params = params
	client.hovered_over = src

/atom/MouseExited(location, control, params)
	. = ..()
	usr.client.hovered_over = null
