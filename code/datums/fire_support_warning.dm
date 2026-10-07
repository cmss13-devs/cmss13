/// fire support area for minimap
/datum/fire_support_warning
	/// Requested impact origin in world coordinates
	var/turf/target
	/// Circular coverage radius
	var/radius
	/// Short description displayed above the minimap warning
	var/label
	/// Positioned native map image, drawn once and reused by all minimaps
	var/image/blip
	/// Outline color
	var/warning_color
	/// Used by firemissions, includes gimbal and firemission length
	var/list/rectangle

/datum/fire_support_warning/New(turf/target, radius, label, lifetime, warning_color = "#ffb347", list/rectangle)
	. = ..()
	src.target = target
	src.radius = radius
	src.label = label
	src.warning_color = warning_color
	src.rectangle = rectangle?.Copy()
	SSminimaps.fire_support_warnings += src
	SSminimaps.refresh_fire_support_warnings()
	QDEL_IN(src, lifetime)

/datum/fire_support_warning/Destroy()
	SSminimaps.fire_support_warnings -= src
	SSminimaps.refresh_fire_support_warnings()
	target = null
	blip = null
	return ..()

/// Builds the native map image only on first use, not on refresh
/datum/fire_support_warning/proc/get_blip()
	if(blip)
		return blip
	var/datum/hud_displays/map = SSminimaps.minimaps_by_z["[target.z]"]
	if(!map)
		return
	if(rectangle)
		return get_rectangle_blip(map)
	var/pixel_radius = max(2, CEILING(radius * MINIMAP_SCALE, 1))
	var/diameter = pixel_radius * 2 + 1
	var/icon/coverage = icon('icons/ui_icons/minimap.dmi')
	coverage.Crop(1, 1, diameter, diameter)
	for(var/py in 1 to diameter)
		var/dy = py - pixel_radius - 1
		var/outer_span = FLOOR(sqrt(pixel_radius**2 - dy**2), 1)
		coverage.DrawBox(warning_color, pixel_radius + 1 - outer_span, py, pixel_radius + 1 + outer_span, py)
		if(abs(dy) < pixel_radius - 1)
			var/inner_span = FLOOR(sqrt((pixel_radius - 1)**2 - dy**2), 1)
			coverage.DrawBox("[warning_color]30", pixel_radius + 1 - inner_span, py, pixel_radius + 1 + inner_span, py)
	blip = image(coverage)
	blip.pixel_x = MINIMAP_PIXEL_FROM_WORLD(target.x) + map.x_offset - pixel_radius
	blip.pixel_y = MINIMAP_PIXEL_FROM_WORLD(target.y) + map.y_offset - pixel_radius
	blip.layer = FLOAT_LAYER
	blip.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	blip.maptext = MAPTEXT("<span style='color: [warning_color]'>[label]</span>")
	blip.maptext_width = 160
	blip.maptext_y = diameter + 2
	return blip

/// Draws CAS firemission rectangle
/datum/fire_support_warning/proc/get_rectangle_blip(datum/hud_displays/map)
	var/width = (rectangle["max_x"] - rectangle["min_x"] + 1) * MINIMAP_SCALE
	var/height = (rectangle["max_y"] - rectangle["min_y"] + 1) * MINIMAP_SCALE
	var/icon/coverage = icon('icons/ui_icons/minimap.dmi')
	coverage.Crop(1, 1, width, height)
	coverage.DrawBox(warning_color, 1, 1, width, height)
	if(width > 2 && height > 2)
		coverage.DrawBox("[warning_color]30", 2, 2, width - 1, height - 1)
	blip = image(coverage)
	blip.pixel_x = MINIMAP_PIXEL_FROM_WORLD(target.x) + map.x_offset + rectangle["min_x"] * MINIMAP_SCALE
	blip.pixel_y = MINIMAP_PIXEL_FROM_WORLD(target.y) + map.y_offset + rectangle["min_y"] * MINIMAP_SCALE
	blip.layer = FLOAT_LAYER
	blip.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	blip.maptext = MAPTEXT("<span style='color: [warning_color]'>[label]</span>")
	blip.maptext_width = 160
	blip.maptext_y = height + 2
	return blip

/// Refreshes visible transient minimap markers
/datum/controller/subsystem/minimaps/proc/refresh_fire_support_warnings(skip_live = FALSE, list/shared_comms_cache)
	if(!shared_comms_cache)
		shared_comms_cache = list()
	for(var/key in hashed_minimaps)
		var/atom/movable/screen/minimap/map = hashed_minimaps[key]
		if(QDELETED(map) || !map.should_refresh_transient_markers())
			continue
		if(skip_live && map.live && updaters_by_datum[map])
			continue
		map.update_fire_support_warnings(shared_comms_cache)

/// force a refresh when fetching a map
/atom/movable/screen/minimap/proc/should_refresh_transient_markers()
	if(is_cache_template)
		return FALSE
	if(is_personal_copy || warning_client)
		return (src in warning_client?.screen)
	if(track_popout_viewers)
		for(var/client/viewer as anything in popout_viewers)
			if(src in viewer?.screen)
				return TRUE
		return FALSE
	return TRUE

