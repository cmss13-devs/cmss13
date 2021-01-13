/obj/structure/pipes/standard/simple
	icon = 'icons/obj/pipes/pipes.dmi'
	icon_state = ""
	name = "pipe"
	desc = "A one meter section of regular pipe"
	dir = SOUTH
	valid_directions = list(SOUTH, NORTH)

/obj/structure/pipes/standard/simple/color_cache_name(var/obj/structure/pipes/node)
	return node.pipe_color

/obj/structure/pipes/standard/simple/Initialize()
	icon = null
	alpha = 255
	. = ..()

/obj/structure/pipes/standard/simple/create_valid_directions()
	switch(dir)
		if(SOUTH || NORTH)
			valid_directions = list(SOUTH, NORTH)
		if(EAST || WEST)
			valid_directions = list(EAST, WEST)
		if(NORTHEAST)
			valid_directions = list(NORTH, EAST)
		if(NORTHWEST)
			valid_directions = list(NORTH, WEST)
		if(SOUTHEAST)
			valid_directions = list(SOUTH, EAST)
		if(SOUTHWEST)
			valid_directions = list(SOUTH, WEST)

/obj/structure/pipes/standard/simple/proc/normalize_dir()
	if(dir == 3)
		setDir(NORTH)
	else if(dir == 12)
		setDir(EAST)

/obj/structure/pipes/standard/simple/update_icon(var/safety = 0)
	..()

	if(!check_icon_cache())
		return

	alpha = 255

	overlays.Cut()
	overlays += icon_manager.get_atmos_icon("pipe", , pipe_color, "intact")

/obj/structure/pipes/standard/simple/update_underlays()
	return


/obj/structure/pipes/standard/simple/visible
	icon_state = "intact"
	level = 2

/obj/structure/pipes/standard/simple/visible/scrubbers
	name = "Scrubbers pipe"
	desc = "A one meter section of scrubbers pipe"
	icon_state = "intact-scrubbers"
	layer = ATMOS_PIPE_SCRUBBER_LAYER
	color = PIPE_COLOR_RED

/obj/structure/pipes/standard/simple/visible/supply
	name = "Air supply pipe"
	desc = "A one meter section of supply pipe"
	icon_state = "intact-supply"
	layer = ATMOS_PIPE_SUPPLY_LAYER
	color = PIPE_COLOR_BLUE

/obj/structure/pipes/standard/simple/visible/yellow
	color = PIPE_COLOR_YELLOW

/obj/structure/pipes/standard/simple/visible/cyan
	color = PIPE_COLOR_CYAN

/obj/structure/pipes/standard/simple/visible/green
	color = PIPE_COLOR_GREEN

/obj/structure/pipes/standard/simple/visible/purple
	color = PIPE_COLOR_PURPLE


/obj/structure/pipes/standard/simple/hidden
	icon_state = "intact"
	alpha = 128		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game

/obj/structure/pipes/standard/simple/hidden/update_icon()
	level = 1

	. = ..()

/obj/structure/pipes/standard/simple/hidden/scrubbers
	name = "Scrubbers pipe"
	desc = "A one meter section of scrubbers pipe"
	icon_state = "intact-scrubbers"
	layer = ATMOS_PIPE_SCRUBBER_LAYER
	color = PIPE_COLOR_RED

/obj/structure/pipes/standard/simple/hidden/supply
	name = "Air supply pipe"
	desc = "A one meter section of supply pipe"
	icon_state = "intact-supply"
	layer = ATMOS_PIPE_SUPPLY_LAYER
	color = PIPE_COLOR_BLUE

/obj/structure/pipes/standard/simple/hidden/yellow
	color = PIPE_COLOR_YELLOW

/obj/structure/pipes/standard/simple/hidden/cyan
	color = PIPE_COLOR_CYAN

/obj/structure/pipes/standard/simple/hidden/green
	color = PIPE_COLOR_GREEN

/obj/structure/pipes/standard/simple/hidden/purple
	color = PIPE_COLOR_PURPLE


/obj/structure/pipes/standard/simple/insulated
	icon = 'icons/obj/pipes/red_pipe.dmi'
	icon_state = "intact"
	level = 2