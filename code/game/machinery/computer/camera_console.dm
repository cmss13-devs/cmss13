#define DEFAULT_MAP_SIZE 15

/obj/structure/machinery/computer/cameras
	name = "security cameras console"
	desc = "Used to access the various cameras on the station."
	icon_state = "cameras"
	var/obj/structure/machinery/camera/current
	var/list/network = list(CAMERA_NET_MILITARY)
	circuit = /obj/item/circuitboard/computer/cameras

	/// The turf where the camera was last updated.
	var/turf/last_camera_turf
	var/list/concurrent_users = list()

	// Stuff needed to render the map
	var/camera_map_name

	var/colony_camera_mapload = TRUE
	var/admin_console = FALSE

/obj/structure/machinery/computer/cameras/Initialize(mapload)
	. = ..()

	RegisterSignal(src, COMSIG_CAMERA_MAPNAME_ASSIGNED, PROC_REF(camera_mapname_update))

	// camera setup
	AddComponent(/datum/component/camera_manager)
	SEND_SIGNAL(src, COMSIG_CAMERA_CLEAR)

	if(colony_camera_mapload && mapload && is_ground_level(z))
		network = list(CAMERA_NET_COLONY)


/obj/structure/machinery/computer/cameras/Destroy()
	SStgui.close_uis(src)
	QDEL_NULL(current)
	UnregisterSignal(src, COMSIG_CAMERA_MAPNAME_ASSIGNED)
	last_camera_turf = null
	concurrent_users = null
	return ..()

/obj/structure/machinery/computer/cameras/proc/camera_mapname_update(source, value)
	camera_map_name = value

/obj/structure/machinery/computer/cameras/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/cameras/attack_hand(mob/user)
	if(!admin_console && should_block_game_interaction(src))
		to_chat(user, SPAN_DANGER("<b>Unable to establish a connection</b>: \black You're too far away from the ship!"))
		return
	if(inoperable())
		return
	if(!isRemoteControlling(user))
		user.set_interaction(src)
	tgui_interact(user)

/obj/structure/machinery/computer/cameras/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_DISABLED

//Closes UI if you move away from console.
/obj/structure/machinery/computer/cameras/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/computer/cameras/tgui_interact(mob/user, datum/tgui/ui)
	// Update UI
	ui = SStgui.try_update_ui(user, src, ui)

	SEND_SIGNAL(src, COMSIG_CAMERA_REFRESH)

	if(!ui)
		var/user_ref = WEAKREF(user)
		var/is_living = isliving(user)
		// Ghosts shouldn't count towards concurrent users, which produces
		// an audible terminal_on click.
		if(is_living)
			concurrent_users += user_ref
		// Turn on the console
		if(length(concurrent_users) == 1 && is_living)
			update_use_power(USE_POWER_ACTIVE)

		SEND_SIGNAL(src, COMSIG_CAMERA_REGISTER_UI, user)

		// Open UI
		ui = new(user, src, "CameraConsole", name)
		ui.open()

/obj/structure/machinery/computer/cameras/ui_data()
	var/list/data = list()
	data["network"] = network
	data["activeCamera"] = null
	if(current)
		data["activeCamera"] = list(
			name = current.c_tag,
			status = current.status,
		)
	return data

/obj/structure/machinery/computer/cameras/ui_static_data()
	var/list/data = list()
	data["mapRef"] = camera_map_name
	var/list/cameras = get_available_cameras()
	data["cameras"] = list()
	for(var/i in cameras)
		var/obj/structure/machinery/camera/C = cameras[i]
		data["cameras"] += list(list(
			name = C.c_tag,
		))

	return data

/obj/structure/machinery/computer/cameras/ui_act(action, params)
	. = ..()
	if(.)
		return

	if(action == "switch_camera")
		var/c_tag = params["name"]
		var/list/cameras = get_available_cameras()
		var/obj/structure/machinery/camera/selected_camera
		selected_camera = cameras[c_tag]
		// Unicode breaks c_tags
		// Currently the only issues with character names comes from the improper or proper tags and so we strip and recheck if not found.
		if(!selected_camera)
			for(var/I in cameras)
				if(strip_improper(I) == c_tag)
					selected_camera = cameras[I]
					break
		current = selected_camera
		playsound(src, get_sfx("terminal_type"), 25, FALSE)

		if(!selected_camera)
			return TRUE

		SEND_SIGNAL(src, COMSIG_CAMERA_SET_TARGET, selected_camera, selected_camera.view_range, selected_camera.view_range)

		return TRUE


/obj/structure/machinery/computer/cameras/ui_close(mob/user)
	var/user_ref = WEAKREF(user)
	var/is_living = isliving(user)
	// Living creature or not, we remove you anyway.
	concurrent_users -= user_ref
	// Unregister map objects
	SEND_SIGNAL(src, COMSIG_CAMERA_UNREGISTER_UI, user)
	// Turn off the console
	if(length(concurrent_users) == 0 && is_living)
		current = null
		SEND_SIGNAL(src, COMSIG_CAMERA_CLEAR)
		last_camera_turf = null
		if(use_power)
			update_use_power(USE_POWER_IDLE)
	user.unset_interaction()

// Returns the list of cameras accessible from this computer
/obj/structure/machinery/computer/cameras/proc/get_available_cameras()
	var/list/D = list()
	for(var/obj/structure/machinery/camera/C in GLOB.all_cameras)
		if(!C.network)
			stack_trace("Camera in a cameranet has no camera network")
			continue
		if(!(islist(C.network)))
			stack_trace("Camera in a cameranet has a non-list camera network")
			continue
		var/list/tempnetwork = C.network & network
		if(tempnetwork.len)
			D["[C.c_tag]"] = C
	return D

