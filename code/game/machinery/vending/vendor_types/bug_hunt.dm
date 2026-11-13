/obj/structure/machinery/cm_vending/gear/bug_hunt
	name = "\improper ColMarTech FORECON Equipment Rack"
	desc = "An equipment rack supplying the Snake Eaters Force Reconnaissance platoon."
	req_one_access = list(ACCESS_MARINE_GENERAL, ACCESS_MARINE_PREP)
	vendor_role = list(JOB_CO, JOB_XO, JOB_SQUAD_LEADER, JOB_SQUAD_TEAM_LEADER, JOB_SQUAD_MEDIC, JOB_SQUAD_ENGI, JOB_SQUAD_SMARTGUN, JOB_SQUAD_MARINE, JOB_SYNTH)
	vend_flags = VEND_CLUTTER_PROTECTION|VEND_CATEGORY_CHECK|VEND_UNIFORM_RANKS|VEND_TO_HAND|VEND_UNIFORM_AUTOEQUIP

GLOBAL_LIST_INIT(cm_vending_clothing_marine_bug_hunt, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Standard FORECON Apparel", 0, list(/obj/item/clothing/under/marine, /obj/item/clothing/shoes/marine/knife, /obj/item/clothing/gloves/marine/insulated/black, /obj/item/clothing/head/helmet/marine), MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("MRE", 0, /obj/item/storage/box/mre, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Map", 0, /obj/item/map/current_map, MARINE_CAN_BUY_MAP, VENDOR_ITEM_MANDATORY),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("M3-R Recon Armor", 0, /obj/item/clothing/suit/storage/marine/light/recon/bug_hunt, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),

		list("BACKPACK (CHOOSE 1)", 0, null, null, null),
		list("Backpack", 0, /obj/item/storage/backpack/marine, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Satchel", 0, /obj/item/storage/backpack/marine/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),
		list("Shotgun Scabbard", 0, /obj/item/storage/large_holster/m37, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Knife Rig (Full)", 0, /obj/item/storage/belt/knifepouch, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M10 Holster Rig", 0, /obj/item/storage/belt/gun/m10, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M39 Holster Rig", 0, /obj/item/storage/belt/gun/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 General Revolver Holster Rig", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M40 Grenade Rig (Empty)", 0, /obj/item/storage/belt/grenade, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Bayonet Sheath (Full)", 0, /obj/item/storage/pouch/bayonet, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Autoinjectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Small Document Pouch", 0, /obj/item/storage/pouch/document/small, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Webbing", 0, /obj/item/clothing/accessory/storage/webbing/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Rebreather", 0, /obj/item/clothing/mask/rebreather, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("E-Tool", 5, /obj/item/tool/shovel/etool/folded, null, VENDOR_ITEM_REGULAR),
		list("Sandbags", 20, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_REGULAR),
		list("ES-11 Mobile Fuel Canister", 5, /obj/item/tool/weldpack/minitank, null, VENDOR_ITEM_REGULAR),
		list("Seegson MCT", 5, /obj/item/tool/weldingtool/simple, null, VENDOR_ITEM_REGULAR),

		list("RESTRICTED FIREARMS", 0, null, null, null),
		list("VP78 Pistol", 15, /obj/item/storage/box/guncase/vp78, null, VENDOR_ITEM_REGULAR),
		list("SU-6 Smart Pistol", 15, /obj/item/storage/box/guncase/smartpistol, null, VENDOR_ITEM_REGULAR),
		list("M85A1 Grenade Launcher", 30, /obj/item/storage/box/guncase/m85a1, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("M40 HEDP High Explosive Packet (x3 grenades)", 20, /obj/item/storage/box/packet/high_explosive, null, VENDOR_ITEM_REGULAR),
		list("M40 HIDP Incendiary Packet (x3 grenades)", 20, /obj/item/storage/box/packet/incendiary, null, VENDOR_ITEM_REGULAR),
		list("M40 WPDP White Phosphorus Packet (x3 grenades)", 20, /obj/item/storage/box/packet/phosphorus, null, VENDOR_ITEM_REGULAR),
		list("M40 HSDP Smoke Packet (x3 grenades)", 10, /obj/item/storage/box/packet/smoke, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Frag Airburst Packet (x3 airburst grenades)", 15, /obj/item/storage/box/packet/airburst_he, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Incendiary Airburst Packet (x3 airburst grenades)", 15, /obj/item/storage/box/packet/airburst_incen, null, VENDOR_ITEM_REGULAR),
		list("M20 Mine Box (x5 mines)", 20, /obj/item/storage/box/explosive_mines, null, VENDOR_ITEM_REGULAR),

		list("PRIMARY AMMUNITION", 0, null, null, null),
		list("M4RA AP Magazine (10x24mm)", 10, /obj/item/ammo_magazine/rifle/m4ra/ap, null, VENDOR_ITEM_REGULAR),
		list("M4RA Extended Magazine (10x24mm)", 10, /obj/item/ammo_magazine/rifle/m4ra/extended, null, VENDOR_ITEM_REGULAR),
		list("M39 AP Magazine (10x20mm)", 10, /obj/item/ammo_magazine/smg/m39/ap, null, VENDOR_ITEM_REGULAR),
		list("M39 Extended Magazine (10x20mm)", 10, /obj/item/ammo_magazine/smg/m39/extended, null, VENDOR_ITEM_REGULAR),

		list("SIDEARM AMMUNITION", 0, null, null, null),
		list("M10 HV Extended Magazine (10x20mm-APC)", 10, /obj/item/ammo_magazine/pistol/m10/extended, null, VENDOR_ITEM_REGULAR),
		list("M44 Heavy Speed Loader (.44)", 5, /obj/item/ammo_magazine/revolver/heavy, null, VENDOR_ITEM_REGULAR),
		list("M44 Marksman Speed Loader (.44)", 5, /obj/item/ammo_magazine/revolver/marksman, null, VENDOR_ITEM_REGULAR),
		list("M4A3 HP Magazine", 5, /obj/item/ammo_magazine/pistol/hp, null, VENDOR_ITEM_REGULAR),
		list("M4A3 AP Magazine", 5, /obj/item/ammo_magazine/pistol/ap, null, VENDOR_ITEM_REGULAR),
		list("VP78 Magazine", 5, /obj/item/ammo_magazine/pistol/vp78, null, VENDOR_ITEM_REGULAR),
		list("SU-6 Smartpistol Magazine (.45)", 10, /obj/item/ammo_magazine/pistol/smart, null, VENDOR_ITEM_REGULAR),

		list("CLOTHING ITEMS", 0, null, null, null),
		list("M276 Combat Sidearm Rig", 15, /obj/item/storage/belt/gun/combat_rig, null, VENDOR_ITEM_REGULAR),
		list("Machete Scabbard (Full)", 15, /obj/item/storage/large_holster/machete/full, null, VENDOR_ITEM_REGULAR),
		list("Machete Pouch (Full)", 15, /obj/item/storage/pouch/machete/full, null, VENDOR_ITEM_REGULAR),
		list("Fuel Tank Strap Pouch", 5, /obj/item/storage/pouch/flamertank, null, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", 5, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 15, /obj/item/storage/pouch/sling, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 15, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 25, /obj/item/storage/pouch/magazine/large, null, VENDOR_ITEM_REGULAR),
		list("Large Shotgun Shell Pouch", 25, /obj/item/storage/pouch/shotgun/large, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Roller Bed", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Fulton Device Stack", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 15, /obj/item/device/motiondetector, null, VENDOR_ITEM_REGULAR),
		list("Data Detector", 15, /obj/item/device/motiondetector/intel, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 5, /obj/item/clothing/accessory/device/whistle, null, VENDOR_ITEM_REGULAR),
		list("SensorMate Medical HUD", 15, /obj/item/clothing/glasses/hud/sensor, null, VENDOR_ITEM_REGULAR),

		list("BINOCULARS", 0, null, null, null),
		list("Binoculars", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Range Finder", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("Laser Designator", 15, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),

		list("HELMET OPTICS", 0, null, null, null),
		list("SensorMate Medical Optic", 15, /obj/item/device/helmet_visor/medical, null, VENDOR_ITEM_REGULAR),
		list("Welding Visor", 5, /obj/item/device/helmet_visor/welding_visor, null, VENDOR_ITEM_REGULAR),

		list("PAMPHLETS", 0, null, null, null),
		list("JTAC Pamphlet", 15, /obj/item/pamphlet/upgradeable/jtac, null, VENDOR_ITEM_REGULAR),
		list("Engineering Pamphlet", 15, /obj/item/pamphlet/upgradeable/engineer, null, VENDOR_ITEM_REGULAR),

		list("RADIO KEYS", 0, null, null, null),
		list("Engineering Radio Encryption Key", 5, /obj/item/device/encryptionkey/engi, null, VENDOR_ITEM_REGULAR),
		list("Intel Radio Encryption Key", 5, /obj/item/device/encryptionkey/intel, null, VENDOR_ITEM_REGULAR),
		list("JTAC Radio Encryption Key", 5, /obj/item/device/encryptionkey/jtac, null, VENDOR_ITEM_REGULAR),
		list("Supply Radio Encryption Key", 5, /obj/item/device/encryptionkey/req, null, VENDOR_ITEM_REGULAR),
		list("Medical Radio Encryption Key", 5, /obj/item/device/encryptionkey/med, null, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/marine/bug_hunt
	name = "\improper ColMarTech FORECON Rifleman Equipment Rack"
	desc = "An automated rack of standard Marine equipment adapted for Force Reconnaissance operations."
	req_one_access = list(ACCESS_MARINE_GENERAL, ACCESS_MARINE_PREP)

/obj/structure/machinery/cm_vending/clothing/marine/bug_hunt/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_marine_bug_hunt

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/bug_hunt
	name = "\improper ColMarTech FORECON Surplus Uniform Vendor"
	desc = "An automated supply rack holding spare uniforms and field equipment for Force Reconnaissance operations."
	req_access = list()
	req_one_access = list(ACCESS_MARINE_GENERAL, ACCESS_MARINE_PREP)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/bug_hunt/populate_product_list(scale)
	..()
	for(var/list/product as anything in listed_products.Copy())
		switch(product[3])
			if(/obj/item/clothing/accessory/patch/falcon)
				product[1] = "FORECON Shoulder Patch"
				product[3] = /obj/item/clothing/accessory/patch/forecon
			if(/obj/item/clothing/accessory/patch/falconalt)
				listed_products -= list(product)
			if(/obj/item/device/radio/headset/almayer)
				product[1] = "FORECON Radio Headset"
				product[3] = /obj/item/device/radio/headset/distress/forecon/bug_hunt
	listed_products = list(
		list("FORECON EQUIPMENT", -1, null, null),
		list("M3-R Recon Armor", floor(scale * 10), /obj/item/clothing/suit/storage/marine/light/recon/bug_hunt, VENDOR_ITEM_REGULAR),
		list("Insulated Combat Gloves", floor(scale * 15), /obj/item/clothing/gloves/marine/insulated/black, VENDOR_ITEM_REGULAR),
	) + listed_products

/obj/structure/machinery/cm_vending/clothing/leader/bug_hunt
	name = "\improper ColMarTech FORECON Platoon Sergeant Equipment Rack"
	desc = "An automated rack of field apparel and equipment for the FORECON platoon sergeant."
	gloves_type = /obj/item/clothing/gloves/marine/insulated/black
	headset_type = /obj/item/device/radio/headset/distress/forecon/bug_hunt

/obj/structure/machinery/cm_vending/gear/leader/bug_hunt
	name = "\improper ColMarTech FORECON Platoon Sergeant Gear Rack"
	desc = "An automated gear rack for the FORECON platoon sergeant."

/obj/structure/machinery/cm_vending/gear/leader/bug_hunt/get_listed_products(mob/user)
	var/list/products = deep_copy_list(..(user))
	for(var/list/product as anything in products)
		if(product[3] == /obj/item/storage/box/kit/m41aMK1_kit)
			product[3] = /obj/item/storage/box/kit/m41aMK1_kit/forecon
		else if(product[3] == /obj/item/clothing/gloves/marine/insulated/black)
			product[2] = 0
			product[4] = MARINE_CAN_BUY_GLOVES
	return products

/obj/structure/machinery/cm_vending/gear/executive_officer/bug_hunt/get_listed_products(mob/user)
	var/list/products = deep_copy_list(..(user))
	for(var/list/product as anything in products)
		if(product[3] == /obj/item/storage/box/guncase/m41aMK1AP)
			product[3] = /obj/item/storage/box/guncase/m41aMK1AP/forecon
		else if(product[3] == /obj/item/clothing/gloves/marine/insulated/black)
			product[2] = 0
			product[4] = MARINE_CAN_BUY_GLOVES
	return products

/obj/structure/machinery/cm_vending/gear/commanding_officer/bug_hunt/get_listed_products(mob/user)
	var/datum/equipment_preset/uscm_co/preset = GLOB.equipment_presets.gear_path_presets_list[/datum/equipment_preset/uscm_co]
	var/list/sidearms = user ? list(user.client?.prefs?.commander_sidearm) : (CO_GUNS + COUNCIL_CO_GUNS)
	var/list/products = list(list("COMMANDER'S SIDEARM", 0, null, null, null))
	for(var/sidearm as anything in sidearms)
		products += list(list("Preferred CO Sidearm", 0, preset.get_sidearm_gear(sidearm), MARINE_CAN_BUY_KIT, VENDOR_ITEM_MANDATORY))
	return products + ..(user)

/obj/structure/machinery/cm_vending/clothing/engi/bug_hunt
	name = "\improper ColMarTech FORECON Engineer Equipment Rack"
	desc = "An automated rack of standard equipment for FORECON engineers."
	headset_type = /obj/item/device/radio/headset/distress/forecon/bug_hunt

/obj/structure/machinery/cm_vending/clothing/engi/bug_hunt/get_listed_products(mob/user)
	var/list/products = ..(user)
	products = products.Copy()
	for(var/list/product as anything in products)
		if(product[4] == MARINE_CAN_BUY_ARMOR)
			products.Insert(products.Find(product), list(list("M3-R Recon Armor", 0, /obj/item/clothing/suit/storage/marine/light/recon/bug_hunt, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED)))
			break
	return products

/obj/structure/machinery/cm_vending/clothing/medic/bug_hunt
	name = "\improper ColMarTech FORECON Corpsman Equipment Rack"
	desc = "An automated rack of standard equipment for FORECON corpsmen."
	gloves_type = /obj/item/clothing/gloves/marine/insulated/black
	headset_type = /obj/item/device/radio/headset/distress/forecon/bug_hunt

/obj/structure/machinery/cm_vending/clothing/medic/bug_hunt/get_listed_products(mob/user)
	var/list/products = ..(user)
	products = products.Copy()
	for(var/list/product as anything in products)
		if(product[4] == MARINE_CAN_BUY_ARMOR)
			products.Insert(products.Find(product), list(list("M3-R Recon Armor", 0, /obj/item/clothing/suit/storage/marine/light/recon/bug_hunt, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED)))
			break
	return products

GLOBAL_LIST_INIT(cm_vending_clothing_tl_bug_hunt, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Standard FORECON Apparel", 0, list(/obj/item/clothing/under/marine, /obj/item/clothing/shoes/marine/knife, /obj/item/clothing/gloves/marine/insulated/black, /obj/item/clothing/head/helmet/marine), MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("M3-R Recon Armor", 0, /obj/item/clothing/suit/storage/marine/light/recon/bug_hunt, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
		list("MRE", 0, /obj/item/storage/box/mre, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Map", 0, /obj/item/map/current_map, MARINE_CAN_BUY_MAP, VENDOR_ITEM_MANDATORY),
		list("USCM Radio Telephone Pack", 0, /obj/item/storage/backpack/marine/satchel/rto, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Trench Whistle", 0, /obj/item/clothing/accessory/device/whistle/trench, MARINE_CAN_BUY_SPECIALIZATION, VENDOR_ITEM_MANDATORY),
		list("Essential Section Leader Utilities", 0, /obj/effect/essentials_set/tl, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Combat Sidearm Rig", 0, /obj/item/storage/belt/gun/combat_rig, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M39 Holster Rig", 0, /obj/item/storage/belt/gun/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M10 Holster Rig", 0, /obj/item/storage/belt/gun/m10, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 General Revolver Holster Rig", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 M40 Grenade Rig", 0, /obj/item/storage/belt/grenade, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("First-Aid Pouch (Refillable Autoinjectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Fuel Tank Strap Pouch", 0, /obj/item/storage/pouch/flamertank, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sidearm Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Webbing", 0, /obj/item/clothing/accessory/storage/webbing/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/tl/bug_hunt
	name = "\improper ColMarTech FORECON Section Leader Equipment Rack"
	desc = "An automated rack of field apparel and equipment for FORECON section leaders."

/obj/structure/machinery/cm_vending/clothing/tl/bug_hunt/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_tl_bug_hunt

GLOBAL_LIST_INIT(cm_vending_gear_tl_bug_hunt, list(
		list("EXPLOSIVES", 0, null, null, null),
		list("M40 HEDP High Explosive Packet (x3 grenades)", 18, /obj/item/storage/box/packet/high_explosive, null, VENDOR_ITEM_REGULAR),
		list("M40 HIDP Incendiary Packet (x3 grenades)", 18, /obj/item/storage/box/packet/incendiary, null, VENDOR_ITEM_REGULAR),
		list("M40 WPDP White Phosphorus Packet (x3 grenades)", 18, /obj/item/storage/box/packet/phosphorus, null, VENDOR_ITEM_REGULAR),
		list("M40 HSDP Smoke Packet (x3 grenades)", 9, /obj/item/storage/box/packet/smoke, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Frag Airburst Packet (x3 airburst grenades)", 13, /obj/item/storage/box/packet/airburst_he, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Incendiary Airburst Packet (x3 airburst grenades)", 13, /obj/item/storage/box/packet/airburst_incen, null, VENDOR_ITEM_REGULAR),
		list("M20 Mine Box (x5 mines)", 20, /obj/item/storage/box/explosive_mines, null, VENDOR_ITEM_REGULAR),
		list("M40 MFHS Metal Foam Grenade", 5, /obj/item/explosive/grenade/metal_foam, null, VENDOR_ITEM_REGULAR),
		list("G2 Electroshock Grenade Packet (x3 grenades)", 16, /obj/item/storage/box/packet/sebb, null, VENDOR_ITEM_REGULAR),

		list("PRIMARY AMMUNITION", 0, null, null, null),
		list("M4RA AP Magazine (10x24mm)", 10, /obj/item/ammo_magazine/rifle/m4ra/ap, null, VENDOR_ITEM_REGULAR),
		list("M4RA Extended Magazine (10x24mm)", 10, /obj/item/ammo_magazine/rifle/m4ra/extended, null, VENDOR_ITEM_REGULAR),
		list("M39 AP Magazine (10x20mm)", 10, /obj/item/ammo_magazine/smg/m39/ap, null, VENDOR_ITEM_REGULAR),
		list("M39 Extended Magazine (10x20mm)", 10, /obj/item/ammo_magazine/smg/m39/extended, null, VENDOR_ITEM_REGULAR),

		list("SIDEARM AMMUNITION", 0, null, null, null),
		list("M10 HV Extended Magazine (10x20mm-APC)", 10, /obj/item/ammo_magazine/pistol/m10/extended, null, VENDOR_ITEM_REGULAR),
		list("M44 Heavy Speed Loader (.44)", 5, /obj/item/ammo_magazine/revolver/heavy, null, VENDOR_ITEM_REGULAR),
		list("M44 Marksman Speed Loader (.44)", 5, /obj/item/ammo_magazine/revolver/marksman, null, VENDOR_ITEM_REGULAR),
		list("M4A3 HP Magazine", 5, /obj/item/ammo_magazine/pistol/hp, null, VENDOR_ITEM_REGULAR),
		list("M4A3 AP Magazine", 5, /obj/item/ammo_magazine/pistol/ap, null, VENDOR_ITEM_REGULAR),
		list("VP78 Magazine", 5, /obj/item/ammo_magazine/pistol/vp78, null, VENDOR_ITEM_REGULAR),
		list("SU-6 Smartpistol Magazine (.45)", 10, /obj/item/ammo_magazine/pistol/smart, null, VENDOR_ITEM_REGULAR),

		list("RESTRICTED FIREARMS", 0, null, null, null),
		list("VP78 Pistol", 10, /obj/item/storage/box/guncase/vp78, null, VENDOR_ITEM_REGULAR),
		list("SU-6 Smart Pistol", 15, /obj/item/storage/box/guncase/smartpistol, null, VENDOR_ITEM_REGULAR),
		list("M85A1 Grenade Launcher", 30, /obj/item/storage/box/guncase/m85a1, null, VENDOR_ITEM_REGULAR),

		list("CLOTHING ITEMS", 0, null, null, null),
		list("Machete Scabbard (Full)", 5, /obj/item/storage/large_holster/machete/full, null, VENDOR_ITEM_REGULAR),
		list("Machete Pouch (Full)", 15, /obj/item/storage/pouch/machete/full, null, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", 3, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),
		list("M276 Pattern Combat Toolbelt Rig", 15, /obj/item/storage/belt/gun/utility, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector Pouch (Full)", 15, /obj/item/storage/pouch/autoinjector/full, null, VENDOR_ITEM_REGULAR),
		list("Insulated Combat Gloves", 0, /obj/item/clothing/gloves/marine/insulated/black, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),
		list("Night Vision Optic", 30, /obj/item/device/helmet_visor/night_vision, null, VENDOR_ITEM_RECOMMENDED),

		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Plastic Explosive", 10, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Signal Flare Pack", 5, /obj/item/storage/box/m94/signal, null, VENDOR_ITEM_REGULAR),
		list("Breaching Charge", 10, /obj/item/explosive/plastic/breaching_charge, null, VENDOR_ITEM_REGULAR),
		list("ES-11 Mobile Fuel Canister", 5, /obj/item/tool/weldpack/minitank, null, VENDOR_ITEM_REGULAR),
		list("Seegson MCT", 5, /obj/item/tool/weldingtool/simple, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Motion Detector", 15, /obj/item/device/motiondetector, null, VENDOR_ITEM_RECOMMENDED),
		list("Roller Bed", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Fulton Device Stack", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("SensorMate Medical HUD", 15, /obj/item/clothing/glasses/hud/sensor, null, VENDOR_ITEM_REGULAR),

		list("BINOCULARS", 0, null, null, null),
		list("Binoculars", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Range Finder", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("Laser Designator", 15, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),

		list("HELMET OPTICS", 0, null, null, null),
		list("SensorMate Medical Optic", 15, /obj/item/device/helmet_visor/medical, null, VENDOR_ITEM_REGULAR),
		list("Welding Visor", 5, /obj/item/device/helmet_visor/welding_visor, null, VENDOR_ITEM_REGULAR),

		list("RADIO KEYS", 0, null, null, null),
		list("Engineering Radio Encryption Key", 5, /obj/item/device/encryptionkey/engi, null, VENDOR_ITEM_REGULAR),
		list("Intel Radio Encryption Key", 5, /obj/item/device/encryptionkey/intel, null, VENDOR_ITEM_REGULAR),
		list("JTAC Radio Encryption Key", 5, /obj/item/device/encryptionkey/jtac, null, VENDOR_ITEM_REGULAR),
		list("Supply Radio Encryption Key", 5, /obj/item/device/encryptionkey/req, null, VENDOR_ITEM_REGULAR),
		list("Medical Radio Encryption Key", 5, /obj/item/device/encryptionkey/med, null, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/gear/tl/bug_hunt
	name = "\improper ColMarTech FORECON Section Leader Gear Rack"
	desc = "An automated gear rack for FORECON section leaders."

/obj/structure/machinery/cm_vending/gear/tl/bug_hunt/get_listed_products(mob/user)
	return GLOB.cm_vending_gear_tl_bug_hunt

/obj/structure/machinery/cm_vending/clothing/commanding_officer/bug_hunt

/obj/structure/machinery/cm_vending/clothing/senior_officer/bug_hunt
	gloves_type = /obj/item/clothing/gloves/marine/insulated/black

/obj/structure/machinery/cm_vending/gear/bug_hunt/clothing
	name = "\improper ColMarTech FORECON Clothing Rack"
	icon_state = "clothing"
	vendor_role = list(JOB_CO, JOB_XO, JOB_SQUAD_LEADER, JOB_SQUAD_TEAM_LEADER, JOB_SQUAD_MEDIC, JOB_SQUAD_ENGI, JOB_SQUAD_MARINE, JOB_SYNTH)
	listed_products = list(
		list("FIELD UNIFORM", 0, null, null, null),
		list("Marine Fatigues", 0, /obj/item/clothing/under/marine, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Combat Boots (Knife)", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Insulated Combat Gloves", 0, /obj/item/clothing/gloves/marine/insulated/black, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),
		list("HEADWEAR", 0, null, null, null),
		list("Patrol Cap", 0, /obj/item/clothing/head/cmcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("M10 Marine Helmet", 0, /obj/item/clothing/head/helmet/marine, MARINE_CAN_BUY_COMBAT_HELMET, VENDOR_ITEM_REGULAR),
		list("M10 Corpsman Helmet", 0, /obj/item/clothing/head/helmet/marine/medic, MARINE_CAN_BUY_COMBAT_HELMET, VENDOR_ITEM_REGULAR),
		list("M10 Technician Helmet", 0, /obj/item/clothing/head/helmet/marine/tech, MARINE_CAN_BUY_COMBAT_HELMET, VENDOR_ITEM_REGULAR),
		list("ARMOR AND WEBBING", 0, null, null, null),
		list("M3-R Recon Armor", 0, /obj/item/clothing/suit/storage/marine/light/recon/bug_hunt, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Webbing", 0, /obj/item/clothing/accessory/storage/webbing/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("BACKPACKS", 0, null, null, null),
		list("USCM Satchel", 0, /obj/item/storage/backpack/marine/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),
		list("Marine Backpack", 0, /obj/item/storage/backpack/marine, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Shotgun Scabbard", 0, /obj/item/storage/large_holster/m37, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("BELTS", 0, null, null, null),
		list("Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Grenade Rig", 0, /obj/item/storage/belt/grenade, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M39 Holster Rig", 0, /obj/item/storage/belt/gun/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("POUCHES", 0, null, null, null),
		list("First-Aid Pouch", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("PROTECTIVE EQUIPMENT", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Ballistic Goggles", 0, /obj/item/clothing/glasses/mgoggles, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
	)

/obj/structure/machinery/cm_vending/gear/bug_hunt/medic
	name = "\improper ColMarTech FORECON Corpsman Equipment Rack"
	icon_state = "med_gear"
	req_access = list(ACCESS_MARINE_MEDPREP)
	vendor_role = list(JOB_SQUAD_MEDIC)
	listed_products = list(
		list("MEDICAL SET (TAKE ONE)", 0, null, null, null),
		list("Essential Medical Set", 0, /obj/effect/essentials_set/medic, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),
		list("CORPSMAN EQUIPMENT", 0, null, null, null),
		list("FORECON Medical Belt (Full)", 0, /obj/item/storage/belt/medical/lifesaver/full/forecon, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Medical Satchel", 0, /obj/item/storage/backpack/marine/satchel/medic, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Medical Backpack", 0, /obj/item/storage/backpack/marine/medic, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Combat Sterile Gloves", 0, /obj/item/clothing/gloves/marine/medical, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),
		list("HealthMate HUD", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),
		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Emergency Defibrillator", 4, /obj/item/device/defibrillator, null, VENDOR_ITEM_RECOMMENDED),
		list("Compact Surgical Case", 15, /obj/item/storage/surgical_case/regular, null, VENDOR_ITEM_RECOMMENDED),
		list("Surgical Bed", 10, /obj/item/roller/surgical, null, VENDOR_ITEM_REGULAR),
		list("Roller Bed", 4, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Stasis Bag", 6, /obj/item/bodybag/cryobag, null, VENDOR_ITEM_REGULAR),
		list("Blood Pack (O-)", 4, /obj/item/reagent_container/blood/OMinus, null, VENDOR_ITEM_REGULAR),
		list("Smart Refill Tank", 6, /obj/item/reagent_container/glass/minitank, null, VENDOR_ITEM_REGULAR),
		list("Medkit Pouch (Full)", 0, /obj/item/storage/pouch/medkit/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Webbing", 0, /obj/item/clothing/accessory/storage/webbing/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	)

/obj/structure/machinery/cm_vending/clothing/smartgun/bug_hunt
	name = "\improper ColMarTech FORECON Smartgunner Equipment Rack"
	desc = "An automated rack of standard equipment for FORECON smartgunners."
	gloves_type = /obj/item/clothing/gloves/marine/insulated/black

/obj/structure/machinery/cm_vending/clothing/smartgun/bug_hunt/get_listed_products(mob/user)
	var/list/products = deep_copy_list(..(user))
	for(var/list/product as anything in products.Copy())
		if(product[4] == MARINE_CAN_BUY_UNIFORM)
			product[1] = "Standard FORECON Apparel"
			var/list/apparel = product[3]
			apparel -= /obj/item/device/radio/headset/almayer/marine
		else if(product[3] == /obj/item/clothing/head/cmcap/boonie)
			products -= list(product)
	return products

/obj/structure/machinery/cm_vending/gear/smartgun/bug_hunt
	name = "\improper ColMarTech FORECON Smartgunner Gear Rack"
	desc = "An automated gear rack for FORECON smartgunners."

/obj/structure/machinery/cm_vending/clothing/synth/bug_hunt
	name = "\improper ColMarTech FORECON Synthetic Equipment Rack"

/obj/structure/machinery/cm_vending/clothing/synth/bug_hunt/get_listed_products(mob/user)
	var/list/products = ..(user)
	products = products.Copy()
	for(var/list/product as anything in products.Copy())
		if(product[3] == /obj/item/device/radio/headset/almayer/mcom/synth)
			products -= list(product)
			break
	return products

/obj/structure/machinery/cm_vending/gear/synth/bug_hunt
	name = "\improper ColMarTech FORECON Synthetic Auxiliary Gear Rack"
