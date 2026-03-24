/// range that we can remove labels when we click near them with the removal tool
#define LABEL_REMOVE_RANGE 20
/// How often a tacmap can be submitted
#define CANVAS_COOLDOWN_TIME 3 MINUTES
/// List of minimap_flag=world.time for a faction wide cooldown on tacmap submissions
GLOBAL_VAR_INIT(faction_tacmap_cooldown, alist()) // TODO: Change to GLOBAL_ALIST_EMPTY
///A player needs to be unbanned from ALL these roles in order to be able to use the minimap drawing tool
GLOBAL_LIST_INIT(roles_allowed_minimap_draw, list(JOB_SQUAD_LEADER, JOB_SQUAD_TEAM_LEADER, JOB_SO, JOB_XO, JOB_CO))
GLOBAL_PROTECT(roles_allowed_minimap_draw)

/**
 *  # Minimaps subsystem
 *
 * Handles updating and handling of the by-zlevel minimaps
 *
 * Minimaps are a low priority subsystem that fires relatively often
 * the Initialize proc for this subsystem draws the maps as one of the last initializing subsystems
 *
 * Fire() for this subsystem doens't actually updates anything, and purely just reapplies the overlays that it already tracks
 * actual updating of marker locations is handled by [/datum/controller/subsystem/minimaps/proc/on_move]
 * and zlevel changes are handled in [/datum/controller/subsystem/minimaps/proc/on_z_change]
 * tracking of the actual atoms you want to be drawn on is done by means of datums holding info pertaining to them with [/datum/hud_displays]
 *
 * Todo
 * *: add fetching of images to allow stuff like adding/removing xeno crowns easily
 * *: add a system for viscontents so things like minimap draw are more responsive
 */
SUBSYSTEM_DEF(minimaps)
	name = "Minimaps"
	init_order = SS_INIT_MINIMAP
	priority = SS_PRIORITY_MINIMAPS
	wait = 10
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	///Minimap hud display datums sorted by zlevel
	var/list/datum/hud_displays/minimaps_by_z = list()
	///Assoc list of images we hold by their source
	var/list/image/images_by_source = list()
	///the update target datums, sorted by update flag type
	var/list/update_targets = list()
	///Nonassoc list of updators we want to have their overlays reapplied
	var/list/datum/minimap_updator/update_targets_unsorted = list()
	///Assoc list of removal callbacks to invoke to remove images from the raw lists
	var/list/datum/callback/removal_cbs = list()
	///list of holders for data relating to tracked zlevel and tracked atum
	var/list/datum/minimap_updator/updators_by_datum = list()
	///assoc list of hash = image of images drawn by players
	var/list/image/drawn_images = list()
	///assoc list of CIC private drawings
	var/list/image/cic_drawings = list()
	///assoc list of transmitted drawings
	var/list/image/transmitted_drawings = list()
	///list of callbacks we need to invoke late because Initialize happens early, or a Z-level was loaded after init
	var/list/list/datum/callback/earlyadds = list()
	///assoc list of minimap objects that are hashed so we have to update as few as possible
	var/list/hashed_minimaps = list()
	///list of individual client minimap copies for tracking and updates
	var/list/atom/movable/screen/minimap/client_minimap_copies = list()
	///assoc list storing frozen overlay states when updates are sent
	var/list/frozen_overlay_states = list()

/datum/controller/subsystem/minimaps/Initialize()
	initialized = TRUE
	for(var/datum/space_level/z_level as anything in SSmapping.z_list)
		load_new_z(null, z_level)

	return SS_INIT_SUCCESS

/datum/controller/subsystem/minimaps/stat_entry(msg)
	msg = "Upd:[length(update_targets_unsorted)] Mark:[length(removal_cbs)]"
	return ..()

/datum/controller/subsystem/minimaps/Recover()
	minimaps_by_z = SSminimaps.minimaps_by_z
	images_by_source = SSminimaps.images_by_source
	update_targets = SSminimaps.update_targets
	update_targets_unsorted = SSminimaps.update_targets_unsorted
	removal_cbs = SSminimaps.removal_cbs
	updators_by_datum = SSminimaps.updators_by_datum
	drawn_images = SSminimaps.drawn_images

/datum/controller/subsystem/minimaps/fire(resumed)
	var/static/iteration = 0
	var/depthcount = 0
	for(var/datum/minimap_updator/updator as anything in update_targets_unsorted)
		if(depthcount < iteration) //under high load update in chunks
			depthcount++
			continue

		var/atom/movable/screen/minimap/target = updator.minimap
		if(istype(target) && !target.live)
			update_targets_unsorted -= updator
			continue

		// Preserve drawing overlays when updating minimap overlays
		var/list/combined_overlays = list()

		// Filter raw_blips for observer maps to exclude labels
		if(istype(target) && target.is_observer_minimap)
			// For observer maps, filter out any labels
			for(var/image/blip as anything in updator.raw_blips)
				if(!blip.maptext)
					combined_overlays += blip
		else
			// For non-observer maps, use all raw_blips
			combined_overlays = updator.raw_blips.Copy()

		if(length(target.current_drawing_overlays))
			combined_overlays += target.current_drawing_overlays
		updator.minimap.overlays = combined_overlays
		depthcount++
		iteration++
		if(MC_TICK_CHECK)
			return
	iteration = 0

///Creates a minimap for a particular z level
/datum/controller/subsystem/minimaps/proc/load_new_z(datum/dcs, datum/space_level/z_level)
	SIGNAL_HANDLER

	var/level = z_level.z_value
	minimaps_by_z["[level]"] = new /datum/hud_displays
	if(!is_mainship_level(level) && !is_ground_level(level) && !(SSmapping.level_trait(level, ZTRAIT_AWAY))) //todo: maybe move this around
		return
	var/datum/hud_displays/hud_data = minimaps_by_z["[level]"]
	var/icon/icon_gen = new('icons/ui_icons/minimap.dmi') //600x600 blank icon template for drawing on the map
	var/icon/ceiling_overlay = icon('icons/ui_icons/minimap.dmi')
	var/xmin = world.maxx
	var/ymin = world.maxy
	var/xmax = 1
	var/ymax = 1

	for(var/xval = 1 to world.maxx)
		for(var/yval = 1 to world.maxy) //Scan all the turfs and draw as needed
			var/turf/location = locate(xval,yval,level)
			if(istype(location, /turf/open/space))
				continue
			var/area/turfloc = location.loc
			var/base_color = location.minimap_color
			var/ceiling_color
			if(turfloc.ceiling >= CEILING_PROTECTION_TIER_4)
				ceiling_color = MINIMAP_CEILING_TIER_4
			else if(turfloc.ceiling >= CEILING_PROTECTION_TIER_3)
				ceiling_color = MINIMAP_CEILING_TIER_3
			else if(turfloc.ceiling >= CEILING_PROTECTION_TIER_2)
				ceiling_color = MINIMAP_CEILING_TIER_2
			else if(turfloc.ceiling >= CEILING_PROTECTION_TIER_1)
				ceiling_color = MINIMAP_CEILING_TIER_1
			else if(turfloc.ceiling >= CEILING_GLASS)
				ceiling_color = MINIMAP_CEILING_TIER_GLASS

			if(location.density)
				if(!istype(location, /turf/closed/wall/almayer/outer)) // Ignore almayer border
					xmin = min(xmin, xval)
					ymin = min(ymin, yval)
					xmax = max(xmax, xval)
					ymax = max(ymax, yval)
			else
				var/atom/movable/alttarget = (locate(/obj/structure/machinery/door) in location) || (locate(/obj/structure/fence) in location)
				if(alttarget)
					base_color = alttarget.minimap_color
				else if(turfloc.minimap_color)
					base_color = BlendRGB(location.minimap_color, turfloc.minimap_color, 0.5)

			xmin = min(xmin, xval)
			ymin = min(ymin, yval)
			xmax = max(xmax, xval)
			ymax = max(ymax, yval)

			icon_gen.DrawBox(base_color, xval, yval)
			if(ceiling_color)
				ceiling_overlay.DrawBox(ceiling_color, xval, yval)

	xmin = xmin * MINIMAP_SCALE - 1
	ymin = ymin * MINIMAP_SCALE - 1
	xmax = min(xmax * MINIMAP_SCALE, MINIMAP_PIXEL_SIZE)
	ymax = min(ymax * MINIMAP_SCALE, MINIMAP_PIXEL_SIZE)

	icon_gen.Scale(icon_gen.Width() * MINIMAP_SCALE, icon_gen.Height() * MINIMAP_SCALE) //scale it up x2 to make it easer to see
	icon_gen.Crop(xmin, ymin, MINIMAP_PIXEL_SIZE + xmin - 1, MINIMAP_PIXEL_SIZE + ymin - 1) //then trim it down also cutting anything unused on the bottom left
	// ditto for the ceiling
	ceiling_overlay.Scale(ceiling_overlay.Width() * MINIMAP_SCALE, ceiling_overlay.Height() * MINIMAP_SCALE)
	ceiling_overlay.Crop(xmin, ymin, MINIMAP_PIXEL_SIZE + xmin - 1, MINIMAP_PIXEL_SIZE + ymin - 1)

	// Determine and assign the offsets
	hud_data.x_offset = floor((MINIMAP_PIXEL_SIZE - xmax - 1) / 2) - xmin
	hud_data.y_offset = floor((MINIMAP_PIXEL_SIZE - ymax - 1) / 2) - ymin
	hud_data.x_max = xmax
	hud_data.y_max = ymax
	hud_data.scaled_x_min = xmin
	hud_data.scaled_y_min = ymin

	// Center the map icon
	icon_gen.Shift(EAST, hud_data.x_offset + xmin)
	icon_gen.Shift(NORTH, hud_data.y_offset + ymin)

	ceiling_overlay.Shift(EAST, hud_data.x_offset + xmin)
	ceiling_overlay.Shift(NORTH, hud_data.y_offset + ymin)

	// Cache the overlay for all clients to use
	hud_data.hud_image = icon_gen //done making the image!
	hud_data.cached_ceiling_overlay = ceiling_overlay

	//lateload icons
	if(!LAZYACCESS(earlyadds, "[level]"))
		return

	for(var/datum/callback/callback as anything in LAZYACCESS(earlyadds, "[level]"))
		callback.Invoke()
	LAZYREMOVE(earlyadds, "[level]")

/// Creates ceiling protection overlay for a specific client and z-level
/datum/controller/subsystem/minimaps/proc/create_ceiling_overlay(client/target_client, z_level)
	if(!target_client?.prefs?.show_minimap_ceiling_protection)
		return null

	var/datum/hud_displays/hud_data = minimaps_by_z["[z_level]"]
	if(!hud_data)
		return null

	// Return cached overlay
	return hud_data.cached_ceiling_overlay

/datum/controller/subsystem/minimaps/proc/regenerate_minimap_for_z(z_level)
	if(!minimaps_by_z["[z_level]"])
		return

	var/datum/space_level/space_level = SSmapping.z_list[z_level]
	if(!space_level)
		return

	// Clear the old minimap data but preserve the structure
	var/datum/hud_displays/old_display = minimaps_by_z["[z_level]"]
	minimaps_by_z["[z_level]"] = new /datum/hud_displays

	// Copy over any existing drawn images
	if(old_display?.drawing_image)
		minimaps_by_z["[z_level]"].drawing_image = old_display.drawing_image

/**
 * Adds an atom to the processing updators that will have blips drawn on them
 * Arguments:
 * * target: the target we want to be updating the overlays on
 * * flags: flags for the types of blips we want to be updated
 * * ztarget: zlevel we want to be updated with
 */
/datum/controller/subsystem/minimaps/proc/add_to_updaters(atom/target, flags, ztarget, drawing, labels)
	var/datum/minimap_updator/holder = new(target, ztarget, drawing)
	for(var/flag in bitfield2list(flags))
		LAZYADD(update_targets["[flag]"], holder)

		// Check if this is a non-live minimap that should get frozen blip positions
		var/use_frozen_blips = FALSE
		var/atom/movable/screen/minimap/minimap_target
		if(istype(target, /atom/movable/screen/minimap))
			minimap_target = target
		if(minimap_target)
			if(!minimap_target.live)
				var/frozen_key = "[ztarget]-[flag]"
				if(frozen_overlay_states[frozen_key])
					// Use frozen blips for late joiners
					for(var/image/frozen_blip in frozen_overlay_states[frozen_key])
						// Only add if it's actually a blip
						if(frozen_blip.icon_state)
							holder.raw_blips += frozen_blip
					use_frozen_blips = TRUE

		// If no frozen state available or this is a live map, use current blips
		if(!use_frozen_blips)
			holder.raw_blips += minimaps_by_z["[ztarget]"].images_raw["[flag]"]
		if(holder.drawing)
			var/add_drawings = TRUE
			if(minimap_target)
				if(minimap_target.live)
					add_drawings = FALSE
			if(add_drawings)
				if(minimap_target)
					if(!minimap_target.live && minimap_target.drawing)
						if(cic_drawings["[ztarget]-[flag]"])
							holder.raw_blips += cic_drawings["[ztarget]-[flag]"]
				else
					// Other non-live updators get CIC drawings
					if(cic_drawings["[ztarget]-[flag]"])
						holder.raw_blips += cic_drawings["[ztarget]-[flag]"]
		if(!labels)
			continue
		LAZYADD(update_targets["[flag]label"], holder)
	updators_by_datum[target] = holder
	update_targets_unsorted += holder
	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(remove_updator))

