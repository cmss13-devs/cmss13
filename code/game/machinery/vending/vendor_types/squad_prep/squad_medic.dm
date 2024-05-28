//------------GEAR VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_gear_medic, list(
		list("MEDICAL SET (MANDATORY)", 0, null, null, null),
		list("Essential Medical Set", 0, /obj/effect/essentials_set/medic, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("FIELD SUPPLIES", 0, null, null, null),
		list("Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_RECOMMENDED),
		list("Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_RECOMMENDED),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_RECOMMENDED),
		list("Gauze", 1, /obj/item/stack/medical/bruise_pack, null, VENDOR_ITEM_REGULAR),
		list("Ointment", 1, /obj/item/stack/medical/ointment, null, VENDOR_ITEM_REGULAR),
		list("Blood Bag (O-)", 4, /obj/item/reagent_container/blood/OMinus, null, VENDOR_ITEM_REGULAR),

		list("FIRSTAID KITS", 0, null, null, null),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_RECOMMENDED),
		list("Firstaid Kit", 5, /obj/item/storage/firstaid/regular, null, VENDOR_ITEM_REGULAR),
		list("Fire Firstaid Kit", 6, /obj/item/storage/firstaid/fire, null, VENDOR_ITEM_REGULAR),
		list("Toxin Firstaid Kit", 6, /obj/item/storage/firstaid/toxin, null, VENDOR_ITEM_REGULAR),
		list("Oxygen Firstaid Kit", 6, /obj/item/storage/firstaid/o2, null, VENDOR_ITEM_REGULAR),
		list("Radiation Firstaid Kit", 6, /obj/item/storage/firstaid/rad, null, VENDOR_ITEM_REGULAR),

		list("AUTOINJECTORS", 0, null, null, null),
		list("Autoinjector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Epinephrine)", 2, /obj/item/reagent_container/hypospray/autoinjector/adrenaline, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("PILL BOTTLES", 0, null, null, null),
		list("Pill Bottle (Bicaridine)", 5, /obj/item/storage/pill_bottle/bicaridine, null, VENDOR_ITEM_RECOMMENDED),
		list("Pill Bottle (Dexalin)", 5, /obj/item/storage/pill_bottle/dexalin, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Dylovene)", 5, /obj/item/storage/pill_bottle/antitox, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Inaprovaline)", 5, /obj/item/storage/pill_bottle/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Kelotane)", 5, /obj/item/storage/pill_bottle/kelotane, null, VENDOR_ITEM_RECOMMENDED),
		list("Pill Bottle (Peridaxon)", 5, /obj/item/storage/pill_bottle/peridaxon, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Tramadol)", 5, /obj/item/storage/pill_bottle/tramadol, null, VENDOR_ITEM_RECOMMENDED),

		list("MEDICAL UTILITIES", 0, null, null, null),
		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Roller Bed", 4, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Stasis Bag", 6, /obj/item/bodybag/cryobag, null, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (EMPTY)", 3, /obj/item/storage/pouch/pressurized_reagent_canister, null, VENDOR_ITEM_REGULAR),
		list("G8-A General Utility Pouch", 15, /obj/item/storage/backpack/general_belt, null, VENDOR_ITEM_REGULAR),
		list("MS-11 Smart Refill Tank", 6, /obj/item/reagent_container/glass/minitank, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("M40 HEDP High Explosive Packet (x3 grenades)", 18, /obj/item/storage/box/packet/high_explosive, null, VENDOR_ITEM_REGULAR),
		list("M40 HIDP Incendiary Packet (x3 grenades)", 18, /obj/item/storage/box/packet/incendiary, null, VENDOR_ITEM_REGULAR),
		list("M40 HPDP White Phosphorus Packet (x3 grenades)", 18, /obj/item/storage/box/packet/phosphorus, null, VENDOR_ITEM_REGULAR),
		list("M40 HSDP Smoke Packet (x3 grenades)", 9, /obj/item/storage/box/packet/smoke, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Frag Airburst Packet (x3 airburst grenades)", 20, /obj/item/storage/box/packet/airburst_he, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Incendiary Airburst Packet (x3 airburst grenades)", 20, /obj/item/storage/box/packet/airburst_incen, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Smoke Airburst Packet (x3 airburst grenades)", 10, /obj/item/storage/box/packet/airburst_smoke, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Hornet Airburst Packet (x3 airburst grenades", 20, /obj/item/storage/box/packet/hornet, null, VENDOR_ITEM_REGULAR),
		list("M20 Mine Box (x4 mines)", 20, /obj/item/storage/box/explosive_mines, null, VENDOR_ITEM_REGULAR),

		list("PRIMARY AMMUNITION", 0, null, null, null),
		list("M4RA AP Magazine (10x24mm)", 6, /obj/item/ammo_magazine/rifle/m4ra/ap, null, VENDOR_ITEM_REGULAR),
		list("M39 AP Magazine (10x20mm)", 6, /obj/item/ammo_magazine/smg/m39/ap , null, VENDOR_ITEM_REGULAR),
		list("M39 Extended Magazine (10x20mm)", 6, /obj/item/ammo_magazine/smg/m39/extended , null, VENDOR_ITEM_REGULAR),
		list("M41A AP Magazine (10x24mm)", 6, /obj/item/ammo_magazine/rifle/ap , null, VENDOR_ITEM_REGULAR),
		list("M41A Extended Magazine (10x24mm)", 6, /obj/item/ammo_magazine/rifle/extended , null, VENDOR_ITEM_REGULAR),

		list("SIDEARM AMMUNITION", 0, null, null, null),
		list("M44 Heavy Speed Loader (.44)", 6, /obj/item/ammo_magazine/revolver/heavy, null, VENDOR_ITEM_REGULAR),
		list("M44 Marksman Speed Loader (.44)", 6, /obj/item/ammo_magazine/revolver/marksman, null, VENDOR_ITEM_REGULAR),
		list("M4A3 HP Magazine", 3, /obj/item/ammo_magazine/pistol/hp, null, VENDOR_ITEM_REGULAR),
		list("M4A3 AP Magazine", 3, /obj/item/ammo_magazine/pistol/ap, null, VENDOR_ITEM_REGULAR),
		list("VP78 Magazine", 3, /obj/item/ammo_magazine/pistol/vp78, null, VENDOR_ITEM_REGULAR),
		list("SU-6 Smartpistol Magazine (.45)", 6, /obj/item/ammo_magazine/pistol/smart, null, VENDOR_ITEM_REGULAR),

		list("ARMORS", 0, null, null, null),
		list("M3 B12 Pattern Marine Armor", 24, /obj/item/clothing/suit/storage/marine/medium/leader, null, VENDOR_ITEM_REGULAR),
		list("M4 Pattern Armor", 16, /obj/item/clothing/suit/storage/marine/medium/rto, null, VENDOR_ITEM_REGULAR),

		list("RESTRICTED FIREARMS", 0, null, null, null),
		list("VP78 Pistol", 8, /obj/item/storage/box/guncase/vp78, null, VENDOR_ITEM_REGULAR),
		list("SU-6 Smart Pistol", 12, /obj/item/storage/box/guncase/smartpistol, null, VENDOR_ITEM_REGULAR),

		list("CLOTHING ITEMS", 0, null, null, null),
		list("Machete Scabbard (Full)", 6, /obj/item/storage/large_holster/machete/full, null, VENDOR_ITEM_REGULAR),
		list("Machete Pouch (Full)", 8, /obj/item/storage/pouch/machete/full, null, VENDOR_ITEM_REGULAR),
		list("USCM Radio Telephone Pack", 15, /obj/item/storage/backpack/marine/satchel/rto, null, VENDOR_ITEM_REGULAR),
		list("Fuel Tank Strap Pouch", 4, /obj/item/storage/pouch/flamertank, null, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", 3, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Fire Extinguisher (Portable)", 3, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 8, /obj/item/device/motiondetector, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 3, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),

		list("BINOCULARS", 0, null, null, null),
		list("Binoculars", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Range Finder", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("Laser Designator", 15, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),

		list("HELMET OPTICS", 0, null, null, null),
		list("Welding Visor", 5, /obj/item/device/helmet_visor/welding_visor, null, VENDOR_ITEM_REGULAR),

		list("PAMPHLETS", 0, null, null, null),
		list("JTAC Pamphlet", 15, /obj/item/pamphlet/skill/jtac, null, VENDOR_ITEM_REGULAR),
		list("Engineering Pamphlet", 15, /obj/item/pamphlet/skill/engineer, null, VENDOR_ITEM_REGULAR),

		list("RADIO KEYS", 0, null, null, null),
		list("Engineering Radio Encryption Key", 3, /obj/item/device/encryptionkey/engi, null, VENDOR_ITEM_REGULAR),
		list("Intel Radio Encryption Key", 3, /obj/item/device/encryptionkey/intel, null, VENDOR_ITEM_REGULAR),
		list("JTAC Radio Encryption Key", 3, /obj/item/device/encryptionkey/jtac, null, VENDOR_ITEM_REGULAR),
		list("Supply Radio Encryption Key", 3, /obj/item/device/encryptionkey/req, null, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/gear/medic
	name = "\improper ColMarTech Squad Medical Gear Rack"
	desc = "An automated gear rack for hospital corpsmen."
	icon_state = "med_gear"
	show_points = TRUE
	vendor_role = list(JOB_SQUAD_MEDIC)
	req_access = list(ACCESS_MARINE_MEDPREP)

/obj/structure/machinery/cm_vending/gear/medic/get_listed_products(mob/user)
	return GLOB.cm_vending_gear_medic

//------------CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_medic, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Standard Marine Apparel", 0, list(/obj/item/clothing/under/marine/medic, /obj/item/clothing/shoes/marine/knife, /obj/item/clothing/gloves/marine, /obj/item/device/radio/headset/almayer/marine, /obj/item/clothing/head/helmet/marine/medic), MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Combat Sterile Gloves", 0, /obj/item/clothing/gloves/marine/medical, MARINE_CAN_BUY_KIT, VENDOR_ITEM_REGULAR),
		list("MRE", 0, /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Map", 0, /obj/item/map/current_map, MARINE_CAN_BUY_KIT, VENDOR_ITEM_MANDATORY),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("Light Armor", 0, /obj/item/clothing/suit/storage/marine/light, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Medium Armor", 0, /obj/item/clothing/suit/storage/marine/medium, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
		list("Heavy Armor", 0, /obj/item/clothing/suit/storage/marine/heavy, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("BACKPACK (CHOOSE 1)", 0, null, null, null),
		list("Medical Backpack", 0, /obj/item/storage/backpack/marine/medic, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Medical Satchel", 0, /obj/item/storage/backpack/marine/satchel/medic, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Lifesaver Bag (Full)", 0, /obj/item/storage/belt/medical/lifesaver/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Medical Storage Rig (Full)", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 M39 Holster Rig", 0, /obj/item/storage/belt/gun/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M44 Holster Rig", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M40 Grenade Rig", 0, /obj/item/storage/belt/grenade, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Bicaridine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Kelotane)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (EMPTY)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),

		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Vial Pouch (Full)", 0, /obj/item/storage/pouch/vials/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Sterile Mask", 0, /obj/item/clothing/mask/surgical, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	))

/obj/structure/machinery/cm_vending/clothing/medic
	name = "\improper ColMarTech Squad Medical Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of hospital corpsman standard-issue equipment."
	req_access = list(ACCESS_MARINE_MEDPREP)
	vendor_role = list(JOB_SQUAD_MEDIC)

/obj/structure/machinery/cm_vending/clothing/medic/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_medic

/obj/structure/machinery/cm_vending/clothing/medic/alpha
	squad_tag = SQUAD_MARINE_1
	req_access = list(ACCESS_MARINE_MEDPREP, ACCESS_MARINE_ALPHA)
	headset_type = /obj/item/device/radio/headset/almayer/marine/alpha/med

/obj/structure/machinery/cm_vending/clothing/medic/bravo
	squad_tag = SQUAD_MARINE_2
	req_access = list(ACCESS_MARINE_MEDPREP, ACCESS_MARINE_BRAVO)
	headset_type = /obj/item/device/radio/headset/almayer/marine/bravo/med

/obj/structure/machinery/cm_vending/clothing/medic/charlie
	squad_tag = SQUAD_MARINE_3
	req_access = list(ACCESS_MARINE_MEDPREP, ACCESS_MARINE_CHARLIE)
	headset_type = /obj/item/device/radio/headset/almayer/marine/charlie/med

/obj/structure/machinery/cm_vending/clothing/medic/delta
	squad_tag = SQUAD_MARINE_4
	req_access = list(ACCESS_MARINE_MEDPREP, ACCESS_MARINE_DELTA)
	headset_type = /obj/item/device/radio/headset/almayer/marine/delta/med

//------------ESSENTIAL SETS---------------

/obj/effect/essentials_set/medic
	spawned_gear_list = list(
		/obj/item/bodybag/cryobag,
		/obj/item/device/defibrillator,
		/obj/item/storage/firstaid/adv,
		/obj/item/device/healthanalyzer,
		/obj/item/roller/medevac,
		/obj/item/roller,
		/obj/item/tool/surgery/surgical_line, //obj/item/storage/firstaid/surgical once broader medic surgeries are done, but for now suturing is the only good one.
		/obj/item/tool/surgery/synthgraft,
		/obj/item/storage/surgical_case/regular,
		/obj/item/reagent_container/blood/OMinus,
		/obj/item/reagent_container/blood/OMinus,
	)
