/obj/structure/droppod/container
	density = FALSE

	open_sound = 'sound/machines/techpod/techpod_toggle.ogg'
	close_sound = 'sound/machines/techpod/techpod_toggle.ogg'

	land_layer = BELOW_OBJ_LAYER

	var/can_be_opened = TRUE

	var/gib_on_land = FALSE
	var/stealth = FALSE

	land_damage = 0

	var/land_exp_power = 0
	var/land_exp_falloff = 75

	var/max_hold_items = 30
	var/max_mob_size = MOB_SIZE_IMMOBILE

	var/reverse_delays = list(
		"drop_time" = 0,
		"dropping_time" = 2 SECONDS,
		"open_time" = 2 SECONDS
	)
	var/return_time = 30 SECONDS

	var/should_recall = FALSE
	var/turf/dropoff_point

/obj/structure/droppod/container/post_land()
	explo_proof = TRUE
	for(var/object in loc)
		if(object == src)
			continue

		if(isobj(object))
			var/obj/O = object
			O.update_health(land_damage)
		else if(isliving(object))
			var/mob/living/M = object
			if(gib_on_land)
				M.gib(create_cause_data("[src]", null))
			else
				M.apply_damage(land_damage, BRUTE)

	if(land_exp_power)
		cell_explosion(loc, land_exp_power, land_exp_falloff, create_cause_data("[src]"))

	if(should_recall)
		addtimer(CALLBACK(src, PROC_REF(recall)), return_time)

	addtimer(CALLBACK(src, PROC_REF(open)), open_time)
	explo_proof = FALSE

/obj/structure/droppod/container/warn_turf(turf/T)
	if(!stealth)
		return ..()

/obj/structure/droppod/container/relaymove(mob/user)
	if(!isturf(loc)\
		|| !(droppod_flags & DROPPOD_DROPPED)\
		|| user.is_mob_incapacitated(TRUE)\
		|| !can_be_opened)
		return
	user.next_move = world.time + 5

	open(user)


/obj/structure/droppod/container/attackby(obj/item/W, mob/user)
	if(droppod_flags & DROPPOD_OPEN)
		if(istype(W, /obj/item/grab))
			if(isxeno(user))
				return
			var/obj/item/grab/G = W
			if(G.grabbed_thing)
				src.MouseDrop_T(G.grabbed_thing, user)   //act like they were dragged onto the closet
			return

		if(W.flags_item & ITEM_ABSTRACT)
			return

		user.drop_inv_item_to_loc(W, loc)
	else
		return ..()

/obj/structure/droppod/container/post_recall()
	if(!dropoff_point)
		return ..()
	else
		drop_time = reverse_delays["drop_time"]
		dropping_time = reverse_delays["dropping_time"]
		open_time = reverse_delays["open_time"]
		should_recall = FALSE
		launch(dropoff_point)
		dropoff_point = null


/obj/structure/droppod/container/attack_alien(mob/living/carbon/xenomorph/M)
	if(!(droppod_flags & DROPPOD_DROPPED) || !can_be_opened || (droppod_flags & DROPPOD_OPEN))
		return

	M.animation_attack_on(src)

	to_chat(M, SPAN_XENONOTICE("You slash open [src]!"))
	open(M)
	return XENO_ATTACK_ACTION

/obj/structure/droppod/container/attack_hand(mob/user)
	if(!can_be_opened || !(droppod_flags & DROPPOD_DROPPED))
		return

	if(droppod_flags & DROPPOD_OPEN)
		close(user)
	else
		open(user)

/obj/structure/droppod/container/open(mob/user)
	. = ..()
	for(var/a in contents)
		var/atom/movable/A = a
		A.forceMove(loc)

/obj/structure/droppod/container/close(mob/user)
	. = ..()
	if(loc)
		collect_objects(loc.contents)
	set_density(TRUE)

/obj/structure/droppod/container/proc/collect_objects(list/L)
	for(var/atom/movable/A in L)
		if(A == src)
			continue

		if(length(contents) >= max_hold_items)
			break

		if(ismob(A))
			var/mob/M = A
			if(M.mob_size > max_mob_size)
				continue

		if(!A.anchored)
			A.forceMove(src)

/obj/structure/droppod/container/deconstruct()
	for(var/i in contents)
		var/atom/movable/A = i
		A.forceMove(loc)
	return ..()

/obj/structure/droppod/container/ex_act(severity, direction)
	if(!explo_proof)
		return ..()


/obj/structure/droppod/container/handle_debris(severity, direction)
	for(var/i in contents)
		var/atom/movable/A = i
		A.forceMove(loc)
		A.ex_act(severity)
	return ..()

/obj/structure/droppod/container/Destroy()
	QDEL_NULL_LIST(contents)
	return ..()
