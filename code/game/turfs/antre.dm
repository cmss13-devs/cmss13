// ------ Antre tiles ------ //

/turf/open/antre
	name = "floor"
	icon = 'icons/turf/floors/antre_floors.dmi'
	icon_state = "antre"

/turf/open/antre/plating
	icon_state = "plating_catwalk"

/turf/open/antre/plating/alt
	icon_state = "plating_catwalk_alt"

/turf/open/antre/plating/direction_north
	icon_state = "plating_catwalk_north"

/turf/open/antre/plating/direction_north/east_edge
	icon_state = "plating_catwalk_north_e"

/turf/open/antre/plating/direction_north/west_edge
	icon_state = "plating_catwalk_north_w"

/turf/open/antre/plating/direction_north/south_edge
	icon_state = "plating_catwalk_north_s"

/turf/open/antre/plating/direction_north/north_edge
	icon_state = "plating_catwalk_north_n"

/turf/open/antre/plating/direction_west
	icon_state = "plating_catwalk_west"

/turf/open/antre/plating/direction_west/east_north
	icon_state = "plating_catwalk_west_n"

/turf/open/antre/plating/direction_west/west_south
	icon_state = "plating_catwalk_west_s"

/turf/open/antre/plating/direction_west/east_east
	icon_state = "plating_catwalk_west_e"

/turf/open/antre/plating/direction_west/west_west
	icon_state = "plating_catwalk_west_w"

/turf/open/antre/plating/corner_dir
	icon_state = "plating_catwalk_north_sw"

/turf/open/antre/plating/corner_dir/south_east
	icon_state = "plating_catwalk_north_se"

/turf/open/antre/plating/corner_dir/north_west
	icon_state = "plating_catwalk_north_nw"

/turf/open/antre/plating/corner_dir/north_east
	icon_state = "plating_catwalk_north_ne"

/turf/open/antre/plating/west_corner_dir
	icon_state = "plating_catwalk_west_sw"

/turf/open/antre/plating/west_corner_dir/south_east
	icon_state = "plating_catwalk_west_se"

/turf/open/antre/plating/west_corner_dir/north_west
	icon_state = "plating_catwalk_west_nw"

/turf/open/antre/plating/west_corner_dir/north_east
	icon_state = "plating_catwalk_west_ne"

// border

/obj/effect/antre/border
	name = "border"
	desc = null
	icon = 'icons/turf/floors/antre_floors.dmi'
	icon_state = "bridge_border"
	density = FALSE
	anchored = TRUE
	layer = ABOVE_TURF_LAYER
	plane = FLOOR_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/antre/border/corner
	icon_state = "bridge_border_corner"

/obj/effect/antre/border/edge
	icon_state = "bridge_border_edge"

