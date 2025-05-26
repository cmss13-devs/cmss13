#define CANVAS_COOLDOWN_TIME 4 MINUTES
#define FLATTEN_MAP_COOLDOWN_TIME 3 MINUTES

/**
 *  # Minimaps subsystem
 *
 * Handles updating and handling of the by-zlevel minimaps
 *
 * Minimaps are a low priority subsystem that fires relatively often
 * the Initialize proc for this subsystem draws the maps as one of the last initializing subsystems
 *
 * Fire() for this subsystem doesn't actually update anything, and purely just reapplies the overlays that it already tracks
 * actual updating of marker locations is handled by [/datum/controller/subsystem/minimaps/proc/on_move]
 * and zlevel changes are handled in [/datum/controller/subsystem/minimaps/proc/on_z_change]
 * tracking of the actual atoms you want to be drawn on is done by means of datums holding info pertaining to them with [/datum/hud_displays]
 */
SUBSYSTEM_DEF(minimaps)
	name = "Minimaps"
	init_order = SS_INIT_MINIMAP
	priority = SS_PRIORITY_MINIMAPS
	wait = 5 SECONDS
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	///Minimap hud display datums sorted by zlevel
	var/list/datum/hud_displays/minimaps_by_z = list()
	///Assoc list of images we hold by their source
	var/list/image/images_by_source = list()
	///the update target datums, sorted by update flag type
	var/list/update_targets = list()
	///Nonassoc list of targets we want to be stripped of their overlays during the SS fire
	var/list/atom/update_targets_unsorted = list()
	///Assoc list of removal callbacks to invoke to remove images from the raw lists
	var/list/datum/callback/removal_cbs = list()
	///list of holders for data relating to tracked zlevel and tracked atom
	var/list/datum/minimap_updator/updators_by_datum = list()
	///list of callbacks we need to invoke late because Initialize happens early
	var/list/datum/callback/earlyadds = list()
	///assoc list of minimap objects that are hashed so we have to update as few as possible
	var/list/hashed_minimaps = list()
	/// associated list of tacmap datums with a hash
	var/list/hashed_tacmaps = list()
	/// weakrefs of xenos temporarily added to the marine minimap
	var/list/minimap_added = list()

/datum/controller/subsystem/minimaps/Initialize(start_timeofday)
	for(var/level in 1 to length(SSmapping.z_list))
		minimaps_by_z["[level]"] = new /datum/hud_displays
		if(!is_ground_level(level) && !is_mainship_level(level))
			continue

		var/icon/icon_gen = new('icons/ui_icons/minimap.dmi') //600x600 blank icon template for drawing on the map
		var/xmin = world.maxx
		var/ymin = world.maxy
		var/xmax = 1
		var/ymax = 1

		for(var/xval in 1 to world.maxx)
			for(var/yval in 1 to world.maxy) //Scan all the turfs and draw as needed
				var/turf/location = locate(xval, yval, level)
				if(location.z != level)
					continue

				if(location.density)
					if(!istype(location, /turf/closed/wall/almayer/outer)) // Ignore almayer border
						xmin = min(xmin, xval)
						ymin = min(ymin, yval)
						xmax = max(xmax, xval)
						ymax = max(ymax, yval)
					icon_gen.DrawBox(location.minimap_color, xval, yval)
					continue

				if(istype(location, /turf/open/space))
					continue

				var/atom/movable/alttarget = (locate(/obj/structure/machinery/door) in location) || (locate(/obj/structure/fence) in location)
				if(alttarget)
					xmin = min(xmin, xval)
					ymin = min(ymin, yval)
					xmax = max(xmax, xval)
					ymax = max(ymax, yval)
					icon_gen.DrawBox(alttarget.minimap_color, xval, yval)
					continue

				var/area/turfloc = location.loc
				if(turfloc.minimap_color)
					xmin = min(xmin, xval)
					ymin = min(ymin, yval)
					xmax = max(xmax, xval)
					ymax = max(ymax, yval)
					icon_gen.DrawBox(BlendRGB(location.minimap_color, turfloc.minimap_color, 0.5), xval, yval)
					continue

				xmin = min(xmin, xval)
				ymin = min(ymin, yval)
				xmax = max(xmax, xval)
				ymax = max(ymax, yval)
				icon_gen.DrawBox(location.minimap_color, xval, yval)

		xmin = xmin * MINIMAP_SCALE - 1
		ymin = ymin * MINIMAP_SCALE - 1
		xmax = min(xmax * MINIMAP_SCALE, MINIMAP_PIXEL_SIZE)
		ymax = min(ymax * MINIMAP_SCALE, MINIMAP_PIXEL_SIZE)

		icon_gen.Scale(icon_gen.Width() * MINIMAP_SCALE, icon_gen.Height() * MINIMAP_SCALE) //scale it up x2 to make it easer to see
		icon_gen.Crop(xmin, ymin, MINIMAP_PIXEL_SIZE + xmin - 1, MINIMAP_PIXEL_SIZE + ymin - 1) //then trim it down also cutting anything unused on the bottom left

		// Determine and assign the offsets
		minimaps_by_z["[level]"].x_offset = floor((MINIMAP_PIXEL_SIZE - xmax - 1) / MINIMAP_SCALE) - xmin
		minimaps_by_z["[level]"].y_offset = floor((MINIMAP_PIXEL_SIZE - ymax - 1) / MINIMAP_SCALE) - ymin
		minimaps_by_z["[level]"].x_max = xmax
		minimaps_by_z["[level]"].y_max = ymax

		// Center the map icon
		icon_gen.Shift(EAST, minimaps_by_z["[level]"].x_offset + xmin)
		icon_gen.Shift(NORTH, minimaps_by_z["[level]"].y_offset + ymin)

		minimaps_by_z["[level]"].hud_image = icon_gen //done making the image!

	RegisterSignal(SSdcs, COMSIG_GLOB_NEW_Z, PROC_REF(handle_new_z))

	initialized = TRUE

	for(var/i in 1 to length(earlyadds)) //lateload icons
		earlyadds[i].Invoke()
	earlyadds = null //then clear them

	return SS_INIT_SUCCESS

