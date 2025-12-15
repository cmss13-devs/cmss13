/datum/flavor_text_editor/ui_data(mob/user)
	. = ..()

	var/datum/preferences/prefs = user.client?.prefs
	if(!prefs)
		return

	.["categories"] = list()

	for (var/category in prefs.flavor_texts)
		.["categories"] += category
		.[category] = prefs.flavor_texts[category]

/datum/flavor_text_editor/tgui_interact(mob/user, datum/tgui/ui)
	. = ..()

	ui = SStgui.try_update_ui(user, src, ui)

	if(!ui)
		ui = new(user, src, "FlavorTextEditor", "Flavor Text Editor")
		ui.open()
		ui.set_autoupdate(FALSE)

	winset(user, ui.window.id, "focus=true")

/datum/flavor_text_editor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	var/datum/preferences/prefs = ui.user.client?.prefs
	if(!prefs)
		return

	switch(action)
		if("set_flavor_text")
			if(!params["category"])
				return
			prefs.flavor_texts[params["category"]] = params["text"]
			return TRUE

	return TRUE


/datum/flavor_text_editor/ui_state(mob/user)
	return GLOB.always_state
