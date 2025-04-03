/obj/structure/machinery/cm_vending/clothing/senior_officer
	name = "\improper ColMarTech Senior Officer Equipment Rack"
	desc = "An automated equipment vendor for Senior Officers."
	req_access = list(ACCESS_MARINE_SENIOR)
	vendor_role = list(JOB_CHIEF_POLICE, JOB_CMO, JOB_XO, JOB_CHIEF_ENGINEER, JOB_CHIEF_REQUISITION, JOB_AUXILIARY_OFFICER)

/obj/structure/machinery/cm_vending/clothing/senior_officer/get_listed_products(mob/user)
	if(!user)
		var/list/combined = list()
		combined += GLOB.cm_vending_clothing_xo
		combined += GLOB.cm_vending_clothing_chief_engineer
		combined += GLOB.cm_vending_clothing_req_officer
		combined += GLOB.cm_vending_clothing_cmo
		combined += GLOB.cm_vending_clothing_military_police_chief
		combined += GLOB.cm_vending_clothing_auxiliary_officer
		return combined
	if(user.job == JOB_XO)
		return GLOB.cm_vending_clothing_xo
	else if(user.job == JOB_CHIEF_ENGINEER)
		return GLOB.cm_vending_clothing_chief_engineer
	else if(user.job == JOB_CHIEF_REQUISITION)
		return GLOB.cm_vending_clothing_req_officer
	else if(user.job == JOB_CMO)
		return GLOB.cm_vending_clothing_cmo
	else if(user.job == JOB_CHIEF_POLICE)
		return GLOB.cm_vending_clothing_military_police_chief
	else if(user.job == JOB_AUXILIARY_OFFICER)
		return GLOB.cm_vending_clothing_auxiliary_officer
	return ..()


