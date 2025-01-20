/// This is an atmospherics pipe which can relay air up/down a deck.
/obj/structure/pipes/multiz
	name = "multi deck pipe adapter"
	desc = "An adapter which allows pipes to connect to other pipenets on different decks."
	icon = 'icons/obj/pipes/multiz.dmi'
	icon_state = "adapter"

	dir = SOUTH
	valid_directions = list(SOUTH)

	///Our central icon
	var/mutable_appearance/center = null
	///The pipe icon
	var/mutable_appearance/pipe = null
	///Reference to the node
	var/obj/structure/pipes/front_node = null

/* We use New() instead of Initialize() because these values are used in update_icon()
 * in the mapping subsystem init before Initialize() is called in the atoms subsystem init.
 * This is true for the other manifolds (the 4 ways and the heat exchanges) too.
 */
/obj/structure/pipes/multiz/New()
	icon_state = ""
	center = mutable_appearance(icon, "adapter", layer = layer)
	pipe = mutable_appearance(icon, "pipe")
	return ..()

/obj/structure/pipes/multiz/update_icon(safety = 0)
	..()

	if(!check_icon_cache())
		return

	alpha = 255

	overlays.Cut()
	overlays += pipe
	overlays += center
	overlays += icon_manager.get_atmos_icon("pipe", , front_node ? front_node.pipe_color : rgb(255, 255, 255), "intact")

///Attempts to locate a multiz pipe that's above us, if it finds one it merges us into its pipenet
/obj/structure/pipes/multiz/get_connection()
	var/turf/local_turf = get_turf(src)
	for(var/obj/structure/pipes/multiz/above in SSmapping.get_turf_above(local_turf))
		connected_to += above
		above.connected_to += src //Two way travel :)
	for(var/obj/structure/pipes/multiz/below in SSmapping.get_turf_below(local_turf))
		below.get_connection() //If we've got one below us, force it to add us on facebook
	return ..()
