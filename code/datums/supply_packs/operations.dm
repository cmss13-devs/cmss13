//large item crates

/datum/supply_packs/powerloader
	name = "powerloader crate"
	contains = list(
					/obj/vehicle/powerloader,
					/obj/item/pamphlet/skill/powerloader,
					)
	cost = 25
	containertype = /obj/structure/largecrate
	containername = "\improper Powerloader Crate"
	group = "Operations"

/datum/supply_packs/bulk_mre
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
	containername = "\improper USCM MRE Crate (x60)"
	group = "Operations"

/datum/supply_packs/bulk_flares
	name = "Flare supply crate (x200)"
	contains = list(
					/obj/item/ammo_box/magazine/misc/flares,
					/obj/item/ammo_box/magazine/misc/flares,
					)
	cost = 20
	containertype = /obj/structure/largecrate
	containername = "\improper Flare Supply Crate (x200)"
	group = "Operations"

//can't buy them crate for staff to spawn in events.

/datum/supply_packs/staff
	cost = 0
	buyable = 0
	iteration_needed = null

/datum/supply_packs/staff/ob_incendiary
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
	containertype = /obj/structure/closet/crate/secure/ob
	containername = "\improper OB Ammo Crate (Incendiary x2)"
	group = "Operations"

/datum/supply_packs/staff/ob_explosive
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
	containertype = /obj/structure/closet/crate/secure/ob
	containername = "\improper OB Ammo Crate (HE x2)"
	group = "Operations"

/datum/supply_packs/staff/ob_cluster
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
	containertype = /obj/structure/closet/crate/secure/ob
	containername = "\improper OB Ammo Crate (Cluster x2)"
	group = "Operations"

/datum/supply_packs/staff/telecommsparts
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
	containertype = /obj/structure/closet/crate/supply
	containername = "\improper Replacement Telecommunications Crate"
	group = "Operations"

/datum/supply_packs/staff/nuclearbomb
	name = "Operational Nuke"
	containertype = /obj/structure/machinery/nuclearbomb
	group = "Operations"

/datum/supply_packs/staff/spec_kits
	name = "Weapons Specialist Kits"
	contains = list(
					/obj/item/spec_kit/asrs,
					/obj/item/spec_kit/asrs,
					/obj/item/spec_kit/asrs,
					/obj/item/spec_kit/asrs
					)
	containertype = /obj/structure/closet/crate/supply
	containername = "\improper Weapons Specialist Kits Crate"
	group = "Operations"
