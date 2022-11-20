/obj/vehicle/multitile/civtruck
	name = "Civilian truck"
	desc = "A rather cheep hunk of metal with some wheels, you know what to do. Entrance on the sides."

	layer = ABOVE_XENO_LAYER
	vehicle_flags = VEHICLE_CLASS_WEAK

	icon = 'icons/obj/vehicles/civtruck.dmi'
	icon_state = "civtruck_1"

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

	luminosity = 6

	move_max_momentum = 3
	move_turn_momentum_loss_factor = 1

	hardpoints_allowed = list(
		/obj/item/hardpoint/locomotion/van_wheels/civtruck
	)

/obj/vehicle/multitile/civtruck/civtruck_2
	name = "Civilian truck"
	icon_state = "civtruck_2"

/obj/vehicle/multitile/civtruck/civtruck_3
	name = "Civilian truck"
	icon_state = "civtruck_3"

/*
** PRESETS SPAWNERS
*/

/obj/effect/vehicle_spawner/civtruck
	name = "Civtruck Spawner"
	icon = 'icons/obj/vehicles/civtruck.dmi'
	icon_state = "civtruck_1"

/obj/effect/vehicle_spawner/civtruck/Initialize()
	. = ..()
	spawn_vehicle()
	qdel(src)

	//PRESET: wheels installed, destroyed
/obj/effect/vehicle_spawner/civtruck/decrepit/spawn_vehicle()
	var/obj/vehicle/multitile/civtruck/CIVTRUCK = new (loc)

	load_misc(CIVTRUCK)
	load_hardpoints(CIVTRUCK)
	handle_direction(CIVTRUCK)
	load_damage(CIVTRUCK)
	CIVTRUCK.update_icon()