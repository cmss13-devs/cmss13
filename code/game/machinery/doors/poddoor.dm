
/obj/structure/machinery/door/poddoor
	name = "\improper Podlock"
	desc = "That looks like it doesn't open easily."
	icon = 'icons/obj/structures/doors/rapid_pdoor.dmi'
	icon_state = "pdoor1"
	var/base_icon_state = "pdoor"
	id = 1
	dir = NORTH
	unslashable = TRUE
	health = 0
	layer = PODDOOR_CLOSED_LAYER
	open_layer = PODDOOR_OPEN_LAYER
	closed_layer = PODDOOR_CLOSED_LAYER

/obj/structure/machinery/door/poddoor/Initialize()
	. = ..()
	if(density)
		set_opacity(1)
	else
		set_opacity(0)
	update_icon()

/obj/structure/machinery/door/poddoor/update_icon()
	if(density)
		icon_state = "[base_icon_state]1"
	else
		icon_state = "[base_icon_state]0"

/obj/structure/machinery/door/poddoor/Collided(atom/movable/AM)
	if(!density)
		return ..()
	else
		return 0

/obj/structure/machinery/door/poddoor/attackby(obj/item/W, mob/user)
	add_fingerprint(user)
	if(!W.pry_capable)
		return
	if(density && (stat & NOPOWER) && !operating && !unacidable)
		spawn(0)
			operating = 1
			flick("[base_icon_state]c0", src)
			icon_state = "[base_icon_state]0"
			set_opacity(0)
			sleep(15)
			density = FALSE
			operating = 0

/obj/structure/machinery/door/poddoor/attack_alien(mob/living/carbon/xenomorph/X)
	if((stat & NOPOWER) && density && !operating && !unacidable)
		INVOKE_ASYNC(src, PROC_REF(pry_open), X)
		return XENO_ATTACK_ACTION

/obj/structure/machinery/door/poddoor/proc/pry_open(mob/living/carbon/xenomorph/X, time = 4 SECONDS)
	X.visible_message(SPAN_DANGER("[X] begins prying [src] open."),\
	SPAN_XENONOTICE("You start prying [src] open."), max_distance = 3)

	playsound(loc, 'sound/effects/metal_creaking.ogg', 25, TRUE)

	if(!do_after(X, time, INTERRUPT_ALL, BUSY_ICON_HOSTILE, src, INTERRUPT_ALL))
		to_chat(X, "You stop prying [src] open.")
		return

	X.visible_message(SPAN_DANGER("[X] pries open [src]."), \
	SPAN_XENONOTICE("You pry open [src]."), max_distance = 3)

	open()
	return TRUE


/obj/structure/machinery/door/poddoor/try_to_activate_door(mob/user)
	return

/obj/structure/machinery/door/poddoor/open()
	if(operating) //doors can still open when emag-disabled
		return

	if(!opacity)
		return TRUE

	operating = TRUE

	playsound(loc, 'sound/machines/blastdoor.ogg', 20, 0)
	flick("[base_icon_state]c0", src)
	icon_state = "[base_icon_state]0"
	set_opacity(0)

	addtimer(CALLBACK(src, PROC_REF(finish_open)), openspeed)
	return TRUE

/obj/structure/machinery/door/poddoor/close()
	if(operating)
		return
	if(opacity == initial(opacity))
		return

	operating = TRUE
	playsound(loc, 'sound/machines/blastdoor.ogg', 20, 0)

	layer = closed_layer
	flick("[base_icon_state]c1", src)
	icon_state = "[base_icon_state]1"
	density = TRUE
	set_opacity(initial(opacity))

	addtimer(CALLBACK(src, PROC_REF(finish_close)), openspeed)
	return

/obj/structure/machinery/door/poddoor/finish_close()
	operating = FALSE

/obj/structure/machinery/door/poddoor/two_tile/open()
	if(operating) //doors can still open when emag-disabled
		return

	operating = TRUE
	start_opening()

	addtimer(CALLBACK(src, PROC_REF(open_fully)), openspeed)
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

	if(operating == 1) //emag again
		operating = 0
	if(autoclose)
		addtimer(CALLBACK(src, PROC_REF(autoclose)), 15 SECONDS)

/obj/structure/machinery/door/poddoor/two_tile/four_tile/open_fully()
	f3.density = FALSE
	f4.density = FALSE
	..()

/obj/structure/machinery/door/poddoor/two_tile/close()
	if(operating)
		return
	start_closing()
	addtimer(CALLBACK(src, PROC_REF(close_fully)), openspeed)
	return

/obj/structure/machinery/door/poddoor/two_tile/proc/start_closing()
	operating = 1
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
	operating = 0

/obj/structure/machinery/door/poddoor/two_tile/four_tile/close_fully()
	f3.set_opacity(initial(opacity))
	f4.set_opacity(initial(opacity))
	..()

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

/obj/structure/machinery/door/poddoor/filler_object
	name = ""
	icon = null
	icon_state = ""
	unslashable = TRUE
	unacidable = TRUE

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

/obj/structure/machinery/door/poddoor/almayer
	icon = 'icons/obj/structures/doors/blastdoors_shutters.dmi'
	openspeed = 4 //shorter open animation.
	var/vehicle_resistant = FALSE
	tiles_with = list(
		/obj/structure/window/framed/almayer,
		/obj/structure/machinery/door/airlock,
	)

/obj/structure/machinery/door/poddoor/almayer/open
	density = FALSE
/obj/structure/machinery/door/poddoor/almayer/blended
	icon_state = "almayer_pdoor1"
	base_icon_state = "almayer_pdoor"
/obj/structure/machinery/door/poddoor/almayer/blended/open
	density = FALSE
/obj/structure/machinery/door/poddoor/almayer/blended/white
	icon_state = "w_almayer_pdoor1"
	base_icon_state = "w_almayer_pdoor"
/obj/structure/machinery/door/poddoor/almayer/blended/white/open
	density = FALSE

/obj/structure/machinery/door/poddoor/almayer/Initialize()
	. = ..()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, relativewall_neighbours)), 10)

/obj/structure/machinery/door/poddoor/almayer/locked
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/machinery/door/poddoor/almayer/locked/attackby(obj/item/C as obj, mob/user as mob)
	if(HAS_TRAIT(C, TRAIT_TOOL_CROWBAR))
		return
	..()

/obj/structure/machinery/door/poddoor/almayer/closed
	density = TRUE
	opacity = TRUE

/obj/structure/machinery/door/poddoor/almayer/planet_side_blastdoor
	density = TRUE
	opacity = TRUE
	vehicle_resistant = TRUE
