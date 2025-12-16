/obj/structure/machinery/cm_vending/clothing/medical_crew
	name = "\improper ColMarTech Medical Equipment Rack"
	desc = "An automated equipment vendor for the Medical Department."
	req_access = list(ACCESS_MARINE_MEDBAY)
	vendor_role = list(JOB_DOCTOR,JOB_FIELD_DOCTOR,JOB_NURSE,JOB_RESEARCHER,JOB_CMO,JOB_SURGEON,JOB_PHARMACIST)
	icon_state = "dress"

/obj/structure/machinery/cm_vending/clothing/medical_crew/get_listed_products(mob/user)
	if(!user)
		var/list/combined = list()
		combined += GLOB.cm_vending_clothing_nurse
		combined += GLOB.cm_vending_clothing_researcher
		combined += GLOB.cm_vending_clothing_cmo
		combined += GLOB.cm_vending_clothing_doctor
		combined += GLOB.cm_vending_clothing_surgeon
		combined += GLOB.cm_vending_clothing_pharmacist
		combined += GLOB.cm_vending_clothing_field_doctor
		return combined
	if(user.job == JOB_NURSE)
		return GLOB.cm_vending_clothing_nurse
	else if(user.job == JOB_RESEARCHER)
		return GLOB.cm_vending_clothing_researcher
	else if(user.job == JOB_CMO)
		///defined in senior_officers.dm
		return GLOB.cm_vending_clothing_cmo
	else if(user.job == JOB_DOCTOR)
		return GLOB.cm_vending_clothing_doctor
	else if(user.job == JOB_SURGEON)
		return GLOB.cm_vending_clothing_surgeon
	else if(user.job == JOB_FIELD_DOCTOR)
		return GLOB.cm_vending_clothing_field_doctor
	else if(user.job == JOB_PHARMACIST)
		return GLOB.cm_vending_clothing_pharmacist
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

		list("HEADWEAR (CHOOSE 1)", 0, null, null, null),
		list("Doctor's Surgical Cap", 0, /obj/item/clothing/head/surgery/blue, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("Purple Surgical Cap", 0, /obj/item/clothing/head/surgery/purple, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Olive Surgical Cap", 0, /obj/item/clothing/head/surgery/olive, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Grey Surgical Cap", 0, /obj/item/clothing/head/surgery/grey, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Brown Surgical Cap", 0, /obj/item/clothing/head/surgery/brown, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("White Surgical Cap", 0, /obj/item/clothing/head/surgery/white, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Morgue Surgical Cap", 0, /obj/item/clothing/head/surgery/morgue, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("UNIFORM (CHOOSE 1)", 0, null, null, null),
		list("Doctor's Scrubs", 0, /obj/item/clothing/under/rank/medical/blue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Purple Scrubs", 0, /obj/item/clothing/under/rank/medical/purple, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Olive Scrubs", 0, /obj/item/clothing/under/rank/medical/olive, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Grey Scrubs", 0, /obj/item/clothing/under/rank/medical/grey, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Brown Scrubs", 0, /obj/item/clothing/under/rank/medical/brown, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("White Scrubs", 0, /obj/item/clothing/under/rank/medical/white, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Morgue Scrubs", 0, /obj/item/clothing/under/rank/medical/morgue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("SUIT (CHOOSE 1)", 0, null, null, null),
		list("Doctor's Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/doctor, MARINE_CAN_BUY_MRE, VENDOR_ITEM_RECOMMENDED),
		list("Doctor's High-Cut Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/doctor/short, MARINE_CAN_BUY_MRE, VENDOR_ITEM_RECOMMENDED),
		list("Doctor's Low-Cut Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/doctor/long, MARINE_CAN_BUY_MRE, VENDOR_ITEM_RECOMMENDED),
		list("Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("High-Cut Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/short, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("Low-Cut Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/long, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("Medical's Apron", 0, /obj/item/clothing/suit/chef/classic/medical, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),

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
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (EMPTY)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_tricord, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Peridaxon)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_peri, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Field Anesthetic)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/oxycodone, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Bicaridine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Kelotane)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Chemistry Pouch", 0, /obj/item/storage/pouch/chem, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Autoinjectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
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

//------------ SURGEON ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_surgeon, list(

		list("MEDICAL SET (MANDATORY)", 0, null, null, null),
		list("Essential Medical Set", 0, /obj/effect/essentials_set/medical/doctor, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("STANDARD EQUIPMENT", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/latex, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/clothing/mask/surgical, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),

		list("EYEWEAR (CHOOSE 1)", 0, null, null, null),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Prescription Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health/prescription, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),

		list("HEADWEAR (CHOOSE 1)", 0, null, null, null),
		list("Surgeon's Surgical Cap", 0, /obj/item/clothing/head/surgery/green, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("Purple Surgical Cap", 0, /obj/item/clothing/head/surgery/purple, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Olive Surgical Cap", 0, /obj/item/clothing/head/surgery/olive, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Grey Surgical Cap", 0, /obj/item/clothing/head/surgery/grey, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Brown Surgical Cap", 0, /obj/item/clothing/head/surgery/brown, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("White Surgical Cap", 0, /obj/item/clothing/head/surgery/white, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Morgue Surgical Cap", 0, /obj/item/clothing/head/surgery/morgue, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("UNIFORM (CHOOSE 1)", 0, null, null, null),
		list("Surgeon's Scrubs", 0, /obj/item/clothing/under/rank/medical/green, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Purple Scrubs", 0, /obj/item/clothing/under/rank/medical/purple, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Olive Scrubs", 0, /obj/item/clothing/under/rank/medical/olive, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Grey Scrubs", 0, /obj/item/clothing/under/rank/medical/grey, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Brown Scrubs", 0, /obj/item/clothing/under/rank/medical/brown, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("White Scrubs", 0, /obj/item/clothing/under/rank/medical/white, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Morgue Scrubs", 0, /obj/item/clothing/under/rank/medical/morgue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("SUIT (CHOOSE 1)", 0, null, null, null),
		list("Surgeon's Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/surgeon, MARINE_CAN_BUY_MRE, VENDOR_ITEM_RECOMMENDED),
		list("Surgeon's High-Cut Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/surgeon/short, MARINE_CAN_BUY_MRE, VENDOR_ITEM_RECOMMENDED),
		list("Surgeon's Low-Cut Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/surgeon/long, MARINE_CAN_BUY_MRE, VENDOR_ITEM_RECOMMENDED),
		list("Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("High-Cut Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/short, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("Low-Cut Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/long, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("Medical's Apron", 0, /obj/item/clothing/suit/chef/classic/medical, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),

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
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (EMPTY)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_tricord, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Peridaxon)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_peri, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Field Anesthetic)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/oxycodone, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Bicaridine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Kelotane)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Chemistry Pouch", 0, /obj/item/storage/pouch/chem, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Autoinjectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
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


//------------ FIELD DOCTOR ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_field_doctor, list(

		list("MEDICAL SET (MANDATORY)", 0, null, null, null),
		list("Essential Medical & Field Set", 0, /obj/effect/essentials_set/medical/doctor/field, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("STANDARD EQUIPMENT", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/latex, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/clothing/mask/surgical, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),

		list("EYEWEAR (CHOOSE 1)", 0, null, null, null),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Prescription Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health/prescription, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),

		list("HEADWEAR (CHOOSE 1)", 0, null, null, null),
		list("Surgeon's Surgical Cap", 0, /obj/item/clothing/head/surgery/green, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("Purple Surgical Cap", 0, /obj/item/clothing/head/surgery/purple, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Olive Surgical Cap", 0, /obj/item/clothing/head/surgery/olive, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Grey Surgical Cap", 0, /obj/item/clothing/head/surgery/grey, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Brown Surgical Cap", 0, /obj/item/clothing/head/surgery/brown, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("White Surgical Cap", 0, /obj/item/clothing/head/surgery/white, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Morgue Surgical Cap", 0, /obj/item/clothing/head/surgery/morgue, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("UNIFORM (CHOOSE 1)", 0, null, null, null),
		list("Surgeon's Scrubs", 0, /obj/item/clothing/under/rank/medical/green, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Purple Scrubs", 0, /obj/item/clothing/under/rank/medical/purple, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Olive Scrubs", 0, /obj/item/clothing/under/rank/medical/olive, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Grey Scrubs", 0, /obj/item/clothing/under/rank/medical/grey, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Brown Scrubs", 0, /obj/item/clothing/under/rank/medical/brown, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("White Scrubs", 0, /obj/item/clothing/under/rank/medical/white, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Morgue Scrubs", 0, /obj/item/clothing/under/rank/medical/morgue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("SUIT (CHOOSE 1)", 0, null, null, null),
		list("Surgeon's Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/surgeon, MARINE_CAN_BUY_MRE, VENDOR_ITEM_RECOMMENDED),
		list("Surgeon's High-Cut Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/surgeon/short, MARINE_CAN_BUY_MRE, VENDOR_ITEM_RECOMMENDED),
		list("Surgeon's Low-Cut Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/surgeon/long, MARINE_CAN_BUY_MRE, VENDOR_ITEM_RECOMMENDED),
		list("Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("High-Cut Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/short, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("Low-Cut Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/long, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("Medical's Apron", 0, /obj/item/clothing/suit/chef/classic/medical, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),

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
		list("Pressurized Reagent Canister Pouch (Field Anesthetic)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/oxycodone, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_MANDATORY),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_MANDATORY),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (EMPTY)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_tricord, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Peridaxon)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_peri, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Field Anesthetic)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/oxycodone, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Bicaridine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Kelotane)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Chemistry Pouch", 0, /obj/item/storage/pouch/chem, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Autoinjectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
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

//------------ PHARMACEUTICAL PHYSICIAN ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_pharmacist, list(

		list("MEDICAL SET (MANDATORY)", 0, null, null, null),
		list("Essential Medical Set", 0, /obj/effect/essentials_set/medical/doctor, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("STANDARD EQUIPMENT", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/latex, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/doc, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),

		list("EYEWEAR (CHOOSE 1)", 0, null, null, null),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Prescription Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health/prescription, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),

		list("HEADWEAR (CHOOSE 1)", 0, null, null, null),
		list("Pharmaceutical Physician's Surgical Cap", 0, /obj/item/clothing/head/surgery/pharmacist, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("Purple Surgical Cap", 0, /obj/item/clothing/head/surgery/purple, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Olive Surgical Cap", 0, /obj/item/clothing/head/surgery/olive, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Grey Surgical Cap", 0, /obj/item/clothing/head/surgery/grey, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Brown Surgical Cap", 0, /obj/item/clothing/head/surgery/brown, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("White Surgical Cap", 0, /obj/item/clothing/head/surgery/white, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Morgue Surgical Cap", 0, /obj/item/clothing/head/surgery/morgue, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("UNIFORM (CHOOSE 1)", 0, null, null, null),
		list("Pharmaceutical Physician's Scrubs", 0, /obj/item/clothing/under/rank/medical/pharmacist, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Purple Scrubs", 0, /obj/item/clothing/under/rank/medical/purple, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Olive Scrubs", 0, /obj/item/clothing/under/rank/medical/olive, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Grey Scrubs", 0, /obj/item/clothing/under/rank/medical/grey, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Brown Scrubs", 0, /obj/item/clothing/under/rank/medical/brown, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("White Scrubs", 0, /obj/item/clothing/under/rank/medical/white, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Morgue Scrubs", 0, /obj/item/clothing/under/rank/medical/morgue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("SUIT (CHOOSE 1)", 0, null, null, null),
		list("Pharmaceutical Physician's Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/pharmacist, MARINE_CAN_BUY_MRE, VENDOR_ITEM_RECOMMENDED),
		list("Pharmaceutical Physician's High-Cut Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/pharmacist/short, MARINE_CAN_BUY_MRE, VENDOR_ITEM_RECOMMENDED),
		list("Pharmaceutical Physician's Low-Cut Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/pharmacist/long, MARINE_CAN_BUY_MRE, VENDOR_ITEM_RECOMMENDED),
		list("Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("High-Cut Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/short, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("Low-Cut Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/long, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("Medical's Apron", 0, /obj/item/clothing/suit/chef/classic/medical, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),

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
		list("Chemistry Pouch", 0, /obj/item/storage/pouch/chem, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (EMPTY)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_tricord, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Peridaxon)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_peri, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Field Anesthetic)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/oxycodone, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Bicaridine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Kelotane)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Autoinjectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
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
		list("Gloves", 0, /obj/item/clothing/gloves/latex, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/doc, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),

		list("EYEWEAR (CHOOSE 1)", 0, null, null, null),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Prescription Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health/prescription, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),

		list("HEADWEAR (CHOOSE 1)", 0, null, null, null),
		list("Nurse's Surgical Cap", 0, /obj/item/clothing/head/surgery/lightblue, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("Purple Surgical Cap", 0, /obj/item/clothing/head/surgery/purple, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Olive Surgical Cap", 0, /obj/item/clothing/head/surgery/olive, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Grey Surgical Cap", 0, /obj/item/clothing/head/surgery/grey, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Brown Surgical Cap", 0, /obj/item/clothing/head/surgery/brown, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("White Surgical Cap", 0, /obj/item/clothing/head/surgery/white, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Morgue Surgical Cap", 0, /obj/item/clothing/head/surgery/morgue, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("UNIFORM (CHOOSE 1)", 0, null, null, null),
		list("Nurse's Scrubs", 0, /obj/item/clothing/under/rank/medical/lightblue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Purple Scrubs", 0, /obj/item/clothing/under/rank/medical/purple, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Olive Scrubs", 0, /obj/item/clothing/under/rank/medical/olive, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Grey Scrubs", 0, /obj/item/clothing/under/rank/medical/grey, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Brown Scrubs", 0, /obj/item/clothing/under/rank/medical/brown, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("White Scrubs", 0, /obj/item/clothing/under/rank/medical/white, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Morgue Scrubs", 0, /obj/item/clothing/under/rank/medical/morgue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("SUIT (CHOOSE 1)", 0, null, null, null),
		list("Nurse's Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/nurse, MARINE_CAN_BUY_MRE, VENDOR_ITEM_RECOMMENDED),
		list("Nurse's High-Cut Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/nurse/short, MARINE_CAN_BUY_MRE,VENDOR_ITEM_RECOMMENDED),
		list("Medical's Apron", 0, /obj/item/clothing/suit/chef/classic/medical, MARINE_CAN_BUY_MRE, VENDOR_ITEM_RECOMMENDED),
		list("Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("High-Cut Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/short, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),

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
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (EMPTY)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_tricord, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Peridaxon)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_peri, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Field Anesthetic)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/oxycodone, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Bicaridine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Kelotane)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Chemistry Pouch", 0, /obj/item/storage/pouch/chem, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Autoinjectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
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

		list("HEADWEAR (CHOOSE 1)", 0, null, null, null),
		list("Purple Surgical Cap", 0, /obj/item/clothing/head/surgery/purple, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Olive Surgical Cap", 0, /obj/item/clothing/head/surgery/olive, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Grey Surgical Cap", 0, /obj/item/clothing/head/surgery/grey, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Brown Surgical Cap", 0, /obj/item/clothing/head/surgery/brown, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("White Surgical Cap", 0, /obj/item/clothing/head/surgery/white, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Morgue Surgical Cap", 0, /obj/item/clothing/head/surgery/morgue, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("UNIFORM (CHOOSE 1)", 0, null, null, null),
		list("Researcher Uniform", 0, /obj/item/clothing/under/marine/officer/researcher, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Purple Scrubs", 0, /obj/item/clothing/under/rank/medical/purple, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Olive Scrubs", 0, /obj/item/clothing/under/rank/medical/olive, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Grey Scrubs", 0, /obj/item/clothing/under/rank/medical/grey, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Brown Scrubs", 0, /obj/item/clothing/under/rank/medical/brown, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("White Scrubs", 0, /obj/item/clothing/under/rank/medical/white, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Morgue Scrubs", 0, /obj/item/clothing/under/rank/medical/morgue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("SUIT (CHOOSE 1)", 0, null, null, null),
		list("Researcher's Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/researcher, MARINE_CAN_BUY_MRE, VENDOR_ITEM_RECOMMENDED),
		list("Researcher's High-Cut Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/researcher/short, MARINE_CAN_BUY_MRE, VENDOR_ITEM_RECOMMENDED),
		list("Researcher's White Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/surgeon, MARINE_CAN_BUY_MRE, VENDOR_ITEM_RECOMMENDED),
		list("Researcher's White High-Cut Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/surgeon/short, MARINE_CAN_BUY_MRE, VENDOR_ITEM_RECOMMENDED),
		list("Researcher's White Low-Cut Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/surgeon/long, MARINE_CAN_BUY_MRE, VENDOR_ITEM_RECOMMENDED),
		list("Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("High-Cut Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/short, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),
		list("Low-Cut Lab Coat", 0, /obj/item/clothing/suit/storage/labcoat/long, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),

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
		list("Vials Pouch", 0, /obj/item/storage/pouch/vials, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_MANDATORY),
		list("Chemistry Pouch", 0, /obj/item/storage/pouch/chem, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_MANDATORY),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (EMPTY)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_tricord, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Peridaxon)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_peri, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Field Anesthetic)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/oxycodone, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Bicaridine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Kelotane)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Autoinjectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
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
		/obj/item/clothing/suit/storage/marine/light/vest,
		/obj/item/clothing/shoes/marine,
		/obj/item/clothing/head/helmet/marine/medic,
		/obj/item/storage/box/mre,
		/obj/item/device/radio/marine,
		/obj/item/clothing/accessory/patch/medic_patch,
	)



