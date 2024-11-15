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
		/obj/item/storage/pill_bottle/peridaxon,
		/obj/item/storage/box/pillbottles,
	)
	cost = 15
	containertype = /obj/structure/closet/crate/medical
	containername = "medical crate"
	group = "Medical"

/datum/supply_packs/medical_restock_cart
	name = "medical restock cart"
	contains = list(
		/obj/structure/restock_cart/medical,
	)
	cost = 20
	containertype = null
	containername = "medical restock cart"
	group = "Medical"

/datum/supply_packs/medical_reagent_cart
	name = "medical reagent restock cart"
	contains = list(
		/obj/structure/restock_cart/medical/reagent,
	)
	cost = 20
	containertype = null
	containername = "medical reagent restock cart"
	group = "Medical"

/datum/supply_packs/pillbottle
	name = "pill bottle crate (x2 each)"
	contains = list(
		/obj/item/storage/pill_bottle/inaprovaline,
		/obj/item/storage/pill_bottle/antitox,
		/obj/item/storage/pill_bottle/bicaridine,
		/obj/item/storage/pill_bottle/dexalin,
		/obj/item/storage/pill_bottle/kelotane,
		/obj/item/storage/pill_bottle/tramadol,
		/obj/item/storage/pill_bottle/peridaxon,
		/obj/item/storage/pill_bottle/inaprovaline,
		/obj/item/storage/pill_bottle/antitox,
		/obj/item/storage/pill_bottle/bicaridine,
		/obj/item/storage/pill_bottle/dexalin,
		/obj/item/storage/pill_bottle/kelotane,
		/obj/item/storage/pill_bottle/tramadol,
		/obj/item/storage/pill_bottle/peridaxon,
		/obj/item/storage/box/pillbottles,
		/obj/item/storage/box/pillbottles,
	)
	cost = 15
	containertype = /obj/structure/closet/crate/medical
	containername = "medical crate"
	group = "Medical"

/datum/supply_packs/firstaid
	name = "first aid kit crate (x2 each)"
	contains = list(
		/obj/item/storage/firstaid/regular,
		/obj/item/storage/firstaid/regular,
		/obj/item/storage/firstaid/fire,
		/obj/item/storage/firstaid/fire,
		/obj/item/storage/firstaid/toxin,
		/obj/item/storage/firstaid/toxin,
		/obj/item/storage/firstaid/o2,
		/obj/item/storage/firstaid/o2,
		/obj/item/storage/firstaid/adv,
		/obj/item/storage/firstaid/adv,
	)
	cost = 11
	containertype = /obj/structure/closet/crate/medical
	containername = "medical crate"
	group = "Medical"

/datum/supply_packs/bodybag
	name = "body bag crate (x28)"
	contains = list(
		/obj/item/storage/box/bodybags,
		/obj/item/storage/box/bodybags,
		/obj/item/storage/box/bodybags,
		/obj/item/storage/box/bodybags,
	)
	cost = 7
	containertype = /obj/structure/closet/crate/medical
	containername = "body bag crate"
	group = "Medical"

/datum/supply_packs/cryobag
	name = "stasis bag crate (x3)"
	contains = list(
		/obj/item/bodybag/cryobag,
		/obj/item/bodybag/cryobag,
		/obj/item/bodybag/cryobag,
	)
	cost = 15
	containertype = /obj/structure/closet/crate/medical
	containername = "stasis bag crate"
	group = "Medical"

/datum/supply_packs/surgery
	name = "surgery crate(tray,anesthetic,surgeon gear)"
	contains = list(
		/obj/item/storage/surgical_tray,
		/obj/item/clothing/mask/breath/medical,
		/obj/item/tank/anesthetic,
		/obj/item/clothing/under/rank/medical/green,
		/obj/item/storage/box/masks,
		/obj/item/storage/box/gloves,
	)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/surgery
	containername = "surgery crate"
	access = ACCESS_MARINE_MEDBAY
	group = "Medical"

/datum/supply_packs/upgraded_medical_kits
	name = "upgraded medical equipment crate (x4)"
	contains = list(
		/obj/item/storage/box/czsp/medic_upgraded_kits,
		/obj/item/storage/box/czsp/medic_upgraded_kits,
		/obj/item/storage/box/czsp/medic_upgraded_kits,
		/obj/item/storage/box/czsp/medic_upgraded_kits,
	)
	cost = 0
	buyable = FALSE
	containertype = /obj/structure/closet/crate/medical
	containername = "upgraded medical equipment crate"
	group = "Medical"
