//*******************************************************************************
//MEDICAL
//*******************************************************************************/


/datum/supply_packs/medical
	name = "medical crate"
	contains = list(
					/obj/item/storage/box/syringes,
					/obj/item/reagent_container/glass/bottle/inaprovaline,
					/obj/item/reagent_container/glass/bottle/antitoxin,
					/obj/item/reagent_container/glass/bottle/bicaridine,
					/obj/item/reagent_container/glass/bottle/dexalin,
					/obj/item/reagent_container/glass/bottle/kelotane,
					/obj/item/reagent_container/glass/bottle/tramadol,
					/obj/item/storage/pill_bottle/inaprovaline,
					/obj/item/storage/pill_bottle/antitox,
					/obj/item/storage/pill_bottle/bicaridine,
					/obj/item/storage/pill_bottle/dexalin,
					/obj/item/storage/pill_bottle/kelotane,
					/obj/item/storage/pill_bottle/tramadol,
					/obj/item/storage/pill_bottle/quickclot,
					/obj/item/storage/pill_bottle/peridaxon,
					/obj/item/storage/box/pillbottles
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/medical
	containername = "medical crate"
	group = "Medical"

/datum/supply_packs/firstaid
	name = "first aid kit crate (2x each)"
	contains = list(/obj/item/storage/firstaid/regular,
					/obj/item/storage/firstaid/regular,
					/obj/item/storage/firstaid/fire,
					/obj/item/storage/firstaid/fire,
					/obj/item/storage/firstaid/toxin,
					/obj/item/storage/firstaid/toxin,
					/obj/item/storage/firstaid/o2,
					/obj/item/storage/firstaid/o2,
					/obj/item/storage/firstaid/adv,
					/obj/item/storage/firstaid/adv
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/medical
	containername = "medical crate"
	group = "Medical"

/datum/supply_packs/bodybag
	name = "body bag crate (x28)"
	contains = list(
			/obj/item/storage/box/bodybags,
			/obj/item/storage/box/bodybags,
			/obj/item/storage/box/bodybags,
			/obj/item/storage/box/bodybags
			)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/medical
	containername = "body bag crate"
	group = "Medical"

/datum/supply_packs/cryobag
	name = "stasis bag crate (x3)"
	contains = list(
			/obj/item/bodybag/cryobag,
			/obj/item/bodybag/cryobag,
			/obj/item/bodybag/cryobag
			)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/medical
	containername = "stasis bag crate"
	group = "Medical"

/datum/supply_packs/surgery
	name = "surgery crate (x2 surgical trays)"
	contains = list(
					/obj/item/storage/surgical_tray,
					/obj/item/storage/surgical_tray
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/secure/surgery
	containername = "surgery crate"
	access = ACCESS_MARINE_MEDBAY
	group = "Medical"

/datum/supply_packs/anesthetic
	name = "anesthetic crate (x4 masks, x4 tanks)"
	contains = list(
					/obj/item/clothing/mask/breath/medical,
					/obj/item/clothing/mask/breath/medical,
					/obj/item/clothing/mask/breath/medical,
					/obj/item/clothing/mask/breath/medical,
					/obj/item/tank/anesthetic,
					/obj/item/tank/anesthetic,
					/obj/item/tank/anesthetic,
					/obj/item/tank/anesthetic
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/secure/surgery
	containername = "surgery crate"
	access = ACCESS_MARINE_MEDBAY
	group = "Medical"

/datum/supply_packs/sterile
	name = "sterile equipment crate"
	contains = list(
					/obj/item/clothing/under/rank/medical/green,
					/obj/item/clothing/under/rank/medical/green,
					/obj/item/storage/box/masks,
					/obj/item/storage/box/gloves
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/medical
	containername = "sterile equipment crate"
	group = "Medical"
