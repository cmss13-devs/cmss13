/obj/structure/pipes/multiz
	icon = 'icons/obj/pipes/pipes.dmi'
	icon_state = "cap"
	var/multiz_direction = UP

/obj/structure/pipes/multiz/search_for_connections()
	var/turf/possible_turf
	if(multiz_direction == UP)
		possible_turf = SSmapping.get_turf_above(loc)
	else
		possible_turf = SSmapping.get_turf_below(loc)

	if(possible_turf)
		for(var/obj/structure/pipes/multiz/connect in possible_turf.contents)
			if(multiz_direction == UP && connect.multiz_direction == DOWN || multiz_direction == DOWN && connect.multiz_direction == UP)
				connect.add_connection(src)
				add_connection(connect)
	. = ..()

/obj/structure/pipes/multiz/up
	multiz_direction = UP


/obj/structure/pipes/multiz/down
	multiz_direction = DOWN

/obj/structure/pipes/multiz/get_connection(direction)
	. = ..()
	if(.)
		return
	if(direction != reverse_direction(dir))
		return

	for(var/obj/structure/pipes/multiz/best_connected_pipe in connected_to)
		return best_connected_pipe

/obj/structure/pipes/multiz/create_valid_directions()
	valid_directions = list(dir, reverse_direction(dir))


