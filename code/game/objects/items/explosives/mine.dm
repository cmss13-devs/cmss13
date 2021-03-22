///***MINES***///
//Mines have an invisible "tripwire" atom that explodes when crossed
//Stepping directly on the mine will also blow it up
/obj/item/explosive/mine
	name = "\improper M20 Claymore anti-personnel mine"
	desc = "The M20 Claymore is a directional proximity-triggered anti-personnel mine designed by Armat Systems for use by the United States Colonial Marines. The mine is triggered by movement both on the mine itself, and on the space immediately in front of it. Detonation sprays shrapnel forwards in a 120-degree cone. The words \"FRONT TOWARD ENEMY\" are embossed on the front."
	icon = 'icons/obj/items/weapons/grenade.dmi'
	icon_state = "m20"
	force = 5.0
	w_class = SIZE_SMALL
	//layer = MOB_LAYER - 0.1 //You can't just randomly hide claymores under boxes. Booby-trapping bodies is fine though
	throwforce = 5.0
	throw_range = 6
	throw_speed = SPEED_VERY_FAST
	unacidable = TRUE
	flags_atom = FPRINT|CONDUCT
	allowed_sensors = list(/obj/item/device/assembly/prox_sensor)
	max_container_volume = 120
	reaction_limits = list(	"max_ex_power" = 105,	"base_ex_falloff" = 60,	"max_ex_shards" = 32,
							"max_fire_rad" = 5,		"max_fire_int" = 12,	"max_fire_dur" = 18,
							"min_fire_rad" = 2,		"min_fire_int" = 3,		"min_fire_dur" = 3
	)
	angle = 60
	use_dir = TRUE
	var/iff_signal = FACTION_MARINE
	var/triggered = FALSE
	var/obj/effect/mine_tripwire/tripwire


/obj/item/explosive/mine/Destroy()
	QDEL_NULL(tripwire)
	. = ..()

/obj/item/explosive/mine/ex_act()
	prime() //We don't care about how strong the explosion was.

/obj/item/explosive/mine/emp_act()
	prime() //Same here. Don't care about the effect strength.


//checks for things that would prevent us from placing the mine.
/obj/item/explosive/mine/proc/check_for_obstacles(mob/living/user)
	if(locate(/obj/item/explosive/mine) in get_turf(src))
		to_chat(user, SPAN_WARNING("There already is a mine at this position!"))
		return TRUE
	if(user.loc && (user.loc.density || locate(/obj/structure/fence) in user.loc))
		to_chat(user, SPAN_WARNING("You can't plant a mine here."))
		return TRUE



//Arming
/obj/item/explosive/mine/attack_self(mob/living/user)
	if(!..())
		return

	if(check_for_obstacles(user))
		return

	if(active || user.action_busy)
		return

	user.visible_message(SPAN_NOTICE("[user] starts deploying [src]."), \
		SPAN_NOTICE("You start deploying [src]."))
	if(!do_after(user, 40, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		user.visible_message(SPAN_NOTICE("[user] stops deploying [src]."), \
			SPAN_NOTICE("You stop deploying \the [src]."))
		return

	if(active)
		return

	if(check_for_obstacles(user))
		return

	user.visible_message(SPAN_NOTICE("[user] finishes deploying [src]."), \
		SPAN_NOTICE("You finish deploying [src]."))

	source_mob = user
	anchored = TRUE
	playsound(loc, 'sound/weapons/mine_armed.ogg', 25, 1)
	user.drop_inv_item_on_ground(src)
	setDir(user.dir) //The direction it is planted in is the direction the user faces at that time
	activate_sensors()
	update_icon()


//Disarming
/obj/item/explosive/mine/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/device/multitool))
		if(active)
			if(user.action_busy)
				return
			user.visible_message(SPAN_NOTICE("[user] starts disarming [src]."), \
			SPAN_NOTICE("You start disarming [src]."))
			if(!do_after(user, 30, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY))
				user.visible_message(SPAN_WARNING("[user] stops disarming [src]."), \
					SPAN_WARNING("You stop disarming [src]."))
				return
			if(!active)//someone beat us to it
				return
			user.visible_message(SPAN_NOTICE("[user] finishes disarming [src]."), \
			SPAN_NOTICE("You finish disarming [src]."))
			disarm()

	else
		return ..()

/obj/item/explosive/mine/proc/disarm()
	if(customizable)
		activate_sensors()
	anchored = FALSE
	active = FALSE
	triggered = FALSE
	update_icon()
	QDEL_NULL(tripwire)

