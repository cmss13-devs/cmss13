//------------ADAPTIVE ANTAG GUNS VENDOR THAT USES SNOWFLAKE POINTS---------------

/obj/structure/machinery/cm_vending/gear/antag_guns
	name = "\improper Suspicious Automated Guns Rack"
	desc = "While similar in function to ColMarTech automated racks, this one is clearly not of USCM origin. Contains various weapons, ammunition and explosives."
	icon_state = "antag_guns"
	req_access = list(ACCESS_ILLEGAL_PIRATE)

	use_snowflake_points = TRUE

	listed_products = list()

/obj/structure/machinery/cm_vending/gear/antag_guns/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 0)

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

	var/faction = H.faction ? H.faction : FACTION_CLF
	if(!(faction in listed_products))
		var/datum/faction/F = get_faction(H.faction)
		listed_products[faction] = F.get_antag_guns_snowflake_equipment()

	var/list/products_sets = listed_products[faction]

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

/obj/structure/machinery/cm_vending/gear/antag_guns/handle_topic(mob/user, href, href_list)
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
			var/faction = H.faction ? H.faction : FACTION_CLF
			var/list/L = listed_products[faction][idx]
			var/cost = L[2]

			if((!H.assigned_squad && squad_tag) || (!H.assigned_squad?.omni_squad_vendor && (squad_tag && H.assigned_squad.name != squad_tag)))
				to_chat(H, SPAN_WARNING("This machine isn't for your squad."))
				vend_fail()
				return

			var/turf/T = get_appropriate_vend_turf()
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
					H.marine_buy_flags &= ~L[4]
				else
					to_chat(H, SPAN_WARNING("You can't buy things from this category anymore."))
					vend_fail()
					return

			vend_succesfully(L, H, T)

		add_fingerprint(user)
		ui_interact(user) //updates the nanoUI window

/obj/structure/machinery/cm_vending/gear/antag_guns/vend_succesfully(var/list/L, var/mob/living/carbon/human/H, var/turf/T)
	if(stat & IN_USE)
		return

	stat |= IN_USE
	if(LAZYLEN(L))

		var/prod_type = L[3]
		var/obj/item/O
		if(ispath(prod_type, /obj/effect/essentials_set/random))
			new prod_type(src)
			for(var/obj/item/IT in contents)
				O = IT
				O.forceMove(T)
		else
			if(ispath(prod_type, /obj/item/weapon/gun))
				O = new prod_type(T, TRUE)
			else
				O = new prod_type(T)
		O.add_fingerprint(usr)

	else
		to_chat(H, SPAN_WARNING("ERROR: L is missing. Please report this to admins."))
		overlays += image(icon, "[icon_state]_deny")
		sleep(5)
	stat &= ~IN_USE
	update_icon()
	return

//--------------ESSENTIALS------------------------

/obj/effect/essentials_set/medic/upp
	spawned_gear_list = list(
		/obj/item/bodybag/cryobag,
		/obj/item/device/defibrillator,
		/obj/item/storage/firstaid/adv,
		/obj/item/device/healthanalyzer,
		/obj/item/roller,
	)

/obj/effect/essentials_set/upp_heavy
	spawned_gear_list = list(
		/obj/item/weapon/gun/minigun/upp,
		/obj/item/ammo_magazine/minigun,
		/obj/item/ammo_magazine/minigun,
	)

/obj/effect/essentials_set/leader/upp
	spawned_gear_list = list(
		/obj/item/explosive/plastic,
		/obj/item/device/binoculars/range,
		/obj/item/map/current_map,
		/obj/item/storage/box/zipcuffs
	)

/obj/effect/essentials_set/kit/svd
	spawned_gear_list = list(
		/obj/item/weapon/gun/rifle/sniper/svd,
		/obj/item/ammo_magazine/sniper/svd,
		/obj/item/ammo_magazine/sniper/svd,
		/obj/item/ammo_magazine/sniper/svd,
		/obj/item/ammo_magazine/sniper/svd
	)

/obj/effect/essentials_set/kit/custom_shotgun
	spawned_gear_list = list(
		/obj/item/weapon/gun/shotgun/merc,
		/obj/item/ammo_magazine/shotgun/incendiary,
		/obj/item/ammo_magazine/shotgun,
		/obj/item/ammo_magazine/shotgun/flechette
	)

/obj/effect/essentials_set/kit/m60
	spawned_gear_list = list(
		/obj/item/weapon/gun/m60,
		/obj/item/ammo_magazine/m60,
		/obj/item/ammo_magazine/m60,
		/obj/item/ammo_magazine/m60
	)

/obj/effect/essentials_set/random/clf_melee
	spawned_gear_list = list(
					/obj/item/tool/hatchet,
					/obj/item/tool/hatchet,
					/obj/item/weapon/melee/baseballbat,
					/obj/item/weapon/melee/baseballbat,
					/obj/item/weapon/melee/baseballbat/metal,
					/obj/item/weapon/melee/twohanded/spear,
					/obj/item/weapon/melee/twohanded/spear,
					/obj/item/weapon/melee/twohanded/fireaxe,
					)