/datum/controller/subsystem/minimaps/proc/handle_new_z(dcs, datum/space_level/z_level)
	SIGNAL_HANDLER

	if(minimaps_by_z["[z_level.z_value]"])
		return

	minimaps_by_z["[z_level.z_value]"] = new /datum/hud_displays

/datum/controller/subsystem/minimaps/stat_entry(msg)
	msg = "Upd:[length(update_targets_unsorted)] Mark: [length(removal_cbs)]"
	return ..()

/datum/controller/subsystem/minimaps/Recover()
	minimaps_by_z = SSminimaps.minimaps_by_z
	images_by_source = SSminimaps.images_by_source
	update_targets = SSminimaps.update_targets
	update_targets_unsorted = SSminimaps.update_targets_unsorted
	removal_cbs = SSminimaps.removal_cbs
	updators_by_datum = SSminimaps.updators_by_datum

/datum/controller/subsystem/minimaps/fire(resumed)
	var/static/iteration = 0
	if(!iteration) //on first iteration clear all overlays
		for(var/iter=1 to length(update_targets_unsorted))
			update_targets_unsorted[iter].overlays.Cut() //clear all the old overlays, no we cant cache it because they wont update
	//checks last fired flag to make sure under high load that things are performed in stages
	var/depthcount = 0
	for(var/flag in update_targets)
		if(depthcount < iteration) //under high load update in chunks
			depthcount++
			continue
		for(var/datum/minimap_updator/updator as anything in update_targets[flag])
			if(length(updator.minimap.overlays))
				updator.minimap.overlays += minimaps_by_z["[updator.ztarget]"].images_raw[flag]
			else
				updator.minimap.overlays = minimaps_by_z["[updator.ztarget]"].images_raw[flag]
		depthcount++
		iteration++
		if(MC_TICK_CHECK)
			return
	iteration = 0

/**
 * Adds an atom to the processing updators that will have blips drawn on them
 * Arguments:
 * * target: the target we want to be updating the overlays on
 * * flags: flags for the types of blips we want to be updated
 * * ztarget: zlevel we want to be updated with
 */
/datum/controller/subsystem/minimaps/proc/add_to_updaters(atom/target, flags, ztarget)
	var/datum/minimap_updator/holder = new(target, ztarget)
	for(var/flag in bitfield2list(flags))
		LAZYADD(update_targets["[flag]"], holder)
	updators_by_datum[target] = holder
	update_targets_unsorted += target
	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(remove_updator))

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
	update_targets_unsorted -= target

/**
 * Holder datum for a zlevels data, concerning the overlays and the drawn level itself
 * The individual image trackers have a raw and a normal list
 * raw lists just store the images, while the normal ones are assoc list of [tracked_atom] = image
 * the raw lists are to speed up the Fire() of the subsystem so we dont have to filter through
 * WARNING!
 * There is a byond bug: http://www.byond.com/forum/post/2661309
 * That that forces us to use a separate list ref when accessing the lists of this datum
 * Yea it hurts me too
 */
/datum/hud_displays
	///Actual icon of the drawn zlevel with all of it's atoms
	var/icon/hud_image
	///Assoc list of updating images; list("[flag]" = list([source] = blip)
	var/list/images_assoc = list()
	///Raw list containing updating images by flag; list("[flag]" = list(blip))
	var/list/images_raw = list()
	///x offset of the actual icon to center it to screens
	var/x_offset = 0
	///y offset of the actual icons to keep it to screens
	var/y_offset = 0
	///max x for this zlevel
	var/x_max = 1
	///max y for this zlevel
	var/y_max = 1

/datum/hud_displays/New()
	..()
	for(var/flag in GLOB.all_minimap_flags)
		images_assoc["[flag]"] = list()
		images_raw["[flag]"] = list()

/**
 * Holder datum to ease updating of atoms to update
 */
/datum/minimap_updator
	/// Atom to update with the overlays
	var/atom/minimap
	///Target zlevel we want to be updating to
	var/ztarget = 0

/datum/minimap_updator/New(minimap, ztarget)
	..()
	src.minimap = minimap
	src.ztarget = ztarget

/**
 * Adds an atom we want to track with blips to the subsystem
 * Arguments:
 * * target: atom we want to track
 * * zlevel: zlevel we want this atom to be tracked for
 * * hud_flags: tracked HUDs we want this atom to be displayed on
 * * iconstate: iconstate for the blip we want to be used for this tracked atom
 * * icon: icon file we want to use for this blip, 'icons/UI_icons/map_blips.dmi' by default
 * * overlay_iconstates: list of iconstates to use as overlay. Used for xeno leader icons.
 */
