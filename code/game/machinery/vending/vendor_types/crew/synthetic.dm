//------------GEAR VENDOR---------------

/obj/structure/machinery/cm_vending/gear/synth
	name = "\improper ColMarTech Synthetic Auxiliary Gear Rack"
	desc = "An automated gear rack hooked up to a colossal storage of various medical and engineering supplies. Can be accessed only by synthetic units."
	icon_state = "gear"
	req_access = list(ACCESS_MARINE_SYNTH)
	vendor_role = list(JOB_SYNTH, JOB_SYNTH_SURVIVOR, JOB_UPP_SUPPORT_SYNTH, JOB_CMB_SYN, JOB_CMB_RSYN, JOB_PMC_SYNTH)

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
		list("Plastic Explosive", 3, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("ES-11 Mobile Fuel Canister", 4, /obj/item/tool/weldpack/minitank, null, VENDOR_ITEM_REGULAR),
		list("Engineer Kit", 1, /obj/item/storage/toolkit/empty, null, VENDOR_ITEM_REGULAR),
		list("Tactical Prybar", 5, /obj/item/tool/crowbar/tactical, null, VENDOR_ITEM_REGULAR),

		list("FIRSTAID KITS", 0, null, null, null),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_REGULAR),
		list("Firstaid Kit", 5, /obj/item/storage/firstaid/regular, null, VENDOR_ITEM_REGULAR),
		list("Fire Firstaid Kit", 6, /obj/item/storage/firstaid/fire, null, VENDOR_ITEM_REGULAR),
		list("Toxin Firstaid Kit", 6, /obj/item/storage/firstaid/toxin, null, VENDOR_ITEM_REGULAR),
		list("Oxygen Firstaid Kit", 6, /obj/item/storage/firstaid/o2, null, VENDOR_ITEM_REGULAR),
		list("Radiation Firstaid Kit", 6, /obj/item/storage/firstaid/rad, null, VENDOR_ITEM_REGULAR),

		list("MEDICAL SUPPLIES", 0, null, null, null),
		list("Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_REGULAR),
		list("Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_REGULAR),
		list("Medevac Bed", 6, /obj/item/roller/medevac, null, VENDOR_ITEM_REGULAR),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_REGULAR),
		list("Roller Bed", 4, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Stasis Bag", 6, /obj/item/bodybag/cryobag, null, VENDOR_ITEM_REGULAR),
		list("MS-11 Smart Refill Tank", 6, /obj/item/reagent_container/glass/minitank, null, VENDOR_ITEM_REGULAR),
		list("Blood", 5, /obj/item/reagent_container/blood/OMinus, null, VENDOR_ITEM_REGULAR),
		list("Surgical Bed", 10, /obj/structure/bed/portable_surgery, null, VENDOR_ITEM_REGULAR),

		list("Pill Bottle (Bicaridine)", 5, /obj/item/storage/pill_bottle/bicaridine, null, VENDOR_ITEM_RECOMMENDED),
		list("Pill Bottle (Dexalin)", 5, /obj/item/storage/pill_bottle/dexalin, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Dylovene)", 5, /obj/item/storage/pill_bottle/antitox, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Inaprovaline)", 5, /obj/item/storage/pill_bottle/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Kelotane)", 5, /obj/item/storage/pill_bottle/kelotane, null, VENDOR_ITEM_RECOMMENDED),
		list("Pill Bottle (Peridaxon)", 5, /obj/item/storage/pill_bottle/peridaxon, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Tramadol)", 5, /obj/item/storage/pill_bottle/tramadol, null, VENDOR_ITEM_RECOMMENDED),

		list("Autoinjector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Dylovene)", 1, /obj/item/reagent_container/hypospray/autoinjector/antitoxin, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Epinephrine)", 2, /obj/item/reagent_container/hypospray/autoinjector/adrenaline, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Oxycodone)", 1, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Peridaxon)", 1, /obj/item/reagent_container/hypospray/autoinjector/peridaxon, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tricordrazine)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("15u Custom Autoinjector (EMPTY)", 1, /obj/item/reagent_container/hypospray/autoinjector/empty/small, null, VENDOR_ITEM_REGULAR),
		list("30u Custom Autoinjector (EMPTY)", 2, /obj/item/reagent_container/hypospray/autoinjector/empty/medium, null, VENDOR_ITEM_REGULAR),
		list("60u Custom Autoinjector (EMPTY)", 4, /obj/item/reagent_container/hypospray/autoinjector/empty/large, null, VENDOR_ITEM_REGULAR),

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
		list("Whistle", 5, /obj/item/clothing/accessory/device/whistle, null, VENDOR_ITEM_REGULAR),
		list("Machete Scabbard (Full)", 2, /obj/item/storage/large_holster/machete/full, null, VENDOR_ITEM_REGULAR),
		list("Stethoscope", 2, /obj/item/clothing/accessory/stethoscope, null, VENDOR_ITEM_REGULAR),
		list("Penlight", 2, /obj/item/device/flashlight/pen, null, VENDOR_ITEM_REGULAR)
	)