/// Applies existing drawings to live minimaps after a Live Update is sent
/datum/controller/subsystem/minimaps/proc/apply_drawings_to_live_minimaps(minimap_flag)
	// First, copy CIC drawings to transmitted storage for this update
	for(var/cic_hash in cic_drawings)
		var/image/cic_drawing = cic_drawings[cic_hash]
		if(cic_drawing)
			var/image/transmitted_copy = new(cic_drawing.icon, cic_drawing.icon_state, cic_drawing.layer, cic_drawing.dir)
			transmitted_copy.pixel_x = cic_drawing.pixel_x
			transmitted_copy.pixel_y = cic_drawing.pixel_y
			transmitted_copy.plane = TACMAP_PLANE
			transmitted_copy.layer = -0.6
			transmitted_copy.alpha = cic_drawing.alpha
			transmitted_copy.color = cic_drawing.color
			transmitted_copy.transform = cic_drawing.transform
			transmitted_copy.appearance_flags = cic_drawing.appearance_flags
			transmitted_copy.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
			// Copy maptext properties for labels
			transmitted_copy.maptext = cic_drawing.maptext
			transmitted_copy.maptext_x = cic_drawing.maptext_x
			transmitted_copy.maptext_y = cic_drawing.maptext_y
			transmitted_copy.maptext_width = cic_drawing.maptext_width
			transmitted_drawings[cic_hash] = transmitted_copy
			// Update legacy storage
			drawn_images[cic_hash] = transmitted_copy

	// Now capture frozen state for latejoiners after drawings are transmitted
	for(var/z_level in minimaps_by_z)
		var/list/frozen_overlays = list()
		for(var/flag in bitfield2list(minimap_flag))
			// Capture ALL current blips from images_raw at this exact moment
			for(var/image/live_blip in minimaps_by_z[z_level].images_raw["[flag]"])
				var/image/frozen_blip = new(live_blip.icon, live_blip.icon_state, live_blip.layer, live_blip.dir)
				frozen_blip.pixel_x = live_blip.pixel_x
				frozen_blip.pixel_y = live_blip.pixel_y
				frozen_blip.plane = live_blip.plane
				frozen_blip.alpha = live_blip.alpha
				frozen_blip.color = live_blip.color
				frozen_blip.transform = live_blip.transform
				frozen_blip.appearance_flags = live_blip.appearance_flags
				frozen_blip.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
				frozen_blip.overlays = live_blip.overlays.Copy()
				frozen_overlays += frozen_blip

			// Add transmitted drawings for frozen states
			if(transmitted_drawings["[z_level]-[flag]"])
				frozen_overlays += transmitted_drawings["[z_level]-[flag]"]

			// Add transmitted labels
			for(var/key in transmitted_drawings)
				if(findtext(key, "[z_level]-[flag]label-"))
					frozen_overlays += transmitted_drawings[key]

		frozen_overlay_states["[z_level]-[minimap_flag]"] = frozen_overlays

	// Update existing late joiner minimaps with the new frozen state
	for(var/atom/movable/screen/minimap/client_map in client_minimap_copies)
		if(client_map.live || !(client_map.minimap_flags & minimap_flag))
			continue
		var/frozen_key = "[client_map.target]-[client_map.minimap_flags]"
		if(frozen_overlay_states[frozen_key] && client_map.drawing)
			// Apply new frozen state to existing late joiner minimaps
			var/list/safe_overlays = list()
			for(var/image/overlay in frozen_overlay_states[frozen_key])
				safe_overlays += overlay
			client_map.overlays = safe_overlays

	// Now apply transmitted drawings to live minimaps only
	for(var/datum/minimap_updator/updator in update_targets_unsorted)
		var/atom/movable/screen/minimap/target = updator.minimap
		if(istype(target) && target.live && target.minimap_flags & minimap_flag)
			target.update_drawing_overlay(show_cic_drawings = FALSE)

	// Also update non-live client minimap copies that match this minimap flag
	for(var/atom/movable/screen/minimap/client_map in client_minimap_copies)
		if(!client_map.live && (client_map.minimap_flags & minimap_flag) && client_map.drawing)
			client_map.update_drawing_overlay(show_cic_drawings = FALSE)

/// Refreshes all non-live minimaps with current data
/datum/controller/subsystem/minimaps/proc/refresh_static_minimaps(minimap_flag)
	// Store frozen overlay state for latejoiners before updating existing minimaps
	for(var/z_level in minimaps_by_z)
		var/list/frozen_overlays = list()
		for(var/flag in bitfield2list(minimap_flag))
			frozen_overlays |= minimaps_by_z[z_level].images_raw["[flag]"]
			if(drawn_images["[z_level]-[flag]"])
				frozen_overlays |= drawn_images["[z_level]-[flag]"]
			frozen_overlays |= minimaps_by_z[z_level].images_raw["[flag]label"]
			if(drawn_images["[z_level]-[flag]label"])
				frozen_overlays |= drawn_images["[z_level]-[flag]label"]
		frozen_overlay_states["[z_level]-[minimap_flag]"] = frozen_overlays

	// Update individual client copies with overlay system
	for(var/atom/movable/screen/minimap/client_map in client_minimap_copies)
		if(client_map.live || !(client_map.minimap_flags & minimap_flag))
			continue

		// Update drawing overlays for non-live maps
		if(client_map.drawing)
			client_map.update_drawing_overlay(show_cic_drawings = FALSE)

/// Refreshes CIC drawing overlays for real time updates
/datum/controller/subsystem/minimaps/proc/refresh_cic_drawing_overlays(zlevel, minimap_flag)
	for(var/datum/minimap_updator/updator in update_targets_unsorted)
		var/atom/movable/screen/minimap/target = updator.minimap
		if(istype(target) && target.is_cic_minimap && target.target == zlevel && target.minimap_flags & minimap_flag)
			target.update_drawing_overlay(show_cic_drawings = TRUE)

/// Applies existing drawings to a specific live minimap when first opened
/datum/controller/subsystem/minimaps/proc/apply_existing_drawings_to_minimap(atom/movable/screen/minimap/target_map, minimap_flags)
	if(!istype(target_map) || !target_map.live || target_map.drawing)
		return

	var/datum/minimap_updator/updator = updators_by_datum[target_map]
	if(!updator)
		return

	// Check if there are any existing transmitted drawings for this map's flags and zlevel
	var/has_drawings = FALSE
	for(var/flag in bitfield2list(minimap_flags))
		if(transmitted_drawings["[target_map.target]-[flag]"])
			has_drawings = TRUE
			break
		// Check for any labels
		for(var/key in transmitted_drawings)
			if(findtext(key, "[target_map.target]-[flag]label-"))
				has_drawings = TRUE
				break
		if(has_drawings)
			break

	if(has_drawings)
		// Add existing transmitted drawings to this live minimap
		for(var/flag in bitfield2list(minimap_flags))
			if(transmitted_drawings["[target_map.target]-[flag]"])
				updator.raw_blips += transmitted_drawings["[target_map.target]-[flag]"]
			// Add all transmitted labels for this z-level and flag combination
			for(var/key in transmitted_drawings)
				if(findtext(key, "[target_map.target]-[flag]label-"))
					updator.raw_blips += transmitted_drawings[key]

		// Update overlays to show existing drawings
		target_map.overlays = updator.raw_blips

/// Removes client copy from tracking when deleted
/datum/controller/subsystem/minimaps/proc/remove_client_copy(atom/movable/screen/minimap/source)
	SIGNAL_HANDLER
	client_minimap_copies -= source
	UnregisterSignal(source, COMSIG_PARENT_QDELETING)

/**
 * Removes a atom from the subsystems updating overlays
 */
/datum/controller/subsystem/minimaps/proc/remove_updator(atom/target)
	SIGNAL_HANDLER
	UnregisterSignal(target, COMSIG_PARENT_QDELETING)
	var/datum/minimap_updator/holder = updators_by_datum[target]
	updators_by_datum -= target
	for(var/key in update_targets)
		LAZYREMOVE(update_targets[key], holder)
	update_targets_unsorted -= holder

/**
 * Holder datum for a zlevels data, concerning the overlays and the drawn level itself
 * The individual image trackers have a raw and a normal list
 * raw lists just store the images, while the normal ones are assoc list of [tracked_atom] = image
 * the raw lists are to speed up the Fire() of the subsystem so we don't have to filter through
 */
/datum/hud_displays
	///Actual icon of the drawn zlevel with all of its atoms
	var/icon/hud_image
	///Assoc list of updating images; list("[flag]" = list([source] = blip)
	var/list/images_assoc = list()
	///Raw list containing updating images by flag; list("[flag]" = list(blip))
	var/list/images_raw = list()
	///drawing image of the map
	var/image/drawing_image
	///Cached ceiling protection overlay to prevent lagspikes
	var/icon/cached_ceiling_overlay
	///x offset of the actual icon to center it to screens
	var/x_offset = 0
	///y offset of the actual icons to keep it to screens
	var/y_offset = 0
	///max x for this zlevel
	var/x_max = 1
	///max y for this zlevel
	var/y_max = 1
	///scaled x minimum for ceiling overlay positioning
	var/scaled_x_min = 1
	///scaled y minimum for ceiling overlay positioning
	var/scaled_y_min = 1

/datum/hud_displays/New()
	..()
	for(var/flag in GLOB.all_minimap_flags)
		images_assoc["[flag]"] = list()
		images_raw["[flag]"] = list()
		images_assoc["[flag]label"] = list()
		images_raw["[flag]label"] = list()

/**
 * Holder datum to ease updating of atoms to update
 */
/datum/minimap_updator
	/// Atom to update with the overlays
	var/atom/minimap
	///Target zlevel we want to be updating to
	var/ztarget = 0
	/// list of overlays we update
	var/list/raw_blips
	/// does this updator showing map drawing
	var/drawing

/datum/minimap_updator/New(minimap, ztarget, drawing)
	..()
	src.minimap = minimap
	src.ztarget = ztarget
	src.drawing = drawing
	raw_blips = list()

/**
 * Adds an atom we want to track with blips to the subsystem
 * Arguments:
 * * target: atom we want to track
 * * hud_flags: tracked HUDs we want this atom to be displayed on
 * * marker: image or mutable_appearance we want to be using on the map
 */
/datum/controller/subsystem/minimaps/proc/add_marker(atom/target, hud_flags = NONE, image/blip, image_x, image_y, is_label=FALSE)
	if(!isatom(target) || !hud_flags || !blip)
		CRASH("Invalid marker added to subsystem")

	var/actual_z = target.z
	if(ismob(target) && target.loc && !isturf(target.loc))
		actual_z = target.loc.z

	if(!initialized || !(minimaps_by_z["[actual_z]"])) //the minimap doesn't exist yet, z level was probably loaded after init
		for(var/datum/callback/callback as anything in LAZYACCESS(earlyadds, "[actual_z]"))
			if(callback.arguments[1] == target)
				return
		LAZYADDASSOCLIST(earlyadds, "[actual_z]", CALLBACK(src, PROC_REF(add_marker), target, hud_flags, blip))
		RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(remove_earlyadd), override = TRUE) //Override required for late z-level loading to prevent hard dels where an atom is initiated during z load, but is qdel'd before it finishes
		return


	var/turf/target_turf = get_turf(target)
	if(ismob(target) && target.loc && !isturf(target.loc))
		target_turf = get_turf(target.loc)

	blip.pixel_x = MINIMAP_PIXEL_FROM_WORLD(target_turf.x) + minimaps_by_z["[target_turf.z]"].x_offset + image_x
	blip.pixel_y = MINIMAP_PIXEL_FROM_WORLD(target_turf.y) + minimaps_by_z["[target_turf.z]"].y_offset + image_y

	images_by_source[target] = blip
	for(var/flag in bitfield2list(hud_flags))
		if(is_label)
			flag = "[flag]label"
		minimaps_by_z["[target_turf.z]"].images_assoc["[flag]"][target] = blip
		minimaps_by_z["[target_turf.z]"].images_raw["[flag]"] += blip
		for(var/datum/minimap_updator/updator as anything in update_targets["[flag]"])
			if(target_turf.z == updator.ztarget)
				updator.raw_blips += blip
	if(ismovableatom(target))
		RegisterSignal(target, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(on_z_change))
		blip.RegisterSignal(target, COMSIG_MOVABLE_MOVED, TYPE_PROC_REF(/image, minimap_on_move))
	removal_cbs[target] = CALLBACK(src, PROC_REF(removeimage), blip, target, hud_flags)
	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(remove_marker), override = TRUE) //override for atoms that were on a late loaded z-level, overrides the remove_earlyadd above

