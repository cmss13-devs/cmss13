//generic procs copied from obj/effect/alien
/obj/effect/spider
	name = "web"
	desc = "it's stringy and sticky"
	icon = 'icons/effects/effects.dmi'
	anchored = 1
	density = 0
	health = 15

//similar to weeds, but only barfed out by nurses manually
/obj/effect/spider/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(5))
				qdel(src)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(50))
				qdel(src)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)
	return

/obj/effect/spider/attackby(var/obj/item/W, var/mob/user)
	if(W.attack_verb.len)
		visible_message(SPAN_DANGER("<B>\The [src] have been [pick(W.attack_verb)] with \the [W][(user ? "by [user]." : ".")]"))
	else
		visible_message(SPAN_DANGER("<B>\The [src] have been attacked with \the [W][(user ? "by [user]." : ".")]"))

	var/damage = W.force / 4.0

	if(istype(W, /obj/item/tool/weldingtool))
		var/obj/item/tool/weldingtool/WT = W

		if(WT.remove_fuel(0, user))
			damage = 15
			playsound(loc, 'sound/items/Welder.ogg', 25, 1)

	health -= damage
	healthcheck()

/obj/effect/spider/bullet_act(var/obj/item/projectile/Proj)
	..()
	health -= Proj.ammo.damage
	healthcheck()
	return 1

/obj/effect/spider/proc/healthcheck()
	if(health <= 0)
		qdel(src)

/obj/effect/spider/fire_act(exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		health -= 5
		healthcheck()

/obj/effect/spider/stickyweb
	icon_state = "stickyweb1"
	New()
		if(prob(50))
			icon_state = "stickyweb2"

/obj/effect/spider/stickyweb/BlockedPassDirs(atom/movable/mover, target_dir)
	if(istype(mover, /mob/living/simple_animal/hostile/giant_spider))
		return NO_BLOCKED_MOVEMENT
	else if(isliving(mover))
		if(prob(50))
			to_chat(mover, SPAN_WARNING("You get stuck in [src] for a moment."))
			return BLOCKED_MOVEMENT
	else if(istype(mover, /obj/item/projectile))
		if(prob(30))
			return BLOCKED_MOVEMENT
	return NO_BLOCKED_MOVEMENT

/obj/effect/spider/eggcluster
	name = "egg cluster"
	desc = "They seem to pulse slightly with an inner life"
	icon_state = "eggs"
	var/amount_grown = 0
	New()
		pixel_x = rand(3,-3)
		pixel_y = rand(3,-3)
		processing_objects.Add(src)

/obj/effect/spider/eggcluster/process()
	amount_grown += rand(0,2)
	if(amount_grown >= 100)
		var/num = rand(6,24)
		for(var/i=0, i<num, i++)
			new /obj/effect/spider/spiderling(src.loc)
		qdel(src)

/obj/effect/spider/spiderling
	name = "spiderling"
	desc = "It never stays still for long."
	icon_state = "spiderling"
	anchored = 0
	layer = BELOW_TABLE_LAYER
	health = 3
	var/amount_grown = -1
	var/obj/structure/pipes/vents/pump/entry_vent
	var/travelling_in_vent = 0
	New()
		pixel_x = rand(6,-6)
		pixel_y = rand(6,-6)
		processing_objects.Add(src)
		//50% chance to grow up
		if(prob(50))
			amount_grown = 1

/obj/effect/spider/spiderling/Collide(atom/A)
	if(istype(A, /obj/structure/surface/table))
		src.loc = A.loc
	else
		..()

/obj/effect/spider/spiderling/proc/die()
	visible_message(SPAN_ALERT("[src] dies!"))
	new /obj/effect/decal/cleanable/spiderling_remains(src.loc)
	qdel(src)

/obj/effect/spider/spiderling/healthcheck()
	if(health <= 0)
		die()

/obj/effect/spider/spiderling/process()
	//=================
	if(prob(25))
		var/list/nearby = oview(5, src)
		if(nearby.len)
			var/target_atom = pick(nearby)
			walk_to(src, target_atom, 5)
			if(prob(25))
				src.visible_message(SPAN_NOTICE("\the [src] skitters[pick(" away"," around","")]."))
	else if(prob(5))
		//vent crawl!
		for(var/obj/structure/pipes/vents/pump/v in view(7,src))
			if(!v.welded)
				entry_vent = v
				walk_to(src, entry_vent, 5)
				break

	if(prob(1))
		src.visible_message(SPAN_NOTICE("\the [src] chitters."))
	if(isturf(loc) && amount_grown > 0)
		amount_grown += rand(0,2)
		if(amount_grown >= 100)
			var/spawn_type = pick(typesof(/mob/living/simple_animal/hostile/giant_spider))
			new spawn_type(src.loc)
			qdel(src)

/obj/effect/decal/cleanable/spiderling_remains
	name = "spiderling remains"
	desc = "Green squishy mess."
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenshatter"

/obj/effect/spider/cocoon
	name = "cocoon"
	desc = "Something wrapped in silky spider web"
	icon_state = "cocoon1"
	health = 60

	New()
		icon_state = pick("cocoon1","cocoon2","cocoon3")

/obj/effect/spider/cocoon/Dispose()
	visible_message(SPAN_DANGER("[src] splits open."))
	for(var/atom/movable/A in contents)
		A.forceMove(loc)
	. = ..()