/datum/controller/subsystem/minimaps/proc/add_marker(atom/target, zlevel, hud_flags = NONE, iconstate, icon = 'icons/ui_icons/map_blips.dmi', list/overlay_iconstates, image/given_image)
	if(!isatom(target) || !zlevel || !hud_flags || ((!iconstate || !icon) && !given_image))
		CRASH("Invalid marker added to subsystem")
	if(images_by_source[target])
		CRASH("Duplicate marker added to subsystem")
	if(!initialized)
		earlyadds += CALLBACK(src, PROC_REF(add_marker), target, zlevel, hud_flags, iconstate, icon, overlay_iconstates, given_image)
		return

	var/image/blip
	if(!given_image)
		blip = image(icon, iconstate, pixel_x = MINIMAP_PIXEL_FROM_WORLD(target.x) + minimaps_by_z["[zlevel]"].x_offset, pixel_y = MINIMAP_PIXEL_FROM_WORLD(target.y) + minimaps_by_z["[zlevel]"].y_offset)
	else
		given_image.pixel_x = MINIMAP_PIXEL_FROM_WORLD(target.x) + minimaps_by_z["[zlevel]"].x_offset
		given_image.pixel_y = MINIMAP_PIXEL_FROM_WORLD(target.y) + minimaps_by_z["[zlevel]"].y_offset
		blip = given_image

	for(var/i in overlay_iconstates)
		var/image/overlay = image(icon, i)
		overlay.appearance_flags = RESET_COLOR
		blip.overlays += overlay

	images_by_source[target] = blip
	for(var/flag in bitfield2list(hud_flags))
		minimaps_by_z["[zlevel]"].images_assoc["[flag]"][target] = blip
		minimaps_by_z["[zlevel]"].images_raw["[flag]"] += blip
	if(ismovableatom(target))
		RegisterSignal(target, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(on_z_change))
		blip.RegisterSignal(target, COMSIG_MOVABLE_MOVED, TYPE_PROC_REF(/image, minimap_on_move))
	removal_cbs[target] = CALLBACK(src, PROC_REF(removeimage), blip, target)
	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(remove_marker))

/**
 * removes an image from raw tracked lists, invoked by callback
 */
/datum/controller/subsystem/minimaps/proc/removeimage(image/blip, atom/target)
	var/turf/turf_gotten = get_turf(target)
	if(!turf_gotten)
		return
	var/z_level = turf_gotten.z
	for(var/flag in GLOB.all_minimap_flags)
		minimaps_by_z["[z_level]"].images_raw["[flag]"] -= blip
	blip.UnregisterSignal(target, COMSIG_MOVABLE_MOVED)
	removal_cbs -= target

/**
 * Called on zlevel change of a blip-atom so we can update the image lists as needed
 */
/datum/controller/subsystem/minimaps/proc/on_z_change(atom/movable/source, oldz, newz)
	SIGNAL_HANDLER
	for(var/flag in GLOB.all_minimap_flags)
		if(!minimaps_by_z["[oldz]"]?.images_assoc["[flag]"][source])
			continue
		var/ref_old = minimaps_by_z["[oldz]"].images_assoc["[flag]"][source]

		minimaps_by_z["[newz]"].images_assoc["[flag]"][source] = ref_old
		minimaps_by_z["[newz]"].images_raw["[flag]"] += ref_old

		minimaps_by_z["[oldz]"].images_assoc["[flag]"] -= source
		minimaps_by_z["[oldz]"].images_raw["[flag]"] -= ref_old

/**
 * Simple proc, updates overlay position on the map when a atom moves
 */
/image/proc/minimap_on_move(atom/movable/source, oldloc)
	SIGNAL_HANDLER

	var/source_z = source.z
	if(!source_z)
		return
	pixel_x = MINIMAP_PIXEL_FROM_WORLD(source.x) + SSminimaps.minimaps_by_z["[source_z]"].x_offset
	pixel_y = MINIMAP_PIXEL_FROM_WORLD(source.y) + SSminimaps.minimaps_by_z["[source_z]"].y_offset

/**
 * Removes an atom and it's blip from the subsystem.
 * Force has no effect on this proc, but is here because we are a COMSIG_PARENT_QDELETING handler.
 */
/datum/controller/subsystem/minimaps/proc/remove_marker(atom/source, force, minimap_flag)
	SIGNAL_HANDLER
	if(!removal_cbs[source]) //already removed
		return
	UnregisterSignal(source, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_Z_CHANGED))
	images_by_source -= source
	removal_cbs[source].Invoke()
	removal_cbs -= source
	var/turf/turf_gotten = get_turf(source)
	if(!turf_gotten)
		return
	var/z_level = turf_gotten.z
	if(minimap_flag)
		minimaps_by_z["[z_level]"].images_assoc["[minimap_flag]"] -= source
	else
		for(var/flag in GLOB.all_minimap_flags)
			minimaps_by_z["[z_level]"].images_assoc["[flag]"] -= source

/**
 * Fetches a /atom/movable/screen/minimap instance or creates one if none exists
 * Note this does not destroy them when the map is unused, might be a potential thing to do?
 * Arguments:
 * * zlevel: zlevel to fetch map for
 * * flags: map flags to fetch from
 */
/datum/controller/subsystem/minimaps/proc/fetch_minimap_object(zlevel, flags, shifting = FALSE)
	var/hash = "[zlevel]-[flags]-[shifting]"
	if(hashed_minimaps[hash])
		return hashed_minimaps[hash]
	var/atom/movable/screen/minimap/map = new(null, zlevel, flags, shifting)
	if (!map.icon) //Don't wanna save an unusable minimap for a z-level.
		CRASH("Empty and unusable minimap generated for '[zlevel]-[flags]-[shifting]'") //Can be caused by atoms calling this proc before minimap subsystem initializing.
	hashed_minimaps[hash] = map
	return map

/**
 * Fetches the datum containing an announced flattend map png reference.
 *
 * Arguments:
 * * faction: FACTION_MARINE or XENO_HIVE_NORMAL
 */
/proc/get_tacmap_data_png(faction)
	var/list/map_list

	if(faction == FACTION_MARINE)
		map_list = GLOB.uscm_flat_tacmap_data
	else if(faction == XENO_HIVE_NORMAL)
		map_list = GLOB.xeno_flat_tacmap_data
	else
		return null

	var/map_length = length(map_list)

	if(map_length == 0)
		return null

	return map_list[map_length]

