/obj/vehicle/multitile/crane
	name = "Crane"
	desc = "A rather cheep hunk of metal with some treads, you know what to do. Entrance on the left side. Additional exit on the back"

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

	interior_map = "crane"
	entrances = list(
		"left" = list(2, 0),
	)

	movement_sound = 'sound/vehicles/tank_driving.ogg'
	honk_sound = 'sound/vehicles/honk_2_truck.ogg'

	luminosity = 5

	move_max_momentum = 3
	move_momentum_build_factor = 1.8
	move_turn_momentum_loss_factor = 0.6

	hardpoints_allowed = list(
		/obj/item/hardpoint/locomotion/treads/crane
	)

/*
** PRESETS SPAWNERS
*/

/obj/effect/vehicle_spawner/crane
	name = "Crane Spawner"
	icon = 'icons/obj/vehicles/crane.dmi'
	icon_state = "crane"

/obj/effect/vehicle_spawner/crane/Initialize()
	. = ..()
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