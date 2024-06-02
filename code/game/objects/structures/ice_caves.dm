//Replaces the turf versions to avoid multiturfing on the same tile
//----Ice walls Structure Versions----//
//Ice Thin Wall
/obj/structure/ice
	density = TRUE
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/ice/thin
	name = "thin ice wall"
	icon = 'icons/turf/walls/icewalllight.dmi'
	icon_state = "Single"
	desc = "It is very thin."
	opacity = FALSE

/obj/structure/ice/thin/indestructible/ex_act(severity, direction)
	return

/obj/structure/ice/thin/single
	icon_state = "Single"

/obj/structure/ice/thin/end
	icon_state = "End"

/obj/structure/ice/thin/straight
	icon_state = "Straight"

/obj/structure/ice/thin/corner
	icon_state = "Corner"

/obj/structure/ice/thin/junction
	icon_state = "T_Junction"

/obj/structure/ice/thin/intersection
	icon_state = "Intersection"


//Thin Ice Secret Wall
/turf/closed/ice/thin/secret
	desc = "There is something inside..."

/turf/closed/ice/thin/secret/single
	icon_state = "Single"

/turf/closed/ice/thin/secret/end
	icon_state = "End"

/turf/closed/ice/thin/secret/straight
	icon_state = "Straight"

/turf/closed/ice/thin/secret/corner
	icon_state = "Corner"

/turf/closed/ice/thin/secret/junction
	icon_state = "T-Junction"

/turf/closed/ice/thin/secret/intersection
	icon_state = "Intersection"

//ROCK WALLS------------------------------//
/obj/structure/ice/ice_rock
	name = "Icy rock"
	icon = 'icons/turf/walls/rockwall.dmi'

/obj/structure/ice/ice_rock/cornerOverlay
	icon_state = "corner_overlay"
