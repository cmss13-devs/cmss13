//*******************************************************************************
//SUPPLIES
//*******************************************************************************/

/datum/supply_packs/evacuation
	name = "emergency equipment (x2 toolbox, x2 hazard vest, x5 oxygen tank, x5 masks)"
	contains = list(
		/obj/item/storage/toolbox/emergency,
		/obj/item/storage/toolbox/emergency,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tank/emergency_oxygen,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/mask/gas,
	)
	cost = 20
	buyable = FALSE // TODO : remake this into a proper evac kit that can be ordered once per round.
	containertype = /obj/structure/closet/crate/internals
	containername = "emergency crate"
	group = "Supplies"

/datum/supply_packs/janitor
	name = "assorted janitorial supplies"
	contains = list(
		/obj/item/reagent_container/glass/bucket,
		/obj/item/reagent_container/glass/bucket,
		/obj/item/reagent_container/glass/bucket,
		/obj/item/tool/mop,
		/obj/item/tool/wet_sign,
		/obj/item/tool/wet_sign,
		/obj/item/tool/wet_sign,
		/obj/item/storage/bag/trash,
		/obj/item/reagent_container/spray/cleaner,
		/obj/item/reagent_container/glass/rag,
		/obj/item/explosive/grenade/custom/cleaner,
		/obj/item/explosive/grenade/custom/cleaner,
		/obj/item/explosive/grenade/custom/cleaner,
		/obj/item/reagent_container/glass/bucket/mopbucket,
		/obj/item/paper/janitor,
	)
	cost = 7
	containertype = /obj/structure/closet/crate/supply
	containername = "\improper Janitorial supplies crate"
	group = "Supplies"

/datum/supply_packs/poster
	name = "posters"
	contains = list(
		/obj/item/poster,
		/obj/item/poster,
		/obj/item/poster,
		/obj/item/poster,
		/obj/item/poster,
	)
	cost = 4
	containertype = /obj/structure/closet/crate/supply
	containername = "\improper posters crate"
	group = "Supplies"

/datum/supply_packs/crayons
	name = "boxes of crayons"
	contains = list(
		/obj/item/storage/fancy/crayons,
		/obj/item/storage/fancy/crayons,
		/obj/item/storage/fancy/crayons,
		/obj/item/storage/fancy/crayons,
		/obj/item/storage/fancy/crayons,
	)
	cost = 50
	containertype = /obj/structure/closet/crate/supply
	containername = "\improper crayons crate"
	group = "Supplies"

/datum/supply_packs/presents
	name = "assorted presents"
	contains = list(
		/obj/item/a_gift,
		/obj/item/a_gift,
		/obj/item/a_gift,
		/obj/item/a_gift,
		/obj/item/a_gift,
	)
	cost = 10
	containertype = /obj/structure/closet/crate/supply
	containername = "\improper crate of presents"
	group = "Supplies"

/datum/supply_packs/wrapping_supplies
	name = "wrapping supplies"
	contains = list(
		/obj/item/wrapping_paper,
		/obj/item/wrapping_paper,
		/obj/item/wrapping_paper,
		/obj/item/wrapping_paper,
		/obj/item/tool/wirecutters,
		/obj/item/tool/wirecutters,
	)
	cost = 6
	containertype = /obj/structure/closet/crate/supply
	containername = "\improper wrapping supplies crate"
	group = "Supplies"
