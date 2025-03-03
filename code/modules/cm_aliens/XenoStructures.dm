/*
 * effect/alien
 */
/obj/effect/alien
	name = "alien thing"
	desc = "There's something alien about this."
	icon = 'icons/mob/xenos/effects.dmi'
	unacidable = TRUE
	health = 1
	flags_obj = OBJ_ORGANIC

/*
 * Resin
 */
/obj/effect/alien/resin
	name = "resin"
	desc = "Looks like some kind of slimy growth."
	icon_state = "weeds"
	anchored = TRUE
	health = 200
	unacidable = TRUE
	var/should_track_build = FALSE
	var/datum/cause_data/construction_data
	var/list/blockers = list()
	var/block_range = 0

/obj/effect/alien/resin/Initialize(mapload, mob/builder)
	. = ..()
	if(istype(builder) && should_track_build)
		construction_data = create_cause_data(initial(name), builder)
	if(block_range)
		for(var/turf/turf in range(block_range, src))
			var/obj/effect/build_blocker/blocker = new(turf, src)
			blockers.Add(blocker)

	var/area/current_area = get_area(src)
	if(current_area.linked_lz)
		AddComponent(/datum/component/resin_cleanup)

/obj/effect/alien/resin/Destroy()
	QDEL_LIST(blockers)
	return ..()

/obj/effect/alien/resin/proc/healthcheck()
	if(health <= 0)
		deconstruct(FALSE)

/obj/effect/alien/resin/flamer_fire_act()
	health -= 50
	healthcheck()

/obj/effect/alien/resin/bullet_act(obj/projectile/Proj)
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
	if(istype(AM,/mob/living/carbon/xenomorph))
		return
	visible_message(SPAN_DANGER("\The [src] was hit by \the [AM]."),
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

/obj/effect/alien/resin/attack_alien(mob/living/carbon/xenomorph/M)
	if(islarva(M)) //Larvae can't do shit
		return

	if(M.a_intent == INTENT_HELP)
		return XENO_NO_DELAY_ACTION
	else
		M.animation_attack_on(src)
		M.visible_message(SPAN_XENONOTICE("\The [M] claws \the [src]!"),
		SPAN_XENONOTICE("We claw \the [src]."))
		if(istype(src, /obj/effect/alien/resin/sticky))
			playsound(loc, "alien_resin_move", 25)
		else
			playsound(loc, "alien_resin_break", 25)

		var/damage_to_structure = M.melee_damage_upper + XENO_DAMAGE_TIER_7
		// Builders can destroy beefy things in maximum 5 hits
		if(isxeno_builder(M))
			health -= max(initial(health) * 0.2, damage_to_structure)
		else
			health -= damage_to_structure
		healthcheck()
	return XENO_ATTACK_ACTION

/obj/effect/alien/resin/attack_animal(mob/living/M as mob)
	M.visible_message(SPAN_DANGER("[M] tears \the [src]!"),
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
		var/damage = W.force * W.demolition_mod * RESIN_MELEE_DAMAGE_MULTIPLIER
		health -= damage
		if(istype(src, /obj/effect/alien/resin/sticky))
			playsound(loc, "alien_resin_move", 25)
		else
			playsound(loc, "alien_resin_break", 25)
		healthcheck()
	return ..()

/obj/effect/alien/resin/proc/set_resin_builder(mob/M)
	if(istype(M) && should_track_build)
		construction_data = create_cause_data(initial(name), M)

/obj/effect/build_blocker
	health = 500000
	unacidable = TRUE
	explo_proof = TRUE
	invisibility = 101
	alpha = 0
	/// The atom we are blocking for
	var/atom/linked_structure

/obj/effect/build_blocker/New(loc, linked_structure)
	. = ..()
	src.linked_structure = linked_structure

/obj/effect/build_blocker/Destroy(force)
	linked_structure = null
	return ..()

/obj/effect/alien/resin/sticky
	name = "sticky resin"
	desc = "A layer of disgusting sticky slime."
	icon_state = "sticky"
	density = FALSE
	opacity = FALSE
	health = HEALTH_RESIN_XENO_STICKY
	layer = RESIN_STRUCTURE_LAYER
	plane = FLOOR_PLANE
	var/slow_amt = 8
	var/hivenumber = XENO_HIVE_NORMAL

/obj/effect/alien/resin/sticky/Initialize(mapload, hive)
	. = ..()
	if (hive)
		hivenumber = hive
	set_hive_data(src, hivenumber)
	if(hivenumber == XENO_HIVE_NORMAL)
		RegisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING, PROC_REF(forsaken_handling))

/obj/effect/alien/resin/sticky/Crossed(atom/movable/AM)
	. = ..()
	var/mob/living/carbon/human/H = AM
	if(istype(H) && !H.ally_of_hivenumber(hivenumber))
		H.next_move_slowdown = max(H.next_move_slowdown, slow_amt)
		return .
	var/mob/living/carbon/xenomorph/X = AM
	if(istype(X) && !X.ally_of_hivenumber(hivenumber))
		X.next_move_slowdown = max(X.next_move_slowdown, slow_amt)
		return .

/obj/effect/alien/resin/sticky/proc/forsaken_handling()
	SIGNAL_HANDLER
	if(is_ground_level(z))
		hivenumber = XENO_HIVE_FORSAKEN
		set_hive_data(src, XENO_HIVE_FORSAKEN)

	UnregisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING)

/obj/effect/alien/resin/spike
	name = "resin spike"
	desc = "A small cluster of bone spikes. Ouch."
	icon = 'icons/obj/structures/alien/structures.dmi'
	icon_state = "resin_spike"
	density = FALSE
	opacity = FALSE
	health = HEALTH_RESIN_XENO_SPIKE
	layer = RESIN_STRUCTURE_LAYER
	should_track_build = TRUE
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
	setDir(pick(GLOB.alldirs))
	if(hivenumber == XENO_HIVE_NORMAL)
		RegisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING, PROC_REF(forsaken_handling))

/obj/effect/alien/resin/spike/Crossed(atom/movable/AM)
	. = ..()
	var/mob/living/carbon/H = AM
	if(!istype(H))
		return

	if(H.ally_of_hivenumber(hivenumber))
		return

	H.apply_armoured_damage(damage, penetration = penetration, def_zone = pick(target_limbs))
	H.last_damage_data = construction_data

