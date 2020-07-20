/obj/structure/grille
	desc = "A flimsy lattice of metal rods, with screws to secure it to the floor."
	name = "grille"
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "grille"
	density = 1
	anchored = 1
	debris = list(/obj/item/stack/rods)
	flags_atom = FPRINT|CONDUCT
	layer = OBJ_LAYER
	health = 10
	var/destroyed = 0

/obj/structure/grille/initialize_pass_flags()
	..()
	flags_can_pass_all = SETUP_LIST_FLAGS(PASS_THROUGH, PASS_BUILDING_ONLY)

/obj/structure/grille/fence/
	var/width = 3
	health = 50

/obj/structure/grille/fence/New()
	..()

	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size


/obj/structure/grille/fence/east_west
	//width=80
	//height=42
	icon='icons/obj/structures/props/fence_ew.dmi'
	icon_state = "fence-ew"
	dir = 4

/obj/structure/grille/fence/north_south
	//width=80
	//height=42
	icon='icons/obj/structures/props/fence_ns.dmi'
	icon_state = "fence-ns"

/obj/structure/grille/fence/healthcheck()
	if(health <= 0)
		density = 0
		destroyed = 1
		handle_debris()
		qdel(src)
	return

/obj/structure/grille/ex_act(severity,direction)
	handle_debris(severity, direction)
	qdel(src)

/obj/structure/grille/Collided(atom/user)
	if(ismob(user)) shock(user, 70)

/obj/structure/grille/attack_hand(mob/user as mob)

	playsound(loc, 'sound/effects/grillehit.ogg', 25, 1)

	var/damage_dealt
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			damage_dealt = 5
			user.visible_message(SPAN_WARNING("[user] mangles [src]."), \
					 SPAN_WARNING("You mangle [src]."), \
					 "You hear twisting metal.")

	if(!damage_dealt)
		user.visible_message(SPAN_WARNING("[user] kicks [src]."), \
						 SPAN_WARNING("You kick [src]."), \
						 "You hear twisting metal.")

	if(shock(user, 70))
		return

	damage_dealt += 1

	health -= damage_dealt
	healthcheck()


/obj/structure/grille/attack_animal(var/mob/living/simple_animal/M as mob)
	if(M.melee_damage_upper == 0)	return

	playsound(loc, 'sound/effects/grillehit.ogg', 25, 1)
	M.visible_message(SPAN_WARNING("[M] smashes against [src]."), \
					  SPAN_WARNING("You smash against [src]."), \
					  "You hear twisting metal.")

	health -= M.melee_damage_upper
	healthcheck()
	return


/obj/structure/grille/BlockedPassDirs(atom/movable/mover, target_dir)
	if(istype(mover, /obj/item/projectile) && prob(90))
		return NO_BLOCKED_MOVEMENT

	return ..()

/obj/structure/grille/bullet_act(var/obj/item/projectile/Proj)

	//Tasers and the like should not damage grilles.
	if(Proj.ammo.damage_type == HALLOSS)
		return 0

	src.health -= round(Proj.damage*0.3)
	healthcheck()
	return 1

/obj/structure/grille/attackby(obj/item/W as obj, mob/user as mob)
	if(iswirecutter(W))
		if(!shock(user, 100))
			playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
			handle_debris()
			qdel(src)
	else if(isscrewdriver(W) && istype(loc, /turf/open))
		if(!shock(user, 90))
			playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
			anchored = !anchored
			user.visible_message(SPAN_NOTICE("[user] [anchored ? "fastens" : "unfastens"] the grille."), \
								 SPAN_NOTICE("You have [anchored ? "fastened the grille to" : "unfastened the grill from"] the floor."))
			return

//window placing begin
	else if(istype(W,/obj/item/stack/sheet/glass))
		var/obj/item/stack/sheet/glass/ST = W
		var/dir_to_set = 1
		if(loc == user.loc)
			dir_to_set = user.dir
		else
			if( ( x == user.x ) || (y == user.y) ) //Only supposed to work for cardinal directions.
				if( x == user.x )
					if( y > user.y )
						dir_to_set = 2
					else
						dir_to_set = 1
				else if( y == user.y )
					if( x > user.x )
						dir_to_set = 8
					else
						dir_to_set = 4
			else
				to_chat(user, SPAN_NOTICE("You can't reach."))
				return //Only works for cardinal direcitons, diagonals aren't supposed to work like this.
		for(var/obj/structure/window/WINDOW in loc)
			if(WINDOW.dir == dir_to_set)
				to_chat(user, SPAN_NOTICE("There is already a window facing this way there."))
				return
		to_chat(user, SPAN_NOTICE("You start placing the window."))
		if(do_after(user,20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			for(var/obj/structure/window/WINDOW in loc)
				if(WINDOW.dir == dir_to_set)//checking this for a 2nd time to check if a window was made while we were waiting.
					to_chat(user, SPAN_NOTICE("There is already a window facing this way there."))
					return

			var/wtype = ST.created_window
			if (ST.use(1))
				var/obj/structure/window/WD = new wtype(loc)
				WD.set_constructed_window(dir_to_set)
				to_chat(user, SPAN_NOTICE("You place the [WD] on [src]."))
		return
//window placing end

	else if(istype(W, /obj/item/shard))
		health -= W.force * 0.1
	else if(!shock(user, 70))
		playsound(loc, 'sound/effects/grillehit.ogg', 25, 1)
		switch(W.damtype)
			if("fire")
				health -= W.force
			if("brute")
				health -= W.force * 0.1
	healthcheck()
	..()
	return


/obj/structure/grille/proc/healthcheck()
	if(health <= 0)
		if(!destroyed)
			icon_state = "brokengrille"
			density = 0
			destroyed = 1
			handle_debris()

		else
			if(health <= -6)
				handle_debris()
				qdel(src)
				return
	return

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise

/obj/structure/grille/proc/shock(mob/user as mob, prb)

	if(!anchored || destroyed)		// anchored/destroyed grilles are never connected
		return 0
	if(!prob(prb))
		return 0
	if(!in_range(src, user))//To prevent TK and mech users from getting shocked
		return 0
	var/turf/T = get_turf(src)
	var/obj/structure/cable/C = T.get_cable_node()
	if(C)
		if(electrocute_mob(user, C, src))
			var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			return 1
		else
			return 0
	return 0

/obj/structure/grille/fire_act(exposed_temperature, exposed_volume)
	if(!destroyed)
		if(exposed_temperature > T0C + 1500)
			health -= 1
			healthcheck()
	..()