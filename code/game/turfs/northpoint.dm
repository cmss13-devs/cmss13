// ------ Northpoint walls ------ //

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

/turf/closed/wall/northpoint/quarantine/alt
	icon = 'icons/turf/walls/northpoint_wall_white.dmi'

/turf/closed/wall/northpoint/quarantine/alt/reinforced
	icon_state = "Inflatable_interior_reinforced"
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/northpoint/quarantine/alt/reinforced/hull
	icon_state = "Inflatable_interior_hull"
	desc = "A thick and chunky quarantine wall that is, just by virtue of its placement and imposing presence, entirely indestructible."
	turf_flags = TURF_HULL

// -- Concrete Wall -- //

/turf/closed/wall/northpoint/concrete
	name = "concrete wall"
	desc = "A concrete wall"
	icon = 'icons/turf/walls/northpoint_wall_concrete.dmi'
	icon_state = "concrete"
	walltype = WALL_CONCRETE
	damage_cap = HEALTH_WALL

/turf/closed/wall/northpoint/concrete/reinforced
	desc = "A concrete wall. It also has some metal bars inside to reinforce it."
	damage_cap = HEALTH_WALL_REINFORCED
	icon_state = "concrete_reinforced"

/turf/closed/wall/northpoint/concrete/hull
	name = "concrete wall"
	desc = "A concrete wall. This one appears to be indestructable"
	icon_state = "concrete_hull"
	turf_flags = TURF_HULL
