/obj/effect/decal/warning_stripes
	name = "warning stripes"
	icon = 'icons/effects/warning_stripes.dmi'
	layer = TURF_LAYER
	mouse_opacity = 0
/obj/effect/decal/warning_stripes/New()
	. = ..()

	loc.overlays += src
	qdel(src)

/obj/effect/decal/warning_stripes/asteroid
	icon_state = "warning"

/obj/effect/decal/sand_overlay
	name = "sandy edge"
	mouse_opacity = 0
	unacidable = 1
	icon = 'icons/turf/overlays.dmi'
	//layer = TURF_LAYER+0.5 //So it appears over other decals
	layer = TURF_LAYER

/obj/effect/decal/sand_overlay/New()
	. = ..()

	loc.overlays += image(icon, icon_state=icon_state, dir=dir)
	qdel(src)

/obj/effect/decal/sand_overlay/sand1
	icon_state = "sand1_s"
/obj/effect/decal/sand_overlay/sand1/corner1
	icon_state = "sand1_c"
/obj/effect/decal/sand_overlay/sand2
	icon_state = "sand2_s"
/obj/effect/decal/sand_overlay/sand2/corner2
	icon_state = "sand2_c"

/obj/effect/decal/halftile
	name = "half tile"
	icon_state = "halftile"

/obj/effect/decal/halftile/warning
	name = "warning stripes half tile"
	icon_state = "halftile_w"

/obj/effect/decal/siding
	name = "siding"
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "siding1"

/obj/effect/decal/siding/wood_siding
	name = "wood siding"
	icon_state = "wood_siding1"
