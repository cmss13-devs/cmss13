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

	interior_map = /datum/map_template/interior/apc

	passengers_slots = 15
	xenos_slots = 8

	entrances = list(
		"left" = list(2, 0),
		"right" = list(-2, 0),
		"rear left" = list(1, 2),
		"rear center" = list(0, 2),
		"rear right" = list(-1, 2),
	)

	entrance_speed = 0.5 SECONDS

	required_skill = SKILL_VEHICLE_LARGE

	movement_sound = 'sound/vehicles/tank_driving.ogg'

	var/gunner_view_buff = 10

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
		VEHICLE_SUPPORT_GUNNER_TWO = null,
	)

	active_hp = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null,
		VEHICLE_SUPPORT_GUNNER_ONE = null,
		VEHICLE_SUPPORT_GUNNER_TWO = null,
	)

	vehicle_flags = VEHICLE_CLASS_LIGHT

	mob_size_required_to_hit = MOB_SIZE_XENO

	actions_list = list(
		"global" = list(
			/obj/vehicle/multitile/proc/get_status_info,
			/obj/vehicle/multitile/proc/open_controls_guide,
			/obj/vehicle/multitile/proc/name_vehicle,
		),
		VEHICLE_DRIVER = list(
			/obj/vehicle/multitile/proc/toggle_door_lock,
			/obj/vehicle/multitile/proc/activate_horn,
			/obj/vehicle/multitile/proc/use_megaphone,
		),
		VEHICLE_GUNNER = list(
			/obj/vehicle/multitile/proc/switch_hardpoint,
			/obj/vehicle/multitile/proc/cycle_hardpoint,
			/obj/vehicle/multitile/proc/toggle_shift_click,
		),
		VEHICLE_SUPPORT_GUNNER_ONE = list(
			/obj/vehicle/multitile/proc/reload_firing_port_weapon,
		),
		VEHICLE_SUPPORT_GUNNER_TWO = list(
			/obj/vehicle/multitile/proc/reload_firing_port_weapon,
		)
	)

	dmg_multipliers = list(
		"all" = 1,
		"acid" = 1.6,
		"slash" = 0.8,
		"bullet" = 0.6,
		"explosive" = 0.7,
		"blunt" = 0.7,
		"abstract" = 1
	)

	move_max_momentum = 2
	move_momentum_build_factor = 1.5
	move_turn_momentum_loss_factor = 0.8

	vehicle_ram_multiplier = VEHICLE_TRAMPLE_DAMAGE_APC_REDUCTION

/obj/vehicle/multitile/apc/Initialize()
	. = ..()

	var/turf/gotten_turf = get_turf(src)
	if(gotten_turf && gotten_turf.z)
		SSminimaps.add_marker(src, gotten_turf.z, MINIMAP_FLAG_USCM, "apc", 'icons/ui_icons/map_blips_large.dmi')

/obj/vehicle/multitile/apc/load_role_reserved_slots()
	var/datum/role_reserved_slots/RRS = new
	RRS.category_name = "Crewmen"
	RRS.roles = list(JOB_TANK_CREW, JOB_WO_CREWMAN, JOB_UPP_CREWMAN, JOB_PMC_CREWMAN)
	RRS.total = 2
	role_reserved_slots += RRS

	RRS = new
	RRS.category_name = "Synthetic Unit"
	RRS.roles = list(JOB_SYNTH, JOB_WO_SYNTH)
	RRS.total = 1
	role_reserved_slots += RRS

/obj/vehicle/multitile/apc/add_seated_verbs(mob/living/M, seat)
	if(!M.client)
		return
	add_verb(M.client, actions_list["global"])
	add_verb(M.client, actions_list[seat])

/obj/vehicle/multitile/apc/remove_seated_verbs(mob/living/M, seat)
	if(!M.client)
		return
	remove_verb(M.client, actions_list["global"])
	remove_verb(M.client, actions_list[seat])
	SStgui.close_user_uis(M, src)

/obj/vehicle/multitile/apc/initialize_cameras(change_tag = FALSE)
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
** PRESETS SPAWNERS
*/
//Transport version without FPWs
/obj/vehicle/multitile/apc/unarmed
	interior_map = /datum/map_template/interior/apc_no_fpw

