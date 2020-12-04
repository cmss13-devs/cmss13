/*******************************************************************************
WEAPONS
*******************************************************************************/


/datum/supply_packs/m56_system
	name = "m56 system crate (x1)"
	contains = list()
	cost = RO_PRICE_VERY_PRICY
	containertype = /obj/item/storage/box/m56_system
	containername = "m56 system crate"
	group = "Weapons"

/datum/supply_packs/flamethrower
	name = "M240 Flamethrower crate (M240 x2)"
	contains = list(
					/obj/item/weapon/gun/flamer,
					/obj/item/weapon/gun/flamer
					)
	cost = RO_PRICE_PRICY
	containertype = /obj/structure/closet/crate/weapon
	containername = "\improper M240 Incinerator crate"
	group = "Weapons"

/datum/supply_packs/m56_system
	name = "m56 system crate (x1)"
	contains = list()
	cost = RO_PRICE_VERY_PRICY
	containertype = /obj/item/storage/box/m56_system
	containername = "m56 system crate"
	group = "Weapons"

/datum/supply_packs/m56d_hmg
	name = "m56d crate (x1)"
	contains = list()
	cost = RO_PRICE_VERY_PRICY
	containertype = /obj/item/storage/box/m56d_hmg
	containername = "m56d crate"
	group = "Weapons" 

/datum/supply_packs/gun/pistols
	contains = list(
					/obj/item/weapon/gun/pistol/m4a3,
					/obj/item/weapon/gun/pistol/m4a3,
					/obj/item/ammo_magazine/pistol,
					/obj/item/ammo_magazine/pistol,
					/obj/item/weapon/gun/revolver/m44,
					/obj/item/weapon/gun/revolver/m44,
					/obj/item/ammo_magazine/revolver,
					/obj/item/ammo_magazine/revolver
					)
	name = "surplus sidearms crate (M4A3 x2, M44 x2, ammunition x2 each)" //speedloader and magazine
	cost = RO_PRICE_NORMAL
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
	cost = RO_PRICE_NORMAL
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
	name = "surplus SMG crate (M39 x2, M39 HV magazines x2)"
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate
	containername = "\improper SMGs crate"
	group = "Weapons"

/datum/supply_packs/gun/rifles
	contains = list(
					/obj/item/weapon/gun/rifle/m41a,
					/obj/item/weapon/gun/rifle/m41a,
					/obj/item/ammo_magazine/rifle,
					/obj/item/ammo_magazine/rifle
					)
	name = "surplus rifles crate (M41A x2, M41A rifle magazines x2)"
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate
	containername = "\improper rifles crate"
	group = "Weapons"

/datum/supply_packs/gun
	contains = list(
					/obj/item/weapon/gun/rifle/m41aMK1,
					/obj/item/weapon/gun/rifle/m41aMK1,
					/obj/item/ammo_magazine/rifle/m41aMK1,
					/obj/item/ammo_magazine/rifle/m41aMK1
					)
	name = "surplus rifles crate (M41A Mk1 x2, M41A Mk1 rifle magazines x2)"
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate
	containername = "\improper rifles crate"
	group = "Weapons"

/datum/supply_packs/gun/heavyweapons
	contains = list(
					/obj/item/weapon/gun/rifle/lmg,
					/obj/item/weapon/gun/rifle/lmg,
					/obj/item/ammo_magazine/rifle/lmg,
					/obj/item/ammo_magazine/rifle/lmg,
					)
	name = "M41AE2 HPR crate (HPR x2, HPR ammo box x2)"
	cost = RO_PRICE_PRICY
	containertype = /obj/structure/closet/crate
	containername = "\improper M41AE2 HPR crate"
	group = "Weapons"

/datum/supply_packs/gun/merc
	contains = list()
	name = "black market firearms (x1)"
	cost = RO_PRICE_CHEAP
	contraband = 1
	containertype = /obj/structure/largecrate/guns/merc
	containername = "\improper black market firearms crate"
	group = "Weapons"

/datum/supply_packs/gun_holster
	contains = list(
					/obj/item/storage/large_holster/m39,
					/obj/item/storage/large_holster/m39
					)
	name = "M39 holster crate (x2)"
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate
	containername = "holster crate"
	group = "Weapons"

