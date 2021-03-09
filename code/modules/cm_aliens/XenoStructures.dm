/*
 * effect/alien
 */
/obj/effect/alien
	name = "alien thing"
	desc = "theres something alien about this"
	icon = null
	unacidable = TRUE
	health = 1
	flags_obj = OBJ_ORGANIC

/obj/effect/alien/Initialize(mapload, ...)
	. = ..()
	if(!icon)
		icon = get_icon_from_source(CONFIG_GET(string/alien_effects))

/*
 * Resin
 */
/obj/effect/alien/resin
	name = "resin"
	desc = "Looks like some kind of slimy growth."
	icon_state = "Resin1"
	anchored = 1
	health = 200
	unacidable = TRUE

/obj/effect/alien/resin/proc/healthcheck()
	if(health <= 0)
		density = 0
		qdel(src)

/obj/effect/alien/resin/flamer_fire_act()
	health -= 50
	healthcheck()

/obj/effect/alien/resin/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	healthcheck()
	return 1

/obj/effect/alien/resin/ex_act(severity)
	health -= (severity * RESIN_EXPLOSIVE_MULTIPLIER)
	healthcheck()
	return

/obj/effect/alien/resin/hitby(AM as mob|obj)
	..()
	if(istype(AM,/mob/living/carbon/Xenomorph))
		return
	visible_message(SPAN_DANGER("\The [src] was hit by \the [AM]."), \
	SPAN_DANGER("You hit \the [src]."))
	var/tforce = 0
	if(ismob(AM))
		tforce = 10
	else
		tforce = AM:throwforce
	if(istype(src, /obj/effect/alien/resin/sticky))
		playsound(loc, "alien_resin_move", 25)
	else
		playsound(loc, "alien_resin_break", 25)
	health = max(0, health - tforce)
	healthcheck()

/obj/effect/alien/resin/attack_alien(mob/living/carbon/Xenomorph/M)
	if(isXenoLarva(M)) //Larvae can't do shit
		return 0
	if(M.a_intent == INTENT_HELP)
		M.visible_message(SPAN_WARNING("\The [M] creepily taps on [src] with its huge claw."), \
			SPAN_WARNING("You creepily tap on [src]."), null, 5)
	else
		M.visible_message(SPAN_XENONOTICE("\The [M] claws \the [src]!"), \
		SPAN_XENONOTICE("You claw \the [src]."))
		if(istype(src, /obj/effect/alien/resin/sticky))
			playsound(loc, "alien_resin_move", 25)
		else
			playsound(loc, "alien_resin_break", 25)

		health -= (M.melee_damage_upper + 50) //Beef up the damage a bit
		healthcheck()

/obj/effect/alien/resin/attack_animal(mob/living/M as mob)
	M.visible_message(SPAN_DANGER("[M] tears \the [src]!"), \
	SPAN_DANGER("You tear \the [name]."))
	if(istype(src, /obj/effect/alien/resin/sticky))
		playsound(loc, "alien_resin_move", 25)
	else
		playsound(loc, "alien_resin_break", 25)
	health -= 40
	healthcheck()

/obj/effect/alien/resin/attack_hand()
	to_chat(usr, SPAN_WARNING("You scrape ineffectively at \the [src]."))

/obj/effect/alien/resin/attackby(obj/item/W, mob/user)
	if(!(W.flags_item & NOBLUDGEON))
		var/damage = W.force * RESIN_MELEE_DAMAGE_MULTIPLIER
		health -= damage
		if(istype(src, /obj/effect/alien/resin/sticky))
			playsound(loc, "alien_resin_move", 25)
		else
			playsound(loc, "alien_resin_break", 25)
		healthcheck()
	return ..()

/obj/effect/alien/resin/sticky
	name = "sticky resin"
	desc = "A layer of disgusting sticky slime."
	icon_state = "sticky"
	density = 0
	opacity = 0
	health = HEALTH_RESIN_XENO_STICKY
	layer = RESIN_STRUCTURE_LAYER
	var/slow_amt = 8
	var/hivenumber = XENO_HIVE_NORMAL

/obj/effect/alien/resin/sticky/Initialize(mapload, hive)
	..()
	if (hive)
		hivenumber = hive
	set_hive_data(src, hivenumber)

