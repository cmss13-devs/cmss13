//------------REQ VENDORS AND THEIR SQUAD VARIANTS---------------

//------------ARMAMENTS VENDOR---------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns
	name = "\improper ColMarTech Automated Armaments Vendor"
	desc = "An automated supply rack hooked up to a big storage of various firearms and explosives. Can be accessed by the Requisitions Officer and Cargo Techs."
	icon_state = "req_guns"
	req_access = list(ACCESS_MARINE_CARGO)
	vendor_theme = VENDOR_THEME_USCM

/obj/structure/machinery/cm_vending/sorted/cargo_guns/Initialize()
	. = ..()
	GLOB.cm_vending_vendors += src

/obj/structure/machinery/cm_vending/sorted/cargo_guns/Destroy()
	GLOB.cm_vending_vendors -= src
	return ..()

/obj/structure/machinery/cm_vending/sorted/cargo_guns/vend_fail()
	return

/obj/structure/machinery/cm_vending/sorted/cargo_guns/populate_product_list(var/scale)
	listed_products = list(
		list("PRIMARY FIREARMS", -1, null, null),
		list("M37A2 Pump Shotgun", round(scale * 10), /obj/item/weapon/gun/shotgun/pump, VENDOR_ITEM_REGULAR),
		list("M39 Submachinegun", round(scale * 15), /obj/item/weapon/gun/smg/m39, VENDOR_ITEM_REGULAR),
		list("M41A Pulse Rifle MK2", round(scale * 20), /obj/item/weapon/gun/rifle/m41a, VENDOR_ITEM_REGULAR),
		list("L42A Battle Rifle", round(scale * 20), /obj/item/weapon/gun/rifle/l42a, VENDOR_ITEM_REGULAR),

		list("SIDEARMS", -1, null, null),
		list("88 Mod 4 Combat Pistol", round(scale * 15), /obj/item/weapon/gun/pistol/mod88, VENDOR_ITEM_REGULAR),
		list("M44 Combat Revolver", round(scale * 10), /obj/item/weapon/gun/revolver/m44, VENDOR_ITEM_REGULAR),
		list("M4A3 Service Pistol", round(scale * 20), /obj/item/weapon/gun/pistol/m4a3, VENDOR_ITEM_REGULAR),
		list("M82F Flare Gun", round(scale * 8), /obj/item/weapon/gun/flare, VENDOR_ITEM_REGULAR),

		list("RESTRICTED FIREARMS", -1, null, null),
		list("VP78 Pistol", round(scale * 4), /obj/item/storage/box/guncase/vp78, VENDOR_ITEM_REGULAR),
		list("SU-6 Smart Pistol", round(scale * 3), /obj/item/storage/box/guncase/smartpistol, VENDOR_ITEM_REGULAR),
		list("MOU-53 Shotgun", round(scale * 2), /obj/item/storage/box/guncase/mou53, VENDOR_ITEM_REGULAR),
		list("XM88 Heavy Rifle", round(scale * 3), /obj/item/storage/box/guncase/xm88, VENDOR_ITEM_REGULAR),
		list("M41AE2 Heavy Pulse Rifle", round(scale * 2), /obj/item/storage/box/guncase/lmg, VENDOR_ITEM_REGULAR),
		list("M41A Pulse Rifle MK1", round(scale * 3), /obj/item/storage/box/guncase/m41aMK1, VENDOR_ITEM_REGULAR),
		list("M56D Heavy Machine Gun", round(scale * 2), /obj/item/storage/box/guncase/m56d, VENDOR_ITEM_REGULAR),
		list("M2C Heavy Machine Gun", round(scale * 2), /obj/item/storage/box/guncase/m2c, VENDOR_ITEM_REGULAR),
		list("M240 Incinerator Unit", round(scale * 2), /obj/item/storage/box/guncase/flamer, VENDOR_ITEM_REGULAR),
		list("M79 Grenade Launcher", round(scale * 3), /obj/item/storage/box/guncase/m79, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", -1, null, null),
		list("M15 Fragmentation Grenade", round(scale * 2), /obj/item/explosive/grenade/HE/m15, VENDOR_ITEM_REGULAR),
		list("M20 Claymore Anti-Personnel Mine", round(scale * 4), /obj/item/explosive/mine, VENDOR_ITEM_REGULAR),
		list("M40 HEDP Grenade Box", round(scale * 1), /obj/item/storage/box/nade_box, VENDOR_ITEM_REGULAR),
		list("M40 HIDP Incendiary Grenade", round(scale * 4), /obj/item/explosive/grenade/incendiary, VENDOR_ITEM_REGULAR),
		list("M40 HPDP White Phosphorus Smoke Grenade", round(scale * 4), /obj/item/explosive/grenade/phosphorus, VENDOR_ITEM_REGULAR),
		list("M40 HSDP Smoke Grenade", round(scale * 5), /obj/item/explosive/grenade/smokebomb, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Frag Airburst Grenade", round(scale * 4), /obj/item/explosive/grenade/HE/airburst, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Icendiary Airburst Grenade", round(scale * 4), /obj/item/explosive/grenade/incendiary/airburst, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Smoke Airburst Grenade", round(scale * 4), /obj/item/explosive/grenade/smokebomb/airburst, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Star Shell", round(scale * 2), /obj/item/explosive/grenade/HE/airburst/starshell, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Hornet Shell", round(scale * 4), /obj/item/explosive/grenade/HE/airburst/hornet_shell, VENDOR_ITEM_REGULAR),
		list("M40 HIRR Baton Slug", round(scale * 8), /obj/item/explosive/grenade/slug/baton, VENDOR_ITEM_REGULAR),
		list("M40 MFHS Metal Foam Grenade", round(scale * 3), /obj/item/explosive/grenade/metal_foam, VENDOR_ITEM_REGULAR),
		list("Plastic Explosives", round(scale * 3), /obj/item/explosive/plastic, VENDOR_ITEM_REGULAR),
		list("Breaching Charge", round(scale * 2), /obj/item/explosive/plastic/breaching_charge, VENDOR_ITEM_REGULAR),

		list("WEBBINGS", -1, null, null),
		list("Black Webbing Vest", round(scale * 2), /obj/item/clothing/accessory/storage/black_vest, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", round(scale * 2), /obj/item/clothing/accessory/storage/black_vest/brown_vest, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", round(scale * 1.5), /obj/item/clothing/accessory/storage/holster, VENDOR_ITEM_REGULAR),
		list("Webbing", round(scale * 5), /obj/item/clothing/accessory/storage/webbing, VENDOR_ITEM_REGULAR),
		list("Knife Webbing", round(scale * 1), /obj/item/clothing/accessory/storage/knifeharness, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", round(scale * 2), /obj/item/clothing/accessory/storage/droppouch, VENDOR_ITEM_REGULAR),

		list("BACKPACKS", -1, null, null),
		list("Lightweight IMP Backpack", round(scale * 15), /obj/item/storage/backpack/marine, VENDOR_ITEM_REGULAR),
		list("Shotgun Scabbard", round(scale * 10), /obj/item/storage/large_holster/m37, VENDOR_ITEM_REGULAR),
		list("Pyrotechnician G4-1 Fueltank", round(scale * 2), /obj/item/storage/backpack/marine/engineerpack/flamethrower/kit, VENDOR_ITEM_REGULAR),
		list("Technician Welderpack", round(scale * 2), /obj/item/storage/backpack/marine/engineerpack, VENDOR_ITEM_REGULAR),
		list("Mortar Shell Backpack", round(scale * 1), /obj/item/storage/backpack/marine/mortarpack, VENDOR_ITEM_REGULAR),
		list("Technician Welder-Satchel", round(scale * 5), /obj/item/storage/backpack/marine/engineerpack/satchel, VENDOR_ITEM_REGULAR),
		list("Small Radio Telephone Pack", round(scale * 4), /obj/item/storage/backpack/marine/satchel/rto/small, VENDOR_ITEM_REGULAR),

		list("BELTS", -1, null, null),
		list("G8-A General Utility Pouch", round(scale * 2), /obj/item/storage/backpack/general_belt, VENDOR_ITEM_REGULAR),
		list("M276 Ammo Load Rig", round(scale * 15), /obj/item/storage/belt/marine, VENDOR_ITEM_REGULAR),
		list("M276 General Pistol Holster Rig", round(scale * 10), /obj/item/storage/belt/gun/m4a3, VENDOR_ITEM_REGULAR),
		list("M276 Knife Rig", round(scale * 5), /obj/item/storage/belt/knifepouch, VENDOR_ITEM_REGULAR),
		list("M276 M39 Holster Rig", round(scale * 5), /obj/item/storage/large_holster/m39, VENDOR_ITEM_REGULAR),
		list("M276 M40 Grenade Rig", round(scale * 2), /obj/item/storage/belt/grenade, VENDOR_ITEM_REGULAR),
		list("M276 M44 Holster Rig", round(scale * 5), /obj/item/storage/belt/gun/m44, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", round(scale * 2), /obj/item/storage/belt/gun/flaregun, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", round(scale * 10), /obj/item/storage/belt/shotgun, VENDOR_ITEM_REGULAR),
		list("M276 Mortar Operator Belt", round(scale * 2), /obj/item/storage/belt/gun/mortarbelt, VENDOR_ITEM_REGULAR),
		list("Rappel Harness", round(scale * 20), /obj/item/rappel_harness, VENDOR_ITEM_REGULAR),

		list("POUCHES", -1, null, null),
		list("Autoinjector Pouch", round(scale * 2), /obj/item/storage/pouch/autoinjector, VENDOR_ITEM_REGULAR),
		list("Construction Pouch", round(scale * 2), /obj/item/storage/pouch/construction, VENDOR_ITEM_REGULAR),
		list("Document Pouch", round(scale * 2), /obj/item/storage/pouch/document/small, VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", round(scale * 2), /obj/item/storage/pouch/explosive, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Full)", round(scale * 5), /obj/item/storage/pouch/firstaid/full, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", round(scale * 2), /obj/item/storage/pouch/first_responder, VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", round(scale * 5), /obj/item/storage/pouch/flare/full, VENDOR_ITEM_REGULAR),
		list("Fuel Tank Strap Pouch", round(scale * 4), /obj/item/storage/pouch/flamertank, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", round(scale * 5), /obj/item/storage/pouch/magazine/pistol/large, VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", round(scale * 5), /obj/item/storage/pouch/magazine, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Pouch", round(scale * 5), /obj/item/storage/pouch/shotgun, VENDOR_ITEM_REGULAR),
		list("Machete Pouch (Full)", round(scale * 4), /obj/item/storage/pouch/machete/full, VENDOR_ITEM_REGULAR),
		list("Medical Pouch", round(scale * 2), /obj/item/storage/pouch/medical, VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", round(scale * 2), /obj/item/storage/pouch/general/medium, VENDOR_ITEM_REGULAR),
		list("Medkit Pouch", round(scale * 2), /obj/item/storage/pouch/medkit, VENDOR_ITEM_REGULAR),
		list("Sidearm Pouch", round(scale * 5), /obj/item/storage/pouch/pistol, VENDOR_ITEM_REGULAR),
		list("Syringe Pouch", round(scale * 2), /obj/item/storage/pouch/syringe, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", round(scale * 2), /obj/item/storage/pouch/tools/full, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", round(scale * 2), /obj/item/storage/pouch/sling, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", round(scale * 2), /obj/item/storage/pouch/magazine/large, VENDOR_ITEM_REGULAR),
		list("Large Shotgun Shell Pouch", round(scale * 2), /obj/item/storage/pouch/shotgun/large, VENDOR_ITEM_REGULAR),

		list("MISCELLANEOUS", -1, null, null),
		list("Combat Flashlight", round(scale * 5), /obj/item/device/flashlight/combat, VENDOR_ITEM_REGULAR),
		list("Entrenching Tool", round(scale * 4), /obj/item/tool/shovel/etool, VENDOR_ITEM_REGULAR),
		list("Gas Mask", round(scale * 10), /obj/item/clothing/mask/gas, VENDOR_ITEM_REGULAR),
		list("M89-S Signal Flare Pack", round(scale * 2), /obj/item/storage/box/m94/signal, VENDOR_ITEM_REGULAR),
		list("M94 Marking Flare Pack", round(scale * 10), /obj/item/storage/box/m94, VENDOR_ITEM_REGULAR),
		list("Machete Scabbard (Full)", round(scale * 6), /obj/item/storage/large_holster/machete/full, VENDOR_ITEM_REGULAR),
		list("MB-6 Folding Barricades (x3)", round(scale * 3), /obj/item/stack/folding_barricade/three, VENDOR_ITEM_REGULAR),
		list("Motion Detector", round(scale * 4), /obj/item/device/motiondetector, VENDOR_ITEM_REGULAR),
		list("Data Detector", round(scale * 4), /obj/item/device/motiondetector/intel, VENDOR_ITEM_REGULAR),
		list("Binoculars", round(scale * 2), /obj/item/device/binoculars, VENDOR_ITEM_REGULAR),
		list("Rangefinder", round(scale * 1), /obj/item/device/binoculars/range, VENDOR_ITEM_REGULAR),
		list("Laser Designator", round(scale * 1), /obj/item/device/binoculars/range/designator, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", round(scale * 3), /obj/item/clothing/glasses/welding, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", round(scale * 3), /obj/item/tool/extinguisher/mini, VENDOR_ITEM_REGULAR),
		list("Fulton Device Stack", round(scale * 1), /obj/item/stack/fulton, VENDOR_ITEM_REGULAR),
		list("JTAC Pamphlet", round(scale * 1), /obj/item/pamphlet/skill/jtac, VENDOR_ITEM_REGULAR),
		list("Engineering Pamphlet", round(scale * 1), /obj/item/pamphlet/skill/engineer, VENDOR_ITEM_REGULAR),
		list("Powerloader Certification", round(scale * 0.1), /obj/item/pamphlet/skill/powerloader, VENDOR_ITEM_REGULAR),
		)

/obj/structure/machinery/cm_vending/sorted/cargo_guns/stock(obj/item/item_to_stock, mob/user)
	if(istype(item_to_stock, /obj/item/storage) && !istype(item_to_stock, /obj/item/storage/box/m94) && !istype(item_to_stock, /obj/item/storage/large_holster/machete))
		to_chat(user, SPAN_WARNING("Can't restock \the [item_to_stock]."))
		return

	//this below is in case we have subtype of an object, that SHOULD be treated as parent object (like /empty ammo box)
	var/corrected_path = return_corresponding_type(item_to_stock.type)

	var/list/R
	for(R in (listed_products))
		if(item_to_stock.type == R[3] || corrected_path && corrected_path == R[3])
			if(istype(item_to_stock, /obj/item/ammo_magazine/flamer_tank))
				var/obj/item/ammo_magazine/flamer_tank/FT = item_to_stock
				if(FT.flamer_chem != initial(FT.flamer_chem))
					to_chat(user, SPAN_WARNING("\The [FT] contains non-standard fuel."))
					return

			//Guns handling
			if(isgun(item_to_stock))
				var/obj/item/weapon/gun/G = item_to_stock
				if(G.in_chamber || (G.current_mag && !istype(G.current_mag, /obj/item/ammo_magazine/internal)) || (istype(G.current_mag, /obj/item/ammo_magazine/internal) && G.current_mag.current_rounds > 0) )
					to_chat(user, SPAN_WARNING("[G] is still loaded. Unload it before you can restock it."))
					return
				for(var/obj/item/attachable/A in G.contents) //Search for attachments on the gun. This is the easier method
					if((A.flags_attach_features & ATTACH_REMOVABLE) && !(is_type_in_list(A, G.starting_attachment_types))) //There are attachments that are default and others that can't be removed
						to_chat(user, SPAN_WARNING("[G] has non-standard attachments equipped. Detach them before you can restock it."))
						return
			//various stacks handling
			else if(istype(item_to_stock, /obj/item/stack/folding_barricade))
				var/obj/item/stack/folding_barricade/B = item_to_stock
				if(B.amount != 3)
					to_chat(user, SPAN_WARNING("[B]s are being stored in [SPAN_HELPFUL("stacks of 3")] for convenience. Add to \the [B] stack to make it a stack of 3 before restocking."))
					return
			//M94 flare packs handling
			else if(istype(item_to_stock, /obj/item/storage/box/m94))
				var/obj/item/storage/box/m94/flare_pack = item_to_stock
				if(flare_pack.contents.len < flare_pack.max_storage_space)
					to_chat(user, SPAN_WARNING("\The [item_to_stock] is not full."))
					return
				var/flare_type
				if(istype(item_to_stock, /obj/item/storage/box/m94/signal))
					flare_type = /obj/item/device/flashlight/flare/signal
				else
					flare_type = /obj/item/device/flashlight/flare
				for(var/obj/item/device/flashlight/flare/F in flare_pack.contents)
					if(F.fuel < 1)
						to_chat(user, SPAN_WARNING("Some flares in \the [F] are used."))
						return
					if(F.type != flare_type)
						to_chat(user, SPAN_WARNING("Some flares in \the [F] are not of the correct type."))
						return
			//Machete holsters handling
			else if(istype(item_to_stock, /obj/item/storage/large_holster/machete))
				var/obj/item/weapon/melee/claymore/mercsword/machete/Mac = locate(/obj/item/weapon/melee/claymore/mercsword/machete) in item_to_stock
				if(!Mac)
					to_chat(user, SPAN_WARNING("\The [item_to_stock] is empty."))
					return

			if(item_to_stock.loc == user) //Inside the mob's inventory
				if(item_to_stock.flags_item & WIELDED)
					item_to_stock.unwield(user)
				user.temp_drop_inv_item(item_to_stock)

			if(isstorage(item_to_stock.loc)) //inside a storage item
				var/obj/item/storage/S = item_to_stock.loc
				S.remove_from_storage(item_to_stock, user.loc)

			qdel(item_to_stock)
			user.visible_message(SPAN_NOTICE("[user] stocks [src] with \a [R[1]]."),
			SPAN_NOTICE("You stock [src] with \a [R[1]]."))
			R[2]++
			updateUsrDialog()
			return //We found our item, no reason to go on.

/obj/structure/machinery/cm_vending/sorted/cargo_guns/blend
	icon_state = "req_guns_wall"
	tiles_with = list(
		/obj/structure/window/framed/almayer,
		/obj/structure/machinery/door/airlock,
		/turf/closed/wall/almayer)

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad
	name = "\improper ColMarTech Automated Armaments Squad Vendor"
	desc = "An automated supply rack hooked up to a small storage of various firearms and explosives. Can be accessed by any Marine Rifleman."
	req_access = list(ACCESS_MARINE_ALPHA)
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_RO)
	hackable = TRUE

	vend_x_offset = 2
	vend_y_offset = 1

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad/populate_product_list(var/scale)
	listed_products = list(
		list("WEBBINGS", -1, null, null),
		list("Brown Webbing Vest", round(scale * 2), /obj/item/clothing/accessory/storage/black_vest/brown_vest, VENDOR_ITEM_REGULAR),
		list("Black Webbing Vest", round(scale * 1), /obj/item/clothing/accessory/storage/black_vest, VENDOR_ITEM_REGULAR),
		list("Webbing", round(scale * 3), /obj/item/clothing/accessory/storage/webbing, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", round(scale * 1), /obj/item/clothing/accessory/storage/droppouch, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", round(scale * 1), /obj/item/clothing/accessory/storage/holster, VENDOR_ITEM_REGULAR),

		list("BACKPACKS", -1, null, null),
		list("Lightweight IMP Backpack", round(scale * 15), /obj/item/storage/backpack/marine, VENDOR_ITEM_REGULAR),
		list("Shotgun Scabbard", round(scale * 5), /obj/item/storage/large_holster/m37, VENDOR_ITEM_REGULAR),
		list("USCM Technician Welderpack", round(scale * 2), /obj/item/storage/backpack/marine/engineerpack, VENDOR_ITEM_REGULAR),
		list("Technician Welder-Satchel", round(scale * 3), /obj/item/storage/backpack/marine/engineerpack/satchel, VENDOR_ITEM_REGULAR),
		list("Small Radio Telephone Backpack", round(scale * 2), /obj/item/storage/backpack/marine/satchel/rto/small, VENDOR_ITEM_REGULAR),

		list("BELTS", -1, null, null),
		list("G8-A General Utility Pouch", round(scale * 2), /obj/item/storage/backpack/general_belt, VENDOR_ITEM_REGULAR),
		list("M276 General Pistol Holster Rig", round(scale * 10), /obj/item/storage/belt/gun/m4a3, VENDOR_ITEM_REGULAR),
		list("M276 M39 Holster Rig", round(scale * 2), /obj/item/storage/large_holster/m39, VENDOR_ITEM_REGULAR),
		list("M276 M44 Holster Rig", round(scale * 5), /obj/item/storage/belt/gun/m44, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", round(scale * 2), /obj/item/storage/belt/gun/flaregun, VENDOR_ITEM_REGULAR),
		list("M276 M40 Grenade Rig", round(scale * 3), /obj/item/storage/belt/grenade, VENDOR_ITEM_REGULAR),

		list("POUCHES", -1, null, null),
		list("Construction Pouch", round(scale * 2), /obj/item/storage/pouch/construction, VENDOR_ITEM_REGULAR),
		list("Document Pouch", round(scale * 2), /obj/item/storage/pouch/document/small, VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", round(scale * 2), /obj/item/storage/pouch/explosive, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Full)", round(scale * 5), /obj/item/storage/pouch/firstaid/full, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch (Empty)", round(scale * 4), /obj/item/storage/pouch/first_responder, VENDOR_ITEM_REGULAR),
		list("Flare Pouch", round(scale * 5), /obj/item/storage/pouch/flare/full, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", round(scale * 3), /obj/item/storage/pouch/magazine/pistol/large, VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", round(scale * 5), /obj/item/storage/pouch/magazine, VENDOR_ITEM_REGULAR),
		list("Medical Pouch (Empty)", round(scale * 4), /obj/item/storage/pouch/medical, VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", round(scale * 2), /obj/item/storage/pouch/general/medium, VENDOR_ITEM_REGULAR),
		list("Medkit Pouch", round(scale * 2), /obj/item/storage/pouch/medkit, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Pouch", round(scale *5), /obj/item/storage/pouch/shotgun, VENDOR_ITEM_REGULAR),
		list("Sidearm Pouch", round(scale * 15), /obj/item/storage/pouch/pistol, VENDOR_ITEM_REGULAR),
		list("Syringe Pouch", round(scale * 2), /obj/item/storage/pouch/syringe, VENDOR_ITEM_REGULAR),
		list("Tools Pouch", round(scale * 2), /obj/item/storage/pouch/tools, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", round(scale * 2), /obj/item/storage/pouch/sling, VENDOR_ITEM_REGULAR),

		list("MISCELLANEOUS", -1, null, null),
		list("Combat Flashlight", round(scale * 5), /obj/item/device/flashlight/combat, VENDOR_ITEM_REGULAR),
		list("Entrenching Tool (ET)", round(scale * 2), /obj/item/tool/shovel/etool, VENDOR_ITEM_REGULAR),
		list("M89-S Signal Flare Pack", round(scale * 1), /obj/item/storage/box/m94/signal, VENDOR_ITEM_REGULAR),
		list("Machete Scabbard (Full)", round(scale * 5), /obj/item/storage/large_holster/machete/full, VENDOR_ITEM_REGULAR),
		list("Binoculars", round(scale * 1), /obj/item/device/binoculars, VENDOR_ITEM_REGULAR),
		list("MB-6 Folding Barricades (x3)", round(scale * 2), /obj/item/stack/folding_barricade/three, VENDOR_ITEM_REGULAR),
		list("Spare PDT/L Battle Buddy Kit", round(scale * 1), /obj/item/storage/box/pdt_kit, VENDOR_ITEM_REGULAR)
		)

//------------AMMUNITION VENDOR---------------

/obj/structure/machinery/cm_vending/sorted/cargo_ammo
	name = "\improper ColMarTech Automated Munition Vendor"
	desc = "An automated supply rack hooked up to a big storage of various ammunition types. Can be accessed by the Requisitions Officer and Cargo Techs."
	icon_state = "req_ammo"
	req_access = list(ACCESS_MARINE_CARGO)
	vendor_theme = VENDOR_THEME_USCM

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/Initialize()
	. = ..()
	GLOB.cm_vending_vendors += src

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/Destroy()
	GLOB.cm_vending_vendors -= src
	return ..()

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/vend_fail()
	return

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/populate_product_list(var/scale)
	listed_products = list(
		list("REGULAR AMMUNITION", -1, null, null),
		list("Box Of Buckshot Shells", round(scale * 2), /obj/item/ammo_magazine/shotgun/buckshot, VENDOR_ITEM_REGULAR),
		list("Box Of Flechette Shells", round(scale * 2), /obj/item/ammo_magazine/shotgun/flechette, VENDOR_ITEM_REGULAR),
		list("Box Of Shotgun Slugs", round(scale * 2), /obj/item/ammo_magazine/shotgun/slugs, VENDOR_ITEM_REGULAR),
		list("L42A Magazine (10x24mm)", round(scale * 8), /obj/item/ammo_magazine/rifle/l42a, VENDOR_ITEM_REGULAR),
		list("M41A MK2 Magazine (10x24mm", round(scale * 10), /obj/item/ammo_magazine/rifle, VENDOR_ITEM_REGULAR),
		list("M39 HV Magazine (10x20mm)", round(scale * 7.5), /obj/item/ammo_magazine/smg/m39, VENDOR_ITEM_REGULAR),
		list("M44 Speed Loader (.44)", round(scale * 5.3), /obj/item/ammo_magazine/revolver, VENDOR_ITEM_REGULAR),
		list("M4A3 Magazine (9mm)", round(scale * 6.1), /obj/item/ammo_magazine/pistol, VENDOR_ITEM_REGULAR),

		list("ARMOR-PIERCING AMMUNITION", -1, null, null),
		list("88 Mod 4 AP Magazine (9mm)", round(scale * 5.5), /obj/item/ammo_magazine/pistol/mod88, VENDOR_ITEM_REGULAR),
		list("L42A AP Magazine (10x24mm)", round(scale * 4.5), /obj/item/ammo_magazine/rifle/l42a/ap, VENDOR_ITEM_REGULAR),
		list("M39 AP Magazine (10x20mm)", round(scale * 3.5), /obj/item/ammo_magazine/smg/m39/ap, VENDOR_ITEM_REGULAR),
		list("M41A MK2 AP Magazine (10x24mm)", round(scale * 3.5), /obj/item/ammo_magazine/rifle/ap, VENDOR_ITEM_REGULAR),
		list("M4A3 AP Magazine (9mm)", round(scale * 2), /obj/item/ammo_magazine/pistol/ap, VENDOR_ITEM_REGULAR),

		list("EXTENDED AMMUNITION", -1, null, null),
		list("M39 Extended Magazine (10x20mm)", round(scale * 2.5) + 3, /obj/item/ammo_magazine/smg/m39/extended, VENDOR_ITEM_REGULAR),
		list("M41A MK2 Extended Magazine (10x24mm)", round(scale * 2.5), /obj/item/ammo_magazine/rifle/extended, VENDOR_ITEM_REGULAR),

		list("SPECIAL AMMUNITION", -1, null, null),
		list("M56 Powerpack", 2, /obj/item/smartgun_powerpack, VENDOR_ITEM_REGULAR),
		list("M56 Smartgun Drum", 4, /obj/item/ammo_magazine/smartgun, VENDOR_ITEM_REGULAR),
		list("M44 Heavy Speed Loader (.44)", round(scale * 2.5), /obj/item/ammo_magazine/revolver/heavy, VENDOR_ITEM_REGULAR),
		list("M44 Marksman Speed Loader (.44)", round(scale * 2.5), /obj/item/ammo_magazine/revolver/marksman, VENDOR_ITEM_REGULAR),
		list("M4A3 HP Magazine (9mm)", round(scale * 2), /obj/item/ammo_magazine/pistol/hp, VENDOR_ITEM_REGULAR),
		list("M41AE2 Holo Target Rounds (10x24mm)", round(scale * 2), /obj/item/ammo_magazine/rifle/lmg/holo_target, VENDOR_ITEM_REGULAR),

		list("RESTRICTED FIREARM AMMUNITION", -1, null, null),
		list("VP78 Magazine", round(scale * 8), /obj/item/ammo_magazine/pistol/vp78, VENDOR_ITEM_REGULAR),
		list("SU-6 Smartpistol Magazine (.45)", round(scale * 8), /obj/item/ammo_magazine/pistol/smart, VENDOR_ITEM_REGULAR),
		list("M240 Incinerator Tank", round(scale * 3), /obj/item/ammo_magazine/flamer_tank, VENDOR_ITEM_REGULAR),
		list("M41AE2 Box Magazine (10x24mm)", round(scale * 3), /obj/item/ammo_magazine/rifle/lmg, VENDOR_ITEM_REGULAR),
		list("M41A MK1 Magazine (10x24mm)", round(scale * 4.5), /obj/item/ammo_magazine/rifle/m41aMK1, VENDOR_ITEM_REGULAR),
		list("M41A MK1 AP Magazine (10x24mm)", round(scale * 2), /obj/item/ammo_magazine/rifle/m41aMK1/ap, VENDOR_ITEM_REGULAR),
		list("M56D Drum Magazine", round(scale * 2), /obj/item/ammo_magazine/m56d, VENDOR_ITEM_REGULAR),
		list("M2C Box Magazine", round(scale * 2), /obj/item/ammo_magazine/m2c, VENDOR_ITEM_REGULAR),

		list("AMMUNITION BOXES", -1, null, null),
		list("Rifle Ammunition Box (10x24mm)", round(scale * 0.9), /obj/item/ammo_box/rounds, VENDOR_ITEM_REGULAR),
		list("Rifle Ammunition Box (10x24mm AP)", round(scale * 0.75), /obj/item/ammo_box/rounds/ap, VENDOR_ITEM_REGULAR),
		list("SMG Ammunition Box (10x20mm HV)", round(scale * 0.9), /obj/item/ammo_box/rounds/smg, VENDOR_ITEM_REGULAR),
		list("SMG Ammunition Box (10x20mm AP)", round(scale * 0.75), /obj/item/ammo_box/rounds/smg/ap, VENDOR_ITEM_REGULAR),
		list(".458 Bullets Box", round(scale * 0.5), /obj/item/ammo_box/magazine/lever_action/xm88, VENDOR_ITEM_REGULAR),

		list("MAGAZINE BOXES", -1, null, null),
		list("Magazine Box (88 Mod 4 AP x 16)", round(scale * 0.7), /obj/item/ammo_box/magazine/mod88, VENDOR_ITEM_REGULAR),
		list("Magazine Box (AP L42A x 16)", round(scale * 0.7), /obj/item/ammo_box/magazine/l42a/ap, VENDOR_ITEM_REGULAR),
		list("Magazine Box (AP M39 x 12)", round(scale * 0.7), /obj/item/ammo_box/magazine/m39/ap, VENDOR_ITEM_REGULAR),
		list("Magazine Box (AP M41A x 10)", round(scale * 0.7), /obj/item/ammo_box/magazine/ap, VENDOR_ITEM_REGULAR),
		list("Magazine Box (Ext M39 x 10)", round(scale * 0.7), /obj/item/ammo_box/magazine/m39/ext, VENDOR_ITEM_REGULAR),
		list("Magazine Box (Ext M41A x 8)", round(scale * 0.7), /obj/item/ammo_box/magazine/ext, VENDOR_ITEM_REGULAR),
		list("Magazine Box (L42A x 16)", round(scale * 0.8), /obj/item/ammo_box/magazine/l42a, VENDOR_ITEM_REGULAR),
		list("Magazine Box (M39 x 12)", round(scale * 0.8), /obj/item/ammo_box/magazine/m39, VENDOR_ITEM_REGULAR),
		list("Magazine Box (M41A x 10)", round(scale * 0.8), /obj/item/ammo_box/magazine, VENDOR_ITEM_REGULAR),
		list("Magazine Box (M4A3 x 16)", round(scale * 0.9), /obj/item/ammo_box/magazine/m4a3, VENDOR_ITEM_REGULAR),
		list("Magazine Box (SU-6 x 16)", round(scale * 0.3), /obj/item/ammo_box/magazine/su6, VENDOR_ITEM_REGULAR),
		list("Magazine Box (VP78 x 16)", round(scale * 0.2), /obj/item/ammo_box/magazine/vp78, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Box (Buckshot x 100)", round(scale * 1), /obj/item/ammo_box/magazine/shotgun/buckshot, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Box (Flechette x 100)", round(scale * 1), /obj/item/ammo_box/magazine/shotgun/flechette, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Box (Slugs x 100)", round(scale * 1), /obj/item/ammo_box/magazine/shotgun, VENDOR_ITEM_REGULAR),
		list("Speed Loaders Box (M44 x 16)", round(scale * 0.8), /obj/item/ammo_box/magazine/m44, VENDOR_ITEM_REGULAR),
		list("Speed Loaders Box (Marksman M44 x 16)", round(scale * 0.2), /obj/item/ammo_box/magazine/m44/marksman, VENDOR_ITEM_REGULAR),
		list("Speed Loaders Box (Heavy M44 x 16)", round(scale * 0.5), /obj/item/ammo_box/magazine/m44/heavy, VENDOR_ITEM_REGULAR),
		)

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/stock(obj/item/item_to_stock, mob/user)
	//these are exempted because checks would be huge and not worth it
	if(istype(item_to_stock, /obj/item/storage))
		to_chat(user, SPAN_WARNING("Can't restock \the [item_to_stock]."))
		return
	var/list/R

	//this below is in case we have subtype of an object, that SHOULD be treated as parent object (like /empty ammo box)
	var/corrected_path = return_corresponding_type(item_to_stock.type)

	for(R in (listed_products))
		if(item_to_stock.type == R[3] || corrected_path && corrected_path == R[3])
			//magazines handling
			if(istype(item_to_stock, /obj/item/ammo_magazine))
				//flamer fuel tanks handling
				if(istype(item_to_stock, /obj/item/ammo_magazine/flamer_tank))
					var/obj/item/ammo_magazine/flamer_tank/FT = item_to_stock
					if(FT.flamer_chem != initial(FT.flamer_chem))
						to_chat(user, SPAN_WARNING("\The [FT] contains non-standard fuel."))
						return
				var/obj/item/ammo_magazine/A = item_to_stock
				if(A.current_rounds < A.max_rounds)
					to_chat(user, SPAN_WARNING("\The [A] isn't full. You need to fill it before you can restock it."))
					return
			//magazine ammo boxes handling
			else if(istype(item_to_stock, /obj/item/ammo_box/magazine))
				var/obj/item/ammo_box/magazine/A = item_to_stock
				//shotgun shells ammo boxes handling
				if(A.handfuls)
					var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine) in item_to_stock.contents
					if(!AM)
						to_chat(user, SPAN_WARNING("Something is wrong with \the [A], tell a coder."))
						return
					if(AM.current_rounds != AM.max_rounds)
						to_chat(user, SPAN_WARNING("\The [A] isn't full. You need to fill it before you can restock it."))
						return
				else if(A.contents.len < A.num_of_magazines)
					to_chat(user, SPAN_WARNING("[A] is not full."))
					return
				else
					for(var/obj/item/ammo_magazine/M in A.contents)
						if(M.current_rounds != M.max_rounds)
							to_chat(user, SPAN_WARNING("Not all magazines in \the [A] are full."))
							return
			//loose rounds ammo box handling
			else if(istype(item_to_stock, /obj/item/ammo_box/rounds))
				var/obj/item/ammo_box/rounds/A = item_to_stock
				if(A.bullet_amount < A.max_bullet_amount)
					to_chat(user, SPAN_WARNING("[A] is not full."))
					return

			if(item_to_stock.loc == user) //Inside the mob's inventory
				if(item_to_stock.flags_item & WIELDED)
					item_to_stock.unwield(user)
				user.temp_drop_inv_item(item_to_stock)

			if(isstorage(item_to_stock.loc)) //inside a storage item
				var/obj/item/storage/S = item_to_stock.loc
				S.remove_from_storage(item_to_stock, user.loc)

			qdel(item_to_stock)
			user.visible_message(SPAN_NOTICE("[user] stocks [src] with \a [R[1]]."),
			SPAN_NOTICE("You stock [src] with \a [R[1]]."))
			R[2]++
			updateUsrDialog()
			return //We found our item, no reason to go on.

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/blend
		icon_state = "req_ammo_wall"
		tiles_with = list(
			/obj/structure/window/framed/almayer,
			/obj/structure/machinery/door/airlock,
			/turf/closed/wall/almayer)

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/squad
	name = "\improper ColMarTech Automated Munition Squad Vendor"
	desc = "An automated supply rack hooked up to a small storage of various ammunition types. Can be accessed by any Marine Rifleman."
	req_access = list(ACCESS_MARINE_ALPHA)
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_RO)
	hackable = TRUE

	vend_x_offset = 2

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/squad/populate_product_list(var/scale)
	listed_products = list(

		list("ARMOR-PIERCING AMMUNITION", -1, null, null),
		list("L42A AP Magazine (10x24mm)", round(scale * 3.5), /obj/item/ammo_magazine/rifle/l42a/ap, VENDOR_ITEM_REGULAR),
		list("M39 AP Magazine (10x20mm)", round(scale * 3), /obj/item/ammo_magazine/smg/m39/ap, VENDOR_ITEM_REGULAR),
		list("M41A AP Magazine (10x24mm)", round(scale * 3), /obj/item/ammo_magazine/rifle/ap, VENDOR_ITEM_REGULAR),

		list("EXTENDED AMMUNITION", -1, null, null),
		list("M39 Extended Magazine (10x20mm)", round(scale * 1.8), /obj/item/ammo_magazine/smg/m39/extended, VENDOR_ITEM_REGULAR),
		list("M41A Extended Magazine (10x24mm)", round(scale * 1.9), /obj/item/ammo_magazine/rifle/extended, VENDOR_ITEM_REGULAR),

		list("SPECIAL AMMUNITION", -1, null, null),
		list("M56 Smartgun Drum", 1, /obj/item/ammo_magazine/smartgun, VENDOR_ITEM_REGULAR),
		list("M44 Heavy Speed Loader (.44)", round(scale * 2), /obj/item/ammo_magazine/revolver/heavy, VENDOR_ITEM_REGULAR),
		list("M44 Marksman Speed Loader (.44)", round(scale * 2), /obj/item/ammo_magazine/revolver/marksman, VENDOR_ITEM_REGULAR),

		list("RESTRICTED FIREARM AMMUNITION", -1, null, null),
		list("VP78 Magazine", round(scale * 5), /obj/item/ammo_magazine/pistol/vp78, VENDOR_ITEM_REGULAR),
		list("SU-6 Smartpistol Magazine (.45)", round(scale * 5), /obj/item/ammo_magazine/pistol/smart, VENDOR_ITEM_REGULAR),
		list("M240 Incinerator Tank", round(scale * 3), /obj/item/ammo_magazine/flamer_tank, VENDOR_ITEM_REGULAR),
		list("M41AE2 Box Magazine (10x24mm)", round(scale * 3), /obj/item/ammo_magazine/rifle/lmg, VENDOR_ITEM_REGULAR),
		list("M56D Drum Magazine", round(scale * 2), /obj/item/ammo_magazine/m56d, VENDOR_ITEM_REGULAR),
		list("M2C Box Magazine", round(scale * 2), /obj/item/ammo_magazine/m2c, VENDOR_ITEM_REGULAR),
		list("HIRR Baton Slugs", round(scale * 6), /obj/item/explosive/grenade/slug/baton, VENDOR_ITEM_REGULAR),
		list("M74 AGM-S Star Shell", round(scale * 2), /obj/item/explosive/grenade/HE/airburst/starshell, VENDOR_ITEM_REGULAR),
		list("M74 AGM-S Hornet Shell", round(scale * 4), /obj/item/explosive/grenade/HE/airburst/hornet_shell, VENDOR_ITEM_REGULAR),
		)

//------------ATTACHMENTS VENDOR---------------

/obj/structure/machinery/cm_vending/sorted/attachments
	name = "\improper Armat Systems Attachments Vendor"
	desc = "An automated supply rack hooked up to a big storage of weapons attachments. Can be accessed by the Requisitions Officer and Cargo Techs."
	req_access = list(ACCESS_MARINE_CARGO)
	vendor_theme = VENDOR_THEME_USCM
	icon_state = "req_attach"

	vend_delay = 3

/obj/structure/machinery/cm_vending/sorted/attachments/Initialize()
	. = ..()
	GLOB.cm_vending_vendors += src

/obj/structure/machinery/cm_vending/sorted/attachments/Destroy()
	GLOB.cm_vending_vendors -= src
	return ..()

/obj/structure/machinery/cm_vending/sorted/attachments/vend_fail()
	return

/obj/structure/machinery/cm_vending/sorted/attachments/populate_product_list(var/scale)
	listed_products = list(
		list("BARREL", -1, null, null),
		list("Barrel Charger", round(scale * 2.5), /obj/item/attachable/heavy_barrel, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", round(scale * 6.5), /obj/item/attachable/extended_barrel, VENDOR_ITEM_REGULAR),
		list("M5 Bayonet", round(scale * 10.5), /obj/item/attachable/bayonet, VENDOR_ITEM_REGULAR),
		list("Recoil Compensator", round(scale * 6.5), /obj/item/attachable/compensator, VENDOR_ITEM_REGULAR),
		list("Suppressor", round(scale * 6.5), /obj/item/attachable/suppressor, VENDOR_ITEM_REGULAR),

		list("RAIL", -1, null, null),
		list("B8 Smart-Scope", round(scale * 3.5), /obj/item/attachable/scope/mini_iff, VENDOR_ITEM_REGULAR),
		list("Magnetic Harness", round(scale * 8.5), /obj/item/attachable/magnetic_harness, VENDOR_ITEM_REGULAR),
		list("Rail Flashlight", round(scale * 10.5), /obj/item/attachable/flashlight, VENDOR_ITEM_REGULAR),
		list("S4 2x Telescopic Mini-Scope", round(scale * 4.5), /obj/item/attachable/scope/mini, VENDOR_ITEM_REGULAR),
		list("S5 Red-Dot Sight", round(scale * 9.5), /obj/item/attachable/reddot, VENDOR_ITEM_REGULAR),
		list("S6 Reflex Sight", round(scale * 9.5), /obj/item/attachable/reflex, VENDOR_ITEM_REGULAR),
		list("S8 4x Telescopic Scope", round(scale * 4.5), /obj/item/attachable/scope, VENDOR_ITEM_REGULAR),

		list("UNDERBARREL", -1, null, null),
		list("Angled Grip", round(scale * 6.5), /obj/item/attachable/angledgrip, VENDOR_ITEM_REGULAR),
		list("Bipod", round(scale * 6.5), /obj/item/attachable/bipod, VENDOR_ITEM_REGULAR),
		list("Burst Fire Assembly", round(scale * 4.5), /obj/item/attachable/burstfire_assembly, VENDOR_ITEM_REGULAR),
		list("Gyroscopic Stabilizer", round(scale * 4.5), /obj/item/attachable/gyro, VENDOR_ITEM_REGULAR),
		list("Laser Sight", round(scale * 9.5), /obj/item/attachable/lasersight, VENDOR_ITEM_REGULAR),
		list("Mini Flamethrower", round(scale * 4.5), /obj/item/attachable/attached_gun/flamer, VENDOR_ITEM_REGULAR),
		list("XM-VESG-1 Flamer Nozzle", round(scale * 4.5), /obj/item/attachable/attached_gun/flamer_nozzle, VENDOR_ITEM_REGULAR),
		list("U7 Underbarrel Shotgun", round(scale * 4.5), /obj/item/attachable/attached_gun/shotgun, VENDOR_ITEM_REGULAR),
		list("Underbarrel Extinguisher", round(scale * 4.5), /obj/item/attachable/attached_gun/extinguisher, VENDOR_ITEM_REGULAR),
		list("Underbarrel Flashlight Grip", round(scale * 9.5), /obj/item/attachable/flashlight/grip, VENDOR_ITEM_REGULAR),
		list("Underslung Grenade Launcher", round(scale * 9.5), /obj/item/attachable/attached_gun/grenade, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", round(scale * 9.5), /obj/item/attachable/verticalgrip, VENDOR_ITEM_REGULAR),

		list("STOCK", -1, null, null),
		list("L42 Synthetic Stock", round(scale * 4.5), /obj/item/attachable/stock/carbine, VENDOR_ITEM_REGULAR),
		list("M37 Wooden Stock", round(scale * 4.5), /obj/item/attachable/stock/shotgun, VENDOR_ITEM_REGULAR),
		list("M39 Arm Brace", round(scale * 4.5), /obj/item/attachable/stock/smg/collapsible/brace, VENDOR_ITEM_REGULAR),
		list("M39 Folding Stock", round(scale * 4.5), /obj/item/attachable/stock/smg/collapsible, VENDOR_ITEM_REGULAR),
		list("M39 Stock", round(scale * 4.5), /obj/item/attachable/stock/smg, VENDOR_ITEM_REGULAR),
		list("M41A Solid Stock", round(scale * 4.5), /obj/item/attachable/stock/rifle, VENDOR_ITEM_REGULAR),
		list("M41A Folding Stock", round(scale * 4.5), /obj/item/attachable/stock/rifle/collapsible, VENDOR_ITEM_REGULAR),
		list("M44 Magnum Sharpshooter Stock", round(scale * 4.5), /obj/item/attachable/stock/revolver, VENDOR_ITEM_REGULAR)
		)

/obj/structure/machinery/cm_vending/sorted/attachments/get_appropriate_vend_turf(var/mob/living/carbon/human/H)
	var/turf/T
	if(vend_x_offset != 0 || vend_y_offset != 0)	//this will allow to avoid code below that suits only Almayer.
		T = locate(x + vend_x_offset, y + vend_y_offset, z)
	else
		T = get_turf(get_step(src, NORTHEAST))
		if(H.loc == T)
			T = get_turf(get_step(src, NORTH))
		else
			T = get_turf(get_step(src, SOUTHEAST))
			if(H.loc == T)
				T = get_turf(get_step(src, SOUTH))
			else
				T = loc
	return T

/obj/structure/machinery/cm_vending/sorted/attachments/blend
	icon_state = "req_attach_wall"
	tiles_with = list(
		/obj/structure/window/framed/almayer,
		/obj/structure/machinery/door/airlock,
		/turf/closed/wall/almayer)

/obj/structure/machinery/cm_vending/sorted/attachments/squad
	name = "\improper Armat Systems Squad Attachments Vendor"
	desc = "An automated supply rack hooked up to a small storage of weapons attachments. Can be accessed by any Marine Rifleman."
	req_access = list(ACCESS_MARINE_ALPHA)
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_RO)
	hackable = TRUE

	vend_y_offset = 1

/obj/structure/machinery/cm_vending/sorted/attachments/squad/populate_product_list(var/scale)
	listed_products = list(
		list("BARREL", -1, null, null),
		list("Barrel Charger", round(scale * 0.9), /obj/item/attachable/heavy_barrel, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", round(scale * 2.5), /obj/item/attachable/extended_barrel, VENDOR_ITEM_REGULAR),
		list("Recoil Compensator", round(scale * 2.5), /obj/item/attachable/compensator, VENDOR_ITEM_REGULAR),
		list("Suppressor", round(scale * 2.5), /obj/item/attachable/suppressor, VENDOR_ITEM_REGULAR),

		list("RAIL", -1, null, null),
		list("B8 Smart-Scope", round(scale * 1.5), /obj/item/attachable/scope/mini_iff, VENDOR_ITEM_REGULAR),
		list("Magnetic Harness", round(scale * 4), /obj/item/attachable/magnetic_harness, VENDOR_ITEM_REGULAR),
		list("S4 2x Telescopic Mini-Scope", round(scale * 2), /obj/item/attachable/scope/mini, VENDOR_ITEM_REGULAR),
		list("S5 Red-Dot Sight", round(scale * 3), /obj/item/attachable/reddot, VENDOR_ITEM_REGULAR),
		list("S6 Reflex Sight", round(scale * 3), /obj/item/attachable/reflex, VENDOR_ITEM_REGULAR),
		list("S8 4x Telescopic Scope", round(scale * 2), /obj/item/attachable/scope, VENDOR_ITEM_REGULAR),

		list("UNDERBARREL", -1, null, null),
		list("Angled Grip", round(scale * 2.5), /obj/item/attachable/angledgrip, VENDOR_ITEM_REGULAR),
		list("Bipod", round(scale * 2.5), /obj/item/attachable/bipod, VENDOR_ITEM_REGULAR),
		list("Burst Fire Assembly", round(scale * 1.5), /obj/item/attachable/burstfire_assembly, VENDOR_ITEM_REGULAR),
		list("Gyroscopic Stabilizer", round(scale * 1.5), /obj/item/attachable/gyro, VENDOR_ITEM_REGULAR),
		list("Laser Sight", round(scale * 3), /obj/item/attachable/lasersight, VENDOR_ITEM_REGULAR),
		list("Mini Flamethrower", round(scale * 1.5), /obj/item/attachable/attached_gun/flamer, VENDOR_ITEM_REGULAR),
		list("XM-VESG-1 Flamer Nozzle", round(scale * 1.5), /obj/item/attachable/attached_gun/flamer_nozzle, VENDOR_ITEM_REGULAR),
		list("U7 Underbarrel Shotgun", round(scale * 1.5), /obj/item/attachable/attached_gun/shotgun, VENDOR_ITEM_REGULAR),
		list("Underbarrel Extinguisher", round(scale * 1.5), /obj/item/attachable/attached_gun/extinguisher, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", round(scale * 3), /obj/item/attachable/verticalgrip, VENDOR_ITEM_REGULAR),

		list("STOCK", -1, null, null),
		list("M37 Wooden Stock", round(scale * 1.5), /obj/item/attachable/stock/shotgun, VENDOR_ITEM_REGULAR),
		list("M39 Arm Brace", round(scale * 1.5), /obj/item/attachable/stock/smg/collapsible/brace, VENDOR_ITEM_REGULAR),
		list("M39 Stock", round(scale * 1.5), /obj/item/attachable/stock/smg, VENDOR_ITEM_REGULAR),
		list("M41A Solid Stock", round(scale * 1.5), /obj/item/attachable/stock/rifle, VENDOR_ITEM_REGULAR),
		list("M44 Magnum Sharpshooter Stock", round(scale * 1.5), /obj/item/attachable/stock/revolver, VENDOR_ITEM_REGULAR)
		)

//------------UNIFORM VENDOR---------------

obj/structure/machinery/cm_vending/sorted/uniform_supply
	name = "\improper ColMarTech Surplus Uniform Vendor"
	desc = "An automated supply rack hooked up to a big storage of standard marine uniforms. Can be accessed by the Requisitions Officer and Cargo Techs."
	icon_state = "clothing"
	req_access = list()
	req_one_access = list(ACCESS_MARINE_CARGO)
	vendor_theme = VENDOR_THEME_USCM

	listed_products = list(
		list("UNIFORM", -1, null, null),
		list("Lightweight IMP Backpack", 20, /obj/item/storage/backpack/marine, VENDOR_ITEM_REGULAR),
		list("Marine Combat Boots", 20, /obj/item/clothing/shoes/marine, VENDOR_ITEM_REGULAR),
		list("M276 Ammo Load Rig", 10, /obj/item/storage/belt/marine, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 10, /obj/item/storage/belt/shotgun, VENDOR_ITEM_REGULAR),
		list("USCM Satchel", 20, /obj/item/storage/backpack/marine/satchel, VENDOR_ITEM_REGULAR),
		list("USCM Uniform", 20, /obj/item/clothing/under/marine, VENDOR_ITEM_REGULAR),

		list("ARMOR", -1, null, null),
		list("M10 Pattern Marine Helmet", 20, /obj/item/clothing/head/helmet/marine, VENDOR_ITEM_REGULAR),
		list("M10 Pattern Technician Helmet", 20, /obj/item/clothing/head/helmet/marine/tech, VENDOR_ITEM_REGULAR),
		list("M3 Pattern Carrier Marine Armor", 20, /obj/item/clothing/suit/storage/marine/carrier, VENDOR_ITEM_REGULAR),
		list("M3 Pattern Padded Marine Armor", 20, /obj/item/clothing/suit/storage/marine/padded, VENDOR_ITEM_REGULAR),
		list("M3 Pattern Padless Marine Armor", 20, /obj/item/clothing/suit/storage/marine/padless, VENDOR_ITEM_REGULAR),
		list("M3 Pattern Ridged Marine Armor", 20, /obj/item/clothing/suit/storage/marine/padless_lines, VENDOR_ITEM_REGULAR),
		list("M3 Pattern Skull Marine Armor", 20, /obj/item/clothing/suit/storage/marine/skull, VENDOR_ITEM_REGULAR),
		list("M3-H Pattern Heavy Armor", 10, /obj/item/clothing/suit/storage/marine/heavy, VENDOR_ITEM_REGULAR),
		list("M3-L Pattern Light Armor", 10, /obj/item/clothing/suit/storage/marine/light, VENDOR_ITEM_REGULAR),

		list("GLOVES", -1, null, null),
		list("Marine Combat Gloves", 40, /obj/item/clothing/gloves/marine, VENDOR_ITEM_REGULAR),
		list("Marine Black Combat Gloves", 40, /obj/item/clothing/gloves/marine/black, VENDOR_ITEM_REGULAR),

		list("RADIO", -1, null, null),
		list("Alpha Squad Radio Encryption Key", 5, /obj/item/device/encryptionkey/alpha, VENDOR_ITEM_REGULAR),
		list("Bravo Squad Radio Encryption Key", 5, /obj/item/device/encryptionkey/bravo, VENDOR_ITEM_REGULAR),
		list("Charlie Squad Radio Encryption Key", 5, /obj/item/device/encryptionkey/charlie, VENDOR_ITEM_REGULAR),
		list("Delta Squad Radio Encryption Key", 5, /obj/item/device/encryptionkey/delta, VENDOR_ITEM_REGULAR),
		list("Echo Squad Radio Encryption Key", 5, /obj/item/device/encryptionkey/echo, VENDOR_ITEM_REGULAR),
		list("Engineering Radio Encryption Key", 5, /obj/item/device/encryptionkey/engi, VENDOR_ITEM_REGULAR),
		list("Intel Radio Encryption Key", 5, /obj/item/device/encryptionkey/intel, VENDOR_ITEM_REGULAR),
		list("JTAC Radio Encryption Key", 5, /obj/item/device/encryptionkey/jtac, VENDOR_ITEM_REGULAR),
		list("Marine Radio Headset", 5, /obj/item/device/radio/headset/almayer, VENDOR_ITEM_REGULAR),
		list("Supply Radio Encryption Key", 5, /obj/item/device/encryptionkey/req, VENDOR_ITEM_REGULAR),

		list("MASKS", -1, null, null, null),
		list("Gas Mask", 20, /obj/item/clothing/mask/gas, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 10, /obj/item/clothing/mask/rebreather/scarf, VENDOR_ITEM_REGULAR),
		)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/populate_product_list(var/scale)
	return

/obj/structure/machinery/cm_vending/sorted/uniform_supply/vend_fail()
	return

/obj/structure/machinery/cm_vending/sorted/uniform_supply/stock(obj/item/item_to_stock, mob/user)
	var/list/R
	for(R in (listed_products))
		if(item_to_stock.type == R[3] && !istype(item_to_stock,/obj/item/storage))
			//Marine armor handling
			if(istype(item_to_stock, /obj/item/clothing/suit/storage/marine))
				var/obj/item/clothing/suit/storage/marine/AR = item_to_stock
				if(AR.pockets && AR.pockets.contents.len)
					to_chat(user, SPAN_WARNING("\The [AR] has something inside it. Empty it before restocking."))
					return
			//Marine helmet handling
			else if(istype(item_to_stock, /obj/item/clothing/head/helmet/marine))
				var/obj/item/clothing/head/helmet/marine/H = item_to_stock
				if(H.pockets && H.pockets.contents.len)
					to_chat(user, SPAN_WARNING("\The [H] has something inside it. Empty it before restocking."))
					return

			if(item_to_stock.loc == user) //Inside the mob's inventory
				if(item_to_stock.flags_item & WIELDED)
					item_to_stock.unwield(user)
				user.temp_drop_inv_item(item_to_stock)

			if(isstorage(item_to_stock.loc)) //inside a storage item
				var/obj/item/storage/S = item_to_stock.loc
				S.remove_from_storage(item_to_stock, user.loc)

			qdel(item_to_stock)
			user.visible_message(SPAN_NOTICE("[user] stocks \the [src] with \a [R[1]]."),
			SPAN_NOTICE("You stock \the [src] with \a [R[1]]."))
			R[2]++
			updateUsrDialog()
			return //We found our item, no reason to go on.