/obj/effect/alien/resin/spike/proc/forsaken_handling()
	SIGNAL_HANDLER
	if(is_ground_level(z))
		hivenumber = XENO_HIVE_FORSAKEN
		set_hive_data(src, XENO_HIVE_FORSAKEN)

	UnregisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING)

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

/obj/effect/alien/resin/sticky/fast/Crossed(atom/movable/AM)
	return


//xeno marker :0)
/obj/effect/alien/resin/marker
	name = "Resin Mark"
	desc = "Something has made its mark on the world, and there it is..."
	icon = 'icons/mob/hud/xeno_markers.dmi'
	icon_state = "marker_nub"
	health = HEALTH_RESIN_XENO_SPIKE
	var/list/xenos_tracking = list()
	var/datum/xeno_mark_define/mark_meaning = null
	var/image/seenMeaning //this needs to be a static image because it needs to be dynamically added/removed from xenos' huds as resin marks are created/destroyed
	var/datum/hivenumber = null
	var/createdby = null
	var/createdTime = null

	//scuffed variables so the overwatch code doesnt have a fit
	var/interference = 0
	var/stat = null

/obj/effect/alien/resin/marker/Initialize(mapload, mob/builder)
	. = ..()
	if(!isxeno(builder))
		return

	var/mob/living/carbon/xenomorph/X = builder

	X.built_structures |= src
	createdby = X.nicknumber
	mark_meaning = new X.selected_mark
	seenMeaning =  image(icon, src.loc, mark_meaning.icon_state, ABOVE_HUD_LAYER, "pixel_y" = 5)
	seenMeaning.plane = ABOVE_HUD_PLANE
	hivenumber = X.hivenumber
	createdTime = worldtime2text()
	X.hive.resin_marks += src

	X.hive.mark_ui.update_all_data()

	for(var/mob/living/carbon/xenomorph/XX in X.hive.totalXenos)
		XX.hud_set_marks() //this should be a hud thing, but that code is too confusing so I am doing it here

	addtimer(CALLBACK(src, PROC_REF(check_for_weeds)), 30 SECONDS, TIMER_UNIQUE)

/obj/effect/alien/resin/marker/Destroy()
	var/datum/hive_status/builder_hive = GLOB.hive_datum[hivenumber]

	if(builder_hive)
		builder_hive.resin_marks -= src

		for(var/mob/living/carbon/xenomorph/XX in builder_hive.totalXenos)
			XX.built_structures -= src
			if(!XX.client)
				continue
			XX.client.images -= seenMeaning  //this should be a hud thing, but that code is too confusing so I am doing it here
			XX.hive.mark_ui.update_all_data()

		for(var/mob/living/carbon/xenomorph/X in xenos_tracking) //no floating references :0)
			X.stop_tracking_resin_mark(TRUE)
	return ..()

/obj/effect/alien/resin/marker/proc/check_for_weeds()
	var/turf/T = get_turf(src)
	for(var/i in T.contents)
		if(istype(i, /obj/effect/alien/weeds))
			addtimer(CALLBACK(src, PROC_REF(check_for_weeds)), 30 SECONDS, TIMER_UNIQUE)
			return
	qdel(src)

/obj/effect/alien/resin/marker/get_examine_text(mob/user)
	. = ..()
	var/mob/living/carbon/xenomorph/xeno_createdby
	var/datum/hive_status/builder_hive = GLOB.hive_datum[hivenumber]
	for(var/mob/living/carbon/xenomorph/X in builder_hive.totalXenos)
		if(X.nicknumber == createdby)
			xeno_createdby = X
	if(isxeno(user) || isobserver(user))
		. += "[mark_meaning.desc], ordered by [xeno_createdby.name]"

/obj/effect/alien/resin/marker/attack_alien(mob/living/carbon/xenomorph/M)
	if(M.hive_pos == 1 || M.nicknumber == createdby)
		. = ..()
	else
		return

/obj/effect/alien/resin/marker/proc/hud_set_queen_overwatch()
	//the stupidest way around feeding effects in as mobs to overwatch() lmao
	return

//Resin Doors
/obj/structure/mineral_door/resin
	name = "resin door"
	icon = 'icons/mob/xenos/effects.dmi'
	icon_state = "resin"
	mineralType = "resin"
	hardness = 1.5
	health = HEALTH_DOOR_XENO
	var/close_delay = 100
	var/hivenumber = XENO_HIVE_NORMAL

	flags_obj = OBJ_ORGANIC
	layer = DOOR_CLOSED_LAYER
	tiles_with = list(/obj/structure/mineral_door/resin)

/obj/structure/mineral_door/resin/Initialize(mapload, hive)
	. = ..()
	relativewall()
	relativewall_neighbours()
	for(var/turf/closed/wall/W in orange(1))
		W.update_connections()
		W.update_icon()

	if(hive)
		hivenumber = hive

	set_hive_data(src, hivenumber)

	if(hivenumber == XENO_HIVE_NORMAL)
		RegisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING, PROC_REF(forsaken_handling))

	var/area/area = get_area(src)
	if(area)
		if(area.linked_lz)
			AddComponent(/datum/component/resin_cleanup)
		area.current_resin_count++

/obj/structure/mineral_door/resin/flamer_fire_act(dam = BURN_LEVEL_TIER_1)
	health -= dam
	healthcheck()

/obj/structure/mineral_door/resin/bullet_act(obj/projectile/Proj)
	health -= Proj.damage
	..()
	healthcheck()
	return 1

/obj/structure/mineral_door/resin/attackby(obj/item/W, mob/living/user)
	if(W.pry_capable == IS_PRY_CAPABLE_FORCE && user.a_intent != INTENT_HARM)
		return // defer to item afterattack
	if(!(W.flags_item & NOBLUDGEON) && W.force)
		user.animation_attack_on(src)
		health -= W.force * RESIN_MELEE_DAMAGE_MULTIPLIER * W.demolition_mod
		to_chat(user, "You hit the [name] with your [W.name]!")
		playsound(loc, "alien_resin_move", 25)
		healthcheck()
		return ATTACKBY_HINT_UPDATE_NEXT_MOVE
	else
		return attack_hand(user)

