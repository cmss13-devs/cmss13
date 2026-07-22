/obj/structure/machinery/cm_vending/clothing/medical_crew
	name = "\improper ColMarTech Medical Equipment Rack"
	desc = "An automated equipment vendor for the Medical Department."
	req_access = list(ACCESS_MARINE_MEDBAY)
	vendor_role = list(JOB_DOCTOR,JOB_FIELD_DOCTOR,JOB_NURSE,JOB_CMO)
	icon_state = "dress"

/obj/structure/machinery/cm_vending/clothing/medical_crew/get_listed_products(mob/user)
	if(!user)
		var/list/combined = list()
		combined += GLOB.cm_vending_clothing_nurse
		combined += GLOB.cm_vending_clothing_cmo
		combined += GLOB.cm_vending_clothing_doctor
		combined += GLOB.cm_vending_clothing_field_doctor
		return combined
	if(user.job == JOB_NURSE)
		return GLOB.cm_vending_clothing_nurse
	else if(user.job == JOB_CMO)
		///defined in senior_officers.dm
		return GLOB.cm_vending_clothing_cmo
	else if(user.job == JOB_DOCTOR)
		return GLOB.cm_vending_clothing_doctor
	else if(user.job == JOB_FIELD_DOCTOR)
		return GLOB.cm_vending_clothing_field_doctor
	return ..()

/obj/structure/machinery/cm_vending/clothing/medical_crew/researcher
	name = "\improper Researcher's Wardrobe"
	desc = "A wardrobe fit for all the clothes and equipment a researcher needs."
	req_access = list(ACCESS_MARINE_MEDBAY)
	vendor_role = list(JOB_RESEARCHER)
	icon_state = "wardrobe_vendor"

/obj/structure/machinery/cm_vending/clothing/medical_crew/researcher/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_researcher



//------------ DOCTOR ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_doctor, list(

		list("MEDICAL SET (MANDATORY)", 0, null, null, null),
		list("Essential Medical Set", 0, /obj/effect/essentials_set/medical/doctor, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("STANDARD EQUIPMENT", 0, null, null, null),
		list("Latex Gloves", 0, /obj/item/clothing/gloves/latex, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),

		list("EYEWEAR (CHOOSE 1)", 0, null, null, null),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Prescription Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health/prescription, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),

		list("HEADWEAR (CHOOSE 1)", 0, null, null, null),
		list("Blue Surgical Cap", 0, /obj/item/clothing/head/surgery/blue, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Green Surgical Cap", 0, /obj/item/clothing/head/surgery/green, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Light Blue Surgical Cap", 0, /obj/item/clothing/head/surgery/lightblue, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Purple Surgical Cap", 0, /obj/item/clothing/head/surgery/purple, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Olive Surgical Cap", 0, /obj/item/clothing/head/surgery/olive, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Grey Surgical Cap", 0, /obj/item/clothing/head/surgery/grey, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Brown Surgical Cap", 0, /obj/item/clothing/head/surgery/brown, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("White Surgical Cap", 0, /obj/item/clothing/head/surgery/white, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Black Surgical Cap", 0, /obj/item/clothing/head/surgery/morgue, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("UNIFORM (CHOOSE 1)", 0, null, null, null),
		list("Blue Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/blue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Green Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/green, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Light Blue Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/lightblue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Purple Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/purple, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Olive Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/olive, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Grey Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/grey, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Brown Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/brown, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("White Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/white, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Black Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/morgue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("SUIT (CHOOSE 1)", 0, null, null, null),
		list("Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("Lab Coat, Short", 0, /obj/item/clothing/suit/storage/labcoat/short, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("Lab Coat, Long", 0, /obj/item/clothing/suit/storage/labcoat/long, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("Medical Apron", 0, /obj/item/clothing/suit/chef/classic/medical, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),

		list("SNOW GEAR (SNOW USE ONLY)", 0, null, null, null),
		list("Snow Coat", 0, /obj/item/clothing/suit/storage/snow_suit/doctor, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Balaclava", 0, /obj/item/clothing/mask/balaclava, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Snow Scarf", 0, /obj/item/clothing/mask/tornscarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),

		list("BAG (CHOOSE 1)", 0, null, null, null),
		list("Medical Satchel", 0, /obj/item/storage/backpack/marine/satchel/medic, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),
		list("Medical Backpack", 0, /obj/item/storage/backpack/marine/medic, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),
		list("Standard Satchel", 0, /obj/item/storage/backpack/marine/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Standard Backpack", 0, /obj/item/storage/backpack/marine, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 Lifesaver Bag (Full)", 0, /obj/item/storage/belt/medical/lifesaver/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Medical Storage Rig (Full)", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Chemistry Pouch", 0, /obj/item/storage/pouch/chem, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (EMPTY)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Damage Mending Mix)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/damage_mend, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Field Anesthetic)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/oxycodone, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Oxycodone)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_oxy, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Peridaxon)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_peri, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_tricord, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Surgery Prep)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/surgery_prep, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Leg Pouch", 0, /obj/item/clothing/accessory/storage/black_vest/leg_pouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Leg Pouch (Black)", 0, /obj/item/clothing/accessory/storage/black_vest/black_leg_pouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Webbing", 0, /obj/item/clothing/accessory/storage/webbing/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))

