#define DEFAULT_MAP_SIZE 15

/obj/structure/machinery/computer/security
	name = "Security Cameras Console"
	desc = "Used to access the various cameras on the station."
	icon_state = "cameras"
	var/obj/structure/machinery/camera/current
	var/list/network = list(CAMERA_NET_MILITARY)
	circuit = /obj/item/circuitboard/computer/security

	/// The turf where the camera was last updated.
	var/turf/last_camera_turf
	var/list/concurrent_users = list()

	// Stuff needed to render the map
	var/map_name
	var/atom/movable/screen/map_view/cam_screen
	var/atom/movable/screen/background/cam_background

	/// All turfs within range of the currently active camera
	var/list/range_turfs = list()

	var/colony_camera_mapload = TRUE

/obj/structure/machinery/computer/security/Initialize(mapload)
	. = ..()
	// Map name has to start and end with an A-Z character,
	// and definitely NOT with a square bracket or even a number.
	// I wasted 6 hours on this. :agony:
	map_name = "camera_console_[REF(src)]_map"

	if(colony_camera_mapload && mapload && is_ground_level(z))
		network = list(CAMERA_NET_COLONY)

	// Initialize map objects
	cam_screen = new
	cam_screen.name = "screen"
	cam_screen.assigned_map = map_name
	cam_screen.del_on_map_removal = FALSE
	cam_screen.screen_loc = "[map_name]:1,1"
	cam_background = new
	cam_background.assigned_map = map_name
	cam_background.del_on_map_removal = FALSE

/obj/structure/machinery/computer/security/Destroy()
	qdel(cam_screen)
	qdel(cam_background)
	return ..()

