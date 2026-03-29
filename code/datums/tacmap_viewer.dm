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

/datum/tacmap_viewer/ui_data(mob/user)
	var/list/data = list()

	var/list/factions = list()
	if(ishuman(user) && (user.faction == FACTION_MARINE || (FACTION_MARINE in user.faction_group)))
		factions += "USCM"

	if(isxeno(user))
		factions += "Hive"

	data["factions"] = factions

	var/uscm_length = length(GLOB.uscm_drawing_tacmap_data)
	if(uscm_length == 0)
		data["uscm_map"] = null
		data["uscm_svg"] = null
	else
		var/datum/flattened_tacmap/selected_flat = GLOB.uscm_flat_tacmap_data[uscm_length]
		var/datum/drawing_data/selected_draw_data = GLOB.uscm_drawing_tacmap_data[uscm_length]
		data["uscm_map"] = selected_flat ? selected_flat.flat_tacmap : null
		data["uscm_svg"] = selected_draw_data ? selected_draw_data.draw_data : null

	var/xeno_length = length(GLOB.xeno_drawing_tacmap_data)
	if(xeno_length == 0)
		data["xeno_map"] = null
		data["xeno_svg"] = null
	else
		var/datum/flattened_tacmap/selected_flat = GLOB.xeno_flat_tacmap_data[xeno_length]
		var/datum/drawing_data/selected_draw_data = GLOB.xeno_drawing_tacmap_data[xeno_length]
		data["xeno_map"] = selected_flat ? selected_flat.flat_tacmap : null
		data["xeno_svg"] = selected_draw_data ? selected_draw_data.draw_data : null

	data["map_fallback"] = wiki_map_fallback
	return data
