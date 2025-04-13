#define CANVAS_COOLDOWN_TIME 3 MINUTES
///A player needs to be unbanned from ALL these roles in order to be able to use the minimap drawing tool
GLOBAL_LIST_INIT(roles_allowed_minimap_draw, list(JOB_SQUAD_LEADER, JOB_SQUAD_TEAM_LEADER, JOB_SO, JOB_XO, JOB_CO))
GLOBAL_PROTECT(roles_allowed_minimap_draw)
/// range that we can remove labels when we click near them with the removal tool
#define LABEL_REMOVE_RANGE 20

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
	///list of callbacks we need to invoke late because Initialize happens early, or a Z-level was loaded after init
	var/list/list/datum/callback/earlyadds = list()
	///assoc list of minimap objects that are hashed so we have to update as few as possible
	var/list/hashed_minimaps = list()

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
		updator.minimap.overlays = updator.raw_blips
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
	var/icon/icon_gen = new('icons/ui_icons/minimap.dmi') //600x600 blank icon template for drawing on the map
	var/xmin = world.maxx
	var/ymin = world.maxy
	var/xmax = 1
	var/ymax = 1

	for(var/xval = 1 to world.maxx)
		for(var/yval = 1 to world.maxy) //Scan all the turfs and draw as needed
			var/turf/location = locate(xval,yval,level)
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
	minimaps_by_z["[level]"].x_offset = floor((MINIMAP_PIXEL_SIZE - xmax - 1) / 2) - xmin
	minimaps_by_z["[level]"].y_offset = floor((MINIMAP_PIXEL_SIZE - ymax - 1) / 2) - ymin
	minimaps_by_z["[level]"].x_max = xmax
	minimaps_by_z["[level]"].y_max = ymax

	// Center the map icon
	icon_gen.Shift(EAST, minimaps_by_z["[level]"].x_offset + xmin)
	icon_gen.Shift(NORTH, minimaps_by_z["[level]"].y_offset + ymin)
	minimaps_by_z["[level]"].hud_image = icon_gen //done making the image!

	//lateload icons
	if(!LAZYACCESS(earlyadds, "[level]"))
		return

	for(var/datum/callback/callback as anything in LAZYACCESS(earlyadds, "[level]"))
		callback.Invoke()
	LAZYREMOVE(earlyadds, "[level]")

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
		holder.raw_blips += minimaps_by_z["[ztarget]"].images_raw["[flag]"]
	updators_by_datum[target] = holder
	update_targets_unsorted += holder
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
	update_targets_unsorted -= holder

/**
 * Holder datum for a zlevels data, concerning the overlays and the drawn level itself
 * The individual image trackers have a raw and a normal list
 * raw lists just store the images, while the normal ones are assoc list of [tracked_atom] = image
 * the raw lists are to speed up the Fire() of the subsystem so we dont have to filter through
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
	/// list of overlays we update
	var/raw_blips

/datum/minimap_updator/New(minimap, ztarget)
	..()
	src.minimap = minimap
	src.ztarget = ztarget
	raw_blips = list()

/**
 * Adds an atom we want to track with blips to the subsystem
 * Arguments:
 * * target: atom we want to track
 * * hud_flags: tracked HUDs we want this atom to be displayed on
 * * marker: image or mutable_appearance we want to be using on the map
 */
/datum/controller/subsystem/minimaps/proc/add_marker(atom/target, hud_flags = NONE, image/blip, image_x, image_y)
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
	for(var/flag in GLOB.all_minimap_flags)
		if(!minimaps_by_z["[oldz]"]?.images_assoc["[flag]"][source])
			continue
		if(!blip)
			blip = minimaps_by_z["[oldz]"].images_assoc["[flag]"][source]
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

	return FALSE

/**
 * Fetches a /atom/movable/screen/minimap instance or creates on if none exists
 * Note this does not destroy them when the map is unused, might be a potential thing to do?
 * Arguments:
 * * zlevel: zlevel to fetch map for
 * * flags: map flags to fetch from
 */
