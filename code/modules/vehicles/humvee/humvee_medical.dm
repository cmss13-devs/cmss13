/obj/vehicle/multitile/humvee/medical
	name = "\improper M2421 JTMV-Ambulance"
	desc = "An M2421 JTMV-Ambulance. A lightly armored vehicle. Entrances on the back and sides."

	icon = 'icons/obj/vehicles/humvee_medical.dmi'
	icon_state = "humvee_base"
	pixel_x = -48
	pixel_y = -48

	bound_width = 64
	bound_height = 64

	bound_x = -32
	bound_y = -32

	health = 800

	interior_map = /datum/map_template/interior/humvee/humvee_medical

	passengers_slots = 3 // slightly more passenger slots to make up for the lack of other options.
	xenos_slots = 3

	misc_multipliers = list(
		"move" = 0.4, // slightly more speed to make up for the lack of other options.
		"accuracy" = 1,
		"cooldown" = 1
	)

	entrances = list(
		"right" = list(-2, -1),
		"left" = list(1, -1),
		"back left" = list(0, 1),
		"back right" = list(-1, 1),
	)

	entrance_speed = 0.5 SECONDS

	required_skill = SKILL_VEHICLE_LARGE

	movement_sound = 'sound/vehicles/tank_driving.ogg'
	honk_sound = 'sound/vehicles/honk_2_truck.ogg'

	luminosity = 8

	hardpoints_allowed = list(
		/obj/item/hardpoint/locomotion/humvee_wheels,
		/obj/item/hardpoint/armor/humvee_snowplow,
		/obj/item/hardpoint/special/humvee_overhead_lights
	)

	seats = list(
		VEHICLE_DRIVER = null,
	)

	active_hp = list(
		VEHICLE_DRIVER = null,
	)

	vehicle_flags = VEHICLE_CLASS_LIGHT

	mob_size_required_to_hit = MOB_SIZE_XENO

	dmg_multipliers = list(
		"all" = 1,
		"acid" = 1.8,
		"slash" = 1.1,
		"bullet" = 0.6,
		"explosive" = 0.8,
		"blunt" = 0.8,
		"abstract" = 1,
	)

	move_max_momentum = 2.2
	move_momentum_build_factor = 1.5
	move_turn_momentum_loss_factor = 0.8

	vehicle_ram_multiplier = VEHICLE_TRAMPLE_DAMAGE_APC_REDUCTION
	minimap_icon_state = "arc"

/obj/effect/vehicle_spawner/humvee/medical/Initialize()
	. = ..()
	spawn_vehicle()
	qdel(src)

/obj/effect/vehicle_spawner/humvee/medical/spawn_vehicle()
	var/obj/vehicle/multitile/humvee/medical/humvee = new (loc)

	load_misc(humvee)
	load_hardpoints(humvee)
	handle_direction(humvee)
	humvee.update_icon()

/obj/effect/vehicle_spawner/humvee/medical/load_hardpoints(obj/vehicle/multitile/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/humvee_wheels)