//------------ CHIEF MP ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_military_police_chief, list(
		list("POLICE SET (MANDATORY)", 0, null, null, null),
		list("Essential Police Set", 0, /obj/effect/essentials_set/chiefmilitarypolice, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("CMP Uniform", 0, /obj/item/clothing/under/marine/officer/warrant, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/cmpcom, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),

		list("ARMOR (TAKE ALL)", 0, null, null, null),
		list("Military Police Chief M3 Armor", 0, /obj/item/clothing/suit/storage/marine/MP/WO, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
		list("Chief MP M10 Helmet", 0, /obj/item/clothing/head/helmet/marine/MP/WO, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("CMP Beret", 0, /obj/item/clothing/head/beret/marine/mp/cmp, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),

		list("HANDGUN CASE (CHOOSE 1)", 0, null, null, null),
		list("88 mod 4 Combat Pistol Case", 0, /obj/item/storage/box/guncase/mod88, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("M44 Combat Revolver Case", 0, /obj/item/storage/box/guncase/m44, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("M4A3 Service Pistol Case", 0, /obj/item/storage/box/guncase/m4a3, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),

		list("BACKPACK (CHOOSE 1)", 0, null, null, null),
		list("Military Police Satchel", 0, /obj/item/storage/backpack/satchel/sec, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 General Revolver Holster Rig", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Rebreather", 0, /obj/item/clothing/mask/rebreather, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Webbing", 0, /obj/item/clothing/accessory/storage/webbing/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))


//------------ CHIEF ENGINEER ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_chief_engineer, list(

		list("SHIPSIDE GEAR", 0, null, null, null),

		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Standard Equipment", 0, list(/obj/item/clothing/gloves/yellow, /obj/item/device/radio/headset/almayer/ce,  /obj/item/clothing/shoes/marine, /obj/item/clothing/glasses/welding, /obj/item/device/working_joe_pda/uscm, /obj/item/weapon/gun/smg/nailgun/compact/tactical), MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),

		list("UNIFORM (CHOOSE 1)", 0, null, null, null),
		list("Chief Engineer Uniform", 0, /obj/item/clothing/under/marine/officer/ce, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Service Uniform", 0, /obj/item/clothing/under/marine/officer/bridge, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Beret, Engineering", 0, /obj/item/clothing/head/beret/eng, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Hardhat", 0, /obj/item/clothing/head/hardhat/white, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Patrol Cap", 0, /obj/item/clothing/head/cmcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Welding Helmet", 0, /obj/item/clothing/head/welding, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("SUIT (CHOOSE 1)", 0, null, null, null),
		list("Black Hazard Vest", 0, /obj/item/clothing/suit/storage/hazardvest/black, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Blue Hazard Vest", 0, /obj/item/clothing/suit/storage/hazardvest/blue, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Orange Hazard Vest", 0, /obj/item/clothing/suit/storage/hazardvest, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Yellow Hazard Vest", 0, /obj/item/clothing/suit/storage/hazardvest/yellow, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("USCM Service Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/service, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("BACKPACK (CHOOSE 1)", 0, null, null, null),
		list("Leather Satchel", 0, /obj/item/storage/backpack/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Technician Chestrig", 0, /obj/item/storage/backpack/marine/satchel/tech, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Technician Welder-Satchel", 0, /obj/item/storage/backpack/marine/engineerpack/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Technician Welderpack", 0, /obj/item/storage/backpack/marine/engineerpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Welding Kit", 0, /obj/item/tool/weldpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M277 Pattern Construction Rig", 0, /obj/item/storage/belt/utility/construction, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Toolbelt", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Construction Pouch", 0, /obj/item/storage/pouch/construction, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Electronics Pouch (Full)", 0, /obj/item/storage/pouch/electronics/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sidearm Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Fuel Tank Strap Pouch", 0, /obj/item/storage/pouch/flamertank, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Engineer kit Pouch", 0, /obj/item/storage/pouch/engikit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("PERSONAL SIDEARM (CHOOSE 1)", 0, null, null, null),
		list("M4A3 Service Pistol", 0, /obj/item/storage/belt/gun/m4a3/full, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("Mod 88 Pistol", 0, /obj/item/storage/belt/gun/m4a3/mod88, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("M44 Revolver", 0, /obj/item/storage/belt/gun/m44/mp, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Small Tool Webbing (Full)", 0, /obj/item/clothing/accessory/storage/tool_webbing/small/equipped, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("DEPLOYMENT GEAR", 0, null, null, null),

		list("COMBAT EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Officer M3 Armor", 0, /obj/item/clothing/suit/storage/marine/MP/SO, MARINE_CAN_BUY_COMBAT_ARMOR, VENDOR_ITEM_REGULAR),
		list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_COMBAT_SHOES, VENDOR_ITEM_REGULAR),
		list("Laser Designator", 0, /obj/item/device/binoculars/range/designator, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),

		list("COMBAT HELMET (CHOOSE 1)", 0, null, null, null),
		list("Officer M10 Helmet", 0, /obj/item/clothing/head/helmet/marine/MP/SO, MARINE_CAN_BUY_COMBAT_HELMET, VENDOR_ITEM_REGULAR),
		list("M10 Technician Helmet", 0, /obj/item/clothing/head/helmet/marine/tech, MARINE_CAN_BUY_COMBAT_HELMET, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("PRIMARY FIREARMS (CHOOSE 1)", 0, null, null, null),
		list("M37A2 Pump Shotgun", 0, /obj/item/storage/box/guncase/pumpshotgun, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),
		list("M41A Pulse Rifle MK2", 0, /obj/item/storage/box/guncase/m41a, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),
		list("M240 Incinerator Unit", 0, /obj/item/storage/box/guncase/flamer, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),

		list("Spare Equipment", 0, null, null, null),
		list("Technician's Headset", 15, /obj/item/device/radio/headset/almayer/mt, null, VENDOR_ITEM_REGULAR),
		list("Synthetic Reset Key", 15, /obj/item/device/defibrillator/synthetic, null, VENDOR_ITEM_REGULAR),

	))


//------------ CHIEF REQ ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_req_officer, list(

		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Insulated Gloves", 0, /obj/item/clothing/gloves/yellow, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Quartermaster Uniform", 0, /obj/item/clothing/under/rank/qm_suit, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/qm, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Satchel", 0, /obj/item/storage/backpack/marine/satchel/tech, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Quartermaster Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/RO, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("Headgear (CHOOSE 1)", 0, null, null, null),
		list("Quartermaster Cap", 0, /obj/item/clothing/head/cmcap/req/ro, MARINE_CAN_BUY_MASK, VENDOR_ITEM_RECOMMENDED),
		list("Quartermaster Beret", 0, /obj/item/clothing/head/beret/marine/ro, MARINE_CAN_BUY_MASK, VENDOR_ITEM_RECOMMENDED),
		list("Requisitions Cap", 0, /obj/item/clothing/head/cmcap/req, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("PERSONAL SIDEARM (CHOOSE 1)", 0, null, null, null),
		list("M4A3 Service Pistol", 0, /obj/item/storage/belt/gun/m4a3/full, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("Mod 88 Pistol", 0, /obj/item/storage/belt/gun/m4a3/mod88, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("M44 Custom Revolver", 0, /obj/item/storage/belt/gun/m44/custom, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),

		list("COMBAT EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Officer M3 Armor", 0, /obj/item/clothing/suit/storage/marine/MP/SO, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Officer M10 Helmet", 0, /obj/item/clothing/head/helmet/marine/MP/SO, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Empty)", 0, /obj/item/storage/pouch/tools, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Construction Pouch", 0, /obj/item/storage/pouch/construction, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("Spare Equipment", 0, null, null, null),
		list("Rubber Stamp", 10, /obj/item/tool/stamp/ro, null, VENDOR_ITEM_REGULAR),
	))


//------------ CHIEF MEDICAL OFFICER ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_cmo, list(

		list("MEDICAL SET (MANDATORY)", 0, null, null, null),
		list("Essential Medical Set", 0, /obj/effect/essentials_set/medical/doctor/cmo, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("STANDARD EQUIPMENT", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/latex, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/cmo, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),

		list("EYEWEAR (CHOOSE 1)", 0, null, null, null),
		list("Combined Medical and Reagent Scanner HUD Glasses", 0, /obj/item/clothing/glasses/hud/health/science, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Prescription Combined Medical and Reagent Scanner HUD Glasses", 0, /obj/item/clothing/glasses/hud/health/science/prescription, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),

		list("UNIFORM (CHOOSE 1)", 0, null, null, null),
		list("Chief Medical Officer's Uniform", 0, /obj/item/clothing/under/rank/chief_medical_officer, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Doctor Uniform", 0, /obj/item/clothing/under/rank/medical, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Green Scrubs", 0, /obj/item/clothing/under/rank/medical/green, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Blue Scrubs", 0, /obj/item/clothing/under/rank/medical/blue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Light Blue Scrubs", 0, /obj/item/clothing/under/rank/medical/lightblue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Purple Scrubs", 0, /obj/item/clothing/under/rank/medical/purple, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Olive Scrubs", 0, /obj/item/clothing/under/rank/medical/olive, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Grey Scrubs", 0, /obj/item/clothing/under/rank/medical/grey, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("SUIT (CHOOSE 1)", 0, null, null, null),
		list("Chief Medical Officer's Labcoat", 0, /obj/item/clothing/suit/storage/labcoat/officer, MARINE_CAN_BUY_MRE, VENDOR_ITEM_RECOMMENDED),
		list("Labcoat", 0, /obj/item/clothing/suit/storage/labcoat, MARINE_CAN_BUY_MRE, VENDOR_ITEM_RECOMMENDED),
		list("Medical's apron", 0, /obj/item/clothing/suit/chef/classic/medical, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),

		list("SNOW GEAR (SNOW USE ONLY)", 0, null, null, null),
		list("Snowcoat", 0, /obj/item/clothing/suit/storage/snow_suit/doctor, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Balaclava", 0, /obj/item/clothing/mask/balaclava, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Snow Scarf", 0, /obj/item/clothing/mask/tornscarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),

		list("HEADWEAR (CHOOSE 1)", 0, null, null, null),
		list("Chief Medical Officer's Peaked Cap", 0, /obj/item/clothing/head/cmo, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("Surgical Cap, Orange", 0, /obj/item/clothing/head/surgery/orange, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Surgical Cap, Blue", 0, /obj/item/clothing/head/surgery/blue, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Surgical Cap, Purple", 0, /obj/item/clothing/head/surgery/purple, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Surgical Cap, Green", 0, /obj/item/clothing/head/surgery/green, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BAG (CHOOSE 1)", 0, null, null, null),

		list("Standard Satchel", 0, /obj/item/storage/backpack/marine/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Standard Backpack", 0, /obj/item/storage/backpack/marine, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Medical Satchel", 0, /obj/item/storage/backpack/marine/satchel/medic, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),
		list("Medical Backpack", 0, /obj/item/storage/backpack/marine/medic, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 Lifesaver Bag (Full)", 0, /obj/item/storage/belt/medical/lifesaver/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Medical Storage Rig (Full)", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("PERSONAL SIDEARM (CHOOSE 1)", 0, null, null, null),
		list("M4A3 Service Pistol", 0, /obj/item/storage/belt/gun/m4a3/full, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_REGULAR),
		list("Mod 88 Pistol", 0, /obj/item/storage/belt/gun/m4a3/mod88, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_REGULAR),
		list("M44 Revolver", 0, /obj/item/storage/belt/gun/m44/mp, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),

		list("COMBAT EQUIPMENT (COMBAT USE ONLY)", 0, null, null, null),
		list("Officer M3 Armor", 0, /obj/item/clothing/suit/storage/marine/MP/SO, MARINE_CAN_BUY_COMBAT_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Officer M10 Helmet", 0, /obj/item/clothing/head/helmet/marine/MP/SO, MARINE_CAN_BUY_COMBAT_HELMET, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_COMBAT_SHOES, VENDOR_ITEM_MANDATORY),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Bicaridine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Kelotane)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_tricord, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Peridaxon)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_peri, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (EMPTY)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("Spare Equipment", 0, null, null, null),
		list("Doctor's Headset", 15, /obj/item/device/radio/headset/almayer/doc, null, VENDOR_ITEM_REGULAR),
		list("Researcher's Headset", 15, /obj/item/device/radio/headset/almayer/research, null, VENDOR_ITEM_REGULAR),
	))


/obj/effect/essentials_set/medical/doctor/cmo
	spawned_gear_list = list(
		/obj/item/device/defibrillator,
		/obj/item/storage/firstaid/adv,
		/obj/item/device/healthanalyzer,
		/obj/item/tool/surgery/surgical_line,
		/obj/item/tool/surgery/synthgraft,
		/obj/item/device/flashlight/pen,
		/obj/item/clothing/accessory/stethoscope,
		/obj/item/storage/syringe_case,
	)



//------------ EXECUTIVE OFFFICER ---------------

//------------WEAPON VENDOR---------------
GLOBAL_LIST_INIT(cm_vending_gear_xo, list(
		list("CAPTAIN'S PRIMARY (CHOOSE 1)", 0, null, null, null),
		list("M41A MK1 Pulse Rifle", 0, /obj/item/storage/box/guncase/m41aMK1AP, MARINE_CAN_BUY_KIT, VENDOR_ITEM_MANDATORY),
		list("MK221 Tactical Shotgun", 0, /obj/effect/essentials_set/xo/shotgunpreset, MARINE_CAN_BUY_KIT, VENDOR_ITEM_MANDATORY),

		list("PRIMARY AMMUNITION", 0, null, null, null),
		list("M41A MK1 Magazine", 40, /obj/item/ammo_magazine/rifle/m41aMK1, null, VENDOR_ITEM_RECOMMENDED),
		list("M41A MK1 AP Magazine", 60, /obj/item/ammo_magazine/rifle/m41aMK1/ap, null, VENDOR_ITEM_RECOMMENDED),
		list("Buckshot Shells", 20, /obj/item/ammo_magazine/shotgun/buckshot, null, VENDOR_ITEM_REGULAR),
		list("Shotgun Slugs", 20, /obj/item/ammo_magazine/shotgun/slugs, null, VENDOR_ITEM_REGULAR),
		list("Flechette Shells", 20, /obj/item/ammo_magazine/shotgun/flechette, null, VENDOR_ITEM_REGULAR),

		list("SPECIALISATION KIT (CHOOSE 1)", 0, null, null, null),
		list("Essential Engineer Set", 0, /obj/effect/essentials_set/engi, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_RECOMMENDED),
		list("Essential Medical Set", 0, /obj/effect/essentials_set/medic, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_RECOMMENDED),

		list("EXPLOSIVES", 0, null, null, null),
		list("HEDP Grenade Pack", 15, /obj/item/storage/box/packet/high_explosive, null, VENDOR_ITEM_REGULAR),
		list("HEFA Grenade Pack", 15, /obj/item/storage/box/packet/hefa, null, VENDOR_ITEM_REGULAR),
		list("WP Grenade Pack", 15, /obj/item/storage/box/packet/phosphorus, null, VENDOR_ITEM_REGULAR),

		list("RAIL ATTACHMENTS", 0, null, null, null),
		list("Magnetic Harness", 12, /obj/item/attachable/magnetic_harness, null, VENDOR_ITEM_RECOMMENDED),
		list("Red-Dot Sight", 15, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 15, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("S4 2x Telescopic Mini-Scope", 15, /obj/item/attachable/scope/mini, null, VENDOR_ITEM_REGULAR),

		list("UNDERBARREL ATTACHMENTS", 0, null, null, null),
		list("Laser Sight", 15, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Angled Grip", 15, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 15, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),
		list("Underbarrel Shotgun", 15, /obj/item/attachable/attached_gun/shotgun, null, VENDOR_ITEM_REGULAR),
		list("Underbarrel Extinguisher", 15, /obj/item/attachable/attached_gun/extinguisher, null, VENDOR_ITEM_REGULAR),
		list("Underbarrel Flamethrower", 15, /obj/item/attachable/attached_gun/flamer, null, VENDOR_ITEM_REGULAR),
		list("Underbarrel Grenade Launcher", 5, /obj/item/attachable/attached_gun/grenade, null, VENDOR_ITEM_REGULAR),

		list("BARREL ATTACHMENTS", 0, null, null, null),
		list("Extended Barrel", 15, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Recoil Compensator", 15, /obj/item/attachable/compensator, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 15, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),

		list("OTHER SUPPLIES", 0, null, null, null),
		list("Welding Visor", 5, /obj/item/device/helmet_visor/welding_visor, null, VENDOR_ITEM_REGULAR),
		list("Insulated Gloves", 3, /obj/item/clothing/gloves/yellow, null, VENDOR_ITEM_REGULAR),
		list("Entrenching Tool", 1, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Magnetic Harness", 12, /obj/item/attachable/magnetic_harness, null, VENDOR_ITEM_RECOMMENDED),
		list("Radio Telephone Pack", 15, /obj/item/storage/backpack/marine/satchel/rto, null, VENDOR_ITEM_RECOMMENDED),
		list("Motion Detector", 5, /obj/item/device/motiondetector, null, VENDOR_ITEM_RECOMMENDED),
		list("Machete Scabbard (Full)", 5, /obj/item/storage/large_holster/machete/full, null, VENDOR_ITEM_REGULAR),
		list("Binoculars", 5,/obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Rangefinder", 8, /obj/item/device/binoculars/range, null,  VENDOR_ITEM_REGULAR),
		list("Laser Designator", 12, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_RECOMMENDED),
		list("Fulton Recovery Device", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Space Cleaner", 2, /obj/item/reagent_container/spray/cleaner, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
		list("Flashlight", 1, /obj/item/device/flashlight, null, VENDOR_ITEM_REGULAR),
		list("Synthetic Reset Key", 10, /obj/item/device/defibrillator/synthetic, null, VENDOR_ITEM_REGULAR),
	))

/obj/effect/essentials_set/xo/shotgunpreset
	spawned_gear_list = list(
		/obj/item/weapon/gun/shotgun/combat,
		/obj/item/ammo_magazine/shotgun/buckshot,
		/obj/item/ammo_magazine/shotgun/slugs,
	)

/obj/structure/machinery/cm_vending/gear/executive_officer
	name = "\improper ColMarTech Executive Officer Weapon Rack"
	desc = "An automated weapons rack for the Executive Officer. It features a decent selection of weaponry meant only for the second in command of a ship."
	req_access = list(ACCESS_MARINE_SENIOR)
	vendor_role = list(JOB_XO)
	icon_state = "guns"
	use_snowflake_points = TRUE

/obj/structure/machinery/cm_vending/gear/executive_officer/get_listed_products(mob/user)
	return GLOB.cm_vending_gear_xo

//------------UNIFORM/GEAR VENDOR---------------
GLOBAL_LIST_INIT(cm_vending_clothing_xo, list(
		list("COMBAT EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Officer M3 Armor", 0, /obj/item/clothing/suit/storage/marine/MP/SO, MARINE_CAN_BUY_COMBAT_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Officer M10 Helmet", 0, /obj/item/clothing/head/helmet/marine/MP/SO, MARINE_CAN_BUY_COMBAT_HELMET, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_COMBAT_SHOES, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Gloves", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),

		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/mcom/cdrcom, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Satchel", 0, /obj/item/storage/backpack/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("MRE", 0, /obj/item/storage/box/mre, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("UNIFORM (CHOOSE ONE)", 0, null, null, null),
		list("Service Uniform", 0, /obj/item/clothing/under/marine/officer/bridge, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Operations Uniform", 0, /obj/item/clothing/under/marine/officer/boiler, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Formal Uniform", 0, /obj/effect/essentials_set/xoformal, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),

		list("PERSONAL WEAPON (CHOOSE 1)", 0, null, null, null),
		list("VP78 Pistol", 0, /obj/item/storage/belt/gun/m4a3/vp78, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("M4A3 Service Pistol", 0, /obj/item/storage/belt/gun/m4a3/commander, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_REGULAR),
		list("Mod 88 Pistol", 0, /obj/item/storage/belt/gun/m4a3/mod88, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_REGULAR),
		list("M44 Revolver", 0, /obj/item/storage/belt/gun/m44/mp, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_REGULAR),

		list("EYEWEAR (CHOOSE 1)", 0, null, null, null),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),
		list("Security HUD Glasses", 0, /obj/item/clothing/glasses/sunglasses/sechud, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
		list("Bimex Personal Shades", 0, /obj/item/clothing/glasses/sunglasses/big, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),
		list("Aviator Shades", 0, /obj/item/clothing/glasses/sunglasses/aviator, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),

		list("HATS (CHOOSE 1)", 0, null, null, null),
		list("Officer Beret", 0, /obj/item/clothing/head/beret/marine/chiefofficer, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Service Peaked Cap", 0, /obj/item/clothing/head/marine/peaked/service, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Patrol Cap", 0, /obj/item/clothing/head/cmcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Officer Cap", 0, /obj/item/clothing/head/cmcap/bridge, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("PATCHES", 0, null, null, null),
		list("Falling Falcons Shoulder Patch", 1, /obj/item/clothing/accessory/patch/falcon, null, VENDOR_ITEM_REGULAR),
		list("Falling Falcons UA Shoulder Patch", 1, /obj/item/clothing/accessory/patch/falconalt, null, VENDOR_ITEM_REGULAR),
		list("USCM Large Chest Patch", 1, /obj/item/clothing/accessory/patch/uscmlarge, null, VENDOR_ITEM_REGULAR),
		list("USCM Shoulder Patch", 1, /obj/item/clothing/accessory/patch, null, VENDOR_ITEM_REGULAR),
		list("United Americas Shoulder patch", 1, /obj/item/clothing/accessory/patch/ua, null, VENDOR_ITEM_REGULAR),
		list("United Americas Flag Shoulder patch", 1, /obj/item/clothing/accessory/patch/uasquare, null, VENDOR_ITEM_REGULAR),


		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Holster Toolrig (Full)", 0, /obj/item/storage/belt/gun/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Lifesaver Bag (Full)", 0, /obj/item/storage/belt/medical/lifesaver/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Medical Storage Rig (Full)", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M39 Holster Rig", 0, /obj/item/storage/belt/gun/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M40 Grenade Rig", 0, /obj/item/storage/belt/grenade, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("Military Police Belt", 0, /obj/item/storage/belt/security/MP/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Large Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Construction Pouch", 0, /obj/item/storage/pouch/construction, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Electronics Pouch (Full)", 0, /obj/item/storage/pouch/electronics/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Fuel Tank Strap Pouch", 0, /obj/item/storage/pouch/flamertank, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))



//------------ AUXILIARY SUPPORT OFFICER ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_auxiliary_officer, list(

		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Insulated Gloves", 0, /obj/item/clothing/gloves/yellow, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Officer Uniform", 0, /obj/item/clothing/under/marine/officer/bridge, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/mcom/cdrcom, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Auxiliary Support Officer Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/service/aso, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("BAG (CHOOSE 1)", 0, null, null, null),
		list("USCM Technician Chestrig", 0, /obj/item/storage/backpack/marine/satchel/tech, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Leather Satchel", 0, /obj/item/storage/backpack/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("PERSONAL SIDEARM (CHOOSE 1)", 0, null, null, null),
		list("M4A3 Service Pistol", 0, /obj/item/storage/belt/gun/m4a3/full, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("Mod 88 Pistol", 0, /obj/item/storage/belt/gun/m4a3/mod88, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("M44 Custom Revolver", 0, /obj/item/storage/belt/gun/m44/custom, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),

		list("HAT (CHOOSE 1)", 0, null, null, null),
		list("Beret, Green", 0, /obj/item/clothing/head/beret/cm, MARINE_CAN_BUY_MASK, VENDOR_ITEM_RECOMMENDED),
		list("Beret, Tan", 0, /obj/item/clothing/head/beret/cm/tan, MARINE_CAN_BUY_MASK, VENDOR_ITEM_RECOMMENDED),
		list("Patrol Cap", 0, /obj/item/clothing/head/cmcap, MARINE_CAN_BUY_MASK, VENDOR_ITEM_RECOMMENDED),
		list("Officer Cap", 0, /obj/item/clothing/head/cmcap/bridge, MARINE_CAN_BUY_MASK, VENDOR_ITEM_RECOMMENDED),
		list("Service Peaked Cap", 0, /obj/item/clothing/head/marine/peaked/service, MARINE_CAN_BUY_MASK, VENDOR_ITEM_RECOMMENDED),

		list("COMBAT EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Officer M3 Armor", 0, /obj/item/clothing/suit/storage/marine/MP/SO, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Officer M10 Helmet", 0, /obj/item/clothing/head/helmet/marine/MP/SO, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Document Pouch", 0, /obj/item/storage/pouch/document, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Empty)", 0, /obj/item/storage/pouch/tools, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Construction Pouch", 0, /obj/item/storage/pouch/construction, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))

/obj/effect/essentials_set/chiefmilitarypolice
	spawned_gear_list = list(
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/storage/belt/security/MP/full,
		/obj/item/clothing/head/helmet/marine/MP/WO,
	)

/obj/effect/essentials_set/xoformal
	spawned_gear_list = list(
		/obj/item/clothing/suit/storage/jacket/marine/dress,
		/obj/item/clothing/head/marine/peaked,
		/obj/item/clothing/under/marine/dress,
	)
