/obj/structure/machinery/gear
	name = "\improper gear"
	icon_state = "gear"
	anchored = TRUE
	density = FALSE
	unslashable = TRUE
	unacidable = TRUE
	use_power = USE_POWER_NONE
	var/id

/obj/structure/machinery/gear/proc/start_moving(direction = NORTH)
	icon_state = "gear_moving"
	setDir(direction)

/obj/structure/machinery/gear/proc/stop_moving()
	icon_state = "gear"

/obj/structure/machinery/gear/upp
	id = "supply_elevator_railing_upp"

/obj/structure/machinery/elevator_strut
	name = "\improper strut"
	icon = 'icons/turf/elevator_strut.dmi'
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE
	density = FALSE
	use_power = USE_POWER_NONE
	opacity = TRUE
	layer = ABOVE_MOB_LAYER
	var/id

/obj/structure/machinery/elevator_strut/top
	icon_state = "strut_top"

/obj/structure/machinery/elevator_strut/bottom
	icon_state = "strut_bottom"


