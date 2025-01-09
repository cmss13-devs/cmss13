//decal parent

/obj/effect/decal
	name = "you should not be seeing this!"
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/keep_as_object = FALSE

/obj/effect/decal/Initialize()
	. = ..()
	if(keep_as_object)
		return

	return INITIALIZE_HINT_LATELOAD

/obj/effect/decal/LateInitialize()
	. = ..()
	var/turf/applied_turf = get_turf(src)

	if(!applied_turf)
		qdel(src)
		return
	var/image/overlay = image(icon, icon_state = icon_state, dir = dir)
	if(pixel_x)
		overlay.pixel_x = pixel_x
	if(pixel_y)
		overlay.pixel_y = pixel_y
	if(color)
		overlay.color = color
	applied_turf.overlays += overlay
	qdel(src)
