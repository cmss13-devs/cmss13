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
		var/icon/icon_gen = new('icons/ui_icons/minimap.dmi') //480x480 blank icon template for drawing on the map
		for(var/xval in 1 to world.maxx)
			for(var/yval in 1 to world.maxy) //Scan all the turfs and draw as needed
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
/datum/controller/subsystem/minimaps/proc/fetch_minimap_object(zlevel, flags)
	var/hash = "[zlevel]-[flags]"
	if(hashed_minimaps[hash])
		return hashed_minimaps[hash]
	var/atom/movable/screen/minimap/map = new(null, zlevel, flags)
	if (!map.icon) //Don't wanna save an unusable minimap for a z-level.
		CRASH("Empty and unusable minimap generated for '[zlevel]-[flags]'") //Can be caused by atoms calling this proc before minimap subsystem initializing.
	hashed_minimaps[hash] = map
	return map

/**
 * Fetches either a datum containing either a flattend map png reference or a set of given svg coords
 * Arguments:
 * * user: mob, to determine which faction get the map from.
 * * asset_type: true for png, false for svg
 */
/datum/proc/get_current_tacmap_data(mob/user, asset_type)
	var/list/map_list
	if(ishuman(user))
		if(asset_type)
			map_list = GLOB.uscm_flat_tacmap_png_asset
		else
			map_list = GLOB.uscm_svg_overlay
	else
		if(asset_type)
			map_list = GLOB.xeno_flat_tacmap_png_asset
		else
			map_list = GLOB.xeno_svg_overlay


	if(map_list.len == 0)
		return

	return map_list[map_list.len]

/**
 * flattens the current map and then distributes it based off user faction.
 * Arguments:
 * * user: to determine which faction to distribute to
 * Return:
 * * returns a boolean value, true if the operation was successful, false if it was not.
 */
/datum/tacmap/proc/distribute_current_map_png(mob/user)
	if(!COOLDOWN_FINISHED(src, flatten_map_cooldown))
		return FALSE
	var/icon/flat_map = getFlatIcon(map_holder.map)
	if(!flat_map)
		to_chat(user, SPAN_WARNING("The tacmap filckers and then shuts off, a critical error has occured")) // tf2heavy: "Oh, this is bad!"
		return FALSE
	var/user_faction
	var/mob/living/carbon/xenomorph/xeno
	if(isxeno(user))
		xeno = user
		user_faction = xeno.hivenumber
	else
		user_faction = FACTION_MARINE

	var/list/faction_clients = list()
	for(var/client/client in GLOB.clients)
		var/mob/client_mob = client.mob
		if(isxeno(client_mob))
			xeno = client_mob
			if(xeno.hivenumber == user_faction)
				faction_clients += client
		else if(client_mob.faction == user_faction)
			faction_clients += client
	COOLDOWN_START(src, flatten_map_cooldown, flatten_map_cooldown_time)
	var/flat_tacmap_png = icon2html(flat_map, faction_clients, sourceonly = TRUE)
	var/datum/flattend_tacmap_png/new_flat = new(flat_tacmap_png)
	if(!isxeno(user))
		GLOB.uscm_flat_tacmap_png_asset += new_flat
	else
		GLOB.xeno_flat_tacmap_png_asset += new_flat
	qdel(new_flat)
	return TRUE

/**
 * globally stores svg coords for a given faction.
 * Arguments:
 * * user: mob, to determine which faction to distribute to
 * * svg_coords: an array of coordinates corresponding to an svg.
 */
/datum/tacmap/proc/store_current_svg_coords(mob/user, svg_coords)
	var/datum/svg_overlay/svg_store_overlay = new(svg_coords)

	if(isxeno(user))
		GLOB.xeno_svg_overlay += svg_store_overlay
	else
		GLOB.uscm_svg_overlay += svg_store_overlay

	qdel(svg_store_overlay)


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
		owner.client.remove_from_screen(map)
	else
		owner.client.add_to_screen(map)
	minimap_displayed = !minimap_displayed

