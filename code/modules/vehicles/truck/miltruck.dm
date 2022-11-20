/obj/vehicle/multitile/miltruck
	name = "Military truck"
	desc = "A rather new hunk of metal with some locomotion, you know what to do. Entrance on the sides."

	layer = ABOVE_XENO_LAYER
	vehicle_flags = VEHICLE_CLASS_WEAK

	icon = 'icons/obj/vehicles/miltruck.dmi'
	icon_state = "miltruck_1"
	pixel_x = -16
	pixel_y = -16

	bound_width = 64
	bound_height = 64

	bound_x = 0
	bound_y = 0


	interior_map = "truck"
	entrances = list(
		"left" = list(2, 0),
		"right" = list(-1, 0)
	)

	movement_sound = 'sound/vehicles/tank_driving.ogg'
	honk_sound = 'sound/vehicles/honk_2_truck.ogg'

	luminosity = 8

	move_max_momentum = 3
	move_turn_momentum_loss_factor = 1

	hardpoints_allowed = list(
		/obj/item/hardpoint/locomotion/van_wheels/miltruck,
		/obj/item/hardpoint/locomotion/treads/miltruck
	)

/obj/vehicle/multitile/miltruck/miltruck_2
	name = "Military truck"
	desc = "A rather new hunk of metal with some locomotion, you know what to do. Entrance on the sides."
	icon_state = "miltruck_2"

/obj/vehicle/multitile/miltruck/miltruck_3
	name = "Military truck"
	desc = "A rather new hunk of metal with some locomotion, you know what to do. Entrance on the back and sides."
	icon_state = "miltruck_3"
	interior_map = "van"
	passengers_slots = 8
	xenos_slots = 8
	entrances = list(
		"left" = list(2, 0),
		"right" = list(-1, 0),
		"back_left" = list(1, 2),
		"back_right" = list(0, 2)
	)

/*
** PRESETS SPAWNERS
*/

/obj/effect/vehicle_spawner/miltruck
	name = "Miltruck Spawner"
	icon = 'icons/obj/vehicles/miltruck.dmi'
	icon_state = "miltruck_1"
	pixel_x = -16
	pixel_y = -16

/obj/effect/vehicle_spawner/miltruck/Initialize()
	. = ..()
	spawn_vehicle()
	qdel(src)

	//PRESET: wheels installed, destroyed
/obj/effect/vehicle_spawner/miltruck/decrepit/spawn_vehicle()
	var/obj/vehicle/multitile/miltruck/MILTRUCK = new (loc)

	load_misc(MILTRUCK)
	load_hardpoints(MILTRUCK)
	handle_direction(MILTRUCK)
	load_damage(MILTRUCK)
	MILTRUCK.update_icon()