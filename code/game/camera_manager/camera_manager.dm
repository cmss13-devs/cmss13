#define DEFAULT_MAP_SIZE 15

#define RENDER_MODE_TARGET 1
#define RENDER_MODE_AREA 2

/datum/component/camera_manager
	var/map_name
	var/obj/structure/machinery/camera/current
	var/datum/shape/current_area
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

/datum/component/camera_manager/proc/show_pilot_camera(mob/user)
	if(user && parent && istype(parent, /obj/structure/machinery/computer/dropship_weapons))
		for(var/plane_id in cam_plane_masters)
			var/atom/movable/screen/plane_master/plane = cam_plane_masters[plane_id]
			var/atom/movable/screen/fullscreen/pilot_camera/overlay
			// bellygun has its own display
			if(istype(parent, /obj/structure/machinery/computer/dropship_weapons/belly_gun))
				overlay = new /atom/movable/screen/fullscreen/pilot_camera/bellygun()
			else
				overlay = new /atom/movable/screen/fullscreen/pilot_camera()
			overlay:assigned_map = map_name
			overlay:pixel_x = -224
			overlay:pixel_y = -224
			overlay:screen_loc = null
			overlay:layer = plane:layer + 1
			overlay:plane = plane:plane
			plane:vis_contents += overlay
			if(!islist(plane:vars["cas_hud_overlays"])) plane:vars["cas_hud_overlays"] = list()
			plane:vars["cas_hud_overlays"] += overlay

/datum/component/camera_manager/proc/hide_pilot_camera(mob/user)
	if(user && parent && istype(parent, /obj/structure/machinery/computer/dropship_weapons))
		// Remove the CAS HUD overlay from the camera panel's plane masters
		for(var/plane_id in cam_plane_masters)
			var/atom/movable/screen/plane_master/plane = cam_plane_masters[plane_id]
			if(islist(plane:vars["cas_hud_overlays"]))
				for(var/overlay in plane:vars["cas_hud_overlays"])
					var/atom/movable/screen/fullscreen/pilot_camera/typed_overlay = overlay
					plane:vis_contents -= typed_overlay
					qdel(typed_overlay)
				plane:vars["cas_hud_overlays"] = list()

/datum/component/camera_manager/proc/register(source, mob/user)
	SIGNAL_HANDLER
	var/client/user_client = user.client
	if(!user_client)
		return
	user_client.register_map_obj(cam_screen)
	user_client.register_map_obj(cam_background)
	for(var/plane_id in cam_plane_masters)
		user_client.register_map_obj(cam_plane_masters[plane_id])
	show_pilot_camera(user)

/datum/component/camera_manager/proc/unregister(source, mob/user)
	SIGNAL_HANDLER
	var/client/user_client = user.client
	if(!user_client)
		return
	user_client.clear_map(map_name)
	hide_pilot_camera(user)
	// Remove dropship reticle overlay if present when exiting console
	if(parent && istype(parent, /obj/structure/machinery/computer/dropship_weapons))
		var/obj/structure/machinery/computer/dropship_weapons/console = parent
		if(console.direct_fire_reticle)
			var/atom/movable/screen/plane_master/above_lighting = cam_plane_masters["[ABOVE_LIGHTING_PLANE]"]
			if(above_lighting)
				above_lighting.vis_contents -= console.direct_fire_reticle
			console.direct_fire_reticle.remove_from_all_clients()
			qdel(console.direct_fire_reticle)
			console.direct_fire_reticle = null

/datum/component/camera_manager/RegisterWithParent()
	. = ..()
	SEND_SIGNAL(parent, COMSIG_CAMERA_MAPNAME_ASSIGNED, map_name)
	RegisterSignal(parent, COMSIG_CAMERA_REGISTER_UI, PROC_REF(register))
	RegisterSignal(parent, COMSIG_CAMERA_UNREGISTER_UI, PROC_REF(unregister))
	RegisterSignal(parent, COMSIG_CAMERA_SET_NVG, PROC_REF(enable_nvg))
	RegisterSignal(parent, COMSIG_CAMERA_CLEAR_NVG, PROC_REF(disable_nvg))
	RegisterSignal(parent, COMSIG_CAMERA_SET_AREA, PROC_REF(set_camera_area))
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
	// Remove dropship reticle overlay if present
	if(parent && istype(parent, /obj/structure/machinery/computer/dropship_weapons))
		var/obj/structure/machinery/computer/dropship_weapons/console = parent
		if(console.direct_fire_reticle)
			var/atom/movable/screen/plane_master/above_lighting = cam_plane_masters["[ABOVE_LIGHTING_PLANE]"]
			if(above_lighting)
				above_lighting.vis_contents -= console.direct_fire_reticle
			console.direct_fire_reticle.remove_from_all_clients()
			qdel(console.direct_fire_reticle)
			console.direct_fire_reticle = null
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

