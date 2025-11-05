//The effect when you wrap a dead body in gift wrap
/obj/effect/spresent
	name = "strange present"
	desc = "It's a ... present?"
	icon = 'icons/obj/items/gifts.dmi'
	icon_state = "strangepresent"
	density = TRUE
	anchored = FALSE






/obj/effect/mark
	var/mark = ""
	icon = 'icons/old_stuff/mark.dmi'
	icon_state = "blank"
	anchored = TRUE
	layer = 99
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	unacidable = TRUE//Just to be sure.

/obj/effect/beam
	name = "beam"
	unacidable = TRUE//Just to be sure.
	var/def_zone

/obj/effect/beam/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_OVER|PASS_THROUGH

/obj/effect/list_container
	name = "list container"

/obj/effect/list_container/mobl
	name = "mobl"
	var/master = null

	var/list/container = list(  )

/obj/effect/projection
	name = "Projection"
	desc = "This looks like a projection of something."
	anchored = TRUE


/obj/effect/shut_controller
	name = "shut controller"
	var/moving = null
	var/list/parts = list(  )




//Exhaust effect
/obj/effect/engine_exhaust
	name = "engine exhaust"
	icon = 'icons/effects/effects.dmi'
	icon_state = "exhaust"
	anchored = TRUE

/obj/effect/engine_exhaust/New(turf/nloc, ndir, temp)
	setDir(ndir)
	..(nloc)

	spawn(20)
		moveToNullspace()

/particles/blood_explosion
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	width = 500
	height = 500
	count = 20
	spawning = 20
	lifespan = 0.7 SECONDS
	fade = 0.9 SECONDS
	grow = 0.1
	scale = 0.4
	spin = generator(GEN_NUM, -20, 20)
	velocity = generator(GEN_CIRCLE, 15, 15)
	friction = generator(GEN_NUM, 0.15, 0.65)
	position = generator(GEN_CIRCLE, 6, 6)

/particles/gib_splatter
	icon = 'icons/effects/blood.dmi'
	icon_state = list("mgibbl3" = 1, "mgibbl5" = 1)
	width = 500
	height = 500
	count = 20
	spawning = 20
	lifespan = 1 SECONDS
	fade = 1.7 SECONDS
	grow = 0.05
	gravity = list(0, -3)
	scale = generator(GEN_NUM, 1, 1.25)
	rotation = generator(GEN_NUM, -10, 10)
	spin = generator(GEN_NUM, -10, 10)
	velocity = list(0, 18)
	friction = generator(GEN_NUM, 0.15, 0.1)
	position = generator(GEN_CIRCLE, 9, 9)
	drift = generator(GEN_CIRCLE, 2, 1)

/obj/effect/gib_particles
	///blood explosion particle holder
	var/obj/effect/abstract/particle_holder/blood
	///gib blood splatter particle holder
	var/obj/effect/abstract/particle_holder/gib_splatter

/obj/effect/gib_particles/Initialize(mapload, gib_color)
	. = ..()
	blood = new(src, /particles/blood_explosion)
	blood.color = gib_color
	gib_splatter = new(src, /particles/gib_splatter)
	gib_splatter.color = gib_color
	addtimer(CALLBACK(src, PROC_REF(stop_spawning)), 5, TIMER_CLIENT_TIME)
	QDEL_IN(src, 1 SECONDS)

/obj/effect/gib_particles/proc/stop_spawning()
	blood.particles.count = 0
	gib_splatter.particles.count = 0
