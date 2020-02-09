/obj/structure/interior_viewport
	name = "viewport"
	desc = "Hey, I can see my base from here!"
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "viewport"
	layer = INTERIOR_DOOR_LAYER

	unacidable = TRUE
	unslashable = TRUE
	indestructible = TRUE

	// The vehicle this seat is tied to
	var/obj/vehicle/multitile/vehicle = null

/obj/structure/interior_viewport/ex_act()
	return

/obj/structure/interior_viewport/attack_hand(var/mob/M)
	if(!vehicle)
		return

	M.set_interaction(vehicle)
	M.reset_view(vehicle)

// Landmark for spawning windows
/obj/effect/landmark/interior/spawn/interior_viewport
	name = "vehicle viewport spawner"
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "viewport"
	layer = INTERIOR_DOOR_LAYER

/obj/effect/landmark/interior/spawn/interior_viewport/on_load(var/datum/interior/I)
	var/obj/structure/interior_viewport/V = new(loc)

	V.vehicle = I.exterior
	V.pixel_x = pixel_x
	V.pixel_y = pixel_y
	V.alpha = alpha
	V.update_icon()

	qdel(src)
