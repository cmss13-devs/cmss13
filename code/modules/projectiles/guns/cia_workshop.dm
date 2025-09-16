/obj/item/weapon/gun/rifle/m16/m16a5/m16a6
	name = "\improper M16A6 rifle"
	desc = "A modernized version of M16 platform rifle, based upon the M16A5, this version has an auto-ejector and ammo counter. It is chambered in 5.56x45mm."
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_AMMO_COUNTER|GUN_CAN_POINTBLANK
	current_mag = /obj/item/ammo_magazine/rifle/m16/m16a5/ap

	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/custom,
		/obj/item/attachable/bayonet/wy,
		/obj/item/attachable/bayonet/custom/red,
		/obj/item/attachable/bayonet/custom/blue,
		/obj/item/attachable/bayonet/custom/black,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/bipod,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/attached_gun/grenade/grs,
		/obj/item/attachable/attached_gun/grenade/grs/hedp,
		/obj/item/attachable/attached_gun/grenade/grs/hedp_super,
		/obj/item/attachable/attached_gun/flamer,
		/obj/item/attachable/attached_gun/flamer/advanced,
		/obj/item/attachable/attached_gun/extinguisher,
		/obj/item/attachable/attached_gun/shotgun,
		/obj/item/attachable/lasersight,
	)

	random_spawn_chance = 100
	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
	)
	random_spawn_under = list(
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/lasersight,
	)
	random_spawn_muzzle = list(
		/obj/item/attachable/suppressor,
	)

/obj/item/weapon/gun/rifle/m16/m16a5/m16a6/heap
	current_mag = /obj/item/ammo_magazine/rifle/m16/m16a5/heap

/obj/item/weapon/gun/rifle/m16/m16a5/m16a6/grenadier
	random_spawn_under = list(
		/obj/item/attachable/attached_gun/grenade/grs/hedp,
	)

/obj/item/weapon/gun/rifle/m16/m16a5/m16a6/grenadier/heap
	random_spawn_under = list(
		/obj/item/attachable/attached_gun/grenade/grs/hedp_super,
	)
	current_mag = /obj/item/ammo_magazine/rifle/m16/m16a5/heap

//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------

/obj/item/weapon/gun/pistol/m1911/custom/tactical
	icon_state = "m1911cb"
	starting_attachment_types = list(/obj/item/attachable/suppressor, /obj/item/attachable/lasersight, /obj/item/attachable/reddot)

//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------

/obj/item/weapon/gun/rifle/m47 //PLACEHOLDER SPRITES
	name = "\improper M47 pulse rifle"
	desc = "A lightweight and powerful pulse rifle used by some special forces groups."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/assault_rifles.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/guns_by_type/assault_rifles.dmi',
		WEAR_J_STORE = 'icons/mob/humans/onmob/clothing/suit_storage/guns_by_type/assault_rifles.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/guns/assault_rifles_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/guns/assault_rifles_righthand.dmi'
	)
	icon_state = "M47"
	item_state = "M47"
	reload_sound = 'sound/weapons/handling/rmcdmr_reload.ogg'
	unload_sound = 'sound/weapons/handling/rmcdmr_unload.ogg'
	fire_sound = "gun_l64"
	current_mag = /obj/item/ammo_magazine/rifle/m47/ap
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_AMMO_COUNTER|GUN_CAN_POINTBLANK

	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/custom,
		/obj/item/attachable/bayonet/wy,
		/obj/item/attachable/bayonet/custom/red,
		/obj/item/attachable/bayonet/custom/blue,
		/obj/item/attachable/bayonet/custom/black,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/bipod,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/attached_gun/grenade/grs,
		/obj/item/attachable/attached_gun/grenade/grs/hedp,
		/obj/item/attachable/attached_gun/grenade/grs/hedp_super,
		/obj/item/attachable/attached_gun/flamer,
		/obj/item/attachable/attached_gun/flamer/advanced,
		/obj/item/attachable/attached_gun/extinguisher,
		/obj/item/attachable/attached_gun/shotgun,
		/obj/item/attachable/lasersight,
	)

	random_spawn_chance = 100
	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
	)
	random_spawn_under = list(
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/lasersight,
	)
//	random_spawn_muzzle = list(
//		/obj/item/attachable/suppressor,
//	)

/obj/item/weapon/gun/rifle/m47/handle_starting_attachment()
	..()
	var/obj/item/attachable/stock/m47pulse/stock = new(src)
	stock.flags_attach_features &= ~ATTACH_REMOVABLE
	stock.hidden = FALSE
	stock.Attach(src)
	update_attachable(stock.slot)

