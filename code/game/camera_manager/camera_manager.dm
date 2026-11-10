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
	var/list/cas_hud_overlays
	var/isXRay = FALSE
	var/render_mode = RENDER_MODE_TARGET
	var/nvg_enabled = FALSE
	/// Camera snapshots of pings detected by an installed radar
	var/list/radar_contacts
	/// Time remaining until the next pulse and contact cleanup
	var/radar_pulse_remaining = 0
	var/radar_reveal_remaining = 0
	/// Tile containers for the meson view. Covered tiles never include mobs
	var/list/meson_contacts
	var/meson_enabled = FALSE
	/// Time remaining until stationary terrain is refreshed
	var/meson_refresh_remaining = 0
	/// Actual rendered bounds
	var/render_width = DEFAULT_MAP_SIZE
	var/render_height = DEFAULT_MAP_SIZE

/datum/component/camera_manager/Initialize()
	. = ..()
	radar_contacts = list()
	meson_contacts = list()
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
	cas_hud_overlays = list()
	for(var/plane in subtypesof(/atom/movable/screen/plane_master) - /atom/movable/screen/plane_master/blackness)
		var/atom/movable/screen/plane_master/instance = new plane()
		add_plane(instance)

/datum/component/camera_manager/Destroy(force, ...)
	STOP_PROCESSING(SSobj, src)
	clear_radar_contacts()
	clear_meson_contacts()
	. = ..()
	range_turfs = null
	current_area = null
	hide_pilot_camera()
	cas_hud_overlays = null
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
	if(!user || !istype(parent, /obj/structure/machinery/computer/dropship_weapons))
		return
	if(length(cas_hud_overlays))
		return
	var/atom/movable/screen/plane_master/screen_plane = cam_plane_masters["[FULLSCREEN_PLANE]"]
	var/atom/movable/screen/fullscreen/pilot_camera/pilot_overlay = new()
	pilot_overlay.assigned_map = map_name
	pilot_overlay.pixel_x = -224
	pilot_overlay.pixel_y = -224
	pilot_overlay.screen_loc = null
	pilot_overlay.plane = FULLSCREEN_PLANE
	screen_plane.vis_contents += pilot_overlay
	cas_hud_overlays[pilot_overlay] = screen_plane
	update_camera_layout(render_width, render_height)

/// Anchor all planes to the scene
/datum/component/camera_manager/proc/update_camera_layout(width, height)
	render_width = width
	render_height = height
	for(var/plane_id in cam_plane_masters)
		var/atom/movable/screen/plane_master/plane = cam_plane_masters[plane_id]
		plane.screen_loc = "[map_name]:[1 + (width - 1) * 0.5],[1 + (height - 1) * 0.5]"
	for(var/atom/movable/screen/fullscreen/pilot_camera/frame as anything in cas_hud_overlays)
		frame.transform = matrix(width / FULLSCREEN_OVERLAY_RESOLUTION_X, 0, 0, 0, height / FULLSCREEN_OVERLAY_RESOLUTION_Y, 0)

/datum/component/camera_manager/proc/hide_pilot_camera()
	if(!cas_hud_overlays)
		return
	for(var/atom/movable/screen/fullscreen/pilot_camera/pilot_overlay as anything in cas_hud_overlays)
		var/atom/movable/screen/plane_master/plane = cas_hud_overlays[pilot_overlay]
		if(plane)
			plane.vis_contents -= pilot_overlay
		qdel(pilot_overlay)
	cas_hud_overlays.Cut()

/datum/component/camera_manager/proc/clear_dropship_reticle()
	if(!istype(parent, /obj/structure/machinery/computer/dropship_weapons))
		return
	var/obj/structure/machinery/computer/dropship_weapons/console = parent
	var/atom/movable/screen/plane_master/above_lighting = cam_plane_masters["[ABOVE_LIGHTING_PLANE]"]
	console.clear_direct_fire_reticle(above_lighting)

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
	hide_pilot_camera()
	clear_dropship_reticle()

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
	clear_radar_contacts()
	if(current)
		UnregisterSignal(current, COMSIG_PARENT_QDELETING)
	clear_dropship_reticle()
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
	clear_radar_contacts()
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
	clear_radar_contacts()
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
	nvg_enabled = TRUE
	for(var/plane_id in cam_plane_masters)
		var/atom/movable/screen/plane_master/plane = cam_plane_masters["[plane_id]"]
		plane.add_filter("nvg", 1, color_matrix_filter(color_matrix_from_string(matrixcol)))
	sync_lighting_plane_alpha(LIGHTING_PLANE_ALPHA_SOMEWHAT_INVISIBLE)

