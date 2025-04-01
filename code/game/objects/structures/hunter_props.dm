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
	icon = 'icons/obj/structures/props/hunter/32x32_hunter_props.dmi'
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
	icon = 'icons/obj/structures/props/hunter/32x32_hunter_props.dmi'
	icon_state = "hunter_feed"
	desc = null
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_MOB_LAYER
	density = TRUE

/obj/structure/prop/hunter/misc/prop_armor
	name = "ancient yautja armor"
	icon = 'icons/obj/structures/props/hunter/32x32_hunter_props.dmi'
	icon_state = "hunter_armor_prop"
	desc = "An ancient suit of armor. It looks incredibly old, yet most likely still functional, although it's fixed to the wall, and purely used as a ceremonial adornment."
	anchored = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/prop/hunter/misc/prop_armor/elder
	icon_state = "hunter_armor_prop_2"

/obj/structure/prop/hunter/misc/prop_armor/elder_alt
	icon_state = "hunter_armor_prop_3"

/obj/structure/prop/hunter/misc/prop_armor/ancient
	icon_state = "hunter_armor_prop_4"

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

/obj/structure/bed/chair/hunter/throne
	name = "Throne of the Eternal Hunt"
	desc = "A grotesquely magnificent seat, carved from the remains of the most formidable prey. Twisted spines, shattered skulls, and serrated bones form a testament to the ancient hunter’s unchallenged supremacy. The throne whispers of countless battles, its macabre elegance a reminder that only the strongest may sit upon it."
	icon = 'icons/obj/structures/props/hunter/32x32_hunter_props.dmi'
	icon_state = "bone_throne"

/obj/structure/bed/chair/hunter/throne/top
	icon_state = "bone_throne_top"

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

/obj/structure/prop/hunter/fake_platform/hunter/stair_cut/hunter_left
	icon_state = "hunter_platform_stair"
	dir = NORTH

/obj/structure/prop/hunter/fake_platform/hunter/stair_cut/hunter_right
	icon_state = "hunter_platform_stair_alt"
	dir = NORTH

// Fake platform effect

/obj/effect/hunter/fake_platform/hunter
	icon = 'icons/obj/structures/props/platforms.dmi'
	icon_state = "hunter_platform"
	name = "raised metal edge"
	desc =  "A raised level of metal, often used to elevate areas above others, or construct bridges. You could probably climb it."
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/hunter/fake_platform/hunter/north
	dir = NORTH
/obj/effect/hunter/fake_platform/hunter/east
	dir = EAST
/obj/effect/hunter/fake_platform/hunter/west
	dir = WEST

// Fake Table Gear Rank for Trophies

/obj/structure/prop/hunter/trophy_display
	name = "\improper Yautja Trophy Display Rack"
	desc = "A trophy rack for hunters displaying their prizes."
	icon = 'icons/obj/structures/props/hunter/32x32_hunter_props.dmi'
	icon_state = "pred_trophy_vendor_top_left"
	layer = TABLE_LAYER
	throwpass = TRUE
	bound_width = 32
	bound_height = 32
	density = TRUE
	climbable = TRUE

/obj/structure/prop/hunter/trophy_display/bottom_left
	icon_state = "pred_trophy_vendor_bottom_left"

/obj/structure/prop/hunter/trophy_display/center
	icon_state = "pred_trophy_vendor_center"

/obj/structure/prop/hunter/trophy_display/top_center
	icon_state = "pred_trophy_vendor_top_center"

/obj/structure/prop/hunter/trophy_display/top_right
	icon_state = "pred_trophy_vendor_top_right"

/obj/structure/prop/hunter/trophy_display/bottom_right
	icon_state = "pred_trophy_vendor_bottom_right"

/obj/structure/prop/hunter/trophy_display/attackby(obj/item/attacking_item, mob/user, click_data)
	if(!user.drop_inv_item_to_loc(attacking_item, loc))
		return

	auto_align(attacking_item, click_data)
	user.next_move = world.time + 2
	return TRUE

/obj/structure/prop/hunter/trophy_display/proc/auto_align(obj/item/new_item, click_data)
	if(!new_item.center_of_mass) // Clothing, material stacks, generally items with large sprites where exact placement would be unhandy.
		new_item.pixel_x = rand(-new_item.randpixel, new_item.randpixel)
		new_item.pixel_y = rand(-new_item.randpixel, new_item.randpixel)
		new_item.pixel_z = 0
		return

	if(!click_data)
		return

	if(!click_data[ICON_X] || !click_data[ICON_Y])
		return

	// Calculation to apply new pixelshift.
	var/mouse_x = text2num(click_data[ICON_X])-1 // Ranging from 0 to 31
	var/mouse_y = text2num(click_data[ICON_Y])-1

	var/cell_x = clamp(floor(mouse_x/CELLSIZE), 0, CELLS-1) // Ranging from 0 to CELLS-1
	var/cell_y = clamp(floor(mouse_y/CELLSIZE), 0, CELLS-1)

	var/list/center = cached_key_number_decode(new_item.center_of_mass)

	new_item.pixel_x = (CELLSIZE * (cell_x + 0.5)) - center["x"]
	new_item.pixel_y = (CELLSIZE * (cell_y + 0.5)) - center["y"]
	new_item.pixel_z = 0
