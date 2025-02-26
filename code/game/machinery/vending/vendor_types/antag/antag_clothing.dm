//------------ADAPTIVE ANTAG CLOSET---------------
//Spawn one of these bad boys and you will have a proper automated closet for CLF/UPP players (for now, more can be always added later)

/obj/structure/machinery/cm_vending/clothing/antag
	name = "\improper Suspicious Automated Equipment Rack"
	desc = "While similar in function to ColMarTech automated racks, this one is clearly not of USCM origin. Contains various equipment."
	icon_state = "antag_clothing"
	req_one_access = list(ACCESS_ILLEGAL_PIRATE, ACCESS_UPP_GENERAL, ACCESS_CLF_GENERAL)
	req_access = null

	listed_products = list()

/obj/structure/machinery/cm_vending/clothing/antag/Initialize()
	. = ..()
	vend_flags |= VEND_FACTION_THEMES

/obj/structure/machinery/cm_vending/clothing/antag/get_listed_products(mob/user)
	if(!user)
		var/list/all_equipment = list()
		var/list/presets = typesof(/datum/equipment_preset)
		for(var/i in presets)
			var/datum/equipment_preset/eq = new i
			var/list/equipment = eq.get_antag_clothing_equipment()
			if(LAZYLEN(equipment))
				all_equipment += equipment
			qdel(eq)
		return all_equipment

	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/list/products_sets = list()
	if(H.assigned_equipment_preset)
		if(!(H.assigned_equipment_preset.type in listed_products))
			listed_products[H.assigned_equipment_preset.type] = H.assigned_equipment_preset.get_antag_clothing_equipment()
		products_sets = listed_products[H.assigned_equipment_preset.type]
	else
		if(!(/datum/equipment_preset/clf in listed_products))
			listed_products[/datum/equipment_preset/clf] = GLOB.gear_path_presets_list[/datum/equipment_preset/clf].get_antag_clothing_equipment()
		products_sets = listed_products[/datum/equipment_preset/clf]
	return products_sets

/obj/structure/machinery/cm_vending/clothing/antag/upp
	name = "\improper Automated Equipment Rack"
	icon_state = "upp_clothing"
	req_access = list(ACCESS_UPP_GENERAL)

//--------------RANDOM EQUIPMENT AND GEAR------------------------

/obj/effect/essentials_set/random/clf_shoes
	spawned_gear_list = list(
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/brown,
		/obj/item/clothing/shoes/combat,
		/obj/item/clothing/shoes/laceup,
		/obj/item/clothing/shoes/leather,
		/obj/item/clothing/shoes/swat,
	)

/obj/effect/essentials_set/random/clf_armor
	spawned_gear_list = list(
		/obj/item/clothing/suit/armor/vest,
		/obj/item/clothing/suit/armor/bulletproof,
		/obj/item/clothing/suit/storage/militia/brace,
		/obj/item/clothing/suit/storage/militia,
		/obj/item/clothing/suit/storage/militia/partial,
		/obj/item/clothing/suit/storage/militia/vest,
	)

/obj/effect/essentials_set/random/clf_gloves
	spawned_gear_list = list(
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/gloves/botanic_leather,
		/obj/item/clothing/gloves/combat,
		/obj/item/clothing/gloves/swat,
	)

/obj/effect/essentials_set/random/clf_head
	spawned_gear_list = list(
		/obj/item/clothing/head/militia,
		/obj/item/clothing/head/militia/bucket,
		/obj/item/clothing/head/helmet/skullcap,
		/obj/item/clothing/head/hardhat,
		/obj/item/clothing/head/helmet,
		/obj/item/clothing/head/bandana,
		/obj/item/clothing/head/headband/red,
		/obj/item/clothing/head/headband/rambo,
		/obj/item/clothing/head/headband/rebel,
		/obj/item/clothing/head/helmet/swat,
	)

