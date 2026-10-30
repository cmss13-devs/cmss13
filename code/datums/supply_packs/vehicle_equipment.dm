/datum/supply_packs/arcsentry_replacement
	name = "Replacement RE700 Rotary Cannon (x1)"
	contains = list(
		/obj/item/hardpoint/primary/arc_sentry,
	)
	cost = 25
	containertype = /obj/structure/closet/crate/weapon
	containername = "RE700 Rotary Cannon crate"
	group = "Vehicle Equipment"

/datum/supply_packs/arc_components
	name = "ARC Components"
	contains = list(
		/obj/item/hardpoint/locomotion/arc_wheels,
		/obj/item/hardpoint/primary/arc_sentry,
		/obj/item/hardpoint/support/arc_antenna,
	)
	cost = 0
	containertype = /obj/structure/closet/crate/supply
	containername = "ARC components crate"
	buyable = FALSE
	group = "Vehicle Equipment"
