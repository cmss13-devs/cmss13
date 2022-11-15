//---------------------------------------------
//Backpacks
//---------------------------------------------

/datum/supply_packs/backpack/mortar_pack
	name = "Mortar Shell Backpack Crate (x4)"
	contains = list(
		/obj/item/storage/backpack/marine/mortarpack,
		/obj/item/storage/backpack/marine/mortarpack,
		/obj/item/storage/backpack/marine/mortarpack,
		/obj/item/storage/backpack/marine/mortarpack
	)
	cost = ASRS_PRICE_THIRTY
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
	cost = ASRS_PRICE_TWENTY
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
	cost = ASRS_PRICE_TWENTY
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
	cost = ASRS_PRICE_TWENTY
	containertype = /obj/structure/closet/crate/green
	containername = "Drop Pouch Crate"
	group = "Clothing"


/datum/supply_packs/webbing_knives//for the lulz
	name = "Knife Vest Crate (x3)"
	contains = list(
		/obj/item/clothing/accessory/storage/knifeharness,//old unathi knife harness updated for our needs
		/obj/item/clothing/accessory/storage/knifeharness,
		/obj/item/clothing/accessory/storage/knifeharness
	)
	cost = ASRS_PRICE_THIRTY
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
	cost = ASRS_PRICE_TWENTY
	containertype = /obj/structure/closet/crate/green
	containername = "Shoulder Holster Crate"
	group = "Clothing"

/datum/supply_packs/gunslinger_holster
	contains = list(
					/obj/item/storage/belt/gun/m44/gunslinger,
					/obj/item/storage/belt/gun/m44/gunslinger
					)
	name = "Red Ranger Cowboy Gunbelt Crate (x2)"
	cost = ASRS_PRICE_TWENTY
	contraband = 1
	containertype = /obj/structure/closet/crate
	containername = "Cowboy Costume Crate"
	group = "Clothing"
