//------------ADAPTIVE ANTAG CLOSET---------------
//Spawn one of these bad boys and you will have a proper automated closet for CLF/UPP players (for now, more can be always added later)

/obj/structure/machinery/cm_vending/clothing/antag
	name = "\improper Suspicious Automated Equipment Rack"
	desc = "While similar in function to ColMarTech automated racks, this one is clearly not of USCM origin. Contains various equipment."
	icon_state = "antag_clothing"
	req_access = list(ACCESS_ILLEGAL_PIRATE)

	listed_products = list()

/obj/structure/machinery/cm_vending/clothing/antag/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 0)

	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	var/list/display_list = list()

	var/m_points = 0
	var/buy_flags = NO_FLAGS
	if(use_snowflake_points)
		m_points = H.marine_snowflake_points
	else
		m_points = H.marine_points
	buy_flags = H.marine_buy_flags

	var/list/products_sets = list()
	if(H.assigned_equipment_preset)
		if(!(H.assigned_equipment_preset.type in listed_products))
			listed_products[H.assigned_equipment_preset.type] = H.assigned_equipment_preset.get_antag_clothing_equipment()
		products_sets = listed_products[H.assigned_equipment_preset.type]
	else
		if(!(/datum/equipment_preset/clf in listed_products))
			listed_products[/datum/equipment_preset/clf] = GLOB.gear_path_presets_list[/datum/equipment_preset/clf].get_antag_clothing_equipment()
		products_sets = listed_products[/datum/equipment_preset/clf]

	if(products_sets.len)
		for(var/i in 1 to products_sets.len)
			var/list/myprod = products_sets[i]
			var/p_name = myprod[1]
			var/p_cost = myprod[2]
			if(p_cost > 0)
				p_name += " ([p_cost] points)"

			var/prod_available = FALSE
			var/avail_flag = myprod[4]
			if(m_points >= p_cost && (!avail_flag || buy_flags & avail_flag))
				prod_available = TRUE

			//place in main list, name, cost, available or not, color.
			display_list += list(list("prod_index" = i, "prod_name" = p_name, "prod_available" = prod_available, "prod_color" = myprod[5]))

	var/adaptive_vendor_theme = VENDOR_THEME_COMPANY	//for potential future PMC version
	switch(H.faction)
		if(FACTION_UPP)
			adaptive_vendor_theme = VENDOR_THEME_UPP
		if(FACTION_CLF)
			adaptive_vendor_theme = VENDOR_THEME_CLF

	var/list/data = list(
		"vendor_name" = name,
		"theme" = adaptive_vendor_theme,
		"show_points" = use_points,
		"current_m_points" = m_points,
		"displayed_records" = display_list,
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "cm_vending.tmpl", name , 600, 700)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(0)

/obj/structure/machinery/cm_vending/clothing/antag/handle_topic(mob/user, href, href_list)
	if(in_range(src, user) && isturf(loc) && ishuman(user))
		user.set_interaction(src)
		if (href_list["vend"])

			var/mob/living/carbon/human/H = user

			if(!allowed(H))
				to_chat(H, SPAN_WARNING("Access denied."))
				vend_fail()
				return

			var/obj/item/card/id/I = H.wear_id
			if(!istype(I)) //not wearing an ID
				to_chat(H, SPAN_WARNING("Access denied. No ID card detected"))
				vend_fail()
				return

			if(I.registered_name != H.real_name)
				to_chat(H, SPAN_WARNING("Wrong ID card owner detected."))
				vend_fail()
				return

			var/idx=text2num(href_list["vend"])
			var/list/L = list()
			if(H.assigned_equipment_preset)
				L = listed_products[H.assigned_equipment_preset.type][idx]
			else
				L = listed_products[/datum/equipment_preset/clf][idx]
			var/cost = L[2]

			var/turf/T = loc
			if(T.contents.len > 25)
				to_chat(H, SPAN_WARNING("The floor is too cluttered, make some space."))
				vend_fail()
				return

			if(use_points)
				if(use_snowflake_points)
					if(H.marine_snowflake_points < cost)
						to_chat(H, SPAN_WARNING("Not enough points."))
						vend_fail()
						return
					else
						H.marine_snowflake_points -= cost
				else
					if(H.marine_points < cost)
						to_chat(H, SPAN_WARNING("Not enough points."))
						vend_fail()
						return
					else
						H.marine_points -= cost

			if(L[4])
				if(H.marine_buy_flags & L[4])
					if(L[4] == (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH))
						if(H.marine_buy_flags & MARINE_CAN_BUY_R_POUCH)
							H.marine_buy_flags &= ~MARINE_CAN_BUY_R_POUCH
						else
							H.marine_buy_flags &= ~MARINE_CAN_BUY_L_POUCH
					else
						H.marine_buy_flags &= ~L[4]
				else
					to_chat(H, SPAN_WARNING("You can't buy things from this category anymore."))
					vend_fail()
					return

			vend_succesfully(L, H)

		add_fingerprint(user)
		ui_interact(user) //updates the nanoUI window

