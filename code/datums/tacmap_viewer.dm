GLOBAL_DATUM_INIT(tacmap_viewer, /datum/tacmap_viewer, new)

/datum/tacmap_viewer
	var/name = "Tacmap Viewer"
	/// A url that will point to the wiki map for the current map as a fall back image
	var/static/wiki_map_fallback

/datum/tacmap_viewer/tgui_interact(mob/user, datum/tgui/ui)
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

		ui = new(user, src, "TacmapViewer", "Tacmap Viewer")
		ui.open()

/datum/tacmap_viewer/ui_state(mob/user)
	if(isliving(user))
		return GLOB.conscious_state
	else
		return GLOB.observer_state

/datum/tacmap_viewer/ui_static_data(mob/user)
	. = list()
	.["ground_zs"] = SSmapping.levels_by_trait(ZTRAIT_GROUND)

/datum/tacmap_viewer/ui_data(mob/user)
	var/list/data = list()

	var/list/factions = list()
	if(ishuman(user) && (user.faction == FACTION_MARINE || (FACTION_MARINE in user.faction_group)))
		factions += "USCM"

	if(isxeno(user))
		factions += "Hive"

	data["factions"] = factions

	// Assumption: Length of flat_tacmap_data is the same as drawing_tacmap_data
	data["uscm_maps"] = null
	data["uscm_drawings"] = null
	var/uscm_length = length(GLOB.uscm_drawing_tacmap_data)
	if(uscm_length != 0)
		// Find the first non-null (in case of deletion)
		for(var/i = uscm_length, i > 0, i--)
			var/list/datum/flattened_tacmap/selected_flat_data = GLOB.uscm_flat_tacmap_data[i]
			var/list/datum/drawing_data/selected_drawing_data = GLOB.uscm_drawing_tacmap_data[i]
			if(!selected_flat_data || !selected_drawing_data)
				continue
			var/list/selected_flats = list()
			var/list/selected_drawings = list()
			for(var/current_z in selected_flat_data)
				selected_flats += selected_flat_data[current_z].flat_tacmap
			for(var/current_z in selected_drawing_data)
				selected_drawings += selected_drawing_data[current_z].draw_data
			data["uscm_maps"] = selected_flats
			data["uscm_drawings"] = selected_drawings
			break

	data["xeno_maps"] = null
	data["xeno_drawings"] = null
	var/xeno_length = length(GLOB.xeno_drawing_tacmap_data)
	if(xeno_length != 0)
		// Find the first non-null (in case of deletion)
		for(var/i = xeno_length, i > 0, i--)
			var/list/datum/flattened_tacmap/selected_flat_data = GLOB.xeno_flat_tacmap_data[i]
			var/list/datum/drawing_data/selected_drawing_data = GLOB.xeno_drawing_tacmap_data[i]
			if(!selected_flat_data || !selected_drawing_data)
				continue
			var/list/selected_flats = list()
			var/list/selected_drawings = list()
			for(var/current_z in selected_flat_data)
				selected_flats += selected_flat_data[current_z].flat_tacmap
			for(var/current_z in selected_drawing_data)
				selected_drawings += selected_drawing_data[current_z].draw_data
			data["xeno_maps"] = selected_flats
			data["xeno_drawings"] = selected_drawings
			break

	data["map_fallback"] = wiki_map_fallback
	return data
