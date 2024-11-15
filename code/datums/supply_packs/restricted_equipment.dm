// here they will be all the Equipment that are restricted to a role/job.

/datum/supply_packs/armor_leader
	name = "B12 pattern marine armor crate (x1 helmet, x1 armor)"
	contains = list(
		/obj/item/clothing/head/helmet/marine/leader,
		/obj/item/clothing/suit/storage/marine/medium/leader,
	)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "B12 pattern marine armor crate"
	group = "Restricted Equipment"

/datum/supply_packs/armor_tl
	name = "M4 pattern marine armor crate (x1 helmet, x1 armor)"
	contains = list(
		/obj/item/clothing/head/helmet/marine/rto,
		/obj/item/clothing/suit/storage/marine/medium/rto,
	)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "M4 pattern marine armor crate"
	group = "Restricted Equipment"

/datum/supply_packs/intel_kit
	name = "Field Intelligence Support Kit crate (x1 fulton pack, x1 data detector, x1 intel pamphlet, x1 large document pouch, 1x intel radio key)"
	contains = list(
		/obj/item/storage/box/kit/mini_intel,
	)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Field Intelligence Support Kit crate"
	group = "Restricted Equipment"

/datum/supply_packs/jtac_kit
	name = "JTAC Radio Kit crate (x1 full flare gun belt, x2 M89-S signal flare packs, 1x laser designator, 1x jtac radio key, 1x radiopack)"
	contains = list(
		/obj/item/storage/box/kit/mini_jtac,
	)
	cost = 30
	containertype = /obj/structure/closet/crate
	containername = "JTAC Radio Kit crate"
	group = "Restricted Equipment"
