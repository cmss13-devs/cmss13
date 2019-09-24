//All the special cases in which the tank can run over things, and what happens.

#define TANK_DAMAGE_TIER_1  22.5
#define TANK_DAMAGE_TIER_2  18.0
#define TANK_DAMAGE_TIER_3  13.5
#define TANK_DAMAGE_SPECIAL 10.0 // Larva, Queen, Abomination, or Xenoborg
#define TANK_DAMAGE_MIN		5.0	 // Minimum is 5% damage from a ram

#define TANK_DAMAGE_OVERDRIVE_BUFF	3			// Overdrive enhancer damage buff
#define TANK_DAMAGE_REDUCTION_ARMOR_MULT 12		// How much we divide our armor by to get the percentage reduction

//Tramplin' time, but other than that identical
/obj/vehicle/multitile/hitbox/cm_armored/Bump(var/atom/A)
	. = ..()

	var/obj/vehicle/multitile/root/cm_armored/CA = root
	if(isliving(A))
		var/mob/living/L = A
		if(L.is_mob_incapacitated(1))
			L.apply_damage(7 + rand(0, 5), BRUTE)
			return

		var/is_knocked_down = 1
		var/takes_damage = 1

		if(isXeno(L))
			var/mob/living/carbon/Xenomorph/X = L
			var/blocked = 0
			if(isXenoCrusher(X) || isXenoQueen(X))
				if (X || !X.is_mob_incapacitated() || !X.buckled)
					if(root.dir == X.dir) // hit from behind
						is_knocked_down = 0
					else if(root.dir == reverse_direction(X.dir)) // front hit
						blocked = 1
					else // side hit
						takes_damage = 0
						is_knocked_down = 0

			if(isXenoBurrower(X))
				if(X.burrow)
					takes_damage = 0
					is_knocked_down = 0
					blocked = 0

			if (isXenoDefender(X))
				if (X.fortify)
					blocked = 1
	
			if(blocked)
				X.visible_message(SPAN_DANGER("[X] digs it's claws into the ground, standing it's ground, halting [src] in it's tracks!"),
				SPAN_DANGER("You dig your claws into the ground, stopping [src] in it's tracks!"))
				return FALSE

			// This could 100% be coded as max(TANK_DAMAGE_MIN, 22.5-4.5*X.tier) but I think this is more readable, plus it lets me avoid a special case for Queen/Larva/Abom.
			var/damage_percentage = TANK_DAMAGE_SPECIAL // Queen and abomb
			switch (X.tier)
				if (1)
					damage_percentage = TANK_DAMAGE_TIER_1 // 2.5 * 9 = 22.5
				if (2)
					damage_percentage = TANK_DAMAGE_TIER_2 // 18%
				if (3)
					damage_percentage = TANK_DAMAGE_TIER_3 // 13.5%

			damage_percentage -= round((X.armor_deflection*(X.armor_integrity/100)) / TANK_DAMAGE_REDUCTION_ARMOR_MULT) // Ravager reduces percentage by ~50% by virtue of having very high armor.

			if (locate(/obj/item/hardpoint/support/overdrive_enhancer) in src)
				damage_percentage += TANK_DAMAGE_OVERDRIVE_BUFF

			damage_percentage = max(TANK_DAMAGE_OVERDRIVE_BUFF, max(0, damage_percentage))
			damage_percentage = max(damage_percentage, TANK_DAMAGE_MIN)
	
			X.adjustBruteLoss(round((X.maxHealth / 100) * damage_percentage))


		else
			if(is_knocked_down)
				L.KnockDown(3, 1)

			if(takes_damage)
				L.apply_damage(7 + rand(0, 5), BRUTE)
		
		if(!L.is_mob_incapacitated())
			step_away(L,src)

		playsound(loc, "punch", 25, 1)
		L.last_damage_mob = driver
		if(root)
			L.last_damage_source = "[initial(root.name)] roadkill"
		else
			L.last_damage_source = "[initial(name)] roadkill"
		L.visible_message(SPAN_DANGER("[src] rams [L]!"), SPAN_DANGER("[src] rams you! Get out of the way!"))

		var/list/slots = CA.get_activatable_hardpoints()
		for(var/slot in slots)
			var/obj/item/hardpoint/H = CA.hardpoints[slot]
			if(!H) continue
			H.livingmob_interact(L)

		return

	// Attempt to open doors before crushing them
	if(istype(A, /obj/structure/machinery/door))
		var/obj/structure/machinery/door/D = A
		// Check if we can even fit through first
		var/list/vehicle_dimensions = root.get_dimensions()
		// The door should be facing east/west when the tank is facing north/south, and north/south when the tank is facing east/west
		// The door must also be wide enough for the vehicle to fit inside
		if( ( (root.dir & (NORTH|SOUTH) && D.dir & (EAST|WEST)) || (root.dir & (EAST|WEST) && D.dir & (NORTH|SOUTH))) && D.width >= vehicle_dimensions["width"])
			// Just one person in the vehicle needs access to open the door
			for(var/mob/living/carbon/human/H in root)
				if(!D.requiresID() || D.allowed(H))
					D.open()
					return

	if(istype(A, /obj/structure/barricade/plasteel))
		var/obj/structure/barricade/plasteel/cade = A
		cade.close(cade)

	else if(istype(A, /obj/structure/barricade/deployable))
		var/obj/structure/barricade/deployable/cade = A

		visible_message(SPAN_DANGER("[src] crushes [cade]!"))
		playsound(cade, 'sound/effects/metal_crash.ogg', 35)
		cade.collapse()

	else if(isobj(A) && !istype(A, /obj/vehicle))
		var/obj/O = A
		if(O.unacidable)
			return

		CA.take_damage_type(5, "blunt", O)
		visible_message(SPAN_DANGER("[src] crushes [O]!"))
		playsound(O, 'sound/effects/metal_crash.ogg', 35)
		qdel(O)

		return

	else if(istype(A, /turf/closed/wall))
		var/turf/closed/wall/W = A
		if(W.hull)
			return

		W.take_damage(30)
		CA.take_damage_type(10, "blunt", W)
		playsound(W, 'sound/effects/metal_crash.ogg', 35)
