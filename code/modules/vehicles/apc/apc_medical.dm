
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
		"right" = list(-2, 0),
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
	RRS.roles = list(JOB_TANK_CREW, JOB_WO_CREWMAN, JOB_UPP_CREWMAN, JOB_PMC_CREWMAN)
	RRS.total = 2
	role_reserved_slots += RRS

	RRS = new
	RRS.category_name = "Medical Support"
	RRS.roles = JOB_MEDIC_ROLES_LIST + list(JOB_WO_CMO, JOB_WO_DOCTOR, JOB_WO_RESEARCHER, JOB_SYNTH, JOB_WO_SYNTH)
	RRS.total = 1
	role_reserved_slots += RRS

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
/obj/effect/vehicle_spawner/apc/med
	icon_state = "apc_base_med"
	vehicle_type = /obj/vehicle/multitile/apc/medical

/obj/effect/vehicle_spawner/apc/plain/med
	icon_state = "apc_base_med"
	vehicle_type = /obj/vehicle/multitile/apc/medical

/obj/effect/vehicle_spawner/apc/decrepit/med
	icon_state = "apc_base_med"
	vehicle_type = /obj/vehicle/multitile/apc/medical

/obj/effect/vehicle_spawner/apc/decrepit/med/empty
	hardpoints = list()

/obj/effect/vehicle_spawner/apc/fixed/med
	icon_state = "apc_base_med"
	vehicle_type = /obj/vehicle/multitile/apc/medical
