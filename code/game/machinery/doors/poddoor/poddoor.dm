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
			operating = DOOR_OPERATING_OPENING
			flick("[base_icon_state]c0", src)
			icon_state = "[base_icon_state]0"
			set_opacity(0)
			sleep(15)
			density = FALSE
			operating = DOOR_OPERATING_IDLE

/obj/structure/machinery/door/poddoor/attack_alien(mob/living/carbon/xenomorph/X)
	if((stat & NOPOWER) && density && !operating && !unacidable)
		INVOKE_ASYNC(src, PROC_REF(pry_open), X)
		return XENO_ATTACK_ACTION

/obj/structure/machinery/door/poddoor/proc/pry_open(mob/living/carbon/xenomorph/X, time = 4 SECONDS)
	X.visible_message(SPAN_DANGER("[X] begins prying [src] open."),
	SPAN_XENONOTICE("You start prying [src] open."), max_distance = 3)

	playsound(loc, 'sound/effects/metal_creaking.ogg', 25, TRUE)

	if(!do_after(X, time, INTERRUPT_ALL, BUSY_ICON_HOSTILE, src, INTERRUPT_ALL))
		to_chat(X, "You stop prying [src] open.")
		return

	X.visible_message(SPAN_DANGER("[X] pries open [src]."),
	SPAN_XENONOTICE("You pry open [src]."), max_distance = 3)

	open()
	return TRUE


/obj/structure/machinery/door/poddoor/try_to_activate_door(mob/user)
	return

/obj/structure/machinery/door/poddoor/open(forced = FALSE)
	if(operating) //doors can still open when emag-disabled
		return FALSE
	if(!opacity)
		return TRUE

	operating = DOOR_OPERATING_OPENING

	playsound(loc, 'sound/machines/blastdoor.ogg', 20, 0)
	flick("[base_icon_state]c0", src)
	icon_state = "[base_icon_state]0"
	set_opacity(0)

	addtimer(CALLBACK(src, PROC_REF(finish_open)), openspeed, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)
	return TRUE

/obj/structure/machinery/door/poddoor/close(forced = FALSE)
	if(operating)
		return FALSE
	if(opacity == initial(opacity))
		return TRUE

	operating = DOOR_OPERATING_CLOSING
	playsound(loc, 'sound/machines/blastdoor.ogg', 20, 0)

	layer = closed_layer
	flick("[base_icon_state]c1", src)
	icon_state = "[base_icon_state]1"
	density = TRUE
	set_opacity(initial(opacity))

	addtimer(CALLBACK(src, PROC_REF(finish_close)), openspeed, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)
	return TRUE

/obj/structure/machinery/door/poddoor/finish_close()
	if(operating != DOOR_OPERATING_CLOSING)
		return

	operating = DOOR_OPERATING_IDLE

/obj/structure/machinery/door/poddoor/filler_object
	name = ""
	icon = null
	icon_state = ""
	unslashable = TRUE
	unacidable = TRUE

// Hybrisa Shutters

/obj/structure/machinery/door/poddoor/hybrisa
	icon = 'icons/obj/structures/doors/hybrisashutters.dmi'
	icon_state = "almayer_pdoor1"
	base_icon_state = "almayer_pdoor"
	openspeed = 4
	/// Whether this can be destroyed by a vehicle bump
	var/vehicle_resistant = TRUE

/obj/structure/machinery/door/poddoor/hybrisa/open_shutters/Initialize()
	. = ..()
	if(opacity)
		set_opacity(0)

/obj/structure/machinery/door/poddoor/hybrisa/open_shutters/open()
	if(operating) //doors can still open when emag-disabled
		return

	if(!density) // We check density instead of opacity
		return TRUE

	operating = TRUE

	playsound(loc, 'sound/machines/blastdoor.ogg', 20, 0)
	flick("[base_icon_state]c0", src)
	icon_state = "[base_icon_state]0"
	set_opacity(0)

	addtimer(CALLBACK(src, PROC_REF(finish_open)), openspeed)
	return TRUE

/obj/structure/machinery/door/poddoor/hybrisa/open_shutters
	name = "\improper shutters"
	desc = "Thin metal shutters, more for show than security. They redirect light and add a bit of structure to the space."
	icon_state = "almayer_pdoor1"
	base_icon_state = "almayer_pdoor"
	opacity = FALSE
	vehicle_resistant = FALSE
	unslashable = FALSE
	gender = PLURAL
	health = 10

/obj/structure/machinery/door/poddoor/hybrisa/open_shutters/bullet_act(obj/projectile/P)
	health -= P.damage
	..()
	healthcheck()
	return TRUE

/obj/structure/machinery/door/poddoor/hybrisa/open_shutters/proc/explode()
	visible_message(SPAN_DANGER("[src] breaks apart!"), max_distance = 1)
	deconstruct(FALSE)

/obj/structure/machinery/door/poddoor/hybrisa/open_shutters/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/structure/machinery/door/poddoor/hybrisa/open_shutters/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/machinery/door/poddoor/hybrisa/open_shutters/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION


/obj/structure/machinery/door/poddoor/hybrisa/shutters
	name = "\improper shutters"
	desc = null
	icon_state = "shutter1"
	base_icon_state = "shutter"
	gender = PLURAL
	vehicle_resistant = FALSE

/obj/structure/machinery/door/poddoor/hybrisa/white
	name = null
	desc = "That looks like it doesn't open easily."
	icon_state = "w_almayer_pdoor1"
	base_icon_state = "w_almayer_pdoor"
	unslashable = TRUE

/obj/structure/machinery/door/poddoor/hybrisa/secure_red_door
	desc = "That looks like it doesn't open easily."
	icon_state = "pdoor1"
	base_icon_state = "pdoor"
	unslashable = TRUE
	emp_proof = TRUE

/obj/structure/machinery/door/poddoor/hybrisa/secure_red_door/emp_act(power, severity)
	..()
	return TRUE

/obj/structure/machinery/door/poddoor/hybrisa/ultra_reinforced_door
	desc = "A heavily reinforced metal-alloy door, designed to be virtually indestructible—nothing can penetrate its defenses."
	icon_state = "udoor1"
	base_icon_state = "udoor"
	unslashable = TRUE
	emp_proof = TRUE
	openspeed = 6

/obj/structure/machinery/door/poddoor/hybrisa/ultra_reinforced_door/open
	density = FALSE

/obj/structure/machinery/door/poddoor/hybrisa/ultra_reinforced_door/emp_act(power, severity)
	if(emp_proof)
		return FALSE
	..()
	return TRUE
