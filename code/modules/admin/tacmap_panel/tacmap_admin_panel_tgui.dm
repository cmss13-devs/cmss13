GLOBAL_DATUM_INIT(tacmap_admin_panel, /datum/tacmap_admin_panel, new)

#define LATEST_SELECTION -1

/datum/tacmap_admin_panel
	var/name = "Tacmap Panel"
	/// The index picked last for USCM (zero indexed), -1 will try to select latest if it exists
	var/uscm_selection = LATEST_SELECTION
	/// The index picked last for Xenos (zero indexed), -1 will try to select latest if it exists
	var/xeno_selection = LATEST_SELECTION
	/// A url that will point to the wiki map for the current map as a fall back image
	var/static/wiki_map_fallback
	/// The last time the map selection was changed - used as a key to trick react into updating the map
	var/last_update_time = 0

/datum/tacmap_admin_panel/tgui_interact(mob/user, datum/tgui/ui)
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

		ui = new(user, src, "TacmapAdminPanel", "Tacmap Panel")
		ui.open()

/datum/tacmap_admin_panel/ui_state(mob/user)
	return GLOB.admin_state

/datum/tacmap_admin_panel/ui_static_data(mob/user)
	. = list()
	.["ground_zs"] = SSmapping.levels_by_trait(ZTRAIT_GROUND)

/datum/tacmap_admin_panel/ui_data(mob/user)
	var/list/data = list()
	var/list/uscm_ckeys = list()
	var/list/xeno_ckeys = list()
	var/list/uscm_names = list()
	var/list/xeno_names = list()
	var/list/uscm_times = list()
	var/list/xeno_times = list()

	// Assumption: Length of flat_tacmap_data is the same as drawing_tacmap_data
	var/uscm_length = length(GLOB.uscm_drawing_tacmap_data)
	if(uscm_selection < 0 || uscm_selection >= uscm_length)
		uscm_selection = uscm_length - 1
	for(var/i = 1, i <= uscm_length, i++)
		var/list/datum/drawing_data/draw_data = GLOB.uscm_drawing_tacmap_data[i]
		if(!draw_data)
			uscm_ckeys += "DELETED"
			uscm_names += "DELETED"
			uscm_times += "DELETED"
		else
			for(var/current_z in draw_data)
				var/datum/drawing_data/current_drawing = draw_data[current_z]
				uscm_ckeys += current_drawing.ckey
				uscm_names += current_drawing.name
				uscm_times += current_drawing.time
				break
	data["uscm_ckeys"] = uscm_ckeys
	data["uscm_names"] = uscm_names
	data["uscm_times"] = uscm_times

	var/xeno_length = length(GLOB.xeno_drawing_tacmap_data)
	if(xeno_selection < 0 || xeno_selection >= xeno_length)
		xeno_selection = xeno_length - 1
	for(var/i = 1, i <= xeno_length, i++)
		var/list/datum/drawing_data/draw_data = GLOB.xeno_drawing_tacmap_data[i]
		if(!draw_data)
			xeno_ckeys += "DELETED"
			xeno_names += "DELETED"
			xeno_times += "DELETED"
		else
			for(var/current_z in draw_data)
				var/datum/drawing_data/current_drawing = draw_data[current_z]
				xeno_ckeys += current_drawing.ckey
				xeno_names += current_drawing.name
				xeno_times += current_drawing.time
				break
	data["xeno_ckeys"] = xeno_ckeys
	data["xeno_names"] = xeno_names
	data["xeno_times"] = xeno_times

	if(uscm_selection == LATEST_SELECTION || !GLOB.uscm_flat_tacmap_data[uscm_selection + 1])
		data["uscm_maps"] = null
		data["uscm_drawings"] = null
	else
		var/list/selected_flats = list()
		var/list/selected_drawings = list()
		var/list/datum/flattened_tacmap/selected_flat_data = GLOB.uscm_flat_tacmap_data[uscm_selection + 1]
		var/list/datum/drawing_data/selected_drawing_data = GLOB.uscm_drawing_tacmap_data[uscm_selection + 1]
		for(var/current_z in selected_flat_data)
			selected_flats += selected_flat_data[current_z].flat_tacmap
		for(var/current_z in selected_drawing_data)
			selected_drawings += selected_drawing_data[current_z].draw_data
		data["uscm_maps"] = selected_flats
		data["uscm_drawings"] = selected_drawings

	if(xeno_selection == LATEST_SELECTION || !GLOB.xeno_flat_tacmap_data[xeno_selection + 1])
		data["xeno_maps"] = null
		data["xeno_drawings"] = null
	else
		var/list/selected_flats = list()
		var/list/selected_drawings = list()
		var/list/datum/flattened_tacmap/selected_flat_data = GLOB.xeno_flat_tacmap_data[xeno_selection + 1]
		var/list/datum/drawing_data/selected_drawing_data = GLOB.xeno_drawing_tacmap_data[xeno_selection + 1]
		for(var/current_z in selected_flat_data)
			selected_flats += selected_flat_data[current_z].flat_tacmap
		for(var/current_z in selected_drawing_data)
			selected_drawings += selected_drawing_data[current_z].draw_data
		data["xeno_maps"] = selected_flats
		data["xeno_drawings"] = selected_drawings

	data["uscm_selection"] = uscm_selection
	data["xeno_selection"] = xeno_selection
	data["map_fallback"] = wiki_map_fallback
	data["last_update_time"] = last_update_time

	return data

