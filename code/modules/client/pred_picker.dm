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

	.["can_use_legacy"] = user.client.check_whitelist_status(WHITELIST_YAUTJA_LEGACY)

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
	.["caster_material"] = prefs.predator_caster_material

	.["cape_color"] = prefs.predator_cape_color

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