/obj/structure/machinery/computer/cameras/telescreen
	name = "Telescreen"
	desc = "Used for watching an empty arena."
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "telescreen"
	network = list("thunder")
	density = FALSE
	circuit = null

/obj/structure/machinery/computer/cameras/telescreen/update_icon()
	icon_state = initial(icon_state)
	if(stat & BROKEN)
		icon_state += "b"
	return

/obj/structure/machinery/computer/cameras/telescreen/entertainment
	name = "entertainment monitor"
	desc = "Damn, why do they never have anything interesting on these things?"
	icon = 'icons/obj/structures/machinery/status_display.dmi'
	icon_state = "entertainment"
	circuit = null

/obj/structure/machinery/computer/cameras/wooden_tv
	name = "Security Cameras"
	desc = "An old TV hooked into the station's camera network."
	icon_state = "security_det"
	circuit = null

/obj/structure/machinery/computer/cameras/wooden_tv/almayer
	name = "Ship Security Cameras"
	network = list(CAMERA_NET_ALMAYER)

/obj/structure/machinery/computer/cameras/wooden_tv/prop
	name = "Television Set"
	desc = "An old TV hooked up to a video cassette recorder, you can even use it to time shift WOW."
	network = null

/obj/structure/machinery/computer/cameras/wooden_tv/ot
	name = "Mortar Monitoring Set"
	desc = "A Console linked to Mortar launched cameras."
	network = list(CAMERA_NET_MORTAR)

/obj/structure/machinery/computer/cameras/mining
	name = "Outpost Cameras"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	desc = "Used to access the various cameras on the outpost."
	icon_state = "cameras"
	network = list("MINE")
	circuit = /obj/item/circuitboard/computer/cameras/mining

/obj/structure/machinery/computer/cameras/engineering
	name = "Engineering Cameras"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	desc = "Used to monitor fires and breaches."
	icon_state = "cameras"
	network = list("Engineering","Power Alarms","Atmosphere Alarms","Fire Alarms")
	circuit = /obj/item/circuitboard/computer/cameras/engineering

/obj/structure/machinery/computer/cameras/nuclear
	name = "Mission Monitor"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	desc = "Used to access the built-in cameras in helmets."
	icon_state = "syndicam"
	network = list("NUKE")
	circuit = null


/obj/structure/machinery/computer/cameras/almayer
	density = FALSE
	icon_state = "security_cam"
	network = list(CAMERA_NET_ALMAYER)

/obj/structure/machinery/computer/cameras/almayer/containment
	name = "Containment Cameras"
	network = list(CAMERA_NET_CONTAINMENT)

/obj/structure/machinery/computer/cameras/almayer/ares
	name = "ARES Core Cameras"
	network = list(CAMERA_NET_ARES)

/obj/structure/machinery/computer/cameras/almayer/vehicle
	name = "Ship Security Cameras"
	network = list(CAMERA_NET_ALMAYER, CAMERA_NET_VEHICLE)

/obj/structure/machinery/computer/cameras/hangar
	name = "Dropship Security Cameras Console"
	icon_state = "security_cam"
	density = FALSE
	network = list(CAMERA_NET_ALAMO, CAMERA_NET_NORMANDY)

/obj/structure/machinery/computer/cameras/containment
	name = "Containment Cameras"
	network = list(CAMERA_NET_CONTAINMENT, CAMERA_NET_RESEARCH)

/obj/structure/machinery/computer/cameras/containment/hidden
	network = list(CAMERA_NET_CONTAINMENT, CAMERA_NET_CONTAINMENT_HIDDEN, CAMERA_NET_RESEARCH)

/obj/structure/machinery/computer/cameras/almayer_network
	network = list(CAMERA_NET_ALMAYER)

/obj/structure/machinery/computer/cameras/almayer_network/vehicle
	network = list(CAMERA_NET_ALMAYER, CAMERA_NET_VEHICLE)

/obj/structure/machinery/computer/cameras/mortar
	name = "Mortar Camera Interface"
	alpha = 0
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	density = FALSE
	use_power = USE_POWER_NONE
	idle_power_usage = 0
	active_power_usage = 0
	needs_power = FALSE
	network = list(CAMERA_NET_MORTAR)
	exproof = TRUE
	colony_camera_mapload = FALSE

/obj/structure/machinery/computer/cameras/mortar/set_broken()
	return

/obj/structure/machinery/computer/cameras/dropship
	name = "abstract dropship camera computer"
	desc = "A computer to monitor cameras linked to the dropship."
	density = TRUE
	icon = 'icons/obj/structures/machinery/shuttle-parts.dmi'
	icon_state = "consoleleft"
	circuit = null
	unslashable = TRUE
	unacidable = TRUE
	exproof = TRUE


/obj/structure/machinery/computer/cameras/dropship/one
	name = "\improper 'Alamo' camera controls"
	network = list(CAMERA_NET_ALAMO, CAMERA_NET_LASER_TARGETS)

/obj/structure/machinery/computer/cameras/dropship/two
	name = "\improper 'Normandy' camera controls"
	network = list(CAMERA_NET_NORMANDY, CAMERA_NET_LASER_TARGETS)

#undef DEFAULT_MAP_SIZE