/obj/effect/vehicle_spawner/apc
	name = "APC Spawner"
	icon = 'icons/obj/vehicles/apc.dmi'
	icon_state = "apc_base"
	pixel_x = -48
	pixel_y = -48

	vehicle_type = /obj/vehicle/multitile/apc/unarmed

	var/fpw = FALSE

//PRESET: no hardpoints
/obj/effect/vehicle_spawner/apc/spawn_vehicle(obj/vehicle/multitile/spawning)
	load_misc(spawning)
	if(fpw)
		load_fpw(spawning)
	load_hardpoints(spawning)
	handle_direction(spawning)
	spawning.update_icon()

//Installation of transport APC Firing Ports Weapons
/obj/effect/vehicle_spawner/apc/proc/load_fpw(obj/vehicle/multitile/spawning)//Here a lot of hardcode, and I don't want to mess with it
	var/obj/item/hardpoint/special/firing_port_weapon/fpw_hardpoint = new
	fpw_hardpoint.allowed_seat = VEHICLE_SUPPORT_GUNNER_ONE
	spawning.add_hardpoint(fpw_hardpoint)
	fpw_hardpoint.dir = turn(spawning.dir, 90)
	fpw_hardpoint.name = "Left "+ initial(fpw_hardpoint.name)
	fpw_hardpoint.origins = list(2, 0)
	fpw_hardpoint.muzzle_flash_pos = list(
		"1" = list(-18, 14),
		"2" = list(18, -42),
		"4" = list(34, 3),
		"8" = list(-32, -34)
	)

	fpw_hardpoint = new
	fpw_hardpoint.allowed_seat = VEHICLE_SUPPORT_GUNNER_TWO
	spawning.add_hardpoint(fpw_hardpoint)
	fpw_hardpoint.dir = turn(spawning.dir, -90)
	fpw_hardpoint.name = "Right "+ initial(fpw_hardpoint.name)
	fpw_hardpoint.origins = list(-2, 0)
	fpw_hardpoint.muzzle_flash_pos = list(
		"1" = list(16, 14),
		"2" = list(-18, -42),
		"4" = list(34, -34),
		"8" = list(-32, 2)
	)

//PRESET: only wheels installed
/obj/effect/vehicle_spawner/apc/plain
	hardpoints = list(
		/obj/item/hardpoint/locomotion/apc_wheels,
	)

//PRESET: default hardpoints, destroyed
/obj/effect/vehicle_spawner/apc/decrepit
	hardpoints = list(
		/obj/item/hardpoint/primary/dualcannon,
		/obj/item/hardpoint/secondary/frontalcannon,
		/obj/item/hardpoint/support/flare_launcher,
		/obj/item/hardpoint/locomotion/apc_wheels,
	)

/obj/effect/vehicle_spawner/apc/decrepit/spawn_vehicle(obj/vehicle/multitile/spawning)
	load_misc(spawning)
	if(fpw)
		load_fpw(spawning)
	load_hardpoints(spawning)
	handle_direction(spawning)
	load_damage(spawning)
	spawning.update_icon()

//PRESET: destroyed
/obj/effect/vehicle_spawner/apc/decrepit/empty
	hardpoints = list()

//PRESET: default hardpoints
/obj/effect/vehicle_spawner/apc/fixed
	hardpoints = list(
		/obj/item/hardpoint/primary/dualcannon,
		/obj/item/hardpoint/secondary/frontalcannon,
		/obj/item/hardpoint/support/flare_launcher,
		/obj/item/hardpoint/locomotion/apc_wheels,
	)

//fpw
/obj/effect/vehicle_spawner/apc/fpw
	vehicle_type = /obj/vehicle/multitile/apc
	fpw = TRUE

/obj/effect/vehicle_spawner/apc/plain/fpw
	vehicle_type = /obj/vehicle/multitile/apc
	fpw = TRUE

/obj/effect/vehicle_spawner/apc/decrepit/fpw
	vehicle_type = /obj/vehicle/multitile/apc
	fpw = TRUE

/obj/effect/vehicle_spawner/apc/decrepit/fpw/empty
	hardpoints = list()

/obj/effect/vehicle_spawner/apc/fixed/fpw
	vehicle_type = /obj/vehicle/multitile/apc
	fpw = TRUE
