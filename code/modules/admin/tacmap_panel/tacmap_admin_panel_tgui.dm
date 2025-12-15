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

/datum/tacmap_admin_panel/ui_data(mob/user)
	var/list/data = list()
	var/list/uscm_ckeys = list()
	var/list/xeno_ckeys = list()
	var/list/uscm_names = list()
	var/list/xeno_names = list()
	var/list/uscm_times = list()
	var/list/xeno_times = list()

	// Assumption: Length of flat_tacmap_data is the same as svg_tacmap_data
	var/uscm_length = length(GLOB.uscm_drawing_tacmap_data)
	if(uscm_selection < 0 || uscm_selection >= uscm_length)
		uscm_selection = uscm_length - 1
	for(var/i = 1, i <= uscm_length, i++)
		var/datum/drawing_data/current_draw_data = GLOB.uscm_drawing_tacmap_data[i]
		if(!current_draw_data)
			uscm_ckeys += "DELETED"
			uscm_names += "DELETED"
			uscm_times += "DELETED"
		else
			uscm_ckeys += current_draw_data.ckey
			uscm_names += current_draw_data.name
			uscm_times += current_draw_data.time
	data["uscm_ckeys"] = uscm_ckeys
	data["uscm_names"] = uscm_names
	data["uscm_times"] = uscm_times

	var/xeno_length = length(GLOB.xeno_drawing_tacmap_data)
	if(xeno_selection < 0 || xeno_selection >= xeno_length)
		xeno_selection = xeno_length - 1
	for(var/i = 1, i <= xeno_length, i++)
		var/datum/drawing_data/current_draw_data = GLOB.xeno_drawing_tacmap_data[i]
		if(!current_draw_data)
			xeno_ckeys += "DELETED"
			xeno_names += "DELETED"
			xeno_times += "DELETED"
		else
			xeno_ckeys += current_draw_data.ckey
			xeno_names += current_draw_data.name
			xeno_times += current_draw_data.time
	data["xeno_ckeys"] = xeno_ckeys
	data["xeno_names"] = xeno_names
	data["xeno_times"] = xeno_times

	if(uscm_selection == LATEST_SELECTION)
		data["uscm_map"] = null
		data["uscm_svg"] = null
	else
		var/datum/flattened_tacmap/selected_flat = GLOB.uscm_flat_tacmap_data[uscm_selection + 1]
		var/datum/drawing_data/selected_draw_data = GLOB.uscm_drawing_tacmap_data[uscm_selection + 1]
		data["uscm_map"] = selected_flat ? selected_flat.flat_tacmap : null
		data["uscm_svg"] = selected_draw_data ? selected_draw_data.draw_data : null

	if(xeno_selection == LATEST_SELECTION)
		data["xeno_map"] = null
		data["xeno_svg"] = null
	else
		var/datum/flattened_tacmap/selected_flat = GLOB.xeno_flat_tacmap_data[xeno_selection + 1]
		var/datum/drawing_data/selected_draw_data = GLOB.xeno_drawing_tacmap_data[xeno_selection + 1]
		data["xeno_map"] = selected_flat ? selected_flat.flat_tacmap : null
		data["xeno_svg"] = selected_draw_data ? selected_draw_data.draw_data : null

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
			var/datum/flattened_tacmap/selected_flat
			var/datum/drawing_data/selected_draw_data
			if(is_uscm)
				if(uscm_selection == LATEST_SELECTION)
					return TRUE
				selected_flat = GLOB.uscm_flat_tacmap_data[uscm_selection + 1]
				selected_draw_data = GLOB.uscm_drawing_tacmap_data[uscm_selection + 1]
			else
				if(xeno_selection == LATEST_SELECTION)
					return TRUE
				selected_flat = GLOB.xeno_flat_tacmap_data[xeno_selection + 1]
				selected_draw_data = GLOB.xeno_drawing_tacmap_data[xeno_selection + 1]

			if(!selected_flat || !selected_draw_data)
				to_chat(user, SPAN_WARNING("The selected tacmap couldn't be recached since it was deleted."))
				return

			SSassets.transport.send_assets(client_user, selected_draw_data.asset_key)
			SSassets.transport.send_assets(client_user, selected_flat.asset_key)
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
			var/image/selected_drawing_image
			var/atom/movable/screen/minimap/selected_minimap
			var/drawn_by

			if(is_uscm)
				if(uscm_selection == LATEST_SELECTION)
					return TRUE
				selected_drawing_image = SSminimaps.get_drawing_image(2, MINIMAP_FLAG_USCM, TRUE)
				selected_minimap = SSminimaps.fetch_minimap_object(2, MINIMAP_FLAG_USCM, FALSE)
				selected_minimap.update()
				selected_minimap = SSminimaps.fetch_minimap_object(2, MINIMAP_FLAG_USCM, TRUE)
				for(var/turf/label as anything in selected_minimap.labelled_turfs)
					SSminimaps.remove_marker(label)
				var/datum/drawing_data/draw_data = GLOB.uscm_drawing_tacmap_data[uscm_selection + 1]
				drawn_by = draw_data.ckey
				GLOB.uscm_drawing_tacmap_data[uscm_selection + 1] = null
				GLOB.uscm_flat_tacmap_data[uscm_selection + 1] = null
			else
				if(xeno_selection == LATEST_SELECTION)
					return TRUE
				selected_minimap = SSminimaps.fetch_minimap_object(2, MINIMAP_FLAG_XENO, TRUE)
				for(var/turf/label as anything in selected_minimap.labelled_turfs)
					SSminimaps.remove_marker(label)
				selected_drawing_image = SSminimaps.get_drawing_image(2, MINIMAP_FLAG_XENO, TRUE)
				var/datum/drawing_data/draw_data = GLOB.xeno_drawing_tacmap_data[xeno_selection + 1]
				drawn_by = draw_data.ckey
				GLOB.xeno_drawing_tacmap_data[xeno_selection + 1] = null
				GLOB.xeno_flat_tacmap_data[xeno_selection + 1] = null

			selected_drawing_image.icon = icon('icons/ui_icons/minimap.dmi')
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
