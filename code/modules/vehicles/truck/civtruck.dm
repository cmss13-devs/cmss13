/obj/vehicle/multitile/civtruck
	name = "civilian truck"
	desc = "A rather cheap hunk of metal with some wheels, you know what to do. Entrance on the sides."

	layer = ABOVE_XENO_LAYER
	vehicle_flags = VEHICLE_CLASS_WEAK

	icon = 'icons/obj/vehicles/civtruck.dmi'
	icon_state = "civtruck_1"

	bound_width = 64
	bound_height = 64

	bound_x = 0
	bound_y = 0


	interior_map = /datum/map_template/interior/truck
	entrances = list(
		"left" = list(2, 0),
		"right" = list(-1, 0)
	)

	movement_sound = 'sound/vehicles/tank_driving.ogg'

	luminosity = 6

	move_max_momentum = 3
	move_turn_momentum_loss_factor = 1

	hardpoints_allowed = list(
		/obj/item/hardpoint/locomotion/truck/wheels/civtruck,
	)

/obj/vehicle/multitile/civtruck/civtruck_2
	name = "civilian truck"
	icon_state = "civtruck_2"

/obj/vehicle/multitile/civtruck/civtruck_3
	name = "civilian truck"
	icon_state = "civtruck_3"

/*
** PRESETS SPAWNERS
*/

/obj/effect/vehicle_spawner/civtruck
	name = "civtruck spawner"
	icon = 'icons/obj/vehicles/civtruck.dmi'
	icon_state = "civtruck_1"

/obj/effect/vehicle_spawner/civtruck/random_vehicle()
	return pick(/obj/vehicle/multitile/civtruck,\
				/obj/vehicle/multitile/civtruck/civtruck_2,\
				/obj/vehicle/multitile/civtruck/civtruck_3)

/obj/effect/vehicle_spawner/civtruck/Initialize()
	. = ..()
	dir = pick(NORTH,SOUTH,EAST,WEST)
	spawn_vehicle()
	qdel(src)

	//PRESET: wheels installed, destroyed
/obj/effect/vehicle_spawner/civtruck/decrepit/spawn_vehicle()
	var/I = random_vehicle()
	var/obj/vehicle/multitile/CIVTRUCK = new I(loc)

	load_misc(CIVTRUCK)
	load_hardpoints(CIVTRUCK)
	handle_direction(CIVTRUCK)
	load_damage(CIVTRUCK)
	CIVTRUCK.update_icon()

/obj/effect/vehicle_spawner/civtruck/decrepit/load_hardpoints(obj/vehicle/multitile/civtruck/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/truck/wheels/civtruck)

	//PRESET: wheels installed
/obj/effect/vehicle_spawner/civtruck/fixed/spawn_vehicle()
	var/I = random_vehicle()
	var/obj/vehicle/multitile/CIVTRUCK = new I(loc)

	load_misc(CIVTRUCK)
	load_hardpoints(CIVTRUCK)
	handle_direction(CIVTRUCK)
	CIVTRUCK.update_icon()

/obj/effect/vehicle_spawner/civtruck/fixed/load_hardpoints(obj/vehicle/multitile/civtruck/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/truck/wheels/civtruck)

	//PRESET: random
/obj/effect/vehicle_spawner/civtruck/random/spawn_vehicle()
	var/I = random_vehicle()
	var/obj/vehicle/multitile/CIVTRUCK = new I(loc)

	if (prob(50))
		load_hardpoints(CIVTRUCK)
	if (prob(50))
		load_damage(CIVTRUCK)
	load_misc(CIVTRUCK)
	handle_direction(CIVTRUCK)
	CIVTRUCK.update_icon()

/obj/effect/vehicle_spawner/civtruck/random/load_hardpoints(obj/vehicle/multitile/civtruck/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/truck/wheels/civtruck)
