/obj/vehicle/multitile/apc_pmc
	name = "M577-WY Armored Personnel Carrier"
	desc = "An M577 Armored Personnel Carrier. Designed for transporting forces of the W-Y PMCs. An armored transport with four big wheels. Entrances on the sides and back."

	icon = 'icons/obj/vehicles/apc_pmc.dmi'
	icon_state = "hull_wy"
	pixel_x = -48
	pixel_y = -48

	bound_width = 96
	bound_height = 96

	bound_x = -32
	bound_y = -32

	interior_map = /datum/map_template/interior/apc_pmc

	passengers_slots = 15
	xenos_slots = 8

	entrances = list(
		"left" = list(2, 0),
		"right" = list(-2, 0),
		"rear left" = list(1, 2),
		"rear center" = list(0, 2),
		"rear right" = list(-1, 2)
	)

	entrance_speed = 0.5 SECONDS

	required_skill = SKILL_VEHICLE_LARGE

	movement_sound = 'sound/vehicles/tank_driving.ogg'

	var/gunner_view_buff = 10

	hardpoints_allowed = list(
		/obj/item/hardpoint/primary/dualcannon/pmc,
		/obj/item/hardpoint/secondary/frontalcannon/pmc,
		/obj/item/hardpoint/support/flare_launcher,
		/obj/item/hardpoint/locomotion/apc_wheels/pmc,
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

/obj/vehicle/multitile/apc_pmc/Initialize()
	. = ..()

	var/turf/gotten_turf = get_turf(src)
	if(gotten_turf && gotten_turf.z)
		SSminimaps.add_marker(src, gotten_turf.z, MINIMAP_FLAG_USCM, "apc", 'icons/ui_icons/map_blips_large.dmi')

/obj/vehicle/multitile/apc_pmc/load_role_reserved_slots()
	var/datum/role_reserved_slots/RRS = new
	RRS.category_name = "Crewmen"
	RRS.roles = list(JOB_PMC_LEAD_INVEST, JOB_PMC_LEADER, JOB_WY_COMMANDO_LEADER, JOB_PMC_CREWMAN)
	RRS.total = 2
	role_reserved_slots += RRS

	RRS = new
	RRS.category_name = "Synthetic Unit"
	RRS.roles = list(JOB_PMC_SYNTH)
	RRS.total = 1
	role_reserved_slots += RRS

/obj/vehicle/multitile/apc_pmc/add_seated_verbs(mob/living/M, seat)
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
			/obj/vehicle/multitile/proc/name_vehicle
		))

	else if(seat == VEHICLE_SUPPORT_GUNNER_ONE || seat == VEHICLE_SUPPORT_GUNNER_TWO)
		add_verb(M.client, list(
			/obj/vehicle/multitile/proc/reload_firing_port_weapon
		))

/obj/vehicle/multitile/apc_pmc/remove_seated_verbs(mob/living/M, seat)
	if(!M.client)
		return
	remove_verb(M.client, list(
		/obj/vehicle/multitile/proc/get_status_info,
		/obj/vehicle/multitile/proc/open_controls_guide,
	))
	SStgui.close_user_uis(M, src)
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
			/obj/vehicle/multitile/proc/name_vehicle,
		))
	else if(seat == VEHICLE_SUPPORT_GUNNER_ONE || seat == VEHICLE_SUPPORT_GUNNER_TWO)
		remove_verb(M.client, list(
			/obj/vehicle/multitile/proc/reload_firing_port_weapon
		))

/obj/vehicle/multitile/apc_pmc/initialize_cameras(change_tag = FALSE)
	if(!camera)
		camera = new /obj/structure/machinery/camera/vehicle(src)
	if(change_tag)
		camera.c_tag = "#[rand(1,100)] M777-WY \"[nickname]\" APC"
		if(camera_int)
			camera_int.c_tag = camera.c_tag + " interior"
	else
		camera.c_tag = "#[rand(1,100)] M777-WY APC"
		if(camera_int)
			camera_int.c_tag = camera.c_tag + " interior"

/*
** PRESETS SPAWNERS
*/
/obj/effect/vehicle_spawner/apc_pmc
	name = "APC Transport Spawner"
	icon = 'icons/obj/vehicles/apc_pmc.dmi'
	icon_state = "hull_wy"
	pixel_x = -48
	pixel_y = -48

//Installation of transport APC Firing Ports Weapons
/obj/effect/vehicle_spawner/apc_pmc/proc/load_fpw(obj/vehicle/multitile/apc/V)
	var/obj/item/hardpoint/special/firing_port_weapon/FPW = new
	FPW.allowed_seat = VEHICLE_SUPPORT_GUNNER_ONE
	V.add_hardpoint(FPW)
	FPW.dir = turn(V.dir, 90)
	FPW.name = "Left "+ initial(FPW.name)
	FPW.origins = list(1, 0)
	FPW.muzzle_flash_pos = list(
		"1" = list(-18, 14),
		"2" = list(18, -42),
		"4" = list(34, 3),
		"8" = list(-32, -34)
	)

	FPW = new
	FPW.allowed_seat = VEHICLE_SUPPORT_GUNNER_TWO
	V.add_hardpoint(FPW)
	FPW.dir = turn(V.dir, -90)
	FPW.name = "Right "+ initial(FPW.name)
	FPW.origins = list(-1, 0)
	FPW.muzzle_flash_pos = list(
		"1" = list(16, 14),
		"2" = list(-18, -42),
		"4" = list(34, -34),
		"8" = list(-32, 2)
	)