/datum/controller/subsystem/minimaps/proc/fetch_minimap_object(zlevel, flags, shifting = FALSE, live=TRUE)
	var/hash = "[zlevel]-[flags]-[shifting]-[live]"
	if(hashed_minimaps[hash])
		return hashed_minimaps[hash]
	var/atom/movable/screen/minimap/map = new(null, null, zlevel, flags, shifting, live)
	if (!map.icon) //Don't wanna save an unusable minimap for a z-level.
		CRASH("Empty and unusable minimap generated for '[zlevel]-[flags]-[shifting]'") //Can be caused by atoms calling this proc before minimap subsystem initializing.
	hashed_minimaps[hash] = map
	return map

///fetches the drawing icon for a minimap flag and returns it, creating it if needed. assumes minimap_flag is ONE flag
/datum/controller/subsystem/minimaps/proc/get_drawing_image(zlevel, minimap_flag)
	var/hash = "[zlevel]-[minimap_flag]"
	if(drawn_images[hash])
		return drawn_images[hash]
	var/image/blip = new // could use MA but yolo
	blip.icon = icon('icons/ui_icons/minimap.dmi')
	if(minimaps_by_z["[zlevel]"])
		minimaps_by_z["[zlevel]"].images_raw["[minimap_flag]"] += blip
	for(var/datum/minimap_updator/updator as anything in update_targets["[minimap_flag]"])
		if(zlevel == updator.ztarget)
			updator.raw_blips += blip
	drawn_images[hash] = blip
	return blip

///Default HUD screen minimap object
/atom/movable/screen/minimap
	name = "Minimap"
	icon = null
	icon_state = ""
	layer = TACMAP_LAYER
	plane = TACMAP_PLANE
	screen_loc = "1,1"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = TILE_BOUND
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
	var/stop_shifting = FALSE
	/// Is the minimap live
	var/live
	/// Minimap flags
	var/flags
	/// Minimap target
	var/target

/atom/movable/screen/minimap/Initialize(mapload, datum/hud/hud_owner, target, flags, shifting = FALSE, live = TRUE)
	. = ..()
	if(!SSminimaps.minimaps_by_z["[target]"])
		return
	choices_by_mob = list()
	stop_polling = list()
	icon = SSminimaps.minimaps_by_z["[target]"].hud_image
	SSminimaps.add_to_updaters(src, flags, target)
	src.flags = flags
	src.target = target
	src.live = live

	x_max = SSminimaps.minimaps_by_z["[target]"].x_max
	y_max = SSminimaps.minimaps_by_z["[target]"].y_max

	if(shifting && (x_max > SCREEN_PIXEL_SIZE || y_max > SCREEN_PIXEL_SIZE))
		START_PROCESSING(SSobj, src)
		if(findtext(screen_loc, "1") != 1) // We're detecting the first position matching, not the 1 there
			CRASH("Shifting a minimap screen_loc of '[screen_loc]' is not currently implemented!") // Just need to do string manip in process to support it
	add_filter("border_outline", 1, outline_filter(2, COLOR_BLACK))
	add_filter("map_glow", 2, drop_shadow_filter(x = 0, y = 0, size = 3, offset = 1, color = "#c0f7ff"))
	add_filter("overlay", 3, layering_filter(x = 0, y = 0, icon = 'icons/mob/hud/minimap_overlay.dmi', blend_mode = BLEND_INSET_OVERLAY))

/atom/movable/screen/minimap/proc/update()
	if(live)
		return
	
	SSminimaps.add_to_updaters(src, flags, target)