///Removes the object from the earlyadds list, in case it was qdel'd before the z-level was fully loaded
/datum/controller/subsystem/minimaps/proc/remove_earlyadd(atom/source)
	SIGNAL_HANDLER
	remove_marker(source)
	var/actual_z = source.z
	if(ismob(source) && source.loc && !isturf(source.loc))
		actual_z = source.loc.z
	for(var/datum/callback/callback in LAZYACCESS(earlyadds, "[actual_z]"))
		if(callback.arguments[1] != source)
			continue
		earlyadds["[actual_z]"] -= callback
		UnregisterSignal(source, COMSIG_PARENT_QDELETING)
		return

/**
 * removes an image from raw tracked lists, invoked by callback
 */
/datum/controller/subsystem/minimaps/proc/removeimage(image/blip, atom/target, hud_flags)
	var/turf/target_turf = get_turf(target)
	for(var/flag in bitfield2list(hud_flags))
		minimaps_by_z["[target_turf.z]"].images_raw["[flag]"] -= blip
		for(var/datum/minimap_updator/updator as anything in update_targets["[flag]"])
			if(updator.ztarget == target_turf.z)
				updator.raw_blips -= blip
		minimaps_by_z["[target_turf.z]"].images_raw["[flag]label"] -= blip
		for(var/datum/minimap_updator/updator as anything in update_targets["[flag]label"])
			if(updator.ztarget == target_turf.z)
				updator.raw_blips -= blip
	blip.UnregisterSignal(target, COMSIG_MOVABLE_MOVED)
	removal_cbs -= target

/**
 * Called on zlevel change of a blip-atom so we can update the image lists as needed
 *
 * TODO gross amount of assoc usage and unneeded ALL FLAGS iteration
 */
/datum/controller/subsystem/minimaps/proc/on_z_change(atom/movable/source, oldz, newz)
	SIGNAL_HANDLER
	var/image/blip
	// Assumption: Never would a label be attached to a moveable atom
	for(var/flag in GLOB.all_minimap_flags)
		if(!minimaps_by_z["[oldz]"]?.images_assoc["[flag]"][source])
			continue
		if(!blip)
			blip = minimaps_by_z["[oldz]"].images_assoc["[flag]"][source]
			blip.minimap_on_move(source, null)
		// todo maybe make update_targets also sort by zlevel?
		for(var/datum/minimap_updator/updator as anything in update_targets["[flag]"])
			if(updator.ztarget == oldz)
				updator.raw_blips -= blip
			else if(updator.ztarget == newz)
				updator.raw_blips += blip
		minimaps_by_z["[newz]"].images_assoc["[flag]"][source] = blip
		minimaps_by_z["[oldz]"].images_assoc["[flag]"] -= source

		minimaps_by_z["[newz]"].images_raw["[flag]"] += blip
		minimaps_by_z["[oldz]"].images_raw["[flag]"] -= blip
/**
 * Simple proc, updates overlay position on the map when a atom moves
 */
/image/proc/minimap_on_move(atom/movable/source, oldloc)
	SIGNAL_HANDLER
	if(isturf(source.loc))
		pixel_x = MINIMAP_PIXEL_FROM_WORLD(source.x) + SSminimaps.minimaps_by_z["[source.z]"].x_offset
		pixel_y = MINIMAP_PIXEL_FROM_WORLD(source.y) + SSminimaps.minimaps_by_z["[source.z]"].y_offset
		return

	var/atom/movable/movable_loc = source.loc
	source.override_minimap_tracking(source.loc)
	pixel_x = MINIMAP_PIXEL_FROM_WORLD(movable_loc.x) + SSminimaps.minimaps_by_z["[movable_loc.z]"].x_offset
	pixel_y = MINIMAP_PIXEL_FROM_WORLD(movable_loc.y) + SSminimaps.minimaps_by_z["[movable_loc.z]"].y_offset

///Used to handle minimap tracking inside other movables
/atom/movable/proc/override_minimap_tracking(atom/movable/loc)
	var/image/blip = SSminimaps.images_by_source[src]
	blip.RegisterSignal(loc, COMSIG_MOVABLE_MOVED, TYPE_PROC_REF(/image, minimap_on_move))
	RegisterSignal(loc, COMSIG_ATOM_EXITED, PROC_REF(cancel_override_minimap_tracking))

///Stops minimap override tracking
/atom/movable/proc/cancel_override_minimap_tracking(atom/movable/source, atom/movable/mover)
	SIGNAL_HANDLER
	if(mover != src)
		return
	var/image/blip = SSminimaps.images_by_source[src]
	blip?.UnregisterSignal(source, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(source, COMSIG_ATOM_EXITED)


/**
 * Removes an atom and it's blip from the subsystem
 */
/datum/controller/subsystem/minimaps/proc/remove_marker(atom/source)
	SIGNAL_HANDLER
	if(!removal_cbs[source]) //already removed
		return
	UnregisterSignal(source, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_Z_CHANGED))
	var/turf/source_turf = get_turf(source)
	for(var/flag in GLOB.all_minimap_flags)
		minimaps_by_z["[source_turf.z]"].images_assoc["[flag]"] -= source
		minimaps_by_z["[source_turf.z]"].images_assoc["[flag]label"] -= source
	images_by_source -= source
	removal_cbs[source].Invoke()
	removal_cbs -= source

/// Checks if the source has a marker already set
/datum/controller/subsystem/minimaps/proc/has_marker(atom/source)
	var/turf/turf_gotten = get_turf(source)

	if(!turf_gotten)
		return

	var/z_level = turf_gotten.z

	if(minimaps_by_z["[z_level]"])
		for(var/flag in GLOB.all_minimap_flags)
			if(source in minimaps_by_z["[z_level]"].images_assoc["[flag]"])
				return TRUE
			if(source in minimaps_by_z["[z_level]"].images_assoc["[flag]label"])
				return TRUE

	return FALSE

/**
 * Fetches a /atom/movable/screen/minimap instance or creates on if none exists
 * Note this does not destroy them when the map is unused, might be a potential thing to do?
 * Arguments:
 * * zlevel: zlevel to fetch map for
 * * flags: map flags to fetch from
 */
/datum/controller/subsystem/minimaps/proc/fetch_minimap_object(zlevel, flags, live, popup, drawing, client/for_client)
	if(!zlevel || zlevel <= 0 || !SSminimaps.initialized)
		return null
	if(!SSminimaps.minimaps_by_z["[zlevel]"])
		return null

	if(!SSminimaps.minimaps_by_z["[zlevel]"].hud_image)
		return null

	var/hash = "[zlevel]-[flags]-[live]-[popup]-[drawing]"

	if(for_client || (!popup && !live))
		if(!hashed_minimaps[hash])
			// Create and cache the base minimap
			var/atom/movable/screen/minimap/base_map = new(null, null, zlevel, flags, live, popup, drawing)
			if(!base_map.icon)
				CRASH("Empty and unusable minimap generated for '[zlevel]-[flags]-[live]-[popup]'")
			hashed_minimaps[hash] = base_map

		var/atom/movable/screen/minimap/cached_base = hashed_minimaps[hash]
		var/atom/movable/screen/minimap/map = new()

		// Copy essential properties and basic overlay filters
		map.icon = cached_base.icon
		map.target = cached_base.target
		map.minimap_flags = cached_base.minimap_flags
		map.live = cached_base.live
		map.drawing = cached_base.drawing
		map.screen_loc = cached_base.screen_loc
		map.name = cached_base.name
		map.dir = cached_base.dir
		map.x_max = cached_base.x_max
		map.y_max = cached_base.y_max
		map.choices_by_mob = list()
		map.stop_polling = list()

		// Set observer flag based on flags
		if(flags == MINIMAP_FLAG_ALL)
			map.is_observer_minimap = TRUE

		// Apply standard minimap filters
		map.apply_minimap_filters()

		// Register for live updates if needed
		if(live)
			SSminimaps.add_to_updaters(map, flags, zlevel, drawing, labels=drawing)
			// Apply drawing overlays for live maps
			if(drawing)
				map.update_drawing_overlay(show_cic_drawings = FALSE)
		else
			// Track non-live individual copies for tacmap updates
			client_minimap_copies += map
			RegisterSignal(map, COMSIG_PARENT_QDELETING, PROC_REF(remove_client_copy))

			// Apply existing drawings to non-live minimaps for late joiners
			if(drawing)
				var/frozen_key = "[zlevel]-[flags]"
				if(frozen_overlay_states[frozen_key])
					// Use the frozen state from when the last update was sent
					var/list/safe_overlays = list()
					for(var/image/overlay in frozen_overlay_states[frozen_key])
						safe_overlays += overlay
					map.overlays = safe_overlays
				else
					// No frozen state available, apply current transmitted drawings only
					map.update_drawing_overlay(show_cic_drawings = FALSE)

		return map

	var/atom/movable/screen/minimap/map = hashed_minimaps[hash]
	if(!map)
		map = new(null, null, zlevel, flags, live, popup, drawing)
		if(!map.icon) //Don't wanna save an unusable minimap for a z-level.
			CRASH("Empty and unusable minimap generated for '[zlevel]-[flags]-[live]-[popup]'") //Can be caused by atoms calling this proc before minimap subsystem initializing.
		hashed_minimaps[hash] = map
	return map

///fetches the drawing icon for a minimap flag and returns it, creating it if needed. assumes minimap_flag is ONE flag
/datum/controller/subsystem/minimaps/proc/get_drawing_image(zlevel, minimap_flag, drawing)
	var/hash = "[zlevel]-[minimap_flag]"
	if(cic_drawings[hash])
		return cic_drawings[hash]
	var/image/blip = new // could use MA but yolo
	blip.icon = icon('icons/ui_icons/minimap.dmi')
	cic_drawings[hash] = blip
	return blip

///Default HUD screen minimap object
/atom/movable/screen/minimap
	name = "Minimap"
	icon = null
	icon_state = ""
	layer = TACMAP_LAYER
	plane = TACMAP_PLANE
	screen_loc = "1,1"
	appearance_flags = TILE_BOUND|PIXEL_SCALE
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	///assoc list of mob choices by clicking on coords. only exists fleetingly for the wait loop in [/proc/get_coords_from_click]
	var/list/mob/choices_by_mob
	///assoc list to determine if get_coords_from_click should stop waiting for an input for that specific mob
	var/list/mob/stop_polling
	/// How many pixels to shift each update
	var/shift_size = 8
	/// The horizontal max for this map (set at Initialize)
	var/x_max = 1
	/// The vertical max for this map (set at Initialize)
	var/y_max = 1
	/// The current x pixel shift
	var/cur_x_shift = 0
	/// The current y pixel shift
	var/cur_y_shift = 0
	/// Whether the horizontal shift is currently pushing the map westward
	var/west_x_shift = TRUE
	/// Whether the vertical shift is currently pushing the map southward
	var/south_y_shift = TRUE
	/// Is the minimap live
	var/live
	/// Minimap flags
	var/minimap_flags
	/// Minimap target
	var/target
	/// Is drawing enbabled
	var/drawing
	/// Is this a CIC minimap
	var/is_cic_minimap = FALSE
	/// Is this an observer minimap
	var/is_observer_minimap = FALSE
	/// Current drawing overlays for cleanup
	var/list/current_drawing_overlays = list()
	/// Max ratio to x_max/y_max you can scroll the map to
	var/max_scroll_ratio = 0.8

	var/atom/movable/screen/minimap_tool/draw_tool/active_draw_tool
	/// List of turfs that have labels attached to them. kept around so it can be cleared
	var/list/turf/labelled_turfs = list()

