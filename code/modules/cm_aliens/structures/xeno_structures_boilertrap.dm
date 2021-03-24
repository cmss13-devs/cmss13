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
	health = 1
	layer = RESIN_STRUCTURE_LAYER
	var/list/tripwires = list()
	var/hivenumber = XENO_HIVE_NORMAL
	var/root_duration = 17.5

	var/mob/living/carbon/Xenomorph/bound_xeno // Boiler linked to this trap

/obj/effect/alien/resin/boilertrap/empowered
	root_duration = 30.0

/obj/effect/alien/resin/boilertrap/Initialize(mapload, mob/living/carbon/Xenomorph/X)
	if(mapload || !istype(X))
		return INITIALIZE_HINT_QDEL
	bound_xeno = X
	hivenumber = X.hivenumber
	set_hive_data(src, hivenumber)
	return ..()

/obj/effect/alien/resin/boilertrap/Destroy(force)
	bound_xeno = null
	QDEL_NULL_LIST(tripwires)
	return ..()

/obj/effect/alien/resin/boilertrap/examine(mob/user)
	if(!isXeno(user))
		return ..()
	to_chat(user, SPAN_XENOWARNING("A trap designed for a catching tallhosts and holding them still."))

/obj/effect/alien/resin/boilertrap/fire_act()
	. = ..()
	qdel(src)

/obj/effect/alien/resin/boilertrap/bullet_act(obj/item/projectile/P)
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	if(ammo_flags & (AMMO_XENO_ACID|AMMO_XENO_TOX))
		return
	return ..()

/obj/effect/alien/resin/boilertrap/proc/trigger_trap(mob/M)
	if(!istype(M) || !istype(bound_xeno))
		return
	var/datum/effects/boiler_trap/F = new(M, bound_xeno)
	QDEL_IN(F, root_duration)
	to_chat(bound_xeno, SPAN_XENOHIGHDANGER("You feel one of your traps capture a tallhost!"))
	to_chat(M, SPAN_XENOHIGHDANGER("You are caught by a trap made of foul resin!"))
	qdel(src)

/obj/effect/alien/resin/boilertrap/attack_alien(mob/living/carbon/Xenomorph/X)
	to_chat(X, SPAN_XENOWARNING("Best not to meddle with that trap."))
	return

/obj/effect/alien/resin/boilertrap/Crossed(atom/A)
	if (isXeno(A))
		var/mob/living/carbon/Xenomorph/X = A
		if (X.hivenumber != hivenumber)
			trigger_trap(A)
	else if(ishuman(A))
		trigger_trap(A)

	return ..()

/obj/effect/hole_tripwire_boiler
	name = "hole tripwire"
	anchored = TRUE
	mouse_opacity = 0
	invisibility = 101
	unacidable = TRUE //You never know
	var/obj/effect/alien/resin/boilertrap/linked_trap

/obj/effect/hole_tripwire_boiler/Destroy(force)
	linked_trap?.tripwires -= src
	linked_trap = null
	return ..()

/obj/effect/hole_tripwire_boiler/Crossed(atom/A)
	if(!linked_trap)
		qdel(src)
		return

	if(ishuman(A))
		linked_trap.trigger_trap(A)
