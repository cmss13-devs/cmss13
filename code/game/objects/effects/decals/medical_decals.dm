/obj/effect/decal/medical_decals
	icon = 'icons/effects/medical_decals.dmi'
	layer = WEED_LAYER
	mouse_opacity = 0

/obj/effect/decal/medical_decals/initialize()
	loc.overlays += image(icon, icon_state=icon_state, dir=dir, layer=layer)
	qdel(src)

/obj/effect/decal/medical_decals/permanent
	anchored = TRUE

/obj/effect/decal/medical_decals/permanent/initialize()
	loc.overlays += src
	return
