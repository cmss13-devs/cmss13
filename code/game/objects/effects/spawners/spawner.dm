/obj/effect/spawner
	name = "object spawner"

/obj/effect/spawner/field_kit/Initialize(mapload)
	. = ..()
	new /obj/item/map/current_map(loc)
	return INITIALIZE_HINT_QDEL
