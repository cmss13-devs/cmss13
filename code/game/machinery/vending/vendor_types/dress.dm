/obj/structure/machinery/cm_vending/clothing/dress
	name = "ColMarTech Automated Personal Uniform Closet"
	desc = "An automated closet hooked up to a colossal storage of standard-issue dress uniform variants."
	icon_state = "dress"
	use_points = TRUE
	vendor_theme = VENDOR_THEME_USCM

/obj/structure/machinery/cm_vending/clothing/dress/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 0)

	if(!ishuman(user)) return
	var/mob/living/carbon/human/H = user

	var/list/display_list = list()

	var/m_points = 0
	var/obj/item/card/id/I = H.wear_id
	var/list/role_specific_uniforms
	var/list/vended_items
	if(istype(I))
		role_specific_uniforms = I.uniform_sets
		vended_items = I.vended_items
	var/category_index = 1
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
		display_list += list(list("prod_index" = category_index, "prod_path" = null, "prod_name" = category_type, "prod_available" = null, "prod_color" = null))
		category_index++
		for(var/object_type in uniform_categories[category_type])
			if(!role_specific_uniforms[object_type])
				continue
			for(var/uniform_path in role_specific_uniforms[object_type])
				var/obj/O = uniform_path
				var/can_vend = TRUE
				if(uniform_path in vended_items)
					can_vend = FALSE
				display_list += list(list("prod_index" = category_index, "prod_path" = uniform_path, "prod_name" = sanitize(initial(O.name)), "prod_available" = can_vend, "prod_color" = VENDOR_ITEM_REGULAR))
				category_index++

	var/list/data = list(
		"vendor_name" = name,
		"theme" = vendor_theme,
		"show_points" = use_points,
		"current_m_points" = m_points,
		"displayed_records" = display_list,
	)
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "cm_vending_uniform.tmpl", name , 600, 700)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(0)

/obj/structure/machinery/cm_vending/clothing/dress/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(stat & (BROKEN|NOPOWER))
		return
	if(usr.is_mob_incapacitated())
		return

	if (in_range(src, usr) && isturf(loc) && ishuman(usr))
		usr.set_interaction(src)
		if (href_list["vend"])
			var/exploiting = TRUE
			var/item_path = text2path(href_list["vend"])
			var/mob/living/carbon/human/H = usr

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

		add_fingerprint(usr)
		ui_interact(usr) //updates the nanoUI window