/datum/tacmap_admin_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	var/client/client_user = user.client
	if(!client_user)
		return // Is this even possible?

	switch(action)
		if("recache")
			var/is_uscm = params["uscm"]
			var/list/datum/flattened_tacmap/selected_flat_data
			var/list/datum/drawing_data/selected_draw_data
			if(is_uscm)
				if(uscm_selection == LATEST_SELECTION)
					return TRUE
				selected_flat_data = GLOB.uscm_flat_tacmap_data[uscm_selection + 1]
				selected_draw_data = GLOB.uscm_drawing_tacmap_data[uscm_selection + 1]
			else
				if(xeno_selection == LATEST_SELECTION)
					return TRUE
				selected_flat_data = GLOB.xeno_flat_tacmap_data[xeno_selection + 1]
				selected_draw_data = GLOB.xeno_drawing_tacmap_data[xeno_selection + 1]

			if(!selected_flat_data || !selected_draw_data)
				to_chat(user, SPAN_WARNING("The selected tacmap couldn't be recached since it was deleted."))
				return

			for(var/current_z in selected_flat_data)
				SSassets.transport.send_assets(client_user, selected_flat_data[current_z].asset_key)
			for(var/current_z in selected_draw_data)
				SSassets.transport.send_assets(client_user, selected_draw_data[current_z].asset_key)
			last_update_time = world.time
			return TRUE

		if("change_selection")
			var/is_uscm = params["uscm"]
			if(is_uscm)
				uscm_selection = params["index"]
			else
				xeno_selection = params["index"]
			last_update_time = world.time
			return TRUE

		if("delete")
			var/is_uscm = params["uscm"]
			var/drawn_by
			var/ground_zs = SSmapping.levels_by_trait(ZTRAIT_GROUND)

			if(is_uscm)
				if(uscm_selection == LATEST_SELECTION)
					return TRUE
				// Clear overlays and labels from all minimaps and reset drawing images
				SSminimaps.clear_drawings_and_labels(ground_zs, MINIMAP_FLAG_USCM)
				// Figure out who drew it for logging
				var/list/datum/drawing_data/draw_data = GLOB.uscm_drawing_tacmap_data[uscm_selection + 1]
				for(var/current_z in draw_data)
					drawn_by = draw_data[current_z].ckey
					break
				// Null out the datums
				GLOB.uscm_drawing_tacmap_data[uscm_selection + 1] = null
				GLOB.uscm_flat_tacmap_data[uscm_selection + 1] = null
			else
				if(xeno_selection == LATEST_SELECTION)
					return TRUE
				// Clear overlays and labels from all minimaps and reset drawing images
				SSminimaps.clear_drawings_and_labels(ground_zs, MINIMAP_FLAG_XENO)
				// Figure out who drew it for logging
				var/list/datum/drawing_data/draw_data = GLOB.xeno_drawing_tacmap_data[xeno_selection + 1]
				for(var/current_z in draw_data)
					drawn_by = draw_data[current_z].ckey
					break
				// Null out the datums
				GLOB.xeno_drawing_tacmap_data[xeno_selection + 1] = null
				GLOB.xeno_flat_tacmap_data[xeno_selection + 1] = null

			last_update_time = world.time
			for(var/client/client as anything in GLOB.clients)
				var/mob/player = client.mob

				var/datum/tgui/client_ui = SStgui.get_open_ui(player, GLOB.tacmap_viewer)
				if(!client_ui)
					continue

				client_ui.refresh_cooldown = FALSE
				client_ui.send_update(force = TRUE)
			message_admins("[key_name_admin(usr)] deleted a <a href='byond://?tacmaps_panel=1'>tactical map drawing</a> drawn by [drawn_by].")
			return TRUE

/datum/tacmap_admin_panel/ui_close(mob/user)
	. = ..()
	uscm_selection = LATEST_SELECTION
	xeno_selection = LATEST_SELECTION

#undef LATEST_SELECTION
