/obj/vehicle/multitile/miltruck
	name = "military truck"
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


	interior_map = /datum/map_template/interior/truck
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
		/obj/item/hardpoint/locomotion/truck/wheels,
		/obj/item/hardpoint/locomotion/truck/treads,
	)

/obj/vehicle/multitile/miltruck/miltruck_2
	name = "military truck"
	desc = "A rather new hunk of metal with some locomotion, you know what to do. Entrance on the sides."
	icon_state = "miltruck_2"

/obj/vehicle/multitile/miltruck/miltruck_3
	name = "military truck"
	desc = "A rather new hunk of metal with some locomotion, you know what to do. Entrance on the back and sides."
	icon_state = "miltruck_3"
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
	name = "miltruck spawner"
	icon = 'icons/obj/vehicles/miltruck.dmi'
	icon_state = "miltruck_1"
	pixel_x = -16
	pixel_y = -16

/obj/effect/vehicle_spawner/miltruck/random_vehicle()
	return pick(/obj/vehicle/multitile/miltruck,\
				/obj/vehicle/multitile/miltruck/miltruck_2,\
				/obj/vehicle/multitile/miltruck/miltruck_3)

/obj/effect/vehicle_spawner/miltruck/random_hardpoint()
	return pick(/obj/item/hardpoint/locomotion/truck/wheels,\
				/obj/item/hardpoint/locomotion/truck/treads)

/obj/effect/vehicle_spawner/miltruck/Initialize()
	. = ..()
	dir = pick(NORTH,SOUTH,EAST,WEST)
	spawn_vehicle()
	qdel(src)

	//PRESET: wheels installed, destroyed
/obj/effect/vehicle_spawner/miltruck/decrepit/spawn_vehicle()
	var/I = random_vehicle()
	var/obj/vehicle/multitile/MILTRUCK = new I(loc)

	load_misc(MILTRUCK)
	load_hardpoints(MILTRUCK)
	handle_direction(MILTRUCK)
	load_damage(MILTRUCK)
	MILTRUCK.update_icon()

/obj/effect/vehicle_spawner/miltruck/decrepit/load_hardpoints(obj/vehicle/multitile/miltruck/V)
	var/H = random_hardpoint()
	V.add_hardpoint(new H)

	//PRESET: wheels installed
/obj/effect/vehicle_spawner/miltruck/fixed/spawn_vehicle()
	var/I = random_vehicle()
	var/obj/vehicle/multitile/MILTRUCK = new I(loc)

	load_misc(MILTRUCK)
	load_hardpoints(MILTRUCK)
	handle_direction(MILTRUCK)
	MILTRUCK.update_icon()

/obj/effect/vehicle_spawner/miltruck/fixed/load_hardpoints(obj/vehicle/multitile/miltruck/V)
	var/H = random_hardpoint()
	V.add_hardpoint(new H)

	//PRESET: random
/obj/effect/vehicle_spawner/miltruck/random/spawn_vehicle()
	var/I = random_vehicle()
	var/obj/vehicle/multitile/MILTRUCK = new I(loc)

	if (prob(50))
		load_hardpoints(MILTRUCK)
	if (prob(50))
		load_damage(MILTRUCK)
	load_misc(MILTRUCK)
	handle_direction(MILTRUCK)
	MILTRUCK.update_icon()

/obj/effect/vehicle_spawner/miltruck/random/load_hardpoints(obj/vehicle/multitile/miltruck/V)
	var/H = random_hardpoint()
	V.add_hardpoint(new H)
