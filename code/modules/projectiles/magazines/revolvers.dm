
//external magazines

/obj/item/ammo_magazine/revolver
	name = "\improper M44 speed loader (.44)"
	desc = "A 7-round .44 revolver speed loader."
	default_ammo = /datum/ammo/bullet/revolver
	flags_equip_slot = NO_FLAGS
	caliber = ".44"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/revolvers.dmi'
	icon_state = "m44"
	item_state = "generic_speedloader"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/ammo_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/ammo_righthand.dmi'
		)
	w_class = SIZE_SMALL
	max_rounds = 7
	gun_type = /obj/item/weapon/gun/revolver/m44
	ammo_band_icon = "+m44_tip"
	ammo_band_icon_empty = "empty"

/obj/item/ammo_magazine/revolver/marksman
	name = "\improper M44 marksman speed loader (.44)"
	desc = "A 7-round .44 revolver speed loader containing long-range armor-piercing marksman bullets."
	default_ammo = /datum/ammo/bullet/revolver/marksman
	caliber = ".44"
	ammo_band_color = REVOLVER_TIP_COLOR_MARKSMAN

/obj/item/ammo_magazine/revolver/heavy
	name = "\improper M44 heavy speed loader (.44)"
	desc = "A 7-round .44 revolver speed loader containing heavy bullets. While less damaging than traditional .44 rounds, they deliver a higher stopping power."
	default_ammo = /datum/ammo/bullet/revolver/heavy
	caliber = ".44"
	ammo_band_color = REVOLVER_TIP_COLOR_HEAVY

/obj/item/ammo_magazine/revolver/incendiary
	name = "\improper M44 incendiary speed loader (.44)"
	desc = "a 7-round .44 revolver speed loader containing incendiary bullets."
	default_ammo = /datum/ammo/bullet/revolver/incendiary
	ammo_band_color = REVOLVER_TIP_COLOR_INCENDIARY

/obj/item/ammo_magazine/revolver/marksman/toxin
	name = "\improper M44 toxic speed loader (.44)"
	desc = "a 7-round .44 revolver speed loader containing toxin bullets."
	default_ammo = /datum/ammo/bullet/revolver/marksman/toxin
	ammo_band_color = REVOLVER_TIP_COLOR_TOXIN

/obj/item/ammo_magazine/revolver/penetrating
	name = "\improper M44 wall-penetrating speed loader (.44)"
	desc = "A 7-round .44 revolver speed loader containing wall-penetrating bullets."
	default_ammo = /datum/ammo/bullet/revolver/penetrating
	ammo_band_color = REVOLVER_TIP_COLOR_PENETRATING

/**
 * COLONY REVOLVERS
 */

/obj/item/ammo_magazine/revolver/pkd
	name = "\improper Plfager Katsuma stripper clip (.44)"
	desc = "Flip up the two side latches (three on PKL) and push after aligning with feed lips on blaster. Clip can be re-used."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony/revolvers.dmi'
	icon_state = "pkd_44"
	caliber = ".44 sabot"

/obj/item/ammo_magazine/revolver/upp
	name = "\improper ZHNK-72 speed loader (7.62x38mmR)"
	desc = "A 7-round 7.62x38mmR revolver speed loader."
	default_ammo = /datum/ammo/bullet/revolver/upp
	caliber = "7.62x38mmR"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/UPP/revolvers.dmi'
	icon_state = "zhnk72loader"
	gun_type = /obj/item/weapon/gun/revolver/upp

/obj/item/ammo_magazine/revolver/upp/shrapnel
	name = "\improper ZHNK-72 shrapnel-shot speed loader (7.62x38mmR)"
	desc = "This speedloader contains seven 'shrapnel-shot' bullets, cheap recycled casings picked up off the ground and refilled with gunpowder and random scrap metal. Acts similarly to flechette."
	default_ammo = /datum/ammo/bullet/revolver/upp/shrapnel
	icon_state = "zhnk72loader_shrapnel"

