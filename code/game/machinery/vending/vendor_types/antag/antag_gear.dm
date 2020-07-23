//------------ADAPTIVE ANTAG GEAR VENDOR---------------

/obj/structure/machinery/cm_vending/gear/antag
	name = "\improper Suspicious Automated Gear Rack"
	desc = "While similar in function to ColMarTech automated racks, this one is clearly not of USCM origin. Contains various gear."
	icon_state = "gear"
	vendor_role = VENDOR_ANTAG_JOBS
	req_access = list(ACCESS_ILLEGAL_PIRATE)

	listed_products = list(

		JOB_UPP = list(

			list("ENGINEERING SUPPLIES", 0, null, null, null),
			list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_RECOMMENDED),
			list("Sandbags x25", 5, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),

			list("SPECIAL AMMUNITION", 0, null, null, null),
			list("Type 71 AP Magazine (5.45x39mm)", 10, /obj/item/ammo_magazine/rifle/type71/ap , null, VENDOR_ITEM_REGULAR),

			list("ATTACHMENTS", 0, null, null, null),
			list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
			list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
			list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
			list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
			list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
			list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
			list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

			list("EXPLOSIVES", 0, null, null, null),
			list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
			list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/HE/upp, null, VENDOR_ITEM_REGULAR),
			list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

			list("UTILITIES", 0, null, null, null),
			list("Brown Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest/brown_vest, null, VENDOR_ITEM_RECOMMENDED),
			list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
			list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
			list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
			list("Shoulder Holster", 10, /obj/item/clothing/accessory/holster, null, VENDOR_ITEM_REGULAR),
			list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR)
		),

		JOB_UPP_ENGI = list(

			list("SAPPER SET (MANDATORY)", 0, null, null, null),
			list("Essential Sapper Set", 0, /obj/effect/essentials_set/engi, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

			list("HANDHELD DEFENSE (CHOOSE 1)", 0, null, null, null),
			list("JIMA Planted Flag", 0, /obj/item/defenses/handheld/planted_flag, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_MANDATORY),
			list("UA 42-F Sentry Flamer", 0, /obj/item/defenses/handheld/sentry/flamer, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_MANDATORY),
			list("UA 571-C Sentry Gun", 0, /obj/item/defenses/handheld/sentry, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_MANDATORY),

			list("ENGINEERING SUPPLIES", 0, null, null, null),
			list("Airlock Circuit Board", 2, /obj/item/circuitboard/airlock, null, VENDOR_ITEM_REGULAR),
			list("APC Circuit Board", 2, /obj/item/circuitboard/apc, null, VENDOR_ITEM_REGULAR),
			list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
			list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
			list("High-Capacity Power Cell", 3, /obj/item/cell/high, null, VENDOR_ITEM_REGULAR),
			list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, VENDOR_ITEM_RECOMMENDED),
			list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, VENDOR_ITEM_RECOMMENDED),
			list("Range Finder", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
			list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),

			list("SPECIAL AMMUNITION", 0, null, null, null),
			list("Type 71 AP Magazine (5.45x39mm)", 10, /obj/item/ammo_magazine/rifle/type71/ap , null, VENDOR_ITEM_REGULAR),

			list("ATTACHMENTS", 0, null, null, null),
			list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
			list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
			list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
			list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
			list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
			list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
			list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

			list("EXPLOSIVES", 0, null, null, null),
			list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
			list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
			list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/HE/upp, null, VENDOR_ITEM_REGULAR),
			list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

			list("UTILITIES", 0, null, null, null),
			list("Brown Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest/brown_vest, null, VENDOR_ITEM_RECOMMENDED),
			list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
			list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
			list("Shoulder Holster", 10, /obj/item/clothing/accessory/holster, null, VENDOR_ITEM_REGULAR),
			list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR)
		),

		JOB_UPP_MEDIC = list(

			list("MEDIC SET (MANDATORY)", 0, null, null, null),
			list("Essential Medic Set", 0, /obj/effect/essentials_set/medic/upp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

			list("FIELD SUPPLIES", 0, null, null, null),
			list("Adv Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_RECOMMENDED),
			list("Adv Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_RECOMMENDED),
			list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_RECOMMENDED),
			list("Firstaid Kit", 6, /obj/item/storage/firstaid/regular, null, VENDOR_ITEM_REGULAR),
			list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_RECOMMENDED),

			list("AUTOINJECTORS", 0, null, null, null),
			list("Autoinjector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
			list("Autoinjector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
			list("Autoinjector (Epinephrine)", 2, /obj/item/reagent_container/hypospray/autoinjector/adrenaline, null, VENDOR_ITEM_REGULAR),
			list("Autoinjector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
			list("Autoinjector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
			list("Autoinjector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
			list("Autoinjector (QuickClot)", 1, /obj/item/reagent_container/hypospray/autoinjector/quickclot, null, VENDOR_ITEM_REGULAR),
			list("Autoinjector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
			list("Autoinjector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

			list("PILL BOTTLES", 0, null, null, null),
			list("Pill Bottle (Bicaridine)", 5, /obj/item/storage/pill_bottle/bicaridine, null, VENDOR_ITEM_RECOMMENDED),
			list("Pill Bottle (Dexalin)", 5, /obj/item/storage/pill_bottle/dexalin, null, VENDOR_ITEM_REGULAR),
			list("Pill Bottle (Dylovene)", 5, /obj/item/storage/pill_bottle/antitox, null, VENDOR_ITEM_REGULAR),
			list("Pill Bottle (Inaprovaline)", 5, /obj/item/storage/pill_bottle/inaprovaline, null, VENDOR_ITEM_REGULAR),
			list("Pill Bottle (Kelotane)", 5, /obj/item/storage/pill_bottle/kelotane, null, VENDOR_ITEM_RECOMMENDED),
			list("Pill Bottle (Peridaxon)", 5, /obj/item/storage/pill_bottle/peridaxon, null, VENDOR_ITEM_REGULAR),
			list("Pill Bottle (QuickClot)", 5, /obj/item/storage/pill_bottle/quickclot, null, VENDOR_ITEM_REGULAR),
			list("Pill Bottle (Tramadol)", 5, /obj/item/storage/pill_bottle/tramadol, null, VENDOR_ITEM_RECOMMENDED),

			list("MEDICAL UTILITIES", 0, null, null, null),
			list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
			list("Medical HUD Glasses", 4, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_REGULAR),
			list("Roller Bed", 4, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
			list("Stasis Bag", 6, /obj/item/bodybag/cryobag, null, VENDOR_ITEM_REGULAR),

			list("SPECIAL AMMUNITION", 0, null, null, null),
			list("Type 71 AP Magazine (5.45x39mm)", 10, /obj/item/ammo_magazine/rifle/type71/ap , null, VENDOR_ITEM_REGULAR),

			list("ATTACHMENTS", 0, null, null, null),
			list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
			list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
			list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
			list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
			list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
			list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
			list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

			list("EXPLOSIVES", 0, null, null, null),
			list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
			list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/HE/upp, null, VENDOR_ITEM_REGULAR),
			list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

			list("UTILITIES", 0, null, null, null),
			list("Brown Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest/brown_vest, null, VENDOR_ITEM_RECOMMENDED),
			list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
			list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
			list("Shoulder Holster", 10, /obj/item/clothing/accessory/holster, null, VENDOR_ITEM_REGULAR),
			list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR)
		),

		JOB_UPP_SPECIALIST = list(

			list("HEAVY SET (MANDATORY)", 0, null, null, null),
			list("Essential Heavy Set", 0, /obj/effect/essentials_set/upp_heavy, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

			list("SPECIAL AMMUNITION", 0, null, null, null),
			list("Rotating Ammo Drum (7.62x51mm)", 15, /obj/item/ammo_magazine/minigun , null, VENDOR_ITEM_RECOMMENDED),

			list("ATTACHMENTS (NONE FIT GSh-7.62)", 0, null, null, null),
			list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
			list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
			list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
			list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
			list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
			list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
			list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

			list("EXPLOSIVES", 0, null, null, null),
			list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
			list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
			list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/HE/upp, null, VENDOR_ITEM_REGULAR),
			list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

			list("UTILITIES", 0, null, null, null),
			list("Brown Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest/brown_vest, null, VENDOR_ITEM_RECOMMENDED),
			list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
			list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
			list("Shoulder Holster", 10, /obj/item/clothing/accessory/holster, null, VENDOR_ITEM_REGULAR),
			list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR)
		),

		JOB_UPP_LEADER = list(

			list("SQUAD LEADER SET (MANDATORY)", 0, null, null, null),
			list("Essential SL Set", 0, /obj/effect/essentials_set/leader/upp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

			list("GENERAL SUPPLIES", 0, null, null, null),
			list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),

			list("ENGINEERING SUPPLIES", 0, null, null, null),
			list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
			list("Insulated Gloves", 3, /obj/item/clothing/gloves/yellow, null, VENDOR_ITEM_REGULAR),
			list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, VENDOR_ITEM_RECOMMENDED),
			list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, VENDOR_ITEM_RECOMMENDED),
			list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),
			list("Tools Pouch (Full)", 5, /obj/item/storage/pouch/tools/full, null, VENDOR_ITEM_REGULAR),
			list("Welding Goggles", 5, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),

			list("MEDICAL SUPPLIES", 0, null, null, null),
			list("Adv Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_REGULAR),
			list("Adv Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_REGULAR),
			list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_REGULAR),
			list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_REGULAR),

			list("Injector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
			list("Injector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
			list("Injector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
			list("Injector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
			list("Injector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
			list("Injector (QuickClot)", 1, /obj/item/reagent_container/hypospray/autoinjector/quickclot, null, VENDOR_ITEM_REGULAR),
			list("Injector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
			list("Injector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

			list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
			list("Medical HUD Glasses", 4, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_MANDATORY),

			list("SPECIAL AMMUNITION", 0, null, null, null),
			list("Type 71 AP Magazine (5.45x39mm)", 10, /obj/item/ammo_magazine/rifle/type71/ap , null, VENDOR_ITEM_REGULAR),

			list("ATTACHMENTS", 0, null, null, null),
			list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
			list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
			list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
			list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
			list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
			list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
			list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

			list("EXPLOSIVES", 0, null, null, null),
			list("Plastic Explosive", 5, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
			list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
			list("Type 6 Shrapnel Grenade", 15, /obj/item/explosive/grenade/HE/upp, null, VENDOR_ITEM_REGULAR),
			list("Type 8 WP Grenade", 20, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

			list("UTILITIES", 0, null, null, null),
			list("Brown Webbing Vest", 10, /obj/item/clothing/accessory/storage/black_vest/brown_vest, null, VENDOR_ITEM_RECOMMENDED),
			list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
			list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
			list("Shoulder Holster", 10, /obj/item/clothing/accessory/holster, null, VENDOR_ITEM_REGULAR),
			list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR)
		),

		//------------CLF SECTION---------------

		JOB_CLF = list(

			list("ENGINEERING SUPPLIES", 0, null, null, null),
			list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_RECOMMENDED),
			list("Sandbags x25", 5, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),

			list("SPECIAL AMMUNITION", 0, null, null, null),
			list("M16 AP Magazine (5.56x45mm)", 10, /obj/item/ammo_magazine/rifle/m16/ap, null, VENDOR_ITEM_REGULAR),
			list("MAR Extended Magazine (7.62x39mm)", 10, /obj/item/ammo_magazine/rifle/mar40/extended, null, VENDOR_ITEM_REGULAR),
			list("Shotgun Incendiary Shells (Handful)", 15, /obj/item/ammo_magazine/handful/shotgun/incendiary, null, VENDOR_ITEM_REGULAR),

			list("EXPLOSIVES", 0, null, null, null),
			list("EMP Grenade", 10, /obj/item/explosive/grenade/empgrenade, null, VENDOR_ITEM_REGULAR),
			list("Improvised Explosive Device", 15, /obj/item/explosive/grenade/custom/ied, null, VENDOR_ITEM_REGULAR),
			list("Improvised Firebomb", 10, /obj/item/explosive/grenade/incendiary/molotov, null, VENDOR_ITEM_REGULAR),
			list("Incendiary IED", 15, /obj/item/explosive/grenade/custom/ied_incendiary, null, VENDOR_ITEM_REGULAR),
			list("Improvised Phosphorus Bomb", 20, /obj/item/explosive/grenade/phosphorus/clf, null, VENDOR_ITEM_REGULAR),
			list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),

			list("UTILITIES", 0, null, null, null),
			list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
			list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
			list("Random Useful (Or Not) Item", 5, /obj/effect/essentials_set/random/clf_bonus_item, null, VENDOR_ITEM_REGULAR),
			list("Shoulder Holster", 10, /obj/item/clothing/accessory/holster, null, VENDOR_ITEM_REGULAR),
			list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR)
		),

		JOB_CLF_ENGI = list(

			list("MECHANIC SET (MANDATORY)", 0, null, null, null),
			list("Essential Mechanic Set", 0, /obj/effect/essentials_set/engi, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

			list("ENGINEERING SUPPLIES", 0, null, null, null),
			list("Airlock Circuit Board", 2, /obj/item/circuitboard/airlock, null, VENDOR_ITEM_REGULAR),
			list("APC Circuit Board", 2, /obj/item/circuitboard/apc, null, VENDOR_ITEM_REGULAR),
			list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
			list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
			list("High-Capacity Power Cell", 3, /obj/item/cell/high, null, VENDOR_ITEM_REGULAR),
			list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, VENDOR_ITEM_RECOMMENDED),
			list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, VENDOR_ITEM_RECOMMENDED),
			list("Range Finder", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
			list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),

			list("SPECIAL AMMUNITION", 0, null, null, null),
			list("M16 AP Magazine (5.56x45mm)", 10, /obj/item/ammo_magazine/rifle/m16/ap, null, VENDOR_ITEM_REGULAR),
			list("MAR Extended Magazine (7.62x39mm)", 10, /obj/item/ammo_magazine/rifle/mar40/extended, null, VENDOR_ITEM_REGULAR),
			list("Shotgun Incendiary Shells (Handful)", 15, /obj/item/ammo_magazine/handful/shotgun/incendiary, null, VENDOR_ITEM_REGULAR),

			list("EXPLOSIVES", 0, null, null, null),
			list("EMP Grenade", 10, /obj/item/explosive/grenade/empgrenade, null, VENDOR_ITEM_REGULAR),
			list("Improvised Explosive Device", 15, /obj/item/explosive/grenade/custom/ied, null, VENDOR_ITEM_REGULAR),
			list("Improvised Firebomb", 10, /obj/item/explosive/grenade/incendiary/molotov, null, VENDOR_ITEM_REGULAR),
			list("Incendiary IED", 15, /obj/item/explosive/grenade/custom/ied_incendiary, null, VENDOR_ITEM_REGULAR),
			list("Improvised Phosphorus Bomb", 20, /obj/item/explosive/grenade/phosphorus/clf, null, VENDOR_ITEM_REGULAR),
			list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),

			list("UTILITIES", 0, null, null, null),
			list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
			list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
			list("Random Useful (Or Not) Item", 5, /obj/effect/essentials_set/random/clf_bonus_item, null, VENDOR_ITEM_REGULAR),
			list("Shoulder Holster", 10, /obj/item/clothing/accessory/holster, null, VENDOR_ITEM_REGULAR),
			list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR)
		),

		JOB_CLF_MEDIC = list(

			list("PARAMEDIC SET (MANDATORY)", 0, null, null, null),
			list("Essential Medic Set", 0, /obj/effect/essentials_set/medic/upp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

			list("FIELD SUPPLIES", 0, null, null, null),
			list("Adv Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_RECOMMENDED),
			list("Adv Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_RECOMMENDED),
			list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_RECOMMENDED),
			list("Firstaid Kit", 6, /obj/item/storage/firstaid/regular, null, VENDOR_ITEM_REGULAR),
			list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_RECOMMENDED),

			list("AUTOINJECTORS", 0, null, null, null),
			list("Autoinjector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
			list("Autoinjector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
			list("Autoinjector (Epinephrine)", 2, /obj/item/reagent_container/hypospray/autoinjector/adrenaline, null, VENDOR_ITEM_REGULAR),
			list("Autoinjector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
			list("Autoinjector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
			list("Autoinjector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
			list("Autoinjector (QuickClot)", 1, /obj/item/reagent_container/hypospray/autoinjector/quickclot, null, VENDOR_ITEM_REGULAR),
			list("Autoinjector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
			list("Autoinjector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

			list("PILL BOTTLES", 0, null, null, null),
			list("Pill Bottle (Bicaridine)", 5, /obj/item/storage/pill_bottle/bicaridine, null, VENDOR_ITEM_RECOMMENDED),
			list("Pill Bottle (Dexalin)", 5, /obj/item/storage/pill_bottle/dexalin, null, VENDOR_ITEM_REGULAR),
			list("Pill Bottle (Dylovene)", 5, /obj/item/storage/pill_bottle/antitox, null, VENDOR_ITEM_REGULAR),
			list("Pill Bottle (Inaprovaline)", 5, /obj/item/storage/pill_bottle/inaprovaline, null, VENDOR_ITEM_REGULAR),
			list("Pill Bottle (Kelotane)", 5, /obj/item/storage/pill_bottle/kelotane, null, VENDOR_ITEM_RECOMMENDED),
			list("Pill Bottle (Peridaxon)", 5, /obj/item/storage/pill_bottle/peridaxon, null, VENDOR_ITEM_REGULAR),
			list("Pill Bottle (QuickClot)", 5, /obj/item/storage/pill_bottle/quickclot, null, VENDOR_ITEM_REGULAR),
			list("Pill Bottle (Tramadol)", 5, /obj/item/storage/pill_bottle/tramadol, null, VENDOR_ITEM_RECOMMENDED),

			list("MEDICAL UTILITIES", 0, null, null, null),
			list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
			list("Medical HUD Glasses", 4, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_REGULAR),
			list("Roller Bed", 4, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
			list("Stasis Bag", 6, /obj/item/bodybag/cryobag, null, VENDOR_ITEM_REGULAR),

			list("SPECIAL AMMUNITION", 0, null, null, null),
			list("M16 AP Magazine (5.56x45mm)", 10, /obj/item/ammo_magazine/rifle/m16/ap, null, VENDOR_ITEM_REGULAR),
			list("MAR Extended Magazine (7.62x39mm)", 10, /obj/item/ammo_magazine/rifle/mar40/extended, null, VENDOR_ITEM_REGULAR),
			list("Shotgun Incendiary Shells (Handful)", 15, /obj/item/ammo_magazine/handful/shotgun/incendiary, null, VENDOR_ITEM_REGULAR),

			list("EXPLOSIVES", 0, null, null, null),
			list("EMP Grenade", 10, /obj/item/explosive/grenade/empgrenade, null, VENDOR_ITEM_REGULAR),
			list("Improvised Explosive Device", 15, /obj/item/explosive/grenade/custom/ied, null, VENDOR_ITEM_REGULAR),
			list("Improvised Firebomb", 10, /obj/item/explosive/grenade/incendiary/molotov, null, VENDOR_ITEM_REGULAR),
			list("Incendiary IED", 15, /obj/item/explosive/grenade/custom/ied_incendiary, null, VENDOR_ITEM_REGULAR),
			list("Improvised Phosphorus Bomb", 20, /obj/item/explosive/grenade/phosphorus/clf, null, VENDOR_ITEM_REGULAR),
			list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),

			list("UTILITIES", 0, null, null, null),
			list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
			list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
			list("Random Useful (Or Not) Item", 5, /obj/effect/essentials_set/random/clf_bonus_item, null, VENDOR_ITEM_REGULAR),
			list("Shoulder Holster", 10, /obj/item/clothing/accessory/holster, null, VENDOR_ITEM_REGULAR),
			list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR)
		),

		JOB_CLF_SPECIALIST = list(

			list("GUNNER KITS (CHOOSE 1)", 0, null, null, null),
			list("SVD Sniper Kit", 0, /obj/effect/essentials_set/kit/svd, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),
			list("Custom Built Shotgun Kit", 0, /obj/effect/essentials_set/kit/custom_shotgun, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),
			list("M60 Machine Gun Kit", 0, /obj/effect/essentials_set/kit/m60, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),

			list("SPECIAL AMMUNITION", 0, null, null, null),
			list("M60 Ammo Box (7.62x51mm)", 15, /obj/item/ammo_magazine/m60, null, VENDOR_ITEM_REGULAR),
			list("Shotgun Incendiary Shells (Handful)", 15, /obj/item/ammo_magazine/handful/shotgun/incendiary, null, VENDOR_ITEM_REGULAR),
			list("SVD Magazine (7.62x54mmR)", 15, /obj/item/ammo_magazine/sniper/svd, null, VENDOR_ITEM_REGULAR),

			list("EXPLOSIVES", 0, null, null, null),
			list("EMP Grenade", 10, /obj/item/explosive/grenade/empgrenade, null, VENDOR_ITEM_REGULAR),
			list("Improvised Explosive Device", 15, /obj/item/explosive/grenade/custom/ied, null, VENDOR_ITEM_REGULAR),
			list("Improvised Firebomb", 10, /obj/item/explosive/grenade/incendiary/molotov, null, VENDOR_ITEM_REGULAR),
			list("Incendiary IED", 15, /obj/item/explosive/grenade/custom/ied_incendiary, null, VENDOR_ITEM_REGULAR),
			list("Improvised Phosphorus Bomb", 20, /obj/item/explosive/grenade/phosphorus/clf, null, VENDOR_ITEM_REGULAR),
			list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),

			list("UTILITIES", 0, null, null, null),
			list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
			list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
			list("Random Useful (Or Not) Item", 5, /obj/effect/essentials_set/random/clf_bonus_item, null, VENDOR_ITEM_REGULAR),
			list("Shoulder Holster", 10, /obj/item/clothing/accessory/holster, null, VENDOR_ITEM_REGULAR),
			list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR)
		),

		JOB_CLF_LEADER = list(

			list("CELL LEADER SET (MANDATORY)", 0, null, null, null),
			list("Essential Leader Set", 0, /obj/effect/essentials_set/leader/upp, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

			list("GENERAL SUPPLIES", 0, null, null, null),
			list("Megaphone", 5, /obj/item/device/megaphone, null, VENDOR_ITEM_REGULAR),
			list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),

			list("ENGINEERING SUPPLIES", 0, null, null, null),
			list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
			list("Insulated Gloves", 3, /obj/item/clothing/gloves/yellow, null, VENDOR_ITEM_REGULAR),
			list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, VENDOR_ITEM_RECOMMENDED),
			list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, VENDOR_ITEM_RECOMMENDED),
			list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),
			list("Tools Pouch (Full)", 5, /obj/item/storage/pouch/tools/full, null, VENDOR_ITEM_REGULAR),
			list("Welding Goggles", 5, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),

			list("MEDICAL SUPPLIES", 0, null, null, null),
			list("Adv Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_REGULAR),
			list("Adv Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_REGULAR),
			list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_REGULAR),
			list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_REGULAR),

			list("Injector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
			list("Injector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
			list("Injector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
			list("Injector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
			list("Injector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
			list("Injector (QuickClot)", 1, /obj/item/reagent_container/hypospray/autoinjector/quickclot, null, VENDOR_ITEM_REGULAR),
			list("Injector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
			list("Injector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

			list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
			list("Sensor Medical HUD", 4, /obj/item/clothing/glasses/hud/sensor, null, VENDOR_ITEM_MANDATORY),

			list("SPECIAL AMMUNITION", 0, null, null, null),
			list("M16 AP Magazine (5.56x45mm)", 10, /obj/item/ammo_magazine/rifle/m16/ap, null, VENDOR_ITEM_REGULAR),
			list("MAR Extended Magazine (7.62x39mm)", 10, /obj/item/ammo_magazine/rifle/mar40/extended, null, VENDOR_ITEM_REGULAR),
			list("Shotgun Incendiary Shells (Handful)", 15, /obj/item/ammo_magazine/handful/shotgun/incendiary, null, VENDOR_ITEM_REGULAR),

			list("EXPLOSIVES", 0, null, null, null),
			list("EMP Grenade", 10, /obj/item/explosive/grenade/empgrenade, null, VENDOR_ITEM_REGULAR),
			list("Improvised Explosive Device", 15, /obj/item/explosive/grenade/custom/ied, null, VENDOR_ITEM_REGULAR),
			list("Improvised Firebomb", 10, /obj/item/explosive/grenade/incendiary/molotov, null, VENDOR_ITEM_REGULAR),
			list("Incendiary IED", 15, /obj/item/explosive/grenade/custom/ied_incendiary, null, VENDOR_ITEM_REGULAR),
			list("Improvised Phosphorus Bomb", 20, /obj/item/explosive/grenade/phosphorus/clf, null, VENDOR_ITEM_REGULAR),
			list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),

			list("UTILITIES", 0, null, null, null),
			list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
			list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
			list("Random Useful (Or Not) Item", 5, /obj/effect/essentials_set/random/clf_bonus_item, null, VENDOR_ITEM_REGULAR),
			list("Shoulder Holster", 10, /obj/item/clothing/accessory/holster, null, VENDOR_ITEM_REGULAR),
			list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR)
		)
	)

/obj/structure/machinery/cm_vending/gear/antag/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 0)

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
	if(listed_products.Find(H.job))			//just in case
		products_sets = listed_products[H.job]
	else
		products_sets = listed_products[JOB_CLF]

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

/obj/structure/machinery/cm_vending/gear/antag/Topic(href, href_list)
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
			var/list/L = listed_products[H.job][idx]
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

/obj/structure/machinery/cm_vending/gear/antag/vend_succesfully(var/list/L, var/mob/living/carbon/human/H)
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
				O.forceMove(get_appropriate_vend_turf())
		else
			if(ispath(prod_type, /obj/item/weapon/gun))
				O = new prod_type(get_appropriate_vend_turf(), TRUE)
			else
				O = new prod_type(get_appropriate_vend_turf())
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
		/obj/item/ammo_magazine/minigun
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
		/obj/item/ammo_magazine/m60
	)

/obj/effect/essentials_set/random/clf_bonus_item
	spawned_gear_list = list(
					/obj/item/storage/pill_bottle/tramadol/skillless,
					/obj/item/storage/pill_bottle/tramadol/skillless,
					/obj/item/storage/pill_bottle/tramadol/skillless,
					/obj/item/tool/hatchet,
					/obj/item/tool/hatchet,
					/obj/item/weapon/melee/twohanded/spear,
					/obj/item/reagent_container/spray/pepper,
					/obj/item/reagent_container/spray/pepper,
					/obj/item/reagent_container/spray/pepper,
					/obj/item/reagent_container/ld50_syringe/choral,
					/obj/item/storage/bible,
					/obj/item/clothing/mask/gas/PMC,
					/obj/item/clothing/accessory/holster,
					/obj/item/clothing/accessory/storage/webbing,
					/obj/item/storage/pill_bottle/happy,
					/obj/item/storage/pill_bottle/happy,
					/obj/item/storage/pill_bottle/happy,
					/obj/item/explosive/grenade/smokebomb,
					)