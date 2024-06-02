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
