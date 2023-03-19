/obj/effect/landmark/supply_elevator/Initialize(mapload, ...)
	. = ..()
	GLOB.supply_elevator = get_turf(src)
	return INITIALIZE_HINT_QDEL
