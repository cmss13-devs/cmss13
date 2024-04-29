/datum/supply_packs/sentry_gun
	contains = list(
        /obj/item/defenses/handheld/sentry,
	)
	name = "UA 571-C Sentry Gun"
	cost = 40
	containertype = /obj/structure/closet/crate/supply
	containername = "UA 571-C Sentry Gun (x1)"
	group = "Weapons"

/datum/supply_packs/sentry_flamer
	contains = list(
        /obj/item/defenses/handheld/sentry/flamer,
	)
	name = "UA 42-F Sentry Flamer"
	cost = 65
	containertype = /obj/structure/closet/crate/supply
	containername = "UA 42-F Sentry Flamer (x1)"
	group = "Weapons"

/datum/supply_packs/tesla_coil
	contains = list(
        /obj/item/defenses/handheld/tesla_coil,
	)
	name = "21S Tesla Coil"
	cost = 50
	containertype = /obj/structure/closet/crate/supply
	containername = "21S Tesla Coil (x1)"
	group = "Weapons"

/datum/supply_packs/planted_flag
	contains = list(
        /obj/item/defenses/handheld/planted_flag,
	)
	name = "JIMA Planted Flag"
	cost = 30
	containertype = /obj/structure/closet/crate/supply
	containername = "JIMA Planted Flag (x1)"
	group = "Weapons"

/datum/supply_packs/mixed_sentry
	contains = list(
        /obj/item/defenses/handheld/planted_flag,
		/obj/item/defenses/handheld/tesla_coil,
		/obj/item/defenses/handheld/sentry/flamer,
		/obj/item/defenses/handheld/sentry,
	)
	name = "Sentry mix, all in one"
	cost = 150
	containertype = /obj/structure/closet/crate/supply
	containername = "JIMA Planted Flag (x1)\n21S Tesla Coil (x1)\nUA 42-F Sentry Flamer (x1)\nUA 571-C Sentry Gun (x1)"
	group = "Weapons"