/obj/effect/alien/resin/sticky/Crossed(atom/movable/AM)
	. = ..()
	var/mob/living/carbon/human/H = AM
	if(istype(H) && !H.lying && !H.ally_of_hivenumber(hivenumber))
		H.next_move_slowdown = H.next_move_slowdown + slow_amt
		return .
	var/mob/living/carbon/Xenomorph/X = AM
	if(istype(X) && !X.ally_of_hivenumber(hivenumber))
		X.next_move_slowdown = X.next_move_slowdown + (slow_amt * WEED_XENO_SPEED_MULT)
		return .

/obj/effect/alien/resin/spike
	name = "resin spike"
	desc = "A small cluster of bone spikes. Ouch."
	icon = 'icons/obj/structures/alien/structures.dmi'
	icon_state = "resin_spike"
	density = 0
	opacity = 0
	health = HEALTH_RESIN_XENO_SPIKE
	layer = RESIN_STRUCTURE_LAYER
	var/hivenumber = XENO_HIVE_NORMAL
	var/damage = 8
	var/penetration = 50

	var/target_limbs = list(
		"l_leg",
		"l_foot",
		"r_leg",
		"r_foot"
	)

/obj/effect/alien/resin/spike/Initialize(mapload, hive)
	. = ..()
	if (hive)
		hivenumber = hive
	set_hive_data(src, hivenumber)
	setDir(pick(alldirs))

/obj/effect/alien/resin/spike/Crossed(atom/movable/AM)
	. = ..()
	var/mob/living/carbon/H = AM
	if(!istype(H))
		return

	if(H.ally_of_hivenumber(hivenumber))
		return

	H.apply_armoured_damage(damage, penetration = penetration, def_zone = pick(target_limbs))


// Praetorian Sticky Resin spit uses this.
/obj/effect/alien/resin/sticky/thin
	name = "thin sticky resin"
	desc = "A thin layer of disgusting sticky slime."
	health = 7
	slow_amt = 4

// Gardener drone uses this.
/obj/effect/alien/resin/sticky/thin/weak
	name = "Weak sticky resin"
	desc = "A thin and weak layer of disgusting sticky slime. It looks like it's already melting..."
	var/duration = 20 SECONDS

/obj/effect/alien/resin/sticky/thin/weak/Initialize(...)
	. = ..()
	QDEL_IN(src, duration)

/obj/effect/alien/resin/sticky/fast
	name = "fast resin"
	desc = "A layer of disgusting sleek slime."
	icon_state = "fast"
	health = HEALTH_RESIN_XENO_FAST
	var/speed_amt = 0.7

	Crossed(atom/movable/AM)
		return


//Resin Doors
/obj/structure/mineral_door/resin
	name = "resin door"
	mineralType = "resin"
	hardness = 1.5
	health = HEALTH_DOOR_XENO
	var/close_delay = 100
	var/hivenumber = XENO_HIVE_NORMAL

	flags_obj = OBJ_ORGANIC

	tiles_with = list(/obj/structure/mineral_door/resin)

/obj/structure/mineral_door/resin/Initialize(mapload, hive)
	. = ..()
	icon = get_icon_from_source(CONFIG_GET(string/alien_effects))
	relativewall()
	relativewall_neighbours()
	for(var/turf/closed/wall/W in orange(1))
		W.update_connections()
		W.update_icon()

	if (hive)
		hivenumber = hive

	set_hive_data(src, hivenumber)

/obj/structure/mineral_door/resin/flamer_fire_act(var/dam = BURN_LEVEL_TIER_1)
	health -= dam
	healthcheck()

/obj/structure/mineral_door/resin/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	healthcheck()
	return 1

/obj/structure/mineral_door/resin/attackby(obj/item/W, mob/living/user)
	if(W.pry_capable == IS_PRY_CAPABLE_FORCE && user.a_intent != INTENT_HARM)
		return // defer to item afterattack
	if(!(W.flags_item & NOBLUDGEON) && W.force)
		user.animation_attack_on(src)
		health -= W.force*RESIN_MELEE_DAMAGE_MULTIPLIER
		to_chat(user, "You hit the [name] with your [W.name]!")
		playsound(loc, "alien_resin_move", 25)
		healthcheck()
	else
		return attack_hand(user)

/obj/structure/mineral_door/resin/TryToSwitchState(atom/user)
	if(isXenoLarva(user))
		var/mob/living/carbon/Xenomorph/Larva/L = user
		if (L.hivenumber == hivenumber)
			L.scuttle(src)
		return
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if (C.ally_of_hivenumber(hivenumber))
			return ..()