/datum/component/camera_manager/proc/disable_nvg()
	SIGNAL_HANDLER
	nvg_enabled = FALSE
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
	clear_radar_contacts()
	clear_meson_contacts()
	cam_screen.vis_contents.Cut()
	cam_screen.pixel_x = 0
	cam_screen.pixel_y = 0
	last_camera_turf = null
	cam_background.icon_state = "scanline2"
	cam_background.fill_rect(1, 1, DEFAULT_MAP_SIZE, DEFAULT_MAP_SIZE)
	update_camera_layout(DEFAULT_MAP_SIZE, DEFAULT_MAP_SIZE)

/datum/component/camera_manager/proc/get_camera_view_range()
	if(render_mode == RENDER_MODE_AREA && current_area)
		return "[current_area.bounds_x]x[current_area.bounds_y]"
	if(current)
		return current.view_range
	return "[DEFAULT_MAP_SIZE]x[DEFAULT_MAP_SIZE]"

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

	clear_radar_contacts()
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
	clear_radar_contacts()

	// Cameras that get here are moving, and are likely attached to some moving atom such as cyborgs.
	last_camera_turf = new_location

	var/x_size = current_area.bounds_x
	var/y_size = current_area.bounds_y
	var/turf/target = locate(current_area.center_x, current_area.center_y, target_z)

	var/list/visible_things = isXRay ? range("[x_size]x[y_size]", target) : view("[x_size]x[y_size]", target)
	render_objects(visible_things)

/datum/component/camera_manager/proc/render_objects(list/visible_things)
	clear_meson_contacts()
	var/list/visible_turfs = list()
	for(var/turf/visible_turf in visible_things)
		visible_turfs += visible_turf

	var/turf/center_turf = null
	var/allow_render = is_firemission_view_active()
	var/cas_camera = (parent && istype(parent, /obj/structure/machinery/computer/dropship_weapons))

	// Check if this is a dropship weapons console with an active firemission in ON_TARGET or FIRING state
	if(cas_camera)
		meson_enabled = !allow_render && !!get_advanced_computer(/obj/structure/dropship_equipment/adv_comp/meson)

	if(render_mode == RENDER_MODE_AREA && current_area && target_z)
		center_turf = locate(current_area.center_x, current_area.center_y, target_z)
	else if(render_mode == RENDER_MODE_TARGET && last_camera_turf)
		center_turf = last_camera_turf
	else
		return

	if(meson_enabled)
		visible_turfs = list()
		for(var/turf/meson_turf in range(get_camera_view_range(), center_turf))
			visible_turfs += meson_turf

	if(cas_camera && !allow_render && !meson_enabled)
		var/area/laser_area = get_area(center_turf)
		var/camera_blocked = !istype(laser_area) || CEILING_IS_PROTECTED(laser_area.ceiling, CEILING_PROTECTION_TIER_1)
		if(!camera_blocked)
			camera_blocked = center_turf.is_signal_obstructed()
		if(camera_blocked)
			// Try to raise camera to a higher Z level with a valid floor
			var/turf/raised = raise_camera_z(center_turf)
			if(!raised)
				show_camera_static()
				return
			// Raise the camera view to the higher Z level
			center_turf = raised
			// Show visible turfs at the raised Z level
			var/view_range = get_camera_view_range()
			visible_turfs = list()
			var/list/raised_visible = isXRay ? range(view_range, center_turf) : view(view_range, center_turf)
			for(var/turf/raised_turf in raised_visible)
				// Replace open turfs with the ground turfs below them
				if(istransparentturf(raised_turf))
					var/turf/below = raised_turf
					while(below && istransparentturf(below))
						below = SSmapping.get_turf_below(below)
					if(below)
						visible_turfs += below
						continue
				visible_turfs += raised_turf

	// Spawn Dropship Reticle
	if(cas_camera)
		var/obj/structure/machinery/computer/dropship_weapons/console = parent
		clear_dropship_reticle()

		// Create dropship reticle
		console.direct_fire_reticle = new /obj/effect/overlay/temp/dropship_reticle(center_turf)

		// Add the reticle image to clients
		var/datum/mob_hud/dropship/dropship_hud = GLOB.huds[MOB_HUD_DROPSHIP]
		if(dropship_hud)
			for(var/mob/hud_user as anything in dropship_hud.hudusers)
				console.direct_fire_reticle.update_visibility_for_mob(hud_user)

	var/list/bbox = get_bbox_of_atoms(visible_turfs)
	var/size_x = bbox[3] - bbox[1] + 1
	var/size_y = bbox[4] - bbox[2] + 1
	update_camera_layout(size_x, size_y)
	cam_screen.pixel_x = 0
	cam_screen.pixel_y = 0

	if(meson_enabled)
		render_meson_tiles(visible_turfs, bbox)
	else
		cam_screen.vis_contents = visible_turfs
	cam_background.icon_state = "clear"
	cam_background.fill_rect(1, 1, size_x, size_y)