/datum/action/minimap/give_to(mob/target)
	. = ..()

	if(default_overwatch_level)
		map = SSminimaps.fetch_minimap_object(default_overwatch_level, minimap_flags)
	else
		RegisterSignal(target, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(on_owner_z_change))

	var/turf/turf_gotten = get_turf(target)
	if(!turf_gotten)
		return
	var/z_level = turf_gotten.z

	if(!SSminimaps.minimaps_by_z["[z_level]"] || !SSminimaps.minimaps_by_z["[z_level]"].hud_image)
		return
	map = SSminimaps.fetch_minimap_object(z_level, minimap_flags)

/datum/action/minimap/remove_from(mob/target)
	. = ..()
	if(minimap_displayed)
		owner?.client?.remove_from_screen(map)
		minimap_displayed = FALSE

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
		map = SSminimaps.fetch_minimap_object(default_overwatch_level, minimap_flags)
		return
	map = SSminimaps.fetch_minimap_object(newz, minimap_flags)

/datum/action/minimap/xeno
	minimap_flags = MINIMAP_FLAG_XENO

/datum/action/minimap/marine
	minimap_flags = MINIMAP_FLAG_USCM
	marker_flags = MINIMAP_FLAG_USCM

/datum/action/minimap/observer
	minimap_flags = MINIMAP_FLAG_ALL
	marker_flags = NONE
	hidden = TRUE

/datum/tacmap
	var/allowed_flags = MINIMAP_FLAG_USCM
	/// by default the ground map - this picks the first level matching the trait. if it exists
	var/targeted_ztrait = ZTRAIT_GROUND
	var/atom/owner

	// color selection for the tactical map canvas, defaults to black.
	var/toolbar_color_selection = "black"
	var/toolbar_updated_selection = "black"

	var/canvas_cooldown_time = 4 MINUTES
	var/flatten_map_cooldown_time = 3 MINUTES
	COOLDOWN_DECLARE(flatten_map_cooldown)

	//tacmap holder for holding the minimap
	var/datum/tacmap_holder/map_holder

	// boolean value to keep track if the canvas has been updated or not, the value is used in tgui state.
	var/updated_canvas = FALSE

	var/datum/flattend_tacmap_png/current_map = new
	var/datum/svg_overlay/current_svg = new

/datum/tacmap/New(atom/source, minimap_type)
	allowed_flags = minimap_type
	owner = source


/datum/tacmap/status_tab_view/New()
	var/datum/tacmap/status_tab_view/uscm_tacmap
	allowed_flags = MINIMAP_FLAG_USCM
	owner = uscm_tacmap

/datum/tacmap/Destroy()
	map_holder = null
	owner = null
	return ..()

/datum/tacmap/tgui_interact(mob/user, datum/tgui/ui)
	if(!map_holder)
		var/level = SSmapping.levels_by_trait(targeted_ztrait)
		if(!level[1])
			return
		map_holder = SSminimaps.fetch_tacmap_datum(level[1], allowed_flags)

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		current_map = get_current_tacmap_data(user, TRUE)
		current_svg = get_current_tacmap_data(user, FALSE)
		if(!current_map)
			if(!distribute_current_map_png(user))
				return
			current_map = get_current_tacmap_data(user, TRUE)


		user.client.register_map_obj(map_holder.map)
		ui = new(user, src, "TacticalMap")
		ui.open()

/datum/tacmap/ui_data(mob/user)
	var/list/data = list()

	data["flatImage"] = current_map.flat_tacmap

	data["svgData"] = null

	if(current_svg)
		data["svgData"] = current_svg.svg_data

	data["mapRef"] = map_holder.map_ref
	data["toolbarColorSelection"] = toolbar_color_selection
	data["toolbarUpdatedSelection"] = toolbar_updated_selection
	data["worldtime"] = world.time
	if(isxeno(user))
		data["canvasCooldown"] = GLOB.xeno_canvas_cooldown
	else
		data["canvasCooldown"] = GLOB.uscm_canvas_cooldown
	data["nextCanvasTime"] = canvas_cooldown_time
	data["updatedCanvas"] = updated_canvas

	return data

