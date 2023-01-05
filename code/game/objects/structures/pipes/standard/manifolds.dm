/obj/structure/pipes/standard/manifold
	icon = 'icons/obj/pipes/manifold.dmi'
	icon_state = ""
	name = "pipe manifold"
	desc = "A manifold composed of regular pipes"
	dir = SOUTH
	valid_directions = list(EAST, NORTH, WEST)

/obj/structure/pipes/standard/manifold/color_cache_name(var/obj/structure/pipes/node)
	if(pipe_color == node.pipe_color)
		return node.pipe_color
	else
		return null

/obj/structure/pipes/standard/manifold/Initialize()
	icon = null
	alpha = 255
	. = ..()

/obj/structure/pipes/standard/manifold/create_valid_directions()
	switch(dir)
		if(NORTH)
			valid_directions = list(EAST, SOUTH, WEST)
		if(SOUTH)
			valid_directions = list(WEST, NORTH, EAST)
		if(EAST)
			valid_directions = list(SOUTH, WEST, NORTH)
		if(WEST)
			valid_directions = list(NORTH, EAST, SOUTH)

/obj/structure/pipes/standard/manifold/update_icon(var/safety = 0)
	if(!check_icon_cache())
		return

	alpha = 255

	if(!length(connected_to))
		new /obj/item/pipe(loc, null, null, src)
		qdel(src)
	else
		overlays.Cut()
		underlays.Cut()

		overlays += icon_manager.get_atmos_icon("manifold", null, pipe_color, "core")
		overlays += icon_manager.get_atmos_icon("manifold", null, null, "clamps")

		var/turf/T = get_turf(src)
		for(var/D in valid_directions)
			add_underlay(T, D)

	..()

/obj/structure/pipes/standard/manifold/visible
	icon_state = "map"
	level = 2

/obj/structure/pipes/standard/manifold/visible/scrubbers
	name="Scrubbers pipe manifold"
	desc = "A manifold composed of scrubbers pipes"
	icon_state = "map-scrubbers"
	layer = ATMOS_PIPE_SCRUBBER_LAYER
	color = PIPE_COLOR_RED

/obj/structure/pipes/standard/manifold/visible/supply
	name="Air supply pipe manifold"
	desc = "A manifold composed of supply pipes"
	icon_state = "map-supply"
	layer = ATMOS_PIPE_SUPPLY_LAYER
	color = PIPE_COLOR_BLUE

/obj/structure/pipes/standard/manifold/visible/yellow
	color = PIPE_COLOR_YELLOW

/obj/structure/pipes/standard/manifold/visible/cyan
	color = PIPE_COLOR_CYAN

/obj/structure/pipes/standard/manifold/visible/green
	color = PIPE_COLOR_GREEN

/obj/structure/pipes/standard/manifold/visible/purple
	color = PIPE_COLOR_PURPLE


/obj/structure/pipes/standard/manifold/hidden
	icon_state = "map"
	alpha = 128		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game

/obj/structure/pipes/standard/manifold/hidden/update_icon()
	level = 1

	. = ..()

/obj/structure/pipes/standard/manifold/hidden/scrubbers
	name = "Scrubbers pipe manifold"
	desc = "A manifold composed of scrubbers pipes"
	icon_state = "map-scrubbers"
	layer = ATMOS_PIPE_SCRUBBER_LAYER
	color = PIPE_COLOR_RED

/obj/structure/pipes/standard/manifold/hidden/supply
	name = "Air supply pipe manifold"
	desc = "A manifold composed of supply pipes"
	icon_state = "map-supply"
	layer = ATMOS_PIPE_SUPPLY_LAYER
	color = PIPE_COLOR_BLUE

/obj/structure/pipes/standard/manifold/hidden/yellow
	color = PIPE_COLOR_YELLOW

/obj/structure/pipes/standard/manifold/hidden/cyan
	color = PIPE_COLOR_CYAN

/obj/structure/pipes/standard/manifold/hidden/green
	color = PIPE_COLOR_GREEN

/obj/structure/pipes/standard/manifold/hidden/purple
	color = PIPE_COLOR_PURPLE


/obj/structure/pipes/standard/manifold/fourway
	icon = 'icons/obj/pipes/manifold.dmi'
	icon_state = ""
	name = "4-way pipe manifold"
	desc = "A manifold composed of regular pipes"
	dir = SOUTH
	valid_directions = list(NORTH, SOUTH, EAST, WEST)

/obj/structure/pipes/standard/manifold/fourway/create_valid_directions()
	return

/obj/structure/pipes/standard/manifold/fourway/visible
	icon_state = "map_4way"
	level = 2

/obj/structure/pipes/standard/manifold/fourway/visible/scrubbers
	name="4-way scrubbers pipe manifold"
	desc = "A manifold composed of scrubbers pipes"
	icon_state = "map_4way-scrubbers"
	layer = ATMOS_PIPE_SCRUBBER_LAYER
	color = PIPE_COLOR_RED

/obj/structure/pipes/standard/manifold/fourway/visible/supply
	name="4-way air supply pipe manifold"
	desc = "A manifold composed of supply pipes"
	icon_state = "map_4way-supply"
	layer = ATMOS_PIPE_SUPPLY_LAYER
	color = PIPE_COLOR_BLUE

/obj/structure/pipes/standard/manifold/fourway/visible/yellow
	color = PIPE_COLOR_YELLOW

/obj/structure/pipes/standard/manifold/fourway/visible/cyan
	color = PIPE_COLOR_CYAN

/obj/structure/pipes/standard/manifold/fourway/visible/green
	color = PIPE_COLOR_GREEN

/obj/structure/pipes/standard/manifold/fourway/visible/purple
	color = PIPE_COLOR_PURPLE


/obj/structure/pipes/standard/manifold/fourway/hidden
	icon_state = "map_4way"
	alpha = 128		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game

/obj/structure/pipes/standard/manifold/fourway/hidden/update_icon()
	level = 1

	. = ..()

/obj/structure/pipes/standard/manifold/fourway/hidden/scrubbers
	name="4-way scrubbers pipe manifold"
	desc = "A manifold composed of scrubbers pipes"
	icon_state = "map_4way-scrubbers"
	layer = ATMOS_PIPE_SCRUBBER_LAYER
	color = PIPE_COLOR_RED

/obj/structure/pipes/standard/manifold/fourway/hidden/supply
	name="4-way air supply pipe manifold"
	desc = "A manifold composed of supply pipes"
	icon_state = "map_4way-supply"
	layer = ATMOS_PIPE_SUPPLY_LAYER
	color = PIPE_COLOR_BLUE

/obj/structure/pipes/standard/manifold/fourway/hidden/yellow
	color = PIPE_COLOR_YELLOW

/obj/structure/pipes/standard/manifold/fourway/hidden/cyan
	color = PIPE_COLOR_CYAN

/obj/structure/pipes/standard/manifold/fourway/hidden/green
	color = PIPE_COLOR_GREEN

/obj/structure/pipes/standard/manifold/fourway/hidden/purple
	color = PIPE_COLOR_PURPLE