/obj/structure/mineral_door/resin/Open()
	if(state || !loc) return //already open
	isSwitchingStates = 1
	playsound(loc, "alien_resin_move", 25)
	flick("[mineralType]opening",src)
	sleep(3)
	density = 0
	opacity = 0
	state = 1
	update_icon()
	isSwitchingStates = 0

	spawn(close_delay)
		if(!isSwitchingStates && state == 1)
			Close()

/obj/structure/mineral_door/resin/Close()
	if(!state || !loc) return //already closed
	//Can't close if someone is blocking it
	for(var/turf/turf in locs)
		if(locate(/mob/living) in turf)
			spawn (close_delay)
				Close()
			return
	isSwitchingStates = 1
	playsound(loc, "alien_resin_move", 25)
	flick("[mineralType]closing",src)
	sleep(3)
	density = 1
	opacity = 1
	state = 0
	update_icon()
	isSwitchingStates = 0
	for(var/turf/turf in locs)
		if(locate(/mob/living) in turf)
			Open()
			return

/obj/structure/mineral_door/resin/Dismantle(devastated = 0)
	qdel(src)

/obj/structure/mineral_door/resin/CheckHardness()
	playsound(loc, "alien_resin_move", 25)
	..()

/obj/structure/mineral_door/resin/Destroy()
	relativewall_neighbours()
	var/turf/U = loc
	spawn(0)
		var/turf/T
		for(var/i in cardinal)
			T = get_step(U, i)
			if(!istype(T)) continue
			for(var/obj/structure/mineral_door/resin/R in T)
				R.check_resin_support()
	. = ..()

/obj/structure/mineral_door/resin/proc/healthcheck()
	if(src.health <= 0)
		src.Dismantle(1)

/obj/structure/mineral_door/resin/ex_act(severity)

	if(!density)
		severity *= EXPLOSION_DAMAGE_MODIFIER_DOOR_OPEN

	health -= (severity * RESIN_EXPLOSIVE_MULTIPLIER * EXPLOSION_DAMAGE_MULTIPLIER_DOOR)
	healthcheck()

	if(src)
		check_resin_support()
	return


/obj/structure/mineral_door/resin/get_explosion_resistance()
	if(density)
		return health //this should exactly match the amount of damage needed to destroy the door
	else
		return 0

//do we still have something next to us to support us?
/obj/structure/mineral_door/resin/proc/check_resin_support()
	var/turf/T
	for(var/i in cardinal)
		T = get_step(src, i)
		if(!T)
			continue
		if(T.density)
			. = 1
			break
		if(locate(/obj/structure/mineral_door/resin) in T)
			. = 1
			break
	if(!.)
		visible_message(SPAN_NOTICE("[src] collapses from the lack of support."))
		qdel(src)

/obj/structure/mineral_door/resin/thick
	name = "thick resin door"
	health = HEALTH_DOOR_XENO_THICK
	hardness = 2.0

/obj/effect/alien/resin/acid_pillar
	name = "acid pillar"
	desc = "A resin pillar that is oozing with acid."
	icon = 'icons/obj/structures/alien/structures64x64.dmi'
	icon_state = "resin_pillar"

	pixel_x = -16
	pixel_y = -16

	health = HEALTH_RESIN_XENO_ACID_PILLAR
	var/hivenumber = XENO_HIVE_NORMAL
	anchored = TRUE

	var/list/mob/living/targets
	var/firing_cooldown = 2 SECONDS

	var/acid_type = /obj/effect/xenomorph/spray/weak

	var/list/mob/living/carbon/next_fire
	var/range = 5
	var/datum/shape/rectangle/range_bounds

/obj/effect/alien/resin/acid_pillar/Initialize(mapload, hive)
	. = ..()
	if (hive)
		hivenumber = hive
	set_hive_data(src, hivenumber)
	START_PROCESSING(SSprocessing, src)
	range_bounds = RECT(x, y, range*2, range*2)

/obj/effect/alien/resin/acid_pillar/proc/acquire_target(var/list/mobs)
	for(var/mob/living/carbon/C in mobs)
		if(!can_target(C))
			continue

		RegisterSignal(C, COMSIG_PARENT_QDELETING, .proc/remove_target, TRUE)
		LAZYOR(targets, C)