/datum/supply_packs/gun_holster/m44
	name = "M44 holster crate (x2)"
	cost = RO_PRICE_VERY_CHEAP
	contains = list(
					/obj/item/storage/belt/gun/m44,
					/obj/item/storage/belt/gun/m44
					)
	group = "Weapons"

/datum/supply_packs/gun_holster/m4a3
	name = "M4A3 holster crate (x2)"
	cost = RO_PRICE_VERY_CHEAP
	contains = list(
					/obj/item/storage/belt/gun/m4a3,
					/obj/item/storage/belt/gun/m4a3
					)
	group = "Weapons"

/datum/supply_packs/explosives
	name = "surplus explosives crate (claymore mine x4, M40 HIDP x2, M40 HEDP x2, M15 Frag x2, M12 Blast x2)"
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
	name = "claymore mines crate (x8)"
	contains = list(
					/obj/item/storage/box/explosive_mines,
					/obj/item/storage/box/explosive_mines
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosive mine boxes crate (WARNING)"
	group = "Weapons"


/datum/supply_packs/explosives_m15
	name = "M15 fragmentation grenades crate (x5)"
	contains = list(
					/obj/item/explosive/grenade/HE/m15,
					/obj/item/explosive/grenade/HE/m15,
					/obj/item/explosive/grenade/HE/m15,
					/obj/item/explosive/grenade/HE/m15,
					/obj/item/explosive/grenade/HE/m15
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosive M15 grenades crate (WARNING)"
	group = "Weapons"


/datum/supply_packs/explosives_plastic
	name = "plastic explosives crate (x2)"
	contains = list(
					/obj/item/explosive/plastic,
					/obj/item/explosive/plastic
					)
	cost = RO_PRICE_PRICY
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper plastic explosives crate (WARNING)"
	group = "Weapons"


/datum/supply_packs/explosives_incendiary
	name = "M40 HIDP incendiary grenades crate (x5)"
	contains = list(
					/obj/item/explosive/grenade/incendiary,
					/obj/item/explosive/grenade/incendiary,
					/obj/item/explosive/grenade/incendiary,
					/obj/item/explosive/grenade/incendiary,
					/obj/item/explosive/grenade/incendiary
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosive M40 HIDP incendiary grenades crate (WARNING)"
	group = "Weapons"


/datum/supply_packs/explosives_M40_HEDP
	name = "M40 HEDP blast grenades crate (x5)"
	contains = list(
					/obj/item/explosive/grenade/HE,
					/obj/item/explosive/grenade/HE,
					/obj/item/explosive/grenade/HE,
					/obj/item/explosive/grenade/HE,
					/obj/item/explosive/grenade/HE
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


/datum/supply_packs/explosives_M40_HEFA
	name = "M40 HEFA fragmentation grenades crate (x5)"
	contains = list(
					/obj/item/explosive/grenade/HE/frag,
					/obj/item/explosive/grenade/HE/frag,
					/obj/item/explosive/grenade/HE/frag,
					/obj/item/explosive/grenade/HE/frag,
					/obj/item/explosive/grenade/HE/frag
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
	name = "M74 Airburst Grenade Munition fragmentation grenades crate (x5)"
	contains = list(
					/obj/item/explosive/grenade/HE/airburst,
					/obj/item/explosive/grenade/HE/airburst,
					/obj/item/explosive/grenade/HE/airburst,
					/obj/item/explosive/grenade/HE/airburst,
					/obj/item/explosive/grenade/HE/airburst
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
	name = "M74 Airburst Grenade Munition incendiary grenades crate (x5)"
	contains = list(
					/obj/item/explosive/grenade/incendiary/airburst,
					/obj/item/explosive/grenade/incendiary/airburst,
					/obj/item/explosive/grenade/incendiary/airburst,
					/obj/item/explosive/grenade/incendiary/airburst,
					/obj/item/explosive/grenade/incendiary/airburst
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper explosive M74 AGM-I  grenades crate (WARNING)"
	group = "Weapons"


/datum/supply_packs/mortar
	name = "M402 mortar crate (x1)"
	contains = list(
					/obj/item/mortar_kit
					)
	cost = RO_PRICE_PRICY
	containertype = /obj/structure/closet/crate/weapon
	containername = "\improper M402 mortar crate"
	group = "Weapons"
