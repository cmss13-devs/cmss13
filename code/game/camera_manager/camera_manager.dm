#define DEFAULT_MAP_SIZE 15

#define RENDER_MODE_TARGET 1
#define RENDER_MODE_AREA 2

/datum/component/camera_manager
	var/map_name
	var/obj/structure/machinery/camera/current
	var/datum/shape/rectangle/current_area
	var/atom/movable/screen/map_view/cam_screen
	var/atom/movable/screen/background/cam_background
	var/list/range_turfs = list()
	/// The turf where the camera was last updated.
	var/turf/last_camera_turf
	var/target_x
	var/target_y
	var/target_z
	var/target_width
	var/target_height
	var/list/cam_plane_masters
	var/isXRay = FALSE
	var/render_mode = RENDER_MODE_TARGET

/datum/component/camera_manager/Initialize()
	. = ..()
	map_name = "camera_manager_[REF(src)]_map"
	cam_screen = new
	cam_screen.icon = null
	cam_screen.name = "screen"
	cam_screen.assigned_map = map_name
	cam_screen.del_on_map_removal = FALSE
	cam_screen.screen_loc = "[map_name]:1,1"
	cam_screen.appearance_flags |= TILE_BOUND
	cam_background = new
	cam_background.assigned_map = map_name
	cam_background.del_on_map_removal = FALSE
	cam_background.appearance_flags |= TILE_BOUND

	cam_plane_masters = list()
	for(var/plane in subtypesof(/atom/movable/screen/plane_master) - /atom/movable/screen/plane_master/blackness)
		var/atom/movable/screen/plane_master/instance = new plane()
		add_plane(instance)

/datum/component/camera_manager/Destroy(force, ...)
	. = ..()
	range_turfs = null
	current_area = null
	QDEL_LIST_ASSOC_VAL(cam_plane_masters)
	QDEL_NULL(cam_background)
	QDEL_NULL(cam_screen)
	if(current)
		UnregisterSignal(current, COMSIG_PARENT_QDELETING)
	current = null
	last_camera_turf = null

/datum/component/camera_manager/proc/add_plane(atom/movable/screen/plane_master/instance)
	instance.assigned_map = map_name
	instance.appearance_flags |= TILE_BOUND
	instance.del_on_map_removal = FALSE
	if(instance.blend_mode_override)
		instance.blend_mode = instance.blend_mode_override
	instance.screen_loc = "[map_name]:CENTER"
	cam_plane_masters["[instance.plane]"] = instance

/datum/component/camera_manager/proc/register(source, mob/user)
	SIGNAL_HANDLER
	var/client/user_client = user.client
	if(!user_client)
		return
	user_client.register_map_obj(cam_screen)
	user_client.register_map_obj(cam_background)
	for(var/plane_id in cam_plane_masters)
		user_client.register_map_obj(cam_plane_masters[plane_id])

/datum/component/camera_manager/proc/unregister(source, mob/user)
	SIGNAL_HANDLER
	var/client/user_client = user.client
	if(!user_client)
		return
	user_client.clear_map(map_name)

/datum/component/camera_manager/RegisterWithParent()
	. = ..()
	SEND_SIGNAL(parent, COMSIG_CAMERA_MAPNAME_ASSIGNED, map_name)
	RegisterSignal(parent, COMSIG_CAMERA_REGISTER_UI, PROC_REF(register))
	RegisterSignal(parent, COMSIG_CAMERA_UNREGISTER_UI, PROC_REF(unregister))
	RegisterSignal(parent, COMSIG_CAMERA_SET_NVG, PROC_REF(enable_nvg))
	RegisterSignal(parent, COMSIG_CAMERA_CLEAR_NVG, PROC_REF(disable_nvg))
	RegisterSignal(parent, COMSIG_CAMERA_SET_AREA, PROC_REF(set_camera_rect))
	RegisterSignal(parent, COMSIG_CAMERA_SET_TARGET, PROC_REF(set_camera))
	RegisterSignal(parent, COMSIG_CAMERA_CLEAR, PROC_REF(clear_camera))
	RegisterSignal(parent, COMSIG_CAMERA_REFRESH, PROC_REF(refresh_camera))

/datum/component/camera_manager/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_CAMERA_REGISTER_UI)
	UnregisterSignal(parent, COMSIG_CAMERA_UNREGISTER_UI)
	UnregisterSignal(parent, COMSIG_CAMERA_SET_NVG)
	UnregisterSignal(parent, COMSIG_CAMERA_CLEAR_NVG)
	UnregisterSignal(parent, COMSIG_CAMERA_SET_AREA)
	UnregisterSignal(parent, COMSIG_CAMERA_SET_TARGET)
	UnregisterSignal(parent, COMSIG_CAMERA_CLEAR)
	UnregisterSignal(parent, COMSIG_CAMERA_REFRESH)

