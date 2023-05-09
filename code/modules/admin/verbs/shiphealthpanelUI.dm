GLOBAL_DATUM_INIT(ship_health_panel_UI, /datum/shiphealthpanelUI, new)

/datum/shiphealthpanelUI/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "shiphealthpanelUI")
		ui.open()

/datum/shiphealthpanelUI/ui_data(mob/user)
	var/list/data = list()
	data["missile"] = GLOB.ship_hits_tally["times_hit_missile"]
	data["railgun"] = GLOB.ship_hits_tally["times_hit_railgun"]
	data["odc"] = GLOB.ship_hits_tally["times_hit_odc"]
	data["aaboiler"] = GLOB.ship_hits_tally["times_hit_aaboiler"]
	data["hull"] = GLOB.ship_health_vars["ship_hull_health"]
	data["systems"] = GLOB.ship_health_vars["ship_systems_health"]
	return data

/datum/shiphealthpanelUI/ui_state(mob/user)
	return GLOB.always_state
