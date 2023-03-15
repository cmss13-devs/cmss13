// here they will be all the Equipment that are restricted to a role/job.

/datum/supply_packs/armor_leader
	name = "B12 pattern marine armor crate (x1 helmet, x1 armor)"
	contains = list(
		/obj/item/clothing/head/helmet/marine/leader,
		/obj/item/clothing/suit/storage/marine/leader,
	)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "B12 pattern marine armor crate"
	group = "Restricted Equipment"

/datum/supply_packs/armor_rto
	name = "M4 pattern marine armor crate (x1 helmet, x1 armor)"
	contains = list(
		/obj/item/clothing/head/helmet/marine/rto,
		/obj/item/clothing/suit/storage/marine/rto,
	)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "M4 pattern marine armor crate"
	group = "Restricted Equipment"