/obj/structure/mineral_door/resin/TryToSwitchState(atom/user)
	if(isxeno(user))
		var/mob/living/carbon/xenomorph/xeno_user = user
		if (xeno_user.hivenumber != hivenumber && !xeno_user.ally_of_hivenumber(hivenumber))
			return
		if(xeno_user.scuttle(src))
			return
		return ..()
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if (C.ally_of_hivenumber(hivenumber))
			return ..()

/obj/structure/mineral_door/resin/open()
	if(open || !loc)
		return //already open
	isSwitchingStates = TRUE
	playsound(loc, "alien_resin_move", 25)
	flick("[mineralType]opening",src)
	addtimer(CALLBACK(src, PROC_REF(finish_open)), 3 DECISECONDS, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)

/obj/structure/mineral_door/resin/finish_open()
	if(!loc || QDELETED(src))
		return
	density = FALSE
	opacity = FALSE
	open = TRUE
	update_icon()
	isSwitchingStates = FALSE
	layer = DOOR_OPEN_LAYER
	addtimer(CALLBACK(src, PROC_REF(close)), close_delay, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)

/obj/structure/mineral_door/resin/proc/close_blocked()
	for(var/turf/turf in locs)
		for(var/mob/living/living_mob in turf)
			if(!HAS_TRAIT(living_mob, TRAIT_MERGED_WITH_WEEDS))
				return TRUE
	return FALSE

/obj/structure/mineral_door/resin/close()
	if(!open || !loc || isSwitchingStates)
		return //already closed or changing
	//Can't close if someone is blocking it
	if(close_blocked())
		addtimer(CALLBACK(src, PROC_REF(close)), close_delay, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)
		return

	isSwitchingStates = TRUE
	playsound(loc, "alien_resin_move", 25)
	flick("[mineralType]closing",src)
	addtimer(CALLBACK(src, PROC_REF(finish_close)), 3 DECISECONDS, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)

/obj/structure/mineral_door/resin/finish_close()
	if(!loc || QDELETED(src))
		return
	density = TRUE
	opacity = TRUE
	open = FALSE
	update_icon()
	isSwitchingStates = FALSE
	layer = DOOR_CLOSED_LAYER

	if(close_blocked())
		open()

/obj/structure/mineral_door/resin/Dismantle(devastated = 0)
	qdel(src)

/obj/structure/mineral_door/resin/CheckHardness()
	playsound(loc, "alien_resin_move", 25)
	..()

/obj/structure/mineral_door/resin/Destroy()
	relativewall_neighbours()
	var/area/area = get_area(src)
	area?.current_resin_count--
	var/turf/base_turf = loc
	spawn(0)
		var/turf/adjacent_turf
		for(var/cardinal in GLOB.cardinals)
			adjacent_turf = get_step(base_turf, cardinal)
			if(!istype(adjacent_turf))
				continue
			for(var/obj/structure/mineral_door/resin/door in adjacent_turf)
				door.check_resin_support()
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
	for(var/i in GLOB.cardinals)
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

/obj/structure/mineral_door/resin/proc/forsaken_handling()
	SIGNAL_HANDLER
	if(is_ground_level(z))
		hivenumber = XENO_HIVE_FORSAKEN
		set_hive_data(src, XENO_HIVE_FORSAKEN)

	UnregisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING)
/obj/structure/mineral_door/resin/thick
	name = "thick resin door"
	icon_state = "thick resin"
	health = HEALTH_DOOR_XENO_THICK
	hardness = 2
	mineralType = "thick resin"

/obj/effect/alien/resin/acid_pillar
	name = "acid pillar"
	desc = "A resin pillar that is oozing with acid."
	icon = 'icons/obj/structures/alien/structures.dmi'
	icon_state = "acid_pillar_idle"

	health = HEALTH_RESIN_XENO_ACID_PILLAR
	var/hivenumber = XENO_HIVE_NORMAL
	should_track_build = TRUE
	anchored = TRUE

	var/firing_cooldown = 2 SECONDS

	var/acid_type = /obj/effect/xenomorph/spray/weak
	var/range = 5

	var/currently_firing = FALSE

/obj/effect/alien/resin/acid_pillar/Initialize(mapload, hive)
	. = ..()
	if (hive)
		hivenumber = hive
	set_hive_data(src, hivenumber)
	START_PROCESSING(SSprocessing, src)
	if(hivenumber == XENO_HIVE_NORMAL)
		RegisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING, PROC_REF(forsaken_handling))


/obj/effect/alien/resin/acid_pillar/proc/can_target(mob/living/carbon/current_mob, position_to_get = 0)
	/// Is it a friendly xenomorph that is on fire
	var/burning_friendly = FALSE

	if(get_dist(src, current_mob) > range)
		return FALSE

	if(current_mob.ally_of_hivenumber(hivenumber))
		if(!isxeno(current_mob))
			return FALSE
		if(!current_mob.on_fire)
			return FALSE
		burning_friendly = TRUE

	else if(current_mob.body_position == LYING_DOWN || current_mob.is_mob_incapacitated(TRUE))
		return FALSE

	if(!burning_friendly && current_mob.health < 0)
		return FALSE
	if(current_mob.stat == DEAD)
		return FALSE

	if(HAS_TRAIT(current_mob, TRAIT_NESTED))
		return FALSE

	var/turf/current_turf
	var/turf/last_turf = loc
	var/atom/temp_atom = new acid_type()
	var/current_pos = 1
	for(var/i in get_line(src, current_mob))
		current_turf = i
		if(LinkBlocked(temp_atom, last_turf, current_turf))
			qdel(temp_atom)
			return FALSE
		last_turf = i

		if(current_pos == position_to_get)
			. = i
		current_pos++
	qdel(temp_atom)

	if(!.)
		return TRUE

/obj/effect/alien/resin/acid_pillar/process()
	if(currently_firing)
		return
	var/mob/living/carbon/target = null
	var/furthest_distance = INFINITY
	for(var/mob/living/carbon/C in urange(range, get_turf(loc)))
		if(!can_target(C))
			continue
		var/distance_between = get_dist(src, C)
		if(distance_between > furthest_distance)
			continue
		furthest_distance = distance_between
		target = C
	if(target)
		currently_firing = TRUE
		SSacid_pillar.queue_attack(src, target)
		playsound(loc, 'sound/effects/splat.ogg', 50, TRUE)
		flick("acid_pillar_attack", src)

