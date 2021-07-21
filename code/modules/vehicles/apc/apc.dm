GLOBAL_LIST_EMPTY(command_apc_list)

/obj/vehicle/multitile/apc
	name = "\improper M577 Armored Personnel Carrier"
	desc = "A giant piece of armor with four big wheels, you know what to do. Entrance on the sides."

	icon = 'icons/obj/vehicles/apc.dmi'
	icon_state = "apc_base"
	pixel_x = -48
	pixel_y = -48

	bound_width = 96
	bound_height = 96

	bound_x = -32
	bound_y = -32

	interior_map = "apc"

	passengers_slots = 12
	xenos_slots = 8

	entrances = list(
		"left" = list(2, 0),
		"right" = list(-2, 0)
	)

	entrance_speed = 0.5

	required_skill = SKILL_VEHICLE_LARGE

	movement_sound = 'sound/vehicles/tank_driving.ogg'

	luminosity = 7

	hardpoints_allowed = list(
		/obj/item/hardpoint/primary/dualcannon,
		/obj/item/hardpoint/secondary/frontalcannon,
		/obj/item/hardpoint/support/flare_launcher,
		/obj/item/hardpoint/locomotion/apc_wheels
	)

	seats = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null
	)

	active_hp = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null
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

/obj/vehicle/multitile/apc/add_seated_verbs(var/mob/living/M, var/seat)
	if(!M.client)
		return
	add_verb(M.client, list(
		/obj/vehicle/multitile/proc/get_status_info,
		/obj/vehicle/multitile/proc/open_controls_guide,
		/obj/vehicle/multitile/proc/name_vehicle,
	))
	if(seat == VEHICLE_DRIVER)
		add_verb(M.client, list(
			/obj/vehicle/multitile/proc/toggle_door_lock,
			/obj/vehicle/multitile/proc/activate_horn,
		))
	else if(seat == VEHICLE_GUNNER)
		add_verb(M.client, list(
			/obj/vehicle/multitile/proc/switch_hardpoint,
			/obj/vehicle/multitile/proc/cycle_hardpoint,
			/obj/vehicle/multitile/proc/toggle_shift_click,
		))

/obj/vehicle/multitile/apc/remove_seated_verbs(var/mob/living/M, var/seat)
	if(!M.client)
		return
	remove_verb(M.client, list(
		/obj/vehicle/multitile/proc/get_status_info,
		/obj/vehicle/multitile/proc/open_controls_guide,
		/obj/vehicle/multitile/proc/name_vehicle,
	))
	if(seat == VEHICLE_DRIVER)
		remove_verb(M.client, list(
			/obj/vehicle/multitile/proc/toggle_door_lock,
			/obj/vehicle/multitile/proc/activate_horn,
		))
	else if(seat == VEHICLE_GUNNER)
		remove_verb(M.client, list(
			/obj/vehicle/multitile/proc/switch_hardpoint,
			/obj/vehicle/multitile/proc/cycle_hardpoint,
			/obj/vehicle/multitile/proc/toggle_shift_click,
		))

/obj/vehicle/multitile/apc/initialize_cameras(var/change_tag = FALSE)
	if(!camera_int)
		camera_int = new /obj/structure/machinery/camera/vehicle(src)
	if(change_tag)
		camera_int.c_tag = "#[rand(1,100)] M777 \"[nickname]\" APC"
	else
		camera_int.c_tag = "#[rand(1,100)] M777 APC"
/*
** PRESETS
*/

//apc spawner that spawns in an apc that's NOT eight kinds of awful, mostly for testing purposes
/obj/vehicle/multitile/apc/fixed/load_hardpoints(var/obj/vehicle/multitile/R)
	add_hardpoint(new /obj/item/hardpoint/primary/dualcannon)
	add_hardpoint(new /obj/item/hardpoint/secondary/frontalcannon)
	add_hardpoint(new /obj/item/hardpoint/support/flare_launcher)
	add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)

/obj/vehicle/multitile/apc/decrepit/load_hardpoints(var/obj/vehicle/multitile/R)
	add_hardpoint(new /obj/item/hardpoint/primary/dualcannon)
	add_hardpoint(new /obj/item/hardpoint/secondary/frontalcannon)
	add_hardpoint(new /obj/item/hardpoint/support/flare_launcher)
	add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)