/atom/movable/screen/minimap/process()
	if(stop_shifting)
		return
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
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MINIMAP_SHIFTED)

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
	RegisterSignal(user, signal_by_type, PROC_REF(on_click))
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
/atom/movable/screen/minimap/proc/on_click(datum/source, atom/A, params)
	SIGNAL_HANDLER
	var/list/modifiers = params2list(params)
	// Only shift click because otherwise this conflicts with clicking on other stuff
	if(!modifiers[SHIFT_CLICK])
		return
	// we only care about absolute coords because the map is fixed to 1,1 so no client stuff
	var/list/pixel_coords = params2screenpixel(modifiers["screen-loc"])
	var/zlevel = SSminimaps.updators_by_datum[src].ztarget
	var/x = (pixel_coords[1] - SSminimaps.minimaps_by_z["[zlevel]"].x_offset + cur_x_shift)  / MINIMAP_SCALE
	var/y = (pixel_coords[2] - SSminimaps.minimaps_by_z["[zlevel]"].y_offset + cur_y_shift)  / MINIMAP_SCALE
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
	///Whether this minimap should shift or not
	var/shifting = TRUE
	///Toggle for scrolling map
	var/atom/movable/screen/stop_scroll/scroll_toggle
	///Does this minimap action get scroll toggle
	var/has_scroll = TRUE
	/// Is it live
	var/live = FALSE

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
	if(!map)
		return FALSE

	if(!isobserver(owner) && owner.is_mob_incapacitated())
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
		if(locate(/atom/movable/screen/minimap) in owner.client.screen) //This seems like the most effective way to do this without some wacky code
			to_chat(owner, SPAN_WARNING("You already have a minimap open!"))
			return FALSE
		owner.client.screen += map
		owner.client.screen += locator
		if(scroll_toggle)
			owner.client.screen += scroll_toggle
		locator.link_locator(map, owner)
		locator.update(tracking, null, null)
		locator.RegisterSignal(SSdcs, COMSIG_GLOB_MINIMAP_SHIFTED, TYPE_PROC_REF(/atom/movable/screen/minimap_locator, update))
		locator.RegisterSignal(tracking, COMSIG_MOVABLE_MOVED, TYPE_PROC_REF(/atom/movable/screen/minimap_locator, update))
	else
		owner.client.screen -= map
		owner.client.screen -= locator
		if(scroll_toggle)
			owner.client.screen -= scroll_toggle
		map.stop_polling -= owner
		locator.UnregisterSignal(SSdcs, COMSIG_GLOB_MINIMAP_SHIFTED)
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
	locator.UnregisterSignal(SSdcs, COMSIG_GLOB_MINIMAP_SHIFTED)
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
	locator.RegisterSignal(SSdcs, COMSIG_GLOB_MINIMAP_SHIFTED, TYPE_PROC_REF(/atom/movable/screen/minimap_locator, update))
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
		locator.RegisterSignal(SSdcs, COMSIG_GLOB_MINIMAP_SHIFTED, TYPE_PROC_REF(/atom/movable/screen/minimap_locator, update))
		locator.RegisterSignal(owner, COMSIG_MOVABLE_MOVED, TYPE_PROC_REF(/atom/movable/screen/minimap_locator, update))
		locator.link_locator(map, owner)
		locator.update(owner)
	locator_override = null

/datum/action/minimap/give_to(mob/M)
	. = ..()
	var/atom/movable/tracking = locator_override ? locator_override : M
	RegisterSignal(tracking, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(on_owner_z_change))
	if(default_overwatch_level)
		if(!SSminimaps.minimaps_by_z["[default_overwatch_level]"] || !SSminimaps.minimaps_by_z["[default_overwatch_level]"].hud_image)
			return
		map = SSminimaps.fetch_minimap_object(default_overwatch_level, minimap_flags, shifting, live)
		return
	if(!SSminimaps.minimaps_by_z["[tracking.z]"] || !SSminimaps.minimaps_by_z["[tracking.z]"].hud_image)
		return
	map = SSminimaps.fetch_minimap_object(tracking.z, minimap_flags, shifting, live)
	if(has_scroll || scroll_toggle)
		scroll_toggle = new /atom/movable/screen/stop_scroll(null, map)

/datum/action/minimap/remove_from(mob/M)
	toggle_minimap(FALSE)
	UnregisterSignal(locator_override || M, COMSIG_MOVABLE_Z_CHANGED)
	return ..()

/**
 * Updates the map when the owner changes zlevel
 */
