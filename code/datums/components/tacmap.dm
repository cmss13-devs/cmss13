// State tracking for users using tacmaps - they can't use more than one at once.
/client/var/using_main_tacmap = FALSE
/client/var/using_popout_tacmap = FALSE

/client/proc/using_tacmap()
	return using_main_tacmap || using_popout_tacmap

/**
	Tacmap component

	Adds a tacmap with defined z level and flags to an object and allows it to open and close it
 */
/datum/component/tacmap
	/// What faction flag this tacmap is for
	var/minimap_flag = MINIMAP_FLAG_USCM
	///by default Zlevel 2, groundside is targetted
	var/targetted_zlevel = 2
	///minimap obj ref that we will display to users
	var/atom/movable/screen/minimap/map
	///List of currently interacting mobs
	var/list/mob/interactees = list()
	///Map holder
	var/datum/tacmap_holder/map_holder
	///ceiling_layer for the map_holder
	var/atom/movable/screen/minimap_ceiling_layer/ceiling_layer
	///Is drawing enabled
	var/drawing
	///Is this tacmap embedded in parent UI
	var/is_embedded = FALSE
	/// List of paths to the kinds tools we will be using (stored in interactees[user]["drawing_tools"])
	var/list/atom/movable/screen/minimap_tool/drawing_tools = list(
		/atom/movable/screen/minimap_tool/up,
		/atom/movable/screen/minimap_tool/down,
		)

/datum/component/tacmap/Initialize(has_drawing_tools, minimap_flag, has_update, drawing)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	src.minimap_flag = minimap_flag
	src.drawing = drawing

	if(has_drawing_tools)
		drawing_tools += list(
			/atom/movable/screen/minimap_tool/draw_tool/red,
			/atom/movable/screen/minimap_tool/draw_tool/yellow,
			/atom/movable/screen/minimap_tool/draw_tool/purple,
			/atom/movable/screen/minimap_tool/draw_tool/blue,
			/atom/movable/screen/minimap_tool/draw_tool/green,
			/atom/movable/screen/minimap_tool/draw_tool/black,
			/atom/movable/screen/minimap_tool/draw_tool/erase,
			/atom/movable/screen/minimap_tool/label,
			/atom/movable/screen/minimap_tool/clear,
			/atom/movable/screen/minimap_tool/popout,
		)

	if(has_update)
		drawing_tools += /atom/movable/screen/minimap_tool/update

/datum/component/tacmap/Destroy(force, silent)
	. = ..()
	map = null
	QDEL_NULL(map_holder)
	QDEL_NULL(ceiling_layer)
	interactees.Cut()
	interactees = null

/datum/component/tacmap/proc/move_tacmap_up()
	targetted_zlevel++
	reset()

/datum/component/tacmap/proc/move_tacmap_down()
	targetted_zlevel--
	reset()

/datum/component/tacmap/proc/reset()
	var/list/had_popout = list()
	var/list/_interactees = interactees.Copy()
	for(var/mob/interactee in _interactees)
		if(SStgui.get_open_ui(interactee, src))
			had_popout += interactee
		on_unset_interaction(interactee)
		close_popout_tacmaps(interactee)
	map = null
	for(var/mob/interactee in _interactees)
		show_tacmap(interactee)
		if(interactee in had_popout)
			tgui_interact(interactee)

/datum/component/tacmap/proc/popout(mob/user)
	var/datum/tgui/maybe_ui = SStgui.get_open_ui(user, src)
	if(maybe_ui == null)
		tgui_interact(user)
	else
		close_popout_tacmaps(user)

/datum/component/tacmap/proc/on_unset_interaction(mob/user)
	if(!user.client)
		return

	// Clean up per client objects
	var/list/user_objects = interactees[user]
	if(user_objects)
		user.client.remove_from_screen(user_objects["map"])
		user.client.remove_from_screen(user_objects["drawing_tools"])
		user.client.remove_from_screen(user_objects["close_button"])
		for(var/atom/movable/screen/tool as anything in user_objects["drawing_tools"])
			qdel(tool)
		for(var/atom/movable/screen/button as anything in user_objects["close_button"])
			qdel(button)

		// Remove ceiling protection toggle action when CIC tactical map closes
		var/datum/action/minimap_ceiling/ceiling_action = user_objects["ceiling_action"]
		ceiling_action?.hide_from(user)

		// Clean up drawing tool references and mark CIC minimap inactive
		var/atom/movable/screen/minimap/user_map = user_objects["map"]
		user_map?.active_draw_tool = null
		user_map?.is_cic_minimap = FALSE

	interactees -= user
	user.client.mouse_pointer_icon = null
	user.client.active_draw_tool = null
	winset(user, "drawingtools", "reset=true")
	user.client.using_main_tacmap = FALSE
	UnregisterSignal(user.client, COMSIG_CLIENT_CEILING_PREF_CHANGED)

