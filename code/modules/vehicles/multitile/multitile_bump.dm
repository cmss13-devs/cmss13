//TODO: Cakey, please trim this hot garbage.
//Tramplin' time, but other than that identical
/obj/vehicle/multitile/Collide(var/atom/A)
	. = ..()

	if(isliving(A))
		return handle_living_collide(A)
		
	// Attempt to open doors before crushing them
	if(istype(A, /obj/structure/machinery/door))
		var/obj/structure/machinery/door/D = A
		// Check if we can even fit through first
		var/list/vehicle_dimensions = get_dimensions()
		// The door should be facing east/west when the tank is facing north/south, and north/south when the tank is facing east/west
		// The door must also be wide enough for the vehicle to fit inside
		if(((dir & (NORTH|SOUTH) && D.dir & (EAST|WEST)) || (dir & (EAST|WEST) && D.dir & (NORTH|SOUTH))) && D.width >= vehicle_dimensions["width"])
			// Driver needs access
			var/mob/living/driver = get_seat_mob(VEHICLE_DRIVER)
			if(!D.requiresID() || (driver && D.allowed(driver)))
				D.open()
				return FALSE

	if(istype(A, /obj/structure/barricade/plasteel))
		var/obj/structure/barricade/plasteel/cade = A
		cade.close(cade)

	else if(istype(A, /obj/structure/barricade/deployable))
		var/obj/structure/barricade/deployable/cade = A

		visible_message(SPAN_DANGER("[src] crushes [cade]!"))
		playsound(cade, 'sound/effects/metal_crash.ogg', 35)
		cade.collapse()
		return FALSE

	else if(istype(A, /obj/structure/machinery/cm_vending))
		var/obj/structure/machinery/cm_vending/O = A

		visible_message(SPAN_DANGER("[src] pushes [O] over!"))
		playsound(O, 'sound/effects/metal_crash.ogg', 35)
		O.tip_over()

	else if(isobj(A) && !istype(A, /obj/vehicle))
		var/obj/O = A
		if(O.unacidable)
			return FALSE

		take_damage_type(5, "blunt", O)
		visible_message(SPAN_DANGER("[src] crushes [O]!"))
		playsound(O, 'sound/effects/metal_crash.ogg', 35)
		qdel(O)

	else if(istype(A, /obj/vehicle/multitile))	//we check multitile first, then other vehicles
		var/obj/vehicle/multitile/V = A
		var/damage

		if(last_move_dir == REVERSE_DIR(V.last_move_dir))	//crashing into each other
			damage = momentum + V.momentum
		else if(last_move_dir == V.last_move_dir)	//crashing into something from behind
			damage = max(momentum - V.momentum, 0)
		else
			damage = momentum

		damage = 5 * (damage + 1)	//5 is minimal damage of bumping which is multiplied on vehicles' current momentum. +1 to prevent reduction
		take_damage_type(damage, "blunt", V)
		V.take_damage_type(damage, "blunt", src)

		visible_message(SPAN_DANGER("[src] crushes into [V]!"))
		playsound(V, 'sound/effects/metal_crash.ogg', 35)
		return FALSE

	else if(istype(A, /obj/vehicle))
		var/obj/vehicle/V = A

		take_damage_type(5, "blunt", V)
		V.health = V.health - Ceiling(V.maxhealth/3)	//we destroy any simple vehicle in 3 crushes
		V.healthcheck()

		visible_message(SPAN_DANGER("[src] crushes into [V]!"))
		playsound(V, 'sound/effects/metal_crash.ogg', 35)
		return FALSE

	else if(istype(A, /turf/closed/wall))
		var/turf/closed/wall/W = A
		if(W.hull)
			return FALSE

		W.take_damage(30)
		take_damage_type(10, "blunt", W)
		playsound(W, 'sound/effects/metal_crash.ogg', 35)
		return FALSE

	return TRUE

// Crushers going top speed can charge into & move frame broken vehicles
/obj/vehicle/multitile/Collided(var/atom/A)
	. = ..()

	if(isXenoCrusher(A) && health <= 0)
		var/mob/living/carbon/Xenomorph/Crusher/C = A
		if(!C.throwing)
			return

		try_move(C.dir, force=TRUE)
		playsound(loc, 'sound/effects/metal_crash.ogg', 35)
		visible_message(SPAN_DANGER("The sheer force of the impact makes \the [src] slide back!"))

