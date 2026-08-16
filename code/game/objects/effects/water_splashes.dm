/obj/effect/water_splash
	name = "splash"
	desc = "Disturbed water, watch how it flies!"
	icon = 'icons/effects/water.dmi'
	icon_state = "splash"
	density = FALSE
	opacity = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_XENO_LAYER
	var/lifetime = 5 SECONDS

/obj/effect/water_splash/Initialize(mapload=FALSE, in_lifetime)
	. = ..()
	lifetime = in_lifetime ? in_lifetime : lifetime
	if(lifetime != INFINITY)
		addtimer(CALLBACK(src, PROC_REF(destroy_effect)), lifetime)

/obj/effect/water_splash/proc/destroy_effect()
	qdel(src)