/**
 * Fetches the datum containing the latest unannounced flattend map png reference.
 *
 * Arguments:
 * * faction: FACTION_MARINE or XENO_HIVE_NORMAL
 */
/proc/get_unannounced_tacmap_data_png(faction)
	if(faction == FACTION_MARINE)
		return GLOB.uscm_unannounced_map
	else if(faction == XENO_HIVE_NORMAL)
		return GLOB.xeno_unannounced_map

	return null

/**
 * Fetches the last set of svg coordinates for the tacmap drawing.
 *
 * Arguments:
 * * faction: which faction get the map for: FACTION_MARINE or XENO_HIVE_NORMAL
 */
/proc/get_tacmap_data_svg(faction)
	var/list/map_list

	if(faction == FACTION_MARINE)
		map_list = GLOB.uscm_svg_tacmap_data
	else if(faction == XENO_HIVE_NORMAL)
		map_list = GLOB.xeno_svg_tacmap_data
	else
		return null

	var/map_length = length(map_list)

	if(map_length == 0)
		return null

	return map_list[map_length]

/**
 * Re-sends relevant flattened tacmaps to a single client.
 *
 * Arguments:
 * * user: The mob that is either an observer, marine, or xeno
 */
/proc/resend_current_map_png(mob/user)
	if(!user.client)
		return

	var/is_observer = user.faction == FACTION_NEUTRAL && isobserver(user)
	if(is_observer || user.faction == FACTION_MARINE)
		// Send marine maps
		var/datum/flattened_tacmap/latest = get_tacmap_data_png(FACTION_MARINE)
		if(latest)
			SSassets.transport.send_assets(user.client, latest.asset_key)
		var/datum/flattened_tacmap/unannounced = get_unannounced_tacmap_data_png(FACTION_MARINE)
		if(unannounced && (!latest || latest.asset_key != unannounced.asset_key))
			SSassets.transport.send_assets(user.client, unannounced.asset_key)

	var/mob/living/carbon/xenomorph/xeno = user
	if(is_observer || istype(xeno) && xeno.hivenumber == XENO_HIVE_NORMAL)
		// Send xeno maps
		var/datum/flattened_tacmap/latest = get_tacmap_data_png(XENO_HIVE_NORMAL)
		if(latest)
			SSassets.transport.send_assets(user.client, latest.asset_key)
		var/datum/flattened_tacmap/unannounced = get_unannounced_tacmap_data_png(XENO_HIVE_NORMAL)
		if(unannounced && (!latest || latest.asset_key != unannounced.asset_key))
			SSassets.transport.send_assets(user.client, unannounced.asset_key)

/**
 * Flattens the current map and then distributes it for the specified faction as an unannounced map.
 *
 * Arguments:
 * * faction: Which faction to distribute the map to: FACTION_MARINE or XENO_HIVE_NORMAL
 * Return:
 * * Returns a boolean value, TRUE if the operation was successful, FALSE if it was not (on cooldown generally).
 */
/datum/tacmap/drawing/proc/distribute_current_map_png(faction)
	if(faction == FACTION_MARINE)
		if(!COOLDOWN_FINISHED(GLOB, uscm_flatten_map_icon_cooldown))
			return FALSE
		COOLDOWN_START(GLOB, uscm_flatten_map_icon_cooldown, FLATTEN_MAP_COOLDOWN_TIME)
	else if(faction == XENO_HIVE_NORMAL)
		if(!COOLDOWN_FINISHED(GLOB, xeno_flatten_map_icon_cooldown))
			return FALSE
		COOLDOWN_START(GLOB, xeno_flatten_map_icon_cooldown, FLATTEN_MAP_COOLDOWN_TIME)
	else
		return FALSE

	var/icon/flat_map = getFlatIcon(map_holder.map, appearance_flags = TRUE)
	if(!flat_map)
		to_chat(usr, SPAN_WARNING("A critical error has occurred! Contact a coder.")) // tf2heavy: "Oh, this is bad!"
		return FALSE

	// Send to only relevant clients
	var/list/faction_clients = list()
	for(var/client/client as anything in GLOB.clients)
		if(!client || !client.mob)
			continue
		var/mob/client_mob = client.mob
		if(client_mob.faction == faction)
			faction_clients += client
		else if(client_mob.faction == FACTION_NEUTRAL && isobserver(client_mob))
			faction_clients += client
		else if(isxeno(client_mob))
			var/mob/living/carbon/xenomorph/xeno = client_mob
			if(xeno.hivenumber == faction)
				faction_clients += client

	// This may be unnecessary to do this way if the asset url is always the same as the lookup key
	var/flat_tacmap_key = icon2html(flat_map, faction_clients, keyonly = TRUE)
	if(!flat_tacmap_key)
		to_chat(usr, SPAN_WARNING("A critical error has occurred! Contact a coder."))
		return FALSE
	var/flat_tacmap_png = SSassets.transport.get_asset_url(flat_tacmap_key)
	var/datum/flattened_tacmap/new_flat = new(flat_tacmap_png, flat_tacmap_key)

	if(faction == FACTION_MARINE)
		GLOB.uscm_unannounced_map = new_flat
	else //if(faction == XENO_HIVE_NORMAL)
		GLOB.xeno_unannounced_map = new_flat

	return TRUE

/**
 * Globally stores svg coords for a given faction.
 *
 * Arguments:
 * * faction: which faction to save the data for: FACTION_MARINE or XENO_HIVE_NORMAL
 * * svg_coords: an array of coordinates corresponding to an svg.
 * * ckey: the ckey of the user who submitted this
 */
