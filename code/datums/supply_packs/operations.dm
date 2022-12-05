//the idea is to put all the bulk items scanner secure crate with lot's of flares MRE in it and at the end OB and non buyable.

//large quantity of metals/sandbags/plasteel.x5 the normal crate and with a 10% discount

/datum/supply_packs/metalsheetbulk
	name = "metal sheets(x250)"
	contains = list(
					/obj/item/stack/sheet/metal/large_stack,
					/obj/item/stack/sheet/metal/large_stack,
					/obj/item/stack/sheet/metal/large_stack,
					/obj/item/stack/sheet/metal/large_stack,
					/obj/item/stack/sheet/metal/large_stack,
					)
	cost = 90
	containertype = /obj/structure/largecrate
	containername = "metal sheets crate (x250)"
	group = "Operations"

/datum/supply_packs/plasteelsheetbulk
	name = "plasteel sheets (x200)"
	contains = list(
					/obj/item/stack/sheet/plasteel/med_large_stack,
					/obj/item/stack/sheet/plasteel/med_large_stack,
					/obj/item/stack/sheet/plasteel/med_large_stack,
					/obj/item/stack/sheet/plasteel/med_large_stack,
					/obj/item/stack/sheet/plasteel/med_large_stack,
					)
	cost = 135
	containertype = /obj/structure/largecrate
	containername = "plasteel sheets crate (x200)"
	group = "Operations"

/datum/supply_packs/sandbagbulk
	name = "sandbag crate (x250)"
	contains = list(
					/obj/item/stack/sandbags_empty/full,
					/obj/item/stack/sandbags_empty/full,
					/obj/item/stack/sandbags_empty/full,
					/obj/item/stack/sandbags_empty/full,
					/obj/item/stack/sandbags_empty/full,
					)
	cost = 135
	containertype = /obj/structure/largecrate
	containername = "sandbag crate(x250)"
	group = "Operations"

//Supplies in large quantity.

/datum/supply_packs/floodlight
	name = "floodlight crate (x4)"
	contains = list(
					/obj/structure/machinery/floodlight,
					/obj/structure/machinery/floodlight,
					/obj/structure/machinery/floodlight,
					/obj/structure/machinery/floodlight,
					)
	cost = 20
	containertype = /obj/structure/largecrate
	containername = "floodlights crate"
	group = "Operations"

/datum/supply_packs/powerloader
	name = "powerloader crate"
	contains = list(
					/obj/vehicle/powerloader,
					/obj/item/pamphlet/skill/powerloader,
					)
	cost = 20
	containertype = /obj/structure/largecrate
	containername = "powerloader crate"
	group = "Operations"

/datum/supply_packs/mre
	name = "USCM MRE crate (x60)"
	contains = list(
					/obj/item/ammo_box/magazine/misc/mre,
					/obj/item/ammo_box/magazine/misc/mre,
					/obj/item/ammo_box/magazine/misc/mre,
					/obj/item/ammo_box/magazine/misc/mre,
					/obj/item/ammo_box/magazine/misc/mre,
					)
	cost = 20
	containertype = /obj/structure/largecrate
	containername = "\improper USCM MRE crate (x60)"
	group = "Operations"

/datum/supply_packs/flares
	name = "Flare supply crate (x200)"
	contains = list(
					/obj/item/ammo_box/magazine/misc/flares,
					/obj/item/ammo_box/magazine/misc/flares,
					)
	cost = 20
	containertype = /obj/structure/largecrate
	containername = "Flare supply crate (x200)"
	group = "Operations"

/datum/supply_packs/ob_incendiary
	contains = list(
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/warhead/incendiary,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/warhead/incendiary,
	)

	name = "OB Incendiary Crate"
	cost = 0
	containertype = /obj/structure/closet/crate/secure/ob
	containername = "OB Ammo Crate (Incendiary x2)"
	buyable = 0
	group = "Operations"
	iteration_needed = null

/datum/supply_packs/ob_explosive
	contains = list(
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/warhead/explosive,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/warhead/explosive,
	)

	name = "OB HE Crate"
	cost = 0
	containertype = /obj/structure/closet/crate/secure/ob
	containername = "OB Ammo Crate (HE x2)"
	buyable = 0
	group = "Operations"
	iteration_needed = null

/datum/supply_packs/ob_cluster
	contains = list(
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/warhead/cluster,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/warhead/cluster,
	)

	name = "OB Cluster Crate"
	cost = 0
	containertype = /obj/structure/closet/crate/secure/ob
	containername = "OB Ammo Crate (Cluster x2)"
	buyable = 0
	group = "Operations"
	iteration_needed = null

/datum/supply_packs/telecommsparts
	name = "Replacement Telecommunications Parts"
	contains = list(
		/obj/item/circuitboard/machine/telecomms/relay/tower,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/subspace/filter,
		/obj/item/stock_parts/subspace/filter,
		/obj/item/cell,
		/obj/item/cell,
		/obj/item/stack/cable_coil,
		/obj/item/stack/cable_coil
					)
	cost = 40
	containertype = /obj/structure/closet/crate/supply
	buyable = 0
	containername = "replacement telecommunications crate"
	group = "Operations"

/datum/supply_packs/nuclearbomb
	name = "Operational Nuke"
	cost = 0
	containertype = /obj/structure/machinery/nuclearbomb
	buyable = 0
	group = "Operations"
	iteration_needed = null

/datum/supply_packs/spec_kits
	name = "Weapons Specialist Kits"
	contains = list(
		/obj/item/spec_kit/asrs,
		/obj/item/spec_kit/asrs,
		/obj/item/spec_kit/asrs,
		/obj/item/spec_kit/asrs
	)
	cost = 0
	containertype = /obj/structure/closet/crate/supply
	containername = "weapons specialist kits crate"
	buyable = 0
	group = "Operations"
	iteration_needed = null
