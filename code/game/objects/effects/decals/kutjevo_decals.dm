/obj/effect/decal/kutjevo_decals
	icon = 'icons/effects/kutjevo_decals.dmi'
	layer = TURF_LAYER

/obj/effect/decal/kutjevo_decals/New()
	. = ..()

	loc.overlays += src
	qdel(src)

/obj/effect/decal/kutjevo_decals/catwalk
	icon = 'icons/turf/floors/kutjevo/kutjevo_floor.dmi'
	icon_state = "catwalk"
	name = "catwalk"
	layer = CATWALK_LAYER
	desc = "These things have no depth to them, are they just, painted on?"