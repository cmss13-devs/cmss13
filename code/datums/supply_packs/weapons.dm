/datum/supply_packs/repairkits
	name = "Firearms Maintenance and Restoration crate (x3 Firearms Kits, x5 Lubricants)"
	contains = list(
		/obj/item/stack/repairable/gunkit,
		/obj/item/stack/repairable/gunkit,
		/obj/item/stack/repairable/gunkit,
		/obj/item/stack/repairable/gunlube,
		/obj/item/stack/repairable/gunlube,
		/obj/item/stack/repairable/gunlube,
		/obj/item/stack/repairable/gunlube,
		/obj/item/stack/repairable/gunlube,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/supply
	containername = "firearms maintenance crate"
	group = "Weapons"

/datum/supply_packs/m56_hmg
	name = "M56D Heavy Machine Gun (x1)"
	contains = list(
		/obj/item/storage/box/guncase/m56d,
	)
	cost = 60
	containertype = /obj/structure/closet/crate/weapon
	containername = "M56D Machine Gun Crate"
	group = "Weapons"

/datum/supply_packs/m2c_hmg
	name = "M2C Heavy Machine Gun (x1)"
	contains = list(
		/obj/item/storage/box/guncase/m2c,
	)
	cost = 60
	containertype = /obj/structure/closet/crate/weapon
	containername = "M2C Machine Gun Crate"
	group = "Weapons"

/datum/supply_packs/flamethrower
	name = "M240 Flamethrower Crate (M240 x2, Broiler-T Fuelback x2)"
	contains = list(
		/obj/item/storage/box/guncase/flamer,
		/obj/item/storage/box/guncase/flamer,
		/obj/item/storage/backpack/marine/engineerpack/flamethrower/kit,
		/obj/item/storage/backpack/marine/engineerpack/flamethrower/kit,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo/alt/flame
	containername = "M240 Incinerator crate"
	group = "Weapons"

/datum/supply_packs/grenade_launchers
	name = "M79 Grenade Launcher Crate (x2 Guncases)"
	contains = list(
		/obj/item/storage/box/guncase/m79,
		/obj/item/storage/box/guncase/m79,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/weapon
	containername = "M79 grenade launcher crate"
	group = "Weapons"

/datum/supply_packs/mou53
	name = "MOU-53 Break Action Shotgun Crate (x2)"
	contains = list(
		/obj/item/storage/box/guncase/mou53,
		/obj/item/storage/box/guncase/mou53,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/weapon
	containername = "MOU-53 Break Action Shotgun Crate"
	group = "Weapons"

/datum/supply_packs/xm51
	name = "XM51 Breaching Scattergun Crate (x2)"
	contains = list(
		/obj/item/storage/box/guncase/xm51,
		/obj/item/storage/box/guncase/xm51,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/weapon
	containername = "XM51 Breaching Scattergun Crate"
	group = "Weapons"

/datum/supply_packs/smartpistol
	name = "SU-6 Smart Pistol Crate (x2)"
	contains = list(
		/obj/item/storage/box/guncase/smartpistol,
		/obj/item/storage/box/guncase/smartpistol,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/weapon
	containername = "SU-6 Smart Pistol Crate"
	group = "Weapons"

/datum/supply_packs/vp78
	name = "VP-78 Hand Cannon Crate (x2)"
	contains = list(
		/obj/item/storage/box/guncase/vp78,
		/obj/item/storage/box/guncase/vp78,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/weapon
	containername = "VP-78 Hand Cannon Crate"
	group = "Weapons"

/datum/supply_packs/gun
	contains = list(
		/obj/item/weapon/gun/rifle/m41aMK1,
		/obj/item/weapon/gun/rifle/m41aMK1,
		/obj/item/ammo_magazine/rifle/m41aMK1,
		/obj/item/ammo_magazine/rifle/m41aMK1,
	)
	name = "M41A MK1 Rifle Crate (x2 MK1, x2 magazines)"
	cost = 40
	containertype = /obj/structure/closet/crate/weapon
	containername = "M41A MK1 Rifle Crate"
	group = "Weapons"

/datum/supply_packs/gun/heavyweapons
	contains = list(
		/obj/item/storage/box/guncase/lmg,
		/obj/item/storage/box/guncase/lmg,
	)
	name = "M41AE2 HPR crate (HPR x2, HPR ammo box x2)"
	cost = 40
	containertype = /obj/structure/closet/crate/weapon
	containername = "\improper M41AE2 HPR crate"
	group = "Weapons"

/datum/supply_packs/gun/xm88
	contains = list(
		/obj/item/storage/box/guncase/xm88,
		/obj/item/storage/box/guncase/xm88,
	)
	name = "XM88 Heavy Rifle crate (XM88 x2)"
	cost = 40
	containertype = /obj/structure/closet/crate/weapon
	containername = "\improper XM88 Heavy Rifle crate"
	group = "Weapons"

/* Uncomment me if it's decided to let the m707 be purchasable through req
/datum/supply_packs/gun/m707
	name = "M707 Anti-Materiel Rifle crate (M707 x1)"
	contains = list()
	cost = 120
	containertype = /obj/structure/closet/crate/secure/vulture
	containername = "M707 crate"
	group = "Weapons"
*/
