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

	movement_sound = 'sound/vehicles/box_van_driving.ogg'
	engine_soundloop_type = /datum/looping_sound/tank_engine/apc

	var/gunner_view_buff = 10

	engine_on = FALSE

	uses_gear_transmission = TRUE
	current_gear = "P"
	top_speed = 3.5
	base_acceleration = 1
	base_fuel_use = 0.268

	hull_cookoff_exterior_power = 100
	hull_cookoff_exterior_falloff = 14
	hull_cookoff_interior_power = 200
	hull_cookoff_interior_falloff = 80

	hardpoints_allowed = list(
		/obj/item/hardpoint/primary/dualcannon/pmc,
		/obj/item/hardpoint/secondary/frontalcannon/pmc,
		/obj/item/hardpoint/support/flare_launcher,
		/obj/item/hardpoint/locomotion/apc_wheels/pmc,
		/obj/item/hardpoint/engine/apc,
		/obj/item/hardpoint/fuel_tank/uscm,
		/obj/item/hardpoint/radiator/uscm,
		/obj/item/hardpoint/battery/uscm,
		/obj/item/hardpoint/iff_module/uscm,
		/obj/item/hardpoint/visual_sensors/uscm,
		/obj/item/hardpoint/air_filter/uscm,
		/obj/item/hardpoint/turret_ring/uscm,
		/obj/item/hardpoint/hatch/armored/uscm,
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
	gear_stats = build_gear_stats()
	cruise_control_granularity = gear_stats["D"]["max_speed"] * CRUISE_CONTROL_DEFAULT_GRANULARITY_FRACTION
	setup_overwatch_camera()

	var/turf/gotten_turf = get_turf(src)
	if(gotten_turf && gotten_turf.z)
		SSminimaps.add_marker(src, gotten_turf.z, MINIMAP_FLAG_USCM, "apc", 'icons/ui_icons/map_blips_large.dmi')

/// Kicks off the shared cookoff sequence the instant hull health first reaches 0.
/obj/vehicle/multitile/apc_pmc/on_hull_destroyed()
	start_hull_cookoff_sequence()

/// The APC has a Visual Sensors slot.
/obj/vehicle/multitile/apc_pmc/supports_visual_sensors()
	return TRUE

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
	// Reassign this APC's CIC overwatch to the new driver's squad, if they're a Tank Crewman with one.
	// driver.mind is required so a map-placed dummy/mannequin can never trigger an assignment just by existing pre-buckled.
	if(seat == VEHICLE_DRIVER && ishuman(M))
		var/mob/living/carbon/human/driver = M
		if(driver.mind && driver.job == JOB_TANK_CREW && driver.assigned_squad)
			update_overwatch_squad(driver.assigned_squad)
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
			/obj/vehicle/multitile/proc/name_vehicle,
			/obj/vehicle/multitile/proc/toggle_cruise_control,
			/obj/vehicle/multitile/proc/set_cruise_control_granularity,
			/obj/vehicle/multitile/proc/toggle_turn_signal_north,
			/obj/vehicle/multitile/proc/toggle_turn_signal_south,
			/obj/vehicle/multitile/proc/toggle_turn_signal_east,
			/obj/vehicle/multitile/proc/toggle_turn_signal_west,
			/obj/vehicle/multitile/proc/toggle_engine,
			/obj/vehicle/multitile/proc/cycle_hardpoint,
		))
		give_action(M, /datum/action/human_action/vehicle_action/toggle_door_lock)
		give_action(M, /datum/action/human_action/vehicle_action/toggle_engine)
		if(!(M.client.prefs.toggles_vehicle & VEHICLE_SIMPLE_ACCELERATION))
			give_action(M, /datum/action/human_action/vehicle_action/toggle_cruise_control)
			give_action(M, /datum/action/human_action/vehicle_action/set_cruise_control_granularity)
		RegisterSignal(M, COMSIG_MOB_VEHICLE_PREFS_CHANGED, PROC_REF(on_driver_prefs_changed))
		start_crew_hud(M, VEHICLE_DRIVER)
	else if(seat == VEHICLE_GUNNER)
		add_verb(M.client, list(
			/obj/vehicle/multitile/proc/switch_hardpoint,
			/obj/vehicle/multitile/proc/cycle_hardpoint,
			/obj/vehicle/multitile/proc/name_vehicle,
			/obj/vehicle/multitile/proc/toggle_hardpoint_fire_mode,
			/obj/vehicle/multitile/proc/toggle_iff_module,
			/obj/vehicle/multitile/proc/toggle_turret_safety,
			/obj/vehicle/multitile/proc/toggle_slave_secondary_to_driver,
		))
		give_action(M, /datum/action/human_action/vehicle_action/toggle_iff)
		give_action(M, /datum/action/human_action/vehicle_action/toggle_gyro)
		get_gyro_hardpoint()?.recalculate_gyro(TRUE)
		if(get_slavable_secondary())
			give_action(M, /datum/action/human_action/vehicle_action/slave_secondary)
		start_crew_hud(M, VEHICLE_GUNNER)

	else if(seat == VEHICLE_SUPPORT_GUNNER_ONE || seat == VEHICLE_SUPPORT_GUNNER_TWO)
		add_verb(M.client, list(
			/obj/vehicle/multitile/proc/reload_firing_port_weapon
		))
	if(seat == VEHICLE_DRIVER || seat == VEHICLE_GUNNER)
		if(active_hp[seat]?.get_flame_mode())
			give_action(M, /datum/action/human_action/vehicle_action/toggle_hardpoint_fire_mode)
		give_action(M, /datum/action/human_action/vehicle_action/use_phone)
	refresh_hardpoint_actions()
	ensure_active_hardpoint(seat)

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
			/obj/vehicle/multitile/proc/toggle_cruise_control,
			/obj/vehicle/multitile/proc/set_cruise_control_granularity,
			/obj/vehicle/multitile/proc/toggle_turn_signal_north,
			/obj/vehicle/multitile/proc/toggle_turn_signal_south,
			/obj/vehicle/multitile/proc/toggle_turn_signal_east,
			/obj/vehicle/multitile/proc/toggle_turn_signal_west,
			/obj/vehicle/multitile/proc/toggle_engine,
			/obj/vehicle/multitile/proc/cycle_hardpoint,
		))
		remove_action(M, /datum/action/human_action/vehicle_action/toggle_door_lock)
		remove_action(M, /datum/action/human_action/vehicle_action/toggle_engine)
		remove_action(M, /datum/action/human_action/vehicle_action/toggle_cruise_control)
		remove_action(M, /datum/action/human_action/vehicle_action/set_cruise_control_granularity)
		UnregisterSignal(M, COMSIG_MOB_VEHICLE_PREFS_CHANGED)
		stop_crew_hud(M, VEHICLE_DRIVER)
	else if(seat == VEHICLE_GUNNER)
		remove_verb(M.client, list(
			/obj/vehicle/multitile/proc/switch_hardpoint,
			/obj/vehicle/multitile/proc/cycle_hardpoint,
			/obj/vehicle/multitile/proc/name_vehicle,
			/obj/vehicle/multitile/proc/toggle_hardpoint_fire_mode,
			/obj/vehicle/multitile/proc/toggle_iff_module,
			/obj/vehicle/multitile/proc/toggle_turret_safety,
			/obj/vehicle/multitile/proc/toggle_slave_secondary_to_driver,
		))
		remove_action(M, /datum/action/human_action/vehicle_action/toggle_iff)
		remove_action(M, /datum/action/human_action/vehicle_action/toggle_gyro)
		remove_action(M, /datum/action/human_action/vehicle_action/slave_secondary)
		get_gyro_hardpoint()?.recalculate_gyro(FALSE)
		stop_crew_hud(M, VEHICLE_GUNNER)
	else if(seat == VEHICLE_SUPPORT_GUNNER_ONE || seat == VEHICLE_SUPPORT_GUNNER_TWO)
		remove_verb(M.client, list(
			/obj/vehicle/multitile/proc/reload_firing_port_weapon
		))
	if(seat == VEHICLE_DRIVER || seat == VEHICLE_GUNNER)
		remove_action(M, /datum/action/human_action/vehicle_action/cycle_hardpoint)
		remove_action(M, /datum/action/human_action/vehicle_action/toggle_hardpoint_fire_mode)
		remove_action(M, /datum/action/human_action/vehicle_action/use_phone)

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
	V.add_hardpoint(new /obj/item/hardpoint/engine/apc)
	V.add_hardpoint(new /obj/item/hardpoint/fuel_tank/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/radiator/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/battery/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/iff_module/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/visual_sensors/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/air_filter/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/turret_ring/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/hatch/armored/uscm)

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
	V.add_hardpoint(new /obj/item/hardpoint/engine/apc)
	V.add_hardpoint(new /obj/item/hardpoint/fuel_tank/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/radiator/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/battery/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/iff_module/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/visual_sensors/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/air_filter/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/turret_ring/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/hatch/armored/uscm)

