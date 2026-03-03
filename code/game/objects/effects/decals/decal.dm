//decal parent

/obj/effect/decal
	name = "you should not be seeing this!"
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/keep_as_object = FALSE

// This is with the intent of optimizing mapload
// See spawners for more details since we use the same pattern
// Basically rather then creating and deleting ourselves, why not just do the bare minimum?
/obj/effect/decal/Initialize(mapload)
	if(keep_as_object)
		return ..()
	if(flags_atom & INITIALIZED)
		CRASH("Warning: [src]([type]) initialized multiple times!")
	flags_atom |= INITIALIZED
	if(!isturf(loc)) //you know this will happen somehow
		CRASH("Decal initialized in an object/nullspace")
	var/turf/applied_turf = get_turf(src)
	while(pixel_x < 0) //we offset east and walk west to display the decal on correct place, it NEEDS positive offsets
		pixel_x += 32
		applied_turf = get_step(applied_turf, WEST)
	while(pixel_y < 0)
		pixel_y += 32
		applied_turf = get_step(applied_turf, SOUTH)
	if(!applied_turf)
		return INITIALIZE_HINT_QDEL
	var/image/overlay = image(icon, icon_state = icon_state, dir = dir)
	if(pixel_x)
		overlay.pixel_x = pixel_x
	if(pixel_y)
		overlay.pixel_y = pixel_y
	if(color)
		overlay.color = color
	LAZYADD(applied_turf.merged_decals, overlay)
	if(!mapload) // spawned after mapload, can't rely on the turf it's on getting updated
		overlays += overlay
	return INITIALIZE_HINT_QDEL
