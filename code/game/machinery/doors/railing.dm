/obj/structure/machinery/door/poddoor/railing
	name = "\improper retractable railing"
	icon = 'icons/obj/structures/doors/railing.dmi'
	icon_state = "railing0"
	climbable = TRUE
	use_power = USE_POWER_NONE
	flags_atom = ON_BORDER
	opacity = FALSE
	unslashable = TRUE
	unacidable = TRUE
	projectile_coverage = PROJECTILE_COVERAGE_LOW

	throwpass = TRUE //You can throw objects over this, despite its density.
	open_layer = CATWALK_LAYER
	closed_layer = WINDOW_LAYER
	density = TRUE

/obj/structure/machinery/door/poddoor/railing/Initialize()
	. = ..()
	if(dir == SOUTH)
		closed_layer = ABOVE_MOB_LAYER
	if(density)//Allows preset-open to work
		layer = closed_layer

	set_opacity(initial(opacity))

/obj/structure/machinery/door/poddoor/railing/update_icon()
	if(density)
		icon_state = "railing1"
	else
		icon_state = "railing0"

/obj/structure/machinery/door/poddoor/railing/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = (PASS_OVER^PASS_OVER_FIRE)|PASS_CRUSHER_CHARGE

/obj/structure/machinery/door/poddoor/railing/open(forced = FALSE)
	if(operating && !forced) //doors can still open when emag-disabled
		return FALSE
	if(!loc)
		return FALSE

	operating = DOOR_OPERATING_OPENING
	flick("railingc0", src)
	icon_state = "railing0"
	layer = open_layer

	addtimer(CALLBACK(src, PROC_REF(finish_open)), 1.2 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)
	return TRUE

/obj/structure/machinery/door/poddoor/railing/finish_open()
	if(operating != DOOR_OPERATING_OPENING)
		return

	density = FALSE
	operating = DOOR_OPERATING_IDLE

/obj/structure/machinery/door/poddoor/railing/close(forced = FALSE)
	if(operating)
		return FALSE

	density = TRUE
	operating = DOOR_OPERATING_CLOSING
	layer = closed_layer
	flick("railingc1", src)
	icon_state = "railing1"

	addtimer(CALLBACK(src, PROC_REF(finish_close)), 1.2 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)
	return TRUE

/obj/structure/machinery/door/poddoor/railing/finish_close()
	if(operating != DOOR_OPERATING_CLOSING)
		return

	operating = DOOR_OPERATING_IDLE

/obj/structure/machinery/door/poddoor/railing/open
	density = FALSE

/obj/structure/machinery/door/poddoor/railing/upp
	id = "supply_elevator_railing_upp"