//PRESET: FPWs, default hardpoints
/obj/effect/vehicle_spawner/apc_pmc/fixed/load_hardpoints(obj/vehicle/multitile/apc/V)
	V.add_hardpoint(new /obj/item/hardpoint/primary/dualcannon/pmc)
	V.add_hardpoint(new /obj/item/hardpoint/secondary/frontalcannon/pmc)
	V.add_hardpoint(new /obj/item/hardpoint/support/flare_launcher)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels/pmc)
	V.add_hardpoint(new /obj/item/hardpoint/engine/apc)
	V.add_hardpoint(new /obj/item/hardpoint/fuel_tank/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/radiator/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/battery/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/iff_module/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/visual_sensors/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/air_filter/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/turret_ring/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/hatch/armored/uscm)

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
	V.add_hardpoint(new /obj/item/hardpoint/engine/apc)
	V.add_hardpoint(new /obj/item/hardpoint/fuel_tank/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/radiator/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/battery/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/iff_module/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/visual_sensors/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/air_filter/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/turret_ring/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/hatch/armored/uscm)

//PRESET: no FPWs, wheels installed
/obj/effect/vehicle_spawner/apc_pmc/unarmed/plain/load_hardpoints(obj/vehicle/multitile/apc/unarmed/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels/pmc)
	V.add_hardpoint(new /obj/item/hardpoint/engine/apc)
	V.add_hardpoint(new /obj/item/hardpoint/fuel_tank/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/radiator/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/battery/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/iff_module/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/visual_sensors/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/air_filter/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/turret_ring/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/hatch/armored/uscm)

//PRESET: default hardpoints
/obj/effect/vehicle_spawner/apc_pmc/unarmed/fixed/load_hardpoints(obj/vehicle/multitile/apc/unarmed/V)
	V.add_hardpoint(new /obj/item/hardpoint/primary/dualcannon/pmc)
	V.add_hardpoint(new /obj/item/hardpoint/secondary/frontalcannon/pmc)
	V.add_hardpoint(new /obj/item/hardpoint/support/flare_launcher)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels/pmc)
	V.add_hardpoint(new /obj/item/hardpoint/engine/apc)
	V.add_hardpoint(new /obj/item/hardpoint/fuel_tank/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/radiator/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/battery/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/iff_module/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/visual_sensors/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/air_filter/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/turret_ring/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/hatch/armored/uscm)