// need planetside comms, radio backpack, scout helmet or ARC in deploy mode for the warnings to display on minimap
/datum/controller/subsystem/minimaps/proc/fire_support_comms_available(zlevel, mob/user)
	for(var/obj/structure/machinery/telecomms/relay as anything in SSradio.tcomm_machines_ground)
		if(relay.on && ((COMM_FREQ in relay.freq_listening) || (UNIVERSAL_FREQ in relay.freq_listening)))
			return TRUE
	if(has_personal_tacmap_radio(user))
		return TRUE
	if(is_ground_level(zlevel))
		for(var/obj/vehicle/multitile/arc/arc in GLOB.all_multi_vehicles)
			if(QDELETED(arc) || !arc.antenna_deployed || arc.health <= 0 || arc.vehicle_faction != FACTION_MARINE || !is_ground_level(arc.z))
				continue
			var/obj/item/hardpoint/support/arc_antenna/antenna = locate() in arc.hardpoints
			if(antenna && antenna.health > 0)
				return TRUE
	return FALSE

/// Comms exception applies only to a human wearing RTO pack/scout helm
/datum/controller/subsystem/minimaps/proc/has_personal_tacmap_radio(mob/user)
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/human = user
	return istype(human.back, /obj/item/storage/backpack/marine/satchel/rto) || istype(human.head, /obj/item/clothing/head/helmet/marine/radio_helmet/scout)

/// Reapplies eligible strike coverage and the map's private markers.
/atom/movable/screen/minimap/proc/update_fire_support_warnings(list/shared_comms_cache)
	overlays -= fire_support_warning_overlays
	fire_support_warning_overlays = list()
	var/comms_available = FALSE
	if(length(SSminimaps.fire_support_warnings) && (minimap_flags & MINIMAP_FLAG_USCM))
		if(shared_comms_cache)
			var/key = "[target]"
			if(!(key in shared_comms_cache))
				shared_comms_cache[key] = SSminimaps.fire_support_comms_available(target)
			comms_available = shared_comms_cache[key] || SSminimaps.has_personal_tacmap_radio(warning_client?.mob)
		else
			comms_available = SSminimaps.fire_support_comms_available(target, warning_client?.mob)
	if(comms_available)
		for(var/datum/fire_support_warning/warning as anything in SSminimaps.fire_support_warnings)
			if(warning.target.z == target)
				var/image/blip = warning.get_blip()
				if(blip)
					fire_support_warning_overlays += blip
	overlays += fire_support_warning_overlays
	update_cas_signal_markers()
	update_operator_aim_marker()
	update_saved_coordinate_markers()

/// Copies map appearance while excluding all fire support warnings
/atom/movable/screen/minimap/proc/snapshot_without_fire_support_warnings()
	var/image/snapshot = image(icon)
	snapshot.appearance = appearance
	snapshot.overlays -= fire_support_warning_overlays
	snapshot.overlays -= cas_signal_overlays
	snapshot.overlays -= saved_coordinate_overlays
	if(operator_aim_marker)
		snapshot.overlays -= operator_aim_marker
	return snapshot

/// Exports eligible coverage to the published map's size
/datum/controller/subsystem/minimaps/proc/fire_support_warning_data(zlevel, mob/user)
	var/list/result = list()
	var/datum/hud_displays/map = minimaps_by_z["[zlevel]"]
	if(!map || !length(fire_support_warnings) || !fire_support_comms_available(zlevel, user))
		return result
	for(var/datum/fire_support_warning/warning as anything in fire_support_warnings)
		if(warning.target.z != zlevel)
			continue
		if(warning.rectangle)
			var/image/blip = warning.get_blip()
			var/width = (warning.rectangle["max_x"] - warning.rectangle["min_x"] + 1) * MINIMAP_SCALE
			var/height = (warning.rectangle["max_y"] - warning.rectangle["min_y"] + 1) * MINIMAP_SCALE
			result += list(list(
				"id" = REF(warning),
				"shape" = "rectangle",
				"x" = blip.pixel_x,
				"y" = MINIMAP_PIXEL_SIZE - blip.pixel_y - height,
				"width" = width,
				"height" = height,
				"label" = warning.label,
				"color" = warning.warning_color,
			))
			continue
		result += list(list(
			"id" = REF(warning),
			"shape" = "circle",
			"x" = MINIMAP_PIXEL_FROM_WORLD(warning.target.x) + map.x_offset + 0.5,
			"y" = MINIMAP_PIXEL_SIZE - (MINIMAP_PIXEL_FROM_WORLD(warning.target.y) + map.y_offset + 0.5),
			"radius" = max(2, CEILING(warning.radius * MINIMAP_SCALE, 1)),
			"label" = warning.label,
			"color" = warning.warning_color,
		))
	return result
