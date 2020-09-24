/obj/effect/decal/medical_decals
	icon = 'icons/effects/medical_decals.dmi'
	layer = WEED_LAYER
	mouse_opacity = 0
	var/permanent = FALSE

/obj/effect/decal/medical_decals/Initialize()
	. = ..()
	if(!permanent)
		loc.overlays += image(icon, icon_state=icon_state, dir=dir, layer=layer)
		return INITIALIZE_HINT_QDEL

/obj/effect/decal/medical_decals/permanent
	anchored = TRUE
	permanent = TRUE

/obj/effect/decal/medical_decals/permanent/Initialize()
	. = ..()
	loc.overlays += src
