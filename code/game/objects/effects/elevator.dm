/obj/effect/elevator/supply
	name = "\improper empty space"
	desc = "There seems to be an awful lot of machinery down below"
	icon = 'icons/effects/160x160.dmi'
	icon_state = "supply_elevator_lowered"
	unacidable = TRUE
	mouse_opacity = 0
	layer = ABOVE_TURF_LAYER

/obj/effect/elevator/supply/ex_act(severity)
	return

/obj/effect/elevator/supply/Destroy(force)
	if(!force)
		return QDEL_HINT_LETMELIVE
	return ..()
