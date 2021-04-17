//------------ADAPTIVE ANTAG SORTED GUNS VENDOR---------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns/antag_guns
	name = "\improper Suspicious Automated Guns Rack"
	desc = "While similar in function to ColMarTech automated racks, this one is clearly not of USCM origin. Contains various weapons."
	icon_state = "antag_guns"
	vendor_role = VENDOR_ANTAG_JOBS
	req_access = list(ACCESS_ILLEGAL_PIRATE)

	listed_products = list(

		FACTION_UPP = list(

			list("PRIMARY FIREARMS", -1, null, null),
			list("CZ-81 Machine Pistol", 20, /obj/item/weapon/gun/pistol/skorpion/upp, VENDOR_ITEM_REGULAR),
			list("Type 71 Pulse Rifle", 20, /obj/item/weapon/gun/rifle/type71, VENDOR_ITEM_REGULAR),
			list("Type 71 Pulse Rifle Carbine", 20, /obj/item/weapon/gun/rifle/type71/carbine, VENDOR_ITEM_REGULAR),

			list("PRIMARY AMMUNITION", -1, null, null),
			list("CZ-81 Magazine (.32ACP)", 60, /obj/item/ammo_magazine/pistol/skorpion, VENDOR_ITEM_REGULAR),
			list("Type 71 AP Magazine (5.45x39mm)", 60, /obj/item/ammo_magazine/rifle/type71/ap, VENDOR_ITEM_REGULAR),
			list("Type 71 Magazine (5.45x39mm)", 60, /obj/item/ammo_magazine/rifle/type71, VENDOR_ITEM_REGULAR),

			list("SIDEARMS", -1, null, null),
			list("Highpower Automag", 20, /obj/item/weapon/gun/pistol/highpower, VENDOR_ITEM_REGULAR),
			list("Korovin PK-9 Pistol", 20, /obj/item/weapon/gun/pistol/c99/upp, VENDOR_ITEM_REGULAR),
			list("N-Y 7.62mm Revolver", 20, /obj/item/weapon/gun/revolver/nagant, VENDOR_ITEM_REGULAR),

			list("SIDEARM AMMUNITION", -1, null, null),
			list("Highpower Magazine (9mm)", 40, /obj/item/ammo_magazine/pistol/highpower, VENDOR_ITEM_REGULAR),
			list("N-Y Speed Loader (7.62x38mmR)", 40, /obj/item/ammo_magazine/revolver/upp, VENDOR_ITEM_REGULAR),
			list("PK-9 Magazine (.22 Hollowpoint)", 40, /obj/item/ammo_magazine/pistol/c99, VENDOR_ITEM_REGULAR),

			list("UTILITIES", -1, null, null),
			list("M94 Marking Flare Pack", 20, /obj/item/storage/box/m94, VENDOR_ITEM_RECOMMENDED),
			list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, VENDOR_ITEM_REGULAR),
			list("Type 80 Bayonet", 40, /obj/item/attachable/bayonet/upp, VENDOR_ITEM_REGULAR),
		),

		FACTION_CLF = list(

			list("PRIMARY FIREARMS", -1, null, null),
			list("Basira-Armstrong Rifle", 20, /obj/item/weapon/gun/rifle/hunting, VENDOR_ITEM_REGULAR),
			list("CZ-81 Machine Pistol", 20, /obj/item/ammo_magazine/pistol/skorpion, VENDOR_ITEM_REGULAR),
			list("Double Barrel Shotgun", 20, /obj/item/weapon/gun/shotgun/double, VENDOR_ITEM_REGULAR),
			list("HG 37-12 Pump Shotgun", 20, /obj/item/weapon/gun/shotgun/double/sawn, VENDOR_ITEM_REGULAR),
			list("M16 Rifle", 20, /obj/item/weapon/gun/rifle/m16, VENDOR_ITEM_REGULAR),
			list("MAC-15 Submachinegun", 20, /obj/item/weapon/gun/smg/uzi, VENDOR_ITEM_REGULAR),
			list("MAR-30 Battle Carbine", 20, /obj/item/weapon/gun/rifle/mar40/carbine, VENDOR_ITEM_REGULAR),
			list("MAR-40 Battle Rifle", 20, /obj/item/weapon/gun/rifle/mar40, VENDOR_ITEM_REGULAR),
			list("MP27 Submachinegun", 20, /obj/item/weapon/gun/smg/mp7, VENDOR_ITEM_REGULAR),
			list("MP5 Submachinegun", 20, /obj/item/weapon/gun/smg/mp5, VENDOR_ITEM_REGULAR),
			list("Sawn-Off Shotgun", 20, /obj/item/weapon/gun/shotgun/pump/cmb, VENDOR_ITEM_REGULAR),

			list("PRIMARY AMMUNITION", -1, null, null),
			list("Basira-Armstrong Magazine (6.5mm)", 60, /obj/item/ammo_magazine/rifle/hunting, VENDOR_ITEM_REGULAR),
			list("Box Of Buckshot Shells", 15, /obj/item/ammo_magazine/shotgun/buckshot, VENDOR_ITEM_REGULAR),
			list("Box Of Flechette Shells", 15, /obj/item/ammo_magazine/shotgun/flechette, VENDOR_ITEM_REGULAR),
			list("Box Of Shotgun Slugs", 15, /obj/item/ammo_magazine/shotgun, VENDOR_ITEM_REGULAR),
			list("CZ-81 Magazine (.32ACP)", 60, /obj/item/ammo_magazine/pistol/skorpion, VENDOR_ITEM_REGULAR),
			list("M16 AP Magazine (5.56x45mm)", 10, /obj/item/ammo_magazine/rifle/m16/ap, VENDOR_ITEM_REGULAR),
			list("M16 Magazine (5.56x45mm)", 60, /obj/item/ammo_magazine/rifle/m16, VENDOR_ITEM_REGULAR),
			list("MAC-15 Magazine (9mm)", 60, /obj/item/ammo_magazine/smg/uzi, VENDOR_ITEM_REGULAR),
			list("MAR Magazine (7.62x39mm)", 60, /obj/item/ammo_magazine/rifle/mar40, VENDOR_ITEM_REGULAR),
			list("MAR Extended Magazine (7.62x39mm)", 10, /obj/item/ammo_magazine/rifle/mar40/extended, VENDOR_ITEM_REGULAR),
			list("MP27 Magazine (4.6x30mm)", 60, /obj/item/ammo_magazine/smg/mp7, VENDOR_ITEM_REGULAR),
			list("MP5 Magazine (9mm)", 60, /obj/item/ammo_magazine/smg/mp5, VENDOR_ITEM_REGULAR),

			list("SIDEARMS", -1, null, null),
			list("88 Mod 4 Combat Pistol", 20, /obj/item/weapon/gun/pistol/mod88, VENDOR_ITEM_REGULAR),
			list("Beretta 92FS Pistol", 20, /obj/item/weapon/gun/pistol/b92fs, VENDOR_ITEM_REGULAR),
			list("CMB Spearhead Autorevolver", 20, /obj/item/weapon/gun/revolver/cmb, VENDOR_ITEM_REGULAR),
			list("Holdout Pistol", 20, /obj/item/weapon/gun/pistol/holdout, VENDOR_ITEM_REGULAR),
			list("KT-42 Automag", 20, /obj/item/weapon/gun/pistol/kt42, VENDOR_ITEM_REGULAR),
			list("S&W .357 Revolver", 20, /obj/item/weapon/gun/revolver/small, VENDOR_ITEM_REGULAR),

			list("SIDEARM AMMUNITION", -1, null, null),
			list("88M4 AP Magazine (9mm)", 40, /obj/item/ammo_magazine/pistol/mod88, VENDOR_ITEM_REGULAR),
			list("Beretta 92FS Magazine (9mm)", 40, /obj/item/ammo_magazine/pistol/b92fs, VENDOR_ITEM_REGULAR),
			list("KT-42 Magazine (.44)", 40, /obj/item/ammo_magazine/pistol/automatic, VENDOR_ITEM_REGULAR),
			list("Spearhead Speed Loader (.357)", 40, /obj/item/ammo_magazine/revolver/cmb, VENDOR_ITEM_REGULAR),
			list("S&W Speed Loader (.357)", 40, /obj/item/ammo_magazine/revolver/small, VENDOR_ITEM_REGULAR),
			list("Tiny Pistol Magazine (.22)", 40, /obj/item/ammo_magazine/pistol/holdout, VENDOR_ITEM_REGULAR),

			list("MELEE WEAPONS", -1, null, null),
			list("Baseball Bat", 10, /obj/item/weapon/melee/baseballbat, VENDOR_ITEM_REGULAR),
			list("Baseball Bat (Metal)", 5, /obj/item/weapon/melee/baseballbat/metal, VENDOR_ITEM_REGULAR),
			list("Fireaxe", 5, /obj/item/weapon/melee/twohanded/fireaxe, VENDOR_ITEM_REGULAR),
			list("Hatchet", 15, /obj/item/tool/hatchet, VENDOR_ITEM_REGULAR),
			list("Spear", 10, /obj/item/weapon/melee/twohanded/spear, VENDOR_ITEM_REGULAR),

			list("UTILITIES", -1, null, null),
			list("M94 Marking Flare Pack", 20, /obj/item/storage/box/m94, VENDOR_ITEM_REGULAR),
			list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, VENDOR_ITEM_REGULAR),
			list("Type 80 Bayonet", 40, /obj/item/attachable/bayonet/upp, VENDOR_ITEM_REGULAR),
		)
	)

/obj/structure/machinery/cm_vending/sorted/cargo_guns/antag_guns/populate_product_list(var/scale)
	return

/obj/structure/machinery/cm_vending/sorted/cargo_guns/antag_guns/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 0)

	if(!ishuman(user))
		return

	var/list/display_list = list()

	if(!LAZYLEN(listed_products))	//runtimed for vendors without goods in them
		to_chat(user, SPAN_WARNING("Vendor wasn't properly initialized, tell an admin!."))
		return

	var/mob/living/carbon/human/H = user
	var/list/products_sets = list()
	if(listed_products.Find(H.faction))			//just in case
		products_sets = listed_products[H.faction]
	else
		products_sets = listed_products[FACTION_CLF]

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

/obj/structure/machinery/cm_vending/sorted/cargo_guns/antag_guns/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(inoperable())
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
			if(!istype(I))
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

		add_fingerprint(usr)
		ui_interact(usr) //updates the nanoUI window
