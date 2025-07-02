/obj/structure/machinery/door/poddoor/two_tile
	dir = EAST
	icon = 'icons/obj/structures/doors/1x2blast_hor.dmi'
	var/obj/structure/machinery/door/poddoor/filler_object/f1
	var/obj/structure/machinery/door/poddoor/filler_object/f2

/obj/structure/machinery/door/poddoor/two_tile/opened
	density = FALSE

/obj/structure/machinery/door/poddoor/two_tile/Initialize()
	. = ..()
	f1 = new/obj/structure/machinery/door/poddoor/filler_object (loc)
	f2 = new/obj/structure/machinery/door/poddoor/filler_object (get_step(src,dir))
	f1.density = density
	f2.density = density
	f1.set_opacity(opacity)
	f2.set_opacity(opacity)

/obj/structure/machinery/door/poddoor/two_tile/Destroy()
	QDEL_NULL(f1)
	QDEL_NULL(f2)
	return ..()

/obj/structure/machinery/door/poddoor/two_tile/open(forced = FALSE)
	if(operating) //doors can still open when emag-disabled
		return FALSE

	operating = DOOR_OPERATING_OPENING
	start_opening()

	addtimer(CALLBACK(src, PROC_REF(open_fully)), openspeed, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)
	return TRUE

/obj/structure/machinery/door/poddoor/two_tile/proc/start_opening()
	flick("[base_icon_state]c0", src)
	icon_state = "[base_icon_state]0"
	set_opacity(0)
	f1.set_opacity(0)
	f2.set_opacity(0)

/obj/structure/machinery/door/poddoor/two_tile/four_tile/start_opening()
	f3.set_opacity(0)
	f4.set_opacity(0)
	..()

/obj/structure/machinery/door/poddoor/two_tile/proc/open_fully()
	density = FALSE
	f1.density = FALSE
	f2.density = FALSE

	operating = DOOR_OPERATING_IDLE
	if(autoclose)
		addtimer(CALLBACK(src, PROC_REF(autoclose)), 15 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)

/obj/structure/machinery/door/poddoor/two_tile/four_tile/open_fully()
	f3.density = FALSE
	f4.density = FALSE
	..()

/obj/structure/machinery/door/poddoor/two_tile/close(forced = FALSE)
	if(operating)
		return FALSE

	start_closing()
	addtimer(CALLBACK(src, PROC_REF(close_fully)), openspeed, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)
	return TRUE

/obj/structure/machinery/door/poddoor/two_tile/proc/start_closing()
	operating = DOOR_OPERATING_CLOSING
	flick("[base_icon_state]c1", src)
	icon_state = "[base_icon_state]1"

	density = TRUE
	f1.density = TRUE
	f2.density = TRUE

/obj/structure/machinery/door/poddoor/two_tile/four_tile/start_closing()
	f3.density = TRUE
	f4.density = TRUE
	..()

/obj/structure/machinery/door/poddoor/two_tile/proc/close_fully()
	set_opacity(initial(opacity))
	f1.set_opacity(initial(opacity))
	f2.set_opacity(initial(opacity))
	operating = DOOR_OPERATING_IDLE

/obj/structure/machinery/door/poddoor/two_tile/four_tile/close_fully()
	f3.set_opacity(initial(opacity))
	f4.set_opacity(initial(opacity))
	..()

/obj/structure/machinery/door/poddoor/two_tile/vertical
	dir = NORTH
	icon = 'icons/obj/structures/doors/1x2blast_vert.dmi'

/obj/structure/machinery/door/poddoor/two_tile/vertical/open
	density = FALSE

/obj/structure/machinery/door/poddoor/two_tile/four_tile
	icon = 'icons/obj/structures/doors/1x4blast_hor.dmi'
	var/obj/structure/machinery/door/poddoor/filler_object/f3
	var/obj/structure/machinery/door/poddoor/filler_object/f4

/obj/structure/machinery/door/poddoor/two_tile/four_tile/open
	density = FALSE

/obj/structure/machinery/door/poddoor/two_tile/four_tile/Initialize()
	. = ..()
	f3 = new/obj/structure/machinery/door/poddoor/filler_object (get_step(f2,dir))
	f4 = new/obj/structure/machinery/door/poddoor/filler_object (get_step(f3,dir))
	f3.density = density
	f4.density = density
	f3.set_opacity(opacity)
	f4.set_opacity(opacity)

/obj/structure/machinery/door/poddoor/two_tile/four_tile/Destroy()
	QDEL_NULL(f3)
	QDEL_NULL(f4)
	return ..()

/obj/structure/machinery/door/poddoor/two_tile/four_tile/vertical
	dir = NORTH
	icon = 'icons/obj/structures/doors/1x4blast_vert.dmi'

/obj/structure/machinery/door/poddoor/two_tile/four_tile/vertical/opened
	density = FALSE

/obj/structure/machinery/door/poddoor/two_tile/four_tile/secure
	icon = 'icons/obj/structures/doors/1x4blast_hor_secure.dmi'
	openspeed = 17
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/machinery/door/poddoor/two_tile/four_tile/secure/opened
	density = FALSE

/obj/structure/machinery/door/poddoor/two_tile/four_tile/vertical/secure
	icon = 'icons/obj/structures/doors/1x4blast_vert_secure.dmi'
	openspeed = 17
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/machinery/door/poddoor/two_tile/four_tile/vertical/secure/open
	density = FALSE

/obj/structure/machinery/door/poddoor/two_tile/secure
	icon = 'icons/obj/structures/doors/1x2blast_hor.dmi'
	openspeed = 17
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/machinery/door/poddoor/two_tile/vertical/secure
	icon = 'icons/obj/structures/doors/1x2blast_vert.dmi'
	openspeed = 17
	unacidable = TRUE
