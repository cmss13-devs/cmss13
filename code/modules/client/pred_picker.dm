/datum/pred_picker
	var/list/skin_color_to_codes = list()

/datum/pred_picker/New()
	. = ..()

	for(var/color in PRED_SKIN_COLOR)
		var/pred_icon = /datum/species/yautja::icobase

		var/icon/icon = icon(pred_icon, "[color]_torso_pred_m")
		var/hex = icon.GetPixel(icon.Width() / 2, icon.Height() / 2)

		if(!hex)
			CRASH("Unable to get the skin color code for [color] in [pred_icon].")

		skin_color_to_codes[color] = hex


/datum/pred_picker/ui_static_data(mob/user)
	. = ..()

	var/datum/entity/player/player = user.client?.player_data
	if(!player)
		return

	.["can_use_legacy"] = user.client.check_whitelist_status(WHITELIST_YAUTJA_LEGACY)

	var/list/options = list(WHITELIST_NORMAL)
	if(player.whitelist_flags & (WHITELIST_YAUTJA_COUNCIL|WHITELIST_YAUTJA_COUNCIL_LEGACY))
		options += WHITELIST_COUNCIL
	if(player.whitelist_flags & WHITELIST_YAUTJA_LEADER)
		options += WHITELIST_LEADER

	.["available_statuses"] = options

	.["hair_icon"] = /datum/sprite_accessory/yautja_hair::icon

	.["hair_styles"] = list()
	for(var/key in GLOB.yautja_hair_styles_list)
		var/datum/sprite_accessory/yautja_hair/hair = GLOB.yautja_hair_styles_list[key]
		if(!hair.selectable)
			continue

		.["hair_styles"] += list(
			list("name" = hair.name, "icon" = hair.icon_state)
		)

	.["skin_colors"] = skin_color_to_codes

	.["armor_icon"] = /obj/item/clothing/suit/armor/yautja::icon
	.["armor_types"] = PRED_ARMOR_TYPE_MAX

	.["mask_icon"] = /obj/item/clothing/mask/gas/yautja/hunter::icon
	.["mask_types"] = PRED_MASK_TYPE_MAX

	.["greave_icon"] = /obj/item/clothing/shoes/yautja/hunter::icon
	.["greave_types"] = PRED_GREAVE_TYPE_MAX

	.["caster_icon"] = /obj/item/weapon/gun/energy/yautja/plasma_caster::icon
	.["caster_prefix"] = /obj/item/weapon/gun/energy/yautja/plasma_caster::base_icon_state

	.["mask_accessory_icon"] = /obj/item/clothing/accessory/mask::icon
	.["mask_accessory_types"] = PRED_MASK_ACCESSORY_TYPE_MAX

	.["materials"] = PRED_MATERIALS
	.["translators"] = PRED_TRANSLATORS
	.["legacies"] = PRED_LEGACIES


/datum/pred_picker/ui_data(mob/user)
	. = ..()

	var/datum/preferences/prefs = user.client?.prefs
	if(!prefs)
		return

	.["name"] = prefs.predator_name
	.["gender"] = prefs.predator_gender
	.["age"] = prefs.predator_age
	.["hair_style"] = prefs.predator_h_style
	.["skin_color"] = prefs.predator_skin_color
	.["flavor_text"] = prefs.predator_flavor_text
	.["yautja_status"] = prefs.yautja_status

	.["use_legacy"] = prefs.predator_use_legacy
	.["translator_type"] = prefs.predator_translator_type

	.["armor_type"] = prefs.predator_armor_type
	.["armor_material"] = prefs.predator_armor_material

	.["greave_type"] = prefs.predator_boot_type
	.["greave_material"] = prefs.predator_greave_material

	.["mask_type"] = prefs.predator_mask_type
	.["mask_material"] = prefs.predator_mask_material

	.["mask_accessory_type"] = prefs.predator_accessory_type

	.["caster_material"] = prefs.predator_caster_material

	.["cape_color"] = prefs.predator_cape_color

