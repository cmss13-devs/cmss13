//*******************************************************************************
//WEAPONS
//*******************************************************************************/

//restricted firearms past this line!

/datum/supply_packs/m56b_smartgun
	name = "M56B Smartgun System Package (x1)"
	contains = list(
		/obj/item/storage/box/m56_system
	)
	cost = RO_PRICE_VERY_PRICY
	containertype = /obj/structure/closet/crate/weapon
	containername = "M56B Smartgun System Package"
	group = "Weapons"

/datum/supply_packs/m56_hmg
	name = "M56D Heavy Machine Gun (x1)"
	contains = list(
		/obj/item/storage/box/guncase/m56d
	)
	cost = RO_PRICE_PRICY
	containertype = /obj/structure/closet/crate/weapon
	containername = "M56D Machine Gun Crate"
	group = "Weapons"

/datum/supply_packs/m2c_hmg
	name = "M2C Heavy Machine Gun (x1)"
	contains = list(
		/obj/item/storage/box/guncase/m2c
	)
	cost = RO_PRICE_PRICY
	containertype = /obj/structure/closet/crate/weapon
	containername = "M2C Machine Gun Crate"
	group = "Weapons"

/datum/supply_packs/flamethrower
	name = "M240 Flamethrower Crate (M240 x2, Broiler-T Fuelback x2)"
	contains = list(
					/obj/item/storage/box/guncase/flamer,
					/obj/item/storage/box/guncase/flamer,
					/obj/item/storage/backpack/marine/engineerpack/flamethrower/kit,
					/obj/item/storage/backpack/marine/engineerpack/flamethrower/kit
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo/alt/flame
	containername = "M240 Incinerator crate"
	group = "Weapons"

/datum/supply_packs/grenade_launchers
	name = "M79 Grenade Launcher Crate (x2 Guncasess)"
	contains = list(
					/obj/item/storage/box/guncase/m79,
					/obj/item/storage/box/guncase/m79,
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/weapon
	containername = "M79 grenade launcher crate"
	group = "Weapons"

/datum/supply_packs/mou53
	name = "MOU-53 Break Action Shotgun Crate (x2)"
	contains = list(
		/obj/item/storage/box/guncase/mou53,
		/obj/item/storage/box/guncase/mou53
	)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/weapon
	containername = "MOU-53 Breack Action Shotgun Crate"
	group = "Weapons"

/datum/supply_packs/smartpistol
	name = "SU-6 Smart Pistol Crate (x2)"
	contains = list(
		/obj/item/storage/box/guncase/smartpistol,
		/obj/item/storage/box/guncase/smartpistol,
	)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/weapon
	containername = "SU-6 Smart Pistol Crate"
	group = "Weapons"

/datum/supply_packs/vp78
	name = "VP-78 Hand Cannon Crate (x2)"
	contains = list(
		/obj/item/storage/box/guncase/vp78,
		/obj/item/storage/box/guncase/vp78,
	)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/weapon
	containername = "VP-78 Hand Cannon Crate"
	group = "Weapons"

//Standard firearms past this line!

/datum/supply_packs/gun/pistols
	contains = list(
					/obj/item/weapon/gun/pistol/m4a3,
					/obj/item/weapon/gun/pistol/m4a3,
					/obj/item/ammo_magazine/pistol,
					/obj/item/ammo_magazine/pistol,
					/obj/item/weapon/gun/revolver/m44,
					/obj/item/weapon/gun/revolver/m44,
					/obj/item/ammo_magazine/revolver,
					/obj/item/ammo_magazine/revolver,
					/obj/item/weapon/gun/pistol/mod88,
					/obj/item/weapon/gun/pistol/mod88,
					/obj/item/ammo_magazine/pistol/mod88,
					/obj/item/ammo_magazine/pistol/mod88
					)
	name = "surplus sidearms crate (M4A3 x2, M44 x2, 88 Mod 4 x2, ammunition x2 each)" //speedloader and magazine
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate
	containername = "\improper sidearms crate"
	group = "Weapons"

/datum/supply_packs/gun/shotguns
	contains = list(
					/obj/item/weapon/gun/shotgun/pump,
					/obj/item/weapon/gun/shotgun/pump,
					/obj/item/ammo_magazine/shotgun,
					/obj/item/ammo_magazine/shotgun,
					/obj/item/ammo_magazine/shotgun/buckshot,
					/obj/item/ammo_magazine/shotgun/buckshot
					)
	name = "surplus shotguns crate (M37A2 x2, 12g slug box x2, 12g buckshot box x2)"
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate
	containername = "\improper shotguns crate"
	group = "Weapons"

/datum/supply_packs/gun/smgs
	contains = list(
					/obj/item/weapon/gun/smg/m39,
					/obj/item/weapon/gun/smg/m39,
					/obj/item/ammo_magazine/smg/m39,
					/obj/item/ammo_magazine/smg/m39
					)
	name = "M39 SMG Crate (x2 M39, x2 magazines)"
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/weapon
	containername = "M39 SMG Crate"
	group = "Weapons"

/datum/supply_packs/gun/rifles
	contains = list(
					/obj/item/weapon/gun/rifle/m41a,
					/obj/item/weapon/gun/rifle/m41a,
					/obj/item/ammo_magazine/rifle,
					/obj/item/ammo_magazine/rifle
					)
	name = "M41A MK2 Crate (x2 MK2, x2 magazines)"
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/weapon
	containername = "M41A MK2 Crate"
	group = "Weapons"

/datum/supply_packs/gun
	contains = list(
					/obj/item/weapon/gun/rifle/m41aMK1,
					/obj/item/weapon/gun/rifle/m41aMK1,
					/obj/item/ammo_magazine/rifle/m41aMK1,
					/obj/item/ammo_magazine/rifle/m41aMK1
					)
	name = "M41A MK1 Rifle Crate (x2 MK1, x2 magazines)"
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/weapon
	containername = "M41A MK1 Rifle Crate"
	group = "Weapons"

/datum/supply_packs/gun/heavyweapons
	contains = list(
					/obj/item/storage/box/guncase/lmg,
					/obj/item/storage/box/guncase/lmg
					)
	name = "M41AE2 HPR crate (HPR x2, HPR ammo box x2)"
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/weapon
	containername = "\improper M41AE2 HPR crate"
	group = "Weapons"

/datum/supply_packs/gun/xm88
	contains = list(
					/obj/item/storage/box/guncase/xm88,
					/obj/item/storage/box/guncase/xm88
					)
	name = "XM88 Heavy Rifle crate (XM88 x2)"
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/weapon
	containername = "\improper XM88 Heavy Rifle crate"
	group = "Weapons"

/datum/supply_packs/gun/merc
	contains = list()
	name = "black market firearms (x1)"
	cost = RO_PRICE_NORMAL
	contraband = 1
	containertype = /obj/structure/largecrate/guns/merc
	containername = "\improper black market firearms crate"
	group = "Weapons"


// explosives past this line!

/datum/supply_packs/explosives
	name = "surplus explosives crate (claymore mine x5, M40 HIDP x2, M40 HEDP x2, M15 Frag x2, M12 Blast x2)"
	contains = list(
					/obj/item/storage/box/explosive_mines,
					/obj/item/explosive/grenade/HE,
					/obj/item/explosive/grenade/HE,
					/obj/item/explosive/grenade/incendiary,
					/obj/item/explosive/grenade/incendiary,
					/obj/item/explosive/grenade/HE/m15,
					/obj/item/explosive/grenade/HE/m15,
					/obj/item/explosive/grenade/HE/PMC,
					/obj/item/explosive/grenade/HE/PMC
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosives crate (WARNING)"
	group = "Weapons"


/datum/supply_packs/explosives_mines
	name = "claymore mines crate (x10)"
	contains = list(
					/obj/item/storage/box/explosive_mines,
					/obj/item/storage/box/explosive_mines
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosive mine boxes crate (WARNING)"
	group = "Weapons"


/datum/supply_packs/explosives_m15
	name = "M15 fragmentation grenades crate (x6)"
	contains = list(
					/obj/item/storage/box/packet/m15,
					/obj/item/storage/box/packet/m15
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosive M15 grenades crate (WARNING)"
	group = "Weapons"


/datum/supply_packs/explosives_plastic
	name = "plastic explosives crate (x3)"
	contains = list(
					/obj/item/explosive/plastic,
					/obj/item/explosive/plastic,
					/obj/item/explosive/plastic
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper plastic explosives crate (WARNING)"
	group = "Weapons"

/datum/supply_packs/explosives_breaching_charge
	name = "breaching charge crate (x4)"
	contains = list(
					/obj/item/explosive/plastic/breaching_charge,
					/obj/item/explosive/plastic/breaching_charge,
					/obj/item/explosive/plastic/breaching_charge,
					/obj/item/explosive/plastic/breaching_charge
	)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper plastic explosives crate (WARNING)"
	group = "Weapons"

/datum/supply_packs/explosives_incendiary
	name = "M40 HIDP incendiary grenades crate (x6)"
	contains = list(
					/obj/item/storage/box/packet/incendiary,
					/obj/item/storage/box/packet/incendiary
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosive M40 HIDP incendiary grenades crate (WARNING)"
	group = "Weapons"


/datum/supply_packs/explosives_M40_HEDP
	name = "M40 HEDP blast grenades crate (x6)"
	contains = list(
					/obj/item/storage/box/packet/high_explosive,
					/obj/item/storage/box/packet/high_explosive
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosive M40 HEDP grenades crate (WARNING)"
	group = "Weapons"


/datum/supply_packs/explosives_hedp
	name = "M40 HEDP blast grenade box crate (x25)"
	contains = list(
					/obj/item/storage/box/nade_box
					)
	cost = RO_PRICE_VERY_PRICY
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosive HEDP grenade crate (WARNING)"
	group = "Weapons"

/datum/supply_packs/explosives_M40_HPDP
	name = "M40 HPDP white phosphorus grenades crate (x6)"
	contains = list(
					/obj/item/storage/box/packet/phosphorus,
					/obj/item/storage/box/packet/phosphorus
	)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper M40 HPDP grenade crate (WARNING)"
	group = "Weapons"

/datum/supply_packs/explosives_M40_HPDP_crate
	name = "M40 HPDP white phosphorus grenade box crate (x25)"
	contains = list(
					/obj/item/storage/box/nade_box/phophorus
					)
	cost = RO_PRICE_VERY_PRICY
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper HPDP grenade crate (WARNING)"
	group = "Weapons"

/datum/supply_packs/explosives_M40_HEFA
	name = "M40 HEFA fragmentation grenades crate (x6)"
	contains = list(
					/obj/item/storage/box/packet/hefa,
					/obj/item/storage/box/packet/hefa
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosive M40 HEFA grenades crate (WARNING)"
	group = "Weapons"


/datum/supply_packs/explosives_hefa
	name = "M40 HEFA fragmentation grenade box crate (x25)"
	contains = list(
					/obj/item/storage/box/nade_box/frag
					)
	cost = RO_PRICE_VERY_PRICY
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosive HEFA grenade crate (WARNING)"
	group = "Weapons"

/datum/supply_packs/explosives_M74_AGM_F
	name = "M74 airburst grenades crate (x6)"
	contains = list(
					/obj/item/storage/box/packet/airburst_he,
					/obj/item/storage/box/packet/airburst_he
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosive M74 AGM-F grenades crate (WARNING)"
	group = "Weapons"

/datum/supply_packs/explosives_AGMF
	name = "M74 Airburst Grenade Munition fragmentation grenade box crate (x25)"
	contains = list(
					/obj/item/storage/box/nade_box/airburst
					)
	cost = RO_PRICE_VERY_PRICY
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper  explosive M74 AGM-F grenades crate (WARNING)"
	group = "Weapons"

/datum/supply_packs/explosives_incendiary
	name = "M74 Airburst Grenade Munition incendiary grenades crate (x6)"
	contains = list(
					/obj/item/storage/box/packet/airburst_incen,
					/obj/item/storage/box/packet/airburst_incen
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosive M74 AGM-I grenades crate (WARNING)"
	group = "Weapons"

/datum/supply_packs/explosives_airburst_smoke
	name = "M74 Airburst Grenade Munition smoke grenades crate (x6)"
	contains = list(
					/obj/item/storage/box/packet/airburst_smoke,
					/obj/item/storage/box/packet/airburst_smoke
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosive M74 AGM-S grenades crate"
	group = "Weapons"

/datum/supply_packs/explosives_m74_hornet
	name = "M74 AGM-Hornet Grenade Crate (x6)"
	contains = list(
		/obj/item/storage/box/packet/hornet,
		/obj/item/storage/box/packet/hornet
	)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/explosives
	containername = "M74 AGM-Hornet Grenade Crate"
	group = "Weapons"

/datum/supply_packs/explosives_m74_starshell
	name = "M74 AGM-Star Shell Grenade Crate (x6)"
	contains = list(
		/obj/item/storage/box/packet/flare,
		/obj/item/storage/box/packet/flare
	)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/explosives
	containername = "M74 AGM-Star Shell Grenade Crate"
	group = "Weapons"

/datum/supply_packs/explosives_baton_slug
	name = "M40 HIRR Baton Slug Crate (x6)"
	contains = list(
		/obj/item/storage/box/packet/baton_slug,
		/obj/item/storage/box/packet/baton_slug
	)
	cost = RO_PRICE_WORTHLESS
	containertype = /obj/structure/closet/crate/explosives
	containername = "M40 HIRR Baton Slug Crate"
	group = "Weapons"

/datum/supply_packs/mortar
	name = "M402 mortar crate (Mortar x1, Mortar shell backpack x1)"
	contains = list(
					/obj/item/storage/backpack/marine/mortarpack,
					/obj/item/mortar_kit
					)
	cost = RO_PRICE_PRICY
	containertype = /obj/structure/closet/crate/weapon
	containername = "\improper M402 mortar crate"
	group = "Weapons"
