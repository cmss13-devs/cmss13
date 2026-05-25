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
		return combined
	if(user.job == JOB_NURSE)
		return GLOB.cm_vending_clothing_nurse
	else if(user.job == JOB_CMO)
		///defined in senior_officers.dm
		return GLOB.cm_vending_clothing_cmo
	else if(user.job == JOB_DOCTOR || user.job == JOB_FIELD_DOCTOR)
		return GLOB.cm_vending_clothing_doctor
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

		list("UNIFORM (CHOOSE 1)", 0, null, null, null),
		list("Doctor's Scrubs", 0, /obj/item/clothing/under/rank/medical/blue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Surgeon's Scrubs", 0, /obj/item/clothing/under/rank/medical/green, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Pharmaceutical Physician's Scrubs", 0, /obj/item/clothing/under/rank/medical/pharmacist, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Purple Scrubs", 0, /obj/item/clothing/under/rank/medical/purple, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Olive Scrubs", 0, /obj/item/clothing/under/rank/medical/olive, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Grey Scrubs", 0, /obj/item/clothing/under/rank/medical/grey, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Brown Scrubs", 0, /obj/item/clothing/under/rank/medical/brown, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("White Scrubs", 0, /obj/item/clothing/under/rank/medical/white, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Morgue Scrubs", 0, /obj/item/clothing/under/rank/medical/morgue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("SUIT (CHOOSE 1)", 0, null, null, null),
		list("Lab Coat, White", 0, /obj/item/clothing/suit/storage/labcoat, MARINE_CAN_BUY_MRE, VENDOR_ITEM_RECOMMENDED),
		list("High-Cut Lab Coat, White", 0, /obj/item/clothing/suit/storage/labcoat/short, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("Low-Cut Lab Coat, White", 0, /obj/item/clothing/suit/storage/labcoat/long, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("Pharmaceutical Physician's Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/pharmacist, MARINE_CAN_BUY_MRE, VENDOR_ITEM_RECOMMENDED),
		list("Medical's Apron", 0, /obj/item/clothing/suit/chef/classic/medical, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),

		list("SNOW GEAR (SNOW USE ONLY)", 0, null, null, null),
		list("Snow Coat", 0, /obj/item/clothing/suit/storage/snow_suit/doctor, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Balaclava", 0, /obj/item/clothing/mask/balaclava, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Snow Scarf", 0, /obj/item/clothing/mask/tornscarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),

		list("HEADWEAR (CHOOSE 1)", 0, null, null, null),
		list("Doctor's Surgical Cap", 0, /obj/item/clothing/head/surgery/blue, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("Surgeon's Surgical Cap", 0, /obj/item/clothing/head/surgery/green, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("Pharmaceutical Physician's Surgical Cap", 0, /obj/item/clothing/head/surgery/pharmacist, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("Purple Surgical Cap", 0, /obj/item/clothing/head/surgery/purple, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Olive Surgical Cap", 0, /obj/item/clothing/head/surgery/olive, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Grey Surgical Cap", 0, /obj/item/clothing/head/surgery/grey, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Brown Surgical Cap", 0, /obj/item/clothing/head/surgery/brown, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("White Surgical Cap", 0, /obj/item/clothing/head/surgery/white, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Morgue Surgical Cap", 0, /obj/item/clothing/head/surgery/morgue, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

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
		list("First-Aid Pouch (Refillable Autoinjectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Chemistry Pouch", 0, /obj/item/storage/pouch/chem, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Bicaridine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Kelotane)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_tricord, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Peridaxon)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_peri, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Field Anesthetic)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/oxycodone, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (EMPTY)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
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

		list("UNIFORM (CHOOSE 1)", 0, null, null, null),
		list("Nurse's Scrubs", 0, /obj/item/clothing/under/rank/medical/lightblue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Pharmaceutical Physician's Scrubs", 0, /obj/item/clothing/under/rank/medical/pharmacist, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Purple Scrubs", 0, /obj/item/clothing/under/rank/medical/purple, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Olive Scrubs", 0, /obj/item/clothing/under/rank/medical/olive, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Grey Scrubs", 0, /obj/item/clothing/under/rank/medical/grey, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Brown Scrubs", 0, /obj/item/clothing/under/rank/medical/brown, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("White Scrubs", 0, /obj/item/clothing/under/rank/medical/white, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Morgue Scrubs", 0, /obj/item/clothing/under/rank/medical/morgue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("SUIT (CHOOSE 1)", 0, null, null, null),
		list("Medical's Apron", 0, /obj/item/clothing/suit/chef/classic/medical, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),

		list("SNOW GEAR (SNOW USE ONLY)", 0, null, null, null),
		list("Snow Coat", 0, /obj/item/clothing/suit/storage/snow_suit/doctor, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Balaclava", 0, /obj/item/clothing/mask/balaclava, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("Snow Scarf", 0, /obj/item/clothing/mask/tornscarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),

		list("HEADWEAR (CHOOSE 1)", 0, null, null, null),
		list("Nurse's Surgical Cap", 0, /obj/item/clothing/head/surgery/lightblue, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("Pharmaceutical Physician's Surgical Cap", 0, /obj/item/clothing/head/surgery/pharmacist, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Purple Surgical Cap", 0, /obj/item/clothing/head/surgery/purple, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Olive Surgical Cap", 0, /obj/item/clothing/head/surgery/olive, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Grey Surgical Cap", 0, /obj/item/clothing/head/surgery/grey, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Brown Surgical Cap", 0, /obj/item/clothing/head/surgery/brown, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("White Surgical Cap", 0, /obj/item/clothing/head/surgery/white, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Morgue Surgical Cap", 0, /obj/item/clothing/head/surgery/morgue, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

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
		list("First-Aid Pouch (Refillable Autoinjectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Chemistry Pouch", 0, /obj/item/storage/pouch/chem, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Bicaridine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Kelotane)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_tricord, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Peridaxon)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_peri, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Field Anesthetic)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/oxycodone, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (EMPTY)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))

//------------ RESEARCHER ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_researcher, list(

		list("RESEARCH SET", 0, null, null, null),
		list("Recommended Research set", 0, /obj/effect/essentials_set/medical/researcher, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("IMPORTANT EQUIPMENT", 0, null, null, null),
		list("Latex gloves", 0, /obj/item/clothing/gloves/latex, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Research headset", 0, /obj/item/device/radio/headset/almayer/research, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),

		list("EYEWEAR (CHOOSE 2)", 0, null, null, null),
		list("Reagent scanner HUD goggles", 0, /obj/item/clothing/glasses/science, CIVILIAN_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Prescription reagent scanner HUD goggles", 0, /obj/item/clothing/glasses/science/prescription, CIVILIAN_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Medical HUD glasses", 0, /obj/item/clothing/glasses/hud/health, CIVILIAN_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),
		list("Prescription medical HUD glasses", 0, /obj/item/clothing/glasses/hud/health/prescription, CIVILIAN_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),

		list("UNDERSUITS (CHOOSE 5)", 0, null, null, null),
		list("Simple white shirt, black pants", 0, /obj/item/clothing/under/sl_suit, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Simple White Shirt, blue pants", 0, /obj/item/clothing/under/lawyer/bluesuit, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("black suit pants", 0, /obj/item/clothing/under/liaison_suit/black, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("blue suit pants", 0, /obj/item/clothing/under/liaison_suit/blue, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("brown suit pants", 0, /obj/item/clothing/under/liaison_suit/brown, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("White suit pants", 0, /obj/item/clothing/under/liaison_suit/corporate_formal, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Grey suit pants", 0, /obj/item/clothing/under/detective/grey, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Worn suit", 0, /obj/item/clothing/under/detective/neutral, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Simple orange shirt, black pants", 0, /obj/item/clothing/under/liaison_suit/orange, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("BUTTON-UP SHIRTS (CHOOSE 5)", 0, null, null, null),
		list("Grey work shirt, Grey pants", 0, /obj/item/clothing/under/colonist/workwear, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Khaki work shirt, blue pants", 0, /obj/item/clothing/under/colonist/workwear/khaki, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Pink work shirt, blue pants", 0, /obj/item/clothing/under/colonist/workwear/pink, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Green work shirt, dark tan pants", 0, /obj/item/clothing/under/colonist/workwear/green, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Blue work shirt, dark tan pants", 0, /obj/item/clothing/under/colonist/workwear/blue, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("White work shirt, grey pants", 0, /obj/item/clothing/under/marine/reporter, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Black work shirt, dark tan pants", 0, /obj/item/clothing/under/marine/reporter/black, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Orange work shirt, black pants", 0, /obj/item/clothing/under/marine/reporter/orange, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Red work shirt, light tan pants", 0, /obj/item/clothing/under/marine/reporter/red, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("T-SHIRTS (CHOOSE 5)", 0, null, null, null),
		list("White T-shirt, brown jeans", 0, /obj/item/clothing/under/tshirt/w_br, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Gray T-shirt, blue jeans", 0, /obj/item/clothing/under/tshirt/gray_blu, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Red T-shirt, black jeans", 0, /obj/item/clothing/under/tshirt/r_bla, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("LABCOATS (CHOOSE 1)", 0, null, null, null),
		list("Lab coat, white", 0, /obj/item/clothing/suit/storage/labcoat, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_MANDATORY),
		list("High-cut lab coat, white", 0, /obj/item/clothing/suit/storage/labcoat/short, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_RECOMMENDED),
		list("Low-cut lab coat, white", 0, /obj/item/clothing/suit/storage/labcoat/long, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_RECOMMENDED),
		list("Lab coat, tan", 0, /obj/item/clothing/suit/storage/labcoat/researcher, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_REGULAR),

		list("LACEUPS (CHOOSE 2)", 0, null, null, null),
		list("Laceup shoes, black", 0, /obj/item/clothing/shoes/laceup, CIVILIAN_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Laceup shoes, brown", 0, /obj/item/clothing/shoes/laceup/brown, CIVILIAN_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Fancy leather shoes", 0, /obj/item/clothing/shoes/leather/fancy, CIVILIAN_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),

		list("SNEAKERS (CHOOSE 2)", 0, null, null, null),
		list("Sneakers, black", 0, /obj/item/clothing/shoes/black, CIVILIAN_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Sneakers, brown", 0, /obj/item/clothing/shoes/brown, CIVILIAN_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Sneakers, blue", 0, /obj/item/clothing/shoes/blue, CIVILIAN_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Sneakers, green", 0, /obj/item/clothing/shoes/green, CIVILIAN_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Sneakers, yellow", 0, /obj/item/clothing/shoes/yellow, CIVILIAN_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Sneakers, purple", 0, /obj/item/clothing/shoes/purple, CIVILIAN_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Sneakers, red", 0, /obj/item/clothing/shoes/red, CIVILIAN_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Sneakers, rainbow", 0, /obj/item/clothing/shoes/rainbow, CIVILIAN_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),

		list("BAG (CHOOSE 1)", 0, null, null, null),
		list("Leather brown satchel", 0, /obj/item/storage/backpack/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Leather blue satchel", 0, /obj/item/storage/backpack/satchel/blue, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Leather black satchel", 0, /obj/item/storage/backpack/satchel/black, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Marine satchel", 0, /obj/item/storage/backpack/marine/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 Lifesaver bag (Full)", 0, /obj/item/storage/belt/medical/lifesaver/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 medical storage rig (Full)", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 G8-A general utility pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Vials pouch", 0, /obj/item/storage/pouch/vials, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_MANDATORY),
		list("Chemistry pouch", 0, /obj/item/storage/pouch/chem, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_MANDATORY),
		list("Autoinjector pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid pouch (Refillable autoinjectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid pouch (Pill packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First responder Pouch", 0, /obj/item/storage/pouch/first_responder, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medical pouch", 0, /obj/item/storage/pouch/medical, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical kit pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized reagent canister pouch (Bicaridine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized reagent canister pouch (Kelotane)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized reagent canister pouch (Revival mixture - Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_tricord, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized reagent canister pouch (Revival mixture - Peridaxon)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_peri, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized reagent canister pouch (Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized reagent canister pouch (Field anesthetic)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/oxycodone, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized reagent canister pouch (EMPTY)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Sling pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("TIES (CHOOSE 5)", 0, null, null, null),
		list("Black tie", 0, /obj/item/clothing/accessory/tie/black, CIVILIAN_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Red tie", 0, /obj/item/clothing/accessory/tie/red, CIVILIAN_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Purple tie", 0, /obj/item/clothing/accessory/tie/purple, CIVILIAN_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Blue tie", 0, /obj/item/clothing/accessory/tie, CIVILIAN_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Green tie", 0, /obj/item/clothing/accessory/tie/green, CIVILIAN_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Gold tie", 0, /obj/item/clothing/accessory/tie/gold, CIVILIAN_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Special tie", 0, /obj/item/clothing/accessory/tie/horrible, CIVILIAN_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("SHOULDER PATCHES (CHOOSE 5)", 0, null, null, null),
		list("Weyland-Yutani round patch, black", 0, /obj/item/clothing/accessory/patch/wy, CIVILIAN_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Weyland-Yutani square patch, black", 0, /obj/item/clothing/accessory/patch/wysquare, CIVILIAN_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Weyland-Yutani round patch, white", 0, /obj/item/clothing/accessory/patch/wy_white, CIVILIAN_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
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

/obj/effect/essentials_set/medical/researcher
	spawned_gear_list = list(
		/obj/item/device/healthanalyzer,
		/obj/item/device/reagent_scanner,
		/obj/item/clothing/accessory/stethoscope,
		/obj/item/device/flashlight/pen,
	)


