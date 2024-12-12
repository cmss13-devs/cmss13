//------------------------------------------
//Block
//------------------------------------------

/obj/effect/block //color is white by default, set to whatever is needed
	name = "blocking glow"
	icon_state = "block"
	color = COLOR_YELLOW
	duration = 6.7

/obj/effect/temp_visual/block/Initialize(mapload)
	. = ..()
	pixel_x = rand(-12, 12)
	pixel_y = rand(-9, 0)