/obj/item/ammo_magazine/revolver/small
	name = "\improper S&W speed loader (.38)"
	desc = "a 6-round .38 revolver speed loader."
	default_ammo = /datum/ammo/bullet/revolver/small
	caliber = ".38"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony/revolvers.dmi'
	icon_state = "38"
	max_rounds = 6
	gun_type = /obj/item/weapon/gun/revolver/small

/obj/item/ammo_magazine/revolver/cmb
	name = "\improper Spearhead hollowpoint speed loader (.357)"
	desc = "This 6-round speed loader was created for the Colonial Marshals' most commonly issued sidearm, loaded with hollow-point rounds either for colonies with wildlife problems or orbital stations, which favor the lesser penetration over other ammunition to reduce the risk of hull breaches. In exchange, they're near useless against armored targets, but what's the chance of that being a problem on a space station?"
	default_ammo = /datum/ammo/bullet/revolver/small/hollowpoint
	caliber = ".357"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony/revolvers.dmi'
	icon_state = "cmb_hp"
	max_rounds = 6
	gun_type = /obj/item/weapon/gun/revolver/cmb

/obj/item/ammo_magazine/revolver/cmb/normalpoint //put these in the marshal ert - ok sure :)
	name = "\improper Spearhead speed loader (.357)"
	desc = "This 6-round speed loader is fitted with standard .357 revolver bullets. A surprising rarity, as most CMB revolvers are issued with hollow-point rounds to Marshals on colonies with inimical wildlife, or thin-hulled space stations."
	default_ammo = /datum/ammo/bullet/revolver/small/cmb
	icon_state = "cmb"

/**
 * MATEBA REVOLVER
 */

/obj/item/ammo_magazine/revolver/mateba
	name = "\improper Mateba speed loader (.454)"
	desc = "A formidable 6-round .454 speedloader, made exclusively for the Mateba autorevolver. Packs a devastating punch. This standard-variant is optimized for anti-armor."
	default_ammo = /datum/ammo/bullet/revolver/mateba
	caliber = ".454"
	icon_state = "mateba"
	max_rounds = 6
	gun_type = /obj/item/weapon/gun/revolver/mateba

/obj/item/ammo_magazine/revolver/mateba/highimpact
	name = "\improper High Impact Mateba speed loader (.454)"
	desc = "A formidable 6-round .454 speedloader, made exclusively for the Mateba autorevolver. Packs a devastating punch. This high impact variant is optimized for anti-personnel. Don't point at anything you don't want to destroy."
	default_ammo = /datum/ammo/bullet/revolver/mateba/highimpact
	ammo_band_color = REVOLVER_TIP_COLOR_HIGH_IMPACT

/obj/item/ammo_magazine/revolver/mateba/highimpact/ap
	name = "\improper High Impact Armor-Piercing Mateba speed loader (.454)"
	desc = "A formidable 6-round .454 speedloader, made exclusively for the Mateba autorevolver. Packs a devastating punch. This armor-piercing variant is optimized against armored targets at the cost of lower overall damage. Don't point at anything you don't want to destroy."
	default_ammo = /datum/ammo/bullet/revolver/mateba/highimpact/ap
	ammo_band_color = REVOLVER_TIP_COLOR_AP

/obj/item/ammo_magazine/revolver/mateba/highimpact/explosive
	name = "\improper Mateba explosive speed loader (.454)"
	desc = "A formidable 6-round .454 speedloader, made exclusively for the Mateba autorevolver. There's an impact charge built into the bullet tip. Firing this at anything will result in a powerful explosion. Use with EXTREME caution."
	default_ammo = /datum/ammo/bullet/revolver/mateba/highimpact/explosive
	ammo_band_color = REVOLVER_TIP_COLOR_EXPLOSIVE

/**
 * WEBLEY REVOLVER
*/

