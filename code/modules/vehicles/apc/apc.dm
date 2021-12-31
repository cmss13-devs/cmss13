GLOBAL_LIST_EMPTY(command_apc_list)

/obj/vehicle/multitile/apc
	name = "M577 Armored Personnel Carrier"
	desc = "An M577 Armored Personnel Carrier. An armored transport with four big wheels. Entrances on the sides and back."

	icon = 'icons/obj/vehicles/apc.dmi'
	icon_state = "apc_base"
	pixel_x = -48
	pixel_y = -48

	bound_width = 96
	bound_height = 96

	bound_x = -32
	bound_y = -32

	interior_map = "apc"

	passengers_slots = 15
	xenos_slots = 8

	entrances = list(
		"left" = list(2, 0),
		"right" = list(-2, 0),
		"rear left" = list(1, 2),
		"rear center" = list(0, 2),
		"rear right" = list(-1, 2)
	)

	entrance_speed = 0.5

	required_skill = SKILL_VEHICLE_LARGE

	movement_sound = 'sound/vehicles/tank_driving.ogg'

	luminosity = 7

	hardpoints_allowed = list(
		/obj/item/hardpoint/primary/dualcannon,
		/obj/item/hardpoint/secondary/frontalcannon,
		/obj/item/hardpoint/support/flare_launcher,
		/obj/item/hardpoint/locomotion/apc_wheels,
	)

	seats = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null,
		VEHICLE_SUPPORT_GUNNER_ONE = null,
		VEHICLE_SUPPORT_GUNNER_TWO = null
	)

	active_hp = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null,
		VEHICLE_SUPPORT_GUNNER_ONE = null,
		VEHICLE_SUPPORT_GUNNER_TWO = null
	)

	vehicle_flags = VEHICLE_CLASS_LIGHT

	mob_size_required_to_hit = MOB_SIZE_XENO

	dmg_multipliers = list(
		"all" = 1,
		"acid" = 1.5,
		"slash" = 0.7,
		"bullet" = 0.6,
		"explosive" = 0.9,
		"blunt" = 0.9,
		"abstract" = 1.0
	)

	move_max_momentum = 2
	move_momentum_build_factor = 1.5
	move_turn_momentum_loss_factor = 0.8

	vehicle_ram_multiplier = VEHICLE_TRAMPLE_DAMAGE_APC_REDUCTION

/obj/vehicle/multitile/apc/load_role_reserved_slots()
	var/datum/role_reserved_slots/RRS = new
	RRS.category_name = "Crewmen"
	RRS.roles = list(JOB_CREWMAN, JOB_UPP_CREWMAN)
	RRS.total = 2
	role_reserved_slots += RRS

	RRS = new
	RRS.category_name = "Synthetic Unit"
	RRS.roles = list(JOB_SYNTH, JOB_WO_SYNTH)
	RRS.total = 1
	role_reserved_slots += RRS

/obj/vehicle/multitile/apc/add_seated_verbs(var/mob/living/M, var/seat)
	if(!M.client)
		return
	add_verb(M.client, list(
		/obj/vehicle/multitile/proc/get_status_info,
		/obj/vehicle/multitile/proc/open_controls_guide
	))
	if(seat == VEHICLE_DRIVER)
		add_verb(M.client, list(
			/obj/vehicle/multitile/proc/toggle_door_lock,
			/obj/vehicle/multitile/proc/activate_horn,
			/obj/vehicle/multitile/proc/name_vehicle
		))
	else if(seat == VEHICLE_GUNNER)
		add_verb(M.client, list(
			/obj/vehicle/multitile/proc/switch_hardpoint,
			/obj/vehicle/multitile/proc/cycle_hardpoint,
			/obj/vehicle/multitile/proc/toggle_shift_click,
			/obj/vehicle/multitile/proc/name_vehicle
		))

	else if(seat == VEHICLE_SUPPORT_GUNNER_ONE || seat == VEHICLE_SUPPORT_GUNNER_TWO)
		add_verb(M.client, list(
			/obj/vehicle/multitile/proc/reload_firing_port_weapon
		))

/obj/vehicle/multitile/apc/remove_seated_verbs(var/mob/living/M, var/seat)
	if(!M.client)
		return
	remove_verb(M.client, list(
		/obj/vehicle/multitile/proc/get_status_info,
		/obj/vehicle/multitile/proc/open_controls_guide,
	))
	if(seat == VEHICLE_DRIVER)
		remove_verb(M.client, list(
			/obj/vehicle/multitile/proc/toggle_door_lock,
			/obj/vehicle/multitile/proc/activate_horn,
			/obj/vehicle/multitile/proc/name_vehicle,
		))
	else if(seat == VEHICLE_GUNNER)
		remove_verb(M.client, list(
			/obj/vehicle/multitile/proc/switch_hardpoint,
			/obj/vehicle/multitile/proc/cycle_hardpoint,
			/obj/vehicle/multitile/proc/toggle_shift_click,
			/obj/vehicle/multitile/proc/name_vehicle,
		))
	else if(seat == VEHICLE_SUPPORT_GUNNER_ONE || seat == VEHICLE_SUPPORT_GUNNER_TWO)
		remove_verb(M.client, list(
			/obj/vehicle/multitile/proc/reload_firing_port_weapon
		))