/obj/effect/vehicle_spawner/apc_pmc/Initialize()
	. = ..()
	spawn_vehicle()
	qdel(src)

//PRESET: FPWs, no hardpoints
/obj/effect/vehicle_spawner/apc_pmc/spawn_vehicle()
	var/obj/vehicle/multitile/apc_pmc/APC = new (loc)

	load_misc(APC)
	load_fpw(APC)
	load_hardpoints(APC)
	handle_direction(APC)
	APC.update_icon()

//PRESET: FPWs, wheels installed
/obj/effect/vehicle_spawner/apc_pmc/plain/load_hardpoints(obj/vehicle/multitile/apc/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels/pmc)

//PRESET: default hardpoints, destroyed (this one spawns on VASRS elevatorfor VCs)
/obj/effect/vehicle_spawner/apc_pmc/decrepit/spawn_vehicle()
	var/obj/vehicle/multitile/apc_pmc/APC = new (loc)

	load_misc(APC)
	load_fpw(APC)
	load_hardpoints(APC)
	handle_direction(APC)
	load_damage(APC)
	APC.update_icon()

/obj/effect/vehicle_spawner/apc_pmc/decrepit/load_hardpoints(obj/vehicle/multitile/apc/V)
	V.add_hardpoint(new /obj/item/hardpoint/primary/dualcannon/pmc)
	V.add_hardpoint(new /obj/item/hardpoint/secondary/frontalcannon/pmc)
	V.add_hardpoint(new /obj/item/hardpoint/support/flare_launcher)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels/pmc)

//PRESET: FPWs, default hardpoints
/obj/effect/vehicle_spawner/apc_pmc/fixed/load_hardpoints(obj/vehicle/multitile/apc/V)
	V.add_hardpoint(new /obj/item/hardpoint/primary/dualcannon/pmc)
	V.add_hardpoint(new /obj/item/hardpoint/secondary/frontalcannon/pmc)
	V.add_hardpoint(new /obj/item/hardpoint/support/flare_launcher)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels/pmc)

//Transport version without FPWs

/obj/vehicle/multitile/apc_pmc/unarmed
	interior_map = /datum/map_template/interior/apc_no_fpw

//PRESET: no hardpoints
/obj/effect/vehicle_spawner/apc_pmc/unarmed/spawn_vehicle()
	var/obj/vehicle/multitile/apc_pmc/unarmed/APC = new (loc)

	load_misc(APC)
	load_hardpoints(APC)
	handle_direction(APC)
	APC.update_icon()

	return APC

/obj/effect/vehicle_spawner/apc_pmc/unarmed/load_hardpoints(obj/vehicle/multitile/apc/V)
	return

/obj/effect/vehicle_spawner/apc_pmc/unarmed/broken/spawn_vehicle()
	var/obj/vehicle/multitile/apc_pmc/apc = ..()
	load_damage(apc)
	apc.update_icon()

//PRESET: default hardpoints, destroyed
/obj/effect/vehicle_spawner/apc_pmc/unarmed/decrepit/spawn_vehicle()
	var/obj/vehicle/multitile/apc_pmc/unarmed/APC = new (loc)

	load_misc(APC)
	load_hardpoints(APC)
	handle_direction(APC)
	load_damage(APC)
	APC.update_icon()

/obj/effect/vehicle_spawner/apc_pmc/unarmed/decrepit/load_hardpoints(obj/vehicle/multitile/apc/V)
	V.add_hardpoint(new /obj/item/hardpoint/primary/dualcannon/pmc)
	V.add_hardpoint(new /obj/item/hardpoint/secondary/frontalcannon/pmc)
	V.add_hardpoint(new /obj/item/hardpoint/support/flare_launcher)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels/pmc)

//PRESET: no FPWs, wheels installed
/obj/effect/vehicle_spawner/apc_pmc/unarmed/plain/load_hardpoints(obj/vehicle/multitile/apc/unarmed/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels/pmc)

//PRESET: default hardpoints
/obj/effect/vehicle_spawner/apc_pmc/unarmed/fixed/load_hardpoints(obj/vehicle/multitile/apc/unarmed/V)
	V.add_hardpoint(new /obj/item/hardpoint/primary/dualcannon/pmc)
	V.add_hardpoint(new /obj/item/hardpoint/secondary/frontalcannon/pmc)
	V.add_hardpoint(new /obj/item/hardpoint/support/flare_launcher)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels/pmc)
