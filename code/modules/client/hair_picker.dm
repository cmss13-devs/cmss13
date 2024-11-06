/datum/hair_picker/ui_static_data(mob/user)
	. = ..()

	.["hair_icon"] = /datum/sprite_accessory/hair::icon
	.["facial_hair_icon"] = /datum/sprite_accessory/facial_hair::icon


/datum/hair_picker/ui_data(mob/user)
	. = ..()

	var/datum/preferences/prefs = user.client.prefs

	.["hair_style"] = GLOB.hair_styles_list[prefs.h_style].icon_state
	.["hair_color"] = rgb(prefs.r_hair, prefs.g_hair, prefs.b_hair)

	.["hair_styles"] = list()
	for(var/key in GLOB.hair_styles_list)
		var/datum/sprite_accessory/hair/hair = GLOB.hair_styles_list[key]
		if(!hair.selectable)
			continue
		if(!(prefs.species in hair.species_allowed))
			continue

		.["hair_styles"] += list(
			list("name" = hair.name, "icon" = hair.icon_state)
		)

	.["facial_hair_style"] = GLOB.facial_hair_styles_list[prefs.f_style].icon_state
	.["facial_hair_color"] = rgb(prefs.r_facial, prefs.g_facial, prefs.b_facial)

	.["facial_hair_styles"] = list()
	for(var/key in GLOB.facial_hair_styles_list)
		var/datum/sprite_accessory/facial_hair/facial_hair = GLOB.facial_hair_styles_list[key]
		if(!facial_hair.selectable)
			continue
		if(!(prefs.species in facial_hair.species_allowed))
			continue
		if(facial_hair.gender != NEUTER && prefs.gender != facial_hair.gender)
			continue

		.["facial_hair_styles"] += list(
			list("name" = facial_hair.name, "icon" = facial_hair.icon_state)
		)

	.["gradient_available"] = !!(/datum/character_trait/hair_dye in prefs.traits)
	.["gradient_style"] = prefs.grad_style
	.["gradient_color"] = rgb(prefs.r_gradient, prefs.g_gradient, prefs.b_gradient)

	.["gradient_styles"] = list()
	for(var/key in GLOB.hair_gradient_list)
		var/datum/sprite_accessory/hair_gradient/gradient = GLOB.hair_gradient_list[key]
		if(!gradient.selectable)
			continue
		if(!(prefs.species in gradient.species_allowed))
			continue

		.["gradient_styles"] += gradient.name

/datum/hair_picker/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	var/datum/preferences/prefs = ui.user.client.prefs

	switch(action)
		if("hair")
			var/datum/sprite_accessory/hair/hair = GLOB.hair_styles_list[params["name"]]
			if(!hair)
				return

			if(!hair.selectable)
				return

			if(!(prefs.species in hair.species_allowed))
				return

			prefs.h_style = params["name"]

		if("hair_color")
			var/param_color = params["color"]
			if(!param_color)
				return

			var/r = hex2num(copytext(param_color, 2, 4))
			var/g = hex2num(copytext(param_color, 4, 6))
			var/b = hex2num(copytext(param_color, 6, 8))

			if(!isnum(r) || !isnum(g) || !isnum(b))
				return

			prefs.r_hair = clamp(r, 0, 255)
			prefs.g_hair = clamp(g, 0, 255)
			prefs.b_hair = clamp(b, 0, 255)

		if("facial_hair")
			var/datum/sprite_accessory/facial_hair/facial_hair = GLOB.facial_hair_styles_list[params["name"]]
			if(!facial_hair)
				return

			if(!facial_hair.selectable)
				return

			if(!(prefs.species in facial_hair.species_allowed))
				return

			if(facial_hair.gender != NEUTER && prefs.gender != facial_hair.gender)
				return

			prefs.f_style = params["name"]

		if("facial_hair_color")
			var/param_color = params["color"]
			if(!param_color)
				return

			var/r = hex2num(copytext(param_color, 2, 4))
			var/g = hex2num(copytext(param_color, 4, 6))
			var/b = hex2num(copytext(param_color, 6, 8))

			if(!isnum(r) || !isnum(g) || !isnum(b))
				return

			prefs.r_facial = clamp(r, 0, 255)
			prefs.g_facial = clamp(g, 0, 255)
			prefs.b_facial = clamp(b, 0, 255)

		if("gradient")
			var/datum/sprite_accessory/hair_gradient/gradient = GLOB.hair_gradient_list[params["name"]]
			if(!gradient)
				return

			if(!gradient.selectable)
				return

			if(!(prefs.species in gradient.species_allowed))
				return

			prefs.grad_style = params["name"]

		if("gradient_color")
			var/param_color = params["color"]
			if(!param_color)
				return

			var/r = hex2num(copytext(param_color, 2, 4))
			var/g = hex2num(copytext(param_color, 4, 6))
			var/b = hex2num(copytext(param_color, 6, 8))

			if(!isnum(r) || !isnum(g) || !isnum(b))
				return

			prefs.r_gradient = clamp(r, 0, 255)
			prefs.g_gradient = clamp(g, 0, 255)
			prefs.b_gradient = clamp(b, 0, 255)

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
