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
			/atom/movable/screen/minimap_tool/down
		)

	if(has_update)
		drawing_tools += /atom/movable/screen/minimap_tool/update

/datum/component/tacmap/proc/move_tacmap_up()
	targetted_zlevel++
	var/list/_interactees = interactees.Copy()
	for(var/mob/interactee in _interactees)
		on_unset_interaction(interactee)
	map = null
	for(var/mob/interactee in _interactees)
		show_tacmap(interactee)

/datum/component/tacmap/proc/move_tacmap_down()
	targetted_zlevel--
	var/list/_interactees = interactees.Copy()
	for(var/mob/interactee in _interactees)
		on_unset_interaction(interactee)
	map = null
	for(var/mob/interactee in _interactees)
		show_tacmap(interactee)

/datum/component/tacmap/proc/popout()
	tgui_interact(usr)

/datum/component/tacmap/proc/on_unset_interaction(mob/user)
	interactees -= user

	if(!user.client)
		return

	user.client.remove_from_screen(map)
	user.client.remove_from_screen(drawing_actions)
	user.client.remove_from_screen(close_button)
	user.client.mouse_pointer_icon = null
	user.client.active_draw_tool = null
	map.active_draw_tool = null
	winset(user, "drawingtools", "reset=true")

/datum/component/tacmap/proc/show_tacmap(mob/user)
	if(!map)
		map = SSminimaps.fetch_minimap_object(targetted_zlevel, minimap_flag, TRUE, drawing=drawing)
		map_holder = new(null, targetted_zlevel, minimap_flag, drawing=drawing)
		close_button = new /atom/movable/screen/exit_map(null, src)
		var/list/atom/movable/screen/actions = list()
		for(var/path in drawing_tools)
			actions += new path(null, targetted_zlevel, minimap_flag, map, src)
		drawing_actions = actions


	user.client.add_to_screen(drawing_actions)
	user.client.add_to_screen(close_button)
	user.client.add_to_screen(map)
	interactees += user


/datum/component/tacmap/ui_status(mob/user, datum/ui_state/state)
	if(get_dist(parent, user) > 1)
		ui_close(user)
		return UI_CLOSE

	return UI_INTERACTIVE

/datum/component/tacmap/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		user.client.register_map_obj(map_holder.map)
		ui = new(user, src, "TacticalMap")
		ui.open()

/datum/component/tacmap/ui_data(mob/user)
	. = ..()

	.["mapRef"] = map_holder?.map_ref

/datum/component/tacmap/ui_close(mob/user)
	. = ..()

	if(!user.client)
		return

	user.client.remove_from_screen(map_holder.map)

GLOBAL_LIST_INIT(tacmap_holders, list())

/datum/tacmap_holder
	var/map_ref
	var/atom/movable/screen/minimap/map

/datum/tacmap_holder/New(loc, zlevel, flags, drawing)
	map_ref = "tacmap_[REF(src)]_map"
	map = SSminimaps.fetch_minimap_object(zlevel, flags, TRUE, TRUE, TRUE, drawing=drawing)
	map.screen_loc = "[map_ref]:1,1"
	var/matrix/transform = matrix()
	transform.Translate(-32, 64)
	map.transform = transform
	map.assigned_map = map_ref
	map.appearance_flags = NONE

/datum/tacmap_holder/Destroy()
	map = null
	return ..()