/obj/effect/alien/resin/acid_pillar/proc/acid_travel(datum/acid_spray_info/info)
	if(QDELETED(src))
		return FALSE

	if(info.distance_travelled > range)
		return FALSE

	if(info.distance_travelled && info.current_turf == info.target_turf )
		return FALSE

	var/turf/next_turf = get_step_towards(info.current_turf, info.target_turf)
	if(next_turf.density)
		return FALSE

	info.distance_travelled++
	info.current_turf = next_turf

	new acid_type(next_turf, create_cause_data(initial(name)), hivenumber)
	return TRUE

/obj/effect/alien/resin/acid_pillar/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/effect/alien/resin/acid_pillar/get_projectile_hit_boolean(obj/projectile/P)
	return TRUE

/obj/effect/alien/resin/acid_pillar/proc/forsaken_handling()
	SIGNAL_HANDLER
	UnregisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING)
	if(is_ground_level(z))
		qdel(src)

/obj/effect/alien/resin/acid_pillar/strong
	name = "acid pillar"
	desc = "A resin pillar that is oozing with acid."
	icon = 'icons/obj/structures/alien/structures64x64.dmi'
	icon_state = "resin_pillar_strong"

	pixel_x = -16
	pixel_y = -16
	firing_cooldown = 6 SECONDS

	acid_type = /obj/effect/xenomorph/spray/strong

/obj/effect/alien/resin/shield_pillar
	name = "shield pillar"
	desc = "A resin pillar that is oozing with acid."
	icon = 'icons/obj/structures/alien/structures64x64.dmi'
	icon_state = "pillar_shield"

	pixel_x = -16
	pixel_y = -16

	health = HEALTH_RESIN_XENO_SHIELD_PILLAR
	var/hivenumber = XENO_HIVE_NORMAL
	anchored = TRUE

	var/decay_rate = AMOUNT_PER_TIME(1, 10 SECONDS)
	var/shield_to_give = 50
	var/range = 2

/obj/effect/alien/resin/shield_pillar/Initialize(mapload, hive)
	. = ..()
	if (hive)
		hivenumber = hive
	set_hive_data(src, hivenumber)
	START_PROCESSING(SSshield_pillar, src)

/obj/effect/alien/resin/shield_pillar/process()
	for(var/mob/living/carbon/xenomorph/X in urange(range, src))
		if((X.hivenumber != hivenumber) || X.stat == DEAD)
			continue
		X.add_xeno_shield(shield_to_give, XENO_SHIELD_SOURCE_SHIELD_PILLAR, decay_amount_per_second = 1, add_shield_on = TRUE, duration = 1 SECONDS)
		X.flick_heal_overlay(1 SECONDS, "#ffa800")
		X.xeno_jitter(15)

/obj/effect/alien/resin/shield_pillar/Destroy()
	STOP_PROCESSING(SSshield_pillar, src)
	return ..()

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
		T.PlaceOnTop(resin_wall_type)
		T.walltype = turf_icon
		T.update_connections(TRUE)
		T.update_icon()
		setup_signals(T)
		LAZYADD(walls, T)

/obj/effect/alien/resin/resin_pillar/proc/setup_signals(turf/T)
	RegisterSignal(T, COMSIG_TURF_BULLET_ACT, PROC_REF(handle_bullet))
	RegisterSignal(T, COMSIG_ATOM_HITBY, PROC_REF(handle_hitby))
	RegisterSignal(T, COMSIG_WALL_RESIN_XENO_ATTACK, PROC_REF(handle_attack_alien))
	RegisterSignal(T, COMSIG_WALL_RESIN_ATTACKBY, PROC_REF(handle_attackby))

/obj/effect/alien/resin/resin_pillar/Destroy()
	STOP_PROCESSING(SSobj, src)
	for(var/i in walls)
		var/turf/T = i
		T.ScrapeAway()
	walls = null
	return ..()

/obj/effect/alien/resin/resin_pillar/proc/handle_attack_alien(turf/T, mob/M)
	SIGNAL_HANDLER
	attack_alien(M)
	return COMPONENT_CANCEL_XENO_ATTACK

/obj/effect/alien/resin/resin_pillar/proc/handle_attackby(turf/T, obj/item/I, mob/M)
	SIGNAL_HANDLER
	attackby(I, M)
	return COMPONENT_CANCEL_ATTACKBY

/obj/effect/alien/resin/resin_pillar/proc/handle_hitby(turf/T, atom/movable/AM)
	SIGNAL_HANDLER
	hitby(AM)

/obj/effect/alien/resin/resin_pillar/proc/handle_bullet(turf/T, obj/projectile/P)
	SIGNAL_HANDLER
	bullet_act(P)
	return COMPONENT_BULLET_ACT_OVERRIDE

/obj/effect/alien/resin/resin_pillar/process()
	if(prob(25))
		playsound(loc, "alien_resin_break", 25, TRUE)

/obj/effect/alien/resin/resin_pillar/proc/start_decay(brittle_time_override, collapse_time_override)
	time_to_brittle = brittle_time_override
	time_to_collapse = collapse_time_override

	addtimer(CALLBACK(src, PROC_REF(brittle)), time_to_brittle)

/obj/effect/alien/resin/resin_pillar/proc/brittle()
	//playsound(granite cracking)
	visible_message(SPAN_DANGER("You hear cracking sounds from [src] as splinters start falling off from the structure! It seems brittle now."))
	health = vulnerable_health
	for(var/i in walls)
		var/turf/closed/wall/T = i
		T.walltype = brittle_turf_icon
		T.update_connections(TRUE)
		T.update_icon()

	playsound(loc, "alien_resin_break", 25, TRUE)
	START_PROCESSING(SSobj, src)
	addtimer(CALLBACK(src, PROC_REF(collapse), TRUE), time_to_collapse)
	brittle = TRUE

/obj/effect/alien/resin/resin_pillar/healthcheck()
	if(!brittle)
		health = vulnerable_health
		return
	return ..()

/obj/effect/alien/resin/resin_pillar/proc/collapse(decayed = FALSE)
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
		visible_message(SPAN_DANGER("[AM] harmlessly bounces off [src]!"))
		return
	return ..()


/obj/effect/alien/resin/resin_pillar/attack_alien(mob/living/carbon/xenomorph/M)
	if(!brittle)
		M.animation_attack_on(src)
		M.visible_message(SPAN_XENONOTICE("\The [M] claws \the [src], but the slash bounces off!"),
		SPAN_XENONOTICE("You claw \the [src], but the slash bounces off!"))
		return XENO_ATTACK_ACTION

	return ..()