/obj/vehicle/multitile/proc/handle_living_collide(var/mob/living/L)
	if(L.is_mob_incapacitated(1))
		L.apply_damage(7 + rand(0, 5), BRUTE)
		return TRUE

	var/is_knocked_down = TRUE
	var/takes_damage = TRUE

	if(isXeno(L))
		var/mob/living/carbon/Xenomorph/X = L
		var/blocked = FALSE
		if((isXenoCrusher(X) || isXenoQueen(X)) && !X.is_mob_incapacitated() && !X.buckled)
			// Check what dir they should be facing to be looking directly at the vehicle
			var/dir_between = get_dir(X, src)
			if(dir_between == X.dir) // front hit (facing the vehicle)
				blocked = TRUE
			else if(dir_between == reverse_dir[X.dir]) // rear hit (facing directly away from the vehicle)
				is_knocked_down = FALSE
			else // side hit
				takes_damage = FALSE
				is_knocked_down = FALSE

		if(isXenoBurrower(X))
			if(X.burrow)
				takes_damage = FALSE
				is_knocked_down = FALSE

		if (isXenoDefender(X))
			if (X.fortify)
				blocked = TRUE

		if(blocked)
			X.visible_message(SPAN_DANGER("[X] digs it's claws into the ground, standing it's ground, halting [src] in it's tracks!"),
			SPAN_DANGER("You dig your claws into the ground, stopping [src] in it's tracks!"))

			return FALSE

		if(takes_damage)
			// This could 100% be coded as max(VEHICLE_TRAMPLE_DAMAGE_MIN, 22.5-4.5*X.tier) but I think this is more readable, plus it lets me avoid a special case for Queen/Larva/Abom.
			var/damage_percentage = VEHICLE_TRAMPLE_DAMAGE_SPECIAL // Queen and abomb
			switch (X.tier)
				if (1)
					damage_percentage = VEHICLE_TRAMPLE_DAMAGE_TIER_1 // 2.5 * 9 = 22.5
				if (2)
					damage_percentage = VEHICLE_TRAMPLE_DAMAGE_TIER_2 // 18%
				if (3)
					damage_percentage = VEHICLE_TRAMPLE_DAMAGE_TIER_3 // 13.5%

			//This is a temporary solution for trampling nerf for APC,
			//trampling refactor coming soon where this will be done properly
			//APC deals 0.5 of damage
			if(istype(src, /obj/vehicle/multitile/apc))
				damage_percentage *= VEHICLE_TRAMPLE_DAMAGE_APC_REDUCTION

			damage_percentage -= round((X.armor_deflection*(X.armor_integrity/100)) / VEHICLE_TRAMPLE_DAMAGE_REDUCTION_ARMOR_MULT) // Ravager reduces percentage by ~50% by virtue of having very high armor.

			if(locate(/obj/item/hardpoint/support/overdrive_enhancer) in src)
				damage_percentage += VEHICLE_TRAMPLE_DAMAGE_OVERDRIVE_BUFF

			damage_percentage = max(VEHICLE_TRAMPLE_DAMAGE_OVERDRIVE_BUFF, max(0, damage_percentage))
			damage_percentage = max(damage_percentage, VEHICLE_TRAMPLE_DAMAGE_MIN)

			X.apply_damage(round((X.maxHealth / 100) * damage_percentage), BRUTE)
		
	else
		if(is_knocked_down)
			L.KnockDown(3, 1)

		if(takes_damage)
			L.apply_damage(7 + rand(0, 5), BRUTE)

	var/mob_moved = FALSE
	var/mob_knocked_down = L.is_mob_incapacitated()
	if(!mob_knocked_down)
		mob_moved = step(L, last_move_dir)

	playsound(loc, "punch", 25, 1)
	L.last_damage_mob = seats[VEHICLE_DRIVER]
	L.last_damage_source = "[initial(name)] roadkill"
	L.visible_message(SPAN_DANGER("[src] rams [L]!"), SPAN_DANGER("[src] rams you! Get out of the way!"))

	var/list/slots = get_activatable_hardpoints()
	for(var/slot in slots)
		var/obj/item/hardpoint/H = hardpoints[slot]
		if(!H) continue
		H.livingmob_interact(L)

	// If the mob is knocked down or was pushed away from the APC (aka have actual space to move), allow movement in desired direction
	if(mob_knocked_down)
		return TRUE
	else if (mob_moved && L.last_move_dir & last_move_dir)
		// Big xenos shouldn't be pushed at mach 10 by the APC for a long time
		if(L.mob_size >= MOB_SIZE_BIG)
			momentum = Floor(momentum/2)
			update_next_move()
			interior_crash_effect()
		return TRUE
	return FALSE