/atom/movable/screen/minimap/MouseWheel(delta_x, delta_y, location, control, params)
	var/mob/user = usr
	var/list/mods = params2list(params)

	if(!user)
		return

	var/atom/movable/screen/plane_master/minimap/plane_master = user.hud_used.plane_masters["[TACMAP_PLANE]"]

	if(!plane_master)
		return

	var/matrix/transform = plane_master.transform

	if(!transform)
		plane_master.transform = matrix()

	var/shift_click = mods[SHIFT_CLICK]
	var/x_shift = plane_master.cur_x_shift
	var/max_x_shift = x_max * max_scroll_ratio
	var/y_shift = plane_master.cur_y_shift
	var/max_y_shift = y_max * max_scroll_ratio

	// Out of bounds checks
	if(x_shift > max_x_shift && (shift_click ? delta_y < 0 : delta_x < 0) || x_shift < max_x_shift * -1 && (shift_click ? delta_y > 0 : delta_x > 0))
		return

	if(y_shift > max_y_shift && (shift_click ? delta_x < 0 : delta_y < 0) || y_shift < max_y_shift * -1 && (shift_click ? delta_x > 0 : delta_y > 0))
		return

	if(shift_click)
		transform.Translate(delta_y / 32, delta_x / 32)
		plane_master.cur_x_shift -= delta_y / 32
		plane_master.cur_y_shift -= delta_x / 32
	else
		transform.Translate(delta_x / 32, delta_y / 32)
		plane_master.cur_x_shift -= delta_x / 32
		plane_master.cur_y_shift -= delta_y / 32

	plane_master.transform = transform

/atom/movable/screen/minimap/Initialize(mapload, datum/hud/hud_owner, target, minimap_flags, live = TRUE, popup = FALSE, drawing = TRUE)
	. = ..()
	if(!SSminimaps.minimaps_by_z["[target]"])
		return

	choices_by_mob = list()
	stop_polling = list()
	icon = SSminimaps.minimaps_by_z["[target]"].hud_image
	if(live)
		SSminimaps.add_to_updaters(src, minimap_flags, target, drawing, labels=drawing)
	src.drawing = drawing
	src.minimap_flags = minimap_flags
	src.target = target
	src.live = live

	// Set observer flag based on flags
	if(minimap_flags == MINIMAP_FLAG_ALL)
		src.is_observer_minimap = TRUE

	x_max = SSminimaps.minimaps_by_z["[target]"].x_max
	y_max = SSminimaps.minimaps_by_z["[target]"].y_max

	apply_minimap_filters()

/// Applies the standard set of minimap filters
/atom/movable/screen/minimap/proc/apply_minimap_filters()
	add_filter("border_outline", 1, outline_filter(2, COLOR_BLACK))
	add_filter("map_glow", 2, drop_shadow_filter(x = 0, y = 0, size = 3, offset = 1, color = "#c0f7ff"))
	add_filter("overlay1", 3, layering_filter(x = -480, y = 0, icon = 'icons/mob/hud/minimap_overlay.dmi', blend_mode = BLEND_INSET_OVERLAY))
	add_filter("overlay2", 4, layering_filter(x = 0, y = 0, icon = 'icons/mob/hud/minimap_overlay.dmi', blend_mode = BLEND_INSET_OVERLAY))
	add_filter("overlay3", 5, layering_filter(x = -480, y = 480, icon = 'icons/mob/hud/minimap_overlay.dmi', blend_mode = BLEND_INSET_OVERLAY))
	add_filter("overlay4", 6, layering_filter(x = 0, y = 480, icon = 'icons/mob/hud/minimap_overlay.dmi', blend_mode = BLEND_INSET_OVERLAY))
	add_filter("overlay5", 7, layering_filter(x = 480, y = 0, icon = 'icons/mob/hud/minimap_overlay.dmi', blend_mode = BLEND_INSET_OVERLAY))
	add_filter("overlay6", 8, layering_filter(x = 480, y = 480, icon = 'icons/mob/hud/minimap_overlay.dmi', blend_mode = BLEND_INSET_OVERLAY))

/atom/movable/screen/minimap/proc/update()
	if(live)
		return

	SSminimaps.remove_updator(src)

/// Updates ceiling protection overlay for this minimap
/atom/movable/screen/minimap/proc/update_ceiling_overlay(client/owner_client)
	// Remove any existing ceiling filter
	remove_filter("ceiling_protection")

	// Check if this specific client wants ceiling protection overlay
	if(!owner_client?.prefs?.show_minimap_ceiling_protection)
		return

	// For individual client copies only
	if(!owner_client)
		return

	// Create ceiling overlay for this client
	var/icon/ceiling_overlay = SSminimaps.create_ceiling_overlay(owner_client, target)
	if(ceiling_overlay)
		add_filter("ceiling_protection", 9, layering_filter(icon = ceiling_overlay, blend_mode = BLEND_OVERLAY))

/// Updates drawing overlay for this minimap based on what drawings should be visible
/atom/movable/screen/minimap/proc/update_drawing_overlay(show_cic_drawings = FALSE)
	// Clean up existing drawing overlays
	if(length(current_drawing_overlays))
		overlays -= current_drawing_overlays
		current_drawing_overlays = list()

	if(!drawing)
		return

	var/list/drawing_images = list()

	// Add CIC drawings if this map should see them
	if(show_cic_drawings)
		for(var/flag in bitfield2list(minimap_flags))
			if(SSminimaps.cic_drawings["[target]-[flag]"])
				drawing_images += SSminimaps.cic_drawings["[target]-[flag]"]
			// Add all labels for this z-level and flag combination
			for(var/key in SSminimaps.cic_drawings)
				if(findtext(key, "[target]-[flag]label-"))
					drawing_images += SSminimaps.cic_drawings[key]
	else
		// Add transmitted drawings
		for(var/flag in bitfield2list(minimap_flags))
			if(SSminimaps.transmitted_drawings["[target]-[flag]"])
				drawing_images += SSminimaps.transmitted_drawings["[target]-[flag]"]
			// Add all transmitted labels for this z-level and flag combination
			for(var/key in SSminimaps.transmitted_drawings)
				if(findtext(key, "[target]-[flag]label-"))
					drawing_images += SSminimaps.transmitted_drawings[key]

	if(length(drawing_images))
		// Apply drawing images as overlays directly
		overlays += drawing_images
		current_drawing_overlays = drawing_images.Copy()
	else
		// If no drawing images, make sure we clear any existing overlays
		if(length(current_drawing_overlays))
			overlays -= current_drawing_overlays
			current_drawing_overlays = list()

/atom/movable/screen/minimap/Destroy()
	SSminimaps.hashed_minimaps -= src
	stop_polling = null
	return ..()

/**
 * lets the user get coordinates by clicking the actual map
 * Returns a list(x_coord, y_coord)
 * note: sleeps until the user makes a choice, stop_polling is set to TRUE for this specific user or they disconnect
 */
/atom/movable/screen/minimap/proc/get_coords_from_click(mob/user)
	//lord forgive my shitcode
	var/signal_by_type = isobserver(user) ? COMSIG_OBSERVER_CLICKON : COMSIG_MOB_CLICKON
	RegisterSignal(user, signal_by_type, PROC_REF(on_click), override=TRUE)
	while(!(choices_by_mob[user] || stop_polling[user]) && user.client && islist(stop_polling))
		stoplag(1)
	UnregisterSignal(user, signal_by_type)
	. = choices_by_mob[user]
	choices_by_mob -= user
	// I have an extra layer of shitcode for you
	stop_polling -= user

/**
 * Handles fetching the targetted coordinates when the mob tries to click on this map
 * does the following:
 * turns map targetted pixel into a list(x, y)
 * gets z level of this map
 * x and y minimap centering is reverted, then the x2 scaling of the map is removed
 * round up to correct if an odd pixel was clicked and make sure its valid
 */
/atom/movable/screen/minimap/proc/on_click(mob/source, atom/A, params)
	SIGNAL_HANDLER
	var/list/modifiers = params2list(params)
	if(!modifiers[CTRL_CLICK])
		return
	// we only care about absolute coords because the map is fixed to 1,1 so no client stuff
	var/atom/movable/screen/plane_master/minimap/plane_master = source.hud_used.plane_masters["[TACMAP_PLANE]"]

	if(!plane_master)
		return

	var/list/pixel_coords = params2screenpixel(modifiers["screen-loc"])
	var/zlevel = SSminimaps.updators_by_datum[src].ztarget
	var/x = (pixel_coords[1] - SSminimaps.minimaps_by_z["[zlevel]"].x_offset + plane_master.cur_x_shift)  / MINIMAP_SCALE
	var/y = (pixel_coords[2] - SSminimaps.minimaps_by_z["[zlevel]"].y_offset + plane_master.cur_y_shift)  / MINIMAP_SCALE
	var/c_x = clamp(CEILING(x, 1), 1, world.maxx)
	var/c_y = clamp(CEILING(y, 1), 1, world.maxy)
	choices_by_mob[source] = list(c_x, c_y)
	return COMSIG_MOB_CLICK_CANCELED

/atom/movable/screen/minimap_locator
	name = "You are here"
	icon = 'icons/ui_icons/map_blips.dmi'
	icon_state = "locator"
	plane = TACMAP_PLANE
	layer = INTRO_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/atom/movable/screen/minimap/current_map
	var/currently_tracking
	var/shift_x = 0
	var/shift_y = 0

///Get the current x and y shift and mover of the minimap
/atom/movable/screen/minimap_locator/proc/link_locator(action_map, atom/movable/mover)
	SIGNAL_HANDLER
	if(action_map)
		current_map = action_map
	if(mover)
		currently_tracking = mover
	shift_x = current_map.cur_x_shift
	shift_y = current_map.cur_y_shift

///updates the screen loc of the locator so that it's on the movers location on the minimap
/atom/movable/screen/minimap_locator/proc/update(atom/movable/mover, atom/oldloc, direction)
	SIGNAL_HANDLER
	link_locator()
	var/turf/mover_turf = get_turf(currently_tracking)
	var/x_coord = mover_turf.x * MINIMAP_SCALE
	var/y_coord = mover_turf.y * MINIMAP_SCALE
	x_coord += SSminimaps.minimaps_by_z["[mover_turf.z]"].x_offset - shift_x
	y_coord += SSminimaps.minimaps_by_z["[mover_turf.z]"].y_offset - shift_y
	// + 1 because tiles start at 1
	var/x_tile = FLOOR(x_coord/32, 1) + 1
	// -3 to center the image
	var/x_pixel = x_coord % 32 - 3
	var/y_tile = FLOOR(y_coord/32, 1) + 1
	var/y_pixel = y_coord % 32 - 3
	screen_loc = "[x_tile]:[x_pixel],[y_tile]:[y_pixel]"
	link_locator()

/**
 * Action that gives the owner access to the minimap pool
 */
/datum/action/minimap
	name = "Toggle Minimap"
	action_icon_state = "minimap"
	///Flags to allow the owner to see others of this type
	var/minimap_flags = MINIMAP_FLAG_ALL
	///marker flags this will give the target, mostly used for marine minimaps
	var/marker_flags = MINIMAP_FLAG_ALL
	///boolean as to whether the minimap is currently shown
	var/minimap_displayed = FALSE
	///Minimap object we'll be displaying
	var/atom/movable/screen/minimap/map
	///Overrides what the locator tracks aswell what z the map displays as opposed to always tracking the minimap's owner. Default behavior when null.
	var/atom/movable/locator_override
	///Minimap "You are here" indicator for when it's up
	var/atom/movable/screen/minimap_locator/locator
	///Sets a fixed z level to be tracked by this minimap action instead of being influenced by the owner's / locator override's z level.
	var/default_overwatch_level = 0
	/// Is it live
	var/live = FALSE
	/// Can it see tacmap drawings
	var/drawing = TRUE
	/// Is this a CIC map
	var/is_cic_minimap = FALSE

/datum/action/minimap/New(Target, new_minimap_flags, new_marker_flags)
	. = ..()
	locator = new
	if(new_minimap_flags)
		minimap_flags = new_minimap_flags
	if(new_marker_flags)
		marker_flags = new_marker_flags

/datum/action/minimap/Destroy()
	map = null
	locator_override = null
	QDEL_NULL(locator)
	return ..()

/datum/action/minimap/action_activate()
	. = ..()
	// Try to initialize map if it doesn't exist
	if(!map)
		try_initialize_map()
		if(!map)
			to_chat(owner, SPAN_WARNING("Minimap data is not available for this area yet. Please try again in a moment."))
			return FALSE

	if(!minimap_displayed && !isobserver(owner) && owner.is_mob_incapacitated())
		return FALSE

	return toggle_minimap()

