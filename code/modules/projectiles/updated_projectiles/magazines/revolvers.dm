
//external magazines

/obj/item/ammo_magazine/revolver
	name = "\improper M44 speed loader (.44)"
	desc = "A revolver speed loader."
	default_ammo = /datum/ammo/bullet/revolver
	flags_equip_slot = NO_FLAGS
	caliber = ".44"
	icon_state = "m44"
	item_state = "generic_speedloader"
	w_class = SIZE_SMALL
	max_rounds = 7
	gun_type = /obj/item/weapon/gun/revolver/m44

/obj/item/ammo_magazine/revolver/marksman
	name = "\improper M44 marksman speed loader (.44)"
	default_ammo = /datum/ammo/bullet/revolver/marksman
	caliber = ".44"
	icon_state = "m_m44"

/obj/item/ammo_magazine/revolver/heavy
	name = "\improper M44 heavy speed loader (.44)"
	default_ammo = /datum/ammo/bullet/revolver/heavy
	caliber = ".44"
	icon_state = "h_m44"


/obj/item/ammo_magazine/revolver/upp
	name = "\improper N-Y speed loader (7.62x38mmR)"
	default_ammo = /datum/ammo/bullet/revolver/small
	caliber = "7.62x38mmR"
	icon_state = "ny762"
	gun_type = /obj/item/weapon/gun/revolver/upp


/obj/item/ammo_magazine/revolver/small
	name = "\improper S&W speed loader (.357)"
	default_ammo = /datum/ammo/bullet/revolver/small
	caliber = ".357"
	icon_state = "sw357"
	max_rounds = 6
	gun_type = /obj/item/weapon/gun/revolver/small


/obj/item/ammo_magazine/revolver/mateba
	name = "\improper Mateba speed loader (.454)"
	default_ammo = /datum/ammo/bullet/revolver/highimpact
	caliber = ".454"
	icon_state = "mateba"
	max_rounds = 6
	gun_type = /obj/item/weapon/gun/revolver/mateba


/obj/item/ammo_magazine/revolver/cmb
	name = "\improper Spearhead speed loader (.357)"
	default_ammo = /datum/ammo/bullet/revolver/small
	caliber = ".357"
	icon_state = "spearhead"
	max_rounds = 6
	gun_type = /obj/item/weapon/gun/revolver/cmb




//INTERNAL MAGAZINES

//---------------------------------------------------

/obj/item/ammo_magazine/internal/revolver
	name = "revolver cylinder"
	default_ammo = /datum/ammo/bullet/revolver
	max_rounds = 6

//-------------------------------------------------------
//M44 MAGNUM REVOLVER //Not actually cannon, but close enough.

/obj/item/ammo_magazine/internal/revolver/m44
	caliber = ".44"
	max_rounds = 7
	gun_type = /obj/item/weapon/gun/revolver/m44

/obj/item/ammo_magazine/internal/revolver/m44/custom
	caliber = ".44"
	max_rounds = 7
	default_ammo = /datum/ammo/bullet/revolver/marksman //because the starting m44 custom revolver belt is full of marksman ammo, but your gun would have normal ammo loaded
	gun_type = /obj/item/weapon/gun/revolver/m44/custom

//-------------------------------------------------------
//RUSSIAN REVOLVER //Based on the 7.62mm Russian revolvers.

/obj/item/ammo_magazine/internal/revolver/upp
	default_ammo = /datum/ammo/bullet/revolver/small
	caliber = "7.62x38mmR"
	max_rounds = 7
	gun_type = /obj/item/weapon/gun/revolver/upp

//-------------------------------------------------------
//357 REVOLVER //Based on the generic S&W 357.

/obj/item/ammo_magazine/internal/revolver/small
	default_ammo = /datum/ammo/bullet/revolver/small
	caliber = ".357"
	gun_type = /obj/item/weapon/gun/revolver/small

//-------------------------------------------------------
//BURST REVOLVER //Mateba is pretty well known. The cylinder folds up instead of to the side.

/obj/item/ammo_magazine/internal/revolver/mateba
	default_ammo = /datum/ammo/bullet/revolver/highimpact
	caliber = ".454"
	gun_type = /obj/item/weapon/gun/revolver/mateba

//-------------------------------------------------------
//MARSHALS REVOLVER //Spearhead exists in Alien cannon.

/obj/item/ammo_magazine/internal/revolver/cmb
	default_ammo = /datum/ammo/bullet/revolver/small
	caliber = ".357"
	gun_type = /obj/item/weapon/gun/revolver/cmb

