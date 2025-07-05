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
	dir = EAST //So multitile doors are directioned properly

	var/open_layer = DOOR_OPEN_LAYER
	var/closed_layer = DOOR_CLOSED_LAYER
	var/id = ""
	var/width = 1

	var/secondsElectrified = 0
	var/visible = TRUE
	var/panel_open = FALSE
	var/operating = DOOR_OPERATING_IDLE
	var/autoclose = FALSE
	var/glass = FALSE
	/// If FALSE it speeds up the autoclosing timing.
	var/normalspeed = TRUE
	/// Time to open/close airlock, default is 1 second.
	var/openspeed = 1 SECONDS
	/// Fixes multi_tile doors opacity issues.
	var/list/filler_turfs = list() //Previously this was just var, because no one had forseen someone creating doors more than 2 tiles wide
	/// Stops it being forced open through normal means (Hunters/Zombies/Aliens).
	var/heavy = FALSE
	/// Resistance to masterkey
	var/masterkey_resist = FALSE
	var/masterkey_mod = 0.1

/obj/structure/machinery/door/Initialize(mapload, ...)
	. = ..()
	layer = density ? closed_layer : open_layer
	handle_multidoor()

/obj/structure/machinery/door/Destroy()
	. = ..()
	if(length(filler_turfs) && width > 1)
		change_filler_opacity(0) // It still doesn't check for walls, might want to add checking that in the future
		filler_turfs = null
	density = FALSE

/obj/structure/machinery/door/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = NONE

/// Also refreshes filler_turfs list.
/obj/structure/machinery/door/proc/change_filler_opacity(new_opacity)
	// I have no idea why do we null opacity first before... changing it
	for(var/turf/filler_turf as anything in filler_turfs)
		filler_turf.set_opacity(null)

	filler_turfs = list()
	for(var/turf/filler as anything in locate_filler_turfs())
		filler.set_opacity(new_opacity)
		filler_turfs += filler

/// Updates collision box and opacity of multi_tile airlocks.
/obj/structure/machinery/door/proc/handle_multidoor()
	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size
		change_filler_opacity(opacity)

/// Finds turfs which should be filler ones.
/obj/structure/machinery/door/proc/locate_filler_turfs()
	var/turf/filler_temp
	var/list/located_turfs = list()

	for(var/i in 1 to width - 1)
		if (dir in list(EAST, WEST))
			filler_temp = locate(x + i, y, z)
		else
			filler_temp = locate(x, y + i, z)
		if (filler_temp)
			located_turfs += filler_temp
	return located_turfs

/obj/structure/machinery/door/proc/borders_space()
	return !!(locate(/turf/open/space) in range(1, src))

/obj/structure/machinery/door/Collided(atom/movable/AM)
	if(panel_open || operating)
		return
	if(ismob(AM))
		var/mob/M = AM
		if(world.time - M.last_bumped <= openspeed)
			return //Can bump-open one airlock per second. This is to prevent shock spam.
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
	if(explo_proof)
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

/obj/structure/machinery/door/proc/open(forced = FALSE)
	if(!density)
		return TRUE
	if(operating && !forced)
		return FALSE
	if(!loc)
		return FALSE

	operating = DOOR_OPERATING_OPENING
	do_animate("opening")
	set_opacity(FALSE)
	if(length(filler_turfs))
		change_filler_opacity(opacity)
	addtimer(CALLBACK(src, PROC_REF(finish_open)), openspeed, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)
	return TRUE

/obj/structure/machinery/door/proc/finish_open()
	if(operating != DOOR_OPERATING_OPENING)
		return
	if(QDELETED(src))
		return // Specifically checked because of the possiible addtimer

	layer = open_layer
	density = FALSE
	update_icon()

	operating = DOOR_OPERATING_IDLE
	if(autoclose)
		addtimer(CALLBACK(src, PROC_REF(autoclose)), normalspeed ? 15 SECONDS + openspeed : 5 DECISECONDS, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)

/obj/structure/machinery/door/proc/close(forced = FALSE)
	if(density && !operating)
		return TRUE
	if(operating && !forced)
		return FALSE
	if(!loc)
		return FALSE

	for(var/turf/turf_tile in locs)
		for(var/obj/structure/blocking_structure in turf_tile)
			if(blocking_structure == src)
				continue // Don't block ourselves (only applicable when opening)
			if(!blocking_structure.density && !istype(blocking_structure, /obj/structure/closet))
				continue // Don't block if non-dense and not a closet (they toggle density)
			if(blocking_structure.anchored && istype(blocking_structure, /obj/structure/machinery/door))
				continue // Don't block because of other doors (shutters) also in this location

			// Try again later
			addtimer(CALLBACK(src, PROC_REF(close), forced), 6 SECONDS + openspeed, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)
			return FALSE

	operating = DOOR_OPERATING_CLOSING
	density = TRUE
	layer = closed_layer
	do_animate("closing")
	addtimer(CALLBACK(src, PROC_REF(finish_close)), openspeed, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)
	return TRUE

/obj/structure/machinery/door/proc/finish_close()
	if(operating != DOOR_OPERATING_CLOSING)
		return

	update_icon()
	if(visible && !glass)
		set_opacity(TRUE)
		if(length(filler_turfs))
			change_filler_opacity(opacity)
	operating = DOOR_OPERATING_IDLE

/obj/structure/machinery/door/proc/requiresID()
	return TRUE

/// Used for overriding in airlocks
/obj/structure/machinery/door/proc/autoclose()
	if(!autoclose)
		return
	if(!density && !operating)
		close()

/obj/structure/machinery/door/Move(new_loc, new_dir)
	. = ..()
	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size
		change_filler_opacity(opacity)

/obj/structure/machinery/door/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	. = ..()
	// Yes, for a split second after departure you can see through rear dropship airlocks, but it's the simplest solution I could've think of
	handle_multidoor()

/obj/structure/machinery/door/morgue
	icon = 'icons/obj/structures/doors/doormorgue.dmi'
