GLOBAL_DATUM_INIT(tacmap_admin_panel, /datum/tacmap_admin_panel, new)

#define LATEST_SELECTION -1

/datum/tacmap_admin_panel
	var/name = "Tacmap Panel"
	/// The index picked last for USCM (zero indexed), -1 will try to select latest if it exists
	var/uscm_selection = LATEST_SELECTION
	/// The index picked last for Xenos (zero indexed), -1 will try to select latest if it exists
	var/xeno_selection = LATEST_SELECTION
	///The index picked last for UPP (zero indexed), -1 will try to select latest if it exists
	var/upp_selection = LATEST_SELECTION
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

		// Ensure we actually have the latest map images sent (recache can handle older/different faction maps)
		resend_current_map_png(user)

		ui = new(user, src, "TacmapAdminPanel", "Tacmap Panel")
		ui.open()

/datum/tacmap_admin_panel/ui_state(mob/user)
	return GLOB.admin_state

/datum/tacmap_admin_panel/ui_data(mob/user)
	var/list/data = list()
	var/list/uscm_ckeys = list()
	var/list/xeno_ckeys = list()
	var/list/upp_ckeys = list()
	var/list/uscm_names = list()
	var/list/xeno_names = list()
	var/list/upp_names = list()
	var/list/uscm_times = list()
	var/list/xeno_times = list()
	var/list/upp_times = list()

	// Assumption: Length of flat_tacmap_data is the same as svg_tacmap_data
	var/uscm_length = length(GLOB.uscm_svg_tacmap_data)
	if(uscm_selection < 0 || uscm_selection >= uscm_length)
		uscm_selection = uscm_length - 1
	for(var/i = 1, i <= uscm_length, i++)
		var/datum/svg_overlay/current_svg = GLOB.uscm_svg_tacmap_data[i]
		uscm_ckeys += current_svg.ckey
		uscm_names += current_svg.name
		uscm_times += current_svg.time
	data["uscm_ckeys"] = uscm_ckeys
	data["uscm_names"] = uscm_names
	data["uscm_times"] = uscm_times

	var/xeno_length = length(GLOB.xeno_svg_tacmap_data)
	if(xeno_selection < 0 || xeno_selection >= xeno_length)
		xeno_selection = xeno_length - 1
	for(var/i = 1, i <= xeno_length, i++)
		var/datum/svg_overlay/current_svg = GLOB.xeno_svg_tacmap_data[i]
		xeno_ckeys += current_svg.ckey
		xeno_names += current_svg.name
		xeno_times += current_svg.time
	data["xeno_ckeys"] = xeno_ckeys
	data["xeno_names"] = xeno_names
	data["xeno_times"] = xeno_times

	var/upp_length = length(GLOB.upp_svg_tacmap_data)
	if(upp_selection < 0 || upp_selection >= upp_length)
		upp_selection = upp_length - 1
	for(var/i = 1, i <= upp_length, i++)
		var/datum/svg_overlay/current_svg = GLOB.upp_svg_tacmap_data[i]
		upp_ckeys += current_svg.ckey
		upp_names += current_svg.name
		upp_times += current_svg.time
	data["upp_ckeys"] = upp_ckeys
	data["upp_names"] = upp_names
	data["upp_times"] = upp_times

	if(uscm_selection == LATEST_SELECTION)
		data["uscm_map"] = null
		data["uscm_svg"] = null
	else
		var/datum/flattened_tacmap/selected_flat = GLOB.uscm_flat_tacmap_data[uscm_selection + 1]
		var/datum/svg_overlay/selected_svg = GLOB.uscm_svg_tacmap_data[uscm_selection + 1]
		data["uscm_map"] = selected_flat.flat_tacmap
		data["uscm_svg"] = selected_svg.svg_data

	if(xeno_selection == LATEST_SELECTION)
		data["xeno_map"] = null
		data["xeno_svg"] = null
	else
		var/datum/flattened_tacmap/selected_flat = GLOB.xeno_flat_tacmap_data[xeno_selection + 1]
		var/datum/svg_overlay/selected_svg = GLOB.xeno_svg_tacmap_data[xeno_selection + 1]
		data["xeno_map"] = selected_flat.flat_tacmap
		data["xeno_svg"] = selected_svg.svg_data

	if(upp_selection == LATEST_SELECTION)
		data["upp_map"] = null
		data["upp_svg"] = null
	else
		var/datum/flattened_tacmap/selected_flat = GLOB.upp_flat_tacmap_data[upp_selection + 1]
		var/datum/svg_overlay/selected_svg = GLOB.upp_svg_tacmap_data[upp_selection + 1]
		data["upp_map"] = selected_flat.flat_tacmap
		data["upp_svg"] = selected_svg.svg_data

	data["uscm_selection"] = uscm_selection
	data["xeno_selection"] = xeno_selection
	data["upp_selection"] = upp_selection
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
			var/page = params["page"]
			var/datum/flattened_tacmap/selected_flat
			switch(page)
				if(0)
					if(uscm_selection == LATEST_SELECTION)
						return TRUE
					selected_flat = GLOB.uscm_flat_tacmap_data[uscm_selection + 1]
				if(1)
					if(xeno_selection == LATEST_SELECTION)
						return TRUE
					selected_flat = GLOB.xeno_flat_tacmap_data[xeno_selection + 1]
				if(2)
					if(upp_selection == LATEST_SELECTION)
						return TRUE
					selected_flat = GLOB.upp_flat_tacmap_data[upp_selection + 1]
			SSassets.transport.send_assets(client_user, selected_flat.asset_key)
			last_update_time = world.time
			return TRUE

		if("change_selection")
			var/page = params["page"]
			switch(page)
				if(0)
					uscm_selection = params["index"]
				if(1)
					xeno_selection = params["index"]
				if(2)
					upp_selection = params["index"]
			last_update_time = world.time
			return TRUE

		if("delete")
			var/page = params["page"]
			var/datum/svg_overlay/selected_svg
			switch(page)
				if(0)
					if(uscm_selection == LATEST_SELECTION)
						return TRUE
					selected_svg = GLOB.uscm_svg_tacmap_data[uscm_selection + 1]
				if(1)
					if(xeno_selection == LATEST_SELECTION)
						return TRUE
					selected_svg = GLOB.xeno_svg_tacmap_data[xeno_selection + 1]
				if(2)
					if(upp_selection == LATEST_SELECTION)
						return TRUE
					selected_svg = GLOB.upp_svg_tacmap_data[upp_selection + 1]
			selected_svg.svg_data = null
			last_update_time = world.time
			message_admins("[key_name_admin(usr)] deleted the <a href='?tacmaps_panel=1'>tactical map drawing</a> by [selected_svg.ckey].")
			return TRUE

/datum/tacmap_admin_panel/ui_close(mob/user)
	. = ..()
	uscm_selection = LATEST_SELECTION
	xeno_selection = LATEST_SELECTION

#undef LATEST_SELECTION