/obj/item/weapon/gun/rifle/m47/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 30, "muzzle_y" = 18, "rail_x" = 13, "rail_y" = 22, "under_x" = 23, "under_y" = 14, "stock_x" = 17, "stock_y" = 15)

/obj/item/weapon/gun/rifle/m47/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_11)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_11)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_7
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_10
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_6
	recoil_unwielded = RECOIL_AMOUNT_TIER_2

/obj/item/weapon/gun/rifle/m47/heap
	current_mag = /obj/item/ammo_magazine/rifle/m47/heap

/obj/item/weapon/gun/rifle/m47/grenadier
	random_spawn_under = list(
		/obj/item/attachable/attached_gun/grenade/grs/hedp,
	)

/obj/item/weapon/gun/rifle/m47/grenadier/heap
	random_spawn_under = list(
		/obj/item/attachable/attached_gun/grenade/grs/hedp_super,
	)
	current_mag = /obj/item/ammo_magazine/rifle/m47/heap

/obj/item/ammo_magazine/rifle/m47 //PLACEHOLDER SPRITES
	name = "\improper M47 magazine (10x24mm)"
	desc = "A magazine of 10x24mm caseless ammo for the M47 Pulse Rifle."
	caliber = "10x24mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/assault_rifles.dmi'
	icon_state = "M47"
	ammo_band_icon = "+M47_band"
	ammo_band_icon_empty = "+M47_band_e"
	w_class = SIZE_MEDIUM
	max_rounds = 50
	default_ammo = /datum/ammo/bullet/rifle
	gun_type = /obj/item/weapon/gun/rifle/m47

/obj/item/ammo_magazine/rifle/m47/incendiary
	name = "\improper M47 incendiary magazine (10x24mm)"
	desc = "An incendiary 10x24mm assault rifle magazine."
	default_ammo = /datum/ammo/bullet/rifle/incendiary
	ammo_band_color = AMMO_BAND_COLOR_INCENDIARY

/obj/item/ammo_magazine/rifle/m47/explosive
	name = "\improper M47 explosive magazine (10x24mm)"
	desc = "An explosive 10x24mm assault rifle magazine. Oh god... just don't hit friendlies with it."
	default_ammo = /datum/ammo/bullet/rifle/explosive
	ammo_band_color = AMMO_BAND_COLOR_EXPLOSIVE

/obj/item/ammo_magazine/rifle/m47/heap
	name = "\improper M47 HEAP magazine (10x24mm)"
	desc = "A high-explosive armor-piercing 10x24mm assault rifle magazine."
	default_ammo = /datum/ammo/bullet/rifle/heap
	ammo_band_color = AMMO_BAND_COLOR_HEAP

/obj/item/ammo_magazine/rifle/m47/ap
	name = "\improper M47 AP magazine (10x24mm)"
	desc = "An armor-piercing 10x24mm assault rifle magazine."
	desc_lore = "Unlike standard HEAP magazines, these reserve bullets do not have depleted uranium tips. Instead, these rounds trade off some of their bullet package for a lighter weight, reducing damage but increasing penetration capabilities and muzzle velocity."
	default_ammo = /datum/ammo/bullet/rifle/ap
	ammo_band_color = AMMO_BAND_COLOR_AP

/obj/item/ammo_magazine/rifle/m47/le
	name = "\improper M47 LE magazine (10x24mm)"
	desc = "An armor-shredding 10x24mm assault rifle magazine."
	default_ammo = /datum/ammo/bullet/rifle/le
	ammo_band_color = AMMO_BAND_COLOR_LIGHT_EXPLOSIVE

/obj/item/ammo_magazine/rifle/m47/penetrating
	name = "\improper M47 wall-penetrating magazine (10x24mm)"
	desc = "A wall-penetrating 10x24mm assault rifle magazine."
	default_ammo = /datum/ammo/bullet/rifle/ap/penetrating
	ammo_band_color = AMMO_BAND_COLOR_PENETRATING

/obj/item/ammo_magazine/rifle/m47/toxin
	name = "\improper M47 toxin magazine (10x24mm)"
	desc = "A toxin 10x24mm assault rifle magazine."
	default_ammo = /datum/ammo/bullet/rifle/ap/toxin
	ammo_band_color = AMMO_BAND_COLOR_TOXIN

/obj/item/ammo_magazine/rifle/m47/rubber
	name = "M47 Rubber Magazine (10x24mm)"
	desc = "A 10x24mm assault rifle magazine filled with rubber bullets."
	default_ammo = /datum/ammo/bullet/rifle/rubber
	ammo_band_color = AMMO_BAND_COLOR_RUBBER
