//List of crates that contain heavy or bulky supply that can be requested to support the operation

//add secured crate flare MRE scanner autodoc surgery table?

//Mortar

/datum/supply_packs/mortar
	name = "M402 mortar crate (Mortar x1, Mortar shell backpack x1)"
	contains = list(
					/obj/item/storage/backpack/marine/mortarpack,
					/obj/item/mortar_kit
					)
	cost = 60
	containertype = /obj/structure/closet/crate/weapon
	containername = "\improper M402 mortar crate"
	group = "Operations"

//------------------------Mortar ammunition crates----------------

/datum/supply_packs/ammo_mortar_he
	name = "M402 mortar shells crate (x6 HE)"
	cost = 20
	contains = list(
					/obj/item/mortar_shell/he,
					/obj/item/mortar_shell/he,
					/obj/item/mortar_shell/he,
					/obj/item/mortar_shell/he,
					/obj/item/mortar_shell/he,
					/obj/item/mortar_shell/he
					)
	containertype = /obj/structure/closet/crate/secure/mortar_ammo
	containername = "\improper M402 mortar HE shells crate"
	group = "Operations"

/datum/supply_packs/ammo_mortar_incend
	name = "M402 mortar shells crate (x6 Incend)"
	cost = 20
	contains = list(
					/obj/item/mortar_shell/incendiary,
					/obj/item/mortar_shell/incendiary,
					/obj/item/mortar_shell/incendiary,
					/obj/item/mortar_shell/incendiary,
					/obj/item/mortar_shell/incendiary,
					/obj/item/mortar_shell/incendiary
					)
	containertype = /obj/structure/closet/crate/secure/mortar_ammo
	containername = "\improper M402 mortar incendiary shells crate"
	group = "Operations"

/datum/supply_packs/ammo_mortar_flare
	name = "M402 mortar shells crate (x6 Flare/Camera)"
	cost = 20
	contains = list(
					/obj/item/mortar_shell/flare,
					/obj/item/mortar_shell/flare,
					/obj/item/mortar_shell/flare,
					/obj/item/mortar_shell/flare,
					/obj/item/mortar_shell/flare,
					/obj/item/mortar_shell/flare
					)
	containertype = /obj/structure/closet/crate/secure/mortar_ammo
	containername = "\improper M402 mortar flare shells crate"
	group = "Operations"

//------------------------Sentries Ammo----------------

/datum/supply_packs/ammo_sentry
	name = "UA 571-C sentry ammunition (x2)"
	contains = list(
					/obj/item/ammo_magazine/sentry,
					/obj/item/ammo_magazine/sentry
					)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper sentry ammo crate"
	group = "Operations"

/datum/supply_packs/ammo_sentry_flamer
	name = "UA 42-F sentry flamer ammunition (x2)"
	contains = list(
					/obj/item/ammo_magazine/sentry_flamer,
					/obj/item/ammo_magazine/sentry_flamer
					)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper sentry flamer ammo crate"
	group = "Operations"

/datum/supply_packs/ammo_sentry_shotgun
	name = "UA 12-G sentry shotgun ammunition (x2)"
	contains = list(
					/obj/item/ammo_magazine/sentry/shotgun,
					/obj/item/ammo_magazine/sentry/shotgun
					)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper sentry shotgun ammo crate"
	group = "Operations"

//Non buyable bellow

//Orbital Bombardement Ammunition

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

//Telecomunication

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

//Nuclear bomb

/datum/supply_packs/nuclearbomb
	name = "Operational Nuke"
	cost = 0
	containertype = /obj/structure/machinery/nuclearbomb
	buyable = 0
	group = "Operations"
	iteration_needed = null
