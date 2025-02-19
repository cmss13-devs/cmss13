/datum/supply_packs/upp/sandbags_upp
	name = "empty sandbags crate (x50)"
	contains = list(/obj/item/stack/sandbags_empty/full)
	cost = 20
	containertype = /obj/structure/closet/crate/supply
	containername = "empty sandbags crate"
	group = "UPP Engineering"

/datum/supply_packs/upp/sandbagskit_upp
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

/datum/supply_packs/upp/metal_upp
	name = "metal sheets (x50)"
	contains = list(/obj/item/stack/sheet/metal/large_stack)
	cost = 20
	containertype = /obj/structure/closet/crate/supply
	containername = "metal sheets crate"
	group = "UPP Engineering"

/datum/supply_packs/upp/plas_upp
	name = "plasteel sheets (x40)"
	contains = list(/obj/item/stack/sheet/plasteel/med_large_stack)
	cost = 30
	containertype = /obj/structure/closet/crate/supply
	containername = "plasteel sheets crate"
	group = "UPP Engineering"

/datum/supply_packs/upp/glass_upp
	name = "glass sheets (x50)"
	contains = list(/obj/item/stack/sheet/glass/large_stack)
	cost = 20
	containertype = /obj/structure/closet/crate/supply
	containername = "glass sheets crate"
	group = "UPP Engineering"

/datum/supply_packs/upp/wood50_upp
	name = "wooden planks (x50)"
	contains = list(/obj/item/stack/sheet/wood/large_stack)
	cost = 20
	containertype = /obj/structure/closet/crate/supply
	containername = "wooden planks crate"
	group = "UPP Engineering"

/datum/supply_packs/upp/folding_barricades_upp
	contains = list(
		/obj/item/stack/folding_barricade/three,
	)
	name = "Folding Barricades (x3)"
	cost = 20
	containertype = /obj/structure/closet/crate/supply
	containername = "folding barricades crate"
	group = "UPP Engineering"

/datum/supply_packs/upp/smescoil_upp
	name = "superconducting magnetic coil crate (x1)"
	contains = list(/obj/item/stock_parts/smes_coil)
	cost = 30
	containertype = /obj/structure/closet/crate/construction
	containername = "superconducting magnetic coil crate"
	group = "UPP Engineering"

/datum/supply_packs/upp/flashlights_upp
	name = "Flashlights (x8)"
	contains = list(
		/obj/item/ammo_box/magazine/misc/flashlight,
	)
	cost = 10
	containertype = /obj/structure/closet/crate/supply
	containername = "flashlights crate"
	group = "UPP Engineering"

/datum/supply_packs/upp/batteries_upp
	name = "High-Capacity Power Cells (x8)"
	contains = list(
		/obj/item/ammo_box/magazine/misc/power_cell,
	)
	cost = 10
	containertype = /obj/structure/closet/crate/supply
	containername = "battery crate"
	group = "UPP Engineering"
