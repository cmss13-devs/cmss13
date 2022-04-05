//---------------------------------------------
//POUCHES BELOW THIS LINE
//---------------------------------------------
/datum/supply_packs/pouches_general
	name = "general pouches crate (2x normal, 1x medium, 1x large)"
	contains = list(
					/obj/item/storage/pouch/general,
					/obj/item/storage/pouch/general,
					/obj/item/storage/pouch/general/medium,
					/obj/item/storage/pouch/general/large
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate
	containername = "general pouches crate"
	group = "Clothing"

/datum/supply_packs/pouches_weapons
	name = "weapons pouches crate (1x bayonet, pistol, explosive)"
	contains = list(
					/obj/item/storage/pouch/bayonet,
					/obj/item/storage/pouch/pistol,
					/obj/item/storage/pouch/explosive
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate
	containername = "weapons pouches crate"
	group = "Clothing"

/datum/supply_packs/pouches_ammo
	name = "ammo pouches crate (1x normal, large, pistol, pistol large)"
	contains = list(
					/obj/item/storage/pouch/magazine,
					/obj/item/storage/pouch/magazine/large,
					/obj/item/storage/pouch/magazine/pistol,
					/obj/item/storage/pouch/magazine/pistol/large
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate
	containername = "ammo pouches crate"
	group = "Clothing"

/datum/supply_packs/pouches_medical
	name = "medical pouches crate (1x firstaid, medical, syringe, medkit, autoinjector)"
	contains = list(
					/obj/item/storage/pouch/firstaid,
					/obj/item/storage/pouch/medical,
					/obj/item/storage/pouch/syringe,
					/obj/item/storage/pouch/medkit,
					/obj/item/storage/pouch/autoinjector,
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate
	containername = "medical pouches crate"
	group = "Clothing"

/datum/supply_packs/pouches_survival
	name = "survival pouches crate (1x radio, flare, survival)"
	contains = list(
					/obj/item/storage/pouch/radio,
					/obj/item/storage/pouch/flare,
					/obj/item/storage/pouch/survival
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate
	containername = "survival pouches crate"
	group = "Clothing"

/datum/supply_packs/pouches_construction
	name = "construction pouches crate (1x electronics, tools, construction)"
	contains = list(
					/obj/item/storage/pouch/electronics,
                    /obj/item/storage/pouch/tools,
					/obj/item/storage/pouch/construction
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate
	containername = "construction pouches crate"
	group = "Clothing"

//---------------------------------------------
//Backpacks
//---------------------------------------------

/datum/supply_packs/backpack
	name = "Lightweight IMP Backpack Crate (x4)"
	contains = list(
		/obj/item/storage/backpack/marine,
		/obj/item/storage/backpack/marine,
		/obj/item/storage/backpack/marine,
		/obj/item/storage/backpack/marine
	)
	cost = RO_PRICE_WORTHLESS
	containertype = /obj/structure/closet/crate/green
	containername = "Lightweight IMP Backpack Crate"
	group = "Clothing"

/datum/supply_packs/backpack/logi
	name = "Logistics IMP Backpack Crate (x4)"
	contains = list(
		/obj/item/storage/backpack/marine/satchel/big,
		/obj/item/storage/backpack/marine/satchel/big,
		/obj/item/storage/backpack/marine/satchel/big,
		/obj/item/storage/backpack/marine/satchel/big
	)
	cost = RO_PRICE_NORMAL
	containername = "Logistics IMP Backpack Crate"

/datum/supply_packs/backpack/satchels
	name = "Marine Satchel Crate (x4)"
	contains = list(
		/obj/item/storage/backpack/marine/satchel,
		/obj/item/storage/backpack/marine/satchel,
		/obj/item/storage/backpack/marine/satchel,
		/obj/item/storage/backpack/marine/satchel
	)
	cost = RO_PRICE_WORTHLESS
	containername = "Marine Satchel Crate"

/datum/supply_packs/backpack/mortar_pack
	name = "Mortar Shell Backpack Crate (x4)"
	contains = list(
		/obj/item/storage/backpack/marine/mortarpack,
		/obj/item/storage/backpack/marine/mortarpack,
		/obj/item/storage/backpack/marine/mortarpack,
		/obj/item/storage/backpack/marine/mortarpack
	)
	cost = RO_PRICE_CHEAP
	containername = "Mortar Shell Backpack Crate"

//---------------------------------------------
//HOLSTERS & WEBBING BELOW THIS LINE
//---------------------------------------------

/datum/supply_packs/webbing_brown_black
	name = "Brown And Black Webbing Crate (x2 each)"
	contains = list(
		/obj/item/clothing/accessory/storage/black_vest/brown_vest,
		/obj/item/clothing/accessory/storage/black_vest/brown_vest,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/clothing/accessory/storage/black_vest
	)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/green
	containername = "Brown And Black Webbing Crate"
	group = "Clothing"

/datum/supply_packs/webbing_large
	name = "Webbing Crate (x4)"
	contains = list(
		/obj/item/clothing/accessory/storage/webbing,
		/obj/item/clothing/accessory/storage/webbing,
		/obj/item/clothing/accessory/storage/webbing,
		/obj/item/clothing/accessory/storage/webbing
	)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/green
	containername = "Webbing Crate"
	group = "Clothing"

/datum/supply_packs/drop_pouches
	name = "Drop Pouch Crate (x4)"
	contains = list(
		/obj/item/clothing/accessory/storage/droppouch,
		/obj/item/clothing/accessory/storage/droppouch,
		/obj/item/clothing/accessory/storage/droppouch,
		/obj/item/clothing/accessory/storage/droppouch,
	)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/green
	containername = "Drop Pouch Crate"
	group = "Clothing"

/datum/supply_packs/webbing_surgical
	name = "Surgical Webbing Crate (x3)"
	contains = list(
		/obj/item/clothing/accessory/storage/surg_vest,
		/obj/item/clothing/accessory/storage/surg_vest,
		/obj/item/clothing/accessory/storage/surg_vest,
	)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/green
	containername = "Surgical Webbing Crate"
	group = "Clothing"

/datum/supply_packs/webbing_knives//for the lulz
	name = "Knife Vest Crate (x3)"
	contains = list(
		/obj/item/clothing/accessory/storage/knifeharness,//old unathi knife harness updated for our needs
		/obj/item/clothing/accessory/storage/knifeharness,
		/obj/item/clothing/accessory/storage/knifeharness
	)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/green
	containername = "Knife Vest Crate"
	group = "Clothing"

/datum/supply_packs/webbing_holster
	name = "Shoulder Holster Crate (x4)"
	contains = list(
		/obj/item/clothing/accessory/storage/holster,
		/obj/item/clothing/accessory/storage/holster,
		/obj/item/clothing/accessory/storage/holster,
		/obj/item/clothing/accessory/storage/holster
	)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/green
	containername = "Shoulder Holster Crate"
	group = "Clothing"


/datum/supply_packs/gun_holster
	contains = list(
					/obj/item/storage/large_holster/m39,
					/obj/item/storage/large_holster/m39
					)
	name = "M39 Belt Holster Crate (x2)"
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate
	containername = "M39 Belt Holster Crate"
	group = "Clothing"

/datum/supply_packs/gunslinger_holster
	contains = list(
					/obj/item/storage/belt/gun/m44/gunslinger,
					/obj/item/storage/belt/gun/m44/gunslinger
					)
	name = "Red Ranger Cowboy Gunbelt Crate (x2)"
	cost = RO_PRICE_VERY_CHEAP
	contraband = 1
	containertype = /obj/structure/closet/crate
	containername = "Cowboy Costume Crate"
	group = "Clothing"

/datum/supply_packs/gun_holster/m44
	name = "M44 Belt Holster Crate (x2)"
	containername = "M44 Belt Holster Crate"
	cost = RO_PRICE_WORTHLESS
	contains = list(
					/obj/item/storage/belt/gun/m44,
					/obj/item/storage/belt/gun/m44
					)
	group = "Clothing"

/datum/supply_packs/gun_holster/m4a3
	name = "M4A3 Belt Holster Crate (x2)"
	containername = "M4A3 Belt Holster Crate"
	cost = RO_PRICE_WORTHLESS
	contains = list(
					/obj/item/storage/belt/gun/m4a3,
					/obj/item/storage/belt/gun/m4a3
					)
	group = "Clothing"

//*******************************************************************************
//CLOTHING
//*******************************************************************************/


/datum/supply_packs/officer_outfits//lmao this shit is so hideously out of date
	contains = list(
					/obj/item/clothing/under/rank/ro_suit,
					/obj/item/clothing/under/marine/officer/bridge,
					/obj/item/clothing/under/marine/officer/bridge,
					/obj/item/clothing/under/marine/officer/exec,
					/obj/item/clothing/under/marine/officer/ce
					)
	name = "officer outfit crate"
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate
	containername = "officer dress crate"
	group = "Clothing"

/datum/supply_packs/marine_outfits
	contains = list(
					/obj/item/clothing/under/marine,
					/obj/item/clothing/under/marine,
					/obj/item/clothing/under/marine,
					/obj/item/storage/belt/marine,
					/obj/item/storage/belt/marine,
					/obj/item/storage/belt/marine,
					/obj/item/storage/backpack/marine,
					/obj/item/storage/backpack/marine,
					/obj/item/storage/backpack/marine,
					/obj/item/clothing/shoes/marine,
					/obj/item/clothing/shoes/marine,
					/obj/item/clothing/shoes/marine
					)
	name = "marine outfit crate"
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate
	containername = "marine outfit crate"
	group = "Clothing"