//------------ NURSE ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_nurse, list(

		list("MEDICAL SET (MANDATORY)", 0, null, null, null),
		list("Essential Medical Set", 0, /obj/effect/essentials_set/medical, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("STANDARD EQUIPMENT", 0, null, null, null),
		list("Latex Gloves", 0, /obj/item/clothing/gloves/latex, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),

		list("EYEWEAR (CHOOSE 1)", 0, null, null, null),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Prescription Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health/prescription, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),

		list("HEADWEAR (CHOOSE 1)", 0, null, null, null),
		list("Blue Surgical Cap", 0, /obj/item/clothing/head/surgery/blue, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Green Surgical Cap", 0, /obj/item/clothing/head/surgery/green, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Light Blue Surgical Cap", 0, /obj/item/clothing/head/surgery/lightblue, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Purple Surgical Cap", 0, /obj/item/clothing/head/surgery/purple, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Olive Surgical Cap", 0, /obj/item/clothing/head/surgery/olive, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Grey Surgical Cap", 0, /obj/item/clothing/head/surgery/grey, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Brown Surgical Cap", 0, /obj/item/clothing/head/surgery/brown, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("White Surgical Cap", 0, /obj/item/clothing/head/surgery/white, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Black Surgical Cap", 0, /obj/item/clothing/head/surgery/morgue, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("UNIFORM (CHOOSE 1)", 0, null, null, null),
		list("Blue Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/blue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Green Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/green, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Light Blue Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/lightblue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Purple Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/purple, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Olive Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/olive, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Grey Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/grey, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Brown Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/brown, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("White Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/white, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Black Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/morgue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("SUIT (CHOOSE 1)", 0, null, null, null),
		list("Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("Lab Coat, Short", 0, /obj/item/clothing/suit/storage/labcoat/short, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("Lab Coat, Long", 0, /obj/item/clothing/suit/storage/labcoat/long, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("Medical Apron", 0, /obj/item/clothing/suit/chef/classic/medical, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),

		list("SNOW GEAR (SNOW USE ONLY)", 0, null, null, null),
		list("Snow Coat", 0, /obj/item/clothing/suit/storage/snow_suit/doctor, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Balaclava", 0, /obj/item/clothing/mask/balaclava, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Snow Scarf", 0, /obj/item/clothing/mask/tornscarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),

		list("BAG (CHOOSE 1)", 0, null, null, null),
		list("Medical Satchel", 0, /obj/item/storage/backpack/marine/satchel/medic, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),
		list("Medical Backpack", 0, /obj/item/storage/backpack/marine/medic, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),
		list("Standard Satchel", 0, /obj/item/storage/backpack/marine/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Standard Backpack", 0, /obj/item/storage/backpack/marine, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 Lifesaver Bag (Full)", 0, /obj/item/storage/belt/medical/lifesaver/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Medical Storage Rig (Full)", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Chemistry Pouch", 0, /obj/item/storage/pouch/chem, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (EMPTY)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Damage Mending Mix)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/damage_mend, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Field Anesthetic)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/oxycodone, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Oxycodone)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_oxy, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Peridaxon)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_peri, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_tricord, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Surgery Prep)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/surgery_prep, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Leg Pouch", 0, /obj/item/clothing/accessory/storage/black_vest/leg_pouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Leg Pouch (Black)", 0, /obj/item/clothing/accessory/storage/black_vest/black_leg_pouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Webbing", 0, /obj/item/clothing/accessory/storage/webbing/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))

