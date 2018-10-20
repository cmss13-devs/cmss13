//All the special cases in which the tank can run over things, and what happens.

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
				X.visible_message("<span class='danger'>[X] digs it's claws into the ground, standing it's ground, halting [src] in it's tracks!</span>",
				"<span class='danger'>You dig your claws into the ground, stopping [src] in it's tracks!</span>")
				return FALSE
		if(!L.is_mob_incapacitated())
			step_away(L,src)
		if(is_knocked_down) L.KnockDown(3, 1)
		if(takes_damage) L.apply_damage(7 + rand(0, 5), BRUTE)
		playsound(loc, "punch", 25, 1)
		L.visible_message("<span class='danger'>[src] rams [L]!</span>", "<span class='danger'>[src] rams you! Get out of the way!</span>")
		var/list/slots = CA.get_activatable_hardpoints()
		for(var/slot in slots)
			var/obj/item/hardpoint/H = CA.hardpoints[slot]
			if(!H) continue
			H.livingmob_interact(L)

	else if(istype(A, /obj) && !istype(A, /obj/vehicle))
		var/obj/O = A
		if(istype(O, /obj/structure/mortar)) //Mortars are unacidable so we need to do them here
			var/obj/structure/mortar/M = O //Attackby code for mortars requires a mob so...
			new /obj/item/mortar_kit (M.loc)
			CA.take_damage_type(5, "blunt", O)
			visible_message("<span class='danger'>[src] crushes [O]!</span>",
			"<span class='xenodanger'>You crush [O]!</span>")
			cdel(M)
			return
		if(O.unacidable)
			return
		CA.take_damage_type(5, "blunt", O)
		visible_message("<span class='danger'>[src] crushes [O]!</span>",
		"<span class='danger'>You crush [O]!</span>")
		if(O.contents.len) //Hopefully won't auto-delete things inside crushed stuff.
			var/turf/L = get_turf(O)
			for(var/atom/movable/S in O.contents) S.loc = L
		playsound(O, 'sound/effects/metal_crash.ogg', 35)
		cdel(O)
		return
	else if(istype(A, /turf/closed/wall))
		var/turf/closed/wall/W = A
		if(W.hull)
			return
		W.take_damage(30)
		CA.take_damage_type(10, "blunt", W)
		playsound(W, 'sound/effects/metal_crash.ogg', 35)