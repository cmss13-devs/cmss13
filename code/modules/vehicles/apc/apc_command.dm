
/obj/vehicle/multitile/apc/command
	name = "M577-CMD Armored Personnel Carrier"
	desc = "A modification of the M577 Armored Personnel Carrier designed to act as a field commander vehicle. An armored transport with four big wheels. Has inbuilt sensor tower and a field command station installed inside. Entrances on the sides."

	icon_state = "apc_base_com"

	interior_map = "apc_command"

	passengers_slots = 8

	var/sensor_radius = 45 //45 tiles radius

	var/techpod_faction_requirement = FACTION_MARINE
	var/techpod_access_settings_override = FALSE

	/// weakrefs of xenos temporarily added to the marine minimap
	var/list/minimap_added = list()

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

/obj/vehicle/multitile/apc/command/Initialize()
	. = ..()
	START_PROCESSING(SSslowobj, src)
	GLOB.command_apc_list += src

/obj/vehicle/multitile/apc/command/Destroy()
	GLOB.command_apc_list -= src
	STOP_PROCESSING(SSslowobj, src)
	return ..()

/obj/vehicle/multitile/apc/command/process()
	. = ..()

	var/turf/apc_turf = get_turf(src)
	if(health == 0 || !visible_in_tacmap || !is_ground_level(apc_turf.z))
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

/obj/vehicle/multitile/apc/command/load_role_reserved_slots()
	var/datum/role_reserved_slots/RRS = new
	RRS.category_name = "Crewmen"
	RRS.roles = list(JOB_CREWMAN, JOB_WO_CREWMAN, JOB_UPP_CREWMAN, JOB_PMC_CREWMAN)
	RRS.total = 2
	role_reserved_slots += RRS

	RRS = new
	RRS.category_name = "Command Staff"
	RRS.roles = JOB_COMMAND_ROLES_LIST
	RRS.total = 1
	role_reserved_slots += RRS

	RRS = new
	RRS.category_name = "Synthetic Unit"
	RRS.roles = list(JOB_SYNTH, JOB_WO_SYNTH)
	RRS.total = 1
	role_reserved_slots += RRS

/obj/vehicle/multitile/apc/command/add_seated_verbs(mob/living/M, seat)
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

/obj/vehicle/multitile/apc/command/remove_seated_verbs(mob/living/M, seat)
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
		))
	else if(seat == VEHICLE_GUNNER)
		remove_verb(M.client, list(
			/obj/vehicle/multitile/proc/switch_hardpoint,
			/obj/vehicle/multitile/proc/cycle_hardpoint,
			/obj/vehicle/multitile/proc/toggle_shift_click,
		))

/obj/vehicle/multitile/apc/command/initialize_cameras(change_tag = FALSE)
	if(!camera)
		camera = new /obj/structure/machinery/camera/vehicle(src)
	if(change_tag)
		camera.c_tag = "#[rand(1,100)] M777 \"[nickname]\" CMD APC"
		if(camera_int)
			camera_int.c_tag = camera.c_tag + " interior"
	else
		camera.c_tag = "#[rand(1,100)] M777 CMD APC"
		if(camera_int)
			camera_int.c_tag = camera.c_tag + " interior"

//With techwebs disabled, disabling these until later.
/*
/obj/vehicle/multitile/apc/command/attack_hand(mob/user)
	. = ..()

	if(user.z != GLOB.interior_manager.interior_z) //if we didn't enter
		var/turf/T = get_step(get_step(get_turf(src), REVERSE_DIR(dir)), REVERSE_DIR(dir))
		if(user.loc == T)
			access_techpod(user)

//taken from gear_access_point.dm
/obj/vehicle/multitile/apc/command/proc/access_techpod(mob/user)
	if(!ishuman(user) || !get_access_permission(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return

	if(health < initial(health) * 0.5)
		to_chat(user, SPAN_WARNING("\The [name]'s hull is too damaged and Techpod Vendor is not responding."))
		return

	var/list/list_of_techs = list()
	for(var/i in GLOB.unlocked_droppod_techs)
		var/datum/tech/droppod/droppod_tech = i
		if(!droppod_tech.can_access(user))
			continue

		list_of_techs[droppod_tech.name] = droppod_tech

	if(!length(list_of_techs))
		to_chat(user, SPAN_WARNING("No tech gear is available at the moment!"))
		return

	var/user_input = tgui_input_list(user, "Choose a tech to retrieve an item from.", name, list_of_techs)
	if(!user_input)
		return

	var/datum/tech/droppod/chosen_tech = list_of_techs[user_input]
	if(!chosen_tech.can_access(user))
		to_chat(user, SPAN_WARNING("You cannot access this tech!"))
		return

	chosen_tech.on_pod_access(user)

//stole my own code from techpod_vendor
/obj/vehicle/multitile/apc/command/proc/get_access_permission(mob/living/carbon/human/user)
	if(SSticker.mode == "Whiskey Outpost" || master_mode == "Whiskey Outpost")
		return TRUE
	else if(SSticker.mode == "Distress Signal" || master_mode == "Distress Signal")
		if(techpod_access_settings_override)
			return TRUE
		else if(user.get_target_lock(techpod_faction_requirement))
			return TRUE
	else
		if(techpod_access_settings_override)
			if(user.get_target_lock(techpod_faction_requirement))
				return TRUE
		else
			return TRUE

	return FALSE
*/

/*
** PRESETS SPAWNERS
*/
/obj/effect/vehicle_spawner/apc_cmd
	name = "APC CMD Spawner"
	icon = 'icons/obj/vehicles/apc.dmi'
	icon_state = "apc_base_com"
	pixel_x = -48
	pixel_y = -48

/obj/effect/vehicle_spawner/apc_cmd/Initialize()
	. = ..()
	spawn_vehicle()
	qdel(src)

//PRESET: no hardpoints
/obj/effect/vehicle_spawner/apc_cmd/spawn_vehicle()
	var/obj/vehicle/multitile/apc/command/APC = new (loc)

	load_misc(APC)
	load_hardpoints(APC)
	handle_direction(APC)
	APC.update_icon()

//PRESET: only wheels installed
/obj/effect/vehicle_spawner/apc_cmd/plain/load_hardpoints(obj/vehicle/multitile/apc/command/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)

//PRESET: default hardpoints, destroyed
/obj/effect/vehicle_spawner/apc_cmd/decrepit/spawn_vehicle()
	var/obj/vehicle/multitile/apc/command/APC = new (loc)

	load_misc(APC)
	handle_direction(APC)
	load_hardpoints(APC)
	load_damage(APC)
	APC.update_icon()

/obj/effect/vehicle_spawner/apc_cmd/decrepit/load_hardpoints(obj/vehicle/multitile/apc/command/V)
	V.add_hardpoint(new /obj/item/hardpoint/primary/dualcannon)
	V.add_hardpoint(new /obj/item/hardpoint/secondary/frontalcannon)
	V.add_hardpoint(new /obj/item/hardpoint/support/flare_launcher)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)

//PRESET: default hardpoints
/obj/effect/vehicle_spawner/apc_cmd/fixed/load_hardpoints(obj/vehicle/multitile/apc/command/V)
	V.add_hardpoint(new /obj/item/hardpoint/primary/dualcannon)
	V.add_hardpoint(new /obj/item/hardpoint/secondary/frontalcannon)
	V.add_hardpoint(new /obj/item/hardpoint/support/flare_launcher)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)
