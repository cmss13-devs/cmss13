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

/obj/structure/machinery/door/poddoor/filler_object
	name = ""
	icon = null
	icon_state = ""
	unslashable = TRUE
	unacidable = TRUE
