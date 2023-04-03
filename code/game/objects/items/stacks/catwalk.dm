/obj/item/stack/catwalk
	name = "catwalk mesh"
	singular_name = "catwalk mesh"
	desc = "Those could work as a pretty decent throwing weapon."
	icon = 'icons/turf/almayer.dmi'
	icon_state = "catwalk_tile"
	w_class = SIZE_MEDIUM
	force = 6
	throwforce = 8
	throw_speed = SPEED_VERY_FAST
	throw_range = 6
	flags_atom = FPRINT|CONDUCT
	max_amount = 60
	stack_id = "catwalk"

	var/turf_type = /turf/open/floor/plating/plating_catwalk

/obj/item/stack/catwalk/Initialize(mapload, amount, new_turf_type)
	. = ..()
	if(new_turf_type)
		set_turf_type(new_turf_type)

/obj/item/stack/catwalk/proc/set_turf_type(new_turf_type)
	var/turf/open/floor/floor_type = new_turf_type
	name = "[initial(floor_type.name)] tile"
	singular_name = name
	turf_type = new_turf_type
	stack_id = name

/obj/item/stack/catwalk/proc/build(turf/build_turf)
	build_turf.ChangeTurf(turf_type)
