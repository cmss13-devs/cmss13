
/obj/vehicle/multitile/apc/medical
	name = "\improper M577-MED Armored Personnel Carrier"
	desc = "A medical modification of the M577 Armored Personnel Carrier. An armored transport with four big wheels. Has compact surgery theater set up inside and stores a significant amount of medical supplies. Entrances on the sides."

	icon_state = "apc_base_med"

	interior_map = "apc_med"

	passengers_slots = 4
	//MED APC can store additional 4 dead revivable bodies for the triage
	//but interior won't allow more revivable dead if passengers_taken_slots >= passengers_slots + revivable_dead_slots
	//to prevent infinitely growing the marine force inside of the vehicle
	revivable_dead_slots = 4

	entrances = list(
		"left" = list(2, 0),
		"right" = list(-2, 0)
	)

	seats = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null
	)

	active_hp = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null
	)

/obj/vehicle/multitile/apc/medical/load_role_reserved_slots()
	var/datum/role_reserved_slots/RRS = new
	RRS.category_name = "Crewmen"
	RRS.roles = list(JOB_CREWMAN, JOB_UPP_CREWMAN)
	RRS.total = 2
	role_reserved_slots += RRS

	RRS = new
	RRS.category_name = "Medical Support"
	RRS.roles = list(JOB_CMO, JOB_DOCTOR, JOB_RESEARCHER, JOB_WO_CMO, JOB_WO_DOCTOR, JOB_WO_RESEARCHER, JOB_SYNTH, JOB_WO_SYNTH)
	RRS.total = 1
	role_reserved_slots += RRS

/obj/vehicle/multitile/apc/medical/add_seated_verbs(var/mob/living/M, var/seat)
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

/obj/vehicle/multitile/apc/medical/remove_seated_verbs(var/mob/living/M, var/seat)
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

/obj/vehicle/multitile/apc/medical/initialize_cameras(var/change_tag = FALSE)
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
** PRESETS
*/

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

/obj/vehicle/multitile/apc/medical/plain/load_hardpoints(var/obj/vehicle/multitile/R)
	add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)