/obj/item/ammo_magazine/revolver/webley
	name = "\improper Webley speed loader (.455)"
	desc = ".455 Webley, the last decent pistol calibre. Loaded with Mk III dum-dum bullets, because Marines are not human and the Hague Conventions do not apply to them."
	default_ammo = /datum/ammo/bullet/revolver/webley
	caliber = ".455"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony/revolvers.dmi'
	icon_state = "357"
	max_rounds = 6
	gun_type = /obj/item/weapon/gun/revolver/m44/custom/webley

//INTERNAL MAGAZINES

//---------------------------------------------------

/obj/item/ammo_magazine/internal/revolver
	name = "revolver cylinder"
	default_ammo = /datum/ammo/bullet/revolver
	max_rounds = 6
	gun_type = /obj/item/weapon/gun/revolver

//-------------------------------------------------------
//M44 MAGNUM REVOLVER //Not actually cannon, but close enough.

/obj/item/ammo_magazine/internal/revolver/m44
	caliber = ".44"
	max_rounds = 7
	gun_type = /obj/item/weapon/gun/revolver/m44

/obj/item/ammo_magazine/internal/revolver/m44/pkd
	max_rounds = 8
	caliber = ".44 sabot"

/obj/item/ammo_magazine/internal/revolver/m44/marksman
	default_ammo = /datum/ammo/bullet/revolver/marksman //because the starting m44 custom revolver belt is full of marksman ammo, but your gun would have normal ammo loaded

//-------------------------------------------------------
//RUSSIAN REVOLVER //Based on the 7.62mm Russian revolvers.

/obj/item/ammo_magazine/internal/revolver/upp
	default_ammo = /datum/ammo/bullet/revolver/upp
	caliber = "7.62x38mmR"
	max_rounds = 7
	gun_type = /obj/item/weapon/gun/revolver/upp

/obj/item/ammo_magazine/internal/revolver/upp/shrapnel
	default_ammo = /datum/ammo/bullet/revolver/upp/shrapnel


//-------------------------------------------------------
//357 REVOLVER //Based on the generic S&W 357.

/obj/item/ammo_magazine/internal/revolver/small
	default_ammo = /datum/ammo/bullet/revolver/small
	caliber = ".38"
	gun_type = /obj/item/weapon/gun/revolver/small

//-------------------------------------------------------
//BURST REVOLVER //Mateba is pretty well known. The cylinder folds up instead of to the side.

/obj/item/ammo_magazine/internal/revolver/mateba
	default_ammo = /datum/ammo/bullet/revolver
	caliber = ".454"
	gun_type = /obj/item/weapon/gun/revolver/mateba

/obj/item/ammo_magazine/internal/revolver/mateba/impact
	default_ammo = /datum/ammo/bullet/revolver/mateba/highimpact

/obj/item/ammo_magazine/internal/revolver/mateba/ap
	default_ammo = /datum/ammo/bullet/revolver/mateba/highimpact/ap

/obj/item/ammo_magazine/internal/revolver/mateba/explosive
	default_ammo = /datum/ammo/bullet/revolver/mateba/highimpact/explosive

//-------------------------------------------------------
//MARSHALS REVOLVER //Spearhead exists in Alien cannon.

/obj/item/ammo_magazine/internal/revolver/cmb
	default_ammo = /datum/ammo/bullet/revolver/small/cmb
	caliber = ".357"
	gun_type = /obj/item/weapon/gun/revolver/cmb

/obj/item/ammo_magazine/internal/revolver/cmb/hollowpoint
	default_ammo = /datum/ammo/bullet/revolver/small/hollowpoint
	caliber = ".357"
	gun_type = /obj/item/weapon/gun/revolver/cmb

//-------------------------------------------------------
//BIG GAME HUNTER'S REVOLVER
/obj/item/ammo_magazine/internal/revolver/webley
	caliber = ".455"
	default_ammo = /datum/ammo/bullet/revolver/webley
	gun_type = /obj/item/weapon/gun/revolver/m44/custom/webley
