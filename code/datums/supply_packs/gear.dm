// add all the gear in this group.

/datum/supply_packs/binocs
	name = "Mixed Binoculars Crate (x2 per, x6 total)"
	cost = 20
	containertype = /obj/structure/closet/crate/green
	containername = "Mixed Binoculars Crate"
	group = "Gear"
	contains = list(
		/obj/item/device/binoculars/range/designator,
		/obj/item/device/binoculars/range/designator,
		/obj/item/device/binoculars/range,
		/obj/item/device/binoculars/range,
		/obj/item/device/binoculars,
		/obj/item/device/binoculars,
	)

/datum/supply_packs/flares
	name = "flare packs crate (x20)"
	contains = list(
		/obj/item/ammo_box/magazine/misc/flares,
		/obj/item/ammo_box/magazine/misc/flares,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo
	containername = "flare pack crate"
	group = "Gear"


/datum/supply_packs/motiondetector
	name = "Motion Detector (x2)"
	contains = list(
		/obj/item/device/motiondetector,
		/obj/item/device/motiondetector,
					)
	cost = 40
	containertype = /obj/structure/closet/crate/supply
	containername = "Motion Detector crate"
	group = "Gear"

/datum/supply_packs/signal_flares
	name = "signal flare packs crate (x4)"
	contains = list(
		/obj/item/storage/box/m94/signal,
		/obj/item/storage/box/m94/signal,
		/obj/item/storage/box/m94/signal,
		/obj/item/storage/box/m94/signal,
	)
	cost = 60
	containertype = /obj/structure/closet/crate/ammo
	containername = "signal flare pack crate"
	group = "Gear"

/datum/supply_packs/fulton
	name = "fulton recovery device crate (x4)"
	contains = list(
		/obj/item/stack/fulton,
		/obj/item/stack/fulton,
		/obj/item/stack/fulton,
		/obj/item/stack/fulton,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/ammo
	containername = "fulton recovery device crate"
	group = "Gear"

/datum/supply_packs/parachute
	name = "parachute crate (x20)"
	contains = list(
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/supply
	containername = "parachute crate"
	group = "Gear"