/obj/effect/essentials_set/random/clf_belt
	spawned_gear_list = list(
		/obj/item/storage/belt/marine,
		/obj/item/storage/belt/marine,
		/obj/item/storage/belt/marine,
		/obj/item/storage/belt/marine,
		/obj/item/storage/belt/marine,
		/obj/item/storage/belt/gun/flaregun/full,
		/obj/item/storage/belt/gun/flaregun/full,
		/obj/item/storage/backpack/general_belt,
		/obj/item/storage/backpack/general_belt,
		/obj/item/storage/backpack/general_belt,
		/obj/item/storage/belt/knifepouch,
		/obj/item/storage/large_holster/katana/full,
		/obj/item/storage/large_holster/machete/full,
	)

//------UPP Synthetic Snowflake------

/obj/structure/machinery/cm_vending/clothing/synth/upp
	name = "\improper UPP Synthetic Conformity Unit"
	desc = "A vendor with a large snowflake on it. Stolen from Wey-Yu Fashion Division."
	icon_state = "snowflake"
	show_points = TRUE
	use_snowflake_points = TRUE
	vendor_theme = VENDOR_THEME_UPP
	req_access = list(ACCESS_UPP_LEADERSHIP)
	vendor_role = list(JOB_SYNTH, JOB_SYNTH_SURVIVOR, JOB_WORKING_JOE, JOB_UPP_SUPPORT_SYNTH, JOB_UPP_COMBAT_SYNTH, JOB_CMB_SYN, JOB_PMC_SYNTH)

	vend_delay = 1 SECONDS

/obj/structure/machinery/cm_vending/clothing/synth/upp/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_synth_upp