/// Toggles the minimap, has a variable to force on or off (most likely only going to be used to close it)
/datum/action/minimap/proc/toggle_minimap(force_state)
	// No force state? Invert the current state
	if(isnull(force_state))
		force_state = !minimap_displayed
	if(force_state == minimap_displayed)
		return FALSE
	if(!locator_override && ismovableatom(owner.loc))
		override_locator(owner.loc)
	var/atom/movable/tracking = locator_override ? locator_override : owner
	if(force_state)
		if(map in owner.client.screen)
			to_chat(owner, SPAN_WARNING("You already have a minimap open!"))
			return FALSE
		owner.client.add_to_screen(map)
		owner.client.add_to_screen(locator)
		// Apply ceiling protection overlay if client has preference enabled
		if(owner.client.prefs?.show_minimap_ceiling_protection)
			map.update_ceiling_overlay(owner.client)
		locator.link_locator(map, owner)
		locator.update(tracking, null, null)
		// Show ceiling protection toggle action when minimap opens
		for(var/datum/action/minimap_ceiling/ceiling_action in owner.actions)
			ceiling_action.hidden = FALSE
			ceiling_action.update_button_icon()
			// Position the ceiling action right after the minimap action button incase buttons are moved due to a strain or something
			owner.actions.Remove(ceiling_action)
			var/minimap_index = owner.actions.Find(src)
			if(minimap_index)
				owner.actions.Insert(minimap_index + 1, ceiling_action)
			else
				owner.actions.Add(ceiling_action)
			owner.update_action_buttons()
			break
		locator.RegisterSignal(tracking, COMSIG_MOVABLE_MOVED, TYPE_PROC_REF(/atom/movable/screen/minimap_locator, update))
	else
		owner.client.remove_from_screen(map)
		owner.client.remove_from_screen(locator)
		map.stop_polling -= owner
		// Hide ceiling protection toggle action when minimap closes
		for(var/datum/action/minimap_ceiling/ceiling_action in owner.actions)
			ceiling_action.hidden = TRUE
			owner.update_action_buttons()
			break
		locator.UnregisterSignal(tracking, COMSIG_MOVABLE_MOVED)
	minimap_displayed = force_state
	return TRUE

///Overrides the minimap locator to a given atom
/datum/action/minimap/proc/override_locator(atom/movable/to_track)
	var/atom/movable/tracking = locator_override ? locator_override : owner
	var/atom/movable/new_track = to_track ? to_track : owner
	if(locator_override)
		clear_locator_override()
	if(owner)
		UnregisterSignal(tracking, COMSIG_MOVABLE_Z_CHANGED)
	if(!minimap_displayed)
		locator_override = to_track
		if(to_track)
			RegisterSignal(to_track, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/datum/action/minimap, clear_locator_override))
			if(owner && owner.loc == to_track)
				RegisterSignal(to_track, COMSIG_ATOM_EXITED, TYPE_PROC_REF(/datum/action/minimap, on_exit_check))
		if(owner)
			RegisterSignal(new_track, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(on_owner_z_change))
			var/turf/old_turf = get_turf(tracking)
			if(!old_turf || !old_turf.z || old_turf.z != new_track.z)
				on_owner_z_change(new_track, old_turf?.z, new_track?.z)
		return
	locator.UnregisterSignal(tracking, COMSIG_MOVABLE_MOVED)
	locator_override = to_track
	if(to_track)
		RegisterSignal(to_track, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/datum/action/minimap, clear_locator_override))
		if(owner.loc == to_track)
			RegisterSignal(to_track, COMSIG_ATOM_EXITED, TYPE_PROC_REF(/datum/action/minimap, on_exit_check))
	RegisterSignal(new_track, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(on_owner_z_change))
	var/turf/old_turf = get_turf(tracking)
	if(old_turf.z != new_track.z)
		on_owner_z_change(new_track, old_turf.z, new_track.z)
	locator.RegisterSignal(new_track, COMSIG_MOVABLE_MOVED, TYPE_PROC_REF(/atom/movable/screen/minimap_locator, update))
	locator.link_locator(map, new_track)
	locator.update(new_track)

///checks if we should clear override if the owner exits this atom
/datum/action/minimap/proc/on_exit_check(datum/source, atom/movable/mover)
	SIGNAL_HANDLER
	if(mover && mover != owner)
		return
	clear_locator_override()

///CLears the locator override in case the override target is deleted
/datum/action/minimap/proc/clear_locator_override()
	SIGNAL_HANDLER
	if(!locator_override)
		return
	UnregisterSignal(locator_override, list(COMSIG_PARENT_QDELETING, COMSIG_ATOM_EXITED))
	if(owner)
		UnregisterSignal(locator_override, COMSIG_MOVABLE_Z_CHANGED)
		RegisterSignal(owner, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(on_owner_z_change))
		var/turf/owner_turf = get_turf(owner)
		if(owner_turf.z != locator_override.z)
			on_owner_z_change(owner, locator_override.z, owner_turf.z)
	if(minimap_displayed)
		locator.UnregisterSignal(locator_override, COMSIG_MOVABLE_MOVED)
		locator.RegisterSignal(owner, COMSIG_MOVABLE_MOVED, TYPE_PROC_REF(/atom/movable/screen/minimap_locator, update))
		locator.link_locator(map, owner)
		locator.update(owner)
	locator_override = null

/datum/action/minimap/give_to(mob/mob)
	. = ..()
	var/atom/movable/tracking = locator_override ? locator_override : mob
	RegisterSignal(tracking, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(on_owner_z_change))
	try_initialize_map()

	// Also give ceiling protection toggle action
	var/datum/action/minimap_ceiling/ceiling_action = give_action(mob, /datum/action/minimap_ceiling)
	if(ceiling_action)
		ceiling_action.hidden = TRUE
		mob.actions.Remove(ceiling_action)
		var/minimap_index = mob.actions.Find(src)
		if(minimap_index)
			mob.actions.Insert(minimap_index + 1, ceiling_action)
		else
			mob.actions.Add(ceiling_action)
		mob.update_action_buttons()

/// Attempts to initialize the minimap object for current z-level
/datum/action/minimap/proc/try_initialize_map()
	// Check if subsystem is still initializing
	if(!SSminimaps.initialized)
		return FALSE

	if(!owner?.client)
		return FALSE

	var/atom/movable/tracking = locator_override ? locator_override : owner
	if(default_overwatch_level)
		if(default_overwatch_level <= 0 || default_overwatch_level > length(SSmapping.z_list))
			return FALSE
		// Try to trigger z-level loading if it doesn't exist
		if(!SSminimaps.minimaps_by_z["[default_overwatch_level]"])
			var/datum/space_level/z_level = SSmapping.z_list[default_overwatch_level]
			if(z_level)
				SSminimaps.load_new_z(null, z_level)
		if(!SSminimaps.minimaps_by_z["[default_overwatch_level]"])
			return FALSE
		map = SSminimaps.fetch_minimap_object(default_overwatch_level, minimap_flags, live=live, popup=FALSE, drawing=drawing, for_client=owner.client)
		if(!map)
			return FALSE
		return TRUE
	// Try to trigger z-level loading if it doesn't exist
	if(!SSminimaps.minimaps_by_z["[tracking.z]"])
		if(tracking.z <= 0 || !SSmapping.z_list || tracking.z > length(SSmapping.z_list))
			return FALSE
		var/datum/space_level/z_level = SSmapping.z_list[tracking.z]
		if(z_level)
			SSminimaps.load_new_z(null, z_level)
	if(!SSminimaps.minimaps_by_z["[tracking.z]"])
		return FALSE
	// Only require hud_image for ground levels
	if(!SSminimaps.minimaps_by_z["[tracking.z]"].hud_image && (is_ground_level(tracking.z) || SSmapping.level_trait(tracking.z, ZTRAIT_AWAY)))
		return FALSE
	map = SSminimaps.fetch_minimap_object(tracking.z, minimap_flags, live=live, popup=FALSE, drawing=drawing, for_client=owner.client)
	if(!map)  // Handle null return from fetch_minimap_object
		return FALSE
	return TRUE

/datum/action/minimap/remove_from(mob/mob)
	toggle_minimap(FALSE)
	UnregisterSignal(locator_override || mob, COMSIG_MOVABLE_Z_CHANGED)

	return ..()

/**
 * Updates the map when the owner changes zlevel
 */
/datum/action/minimap/proc/on_owner_z_change(atom/movable/source, oldz, newz)
	SIGNAL_HANDLER
	var/atom/movable/tracking = locator_override ? locator_override : owner
	if(minimap_displayed)
		toggle_minimap(force_state=FALSE)
	map = null
	if(default_overwatch_level)
		if(!SSminimaps.minimaps_by_z["[default_overwatch_level]"] || !SSminimaps.minimaps_by_z["[default_overwatch_level]"].hud_image)
			if(minimap_displayed)
				owner.client?.screen -= locator
				locator.UnregisterSignal(tracking, COMSIG_MOVABLE_MOVED)
				minimap_displayed = FALSE
			return
		map = SSminimaps.fetch_minimap_object(default_overwatch_level, minimap_flags, live=live, popup=FALSE, drawing=drawing, for_client=owner.client)
		if(minimap_displayed)
			if(owner.client)
				owner.client.screen += map
				map.update_ceiling_overlay(owner.client)
			else
				minimap_displayed = FALSE
		return
	if(!SSminimaps.minimaps_by_z["[newz]"] || !SSminimaps.minimaps_by_z["[newz]"].hud_image)
		if(minimap_displayed)
			owner.client?.screen -= locator
			locator.UnregisterSignal(tracking, COMSIG_MOVABLE_MOVED)
			minimap_displayed = FALSE
		return
	map = SSminimaps.fetch_minimap_object(newz, minimap_flags, live=live, popup=FALSE, drawing=drawing, for_client=owner.client)
	if(minimap_displayed)
		if(owner.client)
			owner.client.screen += map
			map.update_ceiling_overlay(owner.client)
		else
			minimap_displayed = FALSE


/datum/action/minimap/xeno
	minimap_flags = MINIMAP_FLAG_XENO
	live = FALSE
	drawing = TRUE

/datum/action/minimap/xeno/New(target, new_minimap_flags, new_marker_flags, hive_number)
	var/minimap_flag = get_minimap_flag_for_faction(hive_number)
	if(minimap_flag != MINIMAP_FLAG_XENO)
		minimap_flags &= ~MINIMAP_FLAG_XENO
		minimap_flags |= minimap_flag

	. = ..()

/datum/action/minimap/xeno/see_humans
	minimap_flags = MINIMAP_FLAG_XENO|MINIMAP_FLAG_USCM|MINIMAP_FLAG_WY|MINIMAP_FLAG_WY|MINIMAP_FLAG_UPP

/datum/action/minimap/xeno/action_activate()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	// Automatically show drawing tools for ovi'd queens
	if(isqueen(xeno) && minimap_flags == MINIMAP_FLAG_XENO)
		var/mob/living/carbon/xenomorph/queen/queen = xeno
		if(queen.ovipositor)
			var/datum/component/tacmap/tacmap_component = queen.GetComponent(/datum/component/tacmap)
			if(tacmap_component)
				if(queen in tacmap_component.interactees)
					tacmap_component.on_unset_interaction(queen)
					tacmap_component.close_popout_tacmaps(queen)
				else
					tacmap_component.show_tacmap(queen)
				return
	// Hunted still get no tacmap
	if(xeno.hive?.tacmap_requires_queen_ovi && !xeno?.hive?.living_xeno_queen && xeno != xeno?.hive?.living_xeno_queen)
		to_chat(xeno, SPAN_WARNING("You cannot access that right now."))
		return

	// Determine if map should be live based on queen's ovipositor status
	var/should_be_live = FALSE
	if(xeno == xeno.hive?.living_xeno_queen)
		should_be_live = TRUE // Queens always get live
	else if(xeno.hive?.living_xeno_queen?.ovipositor)
		should_be_live = TRUE // Queen is on ovipositor, all xenos get live
	else if(!xeno.hive?.tacmap_requires_queen_ovi)
		should_be_live = TRUE // This Hive doesn't require queen ovi (forsaken for example)

	// If live status changed, reset the map so it gets recreated with correct mode
	if(live != should_be_live)
		if(minimap_displayed)
			toggle_minimap(FALSE)
		live = should_be_live
		map = null

	. = ..()

/datum/action/minimap/marine
	minimap_flags = MINIMAP_FLAG_USCM
	marker_flags = MINIMAP_FLAG_USCM

/datum/action/minimap/marine/live
	live = TRUE

/datum/action/minimap/marine/upp
	minimap_flags = MINIMAP_FLAG_UPP
	marker_flags = MINIMAP_FLAG_UPP