/obj/effect/alien/resin/resin_pillar/attackby(obj/item/W, mob/living/user)
	user.animation_attack_on(src)
	if(!brittle)
		user.visible_message(SPAN_DANGER("[user] hits \the [src], but \the [W] bounces off!"),
			SPAN_DANGER("You hit \the [name], but \the [W] bounces off!"))
		return

	return ..()

/obj/effect/alien/resin/king_cocoon
	name = "alien cocoon"
	desc = "A large pulsating cocoon."
	icon = 'icons/obj/structures/alien/xenoKingHatchery.dmi'
	icon_state = "static"
	health = 4000
	pixel_x = -48
	pixel_y = -64
	density = TRUE
	plane = FLOOR_PLANE

	/// The mob picked as a candidate to be the King
	var/client/chosen_candidate
	/// The hive associated with this cocoon
	var/hive_number = XENO_HIVE_NORMAL
	/// Whether the cocoon has hatched
	var/hatched = FALSE
	/// Is currently rolling candidates
	var/rolling_candidates = FALSE
	/// Voting for King
	var/list/mob/living/carbon/xenomorph/votes = list()
	/// Candidates
	var/list/mob/living/carbon/xenomorph/candidates = list()
	/// Time to hatch
	var/time_to_hatch = 10 MINUTES
	/// Announced that the hatchery was paused
	var/announced_paused = FALSE
	/// Stage of hatching
	var/stage = 0

