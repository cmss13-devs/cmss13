/*******************************************************************************
AMMO
*******************************************************************************/

//------------------------Ammunition Boxes crates----------------

/datum/supply_packs/ammo_rounds_box_smg
	name = "SMG ammo box crate (10x20mm) (x600 rounds)"
	contains = list(/obj/item/ammo_box/rounds/smg)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper SMG ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_rounds_box_smg_ap
	name = "SMG AP ammo box crate (10x20mm AP) (x600 rounds)"
	contains = list(/obj/item/ammo_box/rounds/smg/ap)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper SMG AP ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_rounds_box_rifle
	name = "Rifle ammo box crate (10x24mm) (x600 rounds)"
	contains = list(/obj/item/ammo_box/rounds)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper rifle ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_rounds_box_rifle_ap
	name = "Rifle AP ammo box crate (10x24mm AP) (x600 rounds)"
	contains = list(/obj/item/ammo_box/rounds/ap)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper rifle AP ammo crate"
	group = "Ammo"

//------------------------Magazine Boxes crates----------------

/datum/supply_packs/ammo_m4a3_mag_box
	name = "Magazine box (M4A3, 16x regular mags)"
	contains = list(
					/obj/item/ammo_box/magazine/m4a3
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M4A3 magazines crate"
	group = "Ammo"

/datum/supply_packs/ammo_m4a3_mag_box_ap
	name = "Magazine box (M4A3, 16x AP mags)"
	contains = list(
					/obj/item/ammo_box/magazine/m4a3/ap
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M4A3 AP magazines crate"
	group = "Ammo"

/datum/supply_packs/ammo_mod88_mag_box_ap
	name = "Magazine box (88 Mod 4 AP, 16x mags)"
	contains = list(
					/obj/item/ammo_box/magazine/mod88
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper 88 Mod 4 AP magazines crate"
	group = "Ammo"

/datum/supply_packs/ammo_vp78_mag_box
	name = "Magazine box (VP78, 16x mags)"
	contains = list(
					/obj/item/ammo_box/magazine/vp78
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper VP78 magazines crate"
	group = "Ammo"

/datum/supply_packs/ammo_su6_mag_box
	name = "Magazine box (SU-6, 16x mags)"
	contains = list(
					/obj/item/ammo_box/magazine/su6
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper SU-6 magazines crate"
	group = "Ammo"

/datum/supply_packs/ammo_smg_mag_box
	name = "Magazine box (M39, 12x regular mags)"
	contains = list(
					/obj/item/ammo_box/magazine/m39
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M39 magazines crate"
	group = "Ammo"

/datum/supply_packs/ammo_smg_mag_box_ap
	name = "Magazine box (M39, 12x AP mags)"
	contains = list(
					/obj/item/ammo_box/magazine/m39/ap
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M39 AP magazines crate"
	group = "Ammo"

/datum/supply_packs/ammo_smg_mag_box_ext
	name = "Magazine box (M39, 10x extended mags)"
	contains = list(
					/obj/item/ammo_box/magazine/m39/ext
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M39 extended magazines crate"
	group = "Ammo"

/datum/supply_packs/ammo_mag_box
	name = "Magazine box (M41A, 10x regular mags)"
	contains = list(
					/obj/item/ammo_box/magazine
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M41A magazines crate"
	group = "Ammo"

/datum/supply_packs/ammo_mag_box_ap
	name = "Magazine box (M41A, 10x AP mags)"
	contains = list(
					/obj/item/ammo_box/magazine/ap
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M41A AP magazines crate"
	group = "Ammo"

/datum/supply_packs/ammo_mag_box_ext
	name = "Magazine box (M41A, 8x extended mags)"
	contains = list(
					/obj/item/ammo_box/magazine/ext
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M41A extended magazines crate"
	group = "Ammo"

/datum/supply_packs/ammo_l42_mag_box
	name = "Magazine box (L42A, 16x mags)"
	contains = list(
					/obj/item/ammo_box/magazine/l42a
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper L42A magazines crate"
	group = "Ammo"

/datum/supply_packs/ammo_l42_mag_box_ap
	name = "Magazine box (L42A, 16x AP mags)"
	contains = list(
					/obj/item/ammo_box/magazine/l42a/ap
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper L42A AP magazines crate"
	group = "Ammo"

/datum/supply_packs/ammo_m44_mag_box
	name = "Speed loaders box (M44, 16x)"
	contains = list(
					/obj/item/ammo_box/magazine/m44
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M44 speed loaders crate"
	group = "Ammo"

/datum/supply_packs/ammo_m44_mag_box_ap
	name = "Speed loaders box (Marksman M44, 16x)"
	contains = list(
					/obj/item/ammo_box/magazine/m44/marksman
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M44 Marksman speed loaders crate"
	group = "Ammo"

/datum/supply_packs/ammo_m44_mag_box_heavy
	name = "Speed loaders box (Heavy M44, 16x)"
	contains = list(
					/obj/item/ammo_box/magazine/m44/heavy
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M44 Heavy speed loaders crate"
	group = "Ammo"

/datum/supply_packs/ammo_shell_box
	name = "Shell box (100x slug shells)"
	contains = list(
					/obj/item/ammo_box/magazine/shotgun
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper shotgun slugs crate"
	group = "Ammo"

/datum/supply_packs/ammo_shell_box_buck
	name = "Shell box (100x buckshot shells)"
	contains = list(
					/obj/item/ammo_box/magazine/shotgun/buckshot
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper shotgun buckshot crate"
	group = "Ammo"

/datum/supply_packs/ammo_shell_box_flechette
	name = "Shell box (100x flechette shells)"
	contains = list(
					/obj/item/ammo_box/magazine/shotgun/flechette
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper shotgun flechette crate"
	group = "Ammo"

//------------------------Misc ammo crates----------------

/datum/supply_packs/ammo_hpr
	contains = list(
					/obj/item/ammo_magazine/rifle/lmg,
					/obj/item/ammo_magazine/rifle/lmg
					)
	name = "M41AE2 HPR Magazines crate (HPR ammo box x2)"
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate
	containername = "\improper M41AE2 HPR magazines crate"
	group = "Ammo"

/datum/supply_packs/ammo_smartgun_powerpack
	name = "M56 smartgun powerpack crate (x2)"
	contains = list(
					/obj/item/smartgun_powerpack,
					/obj/item/smartgun_powerpack
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper smartgun powerpacks crate"
	group = "Ammo"

/datum/supply_packs/ammo_smartgun
	name = "M56 smartgun drum crate (x2)"
	contains = list(
					/obj/item/ammo_magazine/smartgun,
					/obj/item/ammo_magazine/smartgun
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper smartgun drums crate"
	group = "Ammo"

/datum/supply_packs/ammo_sentry
	name = "UA 571-C sentry ammunition (x2)"
	contains = list(
					/obj/item/ammo_magazine/sentry,
					/obj/item/ammo_magazine/sentry
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper sentry ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_sentry_flamer
	name = "UA 42-F sentry flamer ammunition (x2)"
	contains = list(
					/obj/item/ammo_magazine/sentry_flamer,
					/obj/item/ammo_magazine/sentry_flamer
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper sentry flamer ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_napalm
	name = "UT-Napthal Fuel (x4)"
	contains = list(
					/obj/item/ammo_magazine/flamer_tank,
					/obj/item/ammo_magazine/flamer_tank,
					/obj/item/ammo_magazine/flamer_tank,
					/obj/item/ammo_magazine/flamer_tank
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper napthal fuel crate"
	group = "Ammo"

/datum/supply_packs/ammo_napalm_gel
	name = "Napalm Gel (x4)"
	contains = list(
					/obj/item/ammo_magazine/flamer_tank/gellied,
					/obj/item/ammo_magazine/flamer_tank/gellied,
					/obj/item/ammo_magazine/flamer_tank/gellied,
					/obj/item/ammo_magazine/flamer_tank/gellied
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper napalm gel crate"
	group = "Ammo"

/datum/supply_packs/ammo_black_market
	name = "Black market ammo crate"
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
					/obj/item/ammo_magazine/pistol/mod88,
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
	containername = "\improper black market ammo crate"
	group = "Ammo"

//This crate has a little bit of everything, mostly okay stuff, but it does have some really unique picks.
/datum/supply_packs/ammo_surplus
	name = "Surplus ammo crate (various USCM magazines x10)"
	randomised_num_contained = 10
	contains = list(
					/obj/item/ammo_magazine/rifle,
					/obj/item/ammo_magazine/rifle,
					/obj/item/ammo_magazine/rifle,
					/obj/item/ammo_magazine/rifle/extended,
					/obj/item/ammo_magazine/rifle/ap,
					/obj/item/ammo_magazine/rifle/incendiary,
					/obj/item/ammo_magazine/rifle/l42a/incendiary,
					/obj/item/ammo_magazine/rifle/m41aMK1,
					/obj/item/ammo_magazine/rifle/m4ra,
					/obj/item/ammo_magazine/rifle/lmg,
					/obj/item/ammo_magazine/pistol,
					/obj/item/ammo_magazine/pistol,
					/obj/item/ammo_magazine/pistol,
					/obj/item/ammo_magazine/pistol/incendiary,
					/obj/item/ammo_magazine/smg/m39,
					/obj/item/ammo_magazine/smg/m39,
					/obj/item/ammo_magazine/smg/m39,
					/obj/item/ammo_magazine/smg/m39/extended,
					/obj/item/ammo_magazine/smg/m39/ap,
					/obj/item/ammo_magazine/smg/m39/ap,
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
					/obj/item/ammo_magazine/rifle/l42a/ap,
					/obj/item/ammo_magazine/rifle/l42a
					)
	cost = RO_PRICE_PRICY
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper surplus ammo crate"
	group = "Ammo"

//------------------------Specialists ammunition crates----------------

//M5 RPG

/datum/supply_packs/ammo_rpg_regular
	name = "M5 RPG rockets crate (HE x1, AP x1, WP x1)"
	contains = list(
					/obj/item/ammo_magazine/rocket,
					/obj/item/ammo_magazine/rocket/ap,
					/obj/item/ammo_magazine/rocket/wp
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper M5 RPG rockets crate"
	group = "Ammo"

/datum/supply_packs/ammo_rpg_he
	name = "M5 RPG HE rockets crate (x3)"
	contains = list(
					/obj/item/ammo_magazine/rocket,
					/obj/item/ammo_magazine/rocket,
					/obj/item/ammo_magazine/rocket
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper high-explosive M5 RPG rockets crate"
	group = "Ammo"

/datum/supply_packs/ammo_rpg_ap
	name = "M5 RPG AP rockets crate (x3)"
	contains = list(
					/obj/item/ammo_magazine/rocket/ap,
					/obj/item/ammo_magazine/rocket/ap,
					/obj/item/ammo_magazine/rocket/ap
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper armor piercing M5 RPG rockets crate"
	group = "Ammo"

/datum/supply_packs/ammo_rpg_wp
	name = "M5 RPG WP rockets crate (x3)"
	contains = list(
					/obj/item/ammo_magazine/rocket/wp,
					/obj/item/ammo_magazine/rocket/wp,
					/obj/item/ammo_magazine/rocket/wp
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper white phosphorus M5 RPG rockets crate"
	group = "Ammo"

//M42A

/datum/supply_packs/ammo_sniper_mix
	name = "M42A magazines crate (marksman x2, flak x2, incendiary x2)"
	contains = list(
					/obj/item/ammo_magazine/sniper,
					/obj/item/ammo_magazine/sniper,
					/obj/item/ammo_magazine/sniper/flak,
					/obj/item/ammo_magazine/sniper/flak,
					/obj/item/ammo_magazine/sniper/incendiary,
					/obj/item/ammo_magazine/sniper/incendiary
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper sniper ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_sniper_marksman
	name = "M42A sniper marksman magazines crate (x5)"
	contains = list(
					/obj/item/ammo_magazine/sniper,
					/obj/item/ammo_magazine/sniper,
					/obj/item/ammo_magazine/sniper,
					/obj/item/ammo_magazine/sniper,
					/obj/item/ammo_magazine/sniper
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper marksman sniper ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_sniper_flak
	name = "M42A sniper flak magazines crate (x5)"
	contains = list(
					/obj/item/ammo_magazine/sniper/flak,
					/obj/item/ammo_magazine/sniper/flak,
					/obj/item/ammo_magazine/sniper/flak,
					/obj/item/ammo_magazine/sniper/flak,
					/obj/item/ammo_magazine/sniper/flak
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper flak sniper ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_sniper_incendiary
	name = "M42A sniper incendiary magazines crate (x5)"
	contains = list(
					/obj/item/ammo_magazine/sniper/incendiary,
					/obj/item/ammo_magazine/sniper/incendiary,
					/obj/item/ammo_magazine/sniper/incendiary,
					/obj/item/ammo_magazine/sniper/incendiary,
					/obj/item/ammo_magazine/sniper/incendiary
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper incendiary sniper ammo crate"
	group = "Ammo"

//M4RA

/datum/supply_packs/ammo_scout_mix
	name = "M4RA A19 high velocity magazines crate (regular x2, incendiary x2, impact x2)"
	contains = list(
					/obj/item/ammo_magazine/rifle/m4ra,
					/obj/item/ammo_magazine/rifle/m4ra,
					/obj/item/ammo_magazine/rifle/m4ra/incendiary,
					/obj/item/ammo_magazine/rifle/m4ra/incendiary,
					/obj/item/ammo_magazine/rifle/m4ra/impact,
					/obj/item/ammo_magazine/rifle/m4ra/impact
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper scout ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_scout_regular
	name = "M4RA A19 high velocity magazines crate (x5)"
	contains = list(
					/obj/item/ammo_magazine/rifle/m4ra,
					/obj/item/ammo_magazine/rifle/m4ra,
					/obj/item/ammo_magazine/rifle/m4ra,
					/obj/item/ammo_magazine/rifle/m4ra,
					/obj/item/ammo_magazine/rifle/m4ra
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper scout regular ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_scout_incendiary
	name = "M4RA A19 high velocity incendiary magazines crate (x5)"
	contains = list(
					/obj/item/ammo_magazine/rifle/m4ra/incendiary,
					/obj/item/ammo_magazine/rifle/m4ra/incendiary,
					/obj/item/ammo_magazine/rifle/m4ra/incendiary,
					/obj/item/ammo_magazine/rifle/m4ra/incendiary,
					/obj/item/ammo_magazine/rifle/m4ra/incendiary
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper scout incendiary ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_scout_impact
	name = "M4RA A19 high velocity impact magazines crate (x5)"
	contains = list(
					/obj/item/ammo_magazine/rifle/m4ra/impact,
					/obj/item/ammo_magazine/rifle/m4ra/impact,
					/obj/item/ammo_magazine/rifle/m4ra/impact,
					/obj/item/ammo_magazine/rifle/m4ra/impact,
					/obj/item/ammo_magazine/rifle/m4ra/impact
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper scout impact ammo crate"
	group = "Ammo"

//M240-T

/datum/supply_packs/ammo_pyro_mix
	name = "M240-T fuel crate (extended x1, A Gel x1, type-B x1, type-X x1)"
	contains = list(
					/obj/item/ammo_magazine/flamer_tank/large,
					/obj/item/ammo_magazine/flamer_tank/large/B,
					/obj/item/ammo_magazine/flamer_tank/large/X
					)
	cost = RO_PRICE_PRICY
	containertype = /obj/structure/closet/crate/weapon
	containername = "\improper M240-T fuel tanks crate"
	group = "Ammo"

/datum/supply_packs/ammo_pyro_extended
	name = "M240-T fuel crate (extended x3)"
	contains = list(
					/obj/item/ammo_magazine/flamer_tank/large,
					/obj/item/ammo_magazine/flamer_tank/large,
					/obj/item/ammo_magazine/flamer_tank/large
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/weapon
	containername = "\improper M240-T extended fuel tanks crate"
	group = "Ammo"

/datum/supply_packs/ammo_pyro_b
	name = "M240-T fuel crate (type-B x1)"
	contains = list(
					/obj/item/ammo_magazine/flamer_tank/large/B
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/weapon
	containername = "\improper M240-T type-B fuel tanks crate"
	group = "Ammo"

/datum/supply_packs/ammo_pyro_x
	name = "M240-T fuel crate (type-X x1)"
	contains = list(
					/obj/item/ammo_magazine/flamer_tank/large/X
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/weapon
	containername = "\improper M240-T type-X fuel tanks crate"
	group = "Ammo"

//------------------------Mortar ammunition crates----------------

/datum/supply_packs/ammo_mortar_he
	name = "M402 mortar shells crate (x6 HE)"
	cost = RO_PRICE_VERY_CHEAP
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
	group = "Ammo"

/datum/supply_packs/ammo_mortar_incend
	name = "M402 mortar shells crate (x6 Incend)"
	cost = RO_PRICE_VERY_CHEAP
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
	group = "Ammo"

/datum/supply_packs/ammo_mortar_flare
	name = "M402 mortar shells crate (x6 Flare)"
	cost = RO_PRICE_VERY_CHEAP
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
	group = "Ammo"