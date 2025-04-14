/obj/structure/machinery/cm_vending/clothing/medical_crew
	name = "\improper ColMarTech Medical Equipment Rack"
	desc = "An automated equipment vendor for the Medical Department."
	req_access = list(ACCESS_MARINE_MEDBAY)
	vendor_role = list(JOB_DOCTOR,JOB_FIELD_DOCTOR,JOB_NURSE,JOB_RESEARCHER,JOB_CMO)
	icon_state = "dress"

/obj/structure/machinery/cm_vending/clothing/medical_crew/get_listed_products(mob/user)
	if(!user)
		var/list/combined = list()
		combined += GLOB.cm_vending_clothing_nurse
		combined += GLOB.cm_vending_clothing_researcher
		combined += GLOB.cm_vending_clothing_cmo
		combined += GLOB.cm_vending_clothing_doctor
		return combined
	if(user.job == JOB_NURSE)
		return GLOB.cm_vending_clothing_nurse
	else if(user.job == JOB_RESEARCHER)
		return GLOB.cm_vending_clothing_researcher
	else if(user.job == JOB_CMO)
		///defined in senior_officers.dm
		return GLOB.cm_vending_clothing_cmo
	else if(user.job == JOB_DOCTOR || user.job == JOB_FIELD_DOCTOR)
		return GLOB.cm_vending_clothing_doctor
	return ..()



//------------ DOCTOR ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_doctor, list(

		list("MEDICAL SET (MANDATORY)", 0, null, null, null),
		list("Essential Medical Set", 0, /obj/effect/essentials_set/medical/doctor, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("STANDARD EQUIPMENT", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/latex, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/doc, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),

		list("EYEWEAR (CHOOSE 1)", 0, null, null, null),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Prescription Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health/prescription, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),

		list("UNIFORM (CHOOSE 1)", 0, null, null, null),
		list("Green Scrubs", 0, /obj/item/clothing/under/rank/medical/green, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Blue Scrubs", 0, /obj/item/clothing/under/rank/medical/blue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Light Blue Scrubs", 0, /obj/item/clothing/under/rank/medical/lightblue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Purple Scrubs", 0, /obj/item/clothing/under/rank/medical/purple, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Olive Scrubs", 0, /obj/item/clothing/under/rank/medical/olive, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Grey Scrubs", 0, /obj/item/clothing/under/rank/medical/grey, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("SUIT (CHOOSE 1)", 0, null, null, null),
		list("Labcoat", 0, /obj/item/clothing/suit/storage/labcoat, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("Medical's apron", 0, /obj/item/clothing/suit/chef/classic/medical, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),

		list("SNOW GEAR (SNOW USE ONLY)", 0, null, null, null),
		list("Snowcoat", 0, /obj/item/clothing/suit/storage/snow_suit/doctor, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Balaclava", 0, /obj/item/clothing/mask/balaclava, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Snow Scarf", 0, /obj/item/clothing/mask/tornscarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),

		list("HEADWEAR (CHOOSE 1)", 0, null, null, null),
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
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Webbing", 0, /obj/item/clothing/accessory/storage/webbing/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

	))

//------------ NURSE ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_nurse, list(

		list("MEDICAL SET (MANDATORY)", 0, null, null, null),
		list("Essential Medical Set", 0, /obj/effect/essentials_set/medical, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("STANDARD EQUIPMENT", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/latex, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/doc, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),

		list("EYEWEAR (CHOOSE 1)", 0, null, null, null),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Prescription Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health/prescription, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),

		list("UNIFORM (CHOOSE 1)", 0, null, null, null),
		list("Light Blue Scrubs", 0, /obj/item/clothing/under/rank/medical/lightblue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Green Scrubs", 0, /obj/item/clothing/under/rank/medical/green, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Blue Scrubs", 0, /obj/item/clothing/under/rank/medical/blue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Purple Scrubs", 0, /obj/item/clothing/under/rank/medical/purple, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Olive Scrubs", 0, /obj/item/clothing/under/rank/medical/olive, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Grey Scrubs", 0, /obj/item/clothing/under/rank/medical/grey, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("SUIT (CHOOSE 1)", 0, null, null, null),
		list("Medical's apron", 0, /obj/item/clothing/suit/chef/classic/medical, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),

		list("SNOW GEAR (SNOW USE ONLY)", 0, null, null, null),
		list("Snowcoat", 0, /obj/item/clothing/suit/storage/snow_suit/doctor, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Balaclava", 0, /obj/item/clothing/mask/balaclava, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Snow Scarf", 0, /obj/item/clothing/mask/tornscarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),

		list("HEADWEAR (CHOOSE 1)", 0, null, null, null),

		list("Surgical Cap, Orange", 0, /obj/item/clothing/head/surgery/orange, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
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
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

	))

