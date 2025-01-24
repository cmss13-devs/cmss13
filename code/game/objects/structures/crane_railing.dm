/obj/structure/roof/cargocrane_tracks
	name = "cargo crane track"
	desc = "A track for a cargo crane to move along."
	icon = 'icons/obj/structures/props/cargocrane_tracks.dmi'
	icon_state = "holder"
	mouse_opacity = FALSE
	layer = INTERIOR_ROOF_LAYER

/obj/structure/roof/cargocrane_tracks/Initialize()
	var/image/source_image = image(icon, icon_state = "[icon_state]-s")
	source_image.pixel_y = -32
	source_image.plane = FLOOR_PLANE
	source_image.layer = ANIMAL_HIDING_LAYER
	overlays += source_image

	return ..()

/obj/structure/roof/cargocrane_tracks/horizontal
	icon_state = "horizontal"

/obj/structure/roof/cargocrane_tracks/horizontal/endcap1
	icon_state = "horizontal_endcap1"

/obj/structure/roof/cargocrane_tracks/horizontal/endcap2
	icon_state = "horizontal_endcap2"

/obj/structure/roof/cargocrane_tracks/vertical
	icon_state = "vertical"

/obj/structure/roof/cargocrane_tracks/vertical/endcap1
	icon_state = "vertical_endcap1"

/obj/structure/roof/cargocrane_tracks/vertical/endcap2
	icon_state = "vertical_endcap2"

/obj/structure/roof/cargocrane_tracks/corner
	icon_state = "corner"

/obj/structure/roof/cargocrane_tracks/tjoint
	icon_state = "t-joint"

/obj/structure/roof/cargocrane_tracks/tjoint2
	icon_state = "t-joint2"

/obj/structure/roof/cargocrane_tracks/tjoint3
	icon_state = "t-joint3"

/obj/structure/roof/cargocrane_tracks/cross
	icon_state = "cross"