/datum/action/minimap/ai	//I'll keep this as seperate type despite being identical so it's easier if people want to make different aspects different.
	minimap_flags = MINIMAP_FLAG_USCM
	marker_flags = MINIMAP_FLAG_USCM

/datum/action/minimap/upp
	minimap_flags = MINIMAP_FLAG_UPP
	marker_flags = MINIMAP_FLAG_UPP

/datum/action/minimap/pmc
	minimap_flags = MINIMAP_FLAG_PMC
	marker_flags = MINIMAP_FLAG_PMC

/datum/action/minimap/observer
	minimap_flags = MINIMAP_FLAG_ALL
	marker_flags = NONE
	live = TRUE
	drawing = FALSE

/datum/action/minimap/observer/action_activate()
	. = ..()
	if(!.)
		return
	if(!minimap_displayed)
		map.stop_polling[owner] = TRUE
		return
	var/list/clicked_coords = map.get_coords_from_click(owner)
	if(!clicked_coords)
		toggle_minimap(FALSE)
		return
	var/turf/clicked_turf = locate(clicked_coords[1], clicked_coords[2], owner.z)
	if(!clicked_turf)
		toggle_minimap(FALSE)
		return
	// Taken directly from observer/DblClickOn
	owner.abstract_move(clicked_turf)
	// Close minimap
	toggle_minimap(FALSE)

/**
 * Action for toggling ceiling protection overlays on minimaps
 */
/datum/action/minimap_ceiling
	name = "Toggle Minimap Ceiling Overlay"
	action_icon_state = "minimap_ceiling"

/datum/action/minimap_ceiling/give_to(mob/mob)
	. = ..()
	hidden = TRUE
	update_button_icon()

/datum/action/minimap_ceiling/update_button_icon()
	. = ..()
	if(!button || !owner?.client?.prefs)
		return

	if(owner.client.prefs.show_minimap_ceiling_protection)
		button.icon_state = "template_on"
	else
		button.icon_state = "template"

/datum/action/minimap_ceiling/action_activate()
	. = ..()
	if(!owner?.client?.prefs)
		return FALSE

	// Check cooldown
	if(!COOLDOWN_FINISHED(owner.client, ceiling_protection_toggle_cooldown))
		to_chat(owner, SPAN_WARNING("You must wait [COOLDOWN_SECONDSLEFT(owner.client, ceiling_protection_toggle_cooldown)] seconds before toggling ceiling protection again."))
		return FALSE

	owner.client.prefs.show_minimap_ceiling_protection = !owner.client.prefs.show_minimap_ceiling_protection

	// Set cooldown
	COOLDOWN_START(owner.client, ceiling_protection_toggle_cooldown, 2 SECONDS)
	owner.client.prefs.save_preferences()
	to_chat(owner, SPAN_NOTICE("Ceiling protection overlay [owner.client.prefs.show_minimap_ceiling_protection ? "enabled" : "disabled"] on minimaps."))
	update_button_icon()

	// Refresh minimaps for this client
	for(var/atom/movable/screen/minimap/mini_map in owner.client.screen)
		if(mini_map.assigned_map) // Skip shared popup maps
			continue
		mini_map.update_ceiling_overlay(owner.client)

	return TRUE

/atom/movable/screen/exit_map
	name = "Close Minimap"
	desc = "Close the minimap."
	icon = 'icons/ui_icons/minimap_buttons.dmi'
	icon_state = "close"
	screen_loc = "RIGHT,TOP"
	plane = ABOVE_TACMAP_PLANE
	layer = INTRO_LAYER
	var/datum/component/tacmap/linked_map

/atom/movable/screen/exit_map/Initialize(mapload, linked_map)
	. = ..()
	src.linked_map = linked_map

/atom/movable/screen/exit_map/MouseEntered(location, control, params)
	. = ..()
	add_filter("mouseover", 1, outline_filter(1, COLOR_WHITE))
	if(desc)
		openToolTip(usr, src, params, title = name, content = desc, special="offset_left")

/atom/movable/screen/exit_map/MouseExited(location, control, params)
	. = ..()
	remove_filter("mouseover")
	if(desc)
		closeToolTip(usr)

/atom/movable/screen/exit_map/clicked(mob/user, list/mods)
	linked_map.on_unset_interaction(user)
	return TRUE

/atom/movable/screen/minimap_tool
	icon = 'icons/ui_icons/minimap_buttons.dmi'
	layer = TACMAP_LAYER
	plane = ABOVE_TACMAP_PLANE
	///x offset of the minimap icon for this zlevel. mostly used for shorthand
	var/x_offset
	///y offset of the minimap icon for this zlevel. mostly used for shorthand
	var/y_offset
	///zlevel that this minimap tool applies to and which it will be drawing on
	var/zlevel
	/// active mouse icon when the tool is selected
	var/active_mouse_icon
	///one minimap flag that this tool will be drawing on
	var/minimap_flag
	/// reference to the icon we are manipulating when drawing, fetched during initialize
	var/image/drawn_image
	/// what minimap screen we drawing to
	var/atom/movable/screen/minimap/linked_map
	/// datum owner of this minimap tool
	var/datum/component/tacmap/owner

/atom/movable/screen/minimap_tool/Initialize(mapload, zlevel, minimap_flag, linked_map, owner)
	. = ..()
	src.owner = owner
	src.minimap_flag = minimap_flag
	src.zlevel = zlevel
	src.linked_map = linked_map
	if(SSminimaps.initialized)
		set_zlevel(zlevel, minimap_flag)
		return
	LAZYADDASSOCLIST(SSminimaps.earlyadds, "[zlevel]", CALLBACK(src, PROC_REF(set_zlevel), zlevel, minimap_flag))

/atom/movable/screen/minimap_tool/Destroy()
	owner = null
	. = ..()

///Setter for the offsets of the x and y of drawing based on the input z, and the drawn_image
/atom/movable/screen/minimap_tool/proc/set_zlevel(zlevel, minimap_flag)
	x_offset = SSminimaps.minimaps_by_z["[zlevel]"] ? SSminimaps.minimaps_by_z["[zlevel]"].x_offset : 0
	y_offset = SSminimaps.minimaps_by_z["[zlevel]"] ? SSminimaps.minimaps_by_z["[zlevel]"].y_offset : 0
	drawn_image = SSminimaps.get_drawing_image(zlevel, minimap_flag)

/atom/movable/screen/minimap_tool/MouseEntered(location, control, params)
	. = ..()
	add_filter("mouseover", 1, outline_filter(1, COLOR_WHITE))
	if(desc)
		openToolTip(usr, src, params, title = name, content = desc, special="offset_left")

/atom/movable/screen/minimap_tool/MouseExited(location, control, params)
	. = ..()
	remove_filter("mouseover")
	if(desc)
		closeToolTip(usr)

/atom/movable/screen/minimap_tool/clicked(mob/user, list/mods)
	if(LAZYACCESS(mods, LEFT_CLICK))
		RegisterSignal(user, COMSIG_MOB_MOUSEDOWN, PROC_REF(on_mousedown))
		user.client.mouse_pointer_icon = active_mouse_icon
	return TRUE

/**
 * handles actions when the mouse is held down while the tool is active.
 * returns COMSIG_MOB_CLICK_CANCELED to continue handling, NONE to cancel
 */
/atom/movable/screen/minimap_tool/proc/on_mousedown(mob/source, atom/object, location, control, params)
	SIGNAL_HANDLER
	if(!(src in source.client.screen))
		UnregisterSignal(source, COMSIG_MOB_MOUSEDOWN)
		source.client.mouse_pointer_icon = null
		return NONE
	if(istype(object, /atom/movable/screen/minimap_tool) || istype(object, /atom/movable/screen/exit_map))
		linked_map.active_draw_tool = null
		UnregisterSignal(source, COMSIG_MOB_MOUSEDOWN)
		source.client.mouse_pointer_icon = null
		return NONE
	return COMSIG_MOB_CLICK_CANCELED

/atom/movable/screen/minimap_tool/draw_tool
	icon_state = "draw"
	desc = "Draw using a color. Drag to draw freely, middle click to place a dot. Middle click this button to unselect."
	// color that this draw tool will be drawing in
	color = COLOR_PINK
	///temporary existing list used to calculate a line between the start of a click and the end of a click
	var/list/starting_coords

	var/list/freedraw_queue = list()
	var/list/last_coords
	/// Width of the lines this is going to draw
	var/width = 0

	/// Whether we're drawing right now. Used to no-op clickdrag macros that we want to blackhole without deleting the verb from the client
	var/drawing

/atom/movable/screen/minimap_tool/draw_tool/clicked(mob/user, list/mods)
	. = ..()
	if(LAZYACCESS(mods, MIDDLE_CLICK))
		user.client.active_draw_tool = null
		linked_map.active_draw_tool = null
		winset(user, "drawingtools", "reset=true")
		return

	winset(user, "drawingtools", "parent=default;name=MouseDragMove;command=\".mouse-draw \[\[mapwindow.map.mouse-pos.x]] \[\[mapwindow.map.mouse-pos.y]] \[\[mapwindow.map.size.x]] \[\[mapwindow.map.size.y]] \[\[mapwindow.map.view-size.x]] \[\[mapwindow.map.view-size.y]]\"")
	add_verb(user.client, /client/proc/handle_draw)
	linked_map.active_draw_tool = src
	user.client.active_draw_tool = src

/client/var/atom/movable/screen/minimap_tool/draw_tool/active_draw_tool
/client/var/last_drawn
/// Cooldown for toggling ceiling protection overlay
/client/COOLDOWN_DECLARE(ceiling_protection_toggle_cooldown)
/client/proc/handle_draw(mouse_x as num, mouse_y as num, size_x as num, size_y as num, view_size_x as num, view_size_y as num)
	set instant = TRUE
	set category = null
	set hidden = TRUE
	set name = ".mouse-draw"

	if(!active_draw_tool)
		return

	if (!active_draw_tool.drawing)
		return

	mouse_y = size_y - mouse_y

	var/horizontal_letterbox = size_x - view_size_x
	var/vertical_letterbox = size_y - view_size_y

	if(horizontal_letterbox)
		mouse_x -= floor(horizontal_letterbox / 2)

	if(vertical_letterbox)
		mouse_y -= floor(vertical_letterbox / 2)

	mouse_x = floor(mouse_x * (SCREEN_PIXEL_SIZE / view_size_x))
	mouse_y = floor(mouse_y * (SCREEN_PIXEL_SIZE / view_size_y))

	if(mouse_x < 0 || mouse_y < 0)
		return

	active_draw_tool.freedraw_queue += vector(mouse_x, mouse_y)

	if(last_drawn == world.time)
		return
	last_drawn = world.time

	sleep(0) // to reschedule us to the end of the tick

	if(!mob)
		return
	active_draw_tool.process_queue(mob)


/atom/movable/screen/minimap_tool/draw_tool/proc/process_queue(mob/user)
	var/icon/slate = icon(drawn_image.icon)
	var/first = TRUE
	var/atom/movable/screen/plane_master/minimap/plane_master = user.hud_used.plane_masters["[TACMAP_PLANE]"]

	if(!plane_master)
		return

	if(!last_coords)
		var/vector/first_in_queue = freedraw_queue[1]
		last_coords = list(first_in_queue.x + plane_master.cur_x_shift, first_in_queue.y + plane_master.cur_x_shift)
	else
		first = FALSE

	for(var/vector/vector in freedraw_queue)
		if(first)
			first = FALSE
			continue

		var/px = vector.x + plane_master.cur_x_shift
		var/py = vector.y + plane_master.cur_y_shift

		if(width)
			draw_line_width(last_coords, list(px, py), slate, width)
		else
			draw_line(last_coords, list(px, py), slate)
		last_coords = list(px, py)

	addtimer(VARSET_CALLBACK(src, last_coords, null), 2, TIMER_UNIQUE|TIMER_OVERRIDE)
	addtimer(VARSET_CALLBACK(src, freedraw_queue, list()), 2, TIMER_UNIQUE|TIMER_OVERRIDE)
	drawn_image.icon = slate
	SSminimaps.refresh_cic_drawing_overlays(zlevel, minimap_flag)
	freedraw_queue = list()