/obj/effect/alien/resin/king_cocoon/Destroy()
	if(!hatched)
		marine_announcement("ALERT.\n\nUNUSUAL ENERGY BUILDUP IN [uppertext(get_area_name(loc))] HAS BEEN STOPPED.", "[MAIN_AI_SYSTEM] Biological Scanner", 'sound/misc/notice1.ogg')
		var/datum/hive_status/hive
		for(var/cur_hive_num in GLOB.hive_datum)
			hive = GLOB.hive_datum[cur_hive_num]
			if(!length(hive.totalXenos))
				continue
			if(cur_hive_num == hive_number)
				xeno_announcement(SPAN_XENOANNOUNCE("THE HATCHERY WAS DESTROYED! VENGEANCE!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)
			else
				xeno_announcement(SPAN_XENOANNOUNCE("THE HATCHERY WAS DESTROYED!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)

	var/datum/hive_status/hive = GLOB.hive_datum[hive_number]
	hive.has_hatchery = FALSE
	for(var/obj/effect/alien/resin/special/pylon/pylon as anything in hive.active_endgame_pylons)
		pylon.protection_level = initial(pylon.protection_level)
		pylon.update_icon()

	votes = null
	chosen_candidate = null
	candidates = null

	. = ..()

/obj/effect/alien/resin/king_cocoon/Initialize(mapload, hivenumber)
	. = ..()
	if(hivenumber)
		hive_number = hivenumber

	var/datum/hive_status/hatchery_hive = GLOB.hive_datum[hive_number]
	hatchery_hive.has_hatchery = TRUE
	color = hatchery_hive.color

	for(var/x_offset in -1 to 1)
		for(var/y_offset in -1 to 1)
			var/turf/turf_to_block = locate(x + x_offset, y + y_offset, z)
			var/obj/effect/build_blocker/blocker = new(turf_to_block, src)
			blockers += blocker

	START_PROCESSING(SSobj, src)

	marine_announcement("ALERT.\n\nUNUSUAL ENERGY BUILDUP DETECTED IN [uppertext(get_area_name(loc))].\n\nESTIMATED TIME UNTIL COMPLETION - 10 MINUTES. RECOMMEND TERMINATION OF XENOMORPH STRUCTURE AT THIS LOCATION, OR TERMINATION OF XENOMORPH PYLON AT EITHER COMMUNICATIONS RELAY.", "[MAIN_AI_SYSTEM] Biological Scanner", 'sound/misc/notice1.ogg')
	var/datum/hive_status/hive
	for(var/cur_hive_num in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_hive_num]
		if(!length(hive.totalXenos))
			continue
		if(cur_hive_num == hive_number)
			xeno_announcement(SPAN_XENOANNOUNCE("The King is growing at [get_area_name(loc)]. Protect it, as well as our pylons at their communications relays, at all costs!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)
		else
			xeno_announcement(SPAN_XENOANNOUNCE("Another hive's King is growing at [get_area_name(loc)]."), cur_hive_num, XENO_GENERAL_ANNOUNCE)


#define STAGE_GROWING 1
#define STAGE_HALFWAY 2
#define STAGE_VOTE 3
#define STAGE_PICK 4
#define STAGE_BEFORE_HATCH 5
#define STAGE_HATCH 6

/obj/effect/alien/resin/king_cocoon/process(delta_time)
	var/datum/hive_status/hive = GLOB.hive_datum[hive_number]

	if(length(hive.active_endgame_pylons) < 2)
		if(!announced_paused)
			marine_announcement("ALERT.\n\nUNUSUAL ENERGY BUILDUP IN [uppertext(get_area_name(loc))] HAS BEEN PAUSED.", "[MAIN_AI_SYSTEM] Biological Scanner", 'sound/misc/notice1.ogg')
			for(var/cur_hive_num in GLOB.hive_datum)
				hive = GLOB.hive_datum[cur_hive_num]
				if(!length(hive.totalXenos))
					continue
				if(cur_hive_num == hive_number)
					xeno_announcement(SPAN_XENOANNOUNCE("One of our pylons was destroyed, the hatchery has paused its progress!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)
				else
					xeno_announcement(SPAN_XENOANNOUNCE("One of another hive's pylons was destroyed, the hatchery has paused its progress!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)

			announced_paused = TRUE
			icon_state = "static"
		return
	else if (length(hive.active_endgame_pylons) >= 2 && announced_paused)
		for(var/cur_hive_num in GLOB.hive_datum)
			hive = GLOB.hive_datum[cur_hive_num]
			if(!length(hive.totalXenos))
				continue
			if(cur_hive_num == hive_number)
				xeno_announcement(SPAN_XENOANNOUNCE("The hatchery's progress has resumed!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)
			else
				xeno_announcement(SPAN_XENOANNOUNCE("Another hive's hatchery progress has resumed!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)
		marine_announcement("ALERT.\n\nUNUSUAL ENERGY BUILDUP IN [uppertext(get_area_name(loc))] HAS BEEN RESUMED.", "[MAIN_AI_SYSTEM] Biological Scanner", 'sound/misc/notice1.ogg')
		announced_paused = FALSE
		icon_state = "growing"

		for(var/obj/effect/alien/resin/special/pylon/pylon as anything in hive.active_endgame_pylons)
			pylon.protection_level = TURF_PROTECTION_OB
			pylon.update_icon()
		
	if(hatched)
		STOP_PROCESSING(SSobj, src)
		return

	var/groundside_humans = 0
	for(var/mob/living/carbon/human/current_human as anything in GLOB.alive_human_list)
		if(!(isspecieshuman(current_human) || isspeciessynth(current_human)))
			continue

		var/turf/turf = get_turf(current_human)
		if(is_ground_level(turf?.z))
			groundside_humans += 1

			if(groundside_humans > 12)
				break

	if(groundside_humans < 12)
		// Too few marines are now groundside, hatch immediately
		start_vote()
		addtimer(CALLBACK(src, PROC_REF(roll_candidates)), 20 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(start_hatching), TRUE), 25 SECONDS)
		STOP_PROCESSING(SSobj, src)
		return

	time_to_hatch -= delta_time SECONDS

	if(!stage && time_to_hatch < 10 MINUTES)
		icon_state = "growing"
		stage = STAGE_GROWING
	else if (stage == STAGE_GROWING && time_to_hatch <= 5 MINUTES)
		announce_halfway()
		stage = STAGE_HALFWAY
	else if (stage == STAGE_HALFWAY && time_to_hatch <= 1 MINUTES)
		start_vote()
		stage = STAGE_VOTE
	else if (stage == STAGE_VOTE && time_to_hatch <= 40 SECONDS)
		roll_candidates()
		stage = STAGE_PICK
	else if (stage == STAGE_PICK && time_to_hatch <= 20 SECONDS)
		start_hatching()
		stage = STAGE_BEFORE_HATCH
	else if (stage == STAGE_BEFORE_HATCH && time_to_hatch <= 0)
		animate_hatch_king()
		STOP_PROCESSING(SSobj, src)

#undef STAGE_GROWING
#undef STAGE_HALFWAY
#undef STAGE_VOTE
#undef STAGE_PICK
#undef STAGE_BEFORE_HATCH
#undef STAGE_HATCH

/// Causes the halfway announcements and initiates the next timer.
/obj/effect/alien/resin/king_cocoon/proc/announce_halfway()
	marine_announcement("ALERT.\n\nUNUSUAL ENERGY BUILDUP DETECTED IN [uppertext(get_area_name(loc))].\n\nESTIMATED TIME UNTIL COMPLETION - 5 MINUTES. RECOMMEND TERMINATION OF XENOMORPH STRUCTURE AT THIS LOCATION, OR TERMINATION OF XENOMORPH PYLON AT EITHER COMMUNICATIONS RELAY.", "[MAIN_AI_SYSTEM] Biological Scanner", 'sound/misc/notice1.ogg')
	var/datum/hive_status/hive
	for(var/cur_hive_num in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_hive_num]
		if(!length(hive.totalXenos))
			continue
		if(cur_hive_num == hive_number)
			xeno_announcement(SPAN_XENOANNOUNCE("The King will hatch in approximately 5 minutes."), cur_hive_num, XENO_GENERAL_ANNOUNCE)
		else
			xeno_announcement(SPAN_XENOANNOUNCE("Another hive's King will hatch in approximately 5 minutes."), cur_hive_num, XENO_GENERAL_ANNOUNCE)

#define KING_PLAYTIME_HOURS (50 HOURS)

/**
 * Returns TRUE is the candidate passed is valid: Returns TRUE is the candidate passed is valid: Has client, not facehugger, not lesser drone, not banished, and conditionally on playtime.
 *
 * Arguments:
 * * hive: The hive_status to check banished ckeys against
 * * candidate: The mob that we want to check
 * * playtime_restricted: Determines whether being below KING_PLAYTIME_HOURS makes the candidate invalid
 * * skip_playtime: Determines whether being above KING_PLAYTIME_HOURS makes the candidate invalid (does nothing unless playtime_restricted is FALSE)
 */
/obj/effect/alien/resin/king_cocoon/proc/is_candidate_valid(datum/hive_status/hive, mob/candidate, playtime_restricted = TRUE, skip_playtime = TRUE)
	if(!candidate?.client)
		return FALSE
	if(isfacehugger(candidate) || islesserdrone(candidate))
		return FALSE
	if(playtime_restricted)
		if(candidate.client.get_total_xeno_playtime() < KING_PLAYTIME_HOURS)
			return FALSE
	else if(candidate.client.get_total_xeno_playtime() >= KING_PLAYTIME_HOURS && skip_playtime)
		return FALSE // We do this under the assumption we tried it the other way already so don't ask twice
	for(var/mob_name in hive.banished_ckeys)
		if(hive.banished_ckeys[mob_name] == candidate.ckey)
			return FALSE
	return TRUE

/**
 * Returns TRUE if a valid candidate accepts a TGUI alert asking them to be King.
 *
 * Arguments:
 * * hive: The hive_status to check banished ckeys against
 * * candidate: The mob that we want to ask
 * * playtime_restricted: Determines whether being below KING_PLAYTIME_HOURS makes the candidate invalid (otherwise above)
 */
/obj/effect/alien/resin/king_cocoon/proc/try_roll_candidate(datum/hive_status/hive, mob/candidate, playtime_restricted = TRUE)
	if(!is_candidate_valid(hive, candidate, playtime_restricted))
		return FALSE

	if(!candidate.client)
		return FALSE
	
	return candidate.client.prefs.be_special & BE_KING

#undef KING_PLAYTIME_HOURS

/**
 * Tallies up votes by asking the passed candidate who they wish to vote for King.
 *
 * Arguments:
 * * candidate: The mob that was want to ask
 * * voting_candidates: A list of xenomorph mobs that are candidates
 */
/obj/effect/alien/resin/king_cocoon/proc/cast_vote(mob/candidate, list/mob/living/carbon/xenomorph/voting_candidates)
	var/mob/living/carbon/xenomorph/choice = tgui_input_list(candidate, "Vote for a sister you wish to become the King.", "Choose a xeno", voting_candidates , 20 SECONDS)

	if(votes[choice])
		votes[choice] += 1
	else
		votes[choice] = 1

/// Initiates a vote that will end in 20 seconds to vote for the King. Hatching will then begin in 1 minute unless expedited.
/obj/effect/alien/resin/king_cocoon/proc/start_vote()
	rolling_candidates = TRUE
	var/datum/hive_status/hive = GLOB.hive_datum[hive_number]

	var/list/mob/living/carbon/xenomorph/voting_candidates = hive.totalXenos.Copy() - hive.living_xeno_queen

	for(var/mob/living/carbon/xenomorph/voting_candidate in voting_candidates)
		if(!is_candidate_valid(hive, voting_candidate))
			voting_candidates -= voting_candidate

	for(var/mob/living/carbon/xenomorph/candidate in hive.totalXenos)
		if(is_candidate_valid(hive, candidate, playtime_restricted = FALSE, skip_playtime = FALSE))
			INVOKE_ASYNC(src, PROC_REF(cast_vote), candidate, voting_candidates)

	candidates = voting_candidates


/**
 * Finalizes the vote for King opting to use a series of fallbacks in case a candidate declines.
 *
 * First is a vote where the first and or second top picked is asked.
 * Then all other living xenos meeting the playtime requirement are asked.
 * Then all xeno observer candidates meeting the playtime requirement are asked.
 * Then all other living xenos not meeting the playtime requirement are asked.
 * Then all other xeno observer candidates not meeting the playtime requirement are asked.
 * Then finally if after all that, the search is given up and will ultimately result in a freed King mob.
 */
/obj/effect/alien/resin/king_cocoon/proc/roll_candidates()
	var/datum/hive_status/hive = GLOB.hive_datum[hive_number]

	var/primary_votes = 0
	var/mob/living/carbon/xenomorph/primary_candidate
	var/secondary_votes = 0
	var/mob/living/carbon/xenomorph/secondary_candidate

	for(var/mob/living/carbon/xenomorph/candidate in votes)
		if(votes[candidate] > primary_votes)
			primary_votes = votes[candidate]
			primary_candidate = candidate
		else if(votes[candidate] > secondary_votes)
			secondary_votes = votes[candidate]
			secondary_candidate = candidate

	votes.Cut()

	if(prob(50) && try_roll_candidate(hive, primary_candidate, playtime_restricted = TRUE))
		chosen_candidate = primary_candidate.client
		rolling_candidates = FALSE
		return

	candidates -= primary_candidate


	if(try_roll_candidate(hive, secondary_candidate, playtime_restricted = TRUE))
		chosen_candidate = secondary_candidate.client
		rolling_candidates = FALSE
		return

	candidates -= secondary_candidate

	// Otherwise ask all the living xenos (minus the player(s) who got voted on earlier)
	for(var/mob/living/carbon/xenomorph/candidate in shuffle(candidates))
		if(try_roll_candidate(hive, candidate, playtime_restricted = TRUE))
			chosen_candidate = candidate.client
			rolling_candidates = FALSE
			return

	// Then observers
	var/list/observer_list_copy = shuffle(get_alien_candidates(hive))

	for(var/mob/candidate in observer_list_copy)
		if(try_roll_candidate(hive, candidate, playtime_restricted = TRUE))
			chosen_candidate = candidate.client
			rolling_candidates = FALSE
			return

	// Lastly all of the above again, without playtime requirements
	for(var/mob/living/carbon/xenomorph/candidate in shuffle(hive.totalXenos.Copy() - hive.living_xeno_queen))
		if(try_roll_candidate(hive, candidate, playtime_restricted = FALSE))
			chosen_candidate = candidate.client
			rolling_candidates = FALSE
			return

	for(var/mob/candidate in observer_list_copy)
		if(try_roll_candidate(hive, candidate, playtime_restricted = FALSE))
			chosen_candidate = candidate.client
			rolling_candidates = FALSE
			return
	message_admins("Failed to find a client for the King, releasing as freed mob.")
	

/// Starts the hatching in twenty seconds, otherwise immediately if expedited
/obj/effect/alien/resin/king_cocoon/proc/start_hatching(expedite = FALSE)
	votes = null
	candidates = null
	if(expedite)
		animate_hatch_king()
		return

	marine_announcement("ALERT.\n\nUNUSUAL ENERGY BUILDUP DETECTED IN [get_area_name(loc)].\n\nESTIMATED TIME UNTIL COMPLETION - 20 SECONDS. RECOMMEND TERMINATION OF XENOMORPH STRUCTURE AT THIS LOCATION, OR TERMINATION OF XENOMORPH PYLON AT EITHER COMMUNICATIONS RELAY.", "[MAIN_AI_SYSTEM] Biological Scanner", 'sound/misc/notice1.ogg')
	var/datum/hive_status/hive
	for(var/cur_hive_num in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_hive_num]
		if(!length(hive.totalXenos))
			continue
		if(cur_hive_num == hive_number)
			xeno_announcement(SPAN_XENOANNOUNCE("The King will hatch in approximately twenty seconds."), cur_hive_num, XENO_GENERAL_ANNOUNCE)
		else
			xeno_announcement(SPAN_XENOANNOUNCE("Another hive's King will hatch in approximately twenty seconds."), cur_hive_num, XENO_GENERAL_ANNOUNCE)

/// Causes the cocoon to change visually for hatching and initiates the next timer.
/obj/effect/alien/resin/king_cocoon/proc/animate_hatch_king()
	flick("hatching", src)
	addtimer(CALLBACK(src, PROC_REF(hatch_king)), 2 SECONDS, TIMER_UNIQUE|TIMER_STOPPABLE)

	marine_announcement("ALERT.\n\nEXTREME ENERGY INFLUX DETECTED IN [get_area_name(loc)].\n\nCAUTION IS ADVISED.", "[MAIN_AI_SYSTEM] Biological Scanner", 'sound/misc/notice1.ogg')
	var/datum/hive_status/hive
	for(var/cur_hive_num in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_hive_num]
		if(!length(hive.totalXenos))
			continue
		if(cur_hive_num == hive_number)
			xeno_announcement(SPAN_XENOANNOUNCE("All hail the King."), cur_hive_num, XENO_GENERAL_ANNOUNCE)
		else
			xeno_announcement(SPAN_XENOANNOUNCE("Another hive's King has hatched!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)

/// Actually hatches the King transferring the candidate into the spawned mob and initiates the next timer.
/obj/effect/alien/resin/king_cocoon/proc/hatch_king()
	icon_state = "hatched"
	hatched = TRUE

	QDEL_LIST(blockers)

	var/mob/living/carbon/xenomorph/king/king = new(get_turf(src), null, hive_number)
	if(chosen_candidate?.mob)
		var/mob/old_mob = chosen_candidate.mob
		old_mob.mind.transfer_to(king)

		if(isliving(old_mob) && old_mob.stat != DEAD)
			old_mob.free_for_ghosts(TRUE)
	else
		king.free_for_ghosts(TRUE)
	playsound(src, 'sound/voice/alien_queen_command.ogg', 75, 0)

	chosen_candidate = null

	// Gives some time for the King to get their barings before it can be OBed
	addtimer(CALLBACK(src, PROC_REF(remove_ob_protection)), 1 MINUTES, TIMER_UNIQUE|TIMER_STOPPABLE|TIMER_DELETE_ME)

/// The final step in the cocoon sequence: Resets pylon protection levels
/obj/effect/alien/resin/king_cocoon/proc/remove_ob_protection()
	var/datum/hive_status/hive = GLOB.hive_datum[hive_number]
	for(var/obj/effect/alien/resin/special/pylon/pylon as anything in hive.active_endgame_pylons)
		pylon.protection_level = initial(pylon.protection_level)
		pylon.update_icon()

/obj/effect/alien/resin/king_cocoon/attack_alien(mob/living/carbon/xenomorph/attacking_alien)
	if(attacking_alien.can_destroy_special() || hatched)
		return	..()

	return XENO_NO_DELAY_ACTION

/obj/item/explosive/grenade/alien
	name = "alien grenade"
	desc = "an alien grenade."
	icon_state = "neuro_nade_greyscale"
	item_state = "neuro_nade_greyscale"

	antigrief_protection = FALSE

	dangerous = TRUE
	rebounds = FALSE
	throw_speed = SPEED_SLOW
	throw_range = 4

	arm_sound = 'sound/effects/blobattack.ogg'
	var/xeno_throw_time = 1 SECONDS

	var/can_prime = FALSE

	var/hivenumber = XENO_HIVE_NORMAL

/obj/item/explosive/grenade/alien/Initialize(mapload, hivenumber)
	. = ..()
	src.hivenumber = hivenumber

/obj/item/explosive/grenade/alien/try_to_throw(mob/living/user)
	if(isxeno(user))
		to_chat(user, SPAN_NOTICE("You prepare to throw [src]."))
		if(!do_after(user, xeno_throw_time, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
			return FALSE
		activate(user)
		return TRUE

/obj/item/explosive/grenade/alien/can_use_grenade(mob/user)
	if(!isxeno(user))
		to_chat(user, SPAN_WARNING("You don't know how to activate this!"))
		return FALSE

	to_chat(user, SPAN_XENOWARNING("You need to throw this to activate it!"))
	return FALSE

/obj/item/explosive/grenade/alien/update_icon()
	. = ..()

	icon_state = initial(icon_state)

	if(active)
		var/image/I = image(icon, src, "+neuro_nade_active")
		I.appearance_flags |= RESET_COLOR|KEEP_APART
		overlays += I


/obj/item/explosive/grenade/alien/attack_alien(mob/living/carbon/xenomorph/M)
	if(!active)
		attack_hand(M)
	else
		to_chat(M, SPAN_XENOWARNING("It's about to burst!"))
	return XENO_NO_DELAY_ACTION

/obj/item/explosive/grenade/alien/acid
	name = "acid grenade"
	desc = "Sprays acid projectiles outwards when detonated."

	color = "#00ff00"

	var/range = 3

/obj/item/explosive/grenade/alien/acid/get_projectile_hit_boolean(obj/projectile/P)
	return FALSE

/obj/item/explosive/grenade/alien/acid/prime(force)
	active = FALSE
	var/datum/automata_cell/acid/E = new /datum/automata_cell/acid(get_turf(loc))

	// something went wrong :(
	if(QDELETED(E))
		return

	E.range = range
	E.hivenumber = hivenumber
	E.source = initial(name)
	qdel(src)


/datum/automata_cell/acid
	neighbor_type = NEIGHBORS_NONE

	var/obj/effect/xenomorph/spray/acid_type = /obj/effect/xenomorph/spray/strong/no_stun

	// Which direction is the explosion traveling?
	// Note that this will be null for the epicenter
	var/hivenumber = XENO_HIVE_NORMAL
	var/source
	var/direction = null
	var/range = 0

	var/delay = 2


/datum/automata_cell/acid/proc/get_propagation_dirs()
	. = list()

	// If the cell is the epicenter, propagate in all directions
	if(isnull(direction))
		return GLOB.alldirs

	if(direction in GLOB.cardinals)
		. += list(direction, turn(direction, 45), turn(direction, -45))
	else
		. += direction

/datum/automata_cell/acid/update_state(list/turf/neighbors)
	if(delay > 0)
		delay--
		return

	var/atom/temp = new acid_type()

	if(LinkBlocked(temp, get_step(in_turf, turn(direction, 180)), in_turf))
		QDEL_NULL(temp)
		qdel(src)
		return
	QDEL_NULL(temp)

	new acid_type(in_turf, create_cause_data(source), hivenumber)

	// Range has been reached
	if(range <= 0)
		qdel(src)
		return

	// Propagate the explosion
	var/list/to_spread = get_propagation_dirs()
	for(var/dir in to_spread)
		var/datum/automata_cell/acid/E = propagate(dir)
		if(E)
			E.range = range - 1
			// Set the direction the explosion is traveling in
			E.direction = dir

			if(dir in GLOB.diagonals)
				E.range--

			switch(E.range)
				if(-INFINITY to 0)
					E.acid_type = /obj/effect/xenomorph/spray/weak
				if(1)
					E.acid_type = /obj/effect/xenomorph/spray/no_stun
				if(2 to INFINITY)
					E.acid_type = /obj/effect/xenomorph/spray/strong/no_stun

			E.hivenumber = hivenumber
			E.source = source

	// We've done our duty, now die pls
	qdel(src)