/datum/action/minimap/proc/on_owner_z_change(atom/movable/source, oldz, newz)
	SIGNAL_HANDLER
	var/atom/movable/tracking = locator_override ? locator_override : owner
	if(minimap_displayed)
		owner.client?.screen -= map
	map = null
	if(default_overwatch_level)
		if(!SSminimaps.minimaps_by_z["[default_overwatch_level]"] || !SSminimaps.minimaps_by_z["[default_overwatch_level]"].hud_image)
			if(minimap_displayed)
				owner.client?.screen -= locator
				locator.UnregisterSignal(SSdcs, COMSIG_GLOB_MINIMAP_SHIFTED)
				locator.UnregisterSignal(tracking, COMSIG_MOVABLE_MOVED)
				minimap_displayed = FALSE
			return
		map = SSminimaps.fetch_minimap_object(default_overwatch_level, minimap_flags, shifting, live)
		if(minimap_displayed)
			if(owner.client)
				owner.client.screen += map
			else
				minimap_displayed = FALSE
		return
	if(!SSminimaps.minimaps_by_z["[newz]"] || !SSminimaps.minimaps_by_z["[newz]"].hud_image)
		if(minimap_displayed)
			owner.client?.screen -= locator
			locator.UnregisterSignal(SSdcs, COMSIG_GLOB_MINIMAP_SHIFTED)
			locator.UnregisterSignal(tracking, COMSIG_MOVABLE_MOVED)
			minimap_displayed = FALSE
		return
	map = SSminimaps.fetch_minimap_object(newz, minimap_flags, shifting, live)
	if(scroll_toggle)
		scroll_toggle.linked_map = map
	if(minimap_displayed)
		if(owner.client)
			owner.client.screen += map
		else
			minimap_displayed = FALSE


/datum/action/minimap/xeno
	minimap_flags = MINIMAP_FLAG_XENO
	live = TRUE

/datum/action/minimap/xeno/action_activate()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	if(!xeno?.hive?.living_xeno_queen?.ovipositor && xeno != xeno?.hive?.living_xeno_queen)
		to_chat(xeno, SPAN_WARNING("You cannot access that right now, The Queen has shed her ovipositor."))
		return

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
	minimap_flags = MINIMAP_FLAG_XENO|MINIMAP_FLAG_USCM|MINIMAP_FLAG_UPP|MINIMAP_FLAG_PMC
	marker_flags = NONE
	has_scroll = FALSE
	live = TRUE

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

/atom/movable/screen/exit_map
	name = "Close Minimap"
	desc = "Close the minimap"
	icon = 'icons/ui_icons/minimap_buttons.dmi'
	icon_state = "close"
	screen_loc = "RIGHT,TOP"
	plane = TACMAP_PLANE
	layer = INTRO_LAYER
	var/datum/component/tacmap/linked_map

/atom/movable/screen/exit_map/Initialize(mapload, linked_map)
	. = ..()
	src.linked_map = linked_map

/atom/movable/screen/exit_map/MouseEntered(location, control, params)
	. = ..()
	add_filter("mouseover", 1, outline_filter(1, COLOR_LIME))
	if(desc)
		openToolTip(usr, src, params, title = name, content = desc)

/atom/movable/screen/exit_map/MouseExited(location, control, params)
	. = ..()
	remove_filter("mouseover")
	if(desc)
		closeToolTip(usr)

/atom/movable/screen/exit_map/clicked(location, list/modifiers)
	linked_map.on_unset_interaction(usr)
	return TRUE

/atom/movable/screen/stop_scroll
	name = "Stop Scrolling"
	desc = "Stop the scrolling of the minimap(shared)"
	icon = 'icons/ui_icons/minimap_buttons.dmi'
	icon_state = "scroll"
	screen_loc = "CENTER,TOP"
	plane = TACMAP_PLANE
	layer = INTRO_LAYER
	/// what minimap screen is linked to this button
	var/atom/movable/screen/minimap/linked_map

/atom/movable/screen/stop_scroll/Initialize(mapload, linked_map)
	. = ..()
	src.linked_map = linked_map

/atom/movable/screen/stop_scroll/MouseEntered(location, control, params)
	. = ..()
	add_filter("mouseover", 1, outline_filter(1, COLOR_LIME))
	if(desc)
		openToolTip(usr, src, params, title = name, content = desc)

