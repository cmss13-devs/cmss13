/obj/item/storage/toolkit
	name = "engineer kit"
	desc = "An combat engineering toolkit intended to carry electrical and mechanical supplies into combat. With engineering training you can fit this in a backpack."
	icon_state = "toolkit"
	item_state = "fulton"
	throw_speed = SPEED_FAST
	throw_range = 8
	use_sound = "toolbox"
	matter = list("plastic" = 2000)
	can_hold = list(
		/obj/item/circuitboard,
		/obj/item/device/flashlight,
		/obj/item/clothing/glasses/welding,
		/obj/item/device/analyzer,
		/obj/item/device/demo_scanner,
		/obj/item/device/reagent_scanner,
		/obj/item/device/t_scanner,
		/obj/item/stack/cable_coil,
		/obj/item/cell,
		/obj/item/device/assembly,
		/obj/item/stock_parts,
		/obj/item/explosive/plastic,
	)
	storage_flags = STORAGE_FLAGS_BOX
	required_skill_for_nest_opening = SKILL_ENGINEER
	required_skill_level_for_nest_opening = SKILL_ENGINEER_ENGI

	///icon state to use when kit is full
	var/icon_full

/obj/item/storage/toolkit/Initialize()
	. = ..()

	icon_full = initial(icon_state)

	update_icon()

/obj/item/storage/toolkit/update_icon()
	if(content_watchers || !length(contents))
		icon_state = "toolkit_empty"
	else
		icon_state = icon_full

/obj/item/storage/toolkit/empty/fill_preset_inventory()
	return