/datum/tacmap/drawing/proc/store_current_svg_coords(faction, svg_coords, ckey)
	var/datum/svg_overlay/svg_store_overlay = new(svg_coords, ckey)

	if(faction == FACTION_MARINE)
		GLOB.uscm_svg_tacmap_data += svg_store_overlay
	else if(faction == XENO_HIVE_NORMAL)
		GLOB.xeno_svg_tacmap_data += svg_store_overlay
	else
		qdel(svg_store_overlay)
		debug_log("SVG coordinates for [faction] are not implemented!")

#define can_draw(faction, user) ((faction == FACTION_MARINE && skillcheck(user, SKILL_OVERWATCH, SKILL_OVERWATCH_TRAINED)) || (faction == XENO_HIVE_NORMAL && isqueen(user)))

/datum/controller/subsystem/minimaps/proc/fetch_tacmap_datum(zlevel, flags)
	var/hash = "[zlevel]-[flags]"
	if(hashed_tacmaps[hash])
		return hashed_tacmaps[hash]

	var/datum/tacmap_holder/tacmap = new(null, zlevel, flags)
	hashed_tacmaps[hash] = tacmap
	return tacmap

///Default HUD screen minimap object
/atom/movable/screen/minimap
	name = "Minimap"
	icon = null
	icon_state = ""
	layer = ABOVE_HUD_LAYER
	screen_loc = "1,1"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = TILE_BOUND
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

/atom/movable/screen/minimap/Initialize(mapload, target, flags, shifting = FALSE)
	. = ..()
	if(!SSminimaps.minimaps_by_z["[target]"])
		return
	icon = SSminimaps.minimaps_by_z["[target]"].hud_image
	SSminimaps.add_to_updaters(src, flags, target)

	x_max = SSminimaps.minimaps_by_z["[target]"].x_max
	y_max = SSminimaps.minimaps_by_z["[target]"].y_max

	if(shifting && (x_max > SCREEN_PIXEL_SIZE || y_max > SCREEN_PIXEL_SIZE))
		START_PROCESSING(SSobj, src)
		if(findtext(screen_loc, "1") != 1) // We're detecting the first position matching, not the 1 there
			CRASH("Shifting a minimap screen_loc of '[screen_loc]' is not currently implemented!") // Just need to do string manip in process to support it

/atom/movable/screen/minimap/process()
	if(x_max > SCREEN_PIXEL_SIZE)
		if(west_x_shift)
			cur_x_shift = min(cur_x_shift + shift_size, x_max - SCREEN_PIXEL_SIZE)
			if(cur_x_shift == x_max - SCREEN_PIXEL_SIZE)
				west_x_shift = !west_x_shift
		else
			cur_x_shift = max(cur_x_shift - shift_size, 0)
			if(cur_x_shift == 0)
				west_x_shift = !west_x_shift
	if(y_max > SCREEN_PIXEL_SIZE)
		if(south_y_shift)
			cur_y_shift = min(cur_y_shift + shift_size, y_max - SCREEN_PIXEL_SIZE)
			if(cur_y_shift == y_max - SCREEN_PIXEL_SIZE)
				south_y_shift = !south_y_shift
		else
			cur_y_shift = max(cur_y_shift - shift_size, 0)
			if(cur_y_shift == 0)
				south_y_shift = !south_y_shift
	screen_loc = "1:-[cur_x_shift],1:-[cur_y_shift]" // Pixel shift the map

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
	///This is mostly for the AI & other things which do not move groundside.
	var/default_overwatch_level = 0
	///Whether this minimap should shift or not
	var/shifting = FALSE

/datum/action/minimap/Destroy()
	map = null
	return ..()

/datum/action/minimap/action_activate()
	. = ..()
	if(!map)
		return
	if(minimap_displayed)
		owner.client.remove_from_screen(map)
	else
		owner.client.add_to_screen(map)
	minimap_displayed = !minimap_displayed

/datum/action/minimap/give_to(mob/target)
	. = ..()

	if(default_overwatch_level)
		map = SSminimaps.fetch_minimap_object(default_overwatch_level, minimap_flags, shifting)
	else
		RegisterSignal(target, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(on_owner_z_change))

	var/turf/turf_gotten = get_turf(target)
	if(!turf_gotten)
		return
	var/z_level = turf_gotten.z

	if(!SSminimaps.minimaps_by_z["[z_level]"] || !SSminimaps.minimaps_by_z["[z_level]"].hud_image)
		return
	map = SSminimaps.fetch_minimap_object(z_level, minimap_flags, shifting)

/datum/action/minimap/remove_from(mob/target)
	. = ..()
	if(minimap_displayed)
		owner?.client?.remove_from_screen(map)
		minimap_displayed = FALSE

	UnregisterSignal(target, COMSIG_MOVABLE_Z_CHANGED)

/**
 * Updates the map when the owner changes zlevel
 */
/datum/action/minimap/proc/on_owner_z_change(atom/movable/source, oldz, newz)
	SIGNAL_HANDLER
	if(minimap_displayed)
		owner.client.remove_from_screen(map)
		minimap_displayed = FALSE
	map = null
	if(!SSminimaps.minimaps_by_z["[newz]"] || !SSminimaps.minimaps_by_z["[newz]"].hud_image)
		return
	if(default_overwatch_level)
		map = SSminimaps.fetch_minimap_object(default_overwatch_level, minimap_flags, shifting)
		return
	map = SSminimaps.fetch_minimap_object(newz, minimap_flags, shifting)

/datum/action/minimap/xeno
	minimap_flags = MINIMAP_FLAG_XENO

/datum/action/minimap/marine
	minimap_flags = MINIMAP_FLAG_USCM
	marker_flags = MINIMAP_FLAG_USCM