/// Attempts to raise the camera view to a higher Z level when the current view is obstructed.
/datum/component/camera_manager/proc/raise_camera_z(turf/origin)
	var/turf/highest_floor = null
	var/turf/check = origin
	while(check)
		var/turf/above = SSmapping.get_turf_above(check)
		if(!above)
			break
		// Skip open turfs, we still have static vision as the fallback just incase there's nothing mapped on the z level above
		if(!istype(above, /turf/open/space) && !istype(above, /turf/open_space))
			highest_floor = above
		check = above
	return highest_floor

/// Remove the camera terrain snapshots
/datum/component/camera_manager/proc/clear_meson_contacts()
	clear_camera_contacts(meson_contacts, cam_screen)

/datum/component/camera_manager/proc/render_meson_tiles(list/visible_turfs, list/bounds)
	clear_meson_contacts()
	for(var/turf/terrain as anything in visible_turfs)
		var/atom/movable/screen/map_view/tile = new
		tile.icon = null
		tile.screen_loc = null
		tile.vis_flags = NONE
		if(is_radar_obstructed(terrain))
			// Only sprite appearances are copied, no mobs
			tile.appearance = copy_contact_appearance(terrain.appearance)
			tile.plane = ABOVE_LIGHTING_PLANE
			tile.color = "#65a080"
			for(var/obj/structure/structure in terrain)
				if(structure.invisibility)
					continue
				var/mutable_appearance/structure_snapshot = copy_contact_appearance(structure.appearance)
				structure_snapshot.layer = OBJ_LAYER
				tile.overlays += structure_snapshot
		else
			tile.vis_contents += terrain
		tile.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		tile.appearance_flags |= TILE_BOUND
		tile.pixel_x = (terrain.x - bounds[1]) * world.icon_size
		tile.pixel_y = (terrain.y - bounds[2]) * world.icon_size
		meson_contacts += tile
	cam_screen.vis_contents = meson_contacts

/// Retain visible sprite layers
/datum/component/camera_manager/proc/copy_contact_appearance(image/source)
	var/mutable_appearance/snapshot = new(source)
	snapshot.overlays = copy_contact_layers(source.overlays)
	snapshot.underlays = copy_contact_layers(source.underlays)
	snapshot.filters = null
	snapshot.render_source = null
	snapshot.render_target = null
	snapshot.plane = FLOAT_PLANE
	snapshot.appearance_flags &= ~(KEEP_APART|RESET_ALPHA)
	snapshot.appearance_flags |= KEEP_TOGETHER
	return snapshot

/datum/component/camera_manager/proc/copy_contact_layers(list/layers)
	var/list/snapshots = list()
	for(var/image/appearance as anything in layers)
		switch(appearance.plane)
			if(FLOAT_PLANE, FLOOR_PLANE, GAME_PLANE, ABOVE_GAME_PLANE, SEETHROUGH_PLANE)
				snapshots += copy_contact_appearance(appearance)
	return snapshots

/// Create a snapshot on this camera's plane without copying live contents
/datum/component/camera_manager/proc/create_camera_contact(atom/target, turf/center, contact_layer)
	var/atom/movable/screen/plane_master/contact_plane = cam_plane_masters["[ABOVE_LIGHTING_PLANE]"]
	var/atom/movable/screen/contact = new
	contact.appearance = copy_contact_appearance(target.appearance)
	contact.screen_loc = null
	contact.plane = ABOVE_LIGHTING_PLANE
	contact.layer = contact_layer
	contact.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	contact.pixel_x = (target.x - center.x) * world.icon_size + target.pixel_x
	contact.pixel_y = (target.y - center.y) * world.icon_size + target.pixel_y
	contact_plane.vis_contents += contact
	return contact

/// Keep radar pings on the camera's own plane
/datum/component/camera_manager/proc/clear_radar_contacts()
	clear_camera_contacts(radar_contacts, cam_plane_masters?["[ABOVE_LIGHTING_PLANE]"])

/datum/component/camera_manager/proc/clear_camera_contacts(list/contacts, atom/movable/container)
	if(!contacts)
		return
	for(var/atom/movable/screen/contact as anything in contacts)
		if(container)
			container.vis_contents -= contact
		qdel(contact)
	contacts.Cut()

/datum/component/camera_manager/proc/is_radar_obstructed(turf/target)
	var/area/target_area = get_area(target)
	return CEILING_IS_PROTECTED(target_area.ceiling, CEILING_PROTECTION_TIER_1) || target.is_signal_obstructed()

