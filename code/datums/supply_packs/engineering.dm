//*******************************************************************************
//ENGINEERING
//*******************************************************************************/


/datum/supply_packs/sandbags
	name = "empty sandbags crate (x50)"
	contains = list(/obj/item/stack/sandbags_empty/full)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/supply
	containername = "empty sandbags crate"
	group = "Engineering"


/datum/supply_packs/sandbagskit
	name = "sandbags construction kit (sandbags x50, etool x2)"
	contains = list(
					/obj/item/stack/sandbags_empty/full,
					/obj/item/tool/shovel/etool,
					/obj/item/tool/shovel/etool)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/supply
	containername = "sandbags construction kit"
	group = "Engineering"

/datum/supply_packs/metal
	name = "metal sheets (x50)"
	contains = list(/obj/item/stack/sheet/metal/large_stack)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/supply
	containername = "metal sheets crate"
	group = "Engineering"

/datum/supply_packs/plas
	name = "plasteel sheets (x40)"
	contains = list(/obj/item/stack/sheet/plasteel/med_large_stack)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/supply
	containername = "plasteel sheets crate"
	group = "Engineering"

/datum/supply_packs/glass
	name = "glass sheets (x50)"
	contains = list(/obj/item/stack/sheet/glass/large_stack)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/supply
	containername = "glass sheets crate"
	group = "Engineering"

/datum/supply_packs/wood50
	name = "wooden planks (x50)"
	contains = list(/obj/item/stack/sheet/wood/large_stack)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/supply
	containername = "wooden planks crate"
	group = "Engineering"

/datum/supply_packs/folding_barricades
	contains = list(
					/obj/item/stack/folding_barricade/three
					)
	name = "Folding Barricades (x3)"
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/supply
	containername = "\improper folding barricades crate"
	group = "Engineering"

/datum/supply_packs/binocs
	name = "Mixed Binoculars Crate (x2 per, x6 total)"
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/green
	containername = "Mixed Binoculars Crate"
	group = "Engineering"
	contains = list(
		/obj/item/device/binoculars/range/designator,
		/obj/item/device/binoculars/range/designator,
		/obj/item/device/binoculars/range,
		/obj/item/device/binoculars/range,
		/obj/item/device/binoculars,
		/obj/item/device/binoculars
	)

/datum/supply_packs/smescoil
	name = "superconducting magnetic coil crate (x1)"
	contains = list(/obj/item/stock_parts/smes_coil)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/construction
	containername = "superconducting magnetic coil crate"
	group = "Engineering"

/datum/supply_packs/electrical
	name = "electrical maintenance crate (toolbox x2, insulated x2, cell x2, hi-cap cell x2)"
	contains = list(
					/obj/item/storage/toolbox/electrical,
					/obj/item/storage/toolbox/electrical,
					/obj/item/clothing/gloves/yellow,
					/obj/item/clothing/gloves/yellow,
					/obj/item/cell,
					/obj/item/cell,
					/obj/item/cell/high,
					/obj/item/cell/high
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/construction
	containername = "electrical maintenance crate"
	group = "Engineering"

/datum/supply_packs/mechanical
	name = "mechanical maintenance crate (utility belt x3, hazard vest x3, welding helmet x2, hard hat x1)"
	contains = list(
					/obj/item/storage/belt/utility/full,
					/obj/item/storage/belt/utility/full,
					/obj/item/storage/belt/utility/full,
					/obj/item/clothing/suit/storage/hazardvest,
					/obj/item/clothing/suit/storage/hazardvest,
					/obj/item/clothing/suit/storage/hazardvest,
					/obj/item/clothing/head/welding,
					/obj/item/clothing/head/welding,
					/obj/item/clothing/head/hardhat
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/construction
	containername = "mechanical maintenance crate"
	group = "Engineering"

/datum/supply_packs/fueltank
	name = "fuel tank crate (x1)"
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/largecrate
	containername = "fuel tank crate"
	group = "Engineering"

/datum/supply_packs/inflatable
	name = "inflatable barriers (x9 doors, x12 walls)"
	contains = list(
					/obj/item/storage/briefcase/inflatable,
					/obj/item/storage/briefcase/inflatable,
					/obj/item/storage/briefcase/inflatable
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/construction
	containername = "inflatable barriers crate"
	group = "Engineering"

/datum/supply_packs/lightbulbs
	name = "replacement lights (x42 tube, x21 bulb)"
	contains = list(
					/obj/item/storage/box/lights/mixed,
					/obj/item/storage/box/lights/mixed,
					/obj/item/storage/box/lights/mixed
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/supply
	containername = "replacement lights crate"
	group = "Engineering"

/datum/supply_packs/pacman_parts
	name = "P.A.C.M.A.N. portable generator parts"
	contains = list(
				/obj/item/stock_parts/micro_laser,
				/obj/item/stock_parts/capacitor,
				/obj/item/stock_parts/matter_bin,
				/obj/item/circuitboard/machine/pacman
				)
	cost = RO_PRICE_CHEAP
	containername = "\improper P.A.C.M.A.N. portable generator construction kit"
	containertype = /obj/structure/closet/crate/secure
	group = "Engineering"


/datum/supply_packs/super_pacman_parts
	name = "Super P.A.C.M.A.N. portable generator parts"
	cost = RO_PRICE_NORMAL
	containername = "\improper Super P.A.C.M.A.N. portable generator construction kit"
	containertype = /obj/structure/closet/crate/secure
	group = "Engineering"
	contains = list(
					/obj/item/stock_parts/micro_laser,
					/obj/item/stock_parts/capacitor,
					/obj/item/stock_parts/matter_bin,
					/obj/item/circuitboard/machine/pacman/super
					)
