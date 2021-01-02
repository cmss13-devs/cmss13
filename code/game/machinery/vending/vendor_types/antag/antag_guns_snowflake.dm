//------------ADAPTIVE ANTAG GUNS VENDOR THAT USES SNOWFLAKE POINTS---------------

/obj/structure/machinery/cm_vending/gear/antag_guns
	name = "\improper Suspicious Automated Guns Rack"
	desc = "While similar in function to ColMarTech automated racks, this one is clearly not of USCM origin. Contains various weapons, ammunition and explosives."
	icon_state = "antag_guns"
	vendor_role = VENDOR_ANTAG_JOBS
	req_access = list(ACCESS_ILLEGAL_PIRATE)

	use_snowflake_points = TRUE

	listed_products = list(

		FACTION_UPP = list(

			list("PRIMARY FIREARMS", 0, null, null, null),
			list("CZ-81 Submachinegun", 20, /obj/item/weapon/gun/smg/skorpion/upp, null, VENDOR_ITEM_REGULAR),
			list("Type 71 Flamethrower Pulse Rifle", 30, /obj/item/weapon/gun/rifle/type71/flamer, null, VENDOR_ITEM_REGULAR),
			list("Type 71 Pulse Rifle", 30, /obj/item/weapon/gun/rifle/type71, null, VENDOR_ITEM_REGULAR),
			list("Type 71 Pulse Rifle Carbine", 30, /obj/item/weapon/gun/rifle/type71/carbine, null, VENDOR_ITEM_REGULAR),

			list("PRIMARY AMMUNITION", 0, null, null, null),
			list("CZ-81 Magazine (.32ACP)", 5, /obj/item/ammo_magazine/smg/skorpion, null, VENDOR_ITEM_REGULAR),
			list("Type 71 AP Magazine (5.45x39mm)", 15, /obj/item/ammo_magazine/rifle/type71/ap, null, VENDOR_ITEM_REGULAR),
			list("Type 71 Magazine (5.45x39mm)", 5, /obj/item/ammo_magazine/rifle/type71, null, VENDOR_ITEM_REGULAR),

			list("SIDEARMS", 0, null, null, null),
			list("Highpower Automag", 15, /obj/item/weapon/gun/pistol/highpower, null, VENDOR_ITEM_REGULAR),
			list("Korovin PK-9 Pistol", 15, /obj/item/weapon/gun/pistol/c99/upp, null, VENDOR_ITEM_REGULAR),
			list("N-Y 7.62mm Revolver", 15, /obj/item/weapon/gun/revolver/upp, null, VENDOR_ITEM_REGULAR),

			list("SIDEARM AMMUNITION", 0, null, null, null),
			list("Highpower Magazine (9mm)", 5, /obj/item/ammo_magazine/pistol/automatic, null, VENDOR_ITEM_REGULAR),
			list("N-Y Speed Loader (7.62x38mmR)", 5, /obj/item/ammo_magazine/revolver/upp, null, VENDOR_ITEM_REGULAR),
			list("PK-9 Magazine (.22 Hollowpoint)", 5, /obj/item/ammo_magazine/pistol/c99, null, VENDOR_ITEM_REGULAR),

			list("ATTACHMENTS", 0, null, null, null),
			list("Angled Grip", 15, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
			list("Burst Fire Assembly", 15, /obj/item/attachable/burstfire_assembly, null, VENDOR_ITEM_REGULAR),
			list("Extended Barrel", 15, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
			list("Laser Sight", 15, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
			list("Quickfire Adapter", 15, /obj/item/attachable/quickfire, null, VENDOR_ITEM_REGULAR),
			list("Rail Flashlight", 5, /obj/item/attachable/flashlight, null, VENDOR_ITEM_REGULAR),
			list("Red-Dot Sight", 15, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
			list("Reflex Sight", 15, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
			list("Suppressor", 15, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
			list("Vertical Grip", 15, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

			list("UTILITIES", 0, null, null, null),
			list("M94 Marking Flare Pack", 3, /obj/item/storage/box/m94, null, VENDOR_ITEM_RECOMMENDED),
			list("Smoke Grenade", 7, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
			list("Type 80 Bayonet", 3, /obj/item/attachable/bayonet/upp, null, VENDOR_ITEM_REGULAR),
		),

		FACTION_CLF = list(

			list("PRIMARY FIREARMS", 0, null, null, null),
			list("Basira-Armstrong Rifle", 30, /obj/item/weapon/gun/rifle/hunting, null, VENDOR_ITEM_REGULAR),
			list("CZ-81 Submachinegun", 20, /obj/item/ammo_magazine/smg/skorpion, null, VENDOR_ITEM_REGULAR),
			list("Double Barrel Shotgun", 30, /obj/item/weapon/gun/shotgun/double, null, VENDOR_ITEM_REGULAR),
			list("HG 37-12 Pump Shotgun", 30, /obj/item/weapon/gun/shotgun/double/sawn, null, VENDOR_ITEM_REGULAR),
			list("M16 Rifle", 30, /obj/item/weapon/gun/rifle/m16, null, VENDOR_ITEM_REGULAR),
			list("MAR-30 Battle Carbine", 30, /obj/item/weapon/gun/rifle/mar40/carbine, null, VENDOR_ITEM_REGULAR),
			list("MAR-40 Battle Rifle", 30, /obj/item/weapon/gun/rifle/mar40, null, VENDOR_ITEM_REGULAR),
			list("MAC-15 Submachinegun", 20, /obj/item/weapon/gun/smg/uzi, null, VENDOR_ITEM_REGULAR),
			list("MP27 Submachinegun", 20, /obj/item/weapon/gun/smg/mp7, null, VENDOR_ITEM_REGULAR),
			list("MP5 Submachinegun", 20, /obj/item/weapon/gun/smg/mp5, null, VENDOR_ITEM_REGULAR),
			list("Sawn-Off Shotgun", 30, /obj/item/weapon/gun/shotgun/pump/cmb, null, VENDOR_ITEM_REGULAR),

			list("PRIMARY AMMUNITION", 0, null, null, null),
			list("Basira-Armstrong Magazine (6.5mm)", 5, /obj/item/ammo_magazine/rifle/hunting, null, VENDOR_ITEM_REGULAR),
			list("Box Of Buckshot Shells", 10, /obj/item/ammo_magazine/shotgun/buckshot, null, VENDOR_ITEM_REGULAR),
			list("Box Of Flechette Shells", 10, /obj/item/ammo_magazine/shotgun/flechette, null, VENDOR_ITEM_REGULAR),
			list("Box Of Shotgun Slugs", 10, /obj/item/ammo_magazine/shotgun, null, VENDOR_ITEM_REGULAR),
			list("CZ-81 Magazine (.32ACP)", 5, /obj/item/ammo_magazine/smg/skorpion, null, VENDOR_ITEM_REGULAR),
			list("M16 AP Magazine (5.56x45mm)", 15, /obj/item/ammo_magazine/rifle/m16/ap, null, VENDOR_ITEM_REGULAR),
			list("M16 Magazine (5.56x45mm)", 5, /obj/item/ammo_magazine/rifle/m16, null, VENDOR_ITEM_REGULAR),
			list("MAC-15 Magazine (9mm)", 5, /obj/item/ammo_magazine/smg/uzi, null, VENDOR_ITEM_REGULAR),
			list("MAR Magazine (7.62x39mm)", 5, /obj/item/ammo_magazine/rifle/mar40, null, VENDOR_ITEM_REGULAR),
			list("MAR Extended Magazine (7.62x39mm)", 15, /obj/item/ammo_magazine/rifle/mar40/extended, null, VENDOR_ITEM_REGULAR),
			list("MP27 Magazine (4.6x30mm)", 5, /obj/item/ammo_magazine/smg/mp7, null, VENDOR_ITEM_REGULAR),
			list("MP5 Magazine (9mm)", 5, /obj/item/ammo_magazine/smg/mp5, null, VENDOR_ITEM_REGULAR),

			list("SIDEARMS", 0, null, null, null),
			list("88 Mod 4 Combat Pistol", 15, /obj/item/weapon/gun/pistol/mod88, null, VENDOR_ITEM_REGULAR),
			list("Beretta 92FS Pistol", 15, /obj/item/weapon/gun/pistol/b92fs, null, VENDOR_ITEM_REGULAR),
			list("CMB Spearhead Autorevolver", 15, /obj/item/weapon/gun/revolver/cmb, null, VENDOR_ITEM_REGULAR),
			list("Holdout Pistol", 10, /obj/item/weapon/gun/pistol/holdout, null, VENDOR_ITEM_REGULAR),
			list("KT-42 Automag", 15, /obj/item/weapon/gun/pistol/kt42, null, VENDOR_ITEM_REGULAR),
			list("S&W .357 Revolver", 15, /obj/item/weapon/gun/revolver/small, null, VENDOR_ITEM_REGULAR),

			list("SIDEARM AMMUNITION", 0, null, null, null),
			list("88M4 AP Magazine (9mm)", 5, /obj/item/ammo_magazine/pistol/mod88, null, VENDOR_ITEM_REGULAR),
			list("Beretta 92FS Magazine (9mm)", 5, /obj/item/ammo_magazine/pistol/b92fs, null, VENDOR_ITEM_REGULAR),
			list("KT-42 Magazine (.44)", 5, /obj/item/ammo_magazine/pistol/automatic, null, VENDOR_ITEM_REGULAR),
			list("Spearhead Speed Loader (.357)", 5, /obj/item/ammo_magazine/revolver/cmb, null, VENDOR_ITEM_REGULAR),
			list("S&W Speed Loader (.357)", 5, /obj/item/ammo_magazine/revolver/small, null, VENDOR_ITEM_REGULAR),
			list("Tiny Pistol Magazine (.22)", 5, /obj/item/ammo_magazine/pistol/holdout, null, VENDOR_ITEM_REGULAR),

			list("ATTACHMENTS", 0, null, null, null),
			list("2x Hunting Mini-Scope", 20, /obj/item/attachable/scope/mini/hunting, null, VENDOR_ITEM_REGULAR),
			list("Angled Grip", 15, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
			list("Burst Fire Assembly", 15, /obj/item/attachable/burstfire_assembly, null, VENDOR_ITEM_REGULAR),
			list("Extended Barrel", 15, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
			list("Laser Sight", 15, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
			list("Quickfire Adapter", 15, /obj/item/attachable/quickfire, null, VENDOR_ITEM_REGULAR),
			list("Rail Flashlight", 5, /obj/item/attachable/flashlight, null, VENDOR_ITEM_REGULAR),
			list("Red-Dot Sight", 15, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
			list("Reflex Sight", 15, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
			list("Suppressor", 15, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
			list("Vertical Grip", 15, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

			list("UTILITIES", 0, null, null, null),
			list("Type 80 Bayonet", 3, /obj/item/attachable/bayonet/upp, null, VENDOR_ITEM_REGULAR),
			list("Lunge Mine", 120, /obj/item/weapon/melee/twohanded/lungemine, null, VENDOR_ITEM_REGULAR),
			list("Melee Weapon (Random)", 7, /obj/effect/essentials_set/random/clf_melee, null, VENDOR_ITEM_REGULAR),
			list("M94 Marking Flare Pack", 3, /obj/item/storage/box/m94, null, VENDOR_ITEM_RECOMMENDED),
			list("Smoke Grenade", 7, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR)
		)
	)

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

	var/list/products_sets = list()
	if(listed_products.Find(H.faction))			//just in case
		products_sets = listed_products[H.faction]
	else
		products_sets = listed_products[FACTION_CLF]

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

/obj/structure/machinery/cm_vending/gear/antag_guns/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(stat & (BROKEN|NOPOWER))
		return
	if(usr.is_mob_incapacitated())
		return

	if(in_range(src, usr) && isturf(loc) && ishuman(usr))
		usr.set_interaction(src)
		if (href_list["vend"])

			var/mob/living/carbon/human/H = usr

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

			if(LAZYLEN(vendor_role) && !vendor_role.Find(H.job))
				to_chat(H, SPAN_WARNING("This machine isn't for you."))
				vend_fail()
				return

			var/idx=text2num(href_list["vend"])
			var/list/L = listed_products[H.faction][idx]
			var/cost = L[2]

			if((!H.assigned_squad && squad_tag) || (squad_tag && H.assigned_squad.name != squad_tag))
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

		add_fingerprint(usr)
		ui_interact(usr) //updates the nanoUI window

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
		vending_stat_bump(prod_type, src.type)
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
