/*#################################################################################################
###################################################################################################
#################################################################################################*/
/obj/structure/machinery/door/airlock/sandstone/runed
	name = "\improper Runed Sandstone Airlock"
	icon = 'icons/obj/structures/doors/doorrunedsand.dmi'
	mineral = "runed sandstone"
	no_panel = TRUE
	not_weldable = TRUE
	use_power = FALSE
	autoclose = FALSE
	locked = TRUE
	icon_state = "door_locked"
	stat = 0
	heavy = 1
	openspeed = 4 SECONDS
	unacidable = TRUE//Walls can still be melted or blown up.
	damage_cap = HEALTH_WALL_REINFORCED//Strong, but only available to Hunters so no abuse from marines.
	color = "#b29082"

/obj/structure/machinery/door/airlock/sandstone/runed/proc/can_use(mob/user as mob, var/loud = 0)
	if(!in_range(src, user))
		to_chat(usr, "You cannot operate the door from this far away")
		return FALSE

/obj/structure/machinery/door/airlock/sandstone/runed/attackby(obj/item/W as obj, mob/user as mob)
//	..()
	user.set_interaction(src)
	if (!istype(W, /obj/item/weapon/wristblades || !isYautja(user)))
		return

	if(istype(W, /obj/item/weapon/wristblades))
		playsound(user.loc, 'sound/effects/bladeinsert.ogg', 25, 0)

		var/list/options = list()
		if(src.locked)
			options += "Unlock Door"
		else
			options += "Lock Door"
			if(src.density)
				options += "Open Door"
			else
				options += "Close Door"

		sleep(1 SECONDS)

		var/input = tgui_input_list(user, "Rotate your wristblades to operate the door", "Temple Door Control", options)

		if(!input)
			return

		if(input == "Unlock Door")
			unlock_door()
		else if(input == "Lock Door")
			lock_door()
		else if(input == "Open Door")
			open_door()
		else if(input == "Close Door")
			close_door()
		src.add_fingerprint(usr)
		src.updateUsrDialog()
		src.update_icon()
	return

//ASYNC procs (Probably ok to get rid of)
/obj/structure/machinery/door/airlock/sandstone/runed/proc/open_door()
	if(src.density)
		INVOKE_ASYNC(src, .proc/open)
	return TRUE

/obj/structure/machinery/door/airlock/sandstone/runed/proc/close_door()
	if(!src.density)
		INVOKE_ASYNC(src, .proc/close)
	return TRUE

/obj/structure/machinery/door/airlock/sandstone/runed/proc/lock_door()
	if(!src.locked)
		INVOKE_ASYNC(src, .proc/lock)
	return TRUE

/obj/structure/machinery/door/airlock/sandstone/runed/proc/unlock_door()
	if(src.locked)
		INVOKE_ASYNC(src, .proc/unlock)
	return TRUE

/// Stops the door being interacted with, without wristblades.
/obj/structure/machinery/door/airlock/sandstone/runed/bumpopen(mob/user as mob)
	return FALSE

/obj/structure/machinery/door/airlock/sandstone/runed/try_to_activate_door(mob/user)
	return FALSE


/obj/structure/machinery/door/airlock/sandstone/runed/open(var/forced=1)
	if(operating || welded || locked || !loc || !density)
		return FALSE
	if(!forced && !arePowerSystemsOn())
		return FALSE
	playsound(loc, 'sound/effects/runedsanddoor.ogg', 25, 0)
	visible_message(SPAN_NOTICE("\The [src] makes a loud grating sound as hidden workings pull it open."))

	if(!operating)
		operating = TRUE
	CHECK_TICK
	do_animate("opening")
	icon_state = "door0"
	src.SetOpacity(0)
	sleep(openspeed)
	src.layer = open_layer
	src.density = FALSE
	update_icon()
	SetOpacity(0)
	if (filler)
		filler.SetOpacity(opacity)

	if(operating)
		operating = FALSE
	return

