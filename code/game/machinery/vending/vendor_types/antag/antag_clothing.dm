//------------ADAPTIVE ANTAG CLOSET---------------
//Spawn one of these bad boys and you will have a proper automated closet for CLF/UPP players (for now, more can be always added later)

/obj/structure/machinery/cm_vending/clothing/antag
	name = "\improper Suspicious Automated Equipment Rack"
	desc = "While similar in function to ColMarTech automated racks, this one is clearly not of USCM origin. Contains various equipment."
	icon_state = "antag_clothing"
	vendor_role = VENDOR_ANTAG_JOBS
	req_access = list(ACCESS_ILLEGAL_PIRATE)

	listed_products = list(

		JOB_UPP = list(
			list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
			list("Boots", 0, /obj/item/clothing/shoes/marine/upp, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
			list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
			list("UM5 Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
			list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/PMC, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
			list("Headset", 0, /obj/item/device/radio/headset/distress/UPP, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
			list("Ration", 0, /obj/item/reagent_container/food/snacks/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
			list("Combat Pack", 0, /obj/item/storage/backpack/lightpack/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

			list("HELMET", 0, null, null, null),
			list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),

			list("BELT (CHOOSE 1)", 0, null, null, null),
			list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
			list("Type 41 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

			list("POUCHES (CHOOSE 2)", 0, null, null, null),
			list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Firstaid Pouch (Full)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

			list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
			list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

			list("MASK (CHOOSE 1)", 0, null, null, null),
			list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
			list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
		),

		JOB_UPP_ENGI = list(
			list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
			list("Boots", 0, /obj/item/clothing/shoes/marine/upp, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
			list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
			list("UM5 Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
			list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/PMC, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
			list("Headset", 0, /obj/item/device/radio/headset/distress/UPP, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
			list("Welding Goggles", 0, /obj/item/clothing/glasses/welding, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
			list("Ration", 0, /obj/item/reagent_container/food/snacks/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
			list("Welderpack", 0, /obj/item/storage/backpack/marine/engineerpack/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

			list("HELMET (CHOOSE 1)", 0, null, null, null),
			list("Armored Cap", 0, /obj/item/clothing/head/uppcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
			list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

			list("BELT (Choose 1)", 0, null, null, null),
			list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
			list("Type 41 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
			list("Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

			list("POUCHES (Choose 2)", 0, null, null, null),
			list("Construction Pouch", 0, /obj/item/storage/pouch/construction, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Firstaid Pouch (Full)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Electronics Pouch (Full)", 0, /obj/item/storage/pouch/electronics/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

			list("MASK (CHOOSE 1)", 0, null, null, null),
			list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
			list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
		),

		JOB_UPP_MEDIC = list(
			list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
			list("Boots", 0, /obj/item/clothing/shoes/marine/upp, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
			list("Medic Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP/medic, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
			list("UM5 Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
			list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/PMC, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
			list("Headset", 0, /obj/item/device/radio/headset/distress/UPP, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
			list("Ration", 0, /obj/item/reagent_container/food/snacks/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
			list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
			list("HealthMate HUD", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),

			list("HELMET (CHOOSE 1)", 0, null, null, null),
			list("Armored Cap", 0, /obj/item/clothing/head/uppcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
			list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

			list("BELT", 0, null, null, null),
			list("Type 41 Lifesaver Bag", 0, /obj/item/storage/belt/medical/lifesaver/upp/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_MANDATORY),

			list("POUCHES (CHOOSE 2)", 0, null, null, null),
			list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("First Responder Technical Pouch", 0, /obj/item/storage/pouch/medical/frt_kit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Firstaid Pouch (Full)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Medical Pouch", 0, /obj/item/storage/pouch/medical, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

			list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
			list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

			list("MASK (CHOOSE 1)", 0, null, null, null),
			list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
			list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
		),

		JOB_UPP_SPECIALIST = list(
			list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
			list("Boots", 0, /obj/item/clothing/shoes/marine/upp, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
			list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
			list("UH7 Heavy Plated Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/heavy, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
			list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/PMC, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
			list("Headset", 0, /obj/item/device/radio/headset/distress/UPP, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
			list("Ration", 0, /obj/item/reagent_container/food/snacks/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
			list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

			list("HELMET", 0, null, null, null),
			list("UM7 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP/heavy, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),

			list("BELT (CHOOSE 1)", 0, null, null, null),
			list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
			list("Type 41 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

			list("POUCHES (CHOOSE 2)", 0, null, null, null),
			list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Firstaid Pouch (Full)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

			list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
			list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

			list("MASK (CHOOSE 1)", 0, null, null, null),
			list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
			list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
		),

		JOB_UPP_LEADER = list(
			list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
			list("Boots", 0, /obj/item/clothing/shoes/marine/upp, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
			list("Fatigues", 0, /obj/item/clothing/under/marine/veteran/UPP, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
			list("UH7 Heavy Plated Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/heavy, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
			list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/PMC, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
			list("Headset", 0, /obj/item/device/radio/headset/distress/UPP, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
			list("Ration", 0, /obj/item/reagent_container/food/snacks/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
			list("Combat Pack", 0, /obj/item/storage/backpack/lightpack/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

			list("HELMET (CHOOSE 1)", 0, null, null, null),
			list("Armored Beret", 0, /obj/item/clothing/head/uppcap/beret, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
			list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

			list("BELT (CHOOSE 1)", 0, null, null, null),
			list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
			list("Type 41 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

			list("POUCHES (CHOOSE 2)", 0, null, null, null),
			list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Firstaid Pouch (Full)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

			list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
			list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

			list("MASK (CHOOSE 1)", 0, null, null, null),
			list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
			list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
		),

		//------------UPP COMMANDO SECTION---------------

		JOB_UPP_COMMANDO = list(
			list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
			list("Boots", 0, /obj/item/clothing/shoes/marine/upp, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
			list("Fatigues", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/commando, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
			list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/PMC, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
			list("Headset", 0, /obj/item/device/radio/headset/distress/UPP, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
			list("Night Vision Goggles", 0, /obj/item/clothing/glasses/night/m42_night_goggles/upp, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
			list("Ration", 0, /obj/item/reagent_container/food/snacks/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
			list("UM5CU Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/commando, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
			list("UPP Cloak", 0, /obj/item/storage/backpack/marine/satchel/scout_cloak/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
			list("UPP Balaclava", 0, /obj/item/clothing/mask/gas/PMC/upp, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),

			list("HELMET (CHOOSE 1)", 0, null, null, null),
			list("Armored Cap", 0, /obj/item/clothing/head/uppcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
			list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

			list("BELT (CHOOSE 1)", 0, null, null, null),
			list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
			list("Type 41 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/type47/PK9/tranq, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

			list("POUCHES (CHOOSE 2)", 0, null, null, null),
			list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Firstaid Pouch (Full)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

			list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
			list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

			list("MASK (CHOOSE 1)", 0, null, null, null),
			list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
			list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
		),

		JOB_UPP_COMMANDO_LEADER = list(
			list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
			list("Boots", 0, /obj/item/clothing/shoes/marine/upp, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
			list("Fatigues", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/commando, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
			list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/PMC, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
			list("Headset", 0, /obj/item/device/radio/headset/distress/UPP, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
			list("Night Vision Goggles", 0, /obj/item/clothing/glasses/night/m42_night_goggles/upp, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
			list("Ration", 0, /obj/item/reagent_container/food/snacks/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
			list("UM5CU Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/commando, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
			list("UPP Cloak", 0, /obj/item/storage/backpack/marine/satchel/scout_cloak/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
			list("UPP Balaclava", 0, /obj/item/clothing/mask/gas/PMC/upp, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),

			list("HELMET (CHOOSE 1)", 0, null, null, null),
			list("Armored Cap", 0, /obj/item/clothing/head/uppcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
			list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

			list("BELT (CHOOSE 1)", 0, null, null, null),
			list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
			list("Type 41 Pistol Holster Rig", 0, /obj/item/storage/belt/gun/type47/PK9/tranq, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

			list("POUCHES (CHOOSE 2)", 0, null, null, null),
			list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Firstaid Pouch (Full)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

			list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
			list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

			list("MASK (CHOOSE 1)", 0, null, null, null),
			list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
			list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
		),

		JOB_UPP_COMMANDO_MEDIC = list(
			list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
			list("Boots", 0, /obj/item/clothing/shoes/marine/upp, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
			list("Fatigues Medic", 0, /obj/item/clothing/under/marine/veteran/UPP/medic, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
			list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/PMC, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
			list("Headset", 0, /obj/item/device/radio/headset/distress/UPP, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
			list("HealthMate HUD", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
			list("Night Vision Goggles", 0, /obj/item/clothing/glasses/night/m42_night_goggles/upp, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
			list("Ration", 0, /obj/item/reagent_container/food/snacks/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
			list("UM5CU Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/commando, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
			list("UPP Cloak", 0, /obj/item/storage/backpack/marine/satchel/scout_cloak/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
			list("UPP Balaclava", 0, /obj/item/clothing/mask/gas/PMC/upp, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),

			list("HELMET (CHOOSE 1)", 0, null, null, null),
			list("Armored Cap", 0, /obj/item/clothing/head/uppcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
			list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

			list("BELT", 0, null, null, null),
			list("Type 41 Lifesaver Bag", 0, /obj/item/storage/belt/medical/lifesaver/upp/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_MANDATORY),
			list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

			list("POUCHES (CHOOSE 2)", 0, null, null, null),
			list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("First Responder Technical Pouch", 0, /obj/item/storage/pouch/medical/frt_kit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Firstaid Pouch (Full)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Medical Pouch", 0, /obj/item/storage/pouch/medical, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

			list("ATTACHMENT (CHOOSE 1)", 0, null, null, null),
			list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

			list("MASK (CHOOSE 1)", 0, null, null, null),
			list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
			list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
		),

		//------------CLF SECTION---------------

		JOB_CLF = list(
			list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
			list("CLF Shoes (Random)", 0, /obj/effect/essentials_set/random/clf_shoes, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
			list("CLF Uniform", 0, /obj/item/clothing/under/colonist/clf, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
			list("CLF Armor (Random)", 0, /obj/effect/essentials_set/random/clf_armor, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
			list("CLF Gloves (Random)", 0, /obj/effect/essentials_set/random/clf_gloves, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
			list("CLF Belt (Random)", 0, /obj/effect/essentials_set/random/clf_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_MANDATORY),
			list("CLF Head Gear (Random)", 0, /obj/effect/essentials_set/random/clf_head, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
			list("Headset", 0, /obj/item/device/radio/headset/distress/dutch, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
			list("Flashlight", 0, /obj/item/device/flashlight, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
			list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

			list("POUCHES (CHOOSE 2)", 0, null, null, null),
			list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Firstaid Pouch (Full)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

			list("ATTACHMENTS (CHOOSE 1)", 0, null, null, null),
			list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Gyroscopic Stabilizer", 0, /obj/item/attachable/gyro, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Masterkey Shotgun", 0, /obj/item/attachable/attached_gun/shotgun, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Recoil Compensator", 0, /obj/item/attachable/compensator, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

			list("MASK (CHOOSE 1)", 0, null, null, null),
			list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
			list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
		),

		JOB_CLF_ENGI = list(
			list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
			list("CLF Shoes (Random)", 0, /obj/effect/essentials_set/random/clf_shoes, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
			list("CLF Uniform", 0, /obj/item/clothing/under/colonist/clf, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
			list("CLF Armor (Random)", 0, /obj/effect/essentials_set/random/clf_armor, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
			list("Insulated Gloves", 0, /obj/item/clothing/gloves/yellow, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
			list("Headset", 0, /obj/item/device/radio/headset/distress/dutch, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
			list("Flashlight", 0, /obj/item/device/flashlight, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
			list("Welderpack", 0, /obj/item/storage/backpack/marine/engineerpack/ert, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

			list("BELT (CHOOSE 1)", 0, null, null, null),
			list("CLF Belt (Random)", 0, /obj/effect/essentials_set/random/clf_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
			list("Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

			list("POUCHES (CHOOSE 2)", 0, null, null, null),
			list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Construction Pouch", 0, /obj/item/storage/pouch/construction, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Electronics Pouch (Full)", 0, /obj/item/storage/pouch/electronics/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Firstaid Pouch (Full)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

			list("ATTACHMENTS (CHOOSE 1)", 0, null, null, null),
			list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Gyroscopic Stabilizer", 0, /obj/item/attachable/gyro, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Masterkey Shotgun", 0, /obj/item/attachable/attached_gun/shotgun, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Recoil Compensator", 0, /obj/item/attachable/compensator, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

			list("MASK (CHOOSE 1)", 0, null, null, null),
			list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
			list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
		),

		JOB_CLF_MEDIC = list(
			list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
			list("CLF Shoes (Random)", 0, /obj/effect/essentials_set/random/clf_shoes, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
			list("CLF Uniform", 0, /obj/item/clothing/under/colonist/clf, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
			list("CLF Armor (Random)", 0, /obj/effect/essentials_set/random/clf_armor, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
			list("CLF Gloves (Random)", 0, /obj/effect/essentials_set/random/clf_gloves, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
			list("CLF Head Gear (Random)", 0, /obj/effect/essentials_set/random/clf_head, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
			list("Headset", 0, /obj/item/device/radio/headset/distress/dutch, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
			list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
			list("Flashlight", 0, /obj/item/device/flashlight, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
			list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

			list("BELT (CHOOSE 1)", 0, null, null, null),
			list("CLF Belt (Random)", 0, /obj/effect/essentials_set/random/clf_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
			list("Medical Storage Rig", 0, /obj/item/storage/belt/medical, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

			list("POUCHES (CHOOSE 2)", 0, null, null, null),
			list("Auto-Injector Pouch", 0, /obj/item/storage/pouch/autoinjector, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("First Responder Technical Pouch", 0, /obj/item/storage/pouch/medical/frt_kit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Firstaid Pouch (Full)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Medical Pouch", 0, /obj/item/storage/pouch/medical, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

			list("ATTACHMENTS (CHOOSE 1)", 0, null, null, null),
			list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Gyroscopic Stabilizer", 0, /obj/item/attachable/gyro, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Masterkey Shotgun", 0, /obj/item/attachable/attached_gun/shotgun, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Recoil Compensator", 0, /obj/item/attachable/compensator, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

			list("MASK (CHOOSE 1)", 0, null, null, null),
			list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
			list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
		),

		JOB_CLF_SPECIALIST = list(
			list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
			list("Combat Boots", 0, /obj/item/clothing/shoes/combat, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
			list("CLF Uniform", 0, /obj/item/clothing/under/colonist/clf, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
			list("CLF Armor", 0, /obj/item/clothing/suit/storage/militia, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
			list("Combat Gloves", 0, /obj/item/clothing/gloves/combat, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
			list("G8-A General Utility Pouch", 0, /obj/item/storage/sparepouch, MARINE_CAN_BUY_BELT, VENDOR_ITEM_MANDATORY),
			list("SWAT Helmet", 0, /obj/item/clothing/head/helmet/swat, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
			list("Headset", 0, /obj/item/device/radio/headset/distress/dutch, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
			list("Flashlight", 0, /obj/item/device/flashlight, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
			list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

			list("POUCHES (CHOOSE 2)", 0, null, null, null),
			list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Firstaid Pouch (Full)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

			list("ATTACHMENTS (CHOOSE 1)", 0, null, null, null),
			list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Gyroscopic Stabilizer", 0, /obj/item/attachable/gyro, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Masterkey Shotgun", 0, /obj/item/attachable/attached_gun/shotgun, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Recoil Compensator", 0, /obj/item/attachable/compensator, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

			list("MASK (CHOOSE 1)", 0, null, null, null),
			list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
			list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
		),

		JOB_CLF_LEADER = list(
			list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
			list("Combat Boots", 0, /obj/item/clothing/shoes/combat, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
			list("CLF Uniform", 0, /obj/item/clothing/under/colonist/clf, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
			list("CLF Armor", 0, /obj/item/clothing/suit/storage/militia, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
			list("Black Gloves", 0, /obj/item/clothing/gloves/black, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
			list("CLF Belt (Random)", 0, /obj/effect/essentials_set/random/clf_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_MANDATORY),
			list("Headset", 0, /obj/item/device/radio/headset/distress/dutch, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
			list("Flashlight", 0, /obj/item/device/flashlight, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
			list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

			list("HELMET (CHOOSE 1)", 0, null, null, null),
			list("CLF Head Gear (Random)", 0, /obj/effect/essentials_set/random/clf_head, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
			list("Officer Beret", 0, /obj/item/clothing/head/beret/sec/hos, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),

			list("POUCHES (CHOOSE 2)", 0, null, null, null),
			list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Firstaid Pouch (Full)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
			list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
			list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

			list("ATTACHMENTS (CHOOSE 1)", 0, null, null, null),
			list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Gyroscopic Stabilizer", 0, /obj/item/attachable/gyro, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Masterkey Shotgun", 0, /obj/item/attachable/attached_gun/shotgun, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Recoil Compensator", 0, /obj/item/attachable/compensator, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
			list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

			list("MASK (CHOOSE 1)", 0, null, null, null),
			list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
			list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
		)
	)

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

/obj/structure/machinery/cm_vending/clothing/antag/Topic(href, href_list)
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
			var/list/L = listed_products[H.job][idx]
			for(var/i in L)
				to_chat(H, SPAN_WARNING("L: [i]"))
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

		add_fingerprint(usr)
		ui_interact(usr) //updates the nanoUI window

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

		vending_stat_bump(prod_type, src.type)
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
					/obj/item/clothing/head/helmet/durag,
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
					/obj/item/storage/sparepouch,
					/obj/item/storage/sparepouch,
					/obj/item/storage/sparepouch,
					/obj/item/storage/belt/knifepouch,
					/obj/item/storage/large_holster/katana/full,
					/obj/item/storage/large_holster/machete/full
					)
