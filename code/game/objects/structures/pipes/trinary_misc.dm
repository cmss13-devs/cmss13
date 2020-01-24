/obj/structure/pipes/trinary
	dir = SOUTH
	valid_directions = list(SOUTH, NORTH, WEST)

/obj/structure/pipes/trinary/create_valid_directions()
	switch(dir)
		if(NORTH)
			valid_directions = list(EAST, NORTH, SOUTH)
		if(SOUTH)
			valid_directions = list(SOUTH, WEST, NORTH)
		if(EAST)
			valid_directions = list(EAST, WEST, SOUTH)
		if(WEST)
			valid_directions = list(WEST, NORTH, EAST)


/obj/structure/pipes/trinary/filter
	icon = 'icons/obj/pipes/filter.dmi'
	icon_state = "map"
	density = 0
	level = 1
	name = "Gas filter"

/obj/structure/pipes/trinary/filter/Initialize()
	. = ..()
	icon_state = ""

/obj/structure/pipes/trinary/filter/update_icon()
	if(length(connected_to))
		icon_state += "on"
	else
		icon_state += "off"

/obj/structure/pipes/trinary/filter/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return

		add_underlay(T, turn(dir, -180))

		if(istype(src, /obj/structure/pipes/trinary/filter/m_filter))
			add_underlay(T, turn(dir, 90))
		else
			add_underlay(T, turn(dir, -90))

		add_underlay(T, dir)

/obj/structure/pipes/trinary/filter/hide(var/invis)
	update_underlays()

/obj/structure/pipes/trinary/filter/m_filter
	icon_state = "mmap"
	dir = SOUTH
	valid_directions = list(SOUTH, NORTH, EAST)

/obj/structure/pipes/trinary/filter/m_filter/Initialize()
	. = ..()
	icon_state = "m"

/obj/structure/pipes/trinary/filter/m_filter/create_valid_directions()
	switch(dir)
		if(NORTH)
			valid_directions = list(WEST, NORTH, SOUTH)
		if(SOUTH)
			valid_directions = list(SOUTH, EAST, NORTH)
		if(EAST)
			valid_directions = list(EAST, WEST, NORTH)
		if(WEST)
			valid_directions = list(WEST, SOUTH, EAST)


/obj/structure/pipes/trinary/mixer
	icon = 'icons/obj/pipes/mixer.dmi'
	icon_state = "map"
	density = 0
	level = 1
	name = "Gas mixer"

/obj/structure/pipes/trinary/filter/Initialize()
	. = ..()
	icon_state = ""

/obj/structure/pipes/trinary/mixer/update_icon(var/safety = 0)
	if(length(connected_to))
		icon_state += "on"
	else
		icon_state += "off"

/obj/structure/pipes/trinary/mixer/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return

		if(istype(src, /obj/structure/pipes/trinary/mixer/t_mixer))
			add_underlay(T, turn(dir, -90))
		else
			add_underlay(T, turn(dir, -180))

		if(istype(src, /obj/structure/pipes/trinary/mixer/m_mixer) || istype(src, /obj/structure/pipes/trinary/mixer/t_mixer))
			add_underlay(T, turn(dir, 90))
		else
			add_underlay(T, turn(dir, -90))

		add_underlay(T, dir)

/obj/structure/pipes/trinary/mixer/hide(var/invis)
	update_underlays()


/obj/structure/pipes/trinary/mixer/t_mixer
	icon_state = "tmap"
	dir = SOUTH
	valid_directions = list(SOUTH, EAST, WEST)

/obj/structure/pipes/trinary/mixer/t_mixer/Initialize()
	. = ..()
	icon_state = "t"

/obj/structure/pipes/trinary/mixer/t_mixer/create_valid_directions()
	switch(dir)
		if(NORTH)
			valid_directions = list(EAST, NORTH, WEST)
		if(SOUTH)
			valid_directions = list(SOUTH, WEST, EAST)
		if(EAST)
			valid_directions = list(EAST, NORTH, SOUTH)
		if(WEST)
			valid_directions = list(WEST, NORTH, SOUTH)

/obj/structure/pipes/trinary/mixer/m_mixer
	icon_state = "mmap"
	dir = SOUTH
	valid_directions = list(SOUTH, NORTH, EAST)

/obj/structure/pipes/trinary/mixer/m_mixer/Initialize()
	. = ..()
	icon_state = "m"

/obj/structure/pipes/trinary/mixer/m_mixer/create_valid_directions()
	switch(dir)
		if(NORTH)
			valid_directions = list(WEST, NORTH, SOUTH)
		if(SOUTH)
			valid_directions = list(SOUTH, EAST, NORTH)
		if(EAST)
			valid_directions = list(EAST, WEST, NORTH)
		if(WEST)
			valid_directions = list(WEST, SOUTH, EAST)