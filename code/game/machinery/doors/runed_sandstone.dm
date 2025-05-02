/obj/structure/machinery/door/airlock/sandstone/runed
	name = "\improper Runed Sandstone Airlock"
	icon = 'icons/obj/structures/doors/doorrunedsand.dmi'
	mineral = "runed sandstone"
	no_panel = TRUE
	not_weldable = TRUE
	use_power = USE_POWER_NONE
	autoclose = FALSE
	locked = TRUE
	icon_state = "door_locked"
	stat = 0
	heavy = TRUE
	masterkey_resist = TRUE
	openspeed = 4 SECONDS
	unacidable = TRUE//Walls can still be melted or blown up.
	damage_cap = HEALTH_WALL_REINFORCED//Strong, but only available to Hunters so no abuse from marines.
	color = "#b29082"

/obj/structure/machinery/door/airlock/sandstone/runed/proc/can_use(mob/user as mob, loud = 0)
	if(!in_range(src, user))
		to_chat(usr, "You cannot operate the door from this far away")
		return FALSE

/obj/structure/machinery/door/airlock/sandstone/runed/attackby(obj/item/W as obj, mob/user as mob)
// ..()
	user.set_interaction(src)
	if (!istype(W, /obj/item/weapon/bracer_attachment || !isyautja(user)))
		return

	if(istype(W, /obj/item/weapon/bracer_attachment))
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
		INVOKE_ASYNC(src, PROC_REF(open))
	return TRUE

/obj/structure/machinery/door/airlock/sandstone/runed/proc/close_door()
	if(!src.density)
		INVOKE_ASYNC(src, PROC_REF(close))
	return TRUE

/obj/structure/machinery/door/airlock/sandstone/runed/proc/lock_door()
	if(!src.locked)
		INVOKE_ASYNC(src, PROC_REF(lock))
	return TRUE

/obj/structure/machinery/door/airlock/sandstone/runed/proc/unlock_door()
	if(src.locked)
		INVOKE_ASYNC(src, PROC_REF(unlock))
	return TRUE

/// Stops the door being interacted with, without wristblades.
/obj/structure/machinery/door/airlock/sandstone/runed/bumpopen(mob/user as mob)
	return FALSE

/obj/structure/machinery/door/airlock/sandstone/runed/try_to_activate_door(mob/user)
	return FALSE


/obj/structure/machinery/door/airlock/sandstone/runed/open(forced = TRUE)
	if(operating && !forced)
		return FALSE
	if(welded)
		return FALSE
	if(locked)
		return FALSE
	if(!density)
		return TRUE
	if(!loc)
		return FALSE
	if(!forced && !arePowerSystemsOn())
		return FALSE

	playsound(loc, 'sound/effects/runedsanddoor.ogg', 25, 0)
	visible_message(SPAN_NOTICE("\The [src] makes a loud grating sound as hidden workings pull it open."))
	operating = DOOR_OPERATING_OPENING
	do_animate("opening")
	icon_state = "door0"
	set_opacity(0)

	addtimer(CALLBACK(src, PROC_REF(finish_open)), openspeed, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)
	return TRUE

/obj/structure/machinery/door/airlock/sandstone/runed/finish_open()
	if(operating != DOOR_OPERATING_OPENING)
		return

	layer = open_layer
	density = FALSE
	update_icon()
	set_opacity(0)
	if(length(filler_turfs))
		change_filler_opacity(opacity)

	operating = DOOR_OPERATING_IDLE

/obj/structure/machinery/door/airlock/sandstone/runed/close(forced = TRUE)
	if(operating && !forced)
		return FALSE
	if(welded)
		return FALSE
	if(locked)
		return FALSE
	if(density && !operating)
		return TRUE
	if(!loc)
		return FALSE

	if(safe)
		for(var/turf/turf in locs)
			if(locate(/mob/living) in turf)
				addtimer(CALLBACK(src, PROC_REF(close), forced), 6 SECONDS + openspeed, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)
				return FALSE
	playsound(loc, 'sound/effects/runedsanddoor.ogg', 25, 0)
	visible_message(SPAN_NOTICE("[src] makes a loud grating sound as hidden workings force it shut."))

	operating = DOOR_OPERATING_CLOSING
	density = TRUE
	set_opacity(1)
	layer = closed_layer
	do_animate("closing")

	addtimer(CALLBACK(src, PROC_REF(finish_close)), openspeed, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)
	return TRUE

/obj/structure/machinery/door/airlock/sandstone/runed/finish_close()
	if(operating != DOOR_OPERATING_CLOSING)
		return

	update_icon()
	operating = DOOR_OPERATING_IDLE

	for(var/turf/turf in locs)
		for(var/mob/living/M in turf)
			M.apply_damage(DOOR_CRUSH_DAMAGE, BRUTE)
			M.set_effect(5, STUN)
			M.set_effect(5, WEAKEN)
			M.emote("pain")
			var/turf/location = loc
			if(istype(location, /turf))
				location.add_mob_blood(M)

		var/obj/structure/window/killthis = (locate(/obj/structure/window) in turf)
		if(killthis)
			killthis.ex_act(EXPLOSION_THRESHOLD_LOW)

/obj/structure/machinery/door/airlock/sandstone/runed/lock(forced = FALSE)
	if(operating && !forced)
		return FALSE
	if(locked)
		return FALSE

	playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 25)
	locked = TRUE
	if(density)
		visible_message(SPAN_NOTICE("[src] makes a loud grating sound as heavy stone bolts seal it shut."))
	else
		visible_message(SPAN_NOTICE("[src] makes a loud grating sound as heavy stone bolts seal it open."))
	update_icon()

/obj/structure/machinery/door/airlock/sandstone/runed/unlock(forced = FALSE)
	if(operating && !forced)
		return FALSE
	if(!locked)
		return FALSE

	locked = FALSE
	playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 25)
	visible_message(SPAN_NOTICE("[src] makes a loud grating sound as heavy stone bolts retract."))
	update_icon()
	return TRUE

//Damage procs needed to be redefined because unacidable apparently makes doors immortal.
/obj/structure/machinery/door/airlock/sandstone/runed/take_damage(dam, mob/M)
	if(!dam)
		return FALSE

	damage = max(0, damage + dam)

	if(damage >= damage_cap)
		if(M && istype(M))
			M.count_niche_stat(STATISTICS_NICHE_DESTRUCTION_DOORS, 1)
			SEND_SIGNAL(M, COMSIG_MOB_DESTROY_AIRLOCK, src)
		to_chat(loc, SPAN_DANGER("[src] blows apart!"))
		deconstruct(FALSE)
		playsound(src, 'sound/effects/metal_crash.ogg', 25, 1)

		return TRUE

	return FALSE

/obj/structure/machinery/door/airlock/sandstone/runed/deconstruct(disassembled = TRUE)
	if(!src)
		return

	if(!disassembled)
		var/turf/T = get_turf(src)
		new /obj/item/stack/sheet/mineral/sandstone/runed(T)
		new /obj/item/stack/sheet/mineral/sandstone/runed(T)
		new /obj/item/stack/sheet/mineral/sandstone/runed(T)
		new /obj/item/stack/sheet/mineral/sandstone/runed(T)
	return ..()

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

/obj/structure/machinery/door/airlock/sandstone/runed/destroyable
	name = "\improper Runed Sandstone Airlock"
	unacidable = FALSE //Destroyable version of the temple doors
	damage_cap = HEALTH_WALL

/obj/structure/machinery/door/airlock/sandstone/runed/dark
	color = "#2E1E21"
