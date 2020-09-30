/*******************************************************************************
ENGINEERING
*******************************************************************************/


/datum/supply_packs/sandbags
	name = "empty sandbags crate (x50)"
	contains = list(/obj/item/stack/sandbags_empty)
	amount = 50
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

/datum/supply_packs/metal50
	name = "50 metal sheets (x50)"
	contains = list(/obj/item/stack/sheet/metal)
	amount = 50
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/supply
	containername = "metal sheets crate"
	group = "Engineering"


/datum/supply_packs/plas50
	name = "plasteel sheets (x30)"
	contains = list(/obj/item/stack/sheet/plasteel)
	amount = 30
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/supply
	containername = "plasteel sheets crate"
	group = "Engineering"


/datum/supply_packs/glass50
	name = "50 glass sheets (x50)"
	contains = list(/obj/item/stack/sheet/glass)
	amount = 50
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/supply
	containername = "glass sheets crate"
	group = "Engineering"

/datum/supply_packs/wood50
	name = "wooden planks (x50)"
	contains = list(/obj/item/stack/sheet/wood)
	amount = 50
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/supply
	containername = "wooden planks crate"
	group = "Engineering"

/datum/supply_packs/folding_barricades
	contains = list(
					/obj/item/folding_barricade,
					/obj/item/folding_barricade,
					/obj/item/folding_barricade,
					/obj/item/folding_barricade
					)
	name = "Folding Barricades (x4)"
	cost = RO_PRICE_VERY_PRICY
	containertype = /obj/structure/closet/crate/supply
	containername = "\improper folding barricades crate"
	group = "Engineering"

/datum/supply_packs/smescoil
	name = "superconducting magnetic coil crate (x1)"
	contains = list(/obj/item/stock_parts/smes_coil)
	cost = RO_PRICE_PRICY
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