/datum/action/minimap/upp
	minimap_flags =  MINIMAP_FLAG_UPP
	marker_flags = MINIMAP_FLAG_UPP

/datum/action/minimap/observer
	minimap_flags = MINIMAP_FLAG_ALL
	marker_flags = NONE
	hidden = TRUE
	shifting = TRUE

/datum/tacmap
	var/allowed_flags = MINIMAP_FLAG_USCM
	/// by default the ground map - this picks the first level matching the trait. if it exists
	var/targeted_ztrait = ZTRAIT_GROUND
	/// the current z level within the z stack
	var/target_z = 1
	var/atom/owner

	/// tacmap holder for holding the minimap
	var/datum/tacmap_holder/map_holder

/datum/tacmap/drawing
	/// A url that will point to the wiki map for the current map as a fall back image
	var/static/wiki_map_fallback

	/// color selection for the tactical map canvas, defaults to black.
	var/toolbar_color_selection = "black"
	var/toolbar_updated_selection = "black"

	/// boolean value to keep track if the canvas has been updated or not, the value is used in tgui state.
	var/updated_canvas = FALSE
	/// current flattend map
	var/datum/flattened_tacmap/new_current_map
	/// previous flattened map
	var/datum/flattened_tacmap/old_map
	/// current svg
	var/datum/svg_overlay/current_svg

	var/action_queue_change = 0

	/// The last time the map has been flattened - used as a key to trick react into updating the canvas
	var/last_update_time = 0
	/// A temporary lock out time before we can open the new canvas tab to allow the tacmap time to fire
	var/tacmap_ready_time = 0

/datum/tacmap/New(atom/source, minimap_type)
	allowed_flags = minimap_type
	owner = source

/datum/tacmap/drawing/status_tab_view/New()
	var/datum/tacmap/drawing/status_tab_view/uscm_tacmap
	allowed_flags = MINIMAP_FLAG_USCM
	owner = uscm_tacmap

/datum/tacmap/drawing/status_tab_view/xeno/New()
	var/datum/tacmap/drawing/status_tab_view/xeno/xeno_tacmap
	allowed_flags = MINIMAP_FLAG_XENO
	owner = xeno_tacmap

/datum/tacmap/Destroy()
	map_holder = null
	owner = null
	return ..()

/datum/tacmap/drawing/Destroy()
	new_current_map = null
	old_map = null
	current_svg = null
	return ..()

/datum/tacmap/tgui_interact(mob/user, datum/tgui/ui)
	if(!map_holder)
		var/level = SSmapping.levels_by_trait(targeted_ztrait)
		if(!level[target_z])
			return
		map_holder = SSminimaps.fetch_tacmap_datum(level[target_z], allowed_flags)

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		user.client.register_map_obj(map_holder.map)
		ui = new(user, src, "TacticalMap")
		ui.open()
		RegisterSignal(user.mind, COMSIG_MIND_TRANSFERRED, PROC_REF(on_mind_transferred))

/datum/tacmap/drawing/tgui_interact(mob/user, datum/tgui/ui)
	var/mob/living/carbon/xenomorph/xeno = user
	var/is_xeno = istype(xeno)
	var/faction = is_xeno ? xeno.hivenumber : user.faction
	if(faction == FACTION_NEUTRAL && isobserver(user))
		faction = allowed_flags == MINIMAP_FLAG_XENO ? XENO_HIVE_NORMAL : FACTION_MARINE

	if(is_xeno && xeno.hive.see_humans_on_tacmap && targeted_ztrait != ZTRAIT_MARINE_MAIN_SHIP)
		allowed_flags |= MINIMAP_FLAG_USCM|MINIMAP_FLAG_WY|MINIMAP_FLAG_UPP|MINIMAP_FLAG_CLF
		targeted_ztrait = ZTRAIT_MARINE_MAIN_SHIP
		map_holder = null

	new_current_map = get_unannounced_tacmap_data_png(faction)
	old_map = get_tacmap_data_png(faction)
	current_svg = get_tacmap_data_svg(faction)

	var/use_live_map = faction == FACTION_MARINE && skillcheck(user, SKILL_OVERWATCH, SKILL_OVERWATCH_TRAINED) || is_xeno

	if(use_live_map && !map_holder)
		var/level = SSmapping.levels_by_trait(targeted_ztrait)
		if(!level[target_z])
			return
		map_holder = SSminimaps.fetch_tacmap_datum(level[target_z], allowed_flags)

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		if(!wiki_map_fallback)
			var/wiki_url = CONFIG_GET(string/wikiurl)
			var/obj/item/map/current_map/new_map = new
			if(wiki_url && new_map.html_link)
				wiki_map_fallback ="[wiki_url]/[new_map.html_link]"
			else
				debug_log("Failed to determine fallback wiki map! Attempted '[wiki_url]/[new_map.html_link]'")
			qdel(new_map)

		// Ensure we actually have the map image sent
		resend_current_map_png(user)

		if(use_live_map)
			tacmap_ready_time = SSminimaps.next_fire + 2 SECONDS
			addtimer(CALLBACK(src, PROC_REF(on_tacmap_fire), faction), SSminimaps.next_fire - world.time + 1 SECONDS)
			user.client.register_map_obj(map_holder.map)
			RegisterSignal(user.mind, COMSIG_MIND_TRANSFERRED, PROC_REF(on_mind_transferred))

		ui = new(user, src, "TacticalMap")
		ui.open()

/datum/tacmap/ui_data(mob/user)
	. = ..()

	.["mapRef"] = map_holder?.map_ref