/obj/structure/machinery/cm_vending/clothing/antag/vend_succesfully(var/list/L, var/mob/living/carbon/human/H)
	if(stat & IN_USE)
		return


	stat |= IN_USE
	if(LAZYLEN(L))
		var/prod_type = L[3]
		var/obj/item/O
		var/turf/T = get_appropriate_vend_turf(H)
		if(ispath(prod_type, /obj/effect/essentials_set/random))
			new prod_type(src)
			for(var/obj/item/IT in contents)
				O = IT
				O.forceMove(T)
		else
			O = new prod_type(T)

		O.add_fingerprint(usr)

		var/bitf = L[4]
		if(bitf)
			if(bitf == MARINE_CAN_BUY_UNIFORM)
				var/obj/item/clothing/under/U = O
				//Gives ranks to the ranked
				if(H.wear_id && H.wear_id.paygrade)
					var/rankpath = get_rank_pins(H.wear_id.paygrade)
					if(rankpath)
						var/obj/item/clothing/accessory/ranks/R = new rankpath()
						U.attach_accessory(H, R)

		if(istype(O, /obj/item) && O.flags_equip_slot != NO_FLAGS)	//auto-equipping feature here
			if(O.flags_equip_slot == SLOT_ACCESSORY)
				if(H.w_uniform)
					var/obj/item/clothing/C = H.w_uniform
					if(C.can_attach_accessory(O))
						C.attach_accessory(H, O)
			else
				H.equip_to_appropriate_slot(O)

	else
		to_chat(H, SPAN_WARNING("ERROR: L is missing. Please report this to admins."))
		overlays += image(icon, "[icon_state]_deny")
		sleep(5)
	stat &= ~IN_USE
	update_icon()
	return

//--------------RANDOM EQUIPMENT AND GEAR------------------------

/obj/effect/essentials_set/random/clf_shoes
	spawned_gear_list = list(
					/obj/item/clothing/shoes/black,
					/obj/item/clothing/shoes/brown,
					/obj/item/clothing/shoes/combat,
					/obj/item/clothing/shoes/laceup,
					/obj/item/clothing/shoes/leather,
					/obj/item/clothing/shoes/swat
					)

/obj/effect/essentials_set/random/clf_armor
	spawned_gear_list = list(
					/obj/item/clothing/suit/armor/vest,
					/obj/item/clothing/suit/armor/bulletproof,
					/obj/item/clothing/suit/storage/militia/brace,
					/obj/item/clothing/suit/storage/militia,
					/obj/item/clothing/suit/storage/militia/partial,
					/obj/item/clothing/suit/storage/militia/vest
					)

/obj/effect/essentials_set/random/clf_gloves
	spawned_gear_list = list(
					/obj/item/clothing/gloves/black,
					/obj/item/clothing/gloves/botanic_leather,
					/obj/item/clothing/gloves/combat,
					/obj/item/clothing/gloves/swat
					)

/obj/effect/essentials_set/random/clf_head
	spawned_gear_list = list(
					/obj/item/clothing/head/militia,
					/obj/item/clothing/head/militia/bucket,
					/obj/item/clothing/head/helmet/skullcap,
					/obj/item/clothing/head/hardhat,
					/obj/item/clothing/head/helmet,
					/obj/item/clothing/head/bandana,
					/obj/item/clothing/head/headband/red,
					/obj/item/clothing/head/headband/rambo,
					/obj/item/clothing/head/headband/rebel,
					/obj/item/clothing/head/helmet/swat
					)

/obj/effect/essentials_set/random/clf_belt
	spawned_gear_list = list(
					/obj/item/storage/belt/marine,
					/obj/item/storage/belt/marine,
					/obj/item/storage/belt/marine,
					/obj/item/storage/belt/marine,
					/obj/item/storage/belt/marine,
					/obj/item/storage/belt/gun/flaregun/full,
					/obj/item/storage/belt/gun/flaregun/full,
					/obj/item/storage/backpack/general_belt,
					/obj/item/storage/backpack/general_belt,
					/obj/item/storage/backpack/general_belt,
					/obj/item/storage/belt/knifepouch,
					/obj/item/storage/large_holster/katana/full,
					/obj/item/storage/large_holster/machete/full
					)