/datum/component/tacmap/proc/show_tacmap(mob/user)
	if (user.client.using_tacmap())
		to_chat(user.client, SPAN_WARNING("You're already using a tacmap. Close it to open another one."))
		return

	// Get ceiling respective minimap
	RegisterSignal(user.client, COMSIG_CLIENT_CEILING_PREF_CHANGED, PROC_REF(on_ceiling_change))
	var/ceiling = user.client.prefs?.show_minimap_ceiling_protection
	var/atom/movable/screen/minimap/user_map = SSminimaps.fetch_minimap_object(targetted_zlevel, minimap_flag, live=TRUE, popup=FALSE, drawing=drawing, ceiling=ceiling)
	var/atom/movable/screen/exit_map/user_close_button = new(null, src)

	// Apply drawing overlays to minimap
	if(drawing)
		user_map.is_cic_minimap = TRUE
		user_map.update_drawing_overlay(show_cic_drawings = TRUE)

	var/list/atom/movable/screen/user_drawing_tools = list()
	for(var/path in drawing_tools)
		user_drawing_tools += new path(null, targetted_zlevel, minimap_flag, user_map, src)

	user.client.add_to_screen(user_drawing_tools)
	user.client.add_to_screen(user_close_button)
	user.client.add_to_screen(user_map)

	// Give ceiling protection toggle action when CIC tactical map opens
	var/datum/action/minimap_ceiling/ceiling_action = locate() in user.actions
	if(ceiling_action)
		ceiling_action.unhide_from(user)
		// Position the ceiling action right after the minimap action button incase buttons are moved due to a strain or something
		user.actions.Remove(ceiling_action)
		var/datum/action/minimap/minimap_action = locate() in user.actions
		var/minimap_index = user.actions.Find(minimap_action)
		if(minimap_index)
			user.actions.Insert(minimap_index + 1, ceiling_action)
		else
			user.actions.Add(ceiling_action)
		user.update_action_buttons()

	// Set up map_holder for tgui_interact
	user.client.clear_map(map_holder?.map?.assigned_map)
	map_holder = new(null, targetted_zlevel, minimap_flag, drawing=drawing)
	QDEL_NULL(ceiling_layer)
	var/matrix/transform = matrix()
	transform.Translate(-32, 64) // Don't know why we're needing to do this
	ceiling_layer = new(null, map_holder.map_ref, targetted_zlevel, transform)
	ceiling_layer.set_enabled(ceiling)
	if(user.client.using_popout_tacmap)
		user.client.register_map_obj(map_holder.map)
		user.client.register_map_obj(ceiling_layer)

	// Store references for cleanup
	interactees[user] = list(
		"map" = user_map,
		"close_button" = user_close_button,
		"drawing_tools" = user_drawing_tools,
		"ceiling_action" = ceiling_action,
		)

	user.client.using_main_tacmap = TRUE

/// SIGNAL_HANDLER for COMSIG_CLIENT_CEILING_PREF_CHANGED
/datum/component/tacmap/proc/on_ceiling_change(client/target, ceiling_setting)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(reset))

/datum/component/tacmap/ui_status(mob/user, datum/ui_state/state)
	// For embedded tacmap, delegate to parent's UI status
	if(is_embedded)
		return parent.ui_status(user, state)

	if(get_dist(parent, user) > 1)
		return UI_CLOSE

	return UI_INTERACTIVE

/datum/component/tacmap/tgui_interact(mob/user, datum/tgui/ui)
	if(!user.client)
		return

	ui = SStgui.try_update_ui(user, src, ui)

	// try_update_ui returns NULL as the UI even if the UI is trying to close from ui_status.
	// Double check that we aren't attempting to close so that we don't make a UI when we don't need to.
	if(ui || get_dist(parent, user) > 1)
		return

	user.client.register_map_obj(map_holder.map)
	user.client.register_map_obj(ceiling_layer)
	var/ceiling = user.client.prefs?.show_minimap_ceiling_protection
	ceiling_layer.set_enabled(ceiling)

	ui = new(user, src, "TacticalMap")
	ui.open()
	ui.set_autoupdate(FALSE)

	user.client.using_popout_tacmap = TRUE

/datum/component/tacmap/ui_static_data(mob/user)
	. = list()
	.["isXeno"] = isxeno(user)
	.["canChangeZ"] = FALSE

/datum/component/tacmap/ui_data(mob/user)
	. = list()
	if(map_holder != null)
		.["mapRef"] = map_holder.map_ref

/datum/component/tacmap/proc/close_popout_tacmaps(mob/user)
	var/datum/tgui/maybe_ui = SStgui.get_open_ui(user, src)
	if(maybe_ui != null)
		maybe_ui.close()

/datum/component/tacmap/ui_close(mob/user)
	. = ..()

	if(!user.client)
		return

	user.client.clear_map(map_holder?.map?.assigned_map)
	user.client.using_popout_tacmap = FALSE

GLOBAL_LIST_INIT(tacmap_holders, list())

/datum/tacmap_holder
	var/map_ref
	var/atom/movable/screen/minimap/map
	var/owns_map = FALSE

/datum/tacmap_holder/New(loc, zlevel, flags, popup=TRUE, drawing, client/for_client, uncached=FALSE)
	map_ref = "tacmap_[REF(src)]_map"
	map = SSminimaps.fetch_minimap_object(zlevel, flags, live=TRUE, popup=popup, drawing=drawing, for_client=for_client, uncached=uncached)
	owns_map = !!for_client || uncached

	if(!map)
		return

	map.screen_loc = "[map_ref]:1,1"
	map.assigned_map = map_ref
	map.appearance_flags = NONE
	var/matrix/transform = matrix()
	transform.Translate(-32, 64)
	map.transform = transform

/datum/tacmap_holder/Destroy()
	if(owns_map)
		QDEL_NULL(map)
	else
		map = null
	return ..()
