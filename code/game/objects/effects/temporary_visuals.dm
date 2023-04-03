/obj/effect/temp_visual//ported (pasted) from TG13
	icon_state = null
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	//time, in deciseconds of duration
	var/duration = 10
	///if true, will pick a random direction when created.
	var/randomdir = TRUE
	///id of the deletion timer
	var/timerid

/obj/effect/temp_visual/Initialize(mapload)
	. = ..()
	if(randomdir)
		setDir(pick(GLOB.cardinals))

	timerid = QDEL_IN(src, duration)

/obj/effect/temp_visual/Destroy()
	. = ..()
	deltimer(timerid)

/obj/effect/temp_visual/dir_setting
	randomdir = FALSE

/obj/effect/temp_visual/dir_setting/Initialize(mapload, set_dir)
	if(set_dir)
		setDir(set_dir)
	. = ..()

//------------------------------------------
//BLOOD HITS
//------------------------------------------

/obj/effect/temp_visual/dir_setting/bloodsplatter
	icon = 'icons/effects/blood.dmi'
	duration = 5
	randomdir = FALSE
	layer = ABOVE_XENO_LAYER
	var/splatter_type = "splatter"

/obj/effect/temp_visual/dir_setting/bloodsplatter/Initialize(mapload, set_dir, fx_duration)
	if(IS_DIAGONAL_DIR(set_dir))
		icon_state = "[splatter_type][pick(1, 2, 6)]"
	else
		icon_state = "[splatter_type][pick(3, 4, 5)]"
	. = ..()
	if(fx_duration)
		duration = fx_duration
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


/obj/effect/temp_visual/dir_setting/bloodsplatter/xenosplatter
	splatter_type = "csplatter"
	color = "#77b013"

/obj/effect/temp_visual/dir_setting/bloodsplatter/human
	splatter_type = "csplatter"
	color = "#a8180d"

/obj/effect/temp_visual/dir_setting/bloodsplatter/hellhound
	splatter_type = "csplatter"
	color = "#a80d3b"

/obj/effect/temp_visual/dir_setting/bloodsplatter/yautjasplatter
	splatter_type = "csplatter"
	color = "#5A934A"

/obj/effect/temp_visual/dir_setting/bloodsplatter/synthsplatter
	splatter_type = "csplatter"
	color = "#e0e0e0"