/// Ordinary camera managers have no dropship equipment.
/datum/component/camera_manager/proc/get_advanced_computer(computer_type)
	return null

/datum/component/camera_manager/proc/is_firemission_view_active()
	return FALSE

/datum/component/camera_manager/dropship/is_firemission_view_active()
	var/obj/structure/machinery/computer/dropship_weapons/console = parent
	var/mission_state = console.firemission_envelope?.stat
	return mission_state == FIRE_MISSION_STATE_ON_TARGET || mission_state == FIRE_MISSION_STATE_FIRING

/datum/component/camera_manager/dropship/Initialize()
	if(!istype(parent, /obj/structure/machinery/computer/dropship_weapons))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	START_PROCESSING(SSobj, src)

/datum/component/camera_manager/dropship/get_advanced_computer(computer_type)
	var/obj/structure/machinery/computer/dropship_weapons/console = parent
	if(console.camera_area_equipment)
		return null
	var/obj/docking_port/mobile/marine_dropship/shuttle = SSshuttle.getShuttle(console.shuttle_tag)
	if(!shuttle?.in_flight())
		return null
	return locate(computer_type) in shuttle?.equipments

/datum/component/camera_manager/dropship/process(delta_time)
	var/elapsed = delta_time SECONDS
	radar_pulse_remaining = max(0, radar_pulse_remaining - elapsed)
	radar_reveal_remaining = max(0, radar_reveal_remaining - elapsed)
	meson_refresh_remaining = max(0, meson_refresh_remaining - elapsed)
	var/had_mesons = meson_enabled
	meson_enabled = !is_firemission_view_active() && !!get_advanced_computer(/obj/structure/dropship_equipment/adv_comp/meson)
	if(meson_enabled != had_mesons || (meson_enabled && !meson_refresh_remaining))
		// Refresh stationary views too, including flight transitions and equipment changes.
		if(!meson_enabled)
			clear_meson_contacts()
		meson_refresh_remaining = 2 SECONDS
		last_camera_turf = null
		refresh_camera()
	var/obj/structure/dropship_equipment/adv_comp/motion/radar = get_advanced_computer(/obj/structure/dropship_equipment/adv_comp/motion)
	if(!radar || !radar.ship_base)
		clear_radar_contacts()
		return
	if(!radar_reveal_remaining)
		clear_radar_contacts()
	if(radar_pulse_remaining)
		return
	radar_pulse_remaining = radar.pulse_interval
	pulse_radar(radar)

/datum/component/camera_manager/dropship/proc/pulse_radar(obj/structure/dropship_equipment/adv_comp/motion/radar)
	var/turf/center
	if(render_mode == RENDER_MODE_AREA && current_area && target_z)
		center = locate(target_x, target_y, target_z)
	else if(render_mode == RENDER_MODE_TARGET && current?.can_use())
		center = get_turf(current)
	if(!center)
		return
	var/atom/movable/screen/plane_master/radar_plane = cam_plane_masters["[ABOVE_LIGHTING_PLANE]"]
	if(!radar_plane)
		return
	var/list/view_size = getviewsize(get_camera_view_range())
	var/half_width = floor(view_size[1] * 0.5)
	var/half_height = floor(view_size[2] * 0.5)
	var/list/candidates = SSmapgrids.get_movables_in_region(center.z, center.x - half_width, center.x + half_width, center.y - half_height, center.y + half_height)
	for(var/mob/living/target in candidates)
		if(target.stat == DEAD || !isturf(target.loc) || world.time > target.l_move_time + radar.pulse_interval)
			continue
		var/turf/target_turf = get_turf(target)
		if(!is_radar_obstructed(target_turf))
			continue
		var/atom/movable/screen/contact = create_camera_contact(target, center, ABOVE_MOB_LAYER)
		contact.name = "radar contact"
		contact.invisibility = 0
		contact.color = null
		contact.alpha = 200
		contact.add_filter("radar_silhouette", 1, color_matrix_filter(list(
			0, 0, 0, 0,
			0, 0, 0, 0,
			0, 0, 0, 0,
			0, 0, 0, 1,
			0, 0, 0, 0,
		)))
		contact.add_filter("radar_outline", 2, outline_filter(1, "#80eaff"))
		contact.add_filter("radar_outline_only", 3, color_matrix_filter(list(
			1, 0, 0, 0,
			0, 1, 0, 0,
			0, 0, 1, 1,
			0, 0, 0, 0,
			0, 0, 0, 0,
		)))
		radar_contacts += contact
		animate(contact, alpha = 0, time = radar.reveal_duration)
	radar_reveal_remaining = radar.reveal_duration

#undef DEFAULT_MAP_SIZE
#undef RENDER_MODE_TARGET
#undef RENDER_MODE_AREA