//------------CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_synth, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Experimental Tool Vendor Token", 0, /obj/item/coin/marine/synth, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),
		list("Synthetic Reset Key", 0, /obj/item/device/defibrillator/synthetic, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/mcom/synth, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),

		list("UNIFORM (CHOOSE 1)", 0, null, null, null),
		list("USCM Standard Uniform", 0, /obj/item/clothing/under/marine, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("WEBBING (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Leg Pouch", 0, /obj/item/clothing/accessory/storage/black_vest/leg_pouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Leg Pouch (Black)", 0, /obj/item/clothing/accessory/storage/black_vest/black_leg_pouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Webbing", 0, /obj/item/clothing/accessory/storage/webbing/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("SHOES (CHOOSE 1)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Brown Boots", 0, /obj/item/clothing/shoes/marine/brown/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Grey Boots", 0, /obj/item/clothing/shoes/marine/grey/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Jungle Boots", 0, /obj/item/clothing/shoes/marine/jungle/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("Shoes, White", 0, /obj/item/clothing/shoes/white, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_RECOMMENDED),

		list("SUIT (CHOOSE 1)", 0, null, null, null),
		list("M3A1 Pattern Synthetic Utility Vest (Mission-Specific Camo)", 0, /obj/item/clothing/suit/storage/marine/light/synvest, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
		list("M3A1 Pattern Synthetic Utility Vest (UA Gray)", 0, /obj/item/clothing/suit/storage/marine/light/synvest/grey, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("M3A1 Pattern Synthetic Utility Vest (UA Dark Grey)", 0, /obj/item/clothing/suit/storage/marine/light/synvest/dgrey, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("M3A1 Pattern Synthetic Utility Vest (UA Jungle)", 0, /obj/item/clothing/suit/storage/marine/light/synvest/jungle, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("M3A1 Pattern Synthetic Utility Vest (UA Snow)", 0, /obj/item/clothing/suit/storage/marine/light/synvest/snow, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("M3A1 Pattern Synthetic Utility Vest (UA Desert)", 0, /obj/item/clothing/suit/storage/marine/light/synvest/desert, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("GLOVES (CHOOSE 1)", 0, null, null, null),
		list("Marine Insulated Gloves", 0, /obj/item/clothing/gloves/marine/insulated, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_RECOMMENDED),
		list("Marine Insulated Black Gloves", 0, /obj/item/clothing/gloves/marine/insulated/black, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_RECOMMENDED),
		list("Marine Black Combat Gloves", 0, /obj/item/clothing/gloves/marine/black, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),
		list("Marine Brown Combat Gloves", 0, /obj/item/clothing/gloves/marine/brown, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),
		list("Marine Grey Combat Gloves", 0, /obj/item/clothing/gloves/marine/grey, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),
		list("Marine Fingerless Combat Gloves", 0, /obj/item/clothing/gloves/marine/fingerless, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),
		list("Latex Gloves", 0, /obj/item/clothing/gloves/latex, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),

		list("BACKPACK (CHOOSE 1)", 0, null, null, null),
		list("S-V42 Smartpack, Blue", 0, /obj/item/storage/backpack/marine/smartpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("S-V42 Smartpack, Green", 0, /obj/item/storage/backpack/marine/smartpack/green, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("S-V42 Smartpack, Tan", 0, /obj/item/storage/backpack/marine/smartpack/tan, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("S-V42 Smartpack, White", 0, /obj/item/storage/backpack/marine/smartpack/white, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("S-V42 Smartpack, Black", 0, /obj/item/storage/backpack/marine/smartpack/black, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("S-V42A1 Smartpack, Blue", 0, /obj/item/storage/backpack/marine/smartpack/a1, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("S-V42A1 Smartpack, Green", 0, /obj/item/storage/backpack/marine/smartpack/a1/green, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("S-V42A1 Smartpack, Tan", 0, /obj/item/storage/backpack/marine/smartpack/a1/tan, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("S-V42A1 Smartpack, Black", 0, /obj/item/storage/backpack/marine/smartpack/a1/black, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("S-V42A1 Smartpack, White", 0, /obj/item/storage/backpack/marine/smartpack/a1/white, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Lifesaver Bag", 0, /obj/item/storage/belt/medical/lifesaver/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Medical Storage Belt", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M277 Pattern Construction Rig", 0, /obj/item/storage/belt/utility/construction, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Construction Pouch", 0, /obj/item/storage/pouch/construction, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Document Pouch", 0, /obj/item/storage/pouch/document, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Electronics Pouch (Full)", 0, /obj/item/storage/pouch/electronics/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Autoinjectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Bicaridine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Kelotane)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_tricord, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Peridaxon)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_peri, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Field Anesthetic)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/oxycodone, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (EMPTY)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Machete Pouch (Full)", 0, /obj/item/storage/pouch/machete/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK", 0, null, null, null),
		list("Sterile mask", 0, /obj/item/clothing/mask/surgical, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	))

/obj/structure/machinery/cm_vending/clothing/synth
	name = "\improper ColMarTech Synthetic Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of various equipment. Can be accessed only by synthetic units."
	req_access = list(ACCESS_MARINE_SYNTH)
	vendor_role = list(JOB_SYNTH, JOB_SYNTH_SURVIVOR, JOB_UPP_SUPPORT_SYNTH, JOB_CMB_SYN, JOB_CMB_RSYN, JOB_PMC_SYNTH, JOB_TWE_IASF_PARA_SYNTH, JOB_WY_GOON_SYNTH)

/obj/structure/machinery/cm_vending/clothing/synth/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_synth

//------------SNOWFLAKE VENDOR---------------

/datum/gear/synthetic
	category = "Other"
	allowed_roles = list(JOB_SYNTH)

	fluff_cost = 0
	loadout_cost = 12

/datum/gear/synthetic/uscm
	category = "USCM Uniforms"

/datum/gear/synthetic/uscm/medical_blue
	path = /obj/item/clothing/under/rank/medical/blue

/datum/gear/synthetic/uscm/medical_lightblue
	path = /obj/item/clothing/under/rank/medical/lightblue

/datum/gear/synthetic/uscm/medical_green
	path = /obj/item/clothing/under/rank/medical/green

/datum/gear/synthetic/uscm/medical_purple
	path = /obj/item/clothing/under/rank/medical/purple

/datum/gear/synthetic/uscm/medical_olive
	path = /obj/item/clothing/under/rank/medical/olive

/datum/gear/synthetic/uscm/medical_grey
	path = /obj/item/clothing/under/rank/medical/grey

/datum/gear/synthetic/uscm/medical_white
	path = /obj/item/clothing/under/rank/medical/white

/datum/gear/synthetic/uscm/medical_black
	path = /obj/item/clothing/under/rank/medical/morgue

/datum/gear/synthetic/uscm/medical_pharmacist
	path = /obj/item/clothing/under/rank/medical/pharmacist

/datum/gear/synthetic/uscm/standard_synth
	path = /obj/item/clothing/under/rank/synthetic

/datum/gear/synthetic/uscm/standard_synth_old
	path = /obj/item/clothing/under/rank/synthetic/old

/datum/gear/synthetic/uscm/marine_jungle
	path = /obj/item/clothing/under/marine/jungle

/datum/gear/synthetic/uscm/marine_desert
	path = /obj/item/clothing/under/marine/desert

/datum/gear/synthetic/uscm/marine_classic
	path = /obj/item/clothing/under/marine/classic

/datum/gear/synthetic/uscm/marine_snow
	path = /obj/item/clothing/under/marine/snow

/datum/gear/synthetic/uscm/marine_urban
	path = /obj/item/clothing/under/marine/urban

/datum/gear/synthetic/uscm/service_tan
	path = /obj/item/clothing/under/marine/officer/bridge

/datum/gear/synthetic/uscm/service_white
	path = /obj/item/clothing/under/marine/dress

/datum/gear/synthetic/uscm/engineer_jungle
	path = /obj/item/clothing/under/marine/engineer/jungle

/datum/gear/synthetic/uscm/engineer_desert
	path = /obj/item/clothing/under/marine/engineer/desert

/datum/gear/synthetic/uscm/engineer_classic
	path = /obj/item/clothing/under/marine/engineer/classic

/datum/gear/synthetic/uscm/engineer_snow
	path = /obj/item/clothing/under/marine/engineer/snow

/datum/gear/synthetic/uscm/engineer_urban
	path = /obj/item/clothing/under/marine/engineer/urban

/datum/gear/synthetic/uscm/engineer_officer
	path = /obj/item/clothing/under/marine/officer/engi

/datum/gear/synthetic/uscm/engineer_OT
	path = /obj/item/clothing/under/marine/officer/engi/OT

/datum/gear/synthetic/uscm/corpsman_jungle
	path = /obj/item/clothing/under/marine/medic/jungle

/datum/gear/synthetic/uscm/corpsman_desert
	path = /obj/item/clothing/under/marine/medic/desert

/datum/gear/synthetic/uscm/corpsman_classic
	path = /obj/item/clothing/under/marine/medic/classic

/datum/gear/synthetic/uscm/corpsman_snow
	path = /obj/item/clothing/under/marine/medic/snow

/datum/gear/synthetic/uscm/corpsman_urban
	path = /obj/item/clothing/under/marine/medic/urban

/datum/gear/synthetic/uscm/mp_jungle
	path = /obj/item/clothing/under/marine/mp/jungle

/datum/gear/synthetic/uscm/mp_desert
	path = /obj/item/clothing/under/marine/mp/desert

/datum/gear/synthetic/uscm/mp_classic
	path = /obj/item/clothing/under/marine/mp/classic

/datum/gear/synthetic/uscm/mp_snow
	path = /obj/item/clothing/under/marine/mp/snow

/datum/gear/synthetic/uscm/mp_urban
	path = /obj/item/clothing/under/marine/mp/urban

/datum/gear/synthetic/uscm/operations_uniform_jungle
	path = /obj/item/clothing/under/marine/officer/boiler/jungle

/datum/gear/synthetic/uscm/operations_uniform_desert
	path = /obj/item/clothing/under/marine/officer/boiler/desert

/datum/gear/synthetic/uscm/operations_uniform_classic
	path = /obj/item/clothing/under/marine/officer/boiler/classic

/datum/gear/synthetic/uscm/operations_uniform_snow
	path = /obj/item/clothing/under/marine/officer/boiler/snow

/datum/gear/synthetic/uscm/operations_uniform_urban
	path = /obj/item/clothing/under/marine/officer/boiler/urban

/datum/gear/synthetic/civilian
	category = "Civilian Uniforms"

/datum/gear/synthetic/civilian/white_tshirt_brown_jeans
	path = /obj/item/clothing/under/tshirt/w_br

/datum/gear/synthetic/civilian/gray_tshirt_blue_jeans
	path = /obj/item/clothing/under/tshirt/gray_blu

/datum/gear/synthetic/civilian/red_tshirt_black_jeans
	path = /obj/item/clothing/under/tshirt/r_bla

/datum/gear/synthetic/civilian/frontier
	path = /obj/item/clothing/under/rank/frontier

/datum/gear/synthetic/civilian/grey_jumpsuit
	path = /obj/item/clothing/under/rank/utility/gray

/datum/gear/synthetic/civilian/brown_jumpsuit
	path = /obj/item/clothing/under/rank/utility/brown

/datum/gear/synthetic/civilian/green_utility
	path = /obj/item/clothing/under/rank/utility

/datum/gear/synthetic/civilian/grey_utility
	path = /obj/item/clothing/under/rank/utility/yellow

/datum/gear/synthetic/civilian/grey_utility_blue_jeans
	path = /obj/item/clothing/under/rank/utility/red

/datum/gear/synthetic/civilian/blue_utility_brown_jeans
	path = /obj/item/clothing/under/rank/utility/blue

/datum/gear/synthetic/civilian/white_service
	path = /obj/item/clothing/under/colonist/white_service

/datum/gear/synthetic/civilian/steward
	path = /obj/item/clothing/under/colonist/steward

/datum/gear/synthetic/civilian/blue_suit_pants
	path = /obj/item/clothing/under/liaison_suit/blue

/datum/gear/synthetic/civilian/brown_suit_pants
	path = /obj/item/clothing/under/liaison_suit/brown

/datum/gear/synthetic/civilian/white_suit_pants
	path = /obj/item/clothing/under/liaison_suit/corporate_formal

/datum/gear/synthetic/civilian/grey_suit_pants
	path = /obj/item/clothing/under/detective/grey

/datum/gear/synthetic/civilian/alt_brown_suit_pants
	path = /obj/item/clothing/under/detective/neutral

/datum/gear/synthetic/glasses
	category = "Glasses"

/datum/gear/synthetic/glasses/marine_rpg
	path = /obj/item/clothing/glasses/regular

/datum/gear/synthetic/glasses/reagent_scanner
	path = /obj/item/clothing/glasses/science


/datum/gear/synthetic/glasses/security_hud
	path = /obj/item/clothing/glasses/sunglasses/sechud

/datum/gear/synthetic/glasses/sunglasses
	path = /obj/item/clothing/glasses/sunglasses

/datum/gear/synthetic/glasses/sunglasses_aviator_tan
	path = /obj/item/clothing/glasses/sunglasses/aviator

/datum/gear/synthetic/glasses/sunglasses_aviator_silver
	path = /obj/item/clothing/glasses/sunglasses/aviator/silver

/datum/gear/synthetic/glasses/bimex
	path = /obj/item/clothing/glasses/sunglasses/big

/datum/gear/synthetic/glasses/bimex_new
	path = /obj/item/clothing/glasses/sunglasses/big/new_bimex

/datum/gear/synthetic/glasses/bimex_new_black
	path = /obj/item/clothing/glasses/sunglasses/big/new_bimex/black

/datum/gear/synthetic/glasses/bimex_new_bronze
	path = /obj/item/clothing/glasses/sunglasses/big/new_bimex/bronze

/datum/gear/synthetic/glasses/fake_bimex_red
	path = /obj/item/clothing/glasses/sunglasses/big/fake/red

/datum/gear/synthetic/glasses/fake_bimex_orange
	path = /obj/item/clothing/glasses/sunglasses/big/fake/orange

/datum/gear/synthetic/glasses/fake_bimex_yellow
	path = /obj/item/clothing/glasses/sunglasses/big/fake/yellow

/datum/gear/synthetic/glasses/fake_bimex_green
	path = /obj/item/clothing/glasses/sunglasses/big/fake/green

/datum/gear/synthetic/glasses/fake_bimex_blue
	path = /obj/item/clothing/glasses/sunglasses/big/fake/blue


/datum/gear/synthetic/shoes
	category = "Shoes"

/datum/gear/synthetic/shoes/marine_black
	path = /obj/item/clothing/shoes/marine

/datum/gear/synthetic/shoes/marine_brown
	path = /obj/item/clothing/shoes/marine/brown

/datum/gear/synthetic/shoes/marine_grey
	path = /obj/item/clothing/shoes/marine/grey

/datum/gear/synthetic/shoes/marine_jungle
	path = /obj/item/clothing/shoes/marine/jungle

/datum/gear/synthetic/shoes/blue
	path = /obj/item/clothing/shoes/black

/datum/gear/synthetic/shoes/brown
	path = /obj/item/clothing/shoes/brown

/datum/gear/synthetic/shoes/green
	path = /obj/item/clothing/shoes/green

/datum/gear/synthetic/shoes/purple
	path = /obj/item/clothing/shoes/purple

/datum/gear/synthetic/shoes/red
	path = /obj/item/clothing/shoes/red

/datum/gear/synthetic/shoes/white
	path = /obj/item/clothing/shoes/white

/datum/gear/synthetic/shoes/yellow
	path = /obj/item/clothing/shoes/yellow

/datum/gear/synthetic/gloves
	category = "Gloves"

/datum/gear/synthetic/gloves/insulated
	path = /obj/item/clothing/gloves/marine/insulated

/datum/gear/synthetic/gloves/insulated/black
	path = /obj/item/clothing/gloves/marine/insulated/black

/datum/gear/synthetic/gloves/black
	path = /obj/item/clothing/gloves/marine/black

/datum/gear/synthetic/gloves/brown
	path = /obj/item/clothing/gloves/marine/brown

/datum/gear/synthetic/gloves/grey
	path = /obj/item/clothing/gloves/marine/grey

/datum/gear/synthetic/gloves/fingerless
	path = /obj/item/clothing/gloves/marine/fingerless

/datum/gear/synthetic/gloves/dress
	path = /obj/item/clothing/gloves/marine/dress

/datum/gear/synthetic/headwear
	category = "Headwear"

/datum/gear/synthetic/headwear/surgcap_green
	path = /obj/item/clothing/head/surgery/green

/datum/gear/synthetic/headwear/surgcap_blue
	path = /obj/item/clothing/head/surgery/blue

/datum/gear/synthetic/headwear/surgcap_lightblue
	path = /obj/item/clothing/head/surgery/lightblue

/datum/gear/synthetic/headwear/surgcap_purple
	path = /obj/item/clothing/head/surgery/purple

/datum/gear/synthetic/headwear/surgcap_olive
	path = /obj/item/clothing/head/surgery/olive

/datum/gear/synthetic/headwear/surgcap_grey
	path = /obj/item/clothing/head/surgery/grey

/datum/gear/synthetic/headwear/surgcap_brown
	path = /obj/item/clothing/head/surgery/brown

/datum/gear/synthetic/headwear/surgcap_white
	path = /obj/item/clothing/head/surgery/white

/datum/gear/synthetic/headwear/surgcap_black
	path = /obj/item/clothing/head/surgery/morgue

/datum/gear/synthetic/headwear/surgcap_pharmacist
	path = /obj/item/clothing/head/surgery/pharmacist

/datum/gear/synthetic/headwear/beanie
	path = /obj/item/clothing/head/beanie

/datum/gear/synthetic/headwear/hardhat_yellow
	path = /obj/item/clothing/head/hardhat

/datum/gear/synthetic/headwear/hardhat_yellow
	path = /obj/item/clothing/head/hardhat

/datum/gear/synthetic/headwear/hardhat_orange
	path = /obj/item/clothing/head/hardhat/orange

/datum/gear/synthetic/headwear/hardhat_white
	path = /obj/item/clothing/head/hardhat/white

/datum/gear/synthetic/headwear/hardhat_blue
	path = /obj/item/clothing/head/hardhat/dblue

/datum/gear/synthetic/headwear/welding_helmet
	path = /obj/item/clothing/head/welding

/datum/gear/synthetic/headwear/beret_engineering
	path = /obj/item/clothing/head/beret/eng

/datum/gear/synthetic/headwear/beret_purple
	path = /obj/item/clothing/head/beret/jan

/datum/gear/synthetic/headwear/beret_red
	path = /obj/item/clothing/head/beret/cm/red

/datum/gear/synthetic/headwear/beret
	path = /obj/item/clothing/head/beret/cm

/datum/gear/synthetic/headwear/beret_tan
	path = /obj/item/clothing/head/beret/cm/tan

/datum/gear/synthetic/headwear/beret_black
	path = /obj/item/clothing/head/beret/cm/black

/datum/gear/synthetic/headwear/beret_white
	path = /obj/item/clothing/head/beret/cm/white

/datum/gear/synthetic/headwear/cap
	path = /obj/item/clothing/head/cmcap

/datum/gear/synthetic/headwear/cap
	path = /obj/item/clothing/head/cmcap/flap

/datum/gear/synthetic/headwear/mp_cap
	path = /obj/item/clothing/head/beret/marine/mp/mpcap

/datum/gear/synthetic/headwear/ro_cap
	path = /obj/item/clothing/head/cmcap/req/ro

/datum/gear/synthetic/headwear/req_cap
	path = /obj/item/clothing/head/cmcap/req

/datum/gear/synthetic/headwear/officer_cap
	path = /obj/item/clothing/head/cmcap/bridge

/datum/gear/synthetic/headwear/fedora_tan
	path = /obj/item/clothing/head/fedora

/datum/gear/synthetic/headwear/fedora_grey
	path = /obj/item/clothing/head/fedora/grey

/datum/gear/synthetic/headwear/fedora_brown
	path = /obj/item/clothing/head/fedora/brown

/datum/gear/synthetic/headwear/trucker_blue
	path = /obj/item/clothing/head/soft/trucker

/datum/gear/synthetic/headwear/trucker_red
	path = /obj/item/clothing/head/soft/trucker/red

/datum/gear/synthetic/helmet
	category = "Helmet"

/datum/gear/synthetic/helmet/marine
	path = /obj/item/clothing/head/helmet/marine

/datum/gear/synthetic/helmet/marine_grey
	path = /obj/item/clothing/head/helmet/marine/grey

/datum/gear/synthetic/helmet/marine_jungle
	path = /obj/item/clothing/head/helmet/marine/jungle

/datum/gear/synthetic/helmet/marine_snow
	path = /obj/item/clothing/head/helmet/marine/snow

/datum/gear/synthetic/helmet/marine_desert
	path = /obj/item/clothing/head/helmet/marine/desert

/datum/gear/synthetic/helmet/marine_urban
	path = /obj/item/clothing/head/helmet/marine/urban

/datum/gear/synthetic/helmet/marine_medic
	path = /obj/item/clothing/head/helmet/marine/medic

/datum/gear/synthetic/helmet/marine_medic_grey
	path = /obj/item/clothing/head/helmet/marine/medic/grey

/datum/gear/synthetic/helmet/marine_medic_white
	path = /obj/item/clothing/head/helmet/marine/medic/white

/datum/gear/synthetic/helmet/marine_medic_jungle
	path = /obj/item/clothing/head/helmet/marine/medic/jungle

/datum/gear/synthetic/helmet/marine_medic_snow
	path = /obj/item/clothing/head/helmet/marine/medic/snow

/datum/gear/synthetic/helmet/marine_medic_desert
	path = /obj/item/clothing/head/helmet/marine/medic/desert

/datum/gear/synthetic/helmet/marine_medic_urban
	path = /obj/item/clothing/head/helmet/marine/medic/urban

/datum/gear/synthetic/helmet/marine_intel
	path = /obj/item/clothing/head/helmet/marine/rto/intel

/datum/gear/synthetic/helmet/marine_intel_grey
	path = /obj/item/clothing/head/helmet/marine/rto/intel/grey

/datum/gear/synthetic/helmet/marine_intel_jungle
	path = /obj/item/clothing/head/helmet/marine/rto/intel/jungle

/datum/gear/synthetic/helmet/marine_intel_snow
	path = /obj/item/clothing/head/helmet/marine/rto/intel/snow

/datum/gear/synthetic/helmet/marine_intel_desert
	path = /obj/item/clothing/head/helmet/marine/rto/intel/desert

/datum/gear/synthetic/helmet/marine_mp
	path = /obj/item/clothing/head/helmet/marine/MP

/datum/gear/synthetic/helmet/marine_mp_grey
	path = /obj/item/clothing/head/helmet/marine/MP/grey

/datum/gear/synthetic/helmet/marine_mp_jungle
	path = /obj/item/clothing/head/helmet/marine/MP/jungle

/datum/gear/synthetic/helmet/marine_mp_snow
	path = /obj/item/clothing/head/helmet/marine/MP/snow

/datum/gear/synthetic/helmet/marine_mp_desert
	path = /obj/item/clothing/head/helmet/marine/MP/desert

/datum/gear/synthetic/helmet/marine_mp_urban
	path = /obj/item/clothing/head/helmet/marine/MP/urban

/datum/gear/synthetic/mask
	category = "Mask"

/datum/gear/synthetic/mask/surgical
	path = /obj/item/clothing/mask/surgical

/datum/gear/synthetic/mask/tacticalmask
	path = /obj/item/clothing/mask/rebreather/scarf/tacticalmask

/datum/gear/synthetic/mask/tacticalmask_red
	path = /obj/item/clothing/mask/rebreather/scarf/tacticalmask/red

/datum/gear/synthetic/mask/tacticalmask_green
	path = /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green

/datum/gear/synthetic/mask/tacticalmask_tan
	path = /obj/item/clothing/mask/rebreather/scarf/tacticalmask/tan

/datum/gear/synthetic/mask/tacticalmask_black
	path = /obj/item/clothing/mask/rebreather/scarf/tacticalmask/black

/datum/gear/synthetic/mask/tornscarf
	path = /obj/item/clothing/mask/tornscarf

/datum/gear/synthetic/mask/tornscarf_green
	path = /obj/item/clothing/mask/tornscarf/green

/datum/gear/synthetic/mask/tornscarf_snow
	path = /obj/item/clothing/mask/tornscarf/snow

/datum/gear/synthetic/mask/tornscarf_desert
	path = /obj/item/clothing/mask/tornscarf/desert

/datum/gear/synthetic/mask/tornscarf_urban
	path = /obj/item/clothing/mask/tornscarf/urban

/datum/gear/synthetic/mask/tornscarf_black
	path = /obj/item/clothing/mask/tornscarf/black

/datum/gear/synthetic/suit
	category = "Suit"

/datum/gear/synthetic/suit/bomber
	path = /obj/item/clothing/suit/storage/bomber

/datum/gear/synthetic/suit/grey_bomber
	path = /obj/item/clothing/suit/storage/jacket/marine/bomber/grey

/datum/gear/synthetic/suit/red_bomber
	path = /obj/item/clothing/suit/storage/jacket/marine/bomber/red

/datum/gear/synthetic/suit/bomber_alt
	path = /obj/item/clothing/suit/storage/bomber/alt

/datum/gear/synthetic/suit/khaki_bomber
	path = /obj/item/clothing/suit/storage/jacket/marine/bomber

/datum/gear/synthetic/suit/webbing
	path = /obj/item/clothing/suit/storage/webbing

/datum/gear/synthetic/suit/utility_vest
	path = /obj/item/clothing/suit/storage/utility_vest

/datum/gear/synthetic/suit/hazardvest
	path = /obj/item/clothing/suit/storage/hazardvest

/datum/gear/synthetic/suit/hazardvest_hivis
	path = /obj/item/clothing/suit/storage/hazardvest/sanitation

/datum/gear/synthetic/suit/hazardvest_blue
	path = /obj/item/clothing/suit/storage/hazardvest/blue

/datum/gear/synthetic/suit/hazardvest_yellow
	path = /obj/item/clothing/suit/storage/hazardvest/yellow

/datum/gear/synthetic/suit/hazardvest_black
	path = /obj/item/clothing/suit/storage/hazardvest/black

/datum/gear/synthetic/suit/medicalvest_green
	path = /obj/item/clothing/suit/storage/hazardvest/medical_green

/datum/gear/synthetic/suit/medicalvest_red
	path = /obj/item/clothing/suit/storage/hazardvest/medical_red

/datum/gear/synthetic/suit/snowsuit
	path = /obj/item/clothing/suit/storage/snow_suit/synth

/datum/gear/synthetic/suit/marine_service
	path = /obj/item/clothing/suit/storage/jacket/marine/service

/datum/gear/synthetic/suit/marine_service
	path = /obj/item/clothing/suit/storage/jacket/marine/service/mp

/datum/gear/synthetic/suit/windbreaker_brown
	path = /obj/item/clothing/suit/storage/windbreaker/windbreaker_brown

/datum/gear/synthetic/suit/windbreaker_gray
	path = /obj/item/clothing/suit/storage/windbreaker/windbreaker_gray

/datum/gear/synthetic/suit/windbreaker_green
	path = /obj/item/clothing/suit/storage/windbreaker/windbreaker_green

/datum/gear/synthetic/suit/windbreaker_fr
	path = /obj/item/clothing/suit/storage/windbreaker/windbreaker_fr

/datum/gear/synthetic/suit/windbreaker_covenant
	path = /obj/item/clothing/suit/storage/windbreaker/windbreaker_covenant

/datum/gear/synthetic/suit/labcoat
	path = /obj/item/clothing/suit/storage/labcoat

/datum/gear/synthetic/suit/labcoat_researcher
	path = /obj/item/clothing/suit/storage/labcoat/researcher

/datum/gear/synthetic/suit/ro_jacket
	path = /obj/item/clothing/suit/storage/jacket/marine/RO

/datum/gear/synthetic/suit/corporate_black
	path = /obj/item/clothing/suit/storage/jacket/marine/corporate/black

/datum/gear/synthetic/suit/corporate_brown
	path = /obj/item/clothing/suit/storage/jacket/marine/corporate/brown

/datum/gear/synthetic/suit/corporate_blue
	path = /obj/item/clothing/suit/storage/jacket/marine/corporate/blue

/datum/gear/synthetic/suit/vest
	path = /obj/item/clothing/suit/storage/jacket/marine/vest

/datum/gear/synthetic/suit/vest_tan
	path = /obj/item/clothing/suit/storage/jacket/marine/vest/tan

/datum/gear/synthetic/suit/vest_gray
	path = /obj/item/clothing/suit/storage/jacket/marine/vest/grey

/datum/gear/synthetic/suit/tan_trenchcoat
	path = /obj/item/clothing/suit/storage/CMB/trenchcoat

/datum/gear/synthetic/suit/brown_trenchcoat
	path = /obj/item/clothing/suit/storage/CMB/trenchcoat/brown

/datum/gear/synthetic/suit/grey_trenchcoat
	path = /obj/item/clothing/suit/storage/CMB/trenchcoat/grey

/datum/gear/synthetic/suit/blue_overalls
	path = /obj/item/clothing/suit/storage/apron/overalls

/datum/gear/synthetic/suit/tan_overalls
	path = /obj/item/clothing/suit/storage/apron/overalls/tan

/datum/gear/synthetic/suit/red_overalls
	path = /obj/item/clothing/suit/storage/apron/overalls/red

/datum/gear/synthetic/backpack
	category = "Backpack"

/datum/gear/synthetic/backpack/industrial
	path = /obj/item/storage/backpack/industrial

/datum/gear/synthetic/backpack/marine_medic
	path = /obj/item/storage/backpack/marine/medic

/datum/gear/synthetic/backpack/marine_medic_satchel
	path = /obj/item/storage/backpack/marine/satchel/tech

/datum/gear/synthetic/backpack/marine_satchel
	path = /obj/item/storage/backpack/marine/satchel

/datum/gear/synthetic/backpack/marine_satchel_med
	path = /obj/item/storage/backpack/marine/satchel/medic

/datum/gear/synthetic/backpack/satchel
	path = /obj/item/storage/backpack/satchel

/datum/gear/synthetic/backpack/satchel_blue
	path = /obj/item/storage/backpack/satchel/blue

/datum/gear/synthetic/backpack/satchel_black
	path = /obj/item/storage/backpack/satchel/black

/datum/gear/synthetic/backpack/marine_engineer_satchel
	path = /obj/item/storage/backpack/marine/engineerpack/satchel

/datum/gear/synthetic/backpack/marine_engineer_chestrig
	path = /obj/item/storage/backpack/marine/engineerpack/welder_chestrig

/datum/gear/synthetic/backpack/marine_radio_telephone
	path = /obj/item/storage/backpack/marine/satchel/rto
	loadout_cost = 24

/datum/gear/synthetic/armband
	path = /obj/item/clothing/accessory/armband

/datum/gear/synthetic/armband_sci
	path = /obj/item/clothing/accessory/armband/science

/datum/gear/synthetic/armband_eng
	path = /obj/item/clothing/accessory/armband/engine

/datum/gear/synthetic/armband_med
	path = /obj/item/clothing/accessory/armband/medgreen

/datum/gear/synthetic/blue_tie
	path = /obj/item/clothing/accessory/tie

/datum/gear/synthetic/green_tie
	path = /obj/item/clothing/accessory/tie/green

/datum/gear/synthetic/black_tie
	path = /obj/item/clothing/accessory/tie/black

/datum/gear/synthetic/gold_tie
	path = /obj/item/clothing/accessory/tie/gold

/datum/gear/synthetic/red_tie
	path = /obj/item/clothing/accessory/tie/red

/datum/gear/synthetic/purple_tie
	path = /obj/item/clothing/accessory/tie/purple

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

/obj/structure/machinery/cm_vending/own_points/experimental_tools/redeem_token(obj/item/coin/marine/token, mob/user)
	if(token.token_type == VEND_TOKEN_SYNTH)
		if(user.drop_inv_item_to_loc(token, src))
			available_points = 30
			available_points_to_display = available_points
			to_chat(user, SPAN_NOTICE("You insert \the [token] into \the [src]."))
			return TRUE
	return ..()

/obj/structure/machinery/cm_vending/own_points/experimental_tools/get_listed_products(mob/user)
	return GLOB.cm_vending_synth_tools

GLOBAL_LIST_INIT(cm_vending_synth_tools, list(
	list("Breaching Hammer", 15, /obj/item/weapon/twohanded/breacher/synth, null, VENDOR_ITEM_REGULAR),
	list("Compact Defibrillator", 15, /obj/item/device/defibrillator/compact, null, VENDOR_ITEM_REGULAR),
	list("Compact Nailgun kit", 15, /obj/effect/essentials_set/cnailgun, null, VENDOR_ITEM_REGULAR),
	list("Telescopic Baton", 15, /obj/item/weapon/telebaton, null, VENDOR_ITEM_REGULAR),
	list("Surgical Webbing Vest", 15, /obj/item/clothing/accessory/storage/surg_vest, null, VENDOR_ITEM_REGULAR),
	list("Surgical Webbing Vest (Blue)", 15, /obj/item/clothing/accessory/storage/surg_vest/blue, null, VENDOR_ITEM_REGULAR),
	list("Surgical Drop Pouch", 15, /obj/item/clothing/accessory/storage/surg_vest/drop_green, null, VENDOR_ITEM_REGULAR),
	list("Surgical Drop Pouch (Blue)", 15, /obj/item/clothing/accessory/storage/surg_vest/drop_blue, null, VENDOR_ITEM_REGULAR),
	list("Surgical Drop Pouch (Black)", 15, /obj/item/clothing/accessory/storage/surg_vest/drop_black, null, VENDOR_ITEM_REGULAR),
	list("Tool Webbing", 15, /obj/item/clothing/accessory/storage/tool_webbing/equipped, null, VENDOR_ITEM_REGULAR),
	list("Tool Drop Pouch", 15, /obj/item/clothing/accessory/storage/tool_webbing/yellow_drop/equipped, null, VENDOR_ITEM_REGULAR),
	list("Logistics IMP Backpack", 15, /obj/item/storage/backpack/marine/satchel/big, null, VENDOR_ITEM_REGULAR),
	list("Expedition Chestrig", 15, /obj/item/storage/backpack/marine/satchel/intel/chestrig, null, VENDOR_ITEM_REGULAR),
	list("Expedition Satchel", 15, /obj/item/storage/backpack/marine/satchel/intel/expeditionsatchel, null, VENDOR_ITEM_REGULAR),
))

//------------EXPERIMENTAL TOOL KITS---------------
/obj/effect/essentials_set/cnailgun
	spawned_gear_list = list(
		/obj/item/weapon/gun/smg/nailgun/compact,
		/obj/item/ammo_magazine/smg/nailgun,
		/obj/item/ammo_magazine/smg/nailgun,
		/obj/item/storage/belt/gun/m4a3/nailgun,
	)
