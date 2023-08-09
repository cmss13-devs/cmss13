/obj/vehicle/multitile/arc
	name = "M540 Armored Recon Carrier"
	desc = "An M540 Armored Recon Carrier. A lightly armored reconnaissance and intelligence vehicle. Entrances on the sides."

	icon = 'icons/obj/vehicles/apc.dmi'
	icon_state = "apc_base" //Holdover until thwomp does his thing
	pixel_x = -48
	pixel_y = -48

	bound_width = 96
	bound_height = 96

	bound_x = -32
	bound_y = -32

	interior_map = /datum/map_template/interior/arc

	passengers_slots = 3
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

	luminosity = 7

	hardpoints_allowed = list(
		/obj/item/hardpoint/locomotion/apc_wheels,
		/obj/item/hardpoint/primary/arc_sentry,
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
		"slash" = 0.9,
		"bullet" = 0.7,
		"explosive" = 0.8,
		"blunt" = 0.8,
		"abstract" = 1,
	)

	move_max_momentum = 2.2
	move_momentum_build_factor = 1.5
	move_turn_momentum_loss_factor = 0.8

	vehicle_ram_multiplier = VEHICLE_TRAMPLE_DAMAGE_APC_REDUCTION

	/// If the ARC has its antenna up, making it unable to move but enabling the turret and sensor wallhack
	var/antenna_deployed = FALSE
	/// How long it takes to deploy or retract the antenna
	var/antenna_toggle_time = 10 SECONDS
	/// Range of the ARC's xenomorph wallhacks
	var/sensor_radius = 45
	/// weakrefs of xenos temporarily added to the marine minimap
	var/list/minimap_added = list()

/obj/vehicle/multitile/arc/Initialize()
	. = ..()

	var/turf/gotten_turf = get_turf(src)
	if(gotten_turf?.z)
		SSminimaps.add_marker(src, gotten_turf.z, MINIMAP_FLAG_USCM, "arc", 'icons/ui_icons/map_blips_large.dmi')

	RegisterSignal(src, COMSIG_ARC_ANTENNA_TOGGLED, PROC_REF(on_antenna_toggle))

/obj/vehicle/multitile/arc/proc/on_antenna_toggle(datum/source)
	SIGNAL_HANDLER

	if(antenna_deployed)
		START_PROCESSING(SSslowobj, src)

	else
		STOP_PROCESSING(SSslowobj, src)

/obj/vehicle/multitile/arc/process()
	var/turf/arc_turf = get_turf(src)
	if((health <= 0) || !visible_in_tacmap || !is_ground_level(arc_turf.z))
		return

	for(var/mob/living/carbon/xenomorph/current_xeno as anything in GLOB.living_xeno_list)
		var/turf/xeno_turf = get_turf(current_xeno)
		if(!is_ground_level(xeno_turf.z))
			continue

		if(get_dist(src, current_xeno) <= sensor_radius)
			if(WEAKREF(current_xeno) in minimap_added)
				continue

			SSminimaps.remove_marker(current_xeno)
			current_xeno.add_minimap_marker(MINIMAP_FLAG_USCM|MINIMAP_FLAG_XENO)
			minimap_added += WEAKREF(current_xeno)
		else
			if(WEAKREF(current_xeno) in minimap_added)
				SSminimaps.remove_marker(current_xeno)
				current_xeno.add_minimap_marker()
				minimap_added -= WEAKREF(current_xeno)

/obj/vehicle/multitile/arc/relaymove(mob/user, direction)
	if(antenna_deployed)
		return FALSE

	return ..()

/obj/vehicle/multitile/arc/load_role_reserved_slots()
	var/datum/role_reserved_slots/RRS = new
	RRS.category_name = "CIC Officer"
	RRS.roles = list(JOB_SO, JOB_SEA, JOB_XO, JOB_CO, JOB_GENERAL)
	RRS.total = 1
	role_reserved_slots += RRS

	RRS = new
	RRS.category_name = "Intelligence Officer"
	RRS.roles = list(JOB_INTEL)
	RRS.total = 1
	role_reserved_slots += RRS

/obj/vehicle/multitile/arc/add_seated_verbs(mob/living/M, seat)
	if(!M.client)
		return
	add_verb(M.client, list(
		/obj/vehicle/multitile/proc/get_status_info,
		/obj/vehicle/multitile/arc/proc/open_controls_guide,
		/obj/vehicle/multitile/proc/toggle_door_lock,
		/obj/vehicle/multitile/proc/activate_horn,
		/obj/vehicle/multitile/proc/name_vehicle,
		/obj/vehicle/multitile/arc/proc/toggle_antenna,
	))

/obj/vehicle/multitile/arc/remove_seated_verbs(mob/living/M, seat)
	if(!M.client)
		return
	remove_verb(M.client, list(
		/obj/vehicle/multitile/proc/get_status_info,
		/obj/vehicle/multitile/arc/proc/open_controls_guide,
		/obj/vehicle/multitile/proc/toggle_door_lock,
		/obj/vehicle/multitile/proc/activate_horn,
		/obj/vehicle/multitile/proc/name_vehicle,
		/obj/vehicle/multitile/arc/proc/toggle_antenna,
	))
	SStgui.close_user_uis(M, src)

/obj/vehicle/multitile/arc/initialize_cameras(change_tag = FALSE)
	if(!camera)
		camera = new /obj/structure/machinery/camera/vehicle(src)
	if(change_tag)
		camera.c_tag = "#[rand(1,100)] M540 \"[nickname]\" ARC"
		if(camera_int)
			camera_int.c_tag = camera.c_tag + " interior"
	else
		camera.c_tag = "#[rand(1,100)] 540 ARC"
		if(camera_int)
			camera_int.c_tag = camera.c_tag + " interior"

/*
** PRESETS SPAWNERS
*/
/obj/effect/vehicle_spawner/arc
	name = "ARC Transport Spawner"
	icon = 'icons/obj/vehicles/apc.dmi'
	icon_state = "apc_base"
	pixel_x = -48
	pixel_y = -48

/obj/effect/vehicle_spawner/arc/Initialize()
	. = ..()
	spawn_vehicle()
	qdel(src)

/obj/effect/vehicle_spawner/arc/spawn_vehicle()
	var/obj/vehicle/multitile/arc/ARC = new (loc)

	load_misc(ARC)
	load_hardpoints(ARC)
	handle_direction(ARC)
	ARC.update_icon()

/obj/effect/vehicle_spawner/arc/load_hardpoints(obj/vehicle/multitile/arc/vehicle)
	vehicle.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)
	vehicle.add_hardpoint(new /obj/item/hardpoint/primary/arc_sentry)