/datum/tacmap/ui_static_data(mob/user)
	var/list/data = list()

	data["canDraw"] = FALSE
	data["canViewHome"] = FALSE
	data["isXeno"] = FALSE
	data["currentMapName"] = SSmapping.configs?[GROUND_MAP].map_name

	var/mob/living/carbon/xenomorph/xeno_user
	if(isxeno(user))
		xeno_user = user
		data["isXeno"] = TRUE
		data["canViewHome"] = TRUE

	if(ishuman(user) && skillcheck(user, SKILL_LEADERSHIP, SKILL_LEAD_EXPERT) || isqueen(user) && xeno_user.hivenumber == XENO_HIVE_NORMAL)
		data["canDraw"] = TRUE
		data["canViewHome"] = TRUE

	return data

/datum/tacmap/status_tab_view/ui_static_data(mob/user)
	var/list/data = list()

	data["currentMapName"] = SSmapping.configs?[GROUND_MAP].map_name
	data["canDraw"] = FALSE
	data["canViewHome"] = FALSE
	data["isXeno"] = FALSE

	return data

/datum/tacmap/ui_close(mob/user)
	. = ..()
	updated_canvas = FALSE
	toolbar_color_selection = "black"
	toolbar_updated_selection = "black"

/datum/tacmap/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/user = ui.user

	switch (action)
		if ("menuSelect")
			if(params["selection"] == "new canvas")
				if(!distribute_current_map_png(user))
					return
				current_map = get_current_tacmap_data(user, TRUE)

			. = TRUE

		if ("updateCanvas")
			// forces state change, this will export the svg.
			toolbar_updated_selection = "export"
			updated_canvas = TRUE
			. = TRUE

		if ("clearCanvas")
			if(toolbar_updated_selection == "clear")
				toolbar_updated_selection = toolbar_color_selection
				return
			toolbar_updated_selection = "clear"
			. = TRUE

		if ("undoChange")
			if(toolbar_updated_selection == "undo")
				toolbar_updated_selection = toolbar_color_selection
				return
			toolbar_updated_selection = "undo"
			. = TRUE

		if ("selectColor")

			toolbar_color_selection = params["color"]
			toolbar_updated_selection = toolbar_color_selection
			. = TRUE

		if ("selectAnnouncement")

			if(!istype(params["image"], /list)) // potentially very serious?
				return

			store_current_svg_coords(user, params["image"])

			current_svg = get_current_tacmap_data(user, FALSE)
			if(isxeno(user))
				var/mob/living/carbon/xenomorph/xeno = user
				xeno_maptext("The Queen has updated your hive mind map", "You sense something unusual...", xeno.hivenumber)
				COOLDOWN_START(GLOB, xeno_canvas_cooldown, canvas_cooldown_time)
			else
				var/mob/living/carbon/human/human_leader = user
				for(var/datum/squad/current_squad in RoleAuthority.squads)
					current_squad.send_maptext("Tactical map update in progress...", "Tactical Map:")

				human_leader.visible_message(SPAN_BOLDNOTICE("Tactical map update in progress..."))
				playsound_client(human_leader.client, "sound/effects/sos-morse-code.ogg")
				COOLDOWN_START(GLOB, uscm_canvas_cooldown, canvas_cooldown_time)

			message_admins("[key_name(user)] has updated the tactical map")
			updated_canvas = FALSE
			. = TRUE

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

/datum/tacmap/xeno/ui_status(mob/user)
	if(!isxeno(user))
		return UI_CLOSE

	var/mob/living/carbon/xenomorph/xeno = user
	if(!xeno.hive?.living_xeno_queen?.ovipositor)
		return UI_CLOSE

	return UI_INTERACTIVE

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

// datums for holding both the flattend png asset reference and an svg overlay. It's best to keep them separate with the current implementation imo.
/datum/flattend_tacmap_png
	var/flat_tacmap

/datum/flattend_tacmap_png/New(flat_tacmap)
	src.flat_tacmap = flat_tacmap

/datum/svg_overlay
	var/svg_data

/datum/svg_overlay/New(svg_data)
	src.svg_data = svg_data