/obj/vehicle/multitile/apc/decrepit/load_damage(var/obj/vehicle/multitile/R)
	take_damage_type(1e8, "abstract")
	take_damage_type(1e8, "abstract")
	healthcheck()

/obj/vehicle/multitile/apc/medical
	name = "\improper M577-MED Armored Personnel Carrier"
	desc = "A giant piece of armor with four big wheels and advanced medical equipment inside, you know what to do. Entrance on the sides."

	icon_state = "apc_base_med"

	interior_map = "apc_med"

	passengers_slots = 4

/obj/vehicle/multitile/apc/medical/load_role_reserved_slots()
	var/datum/role_reserved_slots/RRS = new
	RRS.category_name = "Crewmen"
	RRS.roles = list(JOB_CREWMAN, JOB_UPP_CREWMAN)
	RRS.total = 2
	role_reserved_slots += RRS

	RRS = new
	RRS.category_name = "Medical Support"
	RRS.roles = list(JOB_CMO, JOB_DOCTOR, JOB_RESEARCHER, JOB_WO_CMO, JOB_WO_DOCTOR, JOB_WO_RESEARCHER)
	RRS.total = 1
	role_reserved_slots += RRS

/obj/vehicle/multitile/apc/medical/decrepit/load_hardpoints(var/obj/vehicle/multitile/R)
	add_hardpoint(new /obj/item/hardpoint/primary/dualcannon)
	add_hardpoint(new /obj/item/hardpoint/secondary/frontalcannon)
	add_hardpoint(new /obj/item/hardpoint/support/flare_launcher)
	add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)

/obj/vehicle/multitile/apc/medical/decrepit/load_damage(var/obj/vehicle/multitile/R)
	take_damage_type(1e8, "abstract")
	take_damage_type(1e8, "abstract")
	healthcheck()

/obj/vehicle/multitile/apc/medical/fixed/load_hardpoints(var/obj/vehicle/multitile/R)
	add_hardpoint(new /obj/item/hardpoint/primary/dualcannon)
	add_hardpoint(new /obj/item/hardpoint/secondary/frontalcannon)
	add_hardpoint(new /obj/item/hardpoint/support/flare_launcher)
	add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)

/obj/vehicle/multitile/apc/command
	name = "\improper M577-CMD Armored Personnel Carrier"
	desc = "A giant piece of armor with four big wheels and a command station inside, you know what to do. Entrance on the sides."

	interior_map = "apc_command"

	passengers_slots = 8

	var/sensor_radius = 45	//45 tiles radius

/obj/vehicle/multitile/apc/command/Initialize()
	. = ..()
	GLOB.command_apc_list += src

/obj/vehicle/multitile/apc/command/Destroy()
	GLOB.command_apc_list -= src
	return ..()

/obj/vehicle/multitile/apc/command/load_role_reserved_slots()
	var/datum/role_reserved_slots/RRS = new
	RRS.category_name = "Crewmen"
	RRS.roles = list(JOB_CREWMAN, JOB_UPP_CREWMAN)
	RRS.total = 2
	role_reserved_slots += RRS

	RRS = new
	RRS.category_name = "Command Staff"
	RRS.roles = JOB_COMMAND_ROLES_LIST
	RRS.total = 1
	role_reserved_slots += RRS

/obj/vehicle/multitile/apc/command/decrepit/load_hardpoints(var/obj/vehicle/multitile/R)
	add_hardpoint(new /obj/item/hardpoint/primary/dualcannon)
	add_hardpoint(new /obj/item/hardpoint/secondary/frontalcannon)
	add_hardpoint(new /obj/item/hardpoint/support/flare_launcher)
	add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)

/obj/vehicle/multitile/apc/command/decrepit/load_damage(var/obj/vehicle/multitile/R)
	take_damage_type(1e8, "abstract")
	take_damage_type(1e8, "abstract")
	healthcheck()

/obj/vehicle/multitile/apc/command/fixed/load_hardpoints(var/obj/vehicle/multitile/R)
	add_hardpoint(new /obj/item/hardpoint/primary/dualcannon)
	add_hardpoint(new /obj/item/hardpoint/secondary/frontalcannon)
	add_hardpoint(new /obj/item/hardpoint/support/flare_launcher)
	add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)
