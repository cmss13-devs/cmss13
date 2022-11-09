/obj/structure/machinery/cm_vending/clothing/dress
	name = "ColMarTech Automated Personal Uniform Closet"
	desc = "An automated closet hooked up to a colossal storage of standard-issue dress uniform variants."
	icon_state = "dress"
	use_points = TRUE
	vendor_theme = VENDOR_THEME_USCM

/obj/structure/machinery/cm_vending/clothing/dress/proc/get_listed_products_for_role(list/role_specific_uniforms)
	var/list/display_list = list()
	for(var/category_type in uniform_categories)
		var/display_category = FALSE
		if(!uniform_categories[category_type])
			continue
		for(var/category in uniform_categories[category_type])
			if((category in role_specific_uniforms) && role_specific_uniforms[category])
				display_category = TRUE
				break
		if(!display_category)
			continue
		display_list += list(
			list(category_type, 0, null, null, null)
		)
		for(var/object_type in uniform_categories[category_type])
			if(!role_specific_uniforms[object_type])
				continue
			for(var/uniform_path in role_specific_uniforms[object_type])
				var/obj/O = uniform_path
				var/name = sanitize(initial(O.name))
				display_list += list(
					list(name, 0, uniform_path, NO_FLAGS, VENDOR_ITEM_REGULAR)
				)
	return display_list

/obj/structure/machinery/cm_vending/clothing/dress/proc/get_products_preset(var/list/presets)
	var/list/display_list = list()
	for(var/preset in presets)
		var/datum/equipment_preset/pre = new preset()
		var/list/uniforms = pre.uniform_sets
		display_list += get_listed_products_for_role(uniforms)
		qdel(pre)
	return display_list

/obj/structure/machinery/cm_vending/clothing/dress/get_listed_products(mob/user)
	if (!user)
		return get_products_preset(typesof(/datum/equipment_preset))

	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/card/id/I = H.wear_id
	var/list/role_specific_uniforms
	var/list/vended_items
	var/list/display_list = list()
	if(istype(I))
		role_specific_uniforms = I.uniform_sets
		vended_items = I.vended_items
	for(var/category_type in uniform_categories)
		var/display_category = FALSE
		if(!uniform_categories[category_type])
			continue
		for(var/category in uniform_categories[category_type])
			if((category in role_specific_uniforms) && role_specific_uniforms[category])
				display_category = TRUE
				break
		if(!display_category)
			continue
		display_list += list(
			list(category_type, 0, null, null, null)
		)
		for(var/object_type in uniform_categories[category_type])
			if(!role_specific_uniforms[object_type])
				continue
			for(var/uniform_path in role_specific_uniforms[object_type])
				var/obj/O = uniform_path
				var/can_vend = TRUE
				if(uniform_path in vended_items)
					can_vend = FALSE
				var/name = sanitize(initial(O.name))
				var/flags = can_vend ? NO_FLAGS : MARINE_CAN_BUY_ALL
				display_list += list(
					list(name, 0, uniform_path, flags, VENDOR_ITEM_REGULAR)
				)
	return display_list

/obj/structure/machinery/cm_vending/clothing/dress/ui_data(mob/user)

	var/mob/living/carbon/human/H = user
	var/obj/item/card/id/I = H.wear_id
	var/list/vended_items
	if(istype(I))
		vended_items = I.vended_items

	var/list/data = list()
	var/list/ui_listed_products = get_listed_products(user)
	var/list/stock_values = list()
	for (var/i in 1 to length(ui_listed_products))
		var/prod_available = TRUE
		var/list/myprod = ui_listed_products[i]	//we take one list from listed_products
		var/uniform_path = myprod[3]
		if(uniform_path in vended_items)
			prod_available = FALSE
		stock_values += list(prod_available)

	data["stock_listing"] = stock_values
	data["show_points"] = FALSE
	data["current_m_points"] = available_points_to_display
	return data

/obj/structure/machinery/cm_vending/clothing/dress/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..(action == "vend" ? "" : action, params, ui, state)
	if(.)
		return

	var/mob/living/carbon/human/H = usr
	switch (action)
		if ("vend")
			var/exploiting = TRUE
			var/idx=params["prod_index"]

			var/list/topic_listed_products = get_listed_products(usr)
			var/list/L = topic_listed_products[idx]

			var/item_path = L[3]

			var/obj/item/card/id/I = H.wear_id

			if(!istype(I)) //not wearing an ID
				to_chat(H, SPAN_WARNING("Access denied. No ID card detected"))
				return

			if(I.registered_name != H.real_name)
				to_chat(H, SPAN_WARNING("Wrong ID card owner detected."))
				return

			if(LAZYLEN(vendor_role) && !vendor_role.Find(I.rank))
				to_chat(H, SPAN_WARNING("This machine isn't for you."))
				return

			for(var/category in uniform_categories) // Very Hacky fix
				if(!exploiting)
					break
				for(var/specific_category in uniform_categories[category])
					if(!exploiting)
						break
					if(!(specific_category in I.uniform_sets))
						continue
					for(var/outfit in I.uniform_sets[specific_category])
						if(ispath(item_path, outfit))
							exploiting = FALSE
							break


			if(exploiting)
				return

			var/obj/item/IT = new item_path(get_appropriate_vend_turf())
			IT.add_fingerprint(usr)
			LAZYADD(I.vended_items, item_path)
			return TRUE
		if("cancel")
			SStgui.close_uis(src)
			return TRUE
