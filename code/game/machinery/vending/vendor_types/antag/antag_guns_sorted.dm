//------------ADAPTIVE ANTAG SORTED GUNS VENDOR---------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns/antag_guns
	name = "\improper Suspicious Automated Guns Rack"
	desc = "While similar in function to ColMarTech automated racks, this one is clearly not of USCM origin. Contains various weapons."
	icon_state = "antag_guns"
	req_access = list(ACCESS_ILLEGAL_PIRATE)
	listed_products = list()

/obj/structure/machinery/cm_vending/sorted/cargo_guns/antag_guns/populate_product_list(var/scale)
	return

/obj/structure/machinery/cm_vending/sorted/cargo_guns/antag_guns/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 0)

	if(!ishuman(user))
		return

	var/list/display_list = list()

	var/mob/living/carbon/human/H = user

	var/faction = H.faction ? H.faction : FACTION_CLF
	if(!(faction in listed_products))
		var/datum/faction/F = get_faction(H.faction)
		listed_products[faction] = F.get_antag_guns_sorted_equipment()

	var/list/products_sets = listed_products[faction]

	if(LAZYLEN(products_sets))
		for(var/i in 1 to products_sets.len)
			var/list/myprod = products_sets[i]	//we take one list from listed_products

			var/p_name = myprod[1]					//taking it's name
			var/p_amount = myprod[2]				//amount left
			var/prod_available = FALSE				//checking if it's available
			if(p_amount > 0)						//checking availability
				p_name += ": [p_amount]"			//and adding amount to product name so it will appear in "button" in UI
				prod_available = TRUE
			else if(p_amount == 0)
				p_name += ": 0"				//Negative  numbers (-1) used for categories.

			//forming new list with index, name, amount, available or not, color and add it to display_list
			display_list += list(list("prod_index" = i, "prod_name" = p_name, "prod_amount" = p_amount, "prod_available" = prod_available, "prod_color" = myprod[4]))


	var/adaptive_vendor_theme = VENDOR_THEME_COMPANY	//for potential future PMC version
	switch(H.faction)
		if(FACTION_UPP)
			adaptive_vendor_theme = VENDOR_THEME_UPP
		if(FACTION_CLF)
			adaptive_vendor_theme = VENDOR_THEME_CLF

	var/list/data = list(
		"vendor_name" = name,
		"theme" = adaptive_vendor_theme,
		"displayed_records" = display_list,
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "cm_vending_sorted.tmpl", name , 600, 700)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(0)

/obj/structure/machinery/cm_vending/sorted/cargo_guns/antag_guns/handle_topic(mob/user, href, href_list)
	if(in_range(src, user) && isturf(loc) && ishuman(user))
		user.set_interaction(src)
		if (href_list["vend"])

			var/mob/living/carbon/human/H = user

			if(!allowed(H))
				to_chat(H, SPAN_WARNING("Access denied."))
				vend_fail()
				return

			var/obj/item/card/id/I = H.wear_id
			if(!istype(I))
				to_chat(H, SPAN_WARNING("Access denied. No ID card detected"))
				vend_fail()
				return

			if(I.registered_name != H.real_name)
				to_chat(H, SPAN_WARNING("Wrong ID card owner detected."))
				vend_fail()
				return

			var/idx=text2num(href_list["vend"])
			var/faction = H.faction ? H.faction : FACTION_CLF
			var/list/L = listed_products[faction][idx]

			var/turf/T = get_appropriate_vend_turf(H)
			if(T.contents.len > 25)
				to_chat(H, SPAN_WARNING("The floor is too cluttered, make some space."))
				vend_fail()
				return

			if(L[2] <= 0)	//to avoid dropping more than one product when there's
				to_chat(H, SPAN_WARNING("[L[1]] is out of stock."))
				vend_fail()
				return		// one left and the player spam click during a lagspike.

			vend_succesfully(L, H, T)

		add_fingerprint(user)
		ui_interact(user) //updates the nanoUI window