/atom/movable/screen/minimap_tool/draw_tool/on_mousedown(mob/source, atom/object, location, control, params)
	. = ..()
	if(!.)
		return

	// N.B. popup tacmap is a different control; we never want to receive drawing inputs from it.
	if (control != "mapwindow.map")
		drawing = FALSE
		return COMSIG_MOB_CLICK_CANCELED
	else
		drawing = TRUE

	var/atom/movable/screen/plane_master/minimap/plane_master = source.hud_used.plane_masters["[TACMAP_PLANE]"]

	if(!plane_master)
		return

	var/list/modifiers = params2list(params)
	var/list/pixel_coords = params2screenpixel(modifiers["screen-loc"])
	pixel_coords = list(pixel_coords[1] + plane_master.cur_x_shift, pixel_coords[2] + plane_master.cur_y_shift)
	if(modifiers[BUTTON] == MIDDLE_CLICK)
		var/icon/mona_lisa = icon(drawn_image.icon)
		mona_lisa.DrawBox(color, pixel_coords[1], pixel_coords[2], ++pixel_coords[1], ++pixel_coords[2])
		drawn_image.icon = mona_lisa
		SSminimaps.refresh_cic_drawing_overlays(zlevel, minimap_flag)
		return COMSIG_MOB_CLICK_CANCELED
	starting_coords = pixel_coords
	return COMSIG_MOB_CLICK_CANCELED

/atom/movable/screen/minimap_tool/draw_tool/proc/draw_line_width(list/start_coords, list/end_coords, icon/slate, width, draw_color = color)
	var/half_width = floor(width / 2)
	var/x1 = start_coords[1]
	var/x2 = end_coords[1]
	var/y1 = start_coords[2]
	var/y2 = end_coords[2]

	if(abs(x2 - x1) > abs(y2 - y1))
		for(var/offset in -half_width to half_width)
			draw_line(list(x1, y1+offset), list(x2, y2+offset), slate, draw_color)
	else
		for(var/offset in -half_width to half_width)
			draw_line(list(x1+offset, y1), list(x2+offset, y2), slate, draw_color)

	return slate

/// proc for drawing a line from list(startx, starty) to list(endx, endy) on the screen. yes this is aa ripoff of [/proc/getline]
/atom/movable/screen/minimap_tool/draw_tool/proc/draw_line(list/start_coords, list/end_coords, icon/slate, draw_color = color)
	// converts these into the unscaled minimap version so we have to do less calculating
	var/start_x = FLOOR(start_coords[1]/2, 1)
	var/start_y = FLOOR(start_coords[2]/2, 1)
	var/end_x = FLOOR(end_coords[1]/2, 1)
	var/end_y = FLOOR(end_coords[2]/2, 1)

	//special case 1, straight line
	if(start_x == end_x)
		slate.DrawBox(draw_color, start_x*2, start_y*2, start_x*2 + 1, end_y*2 + 1)
		return slate
	if(start_y == end_y)
		slate.DrawBox(draw_color, start_x*2, start_y*2, end_x*2 + 1, start_y*2 + 1)
		return slate

	slate.DrawBox(draw_color, start_x*2, start_y*2, start_x*2 + 1, start_y*2 + 1)

	var/abs_dx = abs(end_x - start_x)
	var/abs_dy = abs(end_y - start_y)
	var/sign_dx = ( ((end_x - start_x) > 0) - ((end_x - start_x) < 0) )
	var/sign_dy = ( ((end_y - start_y) > 0) - ((end_y - start_y) < 0) )

	//special case 2, perfectly diagonal line
	if(abs_dx == abs_dy)
		for(var/j = 1 to abs_dx)
			start_x += sign_dx
			start_y += sign_dy
			slate.DrawBox(draw_color, start_x*2, start_y*2, start_x*2 + 1, start_y*2 + 1)
		return slate

	/*x_error and y_error represents how far we are from the ideal line.
	Initialized so that we will check these errors against 0, instead of 0.5 * abs_(dx/dy)*/
	//We multiply every check by the line slope denominator so that we only handles integers
	if(abs_dx > abs_dy)
		var/y_error = -(abs_dx >> 1)
		var/steps = abs_dx
		while(steps--)
			y_error += abs_dy
			if(y_error > 0)
				y_error -= abs_dx
				start_y += sign_dy
			start_x += sign_dx
			slate.DrawBox(draw_color, start_x*2, start_y*2, start_x*2 + 1, start_y*2 + 1)
	else
		var/x_error = -(abs_dy >> 1)
		var/steps = abs_dy
		while(steps--)
			x_error += abs_dx
			if(x_error > 0)
				x_error -= abs_dy
				start_x += sign_dx
			start_y += sign_dy
			slate.DrawBox(draw_color, start_x*2, start_y*2, start_x*2 + 1, start_y*2 + 1)
	return slate

/atom/movable/screen/minimap_tool/draw_tool/green
	screen_loc = "14,14"
	active_mouse_icon = 'icons/ui_icons/minimap_mouse/draw_green.dmi'
	color = MINIMAP_DRAWING_GREEN

/atom/movable/screen/minimap_tool/draw_tool/black
	screen_loc = "14,13"
	active_mouse_icon = 'icons/ui_icons/minimap_mouse/draw_black.dmi'
	color = MINIMAP_DRAWING_BLACK

/atom/movable/screen/minimap_tool/draw_tool/red
	screen_loc = "15,14"
	active_mouse_icon = 'icons/ui_icons/minimap_mouse/draw_red.dmi'
	color = MINIMAP_DRAWING_RED

/atom/movable/screen/minimap_tool/draw_tool/yellow
	screen_loc = "15,13"
	active_mouse_icon = 'icons/ui_icons/minimap_mouse/draw_yellow.dmi'
	color = MINIMAP_DRAWING_YELLOW

/atom/movable/screen/minimap_tool/draw_tool/purple
	screen_loc = "15,12"
	active_mouse_icon = 'icons/ui_icons/minimap_mouse/draw_purple.dmi'
	color = MINIMAP_DRAWING_PURPLE

/atom/movable/screen/minimap_tool/draw_tool/blue
	screen_loc = "15,11"
	active_mouse_icon = 'icons/ui_icons/minimap_mouse/draw_blue.dmi'
	color = MINIMAP_DRAWING_BLUE

/atom/movable/screen/minimap_tool/draw_tool/erase
	icon_state = "erase"
	desc = "Drag to erase freely, middle click to erase a dot. Middle click this button to unselect."
	active_mouse_icon = 'icons/ui_icons/minimap_mouse/draw_erase.dmi'
	screen_loc = "15,10"
	color = null
	width = 5

/atom/movable/screen/minimap_tool/label
	icon_state = "label"
	desc = "Click to place a label. Middle click a label to remove it. Middle click this button to remove all labels."
	active_mouse_icon = 'icons/ui_icons/minimap_mouse/label.dmi'
	screen_loc = "15,9"

/atom/movable/screen/minimap_tool/label/clicked(mob/user, list/mods)
	. = ..()
	if(LAZYACCESS(mods, MIDDLE_CLICK))
		clear_labels(user)

///Clears all labels and logs who did it
/atom/movable/screen/minimap_tool/label/proc/clear_labels(mob/user)
	// Clear all labels from the linked map's list
	linked_map.labelled_turfs.Cut()

	// Clear labels from CIC drawings system
	for(var/key in SSminimaps.cic_drawings)
		if(findtext(key, "[zlevel]-[minimap_flag]label-"))
			SSminimaps.cic_drawings -= key

	// Clear labels from transmitted drawings system
	for(var/key in SSminimaps.transmitted_drawings)
		if(findtext(key, "[zlevel]-[minimap_flag]label-"))
			SSminimaps.transmitted_drawings -= key

	SSminimaps.refresh_cic_drawing_overlays(zlevel, minimap_flag)

/atom/movable/screen/minimap_tool/label/on_mousedown(mob/source, atom/object, location, control, params)
	. = ..()
	if(!.)
		return

	// N.B. popup tacmap is a different control; we never want to receive drawing inputs from it.
	if (control != "mapwindow.map")
		return COMSIG_MOB_CLICK_CANCELED

	INVOKE_ASYNC(src, PROC_REF(async_mousedown), source, object, location, control, params)
	return COMSIG_MOB_CLICK_CANCELED

///async mousedown for the actual label placement handling
/atom/movable/screen/minimap_tool/label/proc/async_mousedown(mob/source, atom/object, location, control, params)
	// this is really [/atom/movable/screen/minimap/proc/get_coords_from_click] copypaste since we
	// want to also cancel the click if they click src and I can't be bothered to make it even more generic rn
	var/atom/movable/screen/plane_master/minimap/plane_master = source.hud_used.plane_masters["[TACMAP_PLANE]"]

	if(!plane_master)
		return

	var/list/modifiers = params2list(params)
	var/list/pixel_coords = params2screenpixel(modifiers["screen-loc"])
	var/x = (pixel_coords[1] - x_offset + plane_master.cur_x_shift) / MINIMAP_SCALE
	var/y = (pixel_coords[2] - y_offset + plane_master.cur_y_shift) / MINIMAP_SCALE
	var/c_x = clamp(CEILING(x, 1), 1, world.maxx)
	var/c_y = clamp(CEILING(y, 1), 1, world.maxy)
	var/turf/target = locate(c_x, c_y, zlevel)
	if(modifiers[BUTTON] == MIDDLE_CLICK)
		var/curr_dist
		var/turf/nearest
		for(var/turf/label as anything in linked_map.labelled_turfs)
			var/dist = get_dist_euclidian(label, target)
			if(dist > LABEL_REMOVE_RANGE)
				continue
			if(!curr_dist || curr_dist > dist)
				curr_dist = dist
				nearest = label
		if(nearest)
			// Remove from labelled_turfs list
			linked_map.labelled_turfs -= nearest

			// Remove from CIC drawings system
			var/drawing_key = "[zlevel]-[minimap_flag]label-[nearest.x]-[nearest.y]"
			if(SSminimaps.cic_drawings[drawing_key])
				SSminimaps.cic_drawings -= drawing_key

			// Also remove from transmitted drawings if it exists
			if(SSminimaps.transmitted_drawings[drawing_key])
				SSminimaps.transmitted_drawings -= drawing_key

			SSminimaps.refresh_cic_drawing_overlays(zlevel, minimap_flag)
		return
	var/label_text = MAPTEXT(tgui_input_text(source, title = "Label Name", max_length = 35))
	if(!label_text)
		return
	var/atom/movable/screen/minimap/mini = SSminimaps.fetch_minimap_object(zlevel, minimap_flag, live=TRUE, popup=FALSE, drawing=TRUE, for_client=source.client)
	if(!locate(mini) in source.client?.screen)
		return

	var/mutable_appearance/textbox = mutable_appearance(icon('icons/ui_icons/map_blips.dmi'), "label", ABOVE_FLOAT_LAYER, appearance_flags = KEEP_TOGETHER)
	textbox.maptext_x = 5
	textbox.maptext_y = 5
	textbox.maptext_width = 64
	textbox.maptext = label_text

	// Set proper positioning for the label on the minimap
	textbox.pixel_x = MINIMAP_PIXEL_FROM_WORLD(target.x) + SSminimaps.minimaps_by_z["[target.z]"].x_offset
	textbox.pixel_y = MINIMAP_PIXEL_FROM_WORLD(target.y) + SSminimaps.minimaps_by_z["[target.z]"].y_offset

	linked_map.labelled_turfs += target
	msg_admin_niche("[key_name(source)] has crated a label at ([target.x],[target.y]) with text: [label_text].")

	// Store label in CIC only drawings system
	var/drawing_key = "[zlevel]-[minimap_flag]label-[target.x]-[target.y]"
	SSminimaps.cic_drawings[drawing_key] = textbox

	SSminimaps.refresh_cic_drawing_overlays(zlevel, minimap_flag)

/atom/movable/screen/minimap_tool/clear
	icon_state = "clear"
	desc = "Remove all current labels and drawings."
	screen_loc = "15,8"

/atom/movable/screen/minimap_tool/clear/clicked(mob/user, list/mods)
	drawn_image.icon = icon('icons/ui_icons/minimap.dmi')
	SSminimaps.refresh_cic_drawing_overlays(zlevel, minimap_flag)
	var/atom/movable/screen/minimap_tool/label/labels = locate() in user.client?.screen
	labels?.clear_labels(user)

/atom/movable/screen/minimap_tool/update
	icon_state = "update"
	desc = "Send a tacmap update."
	screen_loc = "15,7"

/atom/movable/screen/minimap_tool/update/proc/cooldown_finished()
	icon_state = initial(icon_state)

