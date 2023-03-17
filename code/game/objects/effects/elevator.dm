/obj/effect/elevator/supply
	name = "\improper empty space"
	desc = "There seems to be an awful lot of machinery down below"
	icon = 'icons/effects/160x160.dmi'
	icon_state = "supply_elevator_lowered"
	unacidable = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_TURF_LAYER
	appearance_flags = KEEP_TOGETHER

/obj/effect/elevator/supply/ex_act(severity)
	return

/obj/effect/elevator/supply/Destroy(force)
	if(!force)
		return QDEL_HINT_LETMELIVE
	return ..()

/obj/effect/elevator/supply/visible_message() //Prevents message spam with empty elevator shaft - "The empty space falls into the depths!"
	return

/obj/effect/elevator/animation_overlay
	appearance_flags = KEEP_TOGETHER
	plane = FLOOR_PLANE
	layer = UNDER_TURF_LAYER

/obj/effect/elevator/animation_overlay/create_clone_movable(shift_x, shift_y, layer_override)
	return //NO CLONES OF THESE REEEEEE

/obj/effect/elevator/supply/multi
	icon_state = "enter_darkness"
	plane = FLOOR_PLANE
	layer = UNDER_TURF_LAYER -0.01
	appearance_flags = TILE_BOUND


/obj/effect/elevator/supply/multi/Initialize(mapload, ...)
	. = ..()

	var/area/my_area = get_area(src)
	icon_state = "supply_elevator_multi_[my_area.fake_zlevel]"
