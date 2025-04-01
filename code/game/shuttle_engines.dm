/obj/structure/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'

/obj/structure/shuttle/window
	name = "shuttle window"
	icon = 'icons/turf/podwindows.dmi'
	icon_state = "1"
	density = TRUE
	opacity = FALSE
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE
	layer = WINDOW_LAYER

/obj/structure/shuttle/window/ex_act(severity)
	return

/obj/structure/shuttle/window/fire_act(exposed_temperature, exposed_volume)
	return

/obj/structure/shuttle/engine
	name = "engine"
	density = TRUE
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/shuttle/engine/heater
	name = "heater"
	icon_state = "heater"

/obj/structure/shuttle/engine/platform
	name = "platform"
	icon_state = "platform"

/obj/structure/shuttle/engine/propulsion
	name = "propulsion"
	icon_state = "propulsion"
	opacity = TRUE

/obj/structure/shuttle/engine/propulsion/burst
	name = "burst"

/obj/structure/shuttle/engine/propulsion/burst/left
	name = "left"
	icon_state = "burst_l"

/obj/structure/shuttle/engine/propulsion/burst/right
	name = "right"
	icon_state = "burst_r"

/obj/structure/shuttle/engine/router
	name = "router"
	icon_state = "router"

/obj/structure/shuttle/diagonal
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "diagonalWall"
	name = "wall"
	layer = ABOVE_TURF_LAYER
	density = TRUE
