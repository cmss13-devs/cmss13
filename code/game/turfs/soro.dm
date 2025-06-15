// Soro Jungle

/turf/open/gm/dirt/brown
	name = "dirt"
	icon = 'icons/turf/floors/ground_map_dirt.dmi'
	icon_state = "desert"
	baseturfs = /turf/open/gm/dirt/brown
	minimap_color = MINIMAP_DIRT

/turf/open/gm/dirt/brown/variant_1
	icon_state = "desert0"

/turf/open/gm/dirt/brown/variant_2
	icon_state = "desert1"

/turf/open/gm/dirt/brown/variant_3
	icon_state = "desert2"

/turf/open/gm/dirt/brown/variant_5
	icon_state = "desert3"

/turf/open/gm/dirt/brown/variant_5/east
	dir = EAST

/turf/open/gm/dirt/brown/variant_5/south
	dir = SOUTH

/turf/open/gm/dirt/brown/variant_5/west
	dir = WEST

/turf/open/gm/dirt/brown/variant_6
	icon_state = "desert_dug"

/turf/open/gm/road
	name = "dirt road"
	icon = 'icons/turf/floors/ground_map_dirt.dmi'
	icon_state = "browndirt_road"
	baseturfs = /turf/open/gm/road
	minimap_color = MINIMAP_DIRT

/turf/open/gm/grass/dirt
	name = "grass"
	icon = 'icons/turf/floors/ground_map_dirt.dmi'
	icon_state = "grass1"
	baseturfs = /turf/open/gm/grass
	scorchable = "grass1"

/turf/open/gm/grass/dirt/grass2
	icon_state = "grass2"

/turf/open/gm/grass/dirt/grassbeach
	icon_state = "grassbeach"

/turf/open/gm/grass/dirt/grassbeach/north

/turf/open/gm/grass/dirt/grassbeach/south
	dir = 1

/turf/open/gm/grass/dirt/grassbeach/west
	dir = 4

/turf/open/gm/grass/dirt/grassbeach/east
	dir = 8

/turf/open/gm/grass/dirt/gbcorner/
	icon_state = "gbcorner"

/turf/open/gm/grass/dirt/gbcorner/north_west

/turf/open/gm/grass/dirt/gbcorner/south_east
	dir = 1

/turf/open/gm/grass/dirt/gbcorner/south_west
	dir = 4

/turf/open/gm/grass/dirt/gbcorner/north_east
	dir = 8

/turf/open/gm/coast/dirt
	name = "coastline"
	icon = 'icons/turf/floors/ground_map_dirt.dmi'
	icon_state = "beach"
	baseturfs = /turf/open/gm/coast
	supports_surgery = FALSE

/turf/open/gm/coast/dirt/north

/turf/open/gm/coast/dirt/south
	dir = 1

/turf/open/gm/coast/dirt/west
	dir = 4

/turf/open/gm/coast/dirt/east
	dir = 8

/turf/open/gm/coast/dirt/beachcorner
	icon_state = "beachcorner"

/turf/open/gm/coast/dirt/beachcorner/north_west

/turf/open/gm/coast/dirt/beachcorner/north_east
	dir = 1

/turf/open/gm/coast/dirt/beachcorner/south_east
	dir = 4

/turf/open/gm/coast/dirt/beachcorner/south_west
	dir = 8

/turf/open/gm/coast/dirt/beachcorner2
	icon_state = "beachcorner2"

/turf/open/gm/coast/dirt/beachcorner2/north_west

/turf/open/gm/coast/dirt/beachcorner2/north_east
	dir = 1

/turf/open/gm/coast/dirt/beachcorner2/south_west
	dir = 4

/turf/open/gm/coast/dirt/beachcorner2/south_east
	dir = 8

/turf/open/asphalt/brown
	name = "asphalt"
	icon = 'icons/turf/floors/ground_map_dirt.dmi'
	icon_state = "browndirt_road"
	baseturfs = /turf/open/asphalt

/turf/closed/wall/strata_ice/rock
	name = "rock wall"
	icon = 'icons/turf/walls/jungle_soro_rock_walls.dmi'
	icon_state = "strata_ice"
	desc = "A rough wall of hardened rock."
	walltype = WALL_STRATA_ICE //Not a metal wall
	turf_flags = TURF_HULL //Can't break this ice.

/turf/closed/wall/strata_ice/dirty/rock
	name = "rock wall"
	icon = 'icons/turf/walls/jungle_soro_rock_walls.dmi'
	icon_state = "strata_ice"
	desc = "A rough wall of hardened rock."
	icon_state = "strata_ice_dirty"
	walltype = WALL_STRATA_ICE_DIRTY

/turf/open/gm/river/soro
	icon = 'icons/turf/floors/ground_map_dirt.dmi'
