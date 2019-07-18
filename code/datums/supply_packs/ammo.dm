/*******************************************************************************
AMMO
*******************************************************************************/


/datum/supply_packs/ammo_mag_box
	name = "magazine box (M41A, 10x regular mags)"
	contains = list(
					/obj/item/magazine_box
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_smg_mag_box
	name = "magazine box (M39, 12x regular mags)"
	contains = list(
					/obj/item/magazine_box/smg
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_mag_box_ext
	name = "magazine box (M41A, 8x extended mags)"
	contains = list(
					/obj/item/magazine_box/rifle_extended
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_smg_mag_box_ext
	name = "magazine box (M39, 10x extended mags)"
	contains = list(
					/obj/item/magazine_box/smg/extended
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_mag_box_ap
	name = "magazine box (M41A, 10x AP mags)"
	contains = list(
					/obj/item/magazine_box/rifle_ap
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_smg_mag_box_ap
	name = "magazine box (M39, 12x AP mags)"
	contains = list(
					/obj/item/magazine_box/smg/ap
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_l42_mag_box
	name = "magazine box (L42-MK1, 16x mags)"
	contains = list(
					/obj/item/magazine_box/rifle/l42mk1
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_l42_mag_box_ext
	name = "magazine box (L42-MK1, 16x extended mags)"
	contains = list(
					/obj/item/magazine_box/rifle/l42mk1/ext
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_l42_mag_box_ap
	name = "magazine box (L42-MK1, 16xAP mags)"
	contains = list(
					/obj/item/magazine_box/rifle/l42mk1/ap
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_shell_box
	name = "shell box (100x slug shells)"
	contains = list(
					/obj/item/magazine_box/shotgun
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_shell_box_buck
	name = "shell box (100x buckshot shells)"
	contains = list(
					/obj/item/magazine_box/shotgun/buckshot
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_shell_box_flechette
	name = "shell box (100x flechette shells)"
	contains = list(
					/obj/item/magazine_box/shotgun/flechette
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_regular
	name = "regular magazines crate (M41A x5, M4A3 x2, M44 x2, M39 x2, L42 x2, M37A2 x1 each)"
	contains = list(
					/obj/item/ammo_magazine/rifle,
					/obj/item/ammo_magazine/rifle,
					/obj/item/ammo_magazine/rifle,
					/obj/item/ammo_magazine/rifle,
					/obj/item/ammo_magazine/rifle,
					/obj/item/ammo_magazine/pistol,
					/obj/item/ammo_magazine/pistol,
					/obj/item/ammo_magazine/smg/m39,
					/obj/item/ammo_magazine/smg/m39,
					/obj/item/ammo_magazine/revolver,
					/obj/item/ammo_magazine/revolver,
					/obj/item/ammo_magazine/shotgun,
					/obj/item/ammo_magazine/shotgun/buckshot,
					/obj/item/ammo_magazine/rifle/l42mk1,
					/obj/item/ammo_magazine/rifle/l42mk1
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_regular_m41a
	name = "regular M41A magazines crate (x8)"
	contains = list(
					/obj/item/ammo_magazine/rifle,
					/obj/item/ammo_magazine/rifle,
					/obj/item/ammo_magazine/rifle,
					/obj/item/ammo_magazine/rifle,
					/obj/item/ammo_magazine/rifle,
					/obj/item/ammo_magazine/rifle,
					/obj/item/ammo_magazine/rifle,
					/obj/item/ammo_magazine/rifle
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "M41A regular ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_regular_l42mk1
	name = "regular L42-MK1 magazines crate (x10)"
	contains = list(
					/obj/item/ammo_magazine/rifle/l42mk1,
					/obj/item/ammo_magazine/rifle/l42mk1,
					/obj/item/ammo_magazine/rifle/l42mk1,
					/obj/item/ammo_magazine/rifle/l42mk1,
					/obj/item/ammo_magazine/rifle/l42mk1,
					/obj/item/ammo_magazine/rifle/l42mk1,
					/obj/item/ammo_magazine/rifle/l42mk1,
					/obj/item/ammo_magazine/rifle/l42mk1,
					/obj/item/ammo_magazine/rifle/l42mk1,
					/obj/item/ammo_magazine/rifle/l42mk1
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "L42-MK1 regular ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_regular_m4a3
	name = "regular M4A3 magazines crate (x10)"
	contains = list(
					/obj/item/ammo_magazine/pistol,
					/obj/item/ammo_magazine/pistol,
					/obj/item/ammo_magazine/pistol,
					/obj/item/ammo_magazine/pistol,
					/obj/item/ammo_magazine/pistol,
					/obj/item/ammo_magazine/pistol,
					/obj/item/ammo_magazine/pistol,
					/obj/item/ammo_magazine/pistol,
					/obj/item/ammo_magazine/pistol,
					/obj/item/ammo_magazine/pistol
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "M4A3 regular ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_regular_m44
	name = "regular M44 magazines crate (x10)"
	contains = list(
					/obj/item/ammo_magazine/revolver,
					/obj/item/ammo_magazine/revolver,
					/obj/item/ammo_magazine/revolver,
					/obj/item/ammo_magazine/revolver,
					/obj/item/ammo_magazine/revolver,
					/obj/item/ammo_magazine/revolver,
					/obj/item/ammo_magazine/revolver,
					/obj/item/ammo_magazine/revolver,
					/obj/item/ammo_magazine/revolver,
					/obj/item/ammo_magazine/revolver
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "M44 regular ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_regular_m39
	name = "regular M39 magazines crate (x10)"
	contains = list(
					/obj/item/ammo_magazine/smg/m39,
					/obj/item/ammo_magazine/smg/m39,
					/obj/item/ammo_magazine/smg/m39,
					/obj/item/ammo_magazine/smg/m39,
					/obj/item/ammo_magazine/smg/m39,
					/obj/item/ammo_magazine/smg/m39,
					/obj/item/ammo_magazine/smg/m39,
					/obj/item/ammo_magazine/smg/m39,
					/obj/item/ammo_magazine/smg/m39,
					/obj/item/ammo_magazine/smg/m39
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "M39 regular ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_regular_m37a2
	name = "regular M37A2 shells crate (x5 slugs, x5 buckshot)"
	contains = list(
					/obj/item/ammo_magazine/shotgun,
					/obj/item/ammo_magazine/shotgun,
					/obj/item/ammo_magazine/shotgun,
					/obj/item/ammo_magazine/shotgun,
					/obj/item/ammo_magazine/shotgun,
					/obj/item/ammo_magazine/shotgun/buckshot,
					/obj/item/ammo_magazine/shotgun/buckshot,
					/obj/item/ammo_magazine/shotgun/buckshot,
					/obj/item/ammo_magazine/shotgun/buckshot,
					/obj/item/ammo_magazine/shotgun/buckshot
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "M37A2 ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_extended
	name = "extended magazines crate (M41A x2, M4A3 x2, M39 x2, L42 x2)"
	contains = list(
					/obj/item/ammo_magazine/rifle/extended,
					/obj/item/ammo_magazine/rifle/extended,
					/obj/item/ammo_magazine/pistol/extended,
					/obj/item/ammo_magazine/pistol/extended,
					/obj/item/ammo_magazine/smg/m39/extended,
					/obj/item/ammo_magazine/smg/m39/extended,
					/obj/item/ammo_magazine/rifle/l42mk1/extended,
					/obj/item/ammo_magazine/rifle/l42mk1/extended
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "extended ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_extended_m41a
	name = "extended M41A magazines crate (x6)"
	contains = list(
					/obj/item/ammo_magazine/rifle/extended,
					/obj/item/ammo_magazine/rifle/extended,
					/obj/item/ammo_magazine/rifle/extended,
					/obj/item/ammo_magazine/rifle/extended,
					/obj/item/ammo_magazine/rifle/extended,
					/obj/item/ammo_magazine/rifle/extended
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "M41A extended ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_extended_l42mk1
	name = "extended L42-MK1 magazines crate (x6)"
	contains = list(
					/obj/item/ammo_magazine/rifle/l42mk1/extended,
					/obj/item/ammo_magazine/rifle/l42mk1/extended,
					/obj/item/ammo_magazine/rifle/l42mk1/extended,
					/obj/item/ammo_magazine/rifle/l42mk1/extended,
					/obj/item/ammo_magazine/rifle/l42mk1/extended,
					/obj/item/ammo_magazine/rifle/l42mk1/extended
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "L42-MK1 extended ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_extended_m4a3
	name = "extended M4A3 magazines crate (x8)"
	contains = list(
					/obj/item/ammo_magazine/pistol/extended,
					/obj/item/ammo_magazine/pistol/extended,
					/obj/item/ammo_magazine/pistol/extended,
					/obj/item/ammo_magazine/pistol/extended,
					/obj/item/ammo_magazine/pistol/extended,
					/obj/item/ammo_magazine/pistol/extended,
					/obj/item/ammo_magazine/pistol/extended,
					/obj/item/ammo_magazine/pistol/extended
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "M4A3 extended ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_smartpistol
	name = "SU-6 smartpistol magazines crate (x12)"
	contains = list(
					/obj/item/ammo_magazine/pistol/smart,
					/obj/item/ammo_magazine/pistol/smart,
					/obj/item/ammo_magazine/pistol/smart,
					/obj/item/ammo_magazine/pistol/smart,
					/obj/item/ammo_magazine/pistol/smart,
					/obj/item/ammo_magazine/pistol/smart,
					/obj/item/ammo_magazine/pistol/smart,
					/obj/item/ammo_magazine/pistol/smart,
					/obj/item/ammo_magazine/pistol/smart,
					/obj/item/ammo_magazine/pistol/smart,
					/obj/item/ammo_magazine/pistol/smart,
					/obj/item/ammo_magazine/pistol/smart
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "smartpistol ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_m1911
	name = "M1911 .45 magazines crate (x12)"
	contains = list(
					/obj/item/ammo_magazine/pistol/m1911,
					/obj/item/ammo_magazine/pistol/m1911,
					/obj/item/ammo_magazine/pistol/m1911,
					/obj/item/ammo_magazine/pistol/m1911,
					/obj/item/ammo_magazine/pistol/m1911,
					/obj/item/ammo_magazine/pistol/m1911,
					/obj/item/ammo_magazine/pistol/m1911,
					/obj/item/ammo_magazine/pistol/m1911,
					/obj/item/ammo_magazine/pistol/m1911,
					/obj/item/ammo_magazine/pistol/m1911,
					/obj/item/ammo_magazine/pistol/m1911,
					/obj/item/ammo_magazine/pistol/m1911
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "M1911 .45 ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_extended_m39
	name = "extended M39 magazines crate (x6)"
	contains = list(
					/obj/item/ammo_magazine/smg/m39/extended,
					/obj/item/ammo_magazine/smg/m39/extended,
					/obj/item/ammo_magazine/smg/m39/extended,
					/obj/item/ammo_magazine/smg/m39/extended,
					/obj/item/ammo_magazine/smg/m39/extended,
					/obj/item/ammo_magazine/smg/m39/extended
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "M39 extended ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_ap
	name = "armor piercing magazines crate (M41A x2, M4A3 x2, M39 x2, M39 LE x1, L42 x2)"
	contains = list(
					/obj/item/ammo_magazine/rifle/ap,
					/obj/item/ammo_magazine/rifle/ap,
					/obj/item/ammo_magazine/pistol/ap,
					/obj/item/ammo_magazine/pistol/ap,
					/obj/item/ammo_magazine/smg/m39/ap,
					/obj/item/ammo_magazine/smg/m39/ap,
					/obj/item/ammo_magazine/smg/m39/le,
					/obj/item/ammo_magazine/rifle/l42mk1/ap,
					/obj/item/ammo_magazine/rifle/l42mk1/ap
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "armor piercing ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_ap_m41a
	name = "armor piercing M41A magazines crate (x10)"
	contains = list(
					/obj/item/magazine_box/rifle_ap,
					)
	cost = RO_PRICE_PRICY
	containertype = /obj/structure/closet/crate/ammo
	containername = "M41A armor piercing ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_ap_m4a3
	name = "armor piercing M4A3 magazines crate (x8)"
	contains = list(
					/obj/item/ammo_magazine/pistol/ap,
					/obj/item/ammo_magazine/pistol/ap,
					/obj/item/ammo_magazine/pistol/ap,
					/obj/item/ammo_magazine/pistol/ap,
					/obj/item/ammo_magazine/pistol/ap,
					/obj/item/ammo_magazine/pistol/ap,
					/obj/item/ammo_magazine/pistol/ap,
					/obj/item/ammo_magazine/pistol/ap
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "M4A3 armor piercing ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_ap_m39
	name = "armor piercing M39 magazines crate (AP x6, LE x2)"
	contains = list(
					/obj/item/ammo_magazine/smg/m39/ap,
					/obj/item/ammo_magazine/smg/m39/ap,
					/obj/item/ammo_magazine/smg/m39/ap,
					/obj/item/ammo_magazine/smg/m39/ap,
					/obj/item/ammo_magazine/smg/m39/ap,
					/obj/item/ammo_magazine/smg/m39/ap,
					/obj/item/ammo_magazine/smg/m39/le,
					/obj/item/ammo_magazine/smg/m39/le
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "M39 armor piercing ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_scout_regular
	name = "M4RA scout magazines crate (regular x3, incendiary x1, impact x1)"
	contains = list(
					/obj/item/ammo_magazine/rifle/m4ra,
					/obj/item/ammo_magazine/rifle/m4ra,
					/obj/item/ammo_magazine/rifle/m4ra,
					/obj/item/ammo_magazine/rifle/m4ra/incendiary,
					/obj/item/ammo_magazine/rifle/m4ra/impact,
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "scout ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_sniper_regular
	name = "M42A sniper magazines crate (x6)"
	contains = list(
					/obj/item/ammo_magazine/sniper,
					/obj/item/ammo_magazine/sniper,
					/obj/item/ammo_magazine/sniper,
					/obj/item/ammo_magazine/sniper,
					/obj/item/ammo_magazine/sniper,
					/obj/item/ammo_magazine/sniper
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "regular sniper ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_sniper_flak
	name = "M42A sniper flak magazines crate (x6)"
	contains = list(
					/obj/item/ammo_magazine/sniper/flak,
					/obj/item/ammo_magazine/sniper/flak,
					/obj/item/ammo_magazine/sniper/flak,
					/obj/item/ammo_magazine/sniper/flak,
					/obj/item/ammo_magazine/sniper/flak,
					/obj/item/ammo_magazine/sniper/flak
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "flak sniper ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_sniper_incendiary
	name = "M42A sniper incendiary magazines crate (x6)"
	contains = list(
					/obj/item/ammo_magazine/sniper/incendiary,
					/obj/item/ammo_magazine/sniper/incendiary,
					/obj/item/ammo_magazine/sniper/incendiary,
					/obj/item/ammo_magazine/sniper/incendiary,
					/obj/item/ammo_magazine/sniper/incendiary,
					/obj/item/ammo_magazine/sniper/incendiary
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "incendiary sniper ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_anti_tank
	name = "XM42B sniper anti-tank magazines crate (x4)"
	contains = list(
					/obj/item/ammo_magazine/sniper/anti_tank,
					/obj/item/ammo_magazine/sniper/anti_tank,
					/obj/item/ammo_magazine/sniper/anti_tank,
					/obj/item/ammo_magazine/sniper/anti_tank
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "anti-tank ammo crate"
	group = "Ammo"

/datum/supply_packs/pyro
	name = "M240-T fuel crate (extended x2, type-B x1, type-X x1)"
	contains = list(
					/obj/item/ammo_magazine/flamer_tank/large,
					/obj/item/ammo_magazine/flamer_tank/large,
					/obj/item/ammo_magazine/flamer_tank/large/B,
					/obj/item/ammo_magazine/flamer_tank/large/X
					)
	cost = RO_PRICE_PRICY
	containertype = /obj/structure/closet/crate/weapon
	containername = "\improper M240-T fuel crate"
	group = "Ammo"

/datum/supply_packs/ammo_rpg_regular
	name = "M5 RPG HE rockets crate (x6)"
	contains = list(
					/obj/item/ammo_magazine/rocket,
					/obj/item/ammo_magazine/rocket,
					/obj/item/ammo_magazine/rocket,
					/obj/item/ammo_magazine/rocket,
					/obj/item/ammo_magazine/rocket,
					/obj/item/ammo_magazine/rocket
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/explosives
	containername = "regular M5 RPG ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_rpg_ap
	name = "M5 RPG AP rockets crate (x6)"
	contains = list(
					/obj/item/ammo_magazine/rocket/ap,
					/obj/item/ammo_magazine/rocket/ap,
					/obj/item/ammo_magazine/rocket/ap,
					/obj/item/ammo_magazine/rocket/ap,
					/obj/item/ammo_magazine/rocket/ap,
					/obj/item/ammo_magazine/rocket/ap
					)
	cost = RO_PRICE_PRICY
	containertype = /obj/structure/closet/crate/explosives
	containername = "armor piercing M5 RPG ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_rpg_wp
	name = "M5 RPG WP rockets crate (x6)"
	contains = list(
					/obj/item/ammo_magazine/rocket/wp,
					/obj/item/ammo_magazine/rocket/wp,
					/obj/item/ammo_magazine/rocket/wp,
					/obj/item/ammo_magazine/rocket/wp,
					/obj/item/ammo_magazine/rocket/wp,
					/obj/item/ammo_magazine/rocket/wp
					)
	cost = RO_PRICE_PRICY
	containertype = /obj/structure/closet/crate/explosives
	containername = "white phosphorus M5 RPG ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_box_rifle
	name = "large 10x24mm ammo box crate (x600 rounds)"
	contains = list(/obj/item/big_ammo_box)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_box_rifle_ap
	name = "large armor piercing 10x24mm ammo box crate (x400 AP rounds)"
	contains = list(/obj/item/big_ammo_box/ap)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_box_smg
	name = "large M39 ammo box crate (x600 rounds)"
	contains = list(/obj/item/big_ammo_box/smg)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_box_smg_ap
	name = "large M39 ammo box crate (x400 AP rounds)"
	contains = list(/obj/item/big_ammo_box/smg/ap)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_black_market
	name = "black market ammo crate"
	randomised_num_contained = 6
	contains = list(
					/obj/item/ammo_magazine/revolver/upp,
					/obj/item/ammo_magazine/revolver/small,
					/obj/item/ammo_magazine/revolver/mateba,
					/obj/item/ammo_magazine/revolver/cmb,
					/obj/item/ammo_magazine/pistol/heavy,
					/obj/item/ammo_magazine/pistol/c99,
					/obj/item/ammo_magazine/pistol/automatic,
					/obj/item/ammo_magazine/pistol/holdout,
					/obj/item/ammo_magazine/pistol/highpower,
					/obj/item/ammo_magazine/pistol/vp70,
					/obj/item/ammo_magazine/pistol/vp78,
					/obj/item/ammo_magazine/smg/mp7,
					/obj/item/ammo_magazine/smg/skorpion,
					/obj/item/ammo_magazine/smg/ppsh,
					/obj/item/ammo_magazine/smg/ppsh/extended,
					/obj/item/ammo_magazine/smg/uzi,
					/obj/item/ammo_magazine/smg/fp9000,
					/obj/item/ammo_magazine/sniper/svd,
					/obj/item/ammo_magazine/rifle/m41aMK1,
					/obj/item/ammo_magazine/rifle/mar40,
					/obj/item/ammo_magazine/rifle/mar40/extended,
					)
	cost = RO_PRICE_NORMAL
	contraband = 1
	containertype = /obj/structure/closet/crate/ammo
	containername = "black market ammo crate"
	group = "Ammo"

//This crate has a little bit of everything, mostly okay stuff, but it does have some really unique picks.
/datum/supply_packs/surplus
	name = "surplus ammo crate (x10)"
	randomised_num_contained = 10
	contains = list(
					/obj/item/ammo_magazine/rifle,
					/obj/item/ammo_magazine/rifle,
					/obj/item/ammo_magazine/rifle,
					/obj/item/ammo_magazine/rifle/extended,
					/obj/item/ammo_magazine/rifle/ap,
					/obj/item/ammo_magazine/rifle/incendiary,
					/obj/item/ammo_magazine/rifle/l42mk1/incendiary,
					/obj/item/ammo_magazine/rifle/m41aMK1,
					/obj/item/ammo_magazine/rifle/m4ra,
					/obj/item/ammo_magazine/rifle/lmg,
					/obj/item/ammo_magazine/pistol,
					/obj/item/ammo_magazine/pistol,
					/obj/item/ammo_magazine/pistol,
					/obj/item/ammo_magazine/pistol/extended,
					/obj/item/ammo_magazine/pistol/ap,
					/obj/item/ammo_magazine/pistol/hp,
					/obj/item/ammo_magazine/pistol/incendiary,
					/obj/item/ammo_magazine/pistol/m1911,
					/obj/item/ammo_magazine/smg/m39,
					/obj/item/ammo_magazine/smg/m39,
					/obj/item/ammo_magazine/smg/m39,
					/obj/item/ammo_magazine/smg/m39/extended,
					/obj/item/ammo_magazine/smg/m39/ap,
					/obj/item/ammo_magazine/smg/m39/le,
					/obj/item/ammo_magazine/revolver,
					/obj/item/ammo_magazine/revolver,
					/obj/item/ammo_magazine/revolver,
					/obj/item/ammo_magazine/revolver/marksman,
					/obj/item/ammo_magazine/revolver/heavy,
					/obj/item/ammo_magazine/shotgun,
					/obj/item/ammo_magazine/shotgun,
					/obj/item/ammo_magazine/shotgun/buckshot,
					/obj/item/ammo_magazine/shotgun/buckshot,
					/obj/item/ammo_magazine/shotgun/incendiary,
					/obj/item/ammo_magazine/rifle/l42mk1/ap,
					/obj/item/ammo_magazine/rifle/l42mk1/extended,
					/obj/item/ammo_magazine/rifle/l42mk1
					)
	cost = RO_PRICE_PRICY
	containertype = /obj/structure/closet/crate/ammo
	containername = "surplus ammo crate"
	group = "Ammo"


/datum/supply_packs/ammo_smartgun
	name = "M56 smartgun powerpack crate (x2)"
	contains = list(
					/obj/item/smartgun_powerpack,
					/obj/item/smartgun_powerpack,
					/obj/item/ammo_magazine/smartgun/,
					/obj/item/ammo_magazine/smartgun/
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "smartgun powerpack crate"
	group = "Ammo"


/datum/supply_packs/ammo_sentry
	name = "UA 571-C sentry ammunition (x2)"
	contains = list(
					/obj/item/ammo_magazine/sentry,
					/obj/item/ammo_magazine/sentry
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "ammo crate"
	group = "Ammo"


/datum/supply_packs/napalm
	name = "UT-Napthal Fuel (x6)"
	contains = list(
					/obj/item/ammo_magazine/flamer_tank,
					/obj/item/ammo_magazine/flamer_tank,
					/obj/item/ammo_magazine/flamer_tank,
					/obj/item/ammo_magazine/flamer_tank,
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "napthal fuel crate"
	group = "Ammo"

/datum/supply_packs/napalm_gel
	name = "Napalm Gel (x4)"
	contains = list(
					/obj/item/ammo_magazine/flamer_tank/gellied,
					/obj/item/ammo_magazine/flamer_tank/gellied,
					/obj/item/ammo_magazine/flamer_tank/gellied,
					/obj/item/ammo_magazine/flamer_tank/gellied,
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "napalm gel crate"
	group = "Ammo"

/datum/supply_packs/napalm_gel_a
	name = "Napalm A Gel (x4)"
	contains = list(
					/obj/item/ammo_magazine/flamer_tank/large/gellied,
					/obj/item/ammo_magazine/flamer_tank/large/gellied,
					/obj/item/ammo_magazine/flamer_tank/large/gellied,
					/obj/item/ammo_magazine/flamer_tank/large/gellied,
					)
	cost = RO_PRICE_PRICY
	containertype = /obj/structure/closet/crate/ammo
	containername = "napalm gel a crate"
	group = "Ammo"


/datum/supply_packs/mortar_ammo_he
	name = "M402 mortar ammo crate (x8 HE)"
	cost = RO_PRICE_PRICY
	contains = list(
					/obj/item/mortal_shell/he,
					/obj/item/mortal_shell/he,
					/obj/item/mortal_shell/he,
					/obj/item/mortal_shell/he,
					/obj/item/mortal_shell/he,
					/obj/item/mortal_shell/he,
					/obj/item/mortal_shell/he,
					/obj/item/mortal_shell/he
					)
	containertype = /obj/structure/closet/crate/secure/mortar_ammo
	containername = "\improper M402 mortar ammo crate"
	group = "Ammo"

/datum/supply_packs/mortar_ammo_incend
	name = "M402 mortar ammo crate (x6 Incend)"
	cost = RO_PRICE_PRICY
	contains = list(
					/obj/item/mortal_shell/incendiary,
					/obj/item/mortal_shell/incendiary,
					/obj/item/mortal_shell/incendiary,
					/obj/item/mortal_shell/incendiary,
					/obj/item/mortal_shell/incendiary,
					/obj/item/mortal_shell/incendiary,
					/obj/item/mortal_shell/incendiary,
					/obj/item/mortal_shell/incendiary
					)
	containertype = /obj/structure/closet/crate/secure/mortar_ammo
	containername = "\improper M402 mortar ammo crate"
	group = "Ammo"

/datum/supply_packs/mortar_ammo_flare
	name = "M402 mortar ammo crate (x10 Flare)"
	cost = RO_PRICE_NORMAL
	contains = list(
					/obj/item/mortal_shell/flare,
					/obj/item/mortal_shell/flare,
					/obj/item/mortal_shell/flare,
					/obj/item/mortal_shell/flare,
					/obj/item/mortal_shell/flare,
					/obj/item/mortal_shell/flare,
					/obj/item/mortal_shell/flare,
					/obj/item/mortal_shell/flare,
					/obj/item/mortal_shell/flare,
					/obj/item/mortal_shell/flare
					)
	containertype = /obj/structure/closet/crate/secure/mortar_ammo
	containername = "\improper M402 mortar ammo crate"
	group = "Ammo"

/datum/supply_packs/mortar_ammo_smoke
	name = "M402 mortar ammo crate (x10 Smoke)"
	cost = RO_PRICE_NORMAL
	contains = list(
					/obj/item/mortal_shell/smoke,
					/obj/item/mortal_shell/smoke,
					/obj/item/mortal_shell/smoke,
					/obj/item/mortal_shell/smoke,
					/obj/item/mortal_shell/smoke,
					/obj/item/mortal_shell/smoke,
					/obj/item/mortal_shell/smoke,
					/obj/item/mortal_shell/smoke,
					/obj/item/mortal_shell/smoke,
					/obj/item/mortal_shell/smoke
					)
	containertype = /obj/structure/closet/crate/secure/mortar_ammo
	containername = "\improper M402 mortar ammo crate"
	group = "Ammo"

/datum/supply_packs/mortar_ammo_flash
	name = "M402 mortar ammo crate (x10 Flash)"
	cost = RO_PRICE_NORMAL
	contains = list(
					/obj/item/mortal_shell/flash,
					/obj/item/mortal_shell/flash,
					/obj/item/mortal_shell/flash,
					/obj/item/mortal_shell/flash,
					/obj/item/mortal_shell/flash,
					/obj/item/mortal_shell/flash,
					/obj/item/mortal_shell/flash,
					/obj/item/mortal_shell/flash,
					/obj/item/mortal_shell/flash,
					/obj/item/mortal_shell/flash
					)
	containertype = /obj/structure/closet/crate/secure/mortar_ammo
	containername = "\improper M402 mortar ammo crate"
	group = "Ammo"