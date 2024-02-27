/client/proc/load_event_level()
	set category = "Admin.Events"
	set name = "Map Template - New Z"
	set desc = "Load a Map Template as a new event Z-Level"

	var/datum/map_template/template
	var/client/C = usr.client
	var/logckey = C.ckey

	var/map_choice = tgui_input_list(C, "Choose a Map Template to load into a new Z-Level", "Load Level Template", sortList(SSmapping.map_templates))
	if(!map_choice)
		return
	template = SSmapping.map_templates[map_choice]
	if(!template)
		return

	// Preload so we can get map information
	var/list/boundaries
	if(template.cached_map)
		boundaries = template.cached_map.bounds
	else
		boundaries = template.preload_size(template.mappath)

	// Get dims & guesstimate center turf (in practice, current implem means min is always 1)
	var/dim_x  = boundaries[MAP_MAXX] - boundaries[MAP_MINX] + 1
	var/dim_y  = boundaries[MAP_MAXY] - boundaries[MAP_MINY] + 1

	var/prompt = alert(C, "Are you SURE you want to load this template as level ? This is SLOW and can freeze server for a bit. Dimensions are: [dim_x] x [dim_y]", "Template Confirm" ,"Yes","Nope!")
	if(prompt != "Yes")
		return

	// Extra debug in case of in-load crashes
	log_debug("Attempting load of template [template.name] as new event Z-Level as requested by [logckey]")

	var/datum/space_level/loaded = template.load_new_z()
	if(!loaded?.z_value)
		if(C)
			to_chat(C, "Failed to load the template to a Z-Level! Sorry!")
		return

	var/center_x = round(loaded.bounds[MAP_MAXX] / 2) // Technically off by 0.5 due to above +1. Whatever
	var/center_y = round(loaded.bounds[MAP_MAXY] / 2)

	// Now notify the staff of the load - this goes in addition to the generic template load game log
	message_admins("Successfully loaded template as new Z-Level by ckey: [logckey], template name: [template.name]", center_x, center_y, loaded.z_value)
	if(isobserver(C?.mob))
		var/turf/T = locate(center_x, center_y, loaded.z_value)
		if(T) // ???? surely that'd never happen
			C.mob.forceMove(T)
