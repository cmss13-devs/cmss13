// Special boiler trap

// Tightly coupled with the boiler trapper strain. Pretty unavoidable given
// the amount of references this has to pass back and forth
/obj/effect/alien/resin/boilertrap
	desc = "It looks like a trap for catching tallhosts."
	name = "resin hole"
	icon_state = "trap_boiler"
	density = FALSE
	opacity = FALSE
	anchored = TRUE
	health = 1
	layer = RESIN_STRUCTURE_LAYER
	var/list/tripwires = list()
	var/hivenumber = XENO_HIVE_NORMAL
	var/root_duration = 2.5 SECONDS

	var/mob/living/carbon/xenomorph/bound_xeno // Boiler linked to this trap

/obj/effect/alien/resin/boilertrap/Initialize(mapload, mob/living/carbon/xenomorph/X)
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

/obj/effect/alien/resin/boilertrap/get_examine_text(mob/user)
	if(!isxeno(user))
		return ..()
	. = ..()
	. += SPAN_XENOWARNING("A trap designed for catching hosts and holding them still.")

/obj/effect/alien/resin/boilertrap/fire_act()
	. = ..()
	qdel(src)

/obj/effect/alien/resin/boilertrap/bullet_act(obj/projectile/proj)
	var/ammo_flags = proj.ammo.flags_ammo_behavior | proj.projectile_override_flags
	if(ammo_flags & (AMMO_XENO))
		return
	return ..()

/obj/effect/alien/resin/boilertrap/proc/trigger_trap(mob/victim)
	if(!istype(victim) || !istype(bound_xeno))
		return
	var/datum/effects/boiler_trap/trap = new(victim, bound_xeno, name)
	QDEL_IN(trap, root_duration)
	to_chat(bound_xeno, SPAN_XENOHIGHDANGER("We feel one of our traps capture a host!"))
	to_chat(victim, SPAN_XENOHIGHDANGER("You are caught by a trap made of foul resin!"))

	to_chat(bound_xeno, SPAN_XENONOTICE("We gain the tactical advantage over our opponents!"))
	var/datum/behavior_delegate/boiler_trapper/be_del = bound_xeno.behavior_delegate
	be_del.success_trap_buff()
	qdel(src)

/obj/effect/alien/resin/boilertrap/attack_alien(mob/living/carbon/xenomorph/X)
	to_chat(X, SPAN_XENOWARNING("Best not to meddle with that trap."))
	return XENO_NO_DELAY_ACTION

/obj/effect/alien/resin/boilertrap/Crossed(atom/A)
	if (isxeno(A))
		var/mob/living/carbon/xenomorph/X = A
		if (X.hivenumber != hivenumber)
			trigger_trap(A)
	else if(ishuman(A))
		trigger_trap(A)

	return ..()

/obj/effect/hole_tripwire_boiler
	name = "hole tripwire"
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
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
