/**
	Tacmap component

	Adds a tacmap with defined z level and flags to an object and allows it to open and close it
 */
/datum/component/tacmap
	/// List of references to the tools we will be using to shape what the map looks like
	var/list/atom/movable/screen/drawing_tools = list(
		/atom/movable/screen/minimap_tool/draw_tool/red,
		/atom/movable/screen/minimap_tool/draw_tool/yellow,
		/atom/movable/screen/minimap_tool/draw_tool/purple,
		/atom/movable/screen/minimap_tool/draw_tool/blue,
		/atom/movable/screen/minimap_tool/draw_tool/erase,
		/atom/movable/screen/minimap_tool/label,
		/atom/movable/screen/minimap_tool/clear,
		/atom/movable/screen/minimap_tool/up,
		/atom/movable/screen/minimap_tool/down
	)
	var/list/atom/movable/screen/minimap_tool/drawing_actions = list()
	var/minimap_flag = MINIMAP_FLAG_USCM
	///by default Zlevel 2, groundside is targetted
	var/targetted_zlevel = 2
	///minimap obj ref that we will display to users
	var/atom/movable/screen/minimap/map
	///List of currently interacting mobs
	var/list/mob/interactees = list()
	///Toggle for scrolling map
	var/scroll_toggle
	///Button for closing map
	var/close_button
	///Does this tacmap have drawing tools
	var/has_drawing_tools


/datum/component/tacmap/Initialize(has_drawing_tools, minimap_flag, has_update)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	
	src.has_drawing_tools = has_drawing_tools
	src.minimap_flag = minimap_flag
	
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

/datum/component/tacmap/proc/on_unset_interaction(mob/user)
	interactees -= user
	user?.client?.screen -= map
	user?.client?.screen -= scroll_toggle
	
	if(has_drawing_tools)
		user?.client?.screen -= drawing_actions
		user?.client?.screen -= close_button
		user?.client?.mouse_pointer_icon = null

/datum/component/tacmap/proc/show_tacmap(mob/user)
	if(!map)
		map = SSminimaps.fetch_minimap_object(targetted_zlevel, minimap_flag, TRUE)
		scroll_toggle = new /atom/movable/screen/stop_scroll(null, map)
		close_button = new /atom/movable/screen/exit_map(null, src)
		var/list/atom/movable/screen/actions = list()
		for(var/path in drawing_tools)
			actions += new path(null, targetted_zlevel, minimap_flag, map, src)
		drawing_actions = actions

	if(has_drawing_tools)
		user.client.screen += drawing_actions
		user.client.screen += close_button

	user.client.screen += scroll_toggle
	user.client.screen += map
	interactees += user

