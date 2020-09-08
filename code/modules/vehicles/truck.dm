
//Trucks
//Read the documentation in multitile.dm before trying to decipher this stuff

/obj/vehicle/multitile/truck
	name = "\improper MUTT-4M7 Multipurpose Truck"
	desc = "A rather old hunk of metal with four wheels, you know what to do. Entrance on the back and sides."

	icon = 'icons/obj/vehicles/truck.dmi'
	icon_state = "truck_base"
	pixel_x = -16
	pixel_y = -16

	bound_width = 64
	bound_height = 64

	bound_x = 0
	bound_y = 0

	interior_map = "truck"
	entrances = list(
		"left" = list(2, 0),
		"right" = list(-1, 0),
		"back_left" = list(1, 2),
		"back_right" = list(0, 2)
	)

	movement_sound = 'sound/vehicles/tank_driving.ogg'

	luminosity = 4

	hardpoints_allowed = list(
		/obj/item/hardpoint/locomotion/truck_wheels,
		/obj/item/hardpoint/locomotion/truck_treads)

	hardpoints = list(
		HDPT_SUPPORT = null,
		HDPT_WHEELS = null
	)

/obj/structure/interior_wall/truck
	name = "truck interior wall"
	desc = "An interior wall."
	icon = 'icons/obj/vehicles/interiors/truck.dmi'
	icon_state = "truck_right_1"
	density = 1
	opacity = 1
	anchored = 1
	mouse_opacity = 0
	layer = WINDOW_LAYER
	flags_atom = ON_BORDER|NOINTERACT
	unacidable = TRUE

/*
** PRESETS
*/

//truck spawner that spawns in an truck that's NOT eight kinds of awful, mostly for testing purposes
/obj/vehicle/multitile/truck/fixed/load_hardpoints(var/obj/vehicle/multitile/R)
	add_hardpoint(new /obj/item/hardpoint/locomotion/truck_wheels)

/obj/vehicle/multitile/truck/decrepit/load_damage(var/obj/vehicle/multitile/R)
	take_damage_type(1e8, "abstract") //OOF.ogg
