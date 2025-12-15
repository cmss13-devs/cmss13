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
	while(pixel_x < 0) //we offset east and walk west to display the decal on correct place, it NEEDS positive offsets
		pixel_x += 32
		applied_turf = get_step(applied_turf, WEST)
	while(pixel_y < 0)
		pixel_y += 32
		applied_turf = get_step(applied_turf, SOUTH)


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
