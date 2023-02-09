//the idea is to put all the bulk items scanner secure crate with lot's of flares MRE in it and at the end OB and non buyable.

//non buyable

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
		/obj/item/stack/cable_coil,
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
		/obj/item/spec_kit/asrs,
	)
	cost = 0
	containertype = /obj/structure/closet/crate/supply
	containername = "weapons specialist kits crate"
	buyable = 0
	group = "Operations"
	iteration_needed = null
