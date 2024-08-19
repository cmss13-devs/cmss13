/datum/supply_packs/sandbags
	name = "empty sandbags crate (x50)"
	contains = list(/obj/item/stack/sandbags_empty/full)
	cost = 20
	containertype = /obj/structure/closet/crate/supply
	containername = "empty sandbags crate"
	group = "UPP Engineering"

/datum/supply_packs/sandbagskit
	name = "sandbags construction kit (sandbags x50, etool x2)"
	contains = list(
		/obj/item/stack/sandbags_empty/full,
		/obj/item/tool/shovel/etool,
		/obj/item/tool/shovel/etool,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/supply
	containername = "sandbags construction kit"
	group = "UPP Engineering"

/datum/supply_packs/metal
	name = "metal sheets (x50)"
	contains = list(/obj/item/stack/sheet/metal/large_stack)
	cost = 20
	containertype = /obj/structure/closet/crate/supply
	containername = "metal sheets crate"
	group = "UPP Engineering"

/datum/supply_packs/plas
	name = "plasteel sheets (x40)"
	contains = list(/obj/item/stack/sheet/plasteel/med_large_stack)
	cost = 30
	containertype = /obj/structure/closet/crate/supply
	containername = "plasteel sheets crate"
	group = "UPP Engineering"

/datum/supply_packs/glass
	name = "glass sheets (x50)"
	contains = list(/obj/item/stack/sheet/glass/large_stack)
	cost = 20
	containertype = /obj/structure/closet/crate/supply
	containername = "glass sheets crate"
	group = "UPP Engineering"

/datum/supply_packs/wood50
	name = "wooden planks (x50)"
	contains = list(/obj/item/stack/sheet/wood/large_stack)
	cost = 20
	containertype = /obj/structure/closet/crate/supply
	containername = "wooden planks crate"
	group = "UPP Engineering"

/datum/supply_packs/folding_barricades
	contains = list(
		/obj/item/stack/folding_barricade/three,
	)
	name = "Folding Barricades (x3)"
	cost = 20
	containertype = /obj/structure/closet/crate/supply
	containername = "folding barricades crate"
	group = "UPP Engineering"

/datum/supply_packs/smescoil
	name = "superconducting magnetic coil crate (x1)"
	contains = list(/obj/item/stock_parts/smes_coil)
	cost = 30
	containertype = /obj/structure/closet/crate/construction
	containername = "superconducting magnetic coil crate"
	group = "UPP Engineering"

/datum/supply_packs/flashlights
	name = "Flashlights (x8)"
	contains = list(
		/obj/item/ammo_box/magazine/misc/flashlight,
	)
	cost = 10
	containertype = /obj/structure/closet/crate/supply
	containername = "flashlights crate"
	group = "UPP Engineering"

/datum/supply_packs/batteries
	name = "High-Capacity Power Cells (x8)"
	contains = list(
		/obj/item/ammo_box/magazine/misc/power_cell,
	)
	cost = 10
	containertype = /obj/structure/closet/crate/supply
	containername = "battery crate"
	group = "UPP Engineering"
