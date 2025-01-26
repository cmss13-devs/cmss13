// Hunter props

/obj/structure/prop/hunter
	icon = 'icons/effects/64x96-hunter_effects.dmi'
	icon_state = "small_red"


/obj/effect/hunter/glowing_shape
	name = "glowing shape"
	desc = null
	icon = 'icons/effects/64x96-hunter_effects.dmi'
	icon_state = "big_red"
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	light_on = TRUE
	light_color ="#ff0000"
	light_power = 2
	light_range = 3

/obj/effect/hunter/glowing_shape/med_red_bottom
	icon_state = "med_red_bottom"

/obj/effect/hunter/glowing_shape/med_red_bottom_top
	icon_state = "med_red_bottom_top"

/obj/effect/hunter/glowing_shape/small_red
	icon_state = "small_red"

/obj/effect/hunter/glowing_shape/small_red_flipped
	icon_state = "small_red_flipped"

/obj/effect/hunter/bridge_border
	name = "border"
	desc = null
	icon = 'icons/effects/32x32-hunter_effects.dmi'
	icon_state = "bridge_border"
	density = FALSE
	anchored = TRUE
	layer = ABOVE_TURF_LAYER
	plane = FLOOR_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/hunter/bridge_border/corner
	icon_state = "bridge_border_corner"

/obj/effect/hunter/bridge_border/edge
	icon_state = "bridge_border_edge"

/obj/effect/hunter/bridge_border/small_stair_left
	icon_state = "small_stair_left"

/obj/effect/hunter/bridge_border/small_stair_right
	icon_state = "small_stair_right"

/obj/effect/hunter/bridge_border/brown
	icon_state = "bridge_brown_border"

/obj/effect/hunter/bridge_border/brown/edge
	icon_state = "bridge_border_brown_edge"

/obj/effect/hunter/bridge_border/brown/corner
	icon_state = "bridge_border_brown_corner"

/obj/effect/hunter/bridge_border/brown/small_stair_left
	icon_state = "small_stair_brown_left"

/obj/effect/hunter/bridge_border/brown/small_stair_right
	icon_state = "small_stair_brown_right"

/obj/effect/hunter/bridge_border/brown/small_stair
	icon_state = "small_stair"

/obj/effect/hunter/bridge_border/brown/large_stair
	icon_state = "large_stair"

// Catwalks

/obj/structure/prop/hunter/catwalk
	icon = 'icons/turf/floors/hunter_floors.dmi'
	icon_state = "hunter_catwalk_alpha"
	name = "catwalk"
	layer = CATWALK_LAYER
	desc = null

/obj/structure/prop/hunter/catwalk/hunter_catwalk_alt
	icon_state = "hunter_catwalk_alt_alpha"

/obj/structure/prop/hunter/catwalk/new_alpha
	icon_state = "hunter_catwalk_new_alpha"

/obj/structure/prop/hunter/catwalk/hunter_grille
	icon_state = "hunter_grille_alpha"

/obj/structure/prop/hunter/catwalk/hunter_grate
	icon_state = "hunter_grate_alpha"

/obj/structure/prop/hunter/catwalk/corner
	icon_state = "corner_1"

/obj/structure/prop/hunter/catwalk/corner/one
	icon_state = "corner_2"

/obj/structure/prop/hunter/catwalk/corner/two
	icon_state = "corner_3"

/obj/structure/prop/hunter/catwalk/corner/three
	icon_state = "corner_4"

/obj/structure/prop/hunter/catwalk/corner/four
	icon_state = "corner_5"

/obj/structure/prop/hunter/catwalk/corner/five
	icon_state = "corner_6"

/obj/structure/prop/hunter/catwalk/corner/six
	icon_state = "corner_7"

/obj/structure/prop/hunter/catwalk/corner/seven
	icon_state = "corner_8"

/obj/structure/prop/hunter/catwalk/corner/eight
	icon_state = "corner_9"

/obj/effect/hunter/catwalk
	icon = 'icons/turf/floors/hunter_floors.dmi'
	icon_state = "hunter_catwalk_alpha"
	desc = null
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/hunter/catwalk/hunter_catwalk_alt
	icon_state = "hunter_catwalk_alt_alpha"

/obj/effect/hunter/catwalk/new_alpha
	icon_state = "hunter_catwalk_new_alpha"

/obj/effect/hunter/catwalk/hunter_grille
	icon_state = "hunter_grille_alpha"

/obj/effect/hunter/catwalk/hunter_grate
	icon_state = "hunter_grate_alpha"

// Misc

/obj/structure/prop/hunter/stairs/border
	icon = 'icons/obj/structures/props/hunter/32x32-hunter_props.dmi'
	icon_state = "border_stairs"
	desc = null
	density = FALSE
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/structure/prop/hunter/stairs/border/rune
	icon_state = "border_stairs_rune"
	light_on = TRUE
	light_color ="#ff0000"
	light_power = 1
	light_range = 1

/obj/structure/prop/hunter/stairs/border/stair_cut
	icon_state = "border_stair_cut"

/obj/structure/prop/hunter/stairs/border/stair_cut/rune
	icon_state = "border_stair_rune_cut"
	light_on = TRUE
	light_color ="#ff0000"
	light_power = 1
	light_range = 1

/obj/structure/prop/hunter/misc/feed
	icon = 'icons/obj/structures/props/hunter/32x32-hunter_props.dmi'
	icon_state = "hunter_feed"
	desc = null
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_MOB_LAYER
	density = TRUE

/obj/effect/hunter/rune
	name = "rune"
	desc = null
	icon = 'icons/effects/32x32-hunter_effects.dmi'
	icon_state = "hunter_rune"
	density = FALSE
	anchored = TRUE
	layer = ABOVE_TURF_LAYER
	plane = FLOOR_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	light_on = TRUE
	light_color ="#ff0000"
	light_power = 1
	light_range = 1

/obj/effect/hunter/rune/corner
	icon_state = "hunter_rune_corner"

/obj/effect/hunter/rune/corner_2
	icon_state = "hunter_rune_corner_2"

/obj/effect/hunter/rune/small_arrow
	icon_state = "small_arrow"

/obj/effect/hunter/rune/stripes_arrow
	icon_state = "stripes_arrow"

// Fake platform

/obj/structure/prop/hunter/fake_platform/hunter
	icon = 'icons/obj/structures/props/platforms.dmi'
	icon_state = "hunter_platform"
	name = "raised metal edge"
	desc =  "A raised level of metal, often used to elevate areas above others, or construct bridges. You could probably climb it."
	density = FALSE
	anchored = TRUE
	layer = WEED_LAYER
	plane = FLOOR_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT


/obj/structure/prop/hunter/fake_platform/hunter/north
	dir = NORTH
/obj/structure/prop/hunter/fake_platform/hunter/east
	dir = EAST
/obj/structure/prop/hunter/fake_platform/hunter/west
	dir = WEST
