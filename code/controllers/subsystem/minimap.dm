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
	for(var/level=1 to length(SSmapping.z_list))
		minimaps_by_z["[level]"] = new /datum/hud_displays
		if(!is_ground_level(level))
			continue
		var/icon/icon_gen = new('icons/ui_icons/minimap.dmi') //480x480 blank icon template for drawing on the map
		for(var/xval = 1 to world.maxx)
			for(var/yval = 1 to world.maxy) //Scan all the turfs and draw as needed
				var/turf/location = locate(xval,yval,level)
				if(istype(location, /turf/open/space))
					continue
				if(location.z != level)
					continue
				if(location.density)
					icon_gen.DrawBox(location.minimap_color, xval, yval)
					continue
				var/atom/movable/alttarget = (locate(/obj/structure/machinery/door) in location) || (locate(/obj/structure/fence) in location)
				if(alttarget)
					icon_gen.DrawBox(alttarget.minimap_color, xval, yval)
					continue
				var/area/turfloc = location.loc
				if(turfloc.minimap_color)
					icon_gen.DrawBox(BlendRGB(location.minimap_color, turfloc.minimap_color, 0.5), xval, yval)
					continue
				icon_gen.DrawBox(location.minimap_color, xval, yval)
		icon_gen.Scale(480 * MINIMAP_SCALE ,480 * MINIMAP_SCALE) //scale it up x2 to make it easer to see
		icon_gen.Crop(1, 1, min(icon_gen.Width(), 480), min(icon_gen.Height(), 480)) //then cut all the empty pixels

		//generation is done, now we need to center the icon to someones view, this can be left out if you like it ugly and will halve SSinit time
		//calculate the offset of the icon
		var/largest_x = 0
		var/smallest_x = SCREEN_PIXEL_SIZE
		var/largest_y = 0
		var/smallest_y = SCREEN_PIXEL_SIZE
		for(var/xval=1 to SCREEN_PIXEL_SIZE step 2)
			for(var/yval=1 to SCREEN_PIXEL_SIZE step 2)
				if(!icon_gen.GetPixel(xval, yval))
					continue
				if(xval > largest_x)
					largest_x = xval
				else if(xval < smallest_x)
					smallest_x = xval
				if(yval > largest_y)
					largest_y = yval
				else if(yval < smallest_y)
					smallest_y = yval

		minimaps_by_z["[level]"].x_offset = FLOOR((SCREEN_PIXEL_SIZE-largest_x-smallest_x) / MINIMAP_SCALE, 1)
		minimaps_by_z["[level]"].y_offset = FLOOR((SCREEN_PIXEL_SIZE-largest_y-smallest_y) / MINIMAP_SCALE, 1)

		icon_gen.Shift(EAST, minimaps_by_z["[level]"].x_offset)
		icon_gen.Shift(NORTH, minimaps_by_z["[level]"].y_offset)

		minimaps_by_z["[level]"].hud_image = icon_gen //done making the image!

	RegisterSignal(SSdcs, COMSIG_GLOB_NEW_Z, PROC_REF(handle_new_z))

	initialized = TRUE

	for(var/i=1 to length(earlyadds)) //lateload icons
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
			updator.minimap.overlays += minimaps_by_z["[updator.ztarget]"].images_raw[flag]
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
 * That that forces us to use a seperate list ref when accessing the lists of this datum
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
		RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))
	removal_cbs[target] = CALLBACK(src, PROC_REF(removeimage), blip, target, zlevel)
	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(remove_marker))



/**
 * removes an image from raw tracked lists, invoked by callback
 */
/datum/controller/subsystem/minimaps/proc/removeimage(image/blip, atom/target, zlevel)
	for(var/flag in GLOB.all_minimap_flags)
		minimaps_by_z["[zlevel]"].images_raw["[flag]"] -= blip
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

		removal_cbs -= source
		removal_cbs[source] = CALLBACK(src, PROC_REF(removeimage), ref_old, source, newz)

/**
 * Simple proc, updates overlay position on the map when a atom moves
 */
/datum/controller/subsystem/minimaps/proc/on_move(atom/movable/source, oldloc)
	SIGNAL_HANDLER

	var/source_z = source.z
	if(!source_z)
		return
	images_by_source[source].pixel_x = MINIMAP_PIXEL_FROM_WORLD(source.x) + minimaps_by_z["[source_z]"].x_offset
	images_by_source[source].pixel_y = MINIMAP_PIXEL_FROM_WORLD(source.y) + minimaps_by_z["[source_z]"].y_offset

/**
 * Removes an atom and it's blip from the subsystem
 */
/datum/controller/subsystem/minimaps/proc/remove_marker(atom/source, minimap_flag)
	SIGNAL_HANDLER
	if(!removal_cbs[source]) //already removed
		return
	UnregisterSignal(source, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED, COMSIG_MOVABLE_Z_CHANGED))
	var/turf/turf_gotten = get_turf(source)
	if(!turf_gotten)
		return
	var/z_level = turf_gotten.z
	if(minimap_flag)
		minimaps_by_z["[z_level]"].images_assoc["[minimap_flag]"] -= source
	else
		for(var/flag in GLOB.all_minimap_flags)
			minimaps_by_z["[z_level]"].images_assoc["[flag]"] -= source
	images_by_source -= source
	removal_cbs[source].Invoke()
	removal_cbs -= source


