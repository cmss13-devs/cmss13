
/obj/vehicle/multitile/apc/medical
	name = "M577-MED Armored Personnel Carrier"
	desc = "A medical modification of the M577 Armored Personnel Carrier. An armored transport with four big wheels. Designed as a reliable mobile triage that stores a significant amount of medical supplies for in-field resupplying of medics. Entrances on the sides."

	icon_state = "apc_base_med"

	interior_map = /datum/map_template/interior/apc_med


	passengers_slots = 8
	//MED APC can store additional 6 dead revivable bodies for the triage
	//but interior won't allow more revivable dead if passengers_taken_slots >= passengers_slots + revivable_dead_slots
	//to prevent infinitely growing the marine force inside of the vehicle
	revivable_dead_slots = 6

	entrances = list(
		"left" = list(2, 0),
		"right" = list(-2, 0)
	)

	seats = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null,
	)

	active_hp = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null,
	)

/obj/vehicle/multitile/apc/medical/load_role_reserved_slots()
	var/datum/role_reserved_slots/RRS = new
	RRS.category_name = "Crewmen"
	RRS.roles = list(JOB_TANK_CREW, JOB_UPP_CREWMAN, JOB_PMC_CREWMAN, JOB_ARMY_TANK)
	RRS.total = 2
	role_reserved_slots += RRS

	RRS = new
	RRS.category_name = "Medical Support"
	RRS.roles = JOB_MEDIC_ROLES_LIST + list(JOB_WO_CMO, JOB_WO_DOCTOR, JOB_WO_RESEARCHER, JOB_SYNTH, JOB_WO_SYNTH)
	RRS.total = 1
	role_reserved_slots += RRS

/obj/vehicle/multitile/apc/medical/add_seated_verbs(mob/living/M, seat)
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
		/obj/vehicle/multitile/proc/open_controls_guide,
		/obj/vehicle/multitile/proc/name_vehicle,
	))
	if(seat == VEHICLE_DRIVER)
		add_verb(M.client, list(
			/obj/vehicle/multitile/proc/toggle_door_lock,
			/obj/vehicle/multitile/proc/activate_horn,
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
	if(seat == VEHICLE_DRIVER || seat == VEHICLE_GUNNER)
		if(active_hp[seat]?.get_flame_mode())
			give_action(M, /datum/action/human_action/vehicle_action/toggle_hardpoint_fire_mode)
		give_action(M, /datum/action/human_action/vehicle_action/use_phone)
	refresh_hardpoint_actions()
	ensure_active_hardpoint(seat)

/obj/vehicle/multitile/apc/medical/remove_seated_verbs(mob/living/M, seat)
	if(!M.client)
		return
	remove_verb(M.client, list(
		/obj/vehicle/multitile/proc/get_status_info,
		/obj/vehicle/multitile/proc/open_controls_guide,
		/obj/vehicle/multitile/proc/name_vehicle,
	))
	SStgui.close_user_uis(M, src)
	if(seat == VEHICLE_DRIVER)
		remove_verb(M.client, list(
			/obj/vehicle/multitile/proc/toggle_door_lock,
			/obj/vehicle/multitile/proc/activate_horn,
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
	if(seat == VEHICLE_DRIVER || seat == VEHICLE_GUNNER)
		remove_action(M, /datum/action/human_action/vehicle_action/cycle_hardpoint)
		remove_action(M, /datum/action/human_action/vehicle_action/toggle_hardpoint_fire_mode)
		remove_action(M, /datum/action/human_action/vehicle_action/use_phone)

/obj/vehicle/multitile/apc/medical/initialize_cameras(change_tag = FALSE)
	if(!camera)
		camera = new /obj/structure/machinery/camera/vehicle(src)
	if(change_tag)
		camera.c_tag = "#[rand(1,100)] M777 \"[nickname]\" MED APC"
		if(camera_int)
			camera_int.c_tag = camera.c_tag + " interior"
	else
		camera.c_tag = "#[rand(1,100)] M777 MED APC"
		if(camera_int)
			camera_int.c_tag = camera.c_tag + " interior"

/*
** PRESETS SPAWNERS
*/
/obj/effect/vehicle_spawner/apc_med
	name = "APC MED Spawner"
	icon = 'icons/obj/vehicles/apc.dmi'
	icon_state = "apc_base_med"
	pixel_x = -48
	pixel_y = -48

/obj/effect/vehicle_spawner/apc_med/Initialize()
	. = ..()
	spawn_vehicle()
	qdel(src)

//PRESET: no hardpoints
/obj/effect/vehicle_spawner/apc_med/spawn_vehicle()
	var/obj/vehicle/multitile/apc/medical/APC = new (loc)

	load_misc(APC)
	load_hardpoints(APC)
	handle_direction(APC)
	APC.update_icon()

//PRESET: only wheels installed
/obj/effect/vehicle_spawner/apc_med/plain/load_hardpoints(obj/vehicle/multitile/apc/medical/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)
	V.add_hardpoint(new /obj/item/hardpoint/engine/apc)
	V.add_hardpoint(new /obj/item/hardpoint/fuel_tank/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/radiator/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/battery/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/iff_module/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/visual_sensors/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/air_filter/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/turret_ring/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/hatch/armored/uscm)

//PRESET: default hardpoints, destroyed
/obj/effect/vehicle_spawner/apc_med/decrepit/spawn_vehicle()
	var/obj/vehicle/multitile/apc/medical/APC = new (loc)

	load_misc(APC)
	load_hardpoints(APC)
	handle_direction(APC)
	load_damage(APC)
	APC.update_icon()

/obj/effect/vehicle_spawner/apc_med/decrepit/load_hardpoints(obj/vehicle/multitile/apc/medical/V)
	V.add_hardpoint(new /obj/item/hardpoint/primary/dualcannon)
	V.add_hardpoint(new /obj/item/hardpoint/secondary/frontalcannon)
	V.add_hardpoint(new /obj/item/hardpoint/support/flare_launcher)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)
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
/obj/effect/vehicle_spawner/apc_med/fixed/load_hardpoints(obj/vehicle/multitile/apc/medical/V)
	V.add_hardpoint(new /obj/item/hardpoint/primary/dualcannon)
	V.add_hardpoint(new /obj/item/hardpoint/secondary/frontalcannon)
	V.add_hardpoint(new /obj/item/hardpoint/support/flare_launcher)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)
	V.add_hardpoint(new /obj/item/hardpoint/engine/apc)
	V.add_hardpoint(new /obj/item/hardpoint/fuel_tank/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/radiator/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/battery/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/iff_module/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/visual_sensors/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/air_filter/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/turret_ring/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/hatch/armored/uscm)
