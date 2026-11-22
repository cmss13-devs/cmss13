/datum/cas_signal
	var/signal_loc
	var/name = "Unknown Electronic Signal"
	var/target_id = 0
	var/obj/structure/machinery/camera/cas/linked_cam
	var/z_initial
	var/datum/weakref/designator_ref // only lases will receive target selection feedback from CAS
	/// Locked on targets may only be used for direct fire.
	var/direct_fire_only = FALSE
	/// Tactical designators can lase through any roof.
	var/penetrates_roof = FALSE
	/// Positioned CAS target image reused across eligible native maps.
	var/image/minimap_blip
	/// Position/color/label signature used to invalidate the cached target image.
	var/minimap_blip_key

/// stores the last gotten world coordinates from a marine's designator, specifically as a check for OW console's saved coords feature
/mob/living/carbon/human/var/list/last_binocular_coordinate

/// Exact planetside marine binocular readings acquired this round, shared across squads
GLOBAL_LIST_EMPTY(acquired_binocular_coordinates)

/// Saves a completed reading and authorizes its exact coordinates for Overwatch's saved coords minimap marker
/mob/living/carbon/human/proc/save_binocular_coordinate(turf/location)
	if(!location)
		return
	last_binocular_coordinate = list("x" = location.x, "y" = location.y, "z" = location.z)
	if(is_ground_level(location.z) && (faction == FACTION_MARINE || (FACTION_MARINE in faction_group)))
		GLOB.acquired_binocular_coordinates["[location.x],[location.y],[location.z]"] = TRUE
	SSminimaps.refresh_fire_support_warnings()

/// Displays the equipped viewer's reading and this console squad's verified saved targets
/atom/movable/screen/minimap/proc/update_saved_coordinate_markers()
	overlays -= saved_coordinate_overlays
	saved_coordinate_overlays = list()
	var/list/new_cache = list()
	var/datum/hud_displays/display = SSminimaps.minimaps_by_z["[target]"]
	if(!display)
		saved_coordinate_cache = new_cache
		return
	if((minimap_flags & MINIMAP_FLAG_USCM) && SSminimaps.has_personal_tacmap_radio(warning_client?.mob))
		var/mob/living/carbon/human/marine = warning_client.mob
		var/list/coordinate = marine.last_binocular_coordinate
		if(coordinate && coordinate["z"] == target)
			add_saved_coordinate_marker(coordinate["x"], coordinate["y"], "COORD", "#ffff55", display, new_cache)
	if(!QDELETED(coordinate_console) && coordinate_console.current_squad)
		for(var/index in 1 to length(coordinate_console.saved_coordinates))
			var/list/coordinate = coordinate_console.saved_coordinates[index]
			if(coordinate["squad"] != coordinate_console.current_squad || !isnum(coordinate["x"]) || !isnum(coordinate["y"]) || !isnum(coordinate["z"]))
				continue
			var/world_x = deobfuscate_x(coordinate["x"])
			var/world_y = deobfuscate_y(coordinate["y"])
			var/world_z = deobfuscate_z(coordinate["z"])
			if(!GLOB.acquired_binocular_coordinates["[world_x],[world_y],[world_z]"])
				continue
			var/turf/location = locate(world_x, world_y, world_z)
			if(location && location.z == target)
				add_saved_coordinate_marker(location.x, location.y, "SAVED [index]", "#ffb347", display, new_cache)
	saved_coordinate_cache = new_cache
	overlays += saved_coordinate_overlays

/// Reuses unchanged marker images and projects world coordinates onto the native map
/atom/movable/screen/minimap/proc/add_saved_coordinate_marker(world_x, world_y, label, marker_color, datum/hud_displays/display, list/new_cache)
	var/key = "[world_x]-[world_y]-[label]-[marker_color]-[display.x_offset]-[display.y_offset]"
	var/image/marker = saved_coordinate_cache[key]
	if(!marker)
		var/icon/marker_icon = icon('icons/ui_icons/minimap.dmi')
		marker_icon.Crop(1, 1, 7, 7)
		marker_icon.DrawBox(marker_color, 1, 4, 7, 4)
		marker_icon.DrawBox(marker_color, 4, 1, 4, 7)
		marker = image(marker_icon)
		marker.pixel_x = MINIMAP_PIXEL_FROM_WORLD(world_x) + display.x_offset - 3
		marker.pixel_y = MINIMAP_PIXEL_FROM_WORLD(world_y) + display.y_offset - 3
		marker.layer = FLOAT_LAYER
		marker.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		marker.maptext = MAPTEXT("<span style='color: [marker_color]'>[label]</span>")
		marker.maptext_width = 160
		marker.maptext_y = 9
	new_cache[key] = marker
	saved_coordinate_overlays += marker