/obj/item/explosive/mine/activate_sensors()
	if(active)
		return

	if(!customizable)
		set_tripwire()
		return;

	if(!detonator)
		active = TRUE
		return

	if(customizable && assembly_stage == ASSEMBLY_LOCKED)
		if(isigniter(detonator.a_right) && isigniter(detonator.a_left))
			set_tripwire()
			return
		else
			..()
			use_dir = FALSE // Claymore defaults to radial in these case. Poor man C4
			triggered = TRUE // Delegating the tripwire/crossed function to the sensor.


/obj/item/explosive/mine/proc/set_tripwire()
	if(!active && !tripwire)
		var/tripwire_loc = get_turf(get_step(loc, dir))
		tripwire = new(tripwire_loc)
		tripwire.linked_claymore = src
		active = TRUE


//Mine can also be triggered if you "cross right in front of it" (same tile)
/obj/item/explosive/mine/Crossed(atom/A)
	..()
	if(isliving(A))
		var/mob/living/L = A
		if(!L.stat == DEAD)//so dragged corpses don't trigger mines.
			return
		else
			try_to_prime(A)

/obj/item/explosive/mine/Collided(atom/movable/AM)
	try_to_prime(AM)


/obj/item/explosive/mine/proc/try_to_prime(mob/living/L)
	if(!active || triggered || (customizable && !detonator))
		return
	if(!istype(L))
		return
	if(L.stat == DEAD)
		return
	if(L.get_target_lock(iff_signal) || isrobot(L))
		return
	L.visible_message(SPAN_DANGER("[icon2html(src, viewers(src))] The [name] clicks as [L] moves in front of it."), \
	SPAN_DANGER("[icon2html(src, L)] The [name] clicks as you move in front of it."), \
	SPAN_DANGER("You hear a click."))

	triggered = TRUE
	playsound(loc, 'sound/weapons/mine_tripped.ogg', 25, 1)
	prime()



//Note : May not be actual explosion depending on linked method
/obj/item/explosive/mine/prime()
	set waitfor = 0

	if(!customizable)
		create_shrapnel(loc, 12, dir, angle, , initial(name), source_mob)
		sleep(2) //so that shrapnel has time to hit mobs before they are knocked over by the explosion
		cell_explosion(loc, 60, 20, EXPLOSION_FALLOFF_SHAPE_LINEAR, dir, initial(name), source_mob)
		qdel(src)
	else
		. = ..()
		if(!QDELETED(src))
			disarm()


/obj/item/explosive/mine/attack_alien(mob/living/carbon/Xenomorph/M)
	if(triggered) //Mine is already set to go off
		return

	if(M.a_intent == INTENT_HELP)
		return
	M.visible_message(SPAN_DANGER("[M] has slashed [src]!"), \
		SPAN_DANGER("You slash [src]!"))
	playsound(loc, 'sound/weapons/slice.ogg', 25, 1)

	//We move the tripwire randomly in either of the four cardinal directions
	triggered = TRUE
	if(tripwire)
		var/direction = pick(cardinal)
		var/step_direction = get_step(src, direction)
		tripwire.forceMove(step_direction)
	prime()
	if(!QDELETED(src))
		disarm()


/obj/item/explosive/mine/flamer_fire_act() //adding mine explosions
	prime()
	if(!QDELETED(src))
		disarm()


/obj/effect/mine_tripwire
	name = "claymore tripwire"
	anchored = TRUE
	mouse_opacity = 0
	invisibility = 101
	unacidable = TRUE //You never know
	var/obj/item/explosive/mine/linked_claymore

/obj/effect/mine_tripwire/Destroy()
	if(linked_claymore)
		linked_claymore = null
	. = ..()

//immune to explosions.
/obj/effect/mine_tripwire/ex_act(severity)
	return

/obj/effect/mine_tripwire/Crossed(atom/movable/AM)
	if(!linked_claymore)
		qdel(src)
		return

	if(linked_claymore.triggered) //Mine is already set to go off
		return

	if(linked_claymore)
		linked_claymore.try_to_prime(AM)


/obj/item/explosive/mine/pmc
	name = "\improper M20P Claymore anti-personnel mine"
	desc = "The M20P Claymore is a directional proximity triggered anti-personnel mine designed by Armat Systems for use by the United States Colonial Marines. It has been modified for use by the W-Y PMC forces."
	icon_state = "m20p"
	iff_signal = FACTION_PMC

/obj/item/explosive/mine/custom
	name = "Custom mine"
	desc = "A custom chemical mine built from an M20 casing."
	icon_state = "m20_custom"
	customizable = TRUE
	matter = list("metal" = 3750)
	has_blast_wave_dampener = TRUE
