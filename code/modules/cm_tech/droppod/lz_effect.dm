/obj/effect/warning
	name = "warning"
	icon = 'icons/effects/alert.dmi'
	icon_state = "alert_greyscale"
	anchored = TRUE

	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_OBJ_LAYER

/obj/effect/warning/droppod
	name = "droppod landing-zone"
	icon_state = "techpod_lz_marker"

/obj/effect/warning/droppod/smoke/Initialize(mapload)
	. = ..()
	add_shared_particles(/particles/droppod_dust)

/obj/effect/warning/droppod/smoke/Destroy(force)
	. = ..()
	remove_shared_particles(/particles/droppod_dust)

/particles/droppod_dust
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	width = 200
	height = 200
	count = 30
	spawning = 10
	lifespan = 5
	fade = 10
	fadein = 2
	grow = 0.2
	velocity = generator(GEN_CIRCLE, 5, 10, UNIFORM_RAND)
	scale = 0.1
	rotation = 0
	spin = generator(GEN_NUM, -20, 20)

/obj/effect/warning/alien
	name = "alien warning"
	color = "#a800ff"

/obj/effect/warning/alien/weak
	name = "weak alien warning"
	color = "#a800ff"
	alpha = 127

/obj/effect/warning/hover
	name = "hoverpack warning"
	color = "#D4AE1E"

/obj/effect/warning/explosive
	name = "explosive warning"
	color = "#ff0000"

/obj/effect/warning/explosive/Initialize(mapload, time_until_explosion)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(disappear)), time_until_explosion)

/obj/effect/warning/explosive/proc/disappear()
	qdel(src)

/obj/effect/warning/explosive/gas
	name = "gas warning"
	color = "#42acd6"
