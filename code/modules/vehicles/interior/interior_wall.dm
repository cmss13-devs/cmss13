/obj/structure/interior_wall
	name = "interior wall"
	desc = "An interior wall."
	icon = 'icons/obj/vehicles/interiors/tank.dmi'
	density = 1
	opacity = 0
	anchored = 1
	mouse_opacity = 0
	layer = WINDOW_LAYER
	flags_atom = ON_BORDER|NOINTERACT
	unacidable = TRUE
	unslashable = TRUE
	indestructible = TRUE

/obj/structure/interior_wall/ex_act()
	return

/obj/structure/interior_wall/New()
	. = ..()
	// BYOND docs fucking lie about New. dir (and other vars) is not initialized by the time this is called
	// So the update icon call needs to be delayed
	add_timer(CALLBACK(src, .proc/update_icon), 10)

/obj/structure/interior_wall/update_icon()
	..()

	pixel_y = 0
	alpha = 255
	layer = ABOVE_OBJ_LAYER

	switch(dir)
		if(NORTH)
			pixel_y = 31
			layer = INTERIOR_WALL_NORTH_LAYER
		if(SOUTH)
			alpha = 50
			layer = INTERIOR_WALL_SOUTH_LAYER