/datum/tacmap/drawing/ui_data(mob/user)
	var/list/data = list()

	data["newCanvasFlatImage"] = new_current_map?.flat_tacmap
	data["oldCanvasFlatImage"] = old_map?.flat_tacmap
	data["svgData"] = current_svg?.svg_data

	data["actionQueueChange"] = action_queue_change

	data["toolbarColorSelection"] = toolbar_color_selection
	data["toolbarUpdatedSelection"] = toolbar_updated_selection

	if(isxeno(user))
		data["canvasCooldown"] = max(GLOB.xeno_canvas_cooldown - world.time, 0)
	else
		data["canvasCooldown"] = max(GLOB.uscm_canvas_cooldown - world.time, 0)

	data["updatedCanvas"] = updated_canvas

	data["lastUpdateTime"] = last_update_time
	data["tacmapReady"] = world.time > tacmap_ready_time
	data["mapRef"] = map_holder?.map_ref

	return data

/datum/tacmap/ui_static_data(mob/user)
	var/list/data = list()

	data["canDraw"] = FALSE
	data["canViewTacmap"] = TRUE
	data["canChangeZ"] = FALSE
	data["canViewCanvas"] = FALSE
	data["isxeno"] = FALSE

	return data

/datum/tacmap/drawing/ui_static_data(mob/user)
	var/list/data = list()

	data["canvasCooldownDuration"] = CANVAS_COOLDOWN_TIME
	data["canDraw"] = FALSE
	data["mapFallback"] = wiki_map_fallback
	data["canChangeZ"] = TRUE

	var/mob/living/carbon/xenomorph/xeno = user
	var/is_xeno = istype(xeno)
	var/faction = is_xeno ? xeno.hivenumber : user.faction

	data["isxeno"] = is_xeno
	data["canViewTacmap"] = is_xeno
	data["canViewCanvas"] = faction == FACTION_MARINE || faction == XENO_HIVE_NORMAL

	if(can_draw(faction, user))
		data["canDraw"] = TRUE
		data["canViewTacmap"] = TRUE

	return data

/datum/tacmap/drawing/status_tab_view/ui_static_data(mob/user)
	var/list/data = list()

	data["canvasCooldownDuration"] = CANVAS_COOLDOWN_TIME
	data["mapFallback"] = wiki_map_fallback
	data["canDraw"] = FALSE
	data["canViewTacmap"] = FALSE
	data["canViewCanvas"] = TRUE
	data["isxeno"] = FALSE

	return data

/datum/tacmap/drawing/status_tab_view/xeno/ui_static_data(mob/user)
	var/list/data = list()

	data["canvasCooldownDuration"] = CANVAS_COOLDOWN_TIME
	data["mapFallback"] = wiki_map_fallback
	data["canDraw"] = FALSE
	data["canViewTacmap"] = FALSE
	data["canViewCanvas"] = TRUE
	data["isxeno"] = TRUE

	return data

/datum/tacmap/ui_close(mob/user)
	UnregisterSignal(user.mind, COMSIG_MIND_TRANSFERRED)

/datum/tacmap/drawing/ui_close(mob/user)
	. = ..()
	action_queue_change = 0
	updated_canvas = FALSE
	toolbar_color_selection = "black"
	toolbar_updated_selection = "black"