/datum/cas_signal/New(location)
	z_initial = z_descend(location)
	signal_loc = location

/datum/cas_signal/Destroy()
	QDEL_NULL(linked_cam)
	signal_loc = null
	minimap_blip = null
	. = ..()

/atom/movable/screen/minimap/proc/update_operator_aim_marker()
	if(operator_aim_marker)
		overlays -= operator_aim_marker
	if(!(minimap_flags & MINIMAP_FLAG_DROPSHIP) || QDELETED(aim_console) || QDELETED(aim_operator))
		return
	var/turf/aim = aim_console.get_operator_map_aim(aim_operator)
	var/datum/hud_displays/display = SSminimaps.minimaps_by_z["[target]"]
	if(!aim || aim.z != target || !display)
		return
	if(!operator_aim_marker)
		var/icon/reticle = icon('icons/ui_icons/minimap.dmi')
		reticle.Crop(1, 1, 11, 11)
		reticle.DrawBox("#ffffff", 4, 6, 8, 6)
		reticle.DrawBox("#ffffff", 6, 4, 6, 8)
		operator_aim_marker = image(reticle)
		operator_aim_marker.layer = FLOAT_LAYER + 0.1
		operator_aim_marker.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		operator_aim_marker.maptext = MAPTEXT("<span style='color: #ffffff'>TARGET</span>")
		operator_aim_marker.maptext_width = 80
		operator_aim_marker.maptext_y = 13
	operator_aim_marker.pixel_x = MINIMAP_PIXEL_FROM_WORLD(aim.x) + display.x_offset - 5
	operator_aim_marker.pixel_y = MINIMAP_PIXEL_FROM_WORLD(aim.y) + display.y_offset - 5
	overlays += operator_aim_marker

/atom/movable/screen/minimap/proc/update_cas_signal_markers()
	overlays -= cas_signal_overlays
	cas_signal_overlays = list()
	var/is_dropship = minimap_flags & MINIMAP_FLAG_DROPSHIP
	var/mob/viewer = warning_client?.mob
	if(!is_dropship && (!(minimap_flags & MINIMAP_FLAG_USCM) || !SSminimaps.has_personal_tacmap_radio(viewer)))
		return
	var/datum/cas_iff_group/group
	if(minimap_flags & MINIMAP_FLAG_USCM)
		group = GLOB.uscm_cas_group
	else if(minimap_flags & MINIMAP_FLAG_UPP)
		group = GLOB.upp_cas_group
	var/datum/hud_displays/display = SSminimaps.minimaps_by_z["[target]"]
	if(!group || !display)
		return
	for(var/datum/cas_signal/signal as anything in group.cas_signals)
		if(QDELETED(signal))
			continue
		if(!is_dropship && !signal.is_personal_laser_for(viewer))
			continue
		var/obj/location = signal.signal_loc
		if(QDELETED(location) || !isturf(location.loc) || location.z != target || location.z != signal.z_initial)
			continue
		cas_signal_overlays += signal.get_minimap_blip(display)
	overlays += cas_signal_overlays

/datum/cas_signal/proc/is_personal_laser_for(mob/viewer)
	if(QDELETED(src) || !SSminimaps.has_personal_tacmap_radio(viewer))
		return FALSE
	var/obj/effect/overlay/temp/laser_target/laser = signal_loc
	return istype(laser) && !QDELETED(laser) && laser.user == viewer

/datum/cas_signal/proc/get_minimap_blip(datum/hud_displays/display)
	var/turf/location = get_turf(signal_loc)
	var/area/target_area = get_area(location)
	var/marker_color = "#54c7ec"
	var/marker_label = "LASER [target_id]"
	if(istype(signal_loc, /obj/item/device/flashlight/flare/signal))
		marker_label = "FLARE [target_id]"
		marker_color = "#55ff55"
		if(target_area.ceiling > CEILING_METAL)
			marker_color = "#ff5555"
		else if(target_area.ceiling == CEILING_METAL)
			marker_color = "#ffff55"
	else if(istype(signal_loc, /obj/structure/machinery/defenses/planted_flag))
		marker_label = "FLAG [target_id]"
	var/pixel_x = MINIMAP_PIXEL_FROM_WORLD(location.x) + display.x_offset - 3
	var/pixel_y = MINIMAP_PIXEL_FROM_WORLD(location.y) + display.y_offset - 3
	var/key = "[pixel_x]-[pixel_y]-[marker_color]-[marker_label]"
	if(minimap_blip && minimap_blip_key == key)
		return minimap_blip
	var/icon/marker = icon('icons/ui_icons/minimap.dmi')
	marker.Crop(1, 1, 7, 7)
	marker.DrawBox(marker_color, 1, 4, 7, 4)
	marker.DrawBox(marker_color, 4, 1, 4, 7)
	minimap_blip = image(marker)
	minimap_blip.pixel_x = pixel_x
	minimap_blip.pixel_y = pixel_y
	minimap_blip.layer = FLOAT_LAYER
	minimap_blip.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	minimap_blip.maptext = MAPTEXT("<span style='color: [marker_color]'>[marker_label]</span>")
	minimap_blip.maptext_width = 160
	minimap_blip.maptext_y = 9
	minimap_blip_key = key
	return minimap_blip

