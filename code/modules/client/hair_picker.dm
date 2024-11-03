/datum/hair_picker/ui_static_data(mob/user)
	. = ..()

	.["icon"] = /datum/sprite_accessory/hair::icon

	.["hair_styles"] = list()
	for(var/key in GLOB.hair_styles_list)
		var/datum/sprite_accessory/hair/hair = GLOB.hair_styles_list[key]
		.["hair_styles"] += list(
			list("name" = hair.name, "icon" = hair.icon_state)
		)

/datum/hair_picker/ui_data(mob/user)
	. = ..()

	var/datum/preferences/prefs = user.client.prefs

	.["hair_style"] = GLOB.hair_styles_list[prefs.h_style].icon_name
	.["hair_color"] = "#[num2hex(prefs.r_hair, 2)][num2hex(prefs.g_hair, 2)][num2hex(prefs.b_hair)]"

/datum/hair_picker/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	var/datum/preferences/prefs = ui.user.client.prefs

	switch(action)
		if("hair")
			if(!GLOB.hair_styles_list[params["name"]])
				return

			prefs.h_style = params["name"]

	prefs.ShowChoices(ui.user)
	return TRUE

/datum/hair_picker/tgui_interact(mob/user, datum/tgui/ui)
	. = ..()

	ui = SStgui.try_update_ui(user, src, ui)

	if(!ui)
		ui = new(user, src, "HairPicker", "Hair Picker")
		ui.open()
		ui.set_autoupdate(FALSE)

	winset(user, ui.window.id, "focus=true")

/datum/hair_picker/ui_state(mob/user)
	return GLOB.always_state