//------------UPP SNOWFLAKE VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_synth_upp, list(
	list("UPP FATIGUES", 0, null, null, null),
	list("UPP Soldier Fatigues", 12, /obj/item/clothing/under/marine/veteran/UPP, null, VENDOR_ITEM_REGULAR),
	list("UPP Engineer Fatigues", 12, /obj/item/clothing/under/marine/veteran/UPP/engi, null, VENDOR_ITEM_REGULAR),
	list("UPP Medic Fatigues", 12, /obj/item/clothing/under/marine/veteran/UPP/medic, null, VENDOR_ITEM_REGULAR),
	list("UPP MP Fatigues", 12, /obj/item/clothing/under/marine/veteran/UPP/mp, null, VENDOR_ITEM_REGULAR),
	list("UPP Officer Fatigues", 12, /obj/item/clothing/under/marine/veteran/UPP/officer, null, VENDOR_ITEM_REGULAR),

	list("NON-STANDARD UNIFORMS", 0, null, null, null),
	list("UPP Civilian-style overalls, Orange", 12, /obj/item/clothing/under/marine/veteran/UPP/civi1, null, VENDOR_ITEM_REGULAR),
	list("UPP Civilian-style overalls, Tan", 12, /obj/item/clothing/under/marine/veteran/UPP/civi2, null, VENDOR_ITEM_REGULAR),
	list("UPP Civilian-style shirt and pants", 12, /obj/item/clothing/under/marine/veteran/UPP/civi3, null, VENDOR_ITEM_REGULAR),
	list("UPP Civilian-style vest and pants", 12, /obj/item/clothing/under/marine/veteran/UPP/civi4, null, VENDOR_ITEM_REGULAR),
	list("Medical Scrubs, Blue", 12, /obj/item/clothing/under/rank/medical/blue, null, VENDOR_ITEM_REGULAR),
	list("Medical Scrubs, Light Blue", 12, /obj/item/clothing/under/rank/medical/lightblue, null, VENDOR_ITEM_REGULAR),
	list("Medical Scrubs, Green", 12, /obj/item/clothing/under/rank/medical/green, null, VENDOR_ITEM_REGULAR),
	list("Medical Scrubs, Purple", 12, /obj/item/clothing/under/rank/medical/purple, null, VENDOR_ITEM_REGULAR),
	list("Medical Scrubs, Olive", 12, /obj/item/clothing/under/rank/medical/olive, null, VENDOR_ITEM_REGULAR),
	list("Medical Scrubs, Grey", 12, /obj/item/clothing/under/rank/medical/grey, null, VENDOR_ITEM_REGULAR),
	list("Medical Scrubs, White", 12, /obj/item/clothing/under/rank/medical, null, VENDOR_ITEM_REGULAR),
	list("White T-Shirt and Brown Jeans", 12, /obj/item/clothing/under/tshirt/w_br, null, VENDOR_ITEM_REGULAR),
	list("Gray T-Shirt and Blue Jeans", 12, /obj/item/clothing/under/tshirt/gray_blu, null, VENDOR_ITEM_REGULAR),
	list("Red T-Shirt and Black Jeans", 12, /obj/item/clothing/under/tshirt/r_bla, null, VENDOR_ITEM_REGULAR),
	list("Frontier Jumpsuit", 12, /obj/item/clothing/under/rank/frontier, null, VENDOR_ITEM_REGULAR),
	list("Grey Utilities", 12, /obj/item/clothing/under/rank/utility/yellow, null, VENDOR_ITEM_REGULAR),
	list("Grey Utilities and Blue Jeans", 12, /obj/item/clothing/under/rank/utility/red, null, VENDOR_ITEM_REGULAR),
	list("Blue Utilities and Brown Jeans", 12, /obj/item/clothing/under/rank/utility/blue, null, VENDOR_ITEM_REGULAR),
	list("White Service Uniform", 12, /obj/item/clothing/under/colonist/white_service, null, VENDOR_ITEM_REGULAR),
	list("Steward Clothes", 12, /obj/item/clothing/under/colonist/steward, null, VENDOR_ITEM_REGULAR),
	list("Red Dress Skirt", 12, /obj/item/clothing/under/blackskirt, null, VENDOR_ITEM_REGULAR),
	list("Blue Suit Pants", 12, /obj/item/clothing/under/liaison_suit/blue, null, VENDOR_ITEM_REGULAR),
	list("Brown Suit Pants", 12, /obj/item/clothing/under/liaison_suit/brown, null, VENDOR_ITEM_REGULAR),
	list("White Suit Pants", 12, /obj/item/clothing/under/liaison_suit/corporate_formal, null, VENDOR_ITEM_REGULAR),
	list("Working Joe Uniform", 36, /obj/item/clothing/under/rank/synthetic/joe, null, VENDOR_ITEM_REGULAR),

	list("GLASSES", 0, null, null, null),
	list("HealthMate HUD", 12, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_REGULAR),
	list("Marine RPG Glasses", 12, /obj/item/clothing/glasses/regular, null, VENDOR_ITEM_REGULAR),
	list("Optical Meson Scanner", 12, /obj/item/clothing/glasses/meson, null, VENDOR_ITEM_REGULAR),
	list("PatrolMate HUD", 12, /obj/item/clothing/glasses/hud/security, null, VENDOR_ITEM_REGULAR),
	list("Security HUD Glasses", 12, /obj/item/clothing/glasses/sunglasses/sechud, null, VENDOR_ITEM_REGULAR),
	list("Sunglasses", 12, /obj/item/clothing/glasses/sunglasses, null, VENDOR_ITEM_REGULAR),
	list("Welding Goggles", 12, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),

	list("SHOES", 0, null, null, null),
	list("UPP Boots", 12, /obj/item/clothing/shoes/marine/upp/knife, null, VENDOR_ITEM_REGULAR),
	list("Shoes, Black", 12, /obj/item/clothing/shoes/black, null, VENDOR_ITEM_REGULAR),
	list("Shoes, Blue", 12, /obj/item/clothing/shoes/blue, null, VENDOR_ITEM_REGULAR),
	list("Shoes, Brown", 12, /obj/item/clothing/shoes/brown, null, VENDOR_ITEM_REGULAR),
	list("Shoes, Green", 12, /obj/item/clothing/shoes/green, null, VENDOR_ITEM_REGULAR),
	list("Shoes, Purple", 12, /obj/item/clothing/shoes/purple, null, VENDOR_ITEM_REGULAR),
	list("Shoes, Red", 12, /obj/item/clothing/shoes/red, null, VENDOR_ITEM_REGULAR),
	list("Shoes, White", 12, /obj/item/clothing/shoes/white, null, VENDOR_ITEM_REGULAR),
	list("Shoes, Yellow", 12, /obj/item/clothing/shoes/yellow, null, VENDOR_ITEM_REGULAR),
	list("Shoes, Seegson", 24, /obj/item/clothing/shoes/dress, null, VENDOR_ITEM_REGULAR),

	list("HEADWEAR", 0, null, null, null),
	list("UL2 cap", 12, /obj/item/clothing/head/uppcap, null, VENDOR_ITEM_REGULAR),
	list("UL2c cap", 12, /obj/item/clothing/head/uppcap/civi, null, VENDOR_ITEM_REGULAR),
	list("UL3 peaked cap", 12, /obj/item/clothing/head/uppcap/peaked, null, VENDOR_ITEM_REGULAR),
	list("UL8 ushanka", 12, /obj/item/clothing/head/uppcap/ushanka, null, VENDOR_ITEM_REGULAR),
	list("UL8c ushanka", 12, /obj/item/clothing/head/uppcap/ushanka/civi, null, VENDOR_ITEM_REGULAR),
	list("Surgical Cap, Blue", 12, /obj/item/clothing/head/surgery/blue, null, VENDOR_ITEM_REGULAR),
	list("Surgical Cap, Blue", 12, /obj/item/clothing/head/surgery/purple, null, VENDOR_ITEM_REGULAR),
	list("Surgical Cap, Green", 12, /obj/item/clothing/head/surgery/green, null, VENDOR_ITEM_REGULAR),
	list("Beanie", 12, /obj/item/clothing/head/beanie, null, VENDOR_ITEM_REGULAR),
	list("Beret, Engineering", 12, /obj/item/clothing/head/beret/eng, null, VENDOR_ITEM_REGULAR),
	list("Beret, Purple", 12, /obj/item/clothing/head/beret/jan, null, VENDOR_ITEM_REGULAR),
	list("Beret, Red", 12, /obj/item/clothing/head/beret/cm/red, null, VENDOR_ITEM_REGULAR),
	list("Beret, Standard", 12, /obj/item/clothing/head/beret/cm, null, VENDOR_ITEM_REGULAR),
	list("Beret, Tan", 12, /obj/item/clothing/head/beret/cm/tan, null, VENDOR_ITEM_REGULAR),
	list("Beret, Green", 12, /obj/item/clothing/head/beret/cm, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
	list("Beret, Black", 12, /obj/item/clothing/head/beret/cm/black, null, VENDOR_ITEM_REGULAR),
	list("Beret, White", 12, /obj/item/clothing/head/beret/cm/white, null, VENDOR_ITEM_REGULAR),
	list("Bio Hood", 12, /obj/item/clothing/head/bio_hood/synth, null, VENDOR_ITEM_REGULAR),
	list("Fedora", 12, /obj/item/clothing/head/fedora/grey, null, VENDOR_ITEM_REGULAR),

	list("HELMET", 0, null, null, null),
	list("UM4 Helmet", 12, /obj/item/clothing/head/helmet/marine/veteran/UPP, null, VENDOR_ITEM_REGULAR),
	list("White Corpsman Helmet (Non-Standard)", 12, /obj/item/clothing/head/helmet/marine/medic/white, null, VENDOR_ITEM_REGULAR),
	list("Attachable Helmet Shield", 12, /obj/item/prop/helmetgarb/riot_shield, null, VENDOR_ITEM_REGULAR),

	list("MASK", 0, null, null, null),
	list("Surgical Mask", 12, /obj/item/clothing/mask/surgical, null, VENDOR_ITEM_REGULAR),
	list("Rebreather", 12, /obj/item/clothing/mask/rebreather, null, VENDOR_ITEM_REGULAR),
	list("Skull Balaclava, Blue", 12, /obj/item/clothing/mask/rebreather/skull, null, VENDOR_ITEM_REGULAR),
	list("Skull balaclava, Black", 12, /obj/item/clothing/mask/rebreather/skull/black, null, VENDOR_ITEM_REGULAR),
	list("Balaclava", 12, /obj/item/clothing/mask/rebreather/scarf, null, VENDOR_ITEM_REGULAR),
	list("Balaclava (Green)", 12, /obj/item/clothing/mask/rebreather/scarf/green, null, VENDOR_ITEM_REGULAR),
	list("Balaclava (Tan)", 12, /obj/item/clothing/mask/rebreather/scarf/tan, null, VENDOR_ITEM_REGULAR),
	list("Balaclava (Grey)", 12, /obj/item/clothing/mask/rebreather/scarf/gray, null, VENDOR_ITEM_REGULAR),
	list("Wrap (Grey)", 12, /obj/item/clothing/mask/rebreather/scarf/tacticalmask, null, VENDOR_ITEM_REGULAR),
	list("Wrap (Red)", 12, /obj/item/clothing/mask/rebreather/scarf/tacticalmask/red, null, VENDOR_ITEM_REGULAR),
	list("Wrap (Green)", 12, /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, null, VENDOR_ITEM_REGULAR),
	list("Wrap (Tan)", 12, /obj/item/clothing/mask/rebreather/scarf/tacticalmask/tan, null, VENDOR_ITEM_REGULAR),
	list("Wrap (Black)", 12, /obj/item/clothing/mask/rebreather/scarf/tacticalmask/black, null, VENDOR_ITEM_REGULAR),
	list("Scarf", 12, /obj/item/clothing/mask/tornscarf, null, VENDOR_ITEM_REGULAR),
	list("Scarf (Green)", 12, /obj/item/clothing/mask/tornscarf/green, null, VENDOR_ITEM_REGULAR),
	list("Scarf (Snow)", 12, /obj/item/clothing/mask/tornscarf/snow, null, VENDOR_ITEM_REGULAR),
	list("Scarf (Desert)", 12, /obj/item/clothing/mask/tornscarf/desert, null, VENDOR_ITEM_REGULAR),
	list("Scarf (Urban)", 12, /obj/item/clothing/mask/tornscarf/urban, null, VENDOR_ITEM_REGULAR),
	list("Scarf (Black)", 12, /obj/item/clothing/mask/tornscarf/black, null, VENDOR_ITEM_REGULAR),

	list("SUIT", 0, null, null, null),
	list("Bomber Jacket, Brown", 12, /obj/item/clothing/suit/storage/bomber, null, VENDOR_ITEM_REGULAR),
	list("Bomber Jacket, Black", 12, /obj/item/clothing/suit/storage/bomber/alt, null, VENDOR_ITEM_REGULAR),
	list("External Webbing", 12, /obj/item/clothing/suit/storage/webbing, null, VENDOR_ITEM_REGULAR),
	list("Utility Vest", 12, /obj/item/clothing/suit/storage/utility_vest, null, VENDOR_ITEM_REGULAR),
	list("Hazard Vest(Orange)", 12, /obj/item/clothing/suit/storage/hazardvest, null, VENDOR_ITEM_REGULAR),
	list("Hazard Vest(Blue)", 12, /obj/item/clothing/suit/storage/hazardvest/blue, null, VENDOR_ITEM_REGULAR),
	list("Hazard Vest(Yellow)", 12, /obj/item/clothing/suit/storage/hazardvest/yellow, null, VENDOR_ITEM_REGULAR),
	list("Hazard Vest(Black)", 12, /obj/item/clothing/suit/storage/hazardvest/black, null, VENDOR_ITEM_REGULAR),
	list("Synthetic's Snow Suit", 12, /obj/item/clothing/suit/storage/snow_suit/synth, null, VENDOR_ITEM_REGULAR),
	list("Windbreaker, Brown", 12, /obj/item/clothing/suit/storage/windbreaker/windbreaker_brown, null, VENDOR_ITEM_REGULAR),
	list("Windbreaker, Grey", 12, /obj/item/clothing/suit/storage/windbreaker/windbreaker_gray, null, VENDOR_ITEM_REGULAR),
	list("Windbreaker, Green", 12, /obj/item/clothing/suit/storage/windbreaker/windbreaker_green, null, VENDOR_ITEM_REGULAR),
	list("Windbreaker, First Responder", 12, /obj/item/clothing/suit/storage/windbreaker/windbreaker_fr, null, VENDOR_ITEM_REGULAR),
	list("Windbreaker, Exploration", 12, /obj/item/clothing/suit/storage/windbreaker/windbreaker_covenant, null, VENDOR_ITEM_REGULAR),
	list("Labcoat", 12, /obj/item/clothing/suit/storage/labcoat, null, VENDOR_ITEM_REGULAR),
	list("Labcoat, Researcher", 12, /obj/item/clothing/suit/storage/labcoat/researcher, null, VENDOR_ITEM_REGULAR),
	list("Quartermaster Jacket", 12, /obj/item/clothing/suit/storage/jacket/marine/RO, null, VENDOR_ITEM_REGULAR),
	list("Bio Suit", 12, /obj/item/clothing/suit/storage/synthbio, null, VENDOR_ITEM_REGULAR),
	list("Black Suit Jacket", 12, /obj/item/clothing/suit/storage/jacket/marine/corporate/black, null, VENDOR_ITEM_REGULAR),
	list("Brown Suit Jacket", 12, /obj/item/clothing/suit/storage/jacket/marine/corporate/brown, null, VENDOR_ITEM_REGULAR),
	list("Blue Suit Jacket", 12, /obj/item/clothing/suit/storage/jacket/marine/corporate/blue, null, VENDOR_ITEM_REGULAR),
	list("Brown Vest", 12, /obj/item/clothing/suit/storage/jacket/marine/vest, null, VENDOR_ITEM_REGULAR),
	list("Tan Vest", 12, /obj/item/clothing/suit/storage/jacket/marine/vest/tan, null, VENDOR_ITEM_REGULAR),
	list("Grey Vest", 12, /obj/item/clothing/suit/storage/jacket/marine/vest/grey, null, VENDOR_ITEM_REGULAR),

	list("BACKPACK", 0, null, null, null),
	list("Combat Pack", 12, /obj/item/storage/backpack/lightpack/upp, null, VENDOR_ITEM_REGULAR),
	list("UPP Sapper Welderpack", 12, /obj/item/storage/backpack/marine/engineerpack/upp, null, VENDOR_ITEM_REGULAR),
	list("Satchel, Leather", 12, /obj/item/storage/backpack/satchel, null, VENDOR_ITEM_REGULAR),
	list("Satchel, Medical", 12, /obj/item/storage/backpack/satchel/med, null, VENDOR_ITEM_REGULAR),

	list("OTHER", 0, null, null, null),
	list("UPP patch", 6, /obj/item/clothing/accessory/patch/upp, null, VENDOR_ITEM_REGULAR),
	list("UPP Naval Infantry patch", 6, /obj/item/clothing/accessory/patch/upp/naval, null, VENDOR_ITEM_REGULAR),
	list("UPP Airborne Reconnaissance patch", 6, /obj/item/clothing/accessory/patch/upp/airborne, null, VENDOR_ITEM_REGULAR),
	list("Red Armband", 6, /obj/item/clothing/accessory/armband, null, VENDOR_ITEM_REGULAR),
	list("Purple Armband", 6, /obj/item/clothing/accessory/armband/science, null, VENDOR_ITEM_REGULAR),
	list("Yellow Armband", 6, /obj/item/clothing/accessory/armband/engine, null, VENDOR_ITEM_REGULAR),
	list("Green Armband", 6, /obj/item/clothing/accessory/armband/medgreen, null, VENDOR_ITEM_REGULAR),
	list("Blue Tie", 6, /obj/item/clothing/accessory/blue, null, VENDOR_ITEM_REGULAR),
	list("Green Tie", 6, /obj/item/clothing/accessory/green, null, VENDOR_ITEM_REGULAR),
	list("Black Tie", 6, /obj/item/clothing/accessory/black, null, VENDOR_ITEM_REGULAR),
	list("Gold Tie", 6, /obj/item/clothing/accessory/gold, null, VENDOR_ITEM_REGULAR),
	list("Red Tie", 6, /obj/item/clothing/accessory/red, null, VENDOR_ITEM_REGULAR),
	list("Purple Tie", 6, /obj/item/clothing/accessory/purple, null, VENDOR_ITEM_REGULAR),
	list("Dress Gloves", 6, /obj/item/clothing/gloves/marine/dress, null, VENDOR_ITEM_REGULAR),
))