/obj/structure/machinery/computer/security/attack_remote(var/mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/security/attack_hand(mob/user)
	if(is_admin_level(z))
		to_chat(user, SPAN_DANGER("<b>Unable to establish a connection</b>: \black You're too far away from the ship!"))
		return
	if(inoperable())
		return
	if(!isRemoteControlling(user))
		user.set_interaction(src)
	tgui_interact(user)

/obj/structure/machinery/computer/security/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_DISABLED

/obj/structure/machinery/computer/security/tgui_interact(mob/user, datum/tgui/ui)
	// Update UI
	ui = SStgui.try_update_ui(user, src, ui)

	// Update the camera, showing static if necessary and updating data if the location has moved.
	update_active_camera_screen()

	if(!ui)
		var/user_ref = WEAKREF(user)
		var/is_living = isliving(user)
		// Ghosts shouldn't count towards concurrent users, which produces
		// an audible terminal_on click.
		if(is_living)
			concurrent_users += user_ref
		// Turn on the console
		if(length(concurrent_users) == 1 && is_living)
			use_power(active_power_usage)
		// Register map objects
		user.client.register_map_obj(cam_screen)
		user.client.register_map_obj(cam_background)
		// Open UI
		ui = new(user, src, "CameraConsole", name)
		ui.open()

/obj/structure/machinery/computer/security/ui_data()
	var/list/data = list()
	data["network"] = network
	data["activeCamera"] = null
	if(current)
		data["activeCamera"] = list(
			name = current.c_tag,
			status = current.status,
		)
	return data

/obj/structure/machinery/computer/security/ui_static_data()
	var/list/data = list()
	data["mapRef"] = map_name
	var/list/cameras = get_available_cameras()
	data["cameras"] = list()
	for(var/i in cameras)
		var/obj/structure/machinery/camera/C = cameras[i]
		data["cameras"] += list(list(
			name = C.c_tag,
		))

	return data

/obj/structure/machinery/computer/security/ui_act(action, params)
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

		update_active_camera_screen()

		return TRUE

/obj/structure/machinery/computer/security/proc/update_active_camera_screen()
	// Show static if can't use the camera
	if(!current?.can_use())
		show_camera_static()
		return

	// Is this camera located in or attached to a living thing, Vehicle or helmet? If so, assume the camera's loc is the living (or non) thing.
	var/cam_location = current
	if(isliving(current.loc) || isVehicle(current.loc))
		cam_location = current.loc
	else if(istype(current.loc, /obj/item/clothing/head/helmet/marine))
		var/obj/item/clothing/head/helmet/marine/helmet = current.loc
		cam_location = helmet.loc

	// If we're not forcing an update for some reason and the cameras are in the same location,
	// we don't need to update anything.
	// Most security cameras will end here as they're not moving.
	var/newturf = get_turf(cam_location)
	if(last_camera_turf == newturf)
		return

	// Cameras that get here are moving, and are likely attached to some moving atom such as cyborgs.
	last_camera_turf = get_turf(cam_location)

	var/list/visible_things = current.isXRay() ? range(current.view_range, cam_location) : view(current.view_range, cam_location)

	var/list/visible_turfs = list()
	range_turfs.Cut()
	var/area/A
	for(var/turf/visible_turf in visible_things)
		range_turfs += visible_turf
		A = visible_turf.loc
		if(!A.lighting_use_dynamic || visible_turf.lighting_lumcount >= 1)
			visible_turfs += visible_turf

	var/list/bbox = get_bbox_of_atoms(visible_turfs)
	var/size_x = bbox[3] - bbox[1] + 1
	var/size_y = bbox[4] - bbox[2] + 1

	cam_screen.vis_contents = visible_turfs
	cam_background.icon_state = "clear"
	cam_background.fill_rect(1, 1, size_x, size_y)

	START_PROCESSING(SSfastobj, src) // fastobj to somewhat keep pace with lighting updates

/obj/structure/machinery/computer/security/process()
	if(current)
		var/list/visible_turfs = list()
		var/area/A
		for(var/turf/visible_turf as anything in range_turfs)
			A = visible_turf.loc
			if(!A.lighting_use_dynamic || visible_turf.lighting_lumcount >= 1)
				visible_turfs += visible_turf
		cam_screen.vis_contents = visible_turfs

/obj/structure/machinery/computer/security/ui_close(mob/user)
	var/user_ref = WEAKREF(user)
	var/is_living = isliving(user)
	// Living creature or not, we remove you anyway.
	concurrent_users -= user_ref
	// Unregister map objects
	user.client.clear_map(map_name)
	// Turn off the console
	if(length(concurrent_users) == 0 && is_living)
		current = null
		last_camera_turf = null
		range_turfs = list()
		use_power(0)
		STOP_PROCESSING(SSfastobj, src)
	user.unset_interaction()

/obj/structure/machinery/computer/security/proc/show_camera_static()
	cam_screen.vis_contents.Cut()
	cam_background.icon_state = "scanline2"
	cam_background.fill_rect(1, 1, DEFAULT_MAP_SIZE, DEFAULT_MAP_SIZE)

// Returns the list of cameras accessible from this computer
/obj/structure/machinery/computer/security/proc/get_available_cameras()
	var/list/D = list()
	for(var/obj/structure/machinery/camera/C in cameranet.cameras)
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

/obj/structure/machinery/computer/security/telescreen
	name = "Telescreen"
	desc = "Used for watching an empty arena."
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "telescreen"
	network = list("thunder")
	density = 0
	circuit = null

/obj/structure/machinery/computer/security/telescreen/update_icon()
	icon_state = initial(icon_state)
	if(stat & BROKEN)
		icon_state += "b"
	return

/obj/structure/machinery/computer/security/telescreen/entertainment
	name = "entertainment monitor"
	desc = "Damn, why do they never have anything interesting on these things?"
	icon = 'icons/obj/structures/machinery/status_display.dmi'
	icon_state = "entertainment"
	circuit = null

/obj/structure/machinery/computer/security/wooden_tv
	name = "Security Cameras"
	desc = "An old TV hooked into the station's camera network."
	icon_state = "security_det"
	circuit = null

/obj/structure/machinery/computer/security/wooden_tv/almayer
	name = "Ship Security Cameras"
	network = list(CAMERA_NET_ALMAYER)

/obj/structure/machinery/computer/security/wooden_tv/prop
	name = "Television Set"
	desc = "An old TV hooked up to a video cassette recorder, you can even use it to time shift WOW."
	network = null

/obj/structure/machinery/computer/security/wooden_tv/ot
	name = "Mortar Monitoring Set"
	desc = "A Console linked to Mortar launched cameras."
	network = list(CAMERA_NET_MORTAR)

/obj/structure/machinery/computer/security/mining
	name = "Outpost Cameras"
	desc = "Used to access the various cameras on the outpost."
	icon_state = "miningcameras"
	network = list("MINE")
	circuit = /obj/item/circuitboard/computer/security/mining

/obj/structure/machinery/computer/security/engineering
	name = "Engineering Cameras"
	desc = "Used to monitor fires and breaches."
	icon_state = "engineeringcameras"
	network = list("Engineering","Power Alarms","Atmosphere Alarms","Fire Alarms")
	circuit = /obj/item/circuitboard/computer/security/engineering

/obj/structure/machinery/computer/security/nuclear
	name = "Mission Monitor"
	desc = "Used to access the built-in cameras in helmets."
	icon_state = "syndicam"
	network = list("NUKE")
	circuit = null


/obj/structure/machinery/computer/security/almayer
	density = 0
	icon_state = "security_cam"
	network = list(CAMERA_NET_ALMAYER)

/obj/structure/machinery/computer/security/almayer/containment
	name = "Containment Cameras"
	network = list(CAMERA_NET_CONTAINMENT)

/obj/structure/machinery/computer/security/almayer/vehicle
	name = "Ship Security Cameras"
	network = list(CAMERA_NET_ALMAYER, CAMERA_NET_VEHICLE)

/obj/structure/machinery/computer/security/hangar
	name = "Dropship Security Cameras Console"
	icon_state = "security_cam"
	density = FALSE
	network = list(CAMERA_NET_ALAMO, CAMERA_NET_NORMANDY)

/obj/structure/machinery/computer/security/containment
	name = "Containment Cameras"
	network = list(CAMERA_NET_CONTAINMENT, CAMERA_NET_RESEARCH)

/obj/structure/machinery/computer/security/containment/hidden
	network = list(CAMERA_NET_CONTAINMENT, CAMERA_NET_CONTAINMENT_HIDDEN, CAMERA_NET_RESEARCH)

/obj/structure/machinery/computer/security/almayer_network
	network = list(CAMERA_NET_ALMAYER)

/obj/structure/machinery/computer/security/almayer_network/vehicle
	network = list(CAMERA_NET_ALMAYER, CAMERA_NET_VEHICLE)

/obj/structure/machinery/computer/security/mortar
	name = "Mortar Camera Interface"
	alpha = 0
	mouse_opacity = 0
	density = FALSE
	use_power = 0
	idle_power_usage = 0
	active_power_usage = 0
	network = list(CAMERA_NET_MORTAR)
	exproof = TRUE
	colony_camera_mapload = FALSE

/obj/structure/machinery/computer/security/mortar/emp_act(severity)
	return FALSE

/obj/structure/machinery/computer/security/dropship
	name = "abstract dropship camera computer"
	desc = "A computer to monitor cameras linked to the dropship."
	density = 1
	icon = 'icons/obj/structures/machinery/shuttle-parts.dmi'
	icon_state = "consoleleft"
	circuit = null
	unslashable = TRUE
	unacidable = TRUE
	exproof = TRUE


/obj/structure/machinery/computer/security/dropship/one
	name = "\improper 'Alamo' camera controls"
	network = list(CAMERA_NET_ALAMO, CAMERA_NET_LASER_TARGETS)

/obj/structure/machinery/computer/security/dropship/two
	name = "\improper 'Normandy' camera controls"
	network = list(CAMERA_NET_NORMANDY, CAMERA_NET_LASER_TARGETS)

#undef DEFAULT_MAP_SIZE
