/obj/structure/machinery/cm_vending/clothing/senior_officer
	name = "\improper Broken ColMarTech Senior Officer Equipment Rack"
	desc = "An automated equipment vendor for Senior Officers. Sadly, it doesn't work."
	req_access = list(777)//ACCESS_MARINE_BRIDGE
	vendor_role = list(JOB_CHIEF_POLICE)//JOB_CMO,JOB_XO,JOB_CHIEF_ENGINEER,JOB_CHIEF_REQUISITION

/obj/structure/machinery/cm_vending/clothing/senior_officer/Initialize(mapload, ...)
	. = ..()
	listed_products = GLOB.cm_vending_clothing_military_police_chief

/*
/obj/structure/machinery/cm_vending/clothing/senior_officer/get_listed_products(mob/user)
	if(user.job == JOB_XO)
		return GLOB.cm_vending_clothing_xo
	else if(user.job == JOB_CHIEF_ENGINEER)
		return GLOB.cm_vending_clothing_chief_engie
	else if(user.job == JOB_CHIEF_REQUISITION)
		return GLOB.cm_vending_clothing_req_officer
	else if(user.job == JOB_CMO)
		return GLOB.cm_vending_clothing_cmo
	return ..()
*/


//------------ CHIEF MP---------------
GLOBAL_LIST_INIT(cm_vending_clothing_military_police_chief, list(

		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("CMP Uniform", 0, /obj/item/clothing/under/marine/officer/warrant, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/cmpcom, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Satchel", 0, /obj/item/storage/backpack/satchel/sec, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("PERSONAL SIDEARM (CHOOSE 1)", 0, null, null, null),
		list("M4A3 Custom Pistol", 0, /obj/item/storage/belt/gun/m4a3/commander, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Mod 88 Pistol", 0, /obj/item/storage/belt/gun/m4a3/mod88, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M44 Revolver", 0, /obj/item/storage/belt/gun/m44/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("Military Police Chief M3 Armor", 0, /obj/item/clothing/suit/storage/marine/MP/WO, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Military Police Chief M3 Padless Armor", 0, /obj/item/clothing/suit/storage/marine/MP/WO/padless, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),

		list("COMBAT EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Military Police M10 Helmet", 0, /obj/item/clothing/head/helmet/marine/MP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),

		list("EYEWEAR (TAKE ALL)", 0, null, null, null),
		list("Security HUD Glasses", 0, /obj/item/clothing/glasses/sunglasses/sechud, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("First-Aid Pouch (Full)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("HAT (CHOOSE 1)", 0, null, null, null),
		list("CMP Beret", 0, /obj/item/clothing/head/helmet/beret/marine/mp/cmp, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
	))
