/datum/supply_packs/pouches_ammo
	name = "Large Pouch 2x(pistol,magazine,general)"
	contains = list(
		/obj/item/storage/pouch/magazine/large,
		/obj/item/storage/pouch/magazine/large,
		/obj/item/storage/pouch/magazine/pistol/large,
		/obj/item/storage/pouch/magazine/pistol/large,
		/obj/item/storage/pouch/general/large,
		/obj/item/storage/pouch/general/large,
	)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Large Pouch"
	group = "Clothing"

/datum/supply_packs/pouches_medical
	name = "Combat medical pouches crate (6x autoinjector)"
	contains = list(
		/obj/item/storage/pouch/autoinjector,
		/obj/item/storage/pouch/autoinjector,
		/obj/item/storage/pouch/autoinjector,
		/obj/item/storage/pouch/autoinjector,
		/obj/item/storage/pouch/autoinjector,
		/obj/item/storage/pouch/autoinjector,
	)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "medical pouches crate"
	group = "Clothing"

//---------------------------------------------
//HOLSTERS & WEBBING BELOW THIS LINE
//---------------------------------------------

/datum/supply_packs/webbing_brown_black
	name = "Brown And Black Webbing Crate (x6)"
	contains = list(
		/obj/item/clothing/accessory/storage/black_vest/brown_vest,
		/obj/item/clothing/accessory/storage/black_vest/brown_vest,
		/obj/item/clothing/accessory/storage/black_vest/brown_vest,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/clothing/accessory/storage/black_vest,
	)
	cost = 10
	containertype = /obj/structure/closet/crate/green
	containername = "Brown And Black Webbing Crate"
	group = "Clothing"

/datum/supply_packs/webbing_large
	name = "Ammo Webbing Crate (x6)"
	contains = list(
		/obj/item/clothing/accessory/storage/webbing,
		/obj/item/clothing/accessory/storage/webbing,
		/obj/item/clothing/accessory/storage/webbing,
		/obj/item/clothing/accessory/storage/webbing,
		/obj/item/clothing/accessory/storage/webbing,
		/obj/item/clothing/accessory/storage/webbing,
	)
	cost = 10
	containertype = /obj/structure/closet/crate/green
	containername = "Webbing Crate"
	group = "Clothing"

/datum/supply_packs/drop_pouches
	name = "Drop Pouch Crate (x6)"
	contains = list(
		/obj/item/clothing/accessory/storage/droppouch,
		/obj/item/clothing/accessory/storage/droppouch,
		/obj/item/clothing/accessory/storage/droppouch,
		/obj/item/clothing/accessory/storage/droppouch,
		/obj/item/clothing/accessory/storage/droppouch,
		/obj/item/clothing/accessory/storage/droppouch,
	)
	cost = 10
	containertype = /obj/structure/closet/crate/green
	containername = "Drop Pouch Crate"
	group = "Clothing"


/datum/supply_packs/webbing_knives//for the lulz
	name = "Knife Vest Crate (x3)"
	contains = list(
		/obj/item/clothing/accessory/storage/knifeharness,//old unathi knife harness updated for our needs
		/obj/item/clothing/accessory/storage/knifeharness,
		/obj/item/clothing/accessory/storage/knifeharness,
	)
	cost = 10
	containertype = /obj/structure/closet/crate/green
	containername = "Knife Vest Crate"
	group = "Clothing"

/datum/supply_packs/webbing_holster
	name = "Shoulder Holster Crate (x4)"
	contains = list(
		/obj/item/clothing/accessory/storage/holster,
		/obj/item/clothing/accessory/storage/holster,
		/obj/item/clothing/accessory/storage/holster,
		/obj/item/clothing/accessory/storage/holster,
	)
	cost = 10
	containertype = /obj/structure/closet/crate/green
	containername = "Shoulder Holster Crate"
	group = "Clothing"

/datum/supply_packs/officer_outfits//up to date :)
	name = "officer outfit crate(x1 each)"
	contains = list(
		/obj/item/clothing/under/rank/qm_suit,
		/obj/item/clothing/under/marine/officer/warrant,
		/obj/item/clothing/under/marine/chef,
		/obj/item/clothing/under/marine/officer/command,
		/obj/item/clothing/under/marine/officer/command,
		/obj/item/clothing/under/marine/officer/ce,
	)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "officer dress crate"
	group = "Clothing"

/datum/supply_packs/marine_formal_outfits
	name = "Formal Marine outfit crate(x6)"
	contains = list(
		/obj/item/clothing/under/marine/dress,
		/obj/item/clothing/under/marine/dress,
		/obj/item/clothing/under/marine/dress,
		/obj/item/clothing/under/marine/dress,
		/obj/item/clothing/under/marine/dress,
		/obj/item/clothing/under/marine/dress,
	)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "officer dress crate"
	group = "Clothing"

/datum/supply_packs/officer_formal_outfits
	name = "Formal officer outfit crate(x6)"
	contains = list(
		/obj/item/clothing/under/marine/dress/command,
		/obj/item/clothing/under/marine/dress/command,
		/obj/item/clothing/under/marine/dress/command,
		/obj/item/clothing/under/marine/dress/command,
		/obj/item/clothing/under/marine/dress/command,
		/obj/item/clothing/under/marine/dress/command,
	)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "officer dress crate"
	group = "Clothing"