/atom/movable/screen/stop_scroll/MouseExited(location, control, params)
	. = ..()
	remove_filter("mouseover")
	if(desc)
		closeToolTip(usr)

/atom/movable/screen/stop_scroll/clicked(location, list/modifiers)
	if(linked_map.stop_shifting)
		linked_map.stop_shifting = FALSE
		icon_state = "scroll"
	else
		linked_map.stop_shifting = TRUE
		icon_state = "scroll_stop"
	return TRUE

/atom/movable/screen/minimap_tool
	icon = 'icons/ui_icons/minimap_buttons.dmi'
	layer = TACMAP_LAYER
	plane = TACMAP_PLANE
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
	add_filter("mouseover", 1, outline_filter(1, COLOR_LIME))
	if(desc)
		openToolTip(usr, src, params, title = name, content = desc)

/atom/movable/screen/minimap_tool/MouseExited(location, control, params)
	. = ..()
	remove_filter("mouseover")
	if(desc)
		closeToolTip(usr)

/atom/movable/screen/minimap_tool/clicked(location, list/modifiers)
	if(LAZYACCESS(modifiers, LEFT_CLICK))
		RegisterSignal(usr, COMSIG_MOB_MOUSEDOWN, PROC_REF(on_mousedown))
		usr.client.mouse_pointer_icon = active_mouse_icon
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
	if(istype(object, /atom/movable/screen/minimap_tool))
		UnregisterSignal(usr, COMSIG_MOB_MOUSEDOWN)
		usr.client.mouse_pointer_icon = null
		return NONE
	return COMSIG_MOB_CLICK_CANCELED

/atom/movable/screen/minimap_tool/draw_tool
	icon_state = "draw"
	desc = "Draw using a color. Drag to draw a line, middle click to place a dot. Middle click this button to unselect."
	// color that this draw tool will be drawing in
	color = COLOR_PINK
	var/list/last_drawn
	///temporary existing list used to calculate a line between the start of a click and the end of a click
	var/list/starting_coords

/atom/movable/screen/minimap_tool/draw_tool/clicked(location, list/modifiers)
	. = ..()
	if(LAZYACCESS(modifiers, MIDDLE_CLICK) && last_drawn)
		last_drawn += list(null)
		draw_line(arglist(last_drawn))
		last_drawn = null

/atom/movable/screen/minimap_tool/draw_tool/on_mousedown(mob/source, atom/object, location, control, params)
	. = ..()
	if(!.)
		return
	var/list/modifiers = params2list(params)
	var/list/pixel_coords = params2screenpixel(modifiers["screen-loc"])
	pixel_coords = list(pixel_coords[1] + linked_map.cur_x_shift, pixel_coords[2] + linked_map.cur_y_shift)
	if(modifiers[BUTTON] == MIDDLE_CLICK)
		var/icon/mona_lisa = icon(drawn_image.icon)
		mona_lisa.DrawBox(color, pixel_coords[1], pixel_coords[2], ++pixel_coords[1], ++pixel_coords[2])
		drawn_image.icon = mona_lisa
		return COMSIG_MOB_CLICK_CANCELED
	starting_coords = pixel_coords
	RegisterSignal(source, COMSIG_MOB_MOUSEUP, PROC_REF(on_mouseup))
	return COMSIG_MOB_CLICK_CANCELED

///Called when the mouse is released again to finish the drag-draw
/atom/movable/screen/minimap_tool/draw_tool/proc/on_mouseup(mob/living/source, atom/object, location, control, params)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_MOB_MOUSEUP)
	var/list/modifiers = params2list(params)
	var/list/end_coords = params2screenpixel(modifiers["screen-loc"])
	end_coords = list(end_coords[1] + linked_map.cur_x_shift, end_coords[2] + linked_map.cur_y_shift)
	draw_line(starting_coords, end_coords)
	last_drawn = list(starting_coords, end_coords)