/obj/structure/machinery/door/airlock/sandstone/runed/close(var/forced=1)
	if(operating || welded || locked || !loc || density)
		return
	if(safe)
		for(var/turf/turf in locs)
			if(locate(/mob/living) in turf)
				spawn (60 + openspeed)
					close()
				return
	playsound(loc, 'sound/effects/runedsanddoor.ogg', 25, 0)
	visible_message(SPAN_NOTICE("\The [src] makes a loud grating sound as hidden workings force it shut."))

	operating = TRUE
	CHECK_TICK
	src.density = TRUE
	src.layer = closed_layer
	do_animate("closing")
	sleep(openspeed)
	update_icon()
	operating = FALSE

	for(var/turf/turf in locs)
		for(var/mob/living/M in turf)
			M.apply_damage(DOOR_CRUSH_DAMAGE, BRUTE)
			M.SetStunned(5)
			M.SetKnockeddown(5)
			M.emote("pain")
			var/turf/location = loc
			if(istype(location, /turf))
				location.add_mob_blood(M)

		var/obj/structure/window/killthis = (locate(/obj/structure/window) in turf)
		if(killthis)
			killthis.ex_act(EXPLOSION_THRESHOLD_LOW)
	return

/obj/structure/machinery/door/airlock/sandstone/runed/lock(var/forced=0)
	if(operating || locked) return

	playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 25)
	locked = TRUE
	if(density)
		visible_message(SPAN_NOTICE("\The [src] makes a loud grating sound as heavy stone bolts seal it shut."))
	else
		visible_message(SPAN_NOTICE("\The [src] makes a loud grating sound as heavy stone bolts seal it open."))
	update_icon()

/obj/structure/machinery/door/airlock/sandstone/runed/unlock(var/forced=0)
	if(operating || !locked) return
	locked = FALSE
	playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 25)
	visible_message(SPAN_NOTICE("\The [src] makes a loud grating sound as heavy stone bolts retract."))
	update_icon()
	return TRUE

//Damage procs needed to be redefined because unacidable apparently makes doors immortal.
/obj/structure/machinery/door/airlock/sandstone/runed/take_damage(var/dam, var/mob/M)
	if(!dam)
		return FALSE

	damage = max(0, damage + dam)

	if(damage >= damage_cap)
		if(M && istype(M))
			M.count_niche_stat(STATISTICS_NICHE_DESTRUCTION_DOORS, 1)
			SEND_SIGNAL(M, COMSIG_MOB_DESTROY_AIRLOCK, src)
		destroy_airlock()
		return TRUE

	return FALSE

/obj/structure/machinery/door/airlock/sandstone/runed/destroy_airlock()
	if(!src)
		return
	var/turf/T = get_turf(src)

	to_chat(loc, SPAN_DANGER("[src] blows apart!"))

	new /obj/item/stack/sheet/mineral/sandstone/runed(T)
	new /obj/item/stack/sheet/mineral/sandstone/runed(T)
	new /obj/item/stack/sheet/mineral/sandstone/runed(T)
	new /obj/item/stack/sheet/mineral/sandstone/runed(T)

	playsound(src, 'sound/effects/metal_crash.ogg', 25, 1)
	qdel(src)

/obj/structure/machinery/door/airlock/sandstone/runed/ex_act(severity, explosion_direction)
	var/exp_damage = severity * EXPLOSION_DAMAGE_MULTIPLIER_DOOR
	var/location = get_turf(src)
	if(!density)
		exp_damage *= EXPLOSION_DAMAGE_MODIFIER_DOOR_OPEN
	if(take_damage(exp_damage)) // destroyed by explosion, shards go flying
		create_shrapnel(location, rand(2,5), explosion_direction, , /datum/ammo/bullet/shrapnel/light)

/obj/structure/machinery/door/airlock/sandstone/runed/get_explosion_resistance()
	if(density)
		return (damage_cap-damage)/EXPLOSION_DAMAGE_MULTIPLIER_DOOR
	else
		return FALSE
/*#################################################################################################
###################################################################################################
#################################################################################################*/
