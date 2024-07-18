

//the objects used by /datum/effect_system

/obj/effect/particle_effect
	name = "effect"
	icon = 'icons/effects/effects.dmi'
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	unacidable = TRUE // So effect are not targeted by alien acid.

/obj/effect/particle_effect/initialize_pass_flags(datum/pass_flags_container/pass_flags)
	..()
	if (pass_flags)
		pass_flags.flags_pass = PASS_OVER|PASS_AROUND|PASS_UNDER|PASS_THROUGH|PASS_MOB_THRU

//Water

/obj/effect/particle_effect/water
	name = "water"
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	var/life = 15
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/particle_effect/water/initialize_pass_flags(datum/pass_flags_container/pass_flags)
	..()
	if (pass_flags)
		pass_flags.flags_pass = PASS_THROUGH|PASS_OVER|PASS_MOB_THRU|PASS_UNDER

/obj/effect/particle_effect/water/Move(turf/newloc)
	life -= 1
	if (life < 1)
		qdel(src)
	if(newloc.density)
		return 0
	.=..()

/obj/effect/particle_effect/water/Collide(atom/A)
	if(reagents)
		reagents.reaction(A)
	return ..()
