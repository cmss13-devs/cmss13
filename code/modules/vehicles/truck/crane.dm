/obj/vehicle/multitile/crane
	name = "crane"
	desc = "A rather cheap hunk of metal with some treads, you know what to do. Entrance on the left side. Also emergency exit on the back."

	layer = ABOVE_XENO_LAYER
	vehicle_flags = VEHICLE_CLASS_WEAK

	icon = 'icons/obj/vehicles/crane.dmi'
	icon_state = "crane"

	bound_width = 64
	bound_height = 64

	bound_x = 0
	bound_y = 0

	passengers_slots = 1
	xenos_slots = 1
	revivable_dead_slots = 1

	interior_map = /datum/map_template/interior/crane
	entrances = list(
		"left" = list(2, 1),
	)

	movement_sound = 'sound/vehicles/tank_driving.ogg'
	honk_sound = 'sound/vehicles/honk_2_truck.ogg'

	luminosity = 5

	move_max_momentum = 3
	move_momentum_build_factor = 1.8
	move_turn_momentum_loss_factor = 0.6

	hardpoints_allowed = list(
		/obj/item/hardpoint/locomotion/truck/treads/crane,
	)

/*
** PRESETS SPAWNERS
*/

/obj/effect/vehicle_spawner/crane
	name = "crane spawner"
	icon = 'icons/obj/vehicles/crane.dmi'
	icon_state = "crane"

/obj/effect/vehicle_spawner/crane/Initialize()
	. = ..()
	dir = pick(NORTH,SOUTH,EAST,WEST)
	spawn_vehicle()
	qdel(src)

	//PRESET: wheels installed, destroyed
/obj/effect/vehicle_spawner/crane/decrepit/spawn_vehicle()
	var/obj/vehicle/multitile/crane/CRANE = new (loc)

	load_misc(CRANE)
	load_hardpoints(CRANE)
	handle_direction(CRANE)
	load_damage(CRANE)
	CRANE.update_icon()

/obj/effect/vehicle_spawner/crane/decrepit/load_hardpoints(obj/vehicle/multitile/crane/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/truck/treads/crane)

	//PRESET: wheels installed
/obj/effect/vehicle_spawner/crane/fixed/spawn_vehicle()
	var/obj/vehicle/multitile/crane/CRANE = new (loc)

	load_misc(CRANE)
	load_hardpoints(CRANE)
	handle_direction(CRANE)
	CRANE.update_icon()

/obj/effect/vehicle_spawner/crane/fixed/load_hardpoints(obj/vehicle/multitile/crane/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/truck/treads/crane)

	//PRESET: random
/obj/effect/vehicle_spawner/crane/random/spawn_vehicle()
	var/obj/vehicle/multitile/crane/CRANE = new (loc)

	if (prob(50))
		load_hardpoints(CRANE)
	if (prob(50))
		load_damage(CRANE)
	load_misc(CRANE)
	handle_direction(CRANE)
	CRANE.update_icon()

/obj/effect/vehicle_spawner/crane/random/load_hardpoints(obj/vehicle/multitile/crane/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/truck/treads/crane)
