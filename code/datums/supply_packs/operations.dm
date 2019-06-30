/*******************************************************************************
OPERATIONS
*******************************************************************************/


/datum/supply_packs/specialops
	name = "special operations crate (operator kit x2)"
	contains = list(/obj/item/attachable/suppressor,
					/obj/item/attachable/suppressor,
					/obj/item/attachable/reddot,
					/obj/item/attachable/reddot,
					/obj/item/explosive/grenade/smokebomb,
					/obj/item/explosive/grenade/smokebomb,
					/obj/item/clothing/mask/gas/swat,
					/obj/item/clothing/mask/gas/swat,
					/obj/item/clothing/tie/storage/webbing,
					/obj/item/clothing/tie/storage/webbing
					)
	cost = RO_PRICE_PRICY
	containertype = /obj/structure/closet/crate
	containername = "special ops crate"
	group = "Operations"

/datum/supply_packs/flares
	name = "flare packs crate (x20)"
	contains = list(
					/obj/item/storage/box/m94,
					/obj/item/storage/box/m94,
					/obj/item/storage/box/m94,
					/obj/item/storage/box/m94,
					/obj/item/storage/box/m94,
					/obj/item/storage/box/m94,
					/obj/item/storage/box/m94,
					/obj/item/storage/box/m94,
					/obj/item/storage/box/m94,
					/obj/item/storage/box/m94,
					/obj/item/storage/box/m94,
					/obj/item/storage/box/m94,
					/obj/item/storage/box/m94,
					/obj/item/storage/box/m94,
					/obj/item/storage/box/m94,
					/obj/item/storage/box/m94,
					/obj/item/storage/box/m94,
					/obj/item/storage/box/m94,
					/obj/item/storage/box/m94,
					/obj/item/storage/box/m94
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "flare pack crate"
	group = "Operations"


/datum/supply_packs/motiondetector
	name = "Motion Detector (x2)"
	contains = list(
		/obj/item/device/motiondetector,
		/obj/item/device/motiondetector
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/supply
	containername = "Motion Detector crate"
	group = "Operations"

/datum/supply_packs/signal_flares
	name = "signal flare packs crate (x4)"
	contains = list(
					/obj/item/storage/box/m94/signal,
					/obj/item/storage/box/m94/signal,
					/obj/item/storage/box/m94/signal,
					/obj/item/storage/box/m94/signal
					)
	cost = RO_PRICE_PRICY
	containertype = /obj/structure/closet/crate/ammo
	containername = "signal flare pack crate"
	group = "Operations"

/datum/supply_packs/fulton
	name = "fulton recovery device crate (x4)"
	contains = list(
					/obj/item/stack/fulton,
					/obj/item/stack/fulton,
					/obj/item/stack/fulton,
					/obj/item/stack/fulton
					)
	cost = RO_PRICE_PRICY
	containertype = /obj/structure/closet/crate/ammo
	containername = "fulton recovery device crate"
	group = "Operations"

/datum/supply_packs/contraband
	randomised_num_contained = 5
	contains = list(
					/obj/item/seeds/bloodtomatoseed,
					/obj/item/storage/pill_bottle/zoom,
					/obj/item/storage/pill_bottle/happy,
					/obj/item/reagent_container/food/drinks/bottle/pwine
					)

	name = "contraband crate"
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/supply
	containername = "unlabeled crate"
	contraband = 1
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
	containertype = /obj/structure/closet/crate/secure/ammo
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
	containertype = /obj/structure/closet/crate/secure/ammo
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
	containertype = /obj/structure/closet/crate/secure/ammo
	containername = "OB Ammo Crate (Cluster x2)"
	buyable = 0
	group = "Operations"
	iteration_needed = null

/datum/supply_packs/nuclearbomb
	name = "Operational Nuke"
	cost = 0
	containertype = /obj/machinery/nuclearbomb
	buyable = 0
	group = "Operations"
	iteration_needed = null