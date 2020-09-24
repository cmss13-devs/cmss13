
/obj/structure/machinery/door/poddoor
	name = "\improper Podlock"
	desc = "That looks like it doesn't open easily."
	icon = 'icons/obj/structures/doors/rapid_pdoor.dmi'
	icon_state = "pdoor"
	id = 1.0
	dir = 1
	unslashable = TRUE
	health = 0
	layer = PODDOOR_OPEN_LAYER
	open_layer = PODDOOR_OPEN_LAYER
	closed_layer = PODDOOR_CLOSED_LAYER

/obj/structure/machinery/door/poddoor/Initialize()
	. = ..()
	if(density)
		layer = PODDOOR_CLOSED_LAYER //to override door.Initialize() proc
		icon_state = initial(icon_state) + "1"
		SetOpacity(1)
	else
		layer = PODDOOR_OPEN_LAYER
		icon_state = initial(icon_state) + "0"
		SetOpacity(0)
	return

/obj/structure/machinery/door/poddoor/update_icon()
	if(density)
		icon_state = initial(icon_state) + "1"
	else
		icon_state = initial(icon_state) + "0"
	return

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
			flick(initial(icon_state) + "c0", src)
			icon_state = initial(icon_state) + "0"
			SetOpacity(0)
			sleep(15)
			density = 0
			operating = 0

/obj/structure/machinery/door/poddoor/attack_alien(mob/living/carbon/Xenomorph/X)
	if((stat & NOPOWER) && density && !operating && !unacidable)
		pry_open(X)


/obj/structure/machinery/door/poddoor/proc/pry_open(var/mob/living/carbon/Xenomorph/X, var/time = SECONDS_4)
	X.visible_message(SPAN_DANGER("[X] begins prying [src] open."),\
	SPAN_XENONOTICE("You start prying [src] open."), max_distance = 3)

	playsound(loc, 'sound/effects/metal_creaking.ogg', 25, TRUE)

	if(!do_after(X, time, INTERRUPT_ALL, BUSY_ICON_HOSTILE, src, INTERRUPT_ALL))
		to_chat(X, "You stop prying [src] open.")
		return

	X.visible_message(SPAN_DANGER("[X] pries open [src]."), \
	SPAN_XENONOTICE("You pry open [src]."), max_distance = 3)
	
	open()


/obj/structure/machinery/door/poddoor/try_to_activate_door(mob/user)
	return

/obj/structure/machinery/door/poddoor/open()
	if(operating == 1) //doors can still open when emag-disabled
		return
	if(!ticker)
		return 0
	if(!operating) //in case of emag
		operating = 1
	flick(initial(icon_state) + "c0", src)
	icon_state = initial(icon_state) + "0"
	SetOpacity(0)
	sleep(10)
	layer = PODDOOR_OPEN_LAYER
	density = 0

	if(operating == 1) //emag again
		operating = 0
	if(autoclose)
		add_timer(CALLBACK(src, .proc/autoclose), 150)
	return 1

/obj/structure/machinery/door/poddoor/close()
	if(operating)
		return
	operating = 1
	layer = PODDOOR_CLOSED_LAYER
	flick(initial(icon_state) + "c1", src)
	icon_state = initial(icon_state) + "1"
	density = 1
	SetOpacity(initial(opacity))

	sleep(10)
	operating = 0
	return

/obj/structure/machinery/door/poddoor/two_tile/open()
	if(operating == 1) //doors can still open when emag-disabled
		return
	if(!ticker)
		return 0
	if(!operating) //in case of emag
		operating = 1
	start_opening()
	sleep(10)
	open_fully()
	return 1

/obj/structure/machinery/door/poddoor/two_tile/proc/start_opening()
	flick("pdoorc0", src)
	icon_state = "pdoor0"
	SetOpacity(0)
	f1.SetOpacity(0)
	f2.SetOpacity(0)

/obj/structure/machinery/door/poddoor/two_tile/four_tile/start_opening()
	f3.SetOpacity(0)
	f4.SetOpacity(0)
	..()

/obj/structure/machinery/door/poddoor/two_tile/proc/open_fully()
	density = 0
	f1.density = 0
	f2.density = 0

	if(operating == 1) //emag again
		operating = 0
	if(autoclose)
		add_timer(CALLBACK(src, .proc/autoclose), 15 SECONDS)

