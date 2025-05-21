//------------------------------------------
//BLOOD HITS
//------------------------------------------

/obj/effect/bloodsplatter
	icon = 'icons/effects/blood.dmi'
	var/duration = 5
	layer = ABOVE_XENO_LAYER
	var/splatter_type = "splatter"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/bloodsplatter/Initialize(mapload, set_dir, fx_duration, color_override)
	. = ..()
	if(color_override)
		color = color_override
	if(IS_DIAGONAL_DIR(set_dir))
		icon_state = "[splatter_type][pick(1, 2, 6)]"
	else
		icon_state = "[splatter_type][pick(3, 4, 5)]"
	if(fx_duration)
		duration = fx_duration
	setDir(set_dir)
	AddElement(/datum/element/temporary, duration)
	var/target_pixel_x = 0
	var/target_pixel_y = 0
	switch(set_dir)
		if(NORTH)
			target_pixel_y = 16
		if(SOUTH)
			target_pixel_y = -16
		if(EAST)
			target_pixel_x = 16
		if(WEST)
			target_pixel_x = -16
		if(NORTHEAST)
			target_pixel_x = 16
			target_pixel_y = 16
		if(NORTHWEST)
			target_pixel_x = -16
			target_pixel_y = 16
		if(SOUTHEAST)
			target_pixel_x = 16
			target_pixel_y = -16
		if(SOUTHWEST)
			target_pixel_x = -16
			target_pixel_y = -16
	animate(src, pixel_x = target_pixel_x, pixel_y = target_pixel_y, alpha = 0, time = duration)


/obj/effect/bloodsplatter/xenosplatter
	splatter_type = "csplatter"
	color = BLOOD_COLOR_XENO

/obj/effect/bloodsplatter/human
	splatter_type = "csplatter"
	color = BLOOD_COLOR_HUMAN

/obj/effect/bloodsplatter/hellhound
	splatter_type = "csplatter"
	color = BLOOD_COLOR_YAUTJA

/obj/effect/bloodsplatter/yautjasplatter
	splatter_type = "csplatter"
	color = BLOOD_COLOR_YAUTJA_DARK

/obj/effect/bloodsplatter/synthsplatter
	splatter_type = "csplatter"
	color = BLOOD_COLOR_SYNTHETIC
