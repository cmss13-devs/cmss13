//------------GEAR VENDOR---------------

/obj/structure/machinery/cm_vending/gear/synth
	name = "\improper ColMarTech Synthetic Auxiliary Gear Rack"
	desc = "An automated gear rack hooked up to a colossal storage of various medical and engineering supplies. Can be accessed only by synthetic units."
	icon_state = "gear"
	req_access = list(ACCESS_MARINE_SYNTH)
	vendor_role = list(JOB_SYNTH, JOB_SYNTH_SURVIVOR)

	listed_products = list(
		list("ENGINEER SUPPLIES", 0, null, null, null),
		list("Airlock Circuit Board", 2, /obj/item/circuitboard/airlock, null, VENDOR_ITEM_REGULAR),
		list("APC Circuit Board", 2, /obj/item/circuitboard/apc, null, VENDOR_ITEM_REGULAR),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("High-Capacity Power Cell", 3, /obj/item/cell/high, null, VENDOR_ITEM_REGULAR),
		list("Light Replacer", 2, /obj/item/device/lightreplacer, null, VENDOR_ITEM_REGULAR),
		list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, VENDOR_ITEM_REGULAR),
		list("Multitool", 4, /obj/item/device/multitool, null, VENDOR_ITEM_REGULAR),
		list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, VENDOR_ITEM_REGULAR),
		list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_REGULAR),
		list("Industrial Blowtorch", 2, /obj/item/tool/weldingtool/largetank, null, VENDOR_ITEM_REGULAR),
		list("High-Capacity Industrial Blowtorch", 4, /obj/item/tool/weldingtool/hugetank, null, VENDOR_ITEM_REGULAR),
		list("Plastic Explosive", 3, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),

		list("FIRSTAID KITS", 0, null, null, null),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_REGULAR),
		list("Firstaid Kit", 5, /obj/item/storage/firstaid/regular, null, VENDOR_ITEM_REGULAR),
		list("Fire Firstaid Kit", 6, /obj/item/storage/firstaid/fire, null, VENDOR_ITEM_REGULAR),
		list("Toxin Firstaid Kit", 6, /obj/item/storage/firstaid/toxin, null, VENDOR_ITEM_REGULAR),
		list("Oxygen Firstaid Kit", 6, /obj/item/storage/firstaid/o2, null, VENDOR_ITEM_REGULAR),
		list("Radiation Firstaid Kit", 6, /obj/item/storage/firstaid/rad, null, VENDOR_ITEM_REGULAR),

		list("MEDICAL SUPPLIES", 0, null, null, null),
		list("Adv Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_REGULAR),
		list("Adv Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_REGULAR),
		list("Medevac Bed", 6, /obj/item/roller/medevac, null, VENDOR_ITEM_REGULAR),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_REGULAR),
		list("Roller Bed", 4, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Stasis Bag", 6, /obj/item/bodybag/cryobag, null, VENDOR_ITEM_REGULAR),

		list("Pillbottle (Bicaridine)", 5, /obj/item/storage/pill_bottle/bicaridine, null, VENDOR_ITEM_RECOMMENDED),
		list("Pillbottle (Dexalin)", 5, /obj/item/storage/pill_bottle/dexalin, null, VENDOR_ITEM_REGULAR),
		list("Pillbottle (Dylovene)", 5, /obj/item/storage/pill_bottle/antitox, null, VENDOR_ITEM_REGULAR),
		list("Pillbottle (Inaprovaline)", 5, /obj/item/storage/pill_bottle/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Pillbottle (Kelotane)", 5, /obj/item/storage/pill_bottle/kelotane, null, VENDOR_ITEM_RECOMMENDED),
		list("Pillbottle (Peridaxon)", 5, /obj/item/storage/pill_bottle/peridaxon, null, VENDOR_ITEM_REGULAR),
		list("Pillbottle (QuickClot)", 5, /obj/item/storage/pill_bottle/quickclot, null, VENDOR_ITEM_REGULAR),
		list("Pillbottle (Tramadol)", 5, /obj/item/storage/pill_bottle/tramadol, null, VENDOR_ITEM_RECOMMENDED),

		list("Injector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Injector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Injector (Epinephrine)", 2, /obj/item/reagent_container/hypospray/autoinjector/adrenaline, null, VENDOR_ITEM_REGULAR),
		list("Injector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Injector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Injector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Injector (QuickClot)", 1, /obj/item/reagent_container/hypospray/autoinjector/quickclot, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Injector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("Emergency Defibrillator", 4, /obj/item/device/defibrillator, null, VENDOR_ITEM_MANDATORY),
		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Surgical Line", 4, /obj/item/tool/surgery/surgical_line, null, VENDOR_ITEM_REGULAR),
		list("Synth-Graft", 4, /obj/item/tool/surgery/synthgraft, null, VENDOR_ITEM_REGULAR),

		list("OTHER SUPPLIES", 0, null, null, null),
		list("Binoculars", 5,/obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Rangefinder", 8, /obj/item/device/binoculars/range, null,  VENDOR_ITEM_REGULAR),
		list("Laser Designator", 12, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_RECOMMENDED),
		list("Data Detector", 5, /obj/item/device/motiondetector/intel, null, VENDOR_ITEM_REGULAR),
		list("Flashlight", 1, /obj/item/device/flashlight, null, VENDOR_ITEM_RECOMMENDED),
		list("Fulton Recovery Device", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 5, /obj/item/device/motiondetector, null, VENDOR_ITEM_REGULAR),
		list("Space Cleaner", 2, /obj/item/reagent_container/spray/cleaner, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
		list("Machete Scabbard (Full)", 2, /obj/item/storage/large_holster/machete/full, null, VENDOR_ITEM_REGULAR)

	)

//------------CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_synth, list(
		list("EXPERIMENTAL TOOL TOKEN (TAKE ALL)", 0, null, null, null),
		list("Experimental Tool Vendor Token", 0, /obj/item/coin/marine/synth, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("RADIO (TAKE ALL)", 0, null, null, null),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/mcom/cdrcom, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),

		list("UNIFORM (CHOOSE 1)", 0, null, null, null),
		list("Medical Scrubs, Green", 0, /obj/item/clothing/under/rank/medical/green, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Uniform, Outdated Synth", 0, /obj/item/clothing/under/rank/synthetic/old, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Uniform, Standard Synth", 0, /obj/item/clothing/under/rank/synthetic, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("USCM Standard Uniform", 0, /obj/item/clothing/under/marine, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("USCM Medical Uniform", 0, /obj/item/clothing/under/marine/medic, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Working Joe Uniform", 0, /obj/item/clothing/under/rank/synthetic/joe, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("WEBBING (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Surgical Webbing Vest", 0, /obj/item/clothing/accessory/storage/surg_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Surgical Webbing Vest (Blue)", 0, /obj/item/clothing/accessory/storage/surg_vest/blue, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Tool Webbing", 0, /obj/item/clothing/accessory/storage/black_vest/tool_webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("SHOES (CHOOSE 1)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Shoes, White", 0, /obj/item/clothing/shoes/white, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_RECOMMENDED),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Expedition Cap", 0, /obj/item/clothing/head/cmcap/flap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Hard Hat, Orange", 0, /obj/item/clothing/head/hardhat/orange, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Surgical Cap, Green", 0, /obj/item/clothing/head/surgery/green, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Welding Helmet", 0, /obj/item/clothing/head/welding, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("SUIT (CHOOSE 1)", 0, null, null, null),
		list("M3A1 Pattern Synthetic Utility Vest (UA Gray)", 0, /obj/item/clothing/suit/storage/marine/light/synvest/vanilla, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("M3A1 Pattern Synthetic Utility Vest (Mission-Specific Camo)", 0, /obj/item/clothing/suit/storage/marine/light/synvest, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("GLOVES (CHOOSE 1)", 0, null, null, null),
		list("Insulated Gloves", 0, /obj/item/clothing/gloves/yellow, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_RECOMMENDED),
		list("Black Gloves", 0, /obj/item/clothing/gloves/black, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),
		list("Latex Gloves", 0, /obj/item/clothing/gloves/latex, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),

		list("BACKPACK (CHOOSE 1)", 0, null, null, null),
		list("Smartpack, Blue", 0, /obj/item/storage/backpack/marine/smartpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Smartpack, Green", 0, /obj/item/storage/backpack/marine/smartpack/green, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Smartpack, Tan", 0, /obj/item/storage/backpack/marine/smartpack/tan, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Smartpack, White", 0, /obj/item/storage/backpack/marine/smartpack/white, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Smartpack, Black", 0, /obj/item/storage/backpack/marine/smartpack/black, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Logistics IMP Backpack", 0, /obj/item/storage/backpack/marine/satchel/big, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Lifesaver Bag", 0, /obj/item/storage/belt/medical/lifesaver/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Medical Storage Belt", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Construction Pouch", 0, /obj/item/storage/pouch/construction, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Document Pouch", 0, /obj/item/storage/pouch/document, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Electronics Pouch (Full)", 0, /obj/item/storage/pouch/electronics/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Empty Pressurized Reagent Pouch", 0, /obj/item/storage/pouch/pressurized_reagent_canister, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Machete Pouch (Full)", 0, /obj/item/storage/pouch/machete/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("MASK", 0, null, null, null),
		list("Sterile mask", 0, /obj/item/clothing/mask/surgical, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	))

/obj/structure/machinery/cm_vending/clothing/synth
	name = "\improper ColMarTech Synthetic Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of various equipment. Can be accessed only by synthetic units."
	req_access = list(ACCESS_MARINE_SYNTH)
	vendor_role = list(JOB_SYNTH, JOB_SYNTH_SURVIVOR)

/obj/structure/machinery/cm_vending/clothing/synth/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_synth

//------------SNOWFLAKE VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_synth_snowflake, list(
	list("UNIFORM", 0, null, null, null),
	list("Medical Scrubs, Blue", 12, /obj/item/clothing/under/rank/medical/blue, null, VENDOR_ITEM_REGULAR),
	list("Medical Scrubs, Green", 12, /obj/item/clothing/under/rank/medical/green, null, VENDOR_ITEM_REGULAR),
	list("Medical Scrubs, Purple", 12, /obj/item/clothing/under/rank/medical/purple, null, VENDOR_ITEM_REGULAR),
	list("Medical Scrubs, White", 12, /obj/item/clothing/under/rank/medical, null, VENDOR_ITEM_REGULAR),
	list("USCM Service Uniform", 12, /obj/item/clothing/under/marine/officer/bridge, null, VENDOR_ITEM_REGULAR),
	list("Engineer Uniform", 12, /obj/item/clothing/under/marine/officer/engi, null, VENDOR_ITEM_REGULAR),
	list("White T-Shirt and Brown Jeans", 12, /obj/item/clothing/under/tshirt/w_br, null, VENDOR_ITEM_REGULAR),
	list("Gray T-Shirt and Blue Jeans", 12, /obj/item/clothing/under/tshirt/gray_blu, null, VENDOR_ITEM_REGULAR),
	list("Red T-Shirt and Black Jeans", 12, /obj/item/clothing/under/tshirt/r_bla, null, VENDOR_ITEM_REGULAR),
	list("Gray Utilities", 12, /obj/item/clothing/under/colonist/ua_civvies, null, VENDOR_ITEM_REGULAR),
	list("Brown Utilities", 12, /obj/item/clothing/under/colonist/wy_davisone, null, VENDOR_ITEM_REGULAR),
	list("Steward Utilities", 12, /obj/item/clothing/under/colonist/wy_joliet_shopsteward, null, VENDOR_ITEM_REGULAR),

	list("GLASSES", 0, null, null, null),
	list("HealthMate HUD", 12, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_REGULAR),
	list("Marine RPG Glasses", 12, /obj/item/clothing/glasses/regular, null, VENDOR_ITEM_REGULAR),
	list("Optical Meson Scanner", 12, /obj/item/clothing/glasses/meson, null, VENDOR_ITEM_REGULAR),
	list("PatrolMate HUD", 12, /obj/item/clothing/glasses/hud/security, null, VENDOR_ITEM_REGULAR),
	list("Sunglasses", 12, /obj/item/clothing/glasses/sunglasses, null, VENDOR_ITEM_REGULAR),
	list("Welding Goggles", 12, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),

	list("SHOES", 0, null, null, null),
	list("Boots", 12, /obj/item/clothing/shoes/marine, null, VENDOR_ITEM_REGULAR),
	list("Shoes, Black", 12, /obj/item/clothing/shoes/black, null, VENDOR_ITEM_REGULAR),
	list("Shoes, Blue", 12, /obj/item/clothing/shoes/blue, null, VENDOR_ITEM_REGULAR),
	list("Shoes, Brown", 12, /obj/item/clothing/shoes/brown, null, VENDOR_ITEM_REGULAR),
	list("Shoes, Green", 12, /obj/item/clothing/shoes/green, null, VENDOR_ITEM_REGULAR),
	list("Shoes, Purple", 12, /obj/item/clothing/shoes/purple, null, VENDOR_ITEM_REGULAR),
	list("Shoes, Red", 12, /obj/item/clothing/shoes/red, null, VENDOR_ITEM_REGULAR),
	list("Shoes, White", 12, /obj/item/clothing/shoes/white, null, VENDOR_ITEM_REGULAR),
	list("Shoes, Yellow", 12, /obj/item/clothing/shoes/yellow, null, VENDOR_ITEM_REGULAR),

	list("HELMET", 0, null, null, null),
	list("Beanie", 12, /obj/item/clothing/head/beanie, null, VENDOR_ITEM_REGULAR),
	list("Beret, Engineering", 12, /obj/item/clothing/head/beret/eng, null, VENDOR_ITEM_REGULAR),
	list("Beret, Purple", 12, /obj/item/clothing/head/beret/jan, null, VENDOR_ITEM_REGULAR),
	list("Beret, Red", 12, /obj/item/clothing/head/beret/cm/red, null, VENDOR_ITEM_REGULAR),
	list("Beret, Standard", 12, /obj/item/clothing/head/beret/cm, null, VENDOR_ITEM_REGULAR),
	list("Beret, Tan", 12, /obj/item/clothing/head/beret/cm/tan, null, VENDOR_ITEM_REGULAR),
	list("Cap", 12, /obj/item/clothing/head/cmcap, null, VENDOR_ITEM_REGULAR),
	list("Surgical Cap, Blue", 12, /obj/item/clothing/head/surgery/blue, null, VENDOR_ITEM_REGULAR),
	list("Surgical Cap, Blue", 12, /obj/item/clothing/head/surgery/purple, null, VENDOR_ITEM_REGULAR),
	list("Surgical Cap, Green", 12, /obj/item/clothing/head/surgery/green, null, VENDOR_ITEM_REGULAR),
	list("Ushanka", 12, /obj/item/clothing/head/ushanka, null, VENDOR_ITEM_REGULAR),
	list("MP Cap", 12, /obj/item/clothing/head/helmet/beret/marine/mp/mpcap, null, VENDOR_ITEM_REGULAR),
	list("RO Cap", 12, /obj/item/clothing/head/cmcap/req, null, VENDOR_ITEM_REGULAR),
	list("Officer Cap", 12, /obj/item/clothing/head/cmcap/ro, null, VENDOR_ITEM_REGULAR),

	list("SUIT", 0, null, null, null),
	list("Brown Bomber Jacket", 12, /obj/item/clothing/suit/storage/bomber, null, VENDOR_ITEM_REGULAR),
	list("Black Bomber Jacket", 12, /obj/item/clothing/suit/storage/bomber/alt, null, VENDOR_ITEM_REGULAR),
	list("External webbing", 12, /obj/item/clothing/suit/storage/webbing, null, VENDOR_ITEM_REGULAR),
	list("Orange Hazard Vest", 12, /obj/item/clothing/suit/storage/hazardvest, null, VENDOR_ITEM_REGULAR),
	list("Blue Hazard Vest", 12, /obj/item/clothing/suit/storage/hazardvest/blue, null, VENDOR_ITEM_REGULAR),
	list("Yellow Hazard Vest", 12, /obj/item/clothing/suit/storage/hazardvest/yellow, null, VENDOR_ITEM_REGULAR),
	list("Black Hazard Vest", 12, /obj/item/clothing/suit/storage/hazardvest/black, null, VENDOR_ITEM_REGULAR),
	list("Synthetic's Snow Suit", 12, /obj/item/clothing/suit/storage/snow_suit/synth, null, VENDOR_ITEM_REGULAR),
	list("USCM Service Jacket", 12, /obj/item/clothing/suit/storage/jacket/marine/service, null, VENDOR_ITEM_REGULAR),
	list("USCM MP Service Jacket", 12, /obj/item/clothing/suit/storage/jacket/marine/service/mp, null, VENDOR_ITEM_REGULAR),
	list("Brown Windbreaker", 12, /obj/item/clothing/suit/storage/windbreaker/windbreaker_brown, null, VENDOR_ITEM_REGULAR),
	list("Gray Windbreaker", 12, /obj/item/clothing/suit/storage/windbreaker/windbreaker_gray, null, VENDOR_ITEM_REGULAR),
	list("Green Windbreaker", 12, /obj/item/clothing/suit/storage/windbreaker/windbreaker_green, null, VENDOR_ITEM_REGULAR),
	list("First Responder Windbreaker", 12, /obj/item/clothing/suit/storage/windbreaker/windbreaker_fr, null, VENDOR_ITEM_REGULAR),
	list("Exploration Windbreaker", 12, /obj/item/clothing/suit/storage/windbreaker/windbreaker_covenant, null, VENDOR_ITEM_REGULAR),
	list("Labcoat", 12, /obj/item/clothing/suit/storage/labcoat, null, VENDOR_ITEM_REGULAR),
	list("Labcoat, Researcher", 12, /obj/item/clothing/suit/storage/labcoat/researcher, null, VENDOR_ITEM_REGULAR),
	list("RO Jacket", 12, /obj/item/clothing/suit/storage/RO, null, VENDOR_ITEM_REGULAR),

	list("BACKPACK", 0, null, null, null),
	list("Backpack, Industrial", 12, /obj/item/storage/backpack/industrial, null, VENDOR_ITEM_REGULAR),
	list("Backpack, Medic", 12, /obj/item/storage/backpack/marine/medic, null, VENDOR_ITEM_REGULAR),
	list("Backpack, Standard", 12, /obj/item/storage/backpack/marine, null, VENDOR_ITEM_REGULAR),
	list("Backpack, Tech", 12, /obj/item/storage/backpack/marine/tech, null, VENDOR_ITEM_REGULAR),
	list("Satchel, Standard", 12, /obj/item/storage/backpack/marine/satchel, null, VENDOR_ITEM_REGULAR),
	list("Welderpack", 12, /obj/item/storage/backpack/marine/engineerpack, null, VENDOR_ITEM_REGULAR),
	list("Small Radio Telephone Backpack", 12, /obj/item/storage/backpack/marine/satchel/rto/small,null, VENDOR_ITEM_REGULAR),
))

/obj/structure/machinery/cm_vending/clothing/synth/snowflake
	name = "\improper W-Y Synthetic Conformity Unit"
	desc = "A vendor with a large snowflake on it. Provided by Wey-Yu Fashion Division(TM)."
	icon_state = "snowflake"
	use_points = TRUE
	show_points = TRUE
	use_snowflake_points = TRUE
	vendor_theme = VENDOR_THEME_COMPANY
	req_access = list(ACCESS_MARINE_SYNTH)
	vendor_role = list(JOB_SYNTH, JOB_SYNTH_SURVIVOR)

	vend_delay = 10

/obj/structure/machinery/cm_vending/clothing/synth/snowflake/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_synth_snowflake


//------------EXPERIMENTAL TOOLS---------------
/obj/structure/machinery/cm_vending/own_points/experimental_tools
	name = "\improper W-Y Experimental Tools Vendor"
	desc = "A smaller vendor hooked up to a cache of specially provisioned, experimental tools and equipment provided by the Wey-Yu Research and Development Division(TM). Handle with care."
	icon_state = "robotics"
	available_points = 0
	available_points_to_display = 0
	vendor_theme = VENDOR_THEME_COMPANY
	req_access = list(ACCESS_MARINE_SYNTH)
	vendor_role = list(JOB_SYNTH)

/obj/structure/machinery/cm_vending/own_points/experimental_tools/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/coin/marine/synth))
		if(user.drop_inv_item_to_loc(W, src))
			available_points = available_points + 45
			available_points_to_display = available_points
			to_chat(user, SPAN_NOTICE("You insert \the [W] into \the [src]."))
			return
	return ..()

/obj/structure/machinery/cm_vending/own_points/experimental_tools
	listed_products = list(
		list("Autocompressor", 15, /obj/item/clothing/suit/auto_cpr, null, VENDOR_ITEM_REGULAR),
		list("Backpack Firefighting Watertank", 15, /obj/item/reagent_container/glass/watertank/atmos, null, VENDOR_ITEM_REGULAR),
		list("Breaching Hammer", 15, /obj/item/weapon/melee/twohanded/breacher, null, VENDOR_ITEM_REGULAR),
		list("Compact Defibrillator", 15, /obj/item/device/defibrillator/compact, null, VENDOR_ITEM_REGULAR),
		list("Compact Nailgun kit", 15, /obj/effect/essentials_set/cnailgun, null, VENDOR_ITEM_REGULAR),
		list("Crew Monitor", 15, /obj/item/tool/crew_monitor, null, VENDOR_ITEM_REGULAR),
		list("Experimental Meson Goggles", 15, /obj/item/clothing/glasses/night/experimental_mesons, null, VENDOR_ITEM_REGULAR),
		list("Portable Dialysis Machine", 15, /obj/item/tool/portadialysis, null, VENDOR_ITEM_REGULAR),
		list("Telescopic Baton", 15, /obj/item/weapon/melee/telebaton, null, VENDOR_ITEM_REGULAR),
	)

//------------EXPERIMENTAL TOOL KITS---------------
/obj/effect/essentials_set/cnailgun
	spawned_gear_list = list(
		/obj/item/weapon/gun/smg/nailgun/compact,
		/obj/item/ammo_magazine/smg/nailgun,
		/obj/item/ammo_magazine/smg/nailgun,
	)
