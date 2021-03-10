/obj/structure/machinery/gear
	name = "\improper gear"
	icon_state = "gear"
	anchored = 1
	density = 0
	unslashable = TRUE
	unacidable = TRUE
	use_power = 0
	var/id

/obj/structure/machinery/gear/proc/start_moving(direction = NORTH)
	icon_state = "gear_moving"
	setDir(direction)

/obj/structure/machinery/gear/proc/stop_moving()
	icon_state = "gear"

/obj/structure/machinery/elevator_strut
	name = "\improper strut"
	icon = 'icons/turf/elevator_strut.dmi'
	anchored = 1
	unslashable = TRUE
	unacidable = TRUE
	density = 0
	use_power = 0
	opacity = 1
	layer = ABOVE_MOB_LAYER
	var/id

/obj/structure/machinery/elevator_strut/top
	icon_state = "strut_top"

/obj/structure/machinery/elevator_strut/bottom
	icon_state = "strut_bottom"

