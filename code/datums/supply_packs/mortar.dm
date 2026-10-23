//group for putting all the items about mortar. mortar/shells/backpack...

//---------------------------------------------
//Backpacks
//---------------------------------------------

/datum/supply_packs/backpack/mortar_pack
	name = "Mortar Shell Backpack Crate (x4)"
	contains = list(
		/obj/item/storage/backpack/marine/mortarpack,
		/obj/item/storage/backpack/marine/mortarpack,
		/obj/item/storage/backpack/marine/mortarpack,
		/obj/item/storage/backpack/marine/mortarpack,
	)
	cost = 30
	containername = "Mortar Shell Backpack Crate"

/datum/supply_packs/mortar
	name = "M402 mortar crate (Mortar x1, Mortar shell backpack x1)"
	contains = list(
		/obj/item/storage/backpack/marine/mortarpack,
		/obj/item/mortar_kit,
	)
	cost = 60
	containertype = /obj/structure/closet/crate/weapon
	containername = "\improper M402 mortar crate"
	group = "Mortar"

//------------------------Mortar ammunition crates----------------

/datum/supply_packs/ammo_mortar_he
	name = "M402 mortar shells crate (x6 HE)"
	cost = 15
	contains = list(
		/obj/item/mortar_shell/he,
		/obj/item/mortar_shell/he,
		/obj/item/mortar_shell/he,
		/obj/item/mortar_shell/he,
		/obj/item/mortar_shell/he,
		/obj/item/mortar_shell/he,
	)
	containertype = /obj/structure/closet/crate/secure/mortar_ammo
	containername = "\improper M402 mortar HE shells crate"
	group = "Mortar"

/datum/supply_packs/ammo_mortar_incend
	name = "M402 mortar shells crate (x6 Incend)"
	cost = 15
	contains = list(
		/obj/item/mortar_shell/incendiary,
		/obj/item/mortar_shell/incendiary,
		/obj/item/mortar_shell/incendiary,
		/obj/item/mortar_shell/incendiary,
		/obj/item/mortar_shell/incendiary,
		/obj/item/mortar_shell/incendiary,
	)
	containertype = /obj/structure/closet/crate/secure/mortar_ammo
	containername = "\improper M402 mortar incendiary shells crate"
	group = "Mortar"

/datum/supply_packs/ammo_mortar_flare
	name = "M402 mortar shells crate (x6 Flare/Camera)"
	cost = 10
	contains = list(
		/obj/item/mortar_shell/flare,
		/obj/item/mortar_shell/flare,
		/obj/item/mortar_shell/flare,
		/obj/item/mortar_shell/flare,
		/obj/item/mortar_shell/flare,
		/obj/item/mortar_shell/flare,
	)
	containertype = /obj/structure/closet/crate/secure/mortar_ammo
	containername = "\improper M402 mortar flare shells crate"
	group = "Mortar"

/datum/supply_packs/ammo_mortar_he_plus
	name = "M402 HCHE mortar crate (x4 HE+)"
	cost = 45
	contains = list(
		/obj/item/mortar_shell/heplus,
		/obj/item/mortar_shell/heplus,
		/obj/item/mortar_shell/heplus,
		/obj/item/mortar_shell/heplus,
	)
	containertype = /obj/structure/closet/crate/secure/mortar_ammo
	containername = "\improper M402 HCHE high-capacity mortar crate"
	group = "Mortar"

/datum/supply_packs/ammo_mortar_incend_plus
	name = "M402 HTVSF-Incendiary mortar crate (x4 Pen-Incend)"
	cost = 30
	contains = list(
		/obj/item/mortar_shell/incendiary/pierce,
		/obj/item/mortar_shell/incendiary/pierce,
		/obj/item/mortar_shell/incendiary/pierce,
		/obj/item/mortar_shell/incendiary/pierce,
	)
	containertype = /obj/structure/closet/crate/secure/mortar_ammo
	containername = "\improper M402 HTVSF-Incendiary mortar crate"
	group = "Mortar"

/datum/supply_packs/ammo_mortar_thermobarics
	name = "M402 SFAE-Vacuum mortar shell (x4 Thermobarics)"
	cost = 30
	contains = list(
		/obj/item/mortar_shell/incendiary/thermobaric,
		/obj/item/mortar_shell/incendiary/thermobaric,
		/obj/item/mortar_shell/incendiary/thermobaric,
		/obj/item/mortar_shell/incendiary/thermobaric,
	)
	containertype = /obj/structure/closet/crate/secure/mortar_ammo
	containername = "\improper M402 HTVSF-Incendiary mortar crate"
	group = "Mortar"

//Honestly due for removal.
/datum/supply_packs/ammo_mortar_frag
	name = "M402 mortar shells crate (x6 Frag)"
	cost = 10
	contains = list(
		/obj/item/mortar_shell/frag,
		/obj/item/mortar_shell/frag,
		/obj/item/mortar_shell/frag,
		/obj/item/mortar_shell/frag,
		/obj/item/mortar_shell/frag,
		/obj/item/mortar_shell/frag,
	)
	containertype = /obj/structure/closet/crate/secure/mortar_ammo
	containername = "\improper M402 mortar frag shells crate"
	group = "Mortar"