/datum/component/camera_manager/proc/set_camera_area(source, datum/shape/new_area, z)
	SIGNAL_HANDLER
	render_mode = RENDER_MODE_AREA
	if(current)
		UnregisterSignal(current, COMSIG_PARENT_QDELETING)
	current = null
	current_area = new_area
	target_x = current_area.center_x
	target_y = current_area.center_y
	target_z = z
	target_width = current_area.bounds_x
	target_height = current_area.bounds_y
	update_area_camera()

/datum/component/camera_manager/proc/enable_nvg(source, power, matrixcol)
	SIGNAL_HANDLER
	for(var/plane_id in cam_plane_masters)
		var/atom/movable/screen/plane_master/plane = cam_plane_masters["[plane_id]"]
		plane.add_filter("nvg", 1, color_matrix_filter(color_matrix_from_string(matrixcol)))
	sync_lighting_plane_alpha(LIGHTING_PLANE_ALPHA_SOMEWHAT_INVISIBLE)

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

	else if(istype(current.loc, /obj/item/device/overwatch_camera))
		var/obj/item/device/overwatch_camera/cam_gear = current.loc
		cam_location = cam_gear.loc
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

	var/x_size = current_area.bounds_x
	var/y_size = current_area.bounds_y
	var/turf/target = locate(current_area.center_x, current_area.center_y, target_z)

	var/list/visible_things = isXRay ? range("[x_size]x[y_size]", target) : view("[x_size]x[y_size]", target)
	render_objects(visible_things)

/datum/component/camera_manager/proc/render_objects(list/visible_things)
	var/list/visible_turfs = list()
	for(var/turf/visible_turf in visible_things)
		visible_turfs += visible_turf

	var/turf/center_turf = null
	var/allow_render = FALSE
	var/cas_camera = (parent && istype(parent, /obj/structure/machinery/computer/dropship_weapons))

	// Check if this is a dropship weapons console with an active firemission in ON_TARGET or FIRING state
	if(cas_camera)
		var/obj/structure/machinery/computer/dropship_weapons/console = parent
		if(console.firemission_envelope && (console.firemission_envelope.stat == FIRE_MISSION_STATE_ON_TARGET || console.firemission_envelope.stat == FIRE_MISSION_STATE_FIRING))
			allow_render = TRUE

	if(render_mode == RENDER_MODE_AREA && current_area && target_z)
		center_turf = locate(current_area.center_x, current_area.center_y, target_z)
	else if(render_mode == RENDER_MODE_TARGET && last_camera_turf)
		center_turf = last_camera_turf
	else
		return

	if(cas_camera && !allow_render)
		var/area/laser_area = get_area(center_turf)
		if(center_turf.turf_protection_flags & TURF_PROTECTION_CHAFF)
			show_camera_static()
			return
		if(!istype(laser_area) || CEILING_IS_PROTECTED(laser_area.ceiling, CEILING_PROTECTION_TIER_1))
			show_camera_static()
			return
		if(center_turf.obstructed_signal())
			show_camera_static()
			return

	// Spawn Dropship Reticle
	if(cas_camera)
		var/obj/structure/machinery/computer/dropship_weapons/console = parent
		// Remove any previous reticle image overlays from all clients
		if(console.direct_fire_reticle)
			// Remove from plane master vis_contents if present
			var/atom/movable/screen/plane_master/above_lighting = cam_plane_masters["[ABOVE_LIGHTING_PLANE]"]
			if(above_lighting)
				above_lighting.vis_contents -= console.direct_fire_reticle
			console.direct_fire_reticle.remove_from_all_clients()
			qdel(console.direct_fire_reticle)
			console.direct_fire_reticle = null

		// Create appropriate reticle based on console type
		if(istype(console, /obj/structure/machinery/computer/dropship_weapons/belly_gun))
			console.direct_fire_reticle = new /obj/effect/overlay/temp/dropship_reticle/bellygunner()
		else
			console.direct_fire_reticle = new /obj/effect/overlay/temp/dropship_reticle()

		console.direct_fire_reticle.loc = null
		// This is so that xeno motion detector pings only happen when dropship is in flight
		console.direct_fire_reticle.shuttle_tag = console.shuttle_tag
		console.direct_fire_reticle.update_target(center_turf.x, center_turf.y, center_turf.z)

		// Add the reticle image to clients
		var/datum/mob_hud/dropship/dropship_hud = GLOB.huds[MOB_HUD_DROPSHIP]
		if(dropship_hud)
			for(var/mob/M in dropship_hud.hudusers)
				console.direct_fire_reticle.update_visibility_for_mob(M)

	var/list/bbox = get_bbox_of_atoms(visible_turfs)
	var/size_x = bbox[3] - bbox[1] + 1
	var/size_y = bbox[4] - bbox[2] + 1

	cam_screen.vis_contents = visible_turfs
	cam_background.icon_state = "clear"
	cam_background.fill_rect(1, 1, size_x, size_y)

#undef DEFAULT_MAP_SIZE
#undef RENDER_MODE_TARGET
#undef RENDER_MODE_AREA

/atom/movable/screen/plane_master
	var/list/cas_hud_overlays = null