/datum/component/camera_manager/proc/clear_camera()
	SIGNAL_HANDLER
	if(current)
		UnregisterSignal(current, COMSIG_PARENT_QDELETING)
	current_area = null
	current = null
	target_x = null
	target_y = null
	target_z = null
	target_width = null
	target_height = null
	show_camera_static()

/datum/component/camera_manager/proc/refresh_camera()
	SIGNAL_HANDLER
	if(render_mode == RENDER_MODE_AREA)
		update_area_camera()
		return
	update_target_camera()

/datum/component/camera_manager/proc/set_camera(source, atom/target, w, h)
	SIGNAL_HANDLER
	render_mode = RENDER_MODE_TARGET
	if(current)
		UnregisterSignal(current, COMSIG_PARENT_QDELETING)
	current = target
	target_width = w
	target_height = h
	RegisterSignal(current, COMSIG_PARENT_QDELETING, PROC_REF(show_camera_static))
	update_target_camera()

/datum/component/camera_manager/proc/set_camera_rect(source, x, y, z, w, h)
	SIGNAL_HANDLER
	render_mode = RENDER_MODE_AREA
	if(current)
		UnregisterSignal(current, COMSIG_PARENT_QDELETING)
	current = null
	current_area = RECT(x, y, w, h)
	target_x = x
	target_y = y
	target_z = z
	target_width = w
	target_height = h
	update_area_camera()

/datum/component/camera_manager/proc/enable_nvg(source, power, matrixcol)
	SIGNAL_HANDLER
	for(var/plane_id in cam_plane_masters)
		var/atom/movable/screen/plane_master/plane = cam_plane_masters["[plane_id]"]
		plane.add_filter("nvg", 1, color_matrix_filter(color_matrix_from_string(matrixcol)))
	sync_lighting_plane_alpha(LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE)

/datum/component/camera_manager/proc/disable_nvg()
	SIGNAL_HANDLER
	for(var/plane_id in cam_plane_masters)
		var/atom/movable/screen/plane_master/plane = cam_plane_masters["[plane_id]"]
		plane.remove_filter("nvg")
	sync_lighting_plane_alpha(LIGHTING_PLANE_ALPHA_VISIBLE)

/datum/component/camera_manager/proc/sync_lighting_plane_alpha(lighting_alpha)
	var/atom/movable/screen/plane_master/lighting/lighting = cam_plane_masters["[LIGHTING_PLANE]"]
	if(lighting)
		lighting.alpha = lighting_alpha
	var/atom/movable/screen/plane_master/lighting/exterior_lighting = cam_plane_masters["[EXTERIOR_LIGHTING_PLANE]"]
	if(exterior_lighting)
		exterior_lighting.alpha = min(GLOB.minimum_exterior_lighting_alpha, lighting_alpha)

/**
 * Set the displayed camera to the static not-connected.
 */
/datum/component/camera_manager/proc/show_camera_static()
	cam_screen.vis_contents.Cut()
	last_camera_turf = null
	cam_background.icon_state = "scanline2"
	cam_background.fill_rect(1, 1, DEFAULT_MAP_SIZE, DEFAULT_MAP_SIZE)

/datum/component/camera_manager/proc/update_target_camera()
	// Show static if can't use the camera
	if(!current?.can_use())
		show_camera_static()
		return

	// Is this camera located in or attached to a living thing, Vehicle or helmet? If so, assume the camera's loc is the living (or non) thing.
	var/cam_location = current
	if(isliving(current.loc) || isVehicle(current.loc))
		cam_location = current.loc
	else if(istype(current.loc, /obj/item/clothing))
		var/obj/item/clothing/clothing = current.loc
		cam_location = clothing.loc

	// If we're not forcing an update for some reason and the cameras are in the same location,
	// we don't need to update anything.
	// Most security cameras will end here as they're not moving.
	var/newturf = get_turf(cam_location)
	if(last_camera_turf == newturf)
		return

	// Cameras that get here are moving, and are likely attached to some moving atom such as cyborgs.
	last_camera_turf = get_turf(cam_location)

	var/list/visible_things = current.isXRay() ? range(current.view_range, cam_location) : view(current.view_range, cam_location)
	render_objects(visible_things)

/datum/component/camera_manager/proc/update_area_camera()
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

	var/list/visible_things = isXRay ? range("[x_size]x[y_size]", target) : view("[x_size]x[y_size]", target)
	render_objects(visible_things)

/datum/component/camera_manager/proc/render_objects(list/visible_things)
	var/list/visible_turfs = list()
	for(var/turf/visible_turf in visible_things)
		visible_turfs += visible_turf

	var/list/bbox = get_bbox_of_atoms(visible_turfs)
	var/size_x = bbox[3] - bbox[1] + 1
	var/size_y = bbox[4] - bbox[2] + 1

	cam_screen.vis_contents = visible_turfs
	cam_background.icon_state = "clear"
	cam_background.fill_rect(1, 1, size_x, size_y)

#undef DEFAULT_MAP_SIZE
#undef RENDER_MODE_TARGET
#undef RENDER_MODE_AREA
