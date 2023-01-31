

//the objects used by /datum/effect_system

/obj/effect/particle_effect
	name = "effect"
	icon = 'icons/effects/effects.dmi'
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	unacidable = TRUE // So effect are not targeted by alien acid.

/obj/effect/particle_effect/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_OVER|PASS_AROUND|PASS_UNDER|PASS_THROUGH|PASS_MOB_THRU

	//Fire
/obj/effect/particle_effect/fire  //Fire that ignites mobs and deletes itself after some time, but doesn't mess with atmos. Good fire flamethrowers and incendiary stuff.
	name = "fire"
	icon = 'icons/effects/fire.dmi'
	icon_state = "3"
	var/life = 0.5 SECONDS
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/particle_effect/fire/New()
	if(!istype(loc, /turf))
		qdel(src)
	addtimer(CALLBACK(src, PROC_REF(handle_extinguish)), life)

	setDir(pick(cardinal))
	SetLuminosity(3)

	for(var/mob/living/L in loc)//Mobs
		L.fire_act()
	for(var/obj/effect/alien/weeds/W in loc)//Weeds
		W.fire_act()
	for(var/obj/effect/alien/egg/E in loc)//Eggs
		E.fire_act()
	for(var/obj/structure/bed/nest/N in loc)//Nests
		N.fire_act()

/obj/effect/particle_effect/fire/proc/handle_extinguish()
	if(istype(loc, /turf))
		SetLuminosity(0)
	qdel(src)

/obj/effect/particle_effect/fire/Crossed(mob/living/L)
	..()
	if(isliving(L))
		L.fire_act()

	//End fire

/obj/effect/particle_effect/water
	name = "water"
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	var/life = 15
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/particle_effect/water/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_THROUGH|PASS_OVER|PASS_MOB_THRU|PASS_UNDER

/obj/effect/particle_effect/water/Move(turf/newloc)
	//var/turf/T = src.loc
	//if (istype(T, /turf))
	// T.firelevel = 0 //TODO: FIX
	if (--src.life < 1)
		//SN src = null
		qdel(src)
	if(newloc.density)
		return 0
	.=..()

/obj/effect/particle_effect/water/Collide(atom/A)
	if(reagents)
		reagents.reaction(A)
	return ..()
