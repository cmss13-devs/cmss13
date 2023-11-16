/datum/component/camera_manager
	var/map_name
	var/datum/shape/rectangle/current_area
	var/atom/movable/screen/map_view/cam_screen
	var/atom/movable/screen/background/cam_background
	var/list/range_turfs = list()
	/// The turf where the camera was last updated.
	var/turf/last_camera_turf
	var/target_x
	var/target_y
	var/target_z
	var/list/cam_plane_masters

/datum/component/camera_manager/Initialize()
	. = ..()
	map_name = "camera_manager_[REF(src)]_map"
	cam_screen = new
	cam_screen.name = "screen"
	cam_screen.assigned_map = map_name
	cam_screen.del_on_map_removal = FALSE
	cam_screen.screen_loc = "[map_name]:1,1"
	cam_background = new
	cam_background.assigned_map = map_name
	cam_background.del_on_map_removal = FALSE

	cam_plane_masters = list()
	for(var/plane in subtypesof(/atom/movable/screen/plane_master) - /atom/movable/screen/plane_master/blackness)
		var/atom/movable/screen/plane_master/instance = new plane()
		add_plane(instance)

/datum/component/camera_manager/Destroy(force, ...)
	. = ..()
	range_turfs = null
	current_area = null
	QDEL_NULL(cam_background)
	QDEL_NULL(cam_screen)
	QDEL_LIST(cam_plane_masters)

/datum/component/camera_manager/proc/add_plane(atom/movable/screen/plane_master/instance)
	instance.assigned_map = map_name
	instance.del_on_map_removal = FALSE
	if(instance.blend_mode_override)
		instance.blend_mode = instance.blend_mode_override
	instance.screen_loc = "[map_name]:CENTER"
	cam_plane_masters += instance

/datum/component/camera_manager/proc/register(source, mob/user)
	var/client/user_client = user.client
	if(!user_client)
		return
	user_client.register_map_obj(cam_background)
	user_client.register_map_obj(cam_screen)
	for(var/plane in cam_plane_masters)
		user_client.register_map_obj(plane)

/datum/component/camera_manager/proc/unregister(source, mob/user)
	var/client/user_client = user.client
	if(!user_client)
		return
	user_client.clear_map(cam_background)
	user_client.clear_map(cam_screen)
	for(var/plane in cam_plane_masters)
		user_client.clear_map(plane)

/datum/component/camera_manager/RegisterWithParent()
	. = ..()
	START_PROCESSING(SSdcs, src)
	SEND_SIGNAL(parent, COMSIG_CAMERA_MAPNAME_ASSIGNED, map_name)
	RegisterSignal(parent, COMSIG_CAMERA_REGISTER_UI, PROC_REF(register))
	RegisterSignal(parent, COMSIG_CAMERA_UNREGISTER_UI, PROC_REF(unregister))
	RegisterSignal(parent, COMSIG_CAMERA_SET_NVG, PROC_REF(enable_nvg))
	RegisterSignal(parent, COMSIG_CAMERA_CLEAR_NVG, PROC_REF(disable_nvg))
	RegisterSignal(parent, COMSIG_CAMERA_SET_AREA, PROC_REF(set_camera_rect))
	RegisterSignal(parent, COMSIG_CAMERA_SET_TARGET, PROC_REF(set_camera))
	RegisterSignal(parent, COMSIG_CAMERA_CLEAR, PROC_REF(clear_camera))

/datum/component/camera_manager/UnregisterFromParent()
	. = ..()
	STOP_PROCESSING(SSdcs, src)

	UnregisterSignal(parent, COMSIG_CAMERA_REGISTER_UI)
	UnregisterSignal(parent, COMSIG_CAMERA_UNREGISTER_UI)

	UnregisterSignal(parent, COMSIG_CAMERA_SET_NVG)
	UnregisterSignal(parent, COMSIG_CAMERA_CLEAR_NVG)

	UnregisterSignal(parent, COMSIG_CAMERA_SET_AREA)
	UnregisterSignal(parent, COMSIG_CAMERA_SET_TARGET)
	UnregisterSignal(parent, COMSIG_CAMERA_CLEAR)

/datum/component/camera_manager/proc/clear_camera()
	current_area = null
	target_x = null
	target_y = null
	target_z = null
	update_active_camera()

/datum/component/camera_manager/proc/set_camera(source, atom/target, w, h)
	log_debug("setting camera from [source] to [target]")
	set_camera_rect(target.x, target.y, target.z, w, h)

/datum/component/camera_manager/proc/set_camera_rect(source, x, y, z, w, h)
	current_area = RECT(x, y, w, h)
	target_x = x
	target_y = y
	target_z = z
	update_active_camera()

/datum/component/camera_manager/proc/enable_nvg(source, power, matrixcol)
	var/color_matrix = color_matrix_multiply(
		color_matrix_saturation(1),
		color_matrix_rotate_x(-1*(20.8571-1.57143*power)),
		color_matrix_from_string(matrixcol))
	for(var/atom/movable/screen/plane_master/nvg_plane/plane in cam_plane_masters)
		log_debug("updating [plane] with [color_matrix]")
		animate(plane, color=color_matrix, time=0, easing=LINEAR_EASING)

/datum/component/camera_manager/proc/disable_nvg()
	for(var/atom/movable/screen/plane_master/nvg_plane/plane in cam_plane_masters)
		log_debug("removing [plane]")
		animate(plane, color=null, time=0, easing=LINEAR_EASING)

/**
 * Set the displayed camera to the static not-connected.
 */
/datum/component/camera_manager/proc/show_camera_static()
	cam_screen.vis_contents.Cut()
	last_camera_turf = null
	cam_background.icon_state = "scanline2"
	cam_background.fill_rect(1, 1, 15, 15)

/datum/component/camera_manager/proc/update_active_camera()
	// Show static if can't use the camera
	if(!current_area || !target_z)
		show_camera_static()
		return

	// If we're not forcing an update for some reason and the cameras are in the same location,
	// we don't need to update anything.
	// Most security cameras will end here as they're not moving.
	var/turf/new_location = locate(target_x, target_y, target_z)
	if(last_camera_turf == new_location)
		return

	// Cameras that get here are moving, and are likely attached to some moving atom such as cyborgs.
	last_camera_turf = new_location

	var/x_size = current_area.width
	var/y_size = current_area.height
	var/turf/target = locate(current_area.center_x, current_area.center_y, target_z)
	var/list/guncamera_zone = range("[x_size]x[y_size]", target)

	var/list/visible_turfs = list()

	for(var/turf/visible_turf in guncamera_zone)
		visible_turfs += visible_turf

	var/list/bbox = get_bbox_of_atoms(visible_turfs)
	var/size_x = bbox[3] - bbox[1] + 1
	var/size_y = bbox[4] - bbox[2] + 1
	cam_screen.icon = null
	cam_screen.icon_state = "clear"
	cam_screen.vis_contents = visible_turfs
	cam_background.icon_state = "clear"
	cam_background.fill_rect(1, 1, size_x, size_y)

