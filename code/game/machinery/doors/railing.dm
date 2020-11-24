/obj/structure/machinery/door/poddoor/railing
	name = "\improper retractable railing"
	icon = 'icons/obj/structures/doors/railing.dmi'
	icon_state = "railing0"
	use_power = 0
	flags_atom = ON_BORDER
	opacity = 0
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
	layer = closed_layer

	SetOpacity(initial(opacity))

/obj/structure/machinery/door/poddoor/railing/update_icon()
	if(density)
		icon_state = "railing1"
	else
		icon_state = "railing0"

/obj/structure/machinery/door/poddoor/railing/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = (PASS_OVER^PASS_OVER_FIRE)|PASS_CRUSHER_CHARGE

/obj/structure/machinery/door/poddoor/railing/open()
	if (operating == 1) //doors can still open when emag-disabled
		return 0
	if (!ticker)
		return 0
	if(!operating) //in case of emag
		operating = 1
	flick("railingc0", src)
	icon_state = "railing0"
	layer = open_layer

	sleep(12)

	density = 0
	if(operating == 1) //emag again
		operating = 0
	return 1

/obj/structure/machinery/door/poddoor/railing/close()
	if (operating)
		return 0
	density = 1
	operating = 1
	layer = closed_layer
	flick("railingc1", src)
	icon_state = "railing1"

	addtimer(VARSET_CALLBACK(src, operating, FALSE), 1.2 SECONDS)
	return 1
