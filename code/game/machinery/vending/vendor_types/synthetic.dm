//------------GEAR VENDOR---------------

/obj/structure/machinery/cm_vending/gear/synth
	name = "\improper ColMarTech Auxiliary Gear Rack"
	desc = "An automated gear rack hooked up to a colossal storage of various medical and engineering supplies. Can be accessed only by synthetic units."
	icon_state = "gear"
	req_access = list(ACCESS_MARINE_COMMANDER)
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
		list("Industrial Blowtorch", 4, /obj/item/tool/weldingtool/largetank, null, VENDOR_ITEM_RECOMMENDED),

		list("MEDICAL SUPPLIES", 0, null, null, null),
		list("Adv Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_REGULAR),
		list("Adv Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_REGULAR),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_REGULAR),
		list("Firstaid Kit", 6, /obj/item/storage/firstaid/regular, null, VENDOR_ITEM_REGULAR),
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

		list("OTHER SUPPLIES", 0, null, null, null),
		list("Data Detector", 5, /obj/item/device/motiondetector/intel, null, VENDOR_ITEM_REGULAR),
		list("Flashlight", 1, /obj/item/device/flashlight, null, VENDOR_ITEM_RECOMMENDED),
		list("Fulton Recovery Device", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 5, /obj/item/device/motiondetector, null, VENDOR_ITEM_REGULAR),
		list("Space Cleaner", 2, /obj/item/reagent_container/spray/cleaner, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
	)

//------------CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_synth, list(
		list("Headset", 0, /obj/item/device/radio/headset/almayer/mcom/cdrcom, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),

		list("UNIFORM (CHOOSE 1)", 0, null, null, null),
		list("Medical Scrubs, Green", 0, /obj/item/clothing/under/rank/medical/green, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Uniform, Outdated Synth", 0, /obj/item/clothing/under/rank/synthetic/old, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Uniform, Standard Synth", 0, /obj/item/clothing/under/rank/synthetic, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("USCM Standard Uniform", 0, /obj/item/clothing/under/marine, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Working Joe Uniform", 0, /obj/item/clothing/under/rank/synthetic/joe, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("WEBBING (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("SHOES (CHOOSE 1)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Shoes, White", 0, /obj/item/clothing/shoes/white, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_RECOMMENDED),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Expedition Cap", 0, /obj/item/clothing/head/cmflapcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Hard Hat, Orange", 0, /obj/item/clothing/head/hardhat/orange, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Surgical Cap, Green", 0, /obj/item/clothing/head/surgery/green, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Welding Helmet", 0, /obj/item/clothing/head/welding, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("SUIT (CHOOSE 1)", 0, null, null, null),
		list("Hazard Vest", 0, /obj/item/clothing/suit/storage/hazardvest, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
		list("Labcoat", 0, /obj/item/clothing/suit/storage/labcoat, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Labcoat, Researcher", 0, /obj/item/clothing/suit/storage/labcoat/researcher, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("GLOVES (CHOOSE 1)", 0, null, null, null),
		list("Insulated Gloves", 0, /obj/item/clothing/gloves/yellow, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_RECOMMENDED),
		list("Black Gloves", 0, /obj/item/clothing/gloves/black, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),
		list("Latex Gloves", 0, /obj/item/clothing/gloves/latex, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),

		list("BACKPACK (CHOOSE 1)", 0, null, null, null),
		list("Smartpack, Blue", 0, /obj/item/storage/backpack/marine/smartpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Smartpack, Green", 0, /obj/item/storage/backpack/marine/smartpack/green, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Smartpack, Tan", 0, /obj/item/storage/backpack/marine/smartpack/tan, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/sparepouch, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Lifesaver Bag", 0, /obj/item/storage/belt/medical/lifesaver/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Medical Storage Belt", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Construction Pouch", 0, /obj/item/storage/pouch/construction, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Document Pouch", 0, /obj/item/storage/pouch/document, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Electronics Pouch (Full)", 0, /obj/item/storage/pouch/electronics/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Firstaid Pouch (Full)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("MASK", 0, null, null, null),
		list("Sterile mask", 0, /obj/item/clothing/mask/surgical, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	))

/obj/structure/machinery/cm_vending/clothing/synth
	name = "\improper ColMarTech Synthetic Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of various equipment. Can be accessed only by synthetic units."
	req_access = list(ACCESS_MARINE_COMMANDER)
	vendor_role = list(JOB_SYNTH, JOB_SYNTH_SURVIVOR)

/obj/structure/machinery/cm_vending/clothing/synth/Initialize(mapload, ...)
	. = ..()
	listed_products = GLOB.cm_vending_clothing_synth

//------------SNOWFLAKE VENDOR---------------

/obj/structure/machinery/cm_vending/clothing/synth/snowflake
	name = "\improper Snowflake Vendor"
	desc = "A vendor with a large snowflake on it. Provided by W-Y Fashion Division(TM)."
	icon_state = "snowflake"
	use_points = TRUE
	show_points = TRUE
	use_snowflake_points = TRUE
	vendor_theme = VENDOR_THEME_COMPANY

	vend_delay = 10

/obj/structure/machinery/cm_vending/clothing/synth/snowflake
	req_access = list(ACCESS_MARINE_COMMANDER)
	vendor_role = list(JOB_SYNTH, JOB_SYNTH_SURVIVOR)

	listed_products = list(
		list("UNIFORM", 0, null, null, null),
		list("Bartender", 12, /obj/item/clothing/under/rank/bartender, null, VENDOR_ITEM_REGULAR),
		list("Black Skirt", 12, /obj/item/clothing/under/blackskirt, null, VENDOR_ITEM_REGULAR),
		list("Chaplain", 12, /obj/item/clothing/under/rank/chaplain, null, VENDOR_ITEM_REGULAR),
		list("Dispatcher's Uniform", 12, /obj/item/clothing/under/rank/dispatch, null, VENDOR_ITEM_REGULAR),
		list("Janitor's Jumpsuit", 12, /obj/item/clothing/under/rank/janitor, null, VENDOR_ITEM_REGULAR),
		list("Librarian", 12, /obj/item/clothing/under/librarian, null, VENDOR_ITEM_REGULAR),
		list("Medical Scrubs, Blue", 12, /obj/item/clothing/under/rank/medical/blue, null, VENDOR_ITEM_REGULAR),
		list("Medical Scrubs, Green", 12, /obj/item/clothing/under/rank/medical/green, null, VENDOR_ITEM_REGULAR),
		list("Medical Scrubs, Purple", 12, /obj/item/clothing/under/rank/medical/purple, null, VENDOR_ITEM_REGULAR),
		list("Medical Scrubs, White", 12, /obj/item/clothing/under/rank/medical, null, VENDOR_ITEM_REGULAR),
		list("Priest Robes", 12, /obj/item/clothing/under/rank/priest_robe, null, VENDOR_ITEM_REGULAR),
		list("Security Uniform, Black and Red", 12, /obj/item/clothing/under/rank/security/corp, null, VENDOR_ITEM_REGULAR),
		list("Security Uniform, Red and Black", 12, /obj/item/clothing/under/rank/security, null, VENDOR_ITEM_REGULAR),
		list("Security Uniform, White and Blue", 12, /obj/item/clothing/under/rank/security/navyblue, null, VENDOR_ITEM_REGULAR),
		list("Security Uniform, White and Red", 12, /obj/item/clothing/under/rank/security2, null, VENDOR_ITEM_REGULAR),
		list("Shaft Miner's Jumpsuit", 12, /obj/item/clothing/under/rank/miner, null, VENDOR_ITEM_REGULAR),
		list("USCM Service Uniform", 12, /obj/item/clothing/under/marine/officer/bridge, null, VENDOR_ITEM_REGULAR),
		list("Worker Overalls", 12, /obj/item/clothing/under/rank/worker_overalls, null, VENDOR_ITEM_REGULAR),

		list("GLASSES", 0, null, null, null),
		list("HealthMate HUD", 12, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_REGULAR),
		list("Marine RPG Glasses", 12, /obj/item/clothing/glasses/regular, null, VENDOR_ITEM_REGULAR),
		list("Optical Meson Scanner", 12, /obj/item/clothing/glasses/meson, null, VENDOR_ITEM_REGULAR),
		list("PatrolMate HUD", 12, /obj/item/clothing/glasses/hud/security, null, VENDOR_ITEM_REGULAR),
		list("Sunglasses", 12, /obj/item/clothing/glasses/sunglasses, null, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", 12, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),

		list("SHOES", 0, null, null, null),
		list("Boots", 12, /obj/item/clothing/shoes/marine, null, VENDOR_ITEM_REGULAR),
		list("Galoshes", 12, /obj/item/clothing/shoes/galoshes, null, VENDOR_ITEM_REGULAR),
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
		list("Beaver Hat", 12, /obj/item/clothing/head/beaverhat, null, VENDOR_ITEM_REGULAR),
		list("Beret, Engineering", 12, /obj/item/clothing/head/beret/eng, null, VENDOR_ITEM_REGULAR),
		list("Beret, Purple", 12, /obj/item/clothing/head/beret/jan, null, VENDOR_ITEM_REGULAR),
		list("Beret, Red", 12, /obj/item/clothing/head/beret/cm/red, null, VENDOR_ITEM_REGULAR),
		list("Beret, Standard", 12, /obj/item/clothing/head/beret/cm, null, VENDOR_ITEM_REGULAR),
		list("Beret, Tan", 12, /obj/item/clothing/head/beret/cm/tan, null, VENDOR_ITEM_REGULAR),
		list("Bowler Hat", 12, /obj/item/clothing/head/bowlerhat, null, VENDOR_ITEM_REGULAR),
		list("Cap", 12, /obj/item/clothing/head/cmcap, null, VENDOR_ITEM_REGULAR),
		list("Chef's Hat", 12, /obj/item/clothing/head/chefhat, null, VENDOR_ITEM_REGULAR),
		list("Corporate Security Cap", 12, /obj/item/clothing/head/soft/sec/corp, null, VENDOR_ITEM_REGULAR),
		list("Detective's Hat", 12, /obj/item/clothing/head/det_hat, null, VENDOR_ITEM_REGULAR),
		list("Fez", 12, /obj/item/clothing/head/fez, null, VENDOR_ITEM_REGULAR),
		list("Hard hat, Blue", 12, /obj/item/clothing/head/hardhat/dblue, null, VENDOR_ITEM_REGULAR),
		list("Hard hat, Orange", 12, /obj/item/clothing/head/hardhat/orange, null, VENDOR_ITEM_REGULAR),
		list("Hard hat, Red", 12, /obj/item/clothing/head/hardhat/red, null, VENDOR_ITEM_REGULAR),
		list("Surgical Cap, Blue", 12, /obj/item/clothing/head/surgery/blue, null, VENDOR_ITEM_REGULAR),
		list("Surgical Cap, Blue", 12, /obj/item/clothing/head/surgery/purple, null, VENDOR_ITEM_REGULAR),
		list("Surgical Cap, Green", 12, /obj/item/clothing/head/surgery/green, null, VENDOR_ITEM_REGULAR),
		list("Top hat", 12, /obj/item/clothing/head/that, null, VENDOR_ITEM_REGULAR),
		list("Ushanka", 12, /obj/item/clothing/head/ushanka, null, VENDOR_ITEM_REGULAR),

		list("SUIT", 0, null, null, null),
		list("Bomber Jacket", 12, /obj/item/clothing/suit/storage/bomber/open, null, VENDOR_ITEM_REGULAR),
		list("Chef's Apron", 12, /obj/item/clothing/suit/chef/classic, null, VENDOR_ITEM_REGULAR),
		list("Chef's Outfit", 12, /obj/item/clothing/suit/chef, null, VENDOR_ITEM_REGULAR),
		list("Coat, Black", 12, /obj/item/clothing/suit/storage/det_suit/black, null, VENDOR_ITEM_REGULAR),
		list("Coat, Brown", 12, /obj/item/clothing/suit/storage/det_suit, null, VENDOR_ITEM_REGULAR),
		list("Coveralls", 12, /obj/item/clothing/suit/storage/apron/overalls, null, VENDOR_ITEM_REGULAR),
		list("Hazard Vest", 12, /obj/item/clothing/suit/storage/hazardvest, null, VENDOR_ITEM_REGULAR),
		list("Jacket, Colonial Marshal", 12, /obj/item/clothing/suit/storage/CMB, null, VENDOR_ITEM_REGULAR),
		list("Overalls", 12, /obj/item/clothing/suit/storage/apron/overalls, null, VENDOR_ITEM_REGULAR),
		list("Snow Suit", 12, /obj/item/clothing/suit/storage/snow_suit, null, VENDOR_ITEM_REGULAR),
		list("USCM Service Jacket", 12, /obj/item/clothing/suit/storage/jacket/marine, null, VENDOR_ITEM_REGULAR),
		list("Waistcoat", 12, /obj/item/clothing/suit/storage/wcoat, null, VENDOR_ITEM_REGULAR),

		list("BACKPACK", 0, null, null, null),
		list("Backpack, Industrial", 12, /obj/item/storage/backpack/industrial, null, VENDOR_ITEM_REGULAR),
		list("Backpack, Medic", 12, /obj/item/storage/backpack/marine/medic, null, VENDOR_ITEM_REGULAR),
		list("Backpack, Standard", 12, /obj/item/storage/backpack/marine, null, VENDOR_ITEM_REGULAR),
		list("Backpack, Tech", 12, /obj/item/storage/backpack/marine/tech, null, VENDOR_ITEM_REGULAR),
		list("Satchel, Standard", 12, /obj/item/storage/backpack/marine/satchel, null, VENDOR_ITEM_REGULAR),
		list("Welderpack", 12, /obj/item/storage/backpack/marine/engineerpack, null, VENDOR_ITEM_REGULAR)
	)

//------------EXPERIMENTAL TOOLS---------------
/obj/structure/machinery/cm_vending/own_points/experimental_tools
	name = "\improper Experimental Vendor"
	desc = "A vendor with specially provisioned tools. They may or may not be tested."
	icon_state = "snowflake"
	vendor_theme = VENDOR_THEME_COMPANY
	req_access = list(ACCESS_MARINE_COMMANDER)
	vendor_role = list(JOB_SYNTH)

	listed_products = list(
		list("MEDICAL", 0, null, null, null),
		list("Compact Defibrillator", 15, /obj/item/device/defibrillator/compact, null, VENDOR_ITEM_REGULAR),

		list("ENGINEERING", 0, null, null, null),
		list("Refurbished Meson Scanner", 15, /obj/item/clothing/glasses/meson/refurbished, null, VENDOR_ITEM_REGULAR),

		list("CONSTRUCTION", 0, null, null, null),
		list("Breach B5", 15, /obj/item/weapon/melee/twohanded/breacher, null, VENDOR_ITEM_REGULAR),

		list("COMMAND", 0, null, null, null),
		list("Crew Monitor", 15, /obj/item/tool/crew_monitor, null, VENDOR_ITEM_REGULAR),
	)
