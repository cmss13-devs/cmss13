/* Diffrent misc types of tiles
 * Contains:
 *		Grass
 *		Wood
 *		Carpet
 */

/obj/item/stack/tile
	name = "abstract tile"
	singular_name = "abstract tile"
	desc = "If you're seeing this, then a Dev made a mistake. Report it on Github."
	w_class = SIZE_MEDIUM
	force = 1.0
	throwforce = 1.0
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	max_amount = 60
	stack_id = "abstract tile"

	var/turf_type = /turf/open/floor/plating

/obj/item/stack/tile/Initialize(mapload, amount, var/new_turf_type)
	. = ..()
	if(new_turf_type)
		set_turf_type(new_turf_type)

/obj/item/stack/tile/proc/set_turf_type(var/new_turf_type)
	var/turf/open/floor/floor_type = new_turf_type
	name = "[initial(floor_type.name)] tile"
	singular_name = name
	turf_type = new_turf_type
	stack_id = name

/obj/item/stack/tile/proc/build(var/turf/build_turf)
	build_turf.ChangeTurf(turf_type)

/obj/item/stack/tile/plasteel
	name = "floor tile"
	singular_name = "floor tile"
	desc = "Those could work as a pretty decent throwing weapon."
	icon_state = "tile"
	w_class = SIZE_MEDIUM
	force = 6.0
	matter = list("metal" = 937.5)
	throwforce = 8.0
	throw_speed = SPEED_VERY_FAST
	throw_range = 6
	flags_atom = FPRINT|CONDUCT
	max_amount = 60
	stack_id = "floor tile"
	turf_type = null

/obj/item/stack/tile/plasteel/Initialize(mapload, amount)
	. = ..()
	src.pixel_x = rand(1, 14)
	src.pixel_y = rand(1, 14)

/obj/item/stack/tile/plasteel/build(turf/build_turf)
	build_turf.ChangeTurf(turf_type || /turf/open/floor)

/*
 * Grass
 */
/obj/item/stack/tile/grass
	name = "grass patch tile"
	desc = "A patch of grass like they often use on golf courses."
	singular_name = "grass patch tile"
	icon_state = "tile_grass"
	stack_id = "grass patch tile"
	turf_type = /turf/open/floor/grass


/*
 * Wood
 */
/obj/item/stack/tile/wood
	name = "wooden floor tile"
	desc = "An easy to fit wooden floor tile."
	singular_name = "wooden floor tile"
	icon_state = "tile-wood"
	stack_id = "wooden floor tile"
	turf_type = /turf/open/floor/wood

/obj/item/stack/tile/wood/fake
	name = "fake wooden floor tile"
	desc = "Looks like wood. Feels like metal."
	singular_name = "fake wooden floor tile"
	stack_id = "fake wooden floor tile"
	turf_type = /turf/open/floor/wood/ship

/*
 * Carpets
 */
/obj/item/stack/tile/carpet
	name = "carpet tile"
	desc = "A piece of carpet. It is the same size as a normal floor tile!"
	singular_name = "carpet tile"
	icon_state = "tile-carpet"
	stack_id = "carpet tile"
	turf_type = /turf/open/floor/carpet