/datum/pred_picker/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	var/datum/preferences/prefs = ui.user.client?.prefs
	if(!prefs)
		return

	switch(action)

		if("name")
			var/picked_name = params["name"]
			picked_name = reject_bad_name(picked_name)
			if(!picked_name)
				return

			prefs.predator_name = picked_name

		if("gender")
			prefs.predator_gender = prefs.predator_gender == FEMALE ? MALE : FEMALE

		if("age")
			var/age = params["age"]
			if(!isnum(age))
				return

			age = clamp(age, 175, 3000)
			if(!age)
				return

			prefs.predator_age = age

		if("flavor_text")
			var/text = tgui_input_text(ui.user, "Choose your Predator's flavor text:", "Flavor Text", multiline = TRUE)
			if(!text)
				return

			prefs.predator_flavor_text = text

		if("skin_color")
			var/skin_color = params["color"]
			if(!skin_color || !(skin_color in PRED_SKIN_COLOR))
				return

			prefs.predator_skin_color = skin_color

		if("yautja_status")
			var/datum/entity/player/player = ui.user.client?.player_data
			if(!player)
				return

			var/list/options = list(WHITELIST_NORMAL)
			if(player.whitelist_flags & (WHITELIST_YAUTJA_COUNCIL|WHITELIST_YAUTJA_COUNCIL_LEGACY))
				options += WHITELIST_COUNCIL
			if(player.whitelist_flags & WHITELIST_YAUTJA_LEADER)
				options += WHITELIST_LEADER

			var/selected = params["selected"]
			if(!selected || !(selected in options))
				return

			prefs.yautja_status = selected

		if("hair_style")
			var/picked = params["name"]
			if(!picked)
				return

			var/datum/sprite_accessory/yautja_hair/hair = GLOB.yautja_hair_styles_list[picked]
			if(!hair)
				return

			prefs.predator_h_style = picked

		if("armor_type")
			var/armor = params["type"]
			if(!armor || !isnum(armor))
				return

			armor = clamp(armor, 1, PRED_ARMOR_TYPE_MAX)
			prefs.predator_armor_type = armor

		if("armor_material")
			var/material = params["material"]
			if(!material || !(material in PRED_MATERIALS))
				return

			prefs.predator_armor_material = material

		if("mask_type")
			var/mask = params["type"]
			if(!mask || !isnum(mask))
				return

			mask = clamp(mask, 1, PRED_MASK_TYPE_MAX)
			prefs.predator_mask_type = mask

		if("mask_material")
			var/material = params["material"]
			if(!material || !(material in PRED_MATERIALS))
				return

			prefs.predator_mask_material = material

		if("greaves_type")
			var/greaves = params["type"]
			if(!greaves || !isnum(greaves))
				return

			greaves = clamp(greaves, 1, PRED_GREAVE_TYPE_MAX)
			prefs.predator_boot_type = greaves

		if("greaves_material")
			var/material = params["material"]
			if(!material || !(material in PRED_MATERIALS))
				return

			prefs.predator_greave_material = material

		if("caster_material")
			var/material = params["material"]
			if(!material || !(material in PRED_MATERIALS))
				return

			prefs.predator_caster_material = material

		if("mask_accessory")
			var/accessory = params["type"]
			if(isnull(accessory) || !isnum(accessory))
				return

			accessory = clamp(accessory, 0, PRED_MASK_ACCESSORY_TYPE_MAX)
			prefs.predator_accessory_type = accessory

		if("translator_type")
			var/selected = params["selected"]
			if(!selected || !(selected in PRED_TRANSLATORS))
				return

			prefs.predator_translator_type = selected

		if("legacy")
			var/selected = params["selected"]
			if(!selected || !(selected in PRED_LEGACIES))
				return

			if(!ui.user.client?.check_whitelist_status(WHITELIST_YAUTJA_LEGACY))
				return

			prefs.predator_use_legacy = selected

		if("cape_color")
			var/color = params["color"]
			if(!color)
				return

			prefs.predator_cape_color = sanitize_hexcolor(color)

	prefs.update_preview_icon()
	return TRUE

/datum/pred_picker/tgui_interact(mob/user, datum/tgui/ui)
	. = ..()

	ui = SStgui.try_update_ui(user, src, ui)

	if(!ui)
		ui = new(user, src, "PredPicker", "Yautja Preferences")
		ui.open()
		ui.set_autoupdate(FALSE)

	winset(user, ui.window.id, "focus=true")

/datum/pred_picker/ui_state(mob/user)
	return GLOB.always_state