/obj/vehicle/multitile/apc/initialize_cameras(var/change_tag = FALSE)
	if(!camera)
		camera = new /obj/structure/machinery/camera/vehicle(src)
	if(change_tag)
		camera.c_tag = "#[rand(1,100)] M777 \"[nickname]\" APC"
		if(camera_int)
			camera_int.c_tag = camera.c_tag + " interior"
	else
		camera.c_tag = "#[rand(1,100)] M777 APC"
		if(camera_int)
			camera_int.c_tag = camera.c_tag + " interior"

/*
** PRESETS
*/

//apc spawner that spawns in an apc that's NOT eight kinds of awful, mostly for testing purposes
/obj/vehicle/multitile/apc/fixed/load_hardpoints(var/obj/vehicle/multitile/R)
	var/obj/item/hardpoint/special/firing_port_weapon/FPW = new
	FPW.allowed_seat = VEHICLE_SUPPORT_GUNNER_ONE
	add_hardpoint(FPW)
	FPW.dir = turn(dir, 90)
	FPW.origins = list(2, 0)

	FPW = new
	FPW.allowed_seat = VEHICLE_SUPPORT_GUNNER_TWO
	add_hardpoint(FPW)
	FPW.dir = turn(dir, -90)
	FPW.origins = list(-2, 0)

	add_hardpoint(new /obj/item/hardpoint/primary/dualcannon)
	add_hardpoint(new /obj/item/hardpoint/secondary/frontalcannon)
	add_hardpoint(new /obj/item/hardpoint/support/flare_launcher)
	add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)

/obj/vehicle/multitile/apc/decrepit/load_hardpoints(var/obj/vehicle/multitile/R)
	var/obj/item/hardpoint/special/firing_port_weapon/FPW = new
	FPW.allowed_seat = VEHICLE_SUPPORT_GUNNER_ONE
	add_hardpoint(FPW)
	FPW.dir = turn(dir, 90)
	FPW.origins = list(2, 0)

	FPW = new
	FPW.allowed_seat = VEHICLE_SUPPORT_GUNNER_TWO
	add_hardpoint(FPW)
	FPW.dir = turn(dir, -90)
	FPW.origins = list(-2, 0)

	add_hardpoint(new /obj/item/hardpoint/primary/dualcannon)
	add_hardpoint(new /obj/item/hardpoint/secondary/frontalcannon)
	add_hardpoint(new /obj/item/hardpoint/support/flare_launcher)
	add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)

/obj/vehicle/multitile/apc/decrepit/load_damage(var/obj/vehicle/multitile/R)
	take_damage_type(1e8, "abstract")
	take_damage_type(1e8, "abstract")
	healthcheck()

/obj/vehicle/multitile/apc/plain/load_hardpoints(var/obj/vehicle/multitile/R)
	var/obj/item/hardpoint/special/firing_port_weapon/FPW = new
	FPW.allowed_seat = VEHICLE_SUPPORT_GUNNER_ONE
	add_hardpoint(FPW)
	FPW.dir = turn(dir, 90)
	FPW.origins = list(2, 0)

	FPW = new
	FPW.allowed_seat = VEHICLE_SUPPORT_GUNNER_TWO
	add_hardpoint(FPW)
	FPW.dir = turn(dir, -90)
	FPW.origins = list(-2, 0)

	add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)

/obj/vehicle/multitile/apc/plain_no_fpw/load_hardpoints(var/obj/vehicle/multitile/R)
	add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)

/obj/vehicle/multitile/apc/plain_fpw_no_wheels/load_hardpoints(var/obj/vehicle/multitile/R)
	var/obj/item/hardpoint/special/firing_port_weapon/FPW = new
	FPW.allowed_seat = VEHICLE_SUPPORT_GUNNER_ONE
	add_hardpoint(FPW)
	FPW.dir = turn(dir, 90)
	FPW.origins = list(2, 0)

	FPW = new
	FPW.allowed_seat = VEHICLE_SUPPORT_GUNNER_TWO
	add_hardpoint(FPW)
	FPW.dir = turn(dir, -90)
	FPW.origins = list(-2, 0)
