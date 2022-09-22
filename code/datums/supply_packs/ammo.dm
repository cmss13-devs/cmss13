//*******************************************************************************
//AMMO
//*******************************************************************************/

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

/datum/supply_packs/ammo_rounds_box_xm88
	name = ".458 bullets box crate (x300 rounds)"
	contains = list(/obj/item/ammo_box/magazine/lever_action/xm88)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper .458 bullets crate"
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

/datum/supply_packs/ammo_m4a3_mag_box_hp
	name = "Magazine box (M4A3, 16x HP mags)"
	contains = list(
					/obj/item/ammo_box/magazine/m4a3/hp
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M4A3 HP magazines crate"
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
	containername = "\improper M39 HV magazines crate"
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

/datum/supply_packs/merc/ammo
	name = "Black market ammo crate"
	contains = list()
	cost = RO_PRICE_VERY_CHEAP
	contraband = 1
	containertype = /obj/structure/largecrate/merc/ammo
	containername = "\improper black market ammo crate"
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

/datum/supply_packs/ammo_hpr_holo
	contains = list(
					/obj/item/ammo_magazine/rifle/lmg/holo_target,
					/obj/item/ammo_magazine/rifle/lmg/holo_target
					)
	name = "M41AE2 HPR Holo-Target Magazines crate (HPR HT ammo box x2)"
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate
	containername = "\improper M41AE2 HPR holo-target magazines crate"
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

/datum/supply_packs/ammo_sentry_shotgun
	name = "UA 12-G sentry shotgun ammunition (x2)"
	contains = list(
					/obj/item/ammo_magazine/sentry/shotgun,
					/obj/item/ammo_magazine/sentry/shotgun
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper sentry shotgun ammo crate"
	group = "Ammo"

/datum/supply_packs/ammo_napalm
	name = "M240 UT-Napthal Fuel (x4)"
	contains = list(
					/obj/item/ammo_magazine/flamer_tank,
					/obj/item/ammo_magazine/flamer_tank,
					/obj/item/ammo_magazine/flamer_tank,
					/obj/item/ammo_magazine/flamer_tank
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo/alt/flame
	containername = "\improper napthal fuel crate"
	group = "Ammo"

/datum/supply_packs/ammo_napalm_gel
	name = "M240 Napalm B-Gel (x4)"
	contains = list(
					/obj/item/ammo_magazine/flamer_tank/gellied,
					/obj/item/ammo_magazine/flamer_tank/gellied,
					/obj/item/ammo_magazine/flamer_tank/gellied,
					/obj/item/ammo_magazine/flamer_tank/gellied
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo/alt/flame
	containername = "\improper napalm gel crate"
	group = "Ammo"

/datum/supply_packs/ammo_flamer_mixed
	name = "M240 Fuel Crate (x2 normal, x2 b-gel)"
	contains = list(/obj/item/ammo_magazine/flamer_tank,
					/obj/item/ammo_magazine/flamer_tank,
					/obj/item/ammo_magazine/flamer_tank/gellied,
					/obj/item/ammo_magazine/flamer_tank/gellied)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate/ammo/alt/flame
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
					/obj/item/ammo_magazine/rifle/m41aMK1/ap,
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
	name = "M402 mortar shells crate (x6 Flare/Camera)"
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