/// proc for drawing a line from list(startx, starty) to list(endx, endy) on the screen. yes this is aa ripoff of [/proc/getline]
/atom/movable/screen/minimap_tool/draw_tool/proc/draw_line(list/start_coords, list/end_coords, draw_color = color)
	// converts these into the unscaled minimap version so we have to do less calculating
	var/start_x = FLOOR(start_coords[1]/2, 1)
	var/start_y = FLOOR(start_coords[2]/2, 1)
	var/end_x = FLOOR(end_coords[1]/2, 1)
	var/end_y = FLOOR(end_coords[2]/2, 1)
	var/icon/mona_lisa = icon(drawn_image.icon)

	//special case 1, straight line
	if(start_x == end_x)
		mona_lisa.DrawBox(draw_color, start_x*2, start_y*2, start_x*2 + 1, end_y*2 + 1)
		drawn_image.icon = mona_lisa
		return
	if(start_y == end_y)
		drawn_image.icon = mona_lisa
		mona_lisa.DrawBox(draw_color, start_x*2, start_y*2, end_x*2 + 1, start_y*2 + 1)
		return

	mona_lisa.DrawBox(draw_color, start_x*2, start_y*2, start_x*2 + 1, start_y*2 + 1)

	var/abs_dx = abs(end_x - start_x)
	var/abs_dy = abs(end_y - start_y)
	var/sign_dx = ( ((end_x - start_x) > 0) - ((end_x - start_x) < 0) )
	var/sign_dy = ( ((end_y - start_y) > 0) - ((end_y - start_y) < 0) )

	//special case 2, perfectly diagonal line
	if(abs_dx == abs_dy)
		for(var/j = 1 to abs_dx)
			start_x += sign_dx
			start_y += sign_dy
			mona_lisa.DrawBox(draw_color, start_x*2, start_y*2, start_x*2 + 1, start_y*2 + 1)
		drawn_image.icon = mona_lisa
		return

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
			mona_lisa.DrawBox(draw_color, start_x*2, start_y*2, start_x*2 + 1, start_y*2 + 1)
	else
		var/x_error = -(abs_dy >> 1)
		var/steps = abs_dy
		while(steps--)
			x_error += abs_dx
			if(x_error > 0)
				x_error -= abs_dy
				start_x += sign_dx
			start_y += sign_dy
			mona_lisa.DrawBox(draw_color, start_x*2, start_y*2, start_x*2 + 1, start_y*2 + 1)
	drawn_image.icon = mona_lisa

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
	desc = "Drag to erase a line, middle click to erase a dot. Middle click this button to unselect."
	active_mouse_icon = 'icons/ui_icons/minimap_mouse/draw_erase.dmi'
	screen_loc = "15,10"
	color = null

/atom/movable/screen/minimap_tool/label
	icon_state = "label"
	desc = "Click to place a label. Middle click a label to remove it. Middle click this button to remove all labels."
	active_mouse_icon = 'icons/ui_icons/minimap_mouse/label.dmi'
	screen_loc = "15,9"
	/// List of turfs that have labels attached to them. kept around so it can be cleared
	var/list/turf/labelled_turfs = list()

/atom/movable/screen/minimap_tool/label/clicked(location, list/modifiers)
	. = ..()
	if(LAZYACCESS(modifiers, MIDDLE_CLICK))
		clear_labels(usr)

///Clears all labels and logs who did it
/atom/movable/screen/minimap_tool/label/proc/clear_labels(mob/user)
	for(var/turf/label as anything in labelled_turfs)
		SSminimaps.remove_marker(label)

/atom/movable/screen/minimap_tool/label/on_mousedown(mob/source, atom/object, location, control, params)
	. = ..()
	if(!.)
		return
	INVOKE_ASYNC(src, PROC_REF(async_mousedown), source, object, location, control, params)
	return COMSIG_MOB_CLICK_CANCELED

