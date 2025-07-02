//------------------------------------------
//Block
//------------------------------------------

/obj/effect/block //color is white by default, set to whatever is needed
	name = "blocking glow"
	icon_state = "block"
	color = COLOR_YELLOW
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/duration = 6.7
	var/timerid

/obj/effect/block/Initialize(mapload)
	. = ..()
	timerid = QDEL_IN(src, duration)
	pixel_x = rand(-12, 12)
	pixel_y = rand(-9, 0)
	animate(src, pixel_x = pixel_x, pixel_y = pixel_y, alpha = 0, time = duration)

/obj/effect/block/Destroy()
	. = ..()
	deltimer(timerid)
