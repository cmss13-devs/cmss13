/datum/supply_packs/bodybag
	name = "body bag crate (x28)"
	contains = list(
			/obj/item/storage/box/bodybags,
			/obj/item/storage/box/bodybags,
			/obj/item/storage/box/bodybags,
			/obj/item/storage/box/bodybags
			)
	cost = 20
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
	cost = 40
	containertype = /obj/structure/closet/crate/medical
	containername = "stasis bag crate"
	group = "Medical"

/datum/supply_packs/surgery
	name = "surgery crate (All the items to do surgery )"
	contains = list(
					/obj/item/storage/surgical_tray,
					/obj/item/clothing/mask/breath/medical,
					/obj/item/tank/anesthetic,
					/obj/item/clothing/under/rank/medical/green,
					/obj/item/storage/box/masks,
					/obj/item/storage/box/gloves
					)
	cost = 30
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