/obj/structure/machinery/door/poddoor/two_tile/four_tile/open_fully()
	f3.density = 0
	f4.density = 0
	..()

/obj/structure/machinery/door/poddoor/two_tile/close()
	if(operating)
		return
	start_closing()
	sleep(10)
	close_fully()
	return

/obj/structure/machinery/door/poddoor/two_tile/proc/start_closing()
	operating = 1
	flick("pdoorc1", src)
	icon_state = "pdoor1"

	density = 1
	f1.density = 1
	f2.density = 1

/obj/structure/machinery/door/poddoor/two_tile/four_tile/start_closing()
	f3.density = 1
	f4.density = 1
	..()

/obj/structure/machinery/door/poddoor/two_tile/proc/close_fully()
	SetOpacity(initial(opacity))
	f1.SetOpacity(initial(opacity))
	f2.SetOpacity(initial(opacity))
	operating = 0

/obj/structure/machinery/door/poddoor/two_tile/four_tile/close_fully()
	f3.SetOpacity(initial(opacity))
	f4.SetOpacity(initial(opacity))
	..()

/obj/structure/machinery/door/poddoor/two_tile
	dir = EAST
	icon = 'icons/obj/structures/doors/1x2blast_hor.dmi'
	var/obj/structure/machinery/door/poddoor/filler_object/f1
	var/obj/structure/machinery/door/poddoor/filler_object/f2

/obj/structure/machinery/door/poddoor/two_tile/Initialize()
	. = ..()
	f1 = new/obj/structure/machinery/door/poddoor/filler_object (loc)
	f2 = new/obj/structure/machinery/door/poddoor/filler_object (get_step(src,dir))
	f1.density = density
	f2.density = density
	f1.SetOpacity(opacity)
	f2.SetOpacity(opacity)

/obj/structure/machinery/door/poddoor/two_tile/Destroy()
	qdel(f1)
	f1 = null
	qdel(f2)
	f2 = null
	return ..()

/obj/structure/machinery/door/poddoor/two_tile/vertical
	dir = NORTH
	icon = 'icons/obj/structures/doors/1x2blast_vert.dmi'

/obj/structure/machinery/door/poddoor/two_tile/four_tile
	icon = 'icons/obj/structures/doors/1x4blast_hor.dmi'
	var/obj/structure/machinery/door/poddoor/filler_object/f3
	var/obj/structure/machinery/door/poddoor/filler_object/f4

/obj/structure/machinery/door/poddoor/two_tile/four_tile/Initialize()
	. = ..()
	f3 = new/obj/structure/machinery/door/poddoor/filler_object (get_step(f2,dir))
	f4 = new/obj/structure/machinery/door/poddoor/filler_object (get_step(f3,dir))
	f3.density = density
	f4.density = density
	f3.SetOpacity(opacity)
	f4.SetOpacity(opacity)

/obj/structure/machinery/door/poddoor/two_tile/four_tile/Destroy()
	qdel(f3)
	f3 = null
	qdel(f4)
	f4 = null
	return ..()

/obj/structure/machinery/door/poddoor/two_tile/four_tile/vertical
	dir = NORTH
	icon = 'icons/obj/structures/doors/1x4blast_vert.dmi'

/obj/structure/machinery/door/poddoor/filler_object
	name = ""
	icon_state = ""
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/machinery/door/poddoor/two_tile/four_tile/secure
	icon = 'icons/obj/structures/doors/1x4blast_hor_secure.dmi'
	openspeed = 17
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/machinery/door/poddoor/two_tile/four_tile/vertical/secure
	icon = 'icons/obj/structures/doors/1x4blast_vert_secure.dmi'
	openspeed = 17
	unslashable = TRUE
	unacidable = TRUE

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
	tiles_with = list(
		/obj/structure/window/framed/almayer,
		/obj/structure/machinery/door/airlock)

/obj/structure/machinery/door/poddoor/almayer/blended
	icon_state = "almayer_pdoor"

/obj/structure/machinery/door/poddoor/almayer/Initialize()
	. = ..()
	add_timer(CALLBACK(src, /atom.proc/relativewall_neighbours), 10)

/obj/structure/machinery/door/poddoor/almayer/locked
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/machinery/door/poddoor/almayer/locked/attackby(obj/item/C as obj, mob/user as mob)
	if(iscrowbar(C))
		return
	..()

/obj/structure/machinery/door/poddoor/almayer/closed
	density = TRUE
	opacity = TRUE