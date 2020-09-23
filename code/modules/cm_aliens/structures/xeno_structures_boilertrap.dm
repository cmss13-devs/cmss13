// Special boiler trap

// Tightly coupled with the boiler trapper strain. Pretty unavoidable given
// the amount of references this has to pass back and forth
/obj/effect/alien/resin/boilertrap
	desc = "It looks like a trap for catching tallhosts."
	name = "resin hole"
	icon_state = "trap_boiler"
	density = 0
	opacity = 0
	anchored = 1
	health = 5
	layer = RESIN_STRUCTURE_LAYER
	var/list/tripwires = list()
	var/hivenumber = XENO_HIVE_NORMAL

	var/mob/living/carbon/Xenomorph/bound_xeno // Boiler linked to this trap
	
/obj/effect/alien/resin/boilertrap/New(loc, mob/living/carbon/Xenomorph/X, ttl = 300)

	if(!istype(X))
		qdel(src)
		return

	bound_xeno = X
	hivenumber = X.hivenumber
	add_timer(CALLBACK(src, .proc/delete_trap), ttl)

	set_hive_data(src, hivenumber)
	..()

/obj/effect/alien/resin/boilertrap/examine(mob/user)
	if(!isXeno(user))
		return ..()
	to_chat(user, SPAN_XENOWARNING("A trap designed for a catching tallhosts and holding them still."))

/obj/effect/alien/resin/boilertrap/flamer_fire_act()
	delete_trap()
	..()

/obj/effect/alien/resin/boilertrap/fire_act()
	delete_trap()
	..()

/obj/effect/alien/resin/boilertrap/bullet_act(obj/item/projectile/P)
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	if(ammo_flags & (AMMO_XENO_ACID|AMMO_XENO_TOX))
		return
	delete_trap()
	. = ..()

/obj/effect/alien/resin/boilertrap/proc/delete_trap()
	clear_tripwires()
	qdel(src)

/obj/effect/alien/resin/boilertrap/proc/trigger_trap(mob/living/carbon/H)
	if (!istype(H))
		return
	
	if (!istype(bound_xeno))
		return

	H.frozen = TRUE // cleaned up by the xeno freeze effect anyway
	H.update_canmove()
	new /datum/effects/xeno_freeze(H, bound_xeno, , , 17.5)
	to_chat(bound_xeno, SPAN_XENOHIGHDANGER("You feel one of your traps capture a tallhost!"))
	to_chat(H, SPAN_XENOHIGHDANGER("You are caught by a trap made of foul resin!"))
	delete_trap()

/obj/effect/alien/resin/boilertrap/proc/clear_tripwires()
	for(var/obj/effect/hole_tripwire_boiler/HT in tripwires)
		tripwires -= HT
		qdel(HT)

	tripwires = null

/obj/effect/alien/resin/boilertrap/attack_alien(mob/living/carbon/Xenomorph/X)
	to_chat(X, SPAN_XENOWARNING("Best not to meddle with that trap."))
	return

/obj/effect/alien/resin/boilertrap/proc/setup_tripwires()
	clear_tripwires()
	for(var/turf/T in orange(1,loc))
		var/obj/effect/hole_tripwire_boiler/HT = new /obj/effect/hole_tripwire_boiler(T)
		HT.linked_trap = src
		tripwires += HT

/obj/effect/alien/resin/boilertrap/Crossed(atom/A)
	if (isXeno(A))
		var/mob/living/carbon/Xenomorph/X = A
		if (X.hivenumber != hivenumber)
			trigger_trap(A)
	else if(ishuman(A))
		trigger_trap(A)

	return ..()

/obj/effect/alien/resin/boilertrap/Destroy()
	clear_tripwires()
	. = ..()

/obj/effect/hole_tripwire_boiler
	name = "hole tripwire"
	anchored = TRUE
	mouse_opacity = 0
	invisibility = 101
	unacidable = TRUE //You never know
	var/obj/effect/alien/resin/boilertrap/linked_trap

/obj/effect/hole_tripwire_boiler/Destroy()
	if(linked_trap)
		linked_trap.tripwires -= src
		linked_trap = null
	. = ..()

/obj/effect/hole_tripwire_boiler/Crossed(atom/A)
	if(!linked_trap)
		qdel(src)
		return

	if(ishuman(A))
		linked_trap.trigger_trap(A)