/atom/movable/screen/minimap_tool/update/clicked(mob/user, list/mods)
	var/time_left = get_cooldown_for_minimap_flag(minimap_flag) - world.time

	if(time_left > 0)
		to_chat(user, SPAN_WARNING("Wait another [DisplayTimeText(time_left)] before sending another update."))
		if(icon_state != "update_cooldown")
			icon_state = "update_cooldown"
			addtimer(CALLBACK(src, PROC_REF(cooldown_finished)), time_left, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)
		return

	set_cooldown_for_minimap_flag(minimap_flag, CANVAS_COOLDOWN_TIME)
	addtimer(CALLBACK(src, PROC_REF(cooldown_finished)), CANVAS_COOLDOWN_TIME, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)
	icon_state = "update_cooldown"

	if(linked_map.minimap_flags & MINIMAP_FLAG_ALL_XENOS)
		announce_xeno(user)
	else
		announce_human(user)

	message_admins("[key_name(user)] has updated the <a href='byond://?tacmaps_panel=1'>tactical map</a>.")

/atom/movable/screen/minimap_tool/update/proc/announce_xeno(mob/user)
	playsound_client(user.client, get_sfx("queen"))

	// Trigger a refresh of all non-live xeno minimaps with new drawings
	SSminimaps.refresh_static_minimaps(minimap_flag)

	// Apply drawings to all live xeno minimaps now that update has been sent
	SSminimaps.apply_drawings_to_live_minimaps(minimap_flag)

	user.client.images += drawn_image
	var/icon/flat_drawing = icon(user.client.RenderIcon(drawn_image))
	user.client.images -= drawn_image
	var/icon/flat_map = icon(user.client.RenderIcon(linked_map))
	if(!flat_map || !flat_drawing)
		to_chat(user, SPAN_WARNING("A critical error has occurred!! Contact a coder."))
		return FALSE

	var/list/faction_clients = list()
	for(var/client/client as anything in GLOB.clients)
		if(!client || !client.mob)
			continue
		var/mob/client_mob = client.mob
		if(linked_map.minimap_flags & get_minimap_flag_for_faction(client_mob.faction))
			faction_clients += client
		else if(client_mob.faction == FACTION_NEUTRAL && isobserver(client_mob))
			faction_clients += client
		else if(isxeno(client_mob))
			var/mob/living/carbon/xenomorph/xeno = client_mob
			if(linked_map.minimap_flags & get_minimap_flag_for_faction(xeno.hivenumber))
				faction_clients += client

	var/flat_tacmap_key = icon2html(flat_map, faction_clients, keyonly = TRUE)
	var/flat_drawing_key = icon2html(flat_drawing, faction_clients, keyonly = TRUE)
	if(!flat_tacmap_key || !flat_drawing_key)
		to_chat(user, SPAN_WARNING("A critical error has occurred! Contact a coder."))
		return FALSE
	var/flat_tacmap_png = SSassets.transport.get_asset_url(flat_tacmap_key)
	var/flat_drawing_png = SSassets.transport.get_asset_url(flat_drawing_key)
	var/datum/flattened_tacmap/new_flat = new(flat_tacmap_png, flat_tacmap_key)
	var/datum/drawing_data/draw_data = new(flat_drawing_png, user, flat_drawing_key)

	GLOB.xeno_flat_tacmap_data += new_flat
	GLOB.xeno_drawing_tacmap_data += draw_data

	xeno_maptext("The Queen has updated our hive mind map", "We sense something unusual...", XENO_HIVE_NORMAL)
	var/mutable_appearance/appearance = mutable_appearance(icon('icons/mob/hud/actions_xeno.dmi'), "toggle_queen_zoom")
	notify_ghosts(header = "Tactical Map", message = "The Xenomorph tactical map has been updated.", ghost_sound = "sound/voice/alien_distantroar_3.ogg", notify_volume = 50, action = NOTIFY_USCM_TACMAP, enter_link = "uscm_tacmap=1", enter_text = "View", source = user, alert_overlay = appearance)
	return TRUE

/atom/movable/screen/minimap_tool/update/proc/announce_human(mob/user)
	playsound_client(user.client, "sound/effects/data-transmission.ogg")

	// Trigger a refresh of all non-live minimaps with new drawings
	SSminimaps.refresh_static_minimaps(MINIMAP_FLAG_USCM)

	// Apply drawings to all live minimaps now that update has been sent
	SSminimaps.apply_drawings_to_live_minimaps(MINIMAP_FLAG_USCM)

	user.client.images += drawn_image
	var/icon/flat_drawing = icon(user.client.RenderIcon(drawn_image))
	user.client.images -= drawn_image
	var/icon/flat_map = icon(user.client.RenderIcon(linked_map))
	if(!flat_map || !flat_drawing)
		to_chat(user, SPAN_WARNING("A critical error has occurred!! Contact a coder."))
		return FALSE

	var/list/faction_clients = list()
	for(var/client/client as anything in GLOB.clients)
		if(!client || !client.mob)
			continue
		var/mob/client_mob = client.mob
		if(linked_map.minimap_flags & get_minimap_flag_for_faction(client_mob.faction))
			faction_clients += client
		else if(client_mob.faction == FACTION_NEUTRAL && isobserver(client_mob))
			faction_clients += client
		else if(isxeno(client_mob))
			var/mob/living/carbon/xenomorph/xeno = client_mob
			if(linked_map.minimap_flags & get_minimap_flag_for_faction(xeno.hivenumber))
				faction_clients += client

	var/flat_tacmap_key = icon2html(flat_map, faction_clients, keyonly = TRUE)
	var/flat_drawing_key = icon2html(flat_drawing, faction_clients, keyonly = TRUE)
	if(!flat_tacmap_key || !flat_drawing_key)
		to_chat(user, SPAN_WARNING("A critical error has occurred! Contact a coder."))
		return FALSE
	var/flat_tacmap_png = SSassets.transport.get_asset_url(flat_tacmap_key)
	var/flat_drawing_png = SSassets.transport.get_asset_url(flat_drawing_key)
	var/datum/flattened_tacmap/new_flat = new(flat_tacmap_png, flat_tacmap_key)
	var/datum/drawing_data/draw_data = new(flat_drawing_png, user, flat_drawing_key)

	GLOB.uscm_flat_tacmap_data += new_flat
	GLOB.uscm_drawing_tacmap_data += draw_data

	for(var/datum/squad/current_squad in GLOB.RoleAuthority.squads)
		current_squad.send_maptext("Tactical map update in progress...", "Tactical Map:")

	var/atom/source = owner?.parent
	if(!source)
		source = user
	notify_ghosts(header = "Tactical Map", message = "The USCM tactical map has been updated.", ghost_sound = "sound/effects/data-transmission.ogg", notify_volume = 80, action = NOTIFY_USCM_TACMAP, enter_link = "uscm_tacmap=1", enter_text = "View", source = source)
	return TRUE

/datum/flattened_tacmap
	var/flat_tacmap
	var/asset_key
	var/time

/datum/flattened_tacmap/New(flat_tacmap, asset_key)
	src.flat_tacmap = flat_tacmap
	src.asset_key = asset_key
	src.time = time_stamp()

/datum/drawing_data
	var/draw_data
	var/asset_key
	var/ckey
	var/name
	var/time

/datum/drawing_data/New(draw_data, mob/user, asset_key)
	src.draw_data = draw_data
	src.asset_key = asset_key
	src.ckey = user?.persistent_ckey
	src.name = user?.real_name
	src.time = time_stamp()

/atom/movable/screen/minimap_tool/up
	icon_state = "up"
	desc = "Move up a level."
	screen_loc = "15,6"

/atom/movable/screen/minimap_tool/up/clicked(mob/user, list/modifiers)
	if(!SSmapping.same_z_map(zlevel, zlevel+1))
		return TRUE

	owner.move_tacmap_up()
	return TRUE

/atom/movable/screen/minimap_tool/down
	icon_state = "down"
	desc = "Move down a level."
	screen_loc = "15,5"

/atom/movable/screen/minimap_tool/down/clicked(mob/user, list/modifiers)
	if(!SSmapping.same_z_map(zlevel, zlevel-1))
		return

	owner.move_tacmap_down()

	return TRUE

/atom/movable/screen/minimap_tool/popout
	icon_state = "popout"
	desc = "Pop the minimap to a window."
	screen_loc = "15,4"

/atom/movable/screen/minimap_tool/popout/clicked(mob/user, list/modifiers)
	owner.popout(user)
	return TRUE

/atom/movable/screen/minimap_tool/popout/set_zlevel(zlevel, minimap_flag)
	x_offset = SSminimaps.minimaps_by_z["[zlevel]"] ? SSminimaps.minimaps_by_z["[zlevel]"].x_offset : 0
	y_offset = SSminimaps.minimaps_by_z["[zlevel]"] ? SSminimaps.minimaps_by_z["[zlevel]"].y_offset : 0

/datum/proc/send_tacmap_assets_latejoin(mob/user)
	if(!user.client)
		return

	var/is_observer = user.faction == FACTION_NEUTRAL && isobserver(user)
	if((is_observer || user.faction == FACTION_MARINE) && length(GLOB.uscm_flat_tacmap_data))
		// Send marine maps
		var/datum/flattened_tacmap/latest = GLOB.uscm_flat_tacmap_data[length(GLOB.uscm_flat_tacmap_data)]
		if(latest)
			SSassets.transport.send_assets(user.client, latest.asset_key)
		var/datum/drawing_data/latest_draw_data = GLOB.uscm_drawing_tacmap_data[length(GLOB.uscm_drawing_tacmap_data)]
		if(latest_draw_data)
			SSassets.transport.send_assets(user.client, latest_draw_data.asset_key)

	var/mob/living/carbon/xenomorph/xeno = user
	if((is_observer || istype(xeno) && xeno.hivenumber == XENO_HIVE_NORMAL) && length(GLOB.xeno_flat_tacmap_data))
		// Send xeno maps
		var/datum/flattened_tacmap/latest = GLOB.xeno_flat_tacmap_data[length(GLOB.xeno_flat_tacmap_data)]
		if(latest)
			SSassets.transport.send_assets(user.client, latest.asset_key)
		var/datum/drawing_data/latest_draw_data = GLOB.xeno_drawing_tacmap_data[length(GLOB.xeno_drawing_tacmap_data)]
		if(latest_draw_data)
			SSassets.transport.send_assets(user.client, latest_draw_data.asset_key)

/// Gets the MINIMAP_FLAG for the provided faction or hivenumber if one exists
/proc/get_minimap_flag_for_faction(faction)
	switch(faction)
		if(XENO_HIVE_NORMAL)
			return MINIMAP_FLAG_XENO
		if(FACTION_MARINE)
			return MINIMAP_FLAG_USCM
		if(FACTION_UPP)
			return MINIMAP_FLAG_UPP
		if(FACTION_WY)
			return MINIMAP_FLAG_USCM
		if(FACTION_CLF)
			return MINIMAP_FLAG_CLF
		if(FACTION_PMC)
			return MINIMAP_FLAG_PMC
		if(FACTION_YAUTJA)
			return MINIMAP_FLAG_YAUTJA
		if(XENO_HIVE_CORRUPTED)
			return MINIMAP_FLAG_XENO_CORRUPTED
		if(XENO_HIVE_ALPHA)
			return MINIMAP_FLAG_XENO_ALPHA
		if(XENO_HIVE_BRAVO)
			return MINIMAP_FLAG_XENO_BRAVO
		if(XENO_HIVE_CHARLIE)
			return MINIMAP_FLAG_XENO_CHARLIE
		if(XENO_HIVE_DELTA)
			return MINIMAP_FLAG_XENO_DELTA
		if(XENO_HIVE_FERAL)
			return MINIMAP_FLAG_XENO_FERAL
		if(XENO_HIVE_TAMED)
			return MINIMAP_FLAG_XENO_TAMED
		if(XENO_HIVE_MUTATED)
			return MINIMAP_FLAG_XENO_MUTATED
		if(XENO_HIVE_FORSAKEN)
			return MINIMAP_FLAG_XENO_FORSAKEN
		if(XENO_HIVE_YAUTJA)
			return MINIMAP_FLAG_YAUTJA
		if(XENO_HIVE_HUNTED)
			return MINIMAP_FLAG_XENO_HUNTED
		if(XENO_HIVE_RENEGADE)
			return MINIMAP_FLAG_XENO_RENEGADE
	return 0

/// Returns the highest world.time for all minimap_flags passed
/proc/get_cooldown_for_minimap_flag(minimap_flag)
	var/cooldown = 0
	for(var/flag in bitfield2list(minimap_flag))
		cooldown = max(cooldown, GLOB.faction_tacmap_cooldown[flag])
	return cooldown

/// Sets the cooldown for all minimap_flags passed
/proc/set_cooldown_for_minimap_flag(minimap_flag, duration)
	duration += world.time
	for(var/flag in bitfield2list(minimap_flag))
		GLOB.faction_tacmap_cooldown[flag] = duration

#undef CANVAS_COOLDOWN_TIME
#undef LABEL_REMOVE_RANGE
