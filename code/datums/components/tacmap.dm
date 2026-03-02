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
	/// List of references to the tools we will be using to shape what the map looks like
	var/list/atom/movable/screen/drawing_tools = list()
	var/list/atom/movable/screen/minimap_tool/drawing_actions = list()
	var/minimap_flag = MINIMAP_FLAG_USCM
	///by default Zlevel 2, groundside is targetted
	var/targetted_zlevel = 2
	///minimap obj ref that we will display to users
	var/atom/movable/screen/minimap/map
	///List of currently interacting mobs
	var/list/mob/interactees = list()
	///Button for closing map
	var/close_button
	///Map holder
	var/datum/tacmap_holder/map_holder
	///Is drawing enabled
	var/drawing


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
			/atom/movable/screen/minimap_tool/up,
			/atom/movable/screen/minimap_tool/down,
			/atom/movable/screen/minimap_tool/popout,
		)

	if(has_update)
		drawing_tools += /atom/movable/screen/minimap_tool/update

/datum/component/tacmap/proc/move_tacmap_up()
	targetted_zlevel++
	var/list/_interactees = interactees.Copy()
	for(var/mob/interactee in _interactees)
		on_unset_interaction(interactee)
		close_popout_tacmaps(interactee)
	map = null
	for(var/mob/interactee in _interactees)
		show_tacmap(interactee)
		tgui_interact(interactee)

/datum/component/tacmap/proc/move_tacmap_down()
	targetted_zlevel--
	var/list/_interactees = interactees.Copy()
	for(var/mob/interactee in _interactees)
		on_unset_interaction(interactee)
		close_popout_tacmaps(interactee)
	map = null
	for(var/mob/interactee in _interactees)
		show_tacmap(interactee)
		tgui_interact(interactee)

/datum/component/tacmap/proc/popout(mob/user)
	var/datum/tgui/maybe_ui = SStgui.get_open_ui(user, src)
	if (maybe_ui == null)
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
		user.client.remove_from_screen(user_objects["drawing_actions"])
		user.client.remove_from_screen(user_objects["close_button"])

		// Clean up drawing tool references
		var/atom/movable/screen/minimap/user_map = user_objects["map"]
		user_map?.active_draw_tool = null

	interactees -= user
	user.client.mouse_pointer_icon = null
	user.client.active_draw_tool = null
	winset(user, "drawingtools", "reset=true")
	user.client.using_main_tacmap = FALSE

/datum/component/tacmap/proc/show_tacmap(mob/user)
	if (user.client.using_tacmap())
		to_chat(user.client, SPAN_WARNING("You're already using a tacmap. Close it to open another one."))
		return

	if(!map_holder)
		map_holder = new(null, targetted_zlevel, minimap_flag, drawing=drawing)

	// Create per client minimap and tools for ceiling protection isolation
	var/atom/movable/screen/minimap/user_map = SSminimaps.fetch_minimap_object(targetted_zlevel, minimap_flag, live=TRUE, popup=FALSE, drawing=drawing, for_client=user.client)
	var/atom/movable/screen/exit_map/user_close_button = new(null, src)

	var/list/atom/movable/screen/user_drawing_actions = list()
	for(var/path in drawing_tools)
		user_drawing_actions += new path(null, targetted_zlevel, minimap_flag, user_map, src)

	user.client.add_to_screen(user_drawing_actions)
	user.client.add_to_screen(user_close_button)
	user.client.add_to_screen(user_map)

	// Apply ceiling protection overlay if client has preference enabled
	if(user.client.prefs?.show_minimap_ceiling_protection)
		user_map.update_ceiling_overlay(user.client)

	// Store references for cleanup
	if(!interactees[user])
		interactees[user] = list("map" = user_map, "close_button" = user_close_button, "drawing_actions" = user_drawing_actions)

	user.client.using_main_tacmap = TRUE

/datum/component/tacmap/ui_status(mob/user, datum/ui_state/state)
	if(get_dist(parent, user) > 1)
		return UI_CLOSE

	return UI_INTERACTIVE

/datum/component/tacmap/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)

	// try_update_ui returns NULL as the UI even if the UI is trying to close from ui_status.
	// Double check that we aren't attempting to close so that we don't make a UI when we don't need to.
	if(ui || get_dist(parent, user) > 1)
		return

	user.client.register_map_obj(map_holder.map)
	ui = new(user, src, "TacticalMap")
	ui.open()
	user.client.using_popout_tacmap = TRUE

/datum/component/tacmap/ui_data(mob/user)
	. = ..()

	if (map_holder != null)
		.["mapRef"] = map_holder.map_ref

	.["isXeno"] = isxeno(user)
	.["canChangeZ"] = FALSE

/datum/component/tacmap/proc/close_popout_tacmaps(mob/user)
	var/datum/tgui/maybe_ui = SStgui.get_open_ui(user, src)
	if (maybe_ui != null)
		maybe_ui.close()

/datum/component/tacmap/ui_close(mob/user)
	. = ..()

	if(!user.client)
		return

	user.client.remove_from_screen(map_holder.map)
	user.client.using_popout_tacmap = FALSE

GLOBAL_LIST_INIT(tacmap_holders, list())

/datum/tacmap_holder
	var/map_ref
	var/atom/movable/screen/minimap/map

/datum/tacmap_holder/New(loc, zlevel, flags, drawing)
	map_ref = "tacmap_[REF(src)]_map"
	map = SSminimaps.fetch_minimap_object(zlevel, flags, live=TRUE, popup=TRUE, drawing=drawing)

	map.screen_loc = "[map_ref]:1,1"
	map.assigned_map = map_ref
	map.appearance_flags = NONE
	var/matrix/transform = matrix()
	transform.Translate(-32, 64)
	map.transform = transform

/datum/tacmap_holder/Destroy()
	map = null
	return ..()