/obj/effect/alien/resin/acid_pillar/proc/remove_target(var/mob/living/carbon/M)
	SIGNAL_HANDLER
	UnregisterSignal(M, COMSIG_PARENT_QDELETING)
	LAZYREMOVE(targets, M)

/obj/effect/alien/resin/acid_pillar/proc/can_target(var/mob/living/carbon/C)
	if(get_dist(src, C) > range)
		return FALSE

	if(C.stat == DEAD)
		return FALSE

	if(C.lying)
		return FALSE

	if(C.ally_of_hivenumber(hivenumber) && !C.on_fire)
		return FALSE

	var/turf/current_turf = get_step(loc, get_dir(loc, C))
	var/turf/last_turf = loc
	var/atom/temp_atom = new acid_type()
	for(var/i in getline(src, C))
		current_turf = i
		if(LinkBlocked(temp_atom, last_turf, current_turf))
			qdel(temp_atom)
			return FALSE
		last_turf = i
	qdel(temp_atom)

	return TRUE

/obj/effect/alien/resin/acid_pillar/process()
	acquire_target(SSquadtree.players_in_range(range_bounds, z, QTREE_SCAN_MOBS | QTREE_EXCLUDE_OBSERVER))

	if(!targets)
		return

	for(var/i in targets)
		var/mob/living/carbon/C = i
		if(!can_target(C))
			remove_target(C)
			continue

		var/last_fired = LAZYACCESS(next_fire, C)
		if(last_fired && last_fired > world.time)
			continue

		SSacid_pillar.queue_attack(src, C)

/obj/effect/alien/resin/acid_pillar/proc/acid_travel(var/datum/acid_spray_info/info)
	if(QDELETED(src))
		return FALSE

	if(!can_target(info.target))
		return FALSE

	if(info.distance_travelled > range)
		return FALSE

	var/mob/living/carbon/C = info.target
	var/turf/current_turf = info.current_turf

	current_turf = get_step(current_turf, get_dir(current_turf, C))
	info.distance_travelled += 1
	info.current_turf = current_turf

	new acid_type(current_turf, name, null, hivenumber)

	if(get_dist(current_turf, C) == 0)
		LAZYSET(next_fire, info.target, world.time + firing_cooldown)
		return FALSE

	return TRUE

/obj/effect/alien/resin/acid_pillar/Destroy()
	QDEL_NULL(range_bounds)
	next_fire = null
	targets   = null
	return ..()

/obj/effect/alien/resin/acid_pillar/get_projectile_hit_boolean(obj/item/projectile/P)
	return TRUE

/obj/effect/alien/resin/resin_pillar
	name = "resin pillar"
	desc = "This massive structure arose out of some weeds coating the ground, somehow... It seems to be doing nothing but blocking the way."
	health = HEALTH_RESIN_PILLAR
	var/vulnerable_health = HEALTH_RESIN_PILLAR
	icon = 'icons/obj/structures/alien/structures96x96.dmi'
	icon_state = "resin_pillar"
	invisibility = INVISIBILITY_MAXIMUM
	var/width = 3
	var/height = 3
	var/time_to_brittle = 45 SECONDS
	var/time_to_collapse = 45 SECONDS

	var/turf_icon = WALL_THICKRESIN
	var/brittle_turf_icon = WALL_MEMBRANE

	var/brittle = FALSE
	var/list/turf/closed/wall/walls
	var/resin_wall_type = /turf/closed/wall/resin/pillar
	layer = UNDER_TURF_LAYER

/obj/effect/alien/resin/resin_pillar/Initialize(mapload, ...)
	. = ..()
	//playsound(granite shuffling)
	bound_width = width * world.icon_size
	bound_height = height * world.icon_size
	playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 25, FALSE)
	if(mapload) //this should never be called in mapload, but in case it is
		name = "calcified resin pillar"
		desc = "This massive structure seems to be inert."

	var/turf/closed/wall/T
	for(var/i in locs)
		T = i
		if(T.density)
			continue
		T = T.ChangeTurf(resin_wall_type)
		T.walltype = turf_icon
		T.update_connections(TRUE)
		T.update_icon()
		setup_signals(T)
		LAZYADD(walls, T)

