//Previous onborder walls had problems with getting in the way for a lot of things since they are located on same tile as interior.
//these are staying beyond the walking area and are not getting in the way of shots, spits and other stuff.

//for mapping
//INTERIOR_WALL_NORTH_LAYER 2.02
//INTERIOR_WALL_SOUTH_LAYER 5.2
/obj/structure/interior_wall
	name = "interior wall"
	desc = "An interior wall."
	icon = 'icons/obj/vehicles/interiors/tank.dmi'
	density = TRUE
	opacity = TRUE
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = INTERIOR_WALL_NORTH_LAYER
	flags_atom = NOINTERACT
	unacidable = TRUE
	unslashable = TRUE
	indestructible = TRUE

/obj/structure/interior_wall/get_projectile_hit_boolean(obj/item/projectile/P)
	return FALSE

/obj/structure/interior_wall/ex_act()
	return

//roof for small vehicles to emphasize small space

/obj/effect/vehicle_roof
	name = "interior roof"
	desc = "An interior roof."
	icon = 'icons/obj/vehicles/interiors/tank.dmi'
	density = FALSE
	opacity = FALSE
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_FLY_LAYER
	flags_atom = NOINTERACT
	unacidable = TRUE
	indestructible = TRUE

	alpha = 80

/obj/effect/vehicle_roof/get_projectile_hit_boolean(obj/item/projectile/P)
	return FALSE

/obj/effect/vehicle_roof/ex_act()
	return
