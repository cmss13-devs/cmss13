//decal parent

/obj/effect/decal
	name = "you should not be seeing this!"
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/Initialize()
	.=..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/decal/LateInitialize()
	. = ..()
	var/turf/applied_turf = get_turf(src)

	if(!applied_turf)
		qdel(src)
		return
	var/image/overlay = icon(icon,icon_state, dir)
	if(pixel_x)
		overlay.pixel_x = pixel_x
	if(pixel_y)
		overlay.pixel_y = pixel_y
	applied_turf.overlays += icon(icon,icon_state, dir)
	qdel(src)
	return