///async mousedown for the actual label placement handling
/atom/movable/screen/minimap_tool/label/proc/async_mousedown(mob/source, atom/object, location, control, params)
	// this is really [/atom/movable/screen/minimap/proc/get_coords_from_click] copypaste since we
	// want to also cancel the click if they click src and I cant be bothered to make it even more generic rn
	var/list/modifiers = params2list(params)
	var/list/pixel_coords = params2screenpixel(modifiers["screen-loc"])
	var/x = (pixel_coords[1] - x_offset + linked_map.cur_x_shift) / MINIMAP_SCALE
	var/y = (pixel_coords[2] - y_offset + linked_map.cur_y_shift) / MINIMAP_SCALE
	var/c_x = clamp(CEILING(x, 1), 1, world.maxx)
	var/c_y = clamp(CEILING(y, 1), 1, world.maxy)
	var/turf/target = locate(c_x, c_y, zlevel)
	if(modifiers[BUTTON] == MIDDLE_CLICK)
		var/curr_dist
		var/turf/nearest
		for(var/turf/label as anything in labelled_turfs)
			var/dist = get_dist_euclidian(label, target)
			if(dist > LABEL_REMOVE_RANGE)
				continue
			if(!curr_dist || curr_dist > dist)
				curr_dist = dist
				nearest = label
		if(nearest)
			SSminimaps.remove_marker(nearest)
		return
	var/label_text = MAPTEXT(tgui_input_text(source, title = "Label Name", max_length = 35))
	if(!label_text)
		return
	var/atom/movable/screen/minimap/mini = SSminimaps.fetch_minimap_object(zlevel, minimap_flag, TRUE)
	if(!locate(mini) in source.client?.screen)
		return

	var/mutable_appearance/textbox = new
	textbox.maptext_x = 5
	textbox.maptext_y = 5
	textbox.maptext_width = 64
	textbox.maptext = label_text

	labelled_turfs += target
	var/image/blip = image('icons/ui_icons/map_blips.dmi', null, "label", ABOVE_FLOAT_LAYER)
	blip.overlays += textbox
	SSminimaps.add_marker(target, minimap_flag, blip)

/atom/movable/screen/minimap_tool/clear
	icon_state = "clear"
	desc = "Remove all current labels and drawings."
	screen_loc = "15,8"

/atom/movable/screen/minimap_tool/clear/clicked(location, list/modifiers)
	drawn_image.icon = icon('icons/ui_icons/minimap.dmi')
	var/atom/movable/screen/minimap_tool/label/labels = locate() in usr.client?.screen
	labels?.clear_labels(usr)

/atom/movable/screen/minimap_tool/update
	icon_state = "update"
	desc = "Send a tacmap update"
	screen_loc = "15,7"
	COOLDOWN_DECLARE(update_cooldown)

/atom/movable/screen/minimap_tool/update/clicked(location, list/modifiers)
	if(!COOLDOWN_FINISHED(src, update_cooldown))
		to_chat(location, SPAN_WARNING("Wait another [COOLDOWN_SECONDSLEFT(src, update_cooldown)] seconds before sending another update."))
		return
	
	COOLDOWN_START(src, update_cooldown, CANVAS_COOLDOWN_TIME)
	
	//Forgive me
	for(var/mob/living/carbon/human/player in GLOB.human_mob_list)
		var/datum/action/minimap/minimap_action = locate() in player.actions

		if(!minimap_action)
			continue

		minimap_action.map?.update()

	return TRUE

/atom/movable/screen/minimap_tool/up
	icon_state = "up"
	desc = "Move up a level"
	screen_loc = "15,6"

/atom/movable/screen/minimap_tool/up/clicked(location, list/modifiers)
	if(!SSmapping.same_z_map(zlevel, zlevel+1))
		return
	
	owner.move_tacmap_up()

	return TRUE

/atom/movable/screen/minimap_tool/down
	icon_state = "down"
	desc = "Move down a level"
	screen_loc = "15,5"

/atom/movable/screen/minimap_tool/down/clicked(location, list/modifiers)
	if(!SSmapping.same_z_map(zlevel, zlevel-1))
		return
	
	owner.move_tacmap_down()

	return TRUE

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
		if(XENO_HIVE_RENEGADE)
			return MINIMAP_FLAG_XENO_RENEGADE
	return 0