//------------ RESEARCHER ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_researcher, list(

		list("RESEARCH SET (MANDATORY)", 0, null, null, null),
		list("Essential Research Set", 0, /obj/effect/essentials_set/medical/researcher, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("IMPORTANT EQUIPMENT", 0, null, null, null),
		list("Latex Gloves", 0, /obj/item/clothing/gloves/latex, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Research Headset", 0, /obj/item/device/radio/headset/almayer/research, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),

		list("SHOULDER PATCHES (CHOOSE 1)", 0, null, null, null),
		list("Weyland-Yutani Round Patch, Black", 0, /obj/item/clothing/accessory/patch/wy, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Weyland-Yutani Square Patch, Black", 0, /obj/item/clothing/accessory/patch/wysquare, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Weyland-Yutani Round Patch, White", 0, /obj/item/clothing/accessory/patch/wy_white, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("EYEWEAR (CHOOSE 1)", 0, null, null, null),
		list("Reagent Scanner HUD Goggles", 0, /obj/item/clothing/glasses/science, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Prescription Reagent Scanner HUD Goggles", 0, /obj/item/clothing/glasses/science/prescription, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),
		list("Prescription Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health/prescription, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),

		list("UNDERSUIT (CHOOSE 1)", 0, null, null, null),
		list("Black Suit Pants", 0, /obj/item/clothing/under/liaison_suit/black, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Black Suitskirt", 0, /obj/item/clothing/under/liaison_suit/black/skirt, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Blue Suit Pants", 0, /obj/item/clothing/under/liaison_suit/blue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Brown Suit Pants", 0, /obj/item/clothing/under/liaison_suit/brown, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("White Suit Pants", 0, /obj/item/clothing/under/liaison_suit/corporate_formal, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Grey Suit Pants", 0, /obj/item/clothing/under/detective/grey, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Worn Suit", 0, /obj/item/clothing/under/detective/neutral, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Simple White Shirt, Black Pants", 0, /obj/item/clothing/under/sl_suit, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Simple White Shirt, Blue Pants", 0, /obj/item/clothing/under/lawyer/bluesuit, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Khaki Workwear", 0, /obj/item/clothing/under/colonist/workwear/khaki, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Pink Workwear", 0, /obj/item/clothing/under/colonist/workwear/pink, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Green Workwear", 0, /obj/item/clothing/under/colonist/workwear/green, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Blue Workwear", 0, /obj/item/clothing/under/colonist/workwear/blue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("White Uniform", 0, /obj/item/clothing/under/marine/reporter, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Black Uniform", 0, /obj/item/clothing/under/marine/reporter/black, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Orange Uniform", 0, /obj/item/clothing/under/marine/reporter/orange, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Red Uniform", 0, /obj/item/clothing/under/marine/reporter/red, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("White T-Shirt and Brown Jeans", 12, /obj/item/clothing/under/tshirt/w_br, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Gray T-Shirt and Blue Jeans", 12, /obj/item/clothing/under/tshirt/gray_blu, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Red T-Shirt and Black Jeans", 12, /obj/item/clothing/under/tshirt/r_bla, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("SUIT (CHOOSE 1)", 0, null, null, null),
		list("Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("Lab Coat, Short", 0, /obj/item/clothing/suit/storage/labcoat/short, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("Lab Coat, Long", 0, /obj/item/clothing/suit/storage/labcoat/long, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("Brown Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/researcher, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("Brown Lab Coat, Short", 0, /obj/item/clothing/suit/storage/labcoat/researcher/short, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),

		list("SHOES (CHOOSE 1)", 0, null, null, null),
		list("Laceup Shoes, Black", 0, /obj/item/clothing/shoes/laceup, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Laceup Shoes, Brown", 0, /obj/item/clothing/shoes/laceup/brown, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Fancy Leather Shoes", 0, /obj/item/clothing/shoes/leather/fancy, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Shoes, Black", 12, /obj/item/clothing/shoes/black, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Shoes, Blue", 12, /obj/item/clothing/shoes/blue, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Shoes, Brown", 12, /obj/item/clothing/shoes/brown, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Shoes, Green", 12, /obj/item/clothing/shoes/green, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Shoes, Purple", 12, /obj/item/clothing/shoes/purple, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Shoes, Red", 12, /obj/item/clothing/shoes/red, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Shoes, White", 12, /obj/item/clothing/shoes/white, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Shoes, Yellow", 12, /obj/item/clothing/shoes/yellow, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Shoes, Rainbow", 12, /obj/item/clothing/shoes/rainbow, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),\

		list("BAG (CHOOSE 1)", 0, null, null, null),
		list("Medical Satchel", 0, /obj/item/storage/backpack/marine/satchel/medic, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),
		list("Medical Backpack", 0, /obj/item/storage/backpack/marine/medic, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),
		list("Leather Blue Satchel", 0, /obj/item/storage/backpack/satchel/blue, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Leather Black Satchel", 0, /obj/item/storage/backpack/satchel/black, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Standard Satchel", 0, /obj/item/storage/backpack/marine/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Standard Backpack", 0, /obj/item/storage/backpack/marine, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 Lifesaver Bag (Full)", 0, /obj/item/storage/belt/medical/lifesaver/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Medical Storage Rig (Full)", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Vials Pouch", 0, /obj/item/storage/pouch/vials, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_MANDATORY),
		list("Chemistry Pouch", 0, /obj/item/storage/pouch/chem, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_MANDATORY),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (EMPTY)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Damage Mending Mix)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/damage_mend, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Leg Pouch", 0, /obj/item/clothing/accessory/storage/black_vest/leg_pouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Leg Pouch (Black)", 0, /obj/item/clothing/accessory/storage/black_vest/black_leg_pouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Webbing", 0, /obj/item/clothing/accessory/storage/webbing/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Tie", 0, /obj/item/clothing/accessory/tie/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Red Tie", 0, /obj/item/clothing/accessory/tie/red, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Purple Tie", 0, /obj/item/clothing/accessory/tie/purple, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Blue Tie", 0, /obj/item/clothing/accessory/tie, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Green Tie", 0, /obj/item/clothing/accessory/tie/green, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Gold Tie", 0, /obj/item/clothing/accessory/tie/gold, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Special Tie", 0, /obj/item/clothing/accessory/tie/horrible, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))


//------------ FIELD DOCTOR ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_field_doctor, list(

		list("MEDICAL SET (MANDATORY)", 0, null, null, null),
		list("Essential Medical & Field Set", 0, /obj/effect/essentials_set/medical/doctor/field, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("STANDARD EQUIPMENT", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/latex, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),

		list("EYEWEAR (CHOOSE 1)", 0, null, null, null),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Prescription Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health/prescription, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),

		list("HEADWEAR (CHOOSE 1)", 0, null, null, null),
		list("M10 Corpsman Helmet", 0, /obj/item/clothing/head/helmet/marine/medic, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Blue Surgical Cap", 0, /obj/item/clothing/head/surgery/blue, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Green Surgical Cap", 0, /obj/item/clothing/head/surgery/green, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("Light Blue Surgical Cap", 0, /obj/item/clothing/head/surgery/lightblue, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Purple Surgical Cap", 0, /obj/item/clothing/head/surgery/purple, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Olive Surgical Cap", 0, /obj/item/clothing/head/surgery/olive, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Grey Surgical Cap", 0, /obj/item/clothing/head/surgery/grey, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Brown Surgical Cap", 0, /obj/item/clothing/head/surgery/brown, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("White Surgical Cap", 0, /obj/item/clothing/head/surgery/white, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Black Surgical Cap", 0, /obj/item/clothing/head/surgery/morgue, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("UNIFORM (CHOOSE 1)", 0, null, null, null),
		list("USCM Field Doctor Uniform", 0, /obj/item/clothing/under/marine/field_doctor, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("USCM Field Doctor Scrubs", 0, /obj/item/clothing/under/marine/field_doctor/scrubs, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Blue Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/blue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Green Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/green, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Light Blue Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/lightblue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Purple Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/purple, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Olive Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/olive, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Grey Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/grey, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Brown Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/brown, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("White Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/white, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Black Medical Scrubs", 0, /obj/item/clothing/under/rank/medical/morgue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("SUIT (CHOOSE 1)", 0, null, null, null),
		list("M3-VL Pattern Ballistics Vest", 0,/obj/item/clothing/suit/storage/marine/light/vest, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("Lab Coat, Short", 0, /obj/item/clothing/suit/storage/labcoat/short, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("Lab Coat, Long", 0, /obj/item/clothing/suit/storage/labcoat/long, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("Medical Apron", 0, /obj/item/clothing/suit/chef/classic/medical, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),

		list("SNOW GEAR (SNOW USE ONLY)", 0, null, null, null),
		list("Snow Coat", 0, /obj/item/clothing/suit/storage/snow_suit/doctor, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Balaclava", 0, /obj/item/clothing/mask/balaclava, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Snow Scarf", 0, /obj/item/clothing/mask/tornscarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),

		list("BAG (CHOOSE 1)", 0, null, null, null),
		list("Medical Backpack", 0, /obj/item/storage/backpack/marine/medic, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Medical Satchel", 0, /obj/item/storage/backpack/marine/satchel/medic, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),
		list("Standard Satchel", 0, /obj/item/storage/backpack/marine/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Standard Backpack", 0, /obj/item/storage/backpack/marine, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 Lifesaver Bag (Full)", 0, /obj/item/storage/belt/medical/lifesaver/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Medical Storage Rig (Full)", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Chemistry Pouch", 0, /obj/item/storage/pouch/chem, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (EMPTY)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Damage Mending Mix)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/damage_mend, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Field Anesthetic)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/oxycodone, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Oxycodone)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_oxy, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Peridaxon)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_peri, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_tricord, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Surgery Prep)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/surgery_prep, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Leg Pouch", 0, /obj/item/clothing/accessory/storage/black_vest/leg_pouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Leg Pouch (Black)", 0, /obj/item/clothing/accessory/storage/black_vest/black_leg_pouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Webbing", 0, /obj/item/clothing/accessory/storage/webbing/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))

/obj/effect/essentials_set/medical
	spawned_gear_list = list(
		/obj/item/device/defibrillator,
		/obj/item/storage/firstaid/adv,
		/obj/item/device/healthanalyzer,
		/obj/item/clothing/mask/surgical,
		/obj/item/tool/surgery/surgical_line,
		/obj/item/tool/surgery/synthgraft,
		/obj/item/storage/syringe_case,
		/obj/item/storage/surgical_case/regular,
		/obj/item/clothing/accessory/stethoscope,
		/obj/item/device/flashlight/pen,
		/obj/structure/bed/portable_surgery,
		/obj/structure/bed/roller,
	)

/obj/effect/essentials_set/medical/doctor
	spawned_gear_list = list(
		/obj/item/device/defibrillator,
		/obj/item/storage/firstaid/adv,
		/obj/item/device/healthanalyzer,
		/obj/item/clothing/mask/surgical,
		/obj/item/tool/surgery/surgical_line,
		/obj/item/tool/surgery/synthgraft,
		/obj/item/clothing/accessory/stethoscope,
		/obj/item/device/flashlight/pen,
		/obj/item/storage/syringe_case,
		/obj/structure/bed/portable_surgery,
		/obj/structure/bed/roller,
	)

/obj/effect/essentials_set/medical/doctor/field
	spawned_gear_list = list(
		/obj/item/device/defibrillator,
		/obj/item/storage/firstaid/adv,
		/obj/item/device/healthanalyzer,
		/obj/item/clothing/mask/surgical,
		/obj/item/tool/surgery/surgical_line,
		/obj/item/tool/surgery/synthgraft,
		/obj/item/clothing/accessory/stethoscope,
		/obj/item/device/flashlight/pen,
		/obj/item/storage/syringe_case,
		/obj/structure/bed/portable_surgery,
		/obj/structure/bed/roller,
		/obj/item/clothing/shoes/marine,
		/obj/item/storage/box/mre,
		/obj/item/device/radio/marine,
		/obj/item/clothing/accessory/patch/medic_patch,
	)

/obj/effect/essentials_set/medical/researcher
	spawned_gear_list = list(
		/obj/item/device/healthanalyzer,
		/obj/item/storage/firstaid/adv,
		/obj/item/device/reagent_scanner,
		/obj/item/clothing/accessory/stethoscope,
		/obj/item/device/flashlight/pen,
		/obj/item/clothing/mask/surgical,
	)


