/// Temporary visual effects
/obj/effect/temp_visual
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	///How long before the temp_visual gets deleted
	var/duration = 1 SECONDS
	///Timer that our duration is stored in
	var/timerid
	///Gives our effect a random direction on init
	var/randomdir = TRUE



/obj/effect/temp_visual/Initialize(mapload)
	. = ..()
	if(randomdir)
		setDir(pick(GLOB.cardinals))

	timerid = QDEL_IN(src, duration)


/obj/effect/temp_visual/Destroy()
	deltimer(timerid)
	return ..()


/obj/effect/temp_visual/ex_act()
	return


/obj/effect/temp_visual/dir_setting
	randomdir = FALSE


/obj/effect/temp_visual/dir_setting/Initialize(mapload, set_dir)
	if(set_dir)
		setDir(set_dir)
	return ..()
