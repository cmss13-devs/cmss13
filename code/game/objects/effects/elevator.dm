/obj/effect/elevator/supply
	name = "\improper empty space"
	desc = "There seems to be an awful lot of machinery down below"
	icon = 'icons/effects/160x160.dmi'
	icon_state = "supply_elevator_lowered"
	unacidable = TRUE
	mouse_opacity = 0
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
	//blend_mode = BLEND_INSET_OVERLAY
	appearance_flags = KEEP_TOGETHER
	plane = FLOOR_PLANE
	layer = ABOVE_TURF_LAYER + 0.1 //uhmn uh uh um um

/obj/effect/elevator/supply/multi
	icon_state = "enter_darkness"
	plane = FLOOR_PLANE

/obj/effect/elevator/supply/multi/Initialize(mapload, ...)
	. = ..()

	var/area/my_area = get_area(src)
	icon_state = "supply_elevator_multi_[my_area.fake_zlevel]"

/obj/effect/elevator/supply/multi/create_clone_movable(shift_x, shift_y, layer_override)
	return null

/obj/effect/enter_darkness
	icon = 'icons/effects/160x160.dmi'
	icon_state = "enter_darkness"
	unacidable = TRUE
	mouse_opacity = 0
	layer = ABOVE_TURF_LAYER + 0.1
	blend_mode = BLEND_ADD

/obj/effect/elevator/supply/multi_shafted
	icon_state = "supply_elevator_multi_shafted"
	layer = UNDER_TURF_LAYER
	plane = FLOOR_PLANE

/obj/effect/elevator/supply/multi_shafted/Initialize(mapload, ...)
	. = ..()

	var/area/my_area = get_area(src)
	icon_state = "supply_elevator_multi_shafted_[my_area.fake_zlevel]"
