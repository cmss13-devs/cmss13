/obj/vehicle/multitile/civvan
	name = "Civilian van"
	desc = "A rather cheap hunk of metal with some wheels, you know what to do. Entrance on the sides."

	layer = ABOVE_XENO_LAYER
	vehicle_flags = VEHICLE_CLASS_WEAK

	icon = 'icons/obj/vehicles/civvan.dmi'
	icon_state = "civvan"

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

	luminosity = 5

	move_max_momentum = 3
	move_turn_momentum_loss_factor = 1

	hardpoints_allowed = list(
		/obj/item/hardpoint/locomotion/van_wheels/civvan
	)

/*
** PRESETS SPAWNERS
*/

/obj/effect/vehicle_spawner/civvan
	name = "Civvan Spawner"
	icon = 'icons/obj/vehicles/civvan.dmi'
	icon_state = "civvan"

/obj/effect/vehicle_spawner/civvan/Initialize()
	. = ..()
	spawn_vehicle()
	qdel(src)

	//PRESET: wheels installed, destroyed
/obj/effect/vehicle_spawner/civvan/decrepit/spawn_vehicle()
	var/obj/vehicle/multitile/civvan/CIVVAN = new (loc)

	load_misc(CIVVAN)
	load_hardpoints(CIVVAN)
	handle_direction(CIVVAN)
	load_damage(CIVVAN)
	CIVVAN.update_icon()
