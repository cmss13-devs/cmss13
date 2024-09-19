/obj/structure/machinery/door
	name = "\improper Door"
	desc = "It opens and closes."
	icon = 'icons/obj/structures/doors/Door1.dmi'
	icon_state = "door1"
	anchored = TRUE
	opacity = TRUE
	density = TRUE
	throwpass = FALSE
	layer = DOOR_OPEN_LAYER
	minimap_color = MINIMAP_DOOR
	var/open_layer = DOOR_OPEN_LAYER
	var/closed_layer = DOOR_CLOSED_LAYER
	var/id = ""
	var/height = 1

	var/secondsElectrified = 0
	var/visible = TRUE
	var/panel_open = FALSE
	var/operating = FALSE
	var/autoclose = FALSE
	var/glass = FALSE
	/// If FALSE it speeds up the autoclosing timing.
	var/normalspeed = TRUE
	/// Time to open/close airlock, default is 1 second.
	var/openspeed = 1 SECONDS
	/// Stops it being forced open through normal means (Hunters/Zombies/Aliens).
	var/heavy = FALSE
	/// Resistance to masterkey
	var/masterkey_resist = FALSE
	var/masterkey_mod = 0.1
	dir = EAST //So multitile doors are directioned properly

/obj/structure/machinery/door/Initialize(mapload, ...)
	. = ..()
	layer = density ? closed_layer : open_layer
	if (height > 1)
		AddElement(/datum/element/multitile/door, 1, height, TRUE, can_block_movement)

/obj/structure/machinery/door/Destroy()
	. = ..()
	density = FALSE

/obj/structure/machinery/door/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = NONE

/obj/structure/machinery/door/proc/borders_space()
	return !!(locate(/turf/open/space) in range(1, src))

/obj/structure/machinery/door/Collided(atom/movable/AM)
	if(panel_open || operating)
		return
	if(ismob(AM))
		var/mob/M = AM
		if(world.time - M.last_bumped <= openspeed) return //Can bump-open one airlock per second. This is to prevent shock spam.
		M.last_bumped = world.time
		if(!M.is_mob_restrained() && M.mob_size > MOB_SIZE_SMALL)
			bumpopen(M)
		return
	if(istype(AM, /obj))
		var/obj/O = AM
		if(O.buckled_mob)
			Collided(O.buckled_mob)
	if(istype(AM, /obj/structure/machinery/bot))
		var/obj/structure/machinery/bot/bot = AM
		if(src.check_access(bot.botcard))
			if(density)
				open()
		return

/obj/structure/machinery/door/proc/bumpopen(mob/user as mob)
	if(operating)
		return
	add_fingerprint(user)
	if(!requiresID())
		user = null
	if(density)
		if(allowed(user))
			open()
		else
			flick("door_deny", src)
	return

/obj/structure/machinery/door/attack_remote(mob/user)
	return src.attack_hand(user)

/obj/structure/machinery/door/attack_hand(mob/user)
	return try_to_activate_door(user)

/obj/structure/machinery/door/proc/try_to_activate_door(mob/user)
	add_fingerprint(user)
	if(operating)
		return
	if(!Adjacent(user) || !requiresID())
		user = null //so allowed(user) always succeeds
	if(allowed(user))
		if(density)
			open()
		else
			close()
		return
	if(density)
		flick("door_deny", src)

/obj/structure/machinery/door/attackby(obj/item/I, mob/user)
	if(!(I.flags_item & NOBLUDGEON))
		try_to_activate_door(user)
		return TRUE

/obj/structure/machinery/door/emp_act(severity)
	. = ..()
	if(prob(20/severity) && use_power)
		open()
	if(prob(40/severity))
		if(secondsElectrified == 0)
			secondsElectrified = -1
			spawn(30 SECONDS)
				secondsElectrified = 0

/obj/structure/machinery/door/ex_act(severity)
	if(unacidable)
		return

	if(density)
		switch(severity)
			if(0 to EXPLOSION_THRESHOLD_LOW)
				if(prob(80))
					var/datum/effect_system/spark_spread/spark = new /datum/effect_system/spark_spread
					spark.set_up(2, 1, src)
					spark.start()
			if(EXPLOSION_THRESHOLD_LOW to INFINITY)
				qdel(src)
	else
		switch(severity)
			if(0 to EXPLOSION_THRESHOLD_MEDIUM)
				if(prob(80))
					var/datum/effect_system/spark_spread/spark = new /datum/effect_system/spark_spread
					spark.set_up(2, 1, src)
					spark.start()
			else
				qdel(src)
	return

/obj/structure/machinery/door/get_explosion_resistance()
	if(density)
		if(unacidable)
			return 1000000 //Used for negation of explosions, should probably be made into define in the future
		else
			return EXPLOSION_THRESHOLD_LOW //this should exactly match the amount of damage needed to destroy the door
	else
		return 0

/obj/structure/machinery/door/update_icon()
	icon_state = density ? "door1" : "door0"

/obj/structure/machinery/door/proc/do_animate(animation)
	switch(animation)
		if("opening")
			if(panel_open)
				flick("o_doorc0", src)
			else
				flick("doorc0", src)
		if("closing")
			if(panel_open)
				flick("o_doorc1", src)
			else
				flick("doorc1", src)
		if("deny")
			flick("door_deny", src)
	return

/obj/structure/machinery/door/proc/open(forced)
	if(!density)
		return TRUE
	if(operating || !loc)
		return FALSE

	operating = TRUE
	do_animate("opening")
	icon_state = "door0"
	set_opacity(FALSE)
	addtimer(CALLBACK(src, PROC_REF(finish_open)), openspeed)
	return TRUE

/obj/structure/machinery/door/proc/finish_open()
	layer = open_layer
	density = FALSE
	update_icon()

	if(operating)
		operating = FALSE
	if(autoclose)
		addtimer(CALLBACK(src, PROC_REF(autoclose)), normalspeed ? 150 + openspeed : 5)

/obj/structure/machinery/door/proc/close()
	for (var/turf/turf in locs)
		for (var/obj/vehicle/multitile/vehicle_tile in turf.movement_blockers)
			return FALSE
	if (density)
		return TRUE
	if (operating)
		return FALSE

	operating = TRUE
	src.density = TRUE
	src.layer = closed_layer
	do_animate("closing")
	addtimer(CALLBACK(src, PROC_REF(finish_close)), openspeed)

/obj/structure/machinery/door/proc/finish_close()
	update_icon()
	if(visible && !glass)
		set_opacity(TRUE)
	operating = FALSE

/obj/structure/machinery/door/proc/requiresID()
	return TRUE

/// Used for overriding in airlocks
/obj/structure/machinery/door/proc/autoclose()
	if(!autoclose)
		return
	if(!density && !operating)
		close()

/obj/structure/machinery/door/morgue
	icon = 'icons/obj/structures/doors/doormorgue.dmi'