//------------ RESEARCHER ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_researcher, list(

		list("MEDICAL SET (MANDATORY)", 0, null, null, null),
		list("Essential Medical Set", 0, /obj/effect/essentials_set/medical/doctor, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("STANDARD EQUIPMENT", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/latex, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/research, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),

		list("EYEWEAR (CHOOSE 1)", 0, null, null, null),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),
		list("Prescription Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health/prescription, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),
		list("Reagent Scanner HUD Goggles", 0, /obj/item/clothing/glasses/science, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Prescription Reagent Scanner HUD Goggles", 0, /obj/item/clothing/glasses/science/prescription, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),

		list("UNIFORM (CHOOSE 1)", 0, null, null, null),
		list("Researcher Uniform", 0, /obj/item/clothing/under/marine/officer/researcher, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Green Scrubs", 0, /obj/item/clothing/under/rank/medical/green, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Blue Scrubs", 0, /obj/item/clothing/under/rank/medical/blue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Light Blue Scrubs", 0, /obj/item/clothing/under/rank/medical/lightblue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Purple Scrubs", 0, /obj/item/clothing/under/rank/medical/purple, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Olive Scrubs", 0, /obj/item/clothing/under/rank/medical/olive, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Grey Scrubs", 0, /obj/item/clothing/under/rank/medical/grey, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("SUIT (CHOOSE 1)", 0, null, null, null),
		list("Labcoat", 0, /obj/item/clothing/suit/storage/labcoat/researcher, MARINE_CAN_BUY_MRE, VENDOR_ITEM_RECOMMENDED),

		list("SNOW GEAR (SNOW USE ONLY)", 0, null, null, null),
		list("Snowcoat", 0, /obj/item/clothing/suit/storage/snow_suit/doctor, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Balaclava", 0, /obj/item/clothing/mask/balaclava, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Snow Scarf", 0, /obj/item/clothing/mask/tornscarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),

		list("HEADWEAR (CHOOSE 1)", 0, null, null, null),
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

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Vials Pouch", 0, /obj/item/storage/pouch/vials, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_MANDATORY),
		list("Chemist Pouch", 0, /obj/item/storage/pouch/chem, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_MANDATORY),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Bicaridine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Kelotane)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_tricord, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Peridaxon)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_peri, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (EMPTY)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

	))

/obj/effect/essentials_set/medical
	spawned_gear_list = list(
		/obj/item/device/defibrillator,
		/obj/item/storage/firstaid/adv,
		/obj/item/device/healthanalyzer,
		/obj/item/tool/surgery/surgical_line,
		/obj/item/tool/surgery/synthgraft,
		/obj/item/storage/syringe_case,
		/obj/item/storage/surgical_case/regular,
		/obj/item/clothing/accessory/stethoscope,
		/obj/item/device/flashlight/pen,


	)

/obj/effect/essentials_set/medical/doctor
	spawned_gear_list = list(
		/obj/item/device/defibrillator,
		/obj/item/storage/firstaid/adv,
		/obj/item/device/healthanalyzer,
		/obj/item/tool/surgery/surgical_line,
		/obj/item/tool/surgery/synthgraft,
		/obj/item/clothing/accessory/stethoscope,
		/obj/item/device/flashlight/pen,
		/obj/item/storage/syringe_case,
	)
