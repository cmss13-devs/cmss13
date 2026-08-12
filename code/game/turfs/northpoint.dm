// ------ Northpoint tiles ------ //

/turf/closed/wall/northpoint/quarantine
	name = "quarantine walls"
	icon = 'icons/turf/walls/northpoint_wall_yellow.dmi'
	icon_state = "Inflatable_interior"
	desc = "A thick and chunky quarantine wall. The surface is yellow and imposing."
	walltype = WALL_NORTHPOINT

/turf/closed/wall/northpoint/quarantine/reinforced
	icon_state = "Inflatable_interior_reinforced"
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/northpoint/quarantine/reinforced/hull
	icon_state = "Inflatable_interior_hull"
	desc = "A thick and chunky quarantine wall that is, just by virtue of its placement and imposing presence, entirely indestructible."
	turf_flags = TURF_HULL