/obj/effect/alien/resin/resin_pillar/proc/setup_signals(var/turf/T)
	RegisterSignal(T, COMSIG_TURF_BULLET_ACT, .proc/handle_bullet)
	RegisterSignal(T, COMSIG_ATOM_HITBY, .proc/handle_hitby)
	RegisterSignal(T, COMSIG_WALL_RESIN_XENO_ATTACK, .proc/handle_attack_alien)
	RegisterSignal(T, COMSIG_WALL_RESIN_ATTACKBY, .proc/handle_attackby)

/obj/effect/alien/resin/resin_pillar/Destroy()
	STOP_PROCESSING(SSobj, src)
	for(var/i in walls)
		var/turf/T = i
		T.ScrapeAway()
	walls = null
	return ..()

/obj/effect/alien/resin/resin_pillar/proc/handle_attack_alien(var/turf/T, var/mob/M)
	SIGNAL_HANDLER
	attack_alien(M)
	return COMPONENT_CANCEL_XENO_ATTACK

/obj/effect/alien/resin/resin_pillar/proc/handle_attackby(var/turf/T, var/obj/item/I, var/mob/M)
	SIGNAL_HANDLER
	attackby(I, M)
	return COMPONENT_CANCEL_ATTACKBY

/obj/effect/alien/resin/resin_pillar/proc/handle_hitby(var/turf/T, var/atom/movable/AM)
	SIGNAL_HANDLER
	hitby(AM)

/obj/effect/alien/resin/resin_pillar/proc/handle_bullet(var/turf/T, var/obj/item/projectile/P)
	SIGNAL_HANDLER
	bullet_act(P)
	return COMPONENT_BULLET_ACT_OVERRIDE

/obj/effect/alien/resin/resin_pillar/process()
	if(prob(25))
		playsound(loc, "alien_resin_break", 25, TRUE)

/obj/effect/alien/resin/resin_pillar/proc/start_decay(brittle_time_override, collapse_time_override)
	time_to_brittle = brittle_time_override
	time_to_collapse = collapse_time_override

	addtimer(CALLBACK(src, .proc/brittle), time_to_brittle)

/obj/effect/alien/resin/resin_pillar/proc/brittle()
	//playsound(granite cracking)
	visible_message(SPAN_DANGER("You hear cracking sounds from the [src] as splinters start falling off from the structure! It seems brittle now."))
	health = vulnerable_health
	for(var/i in walls)
		var/turf/closed/wall/T = i
		T.walltype = brittle_turf_icon
		T.update_connections(TRUE)
		T.update_icon()

	playsound(loc, "alien_resin_break", 25, TRUE)
	START_PROCESSING(SSobj, src)
	addtimer(CALLBACK(src, .proc/collapse, TRUE), time_to_collapse)
	brittle = TRUE

/obj/effect/alien/resin/resin_pillar/healthcheck()
	if(!brittle)
		health = vulnerable_health
		return
	return ..()

/obj/effect/alien/resin/resin_pillar/proc/collapse(var/decayed = FALSE)
	//playsound granite collapsing
	if(decayed)
		visible_message(SPAN_DANGER("[src]'s failing structure suddenly collapses!"))
	else
		visible_message(SPAN_DANGER("[src]'s structure collapses under the blow!"))

	playsound(loc, "alien_resin_break", 25, TRUE)
	qdel(src)

//bullet_act() by default only pings, so it's not overridden here. it should not damage, only ping even post-brittle

/obj/effect/alien/resin/resin_pillar/hitby(atom/movable/AM)
	if(!brittle)
		visible_message(SPAN_DANGER("[AM] harmlessly bounces off the [src]!"))
		return
	return ..()


/obj/effect/alien/resin/resin_pillar/attack_alien(mob/living/carbon/Xenomorph/M)
	if(!brittle)
		M.animation_attack_on(src)
		M.visible_message(SPAN_XENONOTICE("\The [M] claws \the [src], but the slash bounces off!"), \
		SPAN_XENONOTICE("You claw \the [src], but the slash bounces off!"))
		return

	return ..()

/obj/effect/alien/resin/resin_pillar/attackby(obj/item/W, mob/living/user)
	user.animation_attack_on(src)
	if(!brittle)
		user.visible_message(SPAN_DANGER("[user] hits \the [src], but \the [W] bounces off!"), \
			SPAN_DANGER("You hit \the [name], but \the [W] bounces off!"))
		return

	return ..()
