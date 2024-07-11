/turf/open/floor/glass
	name = "glass floor"
	desc = "Don't jump on it, or do, I'm not your mom."
	icon = 'icons/turf/floors/glass.dmi'
	icon_state = "glass"
	base_icon = "glass"
//	baseturfs = /turf/open/openspace

/turf/open/floor/glass/Initialize(mapload)
	icon_state = "" //Prevent the normal icon from appearing behind the smooth overlays
	turf_flags |= TURF_TRANSPARENT
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/turf/open/floor/glass/LateInitialize()
	. = ..()
	handle_transpare_turf()

/turf/open/floor/glass/reinforced
	name = "reinforced glass floor"
	desc = "Do jump on it, it can take it."
	icon = 'icons/turf/floors/reinf_glass.dmi'
	icon_state = "reinf_glass"
	base_icon = "reinf_glass"