/datum/cas_signal/proc/get_name()
	var/area/laser_area = get_area(signal_loc)
	var/obstructed = obstructed_signal()?"OBSTRUCTED":""
	if(laser_area)
		return "[name] ([laser_area.name]) [obstructed]"
	return "[name] [obstructed]"

//prevents signal from being triggered from pockets. It has to be on turf
/datum/cas_signal/proc/valid_signal()
	var/obj/object = signal_loc
	var/area/laser_area = get_area(signal_loc)
	var/new_z = z_descend(signal_loc)
	return istype(object) && istype(object.loc,/turf/) && istype(laser_area) && (penetrates_roof || laser_area.ceiling < CEILING_DEEP_UNDERGROUND_METAL) && new_z == z_initial

/datum/cas_signal/proc/obstructed_signal()
	var/area/laser_area = get_area(signal_loc)
	return !istype(laser_area) || (!penetrates_roof && CEILING_IS_PROTECTED(laser_area.ceiling, CEILING_PROTECTION_TIER_2))

/// Prevents direct fire from penetrating metal roofs when a locked target is under one
/proc/cas_direct_fire_visible(atom/target)
	var/turf/target_turf = get_turf(target)
	var/area/target_area = get_area(target_turf)
	return target_turf && is_ground_level(target_turf.z) && target_area && (target_area.ceiling == CEILING_NONE || target_area.ceiling == CEILING_GLASS)

/proc/z_descend(loc)
	var/sloc = loc
	while(sloc && !sloc:z)
		sloc = sloc:loc
	if(!sloc)
		return null
	return sloc:z

/// Designator feedback requires a comms route and an airborne dropship.
/proc/send_cas_target_feedback(obj/designator, obj/effect/overlay/temp/laser_target/laser, obj/structure/machinery/computer/dropship_weapons/console, attack_type = null)
	var/turf/location = get_turf(designator)
	if(QDELETED(laser) || !location || !is_ground_level(location.z))
		return FALSE
	if(!has_cas_feedback_comms(laser.user, location))
		return FALSE
	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(console.shuttle_tag)
	if(!dropship || !istype(dropship.get_docked(), /obj/docking_port/stationary/transit))
		return FALSE
	if(attack_type)
		playsound(designator, attack_type == "direct fire" ? 'sound/machines/twobeep.ogg' : 'sound/machines/beepalert.ogg', 15, FALSE)
		to_chat(laser.user, SPAN_NOTICE("The designator signals: [dropship.name] is engaging your laser."))
		return TRUE
	playsound(designator, 'sound/machines/chime.ogg', 15, FALSE)
	to_chat(laser.user, SPAN_NOTICE("The designator chirps: [dropship.name] has acquired your laser."))
	return TRUE

/// Notify the original designator.
/datum/cas_signal/proc/notify_cas_fire(obj/structure/machinery/computer/dropship_weapons/console, is_firemission = FALSE)
	var/obj/designator = designator_ref?.resolve()
	if(!designator || !istype(signal_loc, /obj/effect/overlay/temp/laser_target))
		return FALSE
	return send_cas_target_feedback(designator, signal_loc, console, is_firemission ? "a firemission" : "direct fire")

/// Tcomms, ARC, RTO Backpack and Scout Helmet allow feedback ping.
/proc/has_cas_feedback_comms(mob/living/carbon/human/user, turf/location)
	if(!location || !is_ground_level(location.z))
		return FALSE
	for(var/obj/structure/machinery/telecomms/relay/relay in SSradio.tcomm_machines_ground)
		if(relay.on && !relay.inoperable(EMPED))
			return TRUE
	if(!QDELETED(user) && user.z == location.z)
		if(istype(user.back, /obj/item/storage/backpack/marine/satchel/rto) || istype(user.head, /obj/item/clothing/head/helmet/marine/radio_helmet/scout))
			return TRUE
	for(var/obj/vehicle/multitile/arc/arc in GLOB.all_multi_vehicles)
		if(QDELETED(arc) || arc.z != location.z || arc.health <= 0 || !arc.antenna_deployed)
			continue
		var/obj/item/hardpoint/support/arc_antenna/antenna = locate() in arc.hardpoints
		if(antenna && antenna.health > 0 && !antenna.deploying)
			return TRUE
	return FALSE