/**
 * Fetches a /atom/movable/screen/minimap instance or creates on if none exists
 * Note this does not destroy them when the map is unused, might be a potential thing to do?
 * Arguments:
 * * zlevel: zlevel to fetch map for
 * * flags: map flags to fetch from
 */
/datum/controller/subsystem/minimaps/proc/fetch_minimap_object(zlevel, flags)
	var/hash = "[zlevel]-[flags]"
	if(hashed_minimaps[hash])
		return hashed_minimaps[hash]
	var/atom/movable/screen/minimap/map = new(null, zlevel, flags)
	if (!map.icon) //Don't wanna save an unusable minimap for a z-level.
		CRASH("Empty and unusable minimap generated for '[zlevel]-[flags]'") //Can be caused by atoms calling this proc before minimap subsystem initializing.
	hashed_minimaps[hash] = map
	return map

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

/atom/movable/screen/minimap/Initialize(mapload, target, flags)
	. = ..()
	if(!SSminimaps.minimaps_by_z["[target]"])
		return
	icon = SSminimaps.minimaps_by_z["[target]"].hud_image
	SSminimaps.add_to_updaters(src, flags, target)


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

/datum/action/minimap/Destroy()
	map = null
	return ..()

/datum/action/minimap/action_activate()
	. = ..()
	if(!map)
		return
	if(minimap_displayed)
		owner.client.screen -= map
	else
		owner.client.screen += map
	minimap_displayed = !minimap_displayed

/datum/action/minimap/give_to(mob/M)
	. = ..()

	if(default_overwatch_level)
		map = SSminimaps.fetch_minimap_object(default_overwatch_level, minimap_flags)
	else
		RegisterSignal(M, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(on_owner_z_change))
	if(!SSminimaps.minimaps_by_z["[M.z]"] || !SSminimaps.minimaps_by_z["[M.z]"].hud_image)
		return
	map = SSminimaps.fetch_minimap_object(M.z, minimap_flags)

/datum/action/minimap/remove_from(mob/M)
	. = ..()
	if(minimap_displayed)
		owner?.client?.screen -= map
		minimap_displayed = FALSE

/**
 * Updates the map when the owner changes zlevel
 */
/datum/action/minimap/proc/on_owner_z_change(atom/movable/source, oldz, newz)
	SIGNAL_HANDLER
	if(minimap_displayed)
		owner.client.screen -= map
		minimap_displayed = FALSE
	map = null
	if(!SSminimaps.minimaps_by_z["[newz]"] || !SSminimaps.minimaps_by_z["[newz]"].hud_image)
		return
	if(default_overwatch_level)
		map = SSminimaps.fetch_minimap_object(default_overwatch_level, minimap_flags)
		return
	map = SSminimaps.fetch_minimap_object(newz, minimap_flags)

/datum/action/minimap/xeno
	minimap_flags = MINIMAP_FLAG_XENO

/datum/action/minimap/marine
	minimap_flags = MINIMAP_FLAG_USCM
	marker_flags = MINIMAP_FLAG_USCM

/datum/action/minimap/observer
	minimap_flags = MINIMAP_FLAG_XENO|MINIMAP_FLAG_USCM|MINIMAP_FLAG_UPP|MINIMAP_FLAG_CLF|MINIMAP_FLAG_UPP
	marker_flags = NONE
	hidden = TRUE

/datum/tacmap
	var/allowed_flags = MINIMAP_FLAG_USCM
	///by default Zlevel 3, groundside is targeted
	var/targeted_zlevel = 3
	var/atom/owner

	var/datum/tacmap_holder/map_holder

/datum/tacmap/New(atom/source, minimap_type)
	allowed_flags = minimap_type
	owner = source

/datum/tacmap/Destroy()
	map_holder = null
	owner = null
	return ..()

/datum/tacmap/tgui_interact(mob/user, datum/tgui/ui)
	if(!map_holder)
		map_holder = SSminimaps.fetch_tacmap_datum(targeted_zlevel, allowed_flags)

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		user.client.register_map_obj(map_holder.map)
		ui = new(user, src, "TacticalMap")
		ui.open()

/datum/tacmap/ui_static_data(mob/user)
	var/list/data = list()
	data["mapRef"] = map_holder.map_ref
	return data

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

/datum/tacmap_holder
	var/map_ref
	var/atom/movable/screen/minimap/map

/datum/tacmap_holder/New(loc, zlevel, flags)
	map_ref = "tacmap_[REF(src)]_map"
	map = SSminimaps.fetch_minimap_object(zlevel, flags)
	map.screen_loc = "[map_ref]:1,1"
	map.assigned_map = map_ref

/datum/tacmap_holder/Destroy()
	map = null
	return ..()