/datum/tacmap/drawing/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	var/mob/living/carbon/xenomorph/xeno = user
	var/faction = istype(xeno) ? xeno.hivenumber : user.faction
	var/is_observer = isobserver(user)
	if(faction == FACTION_NEUTRAL && is_observer)
		faction = allowed_flags == MINIMAP_FLAG_XENO ? XENO_HIVE_NORMAL : FACTION_MARINE
	var/drawing_allowed = !is_observer && can_draw(faction, user)

	switch (action)
		if ("menuSelect")
			if(params["selection"] != "Canvas")
				if(updated_canvas)
					updated_canvas = FALSE
					toolbar_updated_selection = toolbar_color_selection  // doing this if it == canvas can cause a latency issue with the stroke.
			else
				if(!drawing_allowed)
					msg_admin_niche("[key_name(user)] made an unauthorized attempt to 'menuSelect' the 'new canvas' panel of the [faction] tacmap!")
					return FALSE
				distribute_current_map_png(faction)
				last_update_time = world.time
				// An attempt to get the image to load on first try in the interface, but doesn't seem always reliable

			new_current_map = get_unannounced_tacmap_data_png(faction)
			old_map = get_tacmap_data_png(faction)
			current_svg = get_tacmap_data_svg(faction)

		if("updateCanvas")
			toolbar_updated_selection = "export"
			updated_canvas = TRUE
			action_queue_change += 1

		if("clearCanvas")
			toolbar_updated_selection = "clear"
			updated_canvas = FALSE
			action_queue_change += 1

		if("undoChange")
			toolbar_updated_selection = "undo"
			updated_canvas = FALSE
			action_queue_change += 1

		if("selectColor")
			var/newColor = params["color"]
			if(newColor)
				toolbar_color_selection = newColor
				toolbar_updated_selection = newColor
			action_queue_change += 1

		if("onDraw")
			updated_canvas = FALSE

		if("changeZ")
			var/amount = params["amount"]
			var/level = SSmapping.levels_by_trait(targeted_ztrait)
			if(target_z+amount < 1 || target_z+amount > length(level) || !SSmapping.same_z_map(level[target_z], level[target_z+amount]))
				return

			target_z += amount

			if(!level[target_z])
				return

			if(user.client)
				user.client.clear_map(map_holder.map.name)
			map_holder = SSminimaps.fetch_tacmap_datum(level[target_z], allowed_flags)
			resend_current_map_png(user)
			if(user.client)
				user.client.register_map_obj(map_holder.map)

			distribute_current_map_png(faction)
			last_update_time = world.time

			new_current_map = get_unannounced_tacmap_data_png(faction)
			old_map = get_tacmap_data_png(faction)
			current_svg = get_tacmap_data_svg(faction)


		if("selectAnnouncement")
			if(!drawing_allowed)
				msg_admin_niche("[key_name(user)] made an unauthorized attempt to 'selectAnnouncement' the [faction] tacmap!")
				return FALSE

			if(!istype(params["image"], /list)) // potentially very serious?
				return FALSE

			var/cooldown_satisfied = FALSE
			if(faction == FACTION_MARINE)
				cooldown_satisfied = COOLDOWN_FINISHED(GLOB, uscm_canvas_cooldown)
			else if(faction == XENO_HIVE_NORMAL)
				cooldown_satisfied = COOLDOWN_FINISHED(GLOB, xeno_canvas_cooldown)
			if(!cooldown_satisfied)
				msg_admin_niche("[key_name(user)] attempted to 'selectAnnouncement' the [faction] tacmap while it is still on cooldown!")
				return FALSE

			if(faction == FACTION_MARINE)
				GLOB.uscm_flat_tacmap_data += new_current_map
				COOLDOWN_START(GLOB, uscm_canvas_cooldown, CANVAS_COOLDOWN_TIME)
				for(var/datum/squad/current_squad in GLOB.RoleAuthority.squads)
					current_squad.send_maptext("Tactical map update in progress...", "Tactical Map:")
				var/mob/living/carbon/human/human_leader = user
				human_leader.visible_message(SPAN_BOLDNOTICE("Tactical map update in progress..."))
				playsound_client(human_leader.client, "sound/effects/data-transmission.ogg")
				notify_ghosts(header = "Tactical Map", message = "The USCM tactical map has been updated.", ghost_sound = "sound/effects/data-transmission.ogg", notify_volume = 80, action = NOTIFY_USCM_TACMAP, enter_link = "uscm_tacmap=1", enter_text = "View", source = owner)
			else if(faction == XENO_HIVE_NORMAL)
				GLOB.xeno_flat_tacmap_data += new_current_map
				COOLDOWN_START(GLOB, xeno_canvas_cooldown, CANVAS_COOLDOWN_TIME)
				xeno_maptext("The Queen has updated our hive mind map", "We sense something unusual...", faction)
				var/mutable_appearance/appearance = mutable_appearance(icon('icons/mob/hud/actions_xeno.dmi'), "toggle_queen_zoom")
				notify_ghosts(header = "Tactical Map", message = "The Xenomorph tactical map has been updated.", ghost_sound = "sound/voice/alien_distantroar_3.ogg", notify_volume = 50, action = NOTIFY_XENO_TACMAP, enter_link = "xeno_tacmap=1", enter_text = "View", source = user, alert_overlay = appearance)

			store_current_svg_coords(faction, params["image"], user)
			current_svg = get_tacmap_data_svg(faction)
			old_map = get_tacmap_data_png(faction)

			toolbar_updated_selection = toolbar_color_selection
			message_admins("[key_name(user)] has updated the <a href='byond://?tacmaps_panel=1'>tactical map</a> for [faction].")
			updated_canvas = FALSE

	return TRUE

/datum/tacmap/ui_status(mob/user)
	if(!(isatom(owner)))
		return UI_INTERACTIVE

	var/dist = get_dist(owner, user)
	if(dist <= 1)
		return UI_INTERACTIVE
	else if(dist <= 2)
		return UI_UPDATE
	else
		return UI_CLOSE

/datum/tacmap/drawing/xeno/ui_status(mob/user)
	if(!isxeno(user))
		return UI_CLOSE

	var/mob/living/carbon/xenomorph/xeno = user
	if(!xeno.hive?.living_xeno_queen?.ovipositor)
		return UI_CLOSE

	return UI_INTERACTIVE

// This gets removed when the player changes bodies (i.e. xeno evolution), so re-register it when that happens.
/datum/tacmap/proc/on_mind_transferred(datum/mind/source, mob/previous_body)
	SIGNAL_HANDLER
	source.current.client.register_map_obj(map_holder.map)

/datum/tacmap_holder
	var/map_ref
	var/atom/movable/screen/minimap/map

/datum/tacmap_holder/New(loc, zlevel, flags)
	map_ref = "tacmap_[REF(src)]_map"
	map = SSminimaps.fetch_minimap_object(zlevel, flags)
	map.screen_loc = "[map_ref]:1,1"
	map.assigned_map = map_ref
	map.appearance_flags = NONE // If you really want TILE_BOUND for the tacmaps, you need to CENTER it but it won't be scaled right

/datum/tacmap_holder/Destroy()
	map = null
	return ..()

/datum/flattened_tacmap
	var/flat_tacmap
	var/asset_key
	var/time

/datum/flattened_tacmap/New(flat_tacmap, asset_key)
	src.flat_tacmap = flat_tacmap
	src.asset_key = asset_key
	src.time = time_stamp()

/datum/svg_overlay
	var/svg_data
	var/ckey
	var/name
	var/time

/datum/svg_overlay/New(svg_data, mob/user)
	src.svg_data = svg_data
	src.ckey = user?.persistent_ckey
	src.name = user?.real_name
	src.time = time_stamp()

/// Callback when timer indicates the tacmap is flattenable now
/datum/tacmap/drawing/proc/on_tacmap_fire(faction)
	distribute_current_map_png(faction)
	last_update_time = world.time

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
			return MINIMAP_FLAG_WY
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
		if(XENO_HIVE_RENEGADE)
			return MINIMAP_FLAG_XENO_RENEGADE
	return 0

#undef CANVAS_COOLDOWN_TIME
#undef FLATTEN_MAP_COOLDOWN_TIME
#undef can_draw
