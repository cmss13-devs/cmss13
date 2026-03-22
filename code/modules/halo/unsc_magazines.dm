// rifle magazines

/obj/item/ammo_magazine/rifle/halo
	name = "halo magazine"
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_magazines.dmi'
	icon_state = null
	ammo_band_icon = null
	ammo_band_icon_empty = null

/obj/item/ammo_magazine/rifle/halo/ma5c
	name = "\improper MA5C magazine (7.62x51mm FMJ)"
	desc = "A rectangular box magazine for the MA5C holding 48 rounds of 7.62x51 FMJ ammunitions."
	icon_state = "ma5c"
	max_rounds = 48
	gun_type = /obj/item/weapon/gun/rifle/halo/ma5c
	default_ammo = /datum/ammo/bullet/rifle/ma5c
	caliber = "7.62x51"
	ammo_band_icon = "+ma5c_band"
	ammo_band_icon_empty = "+ma5c_band_e"

/obj/item/ammo_magazine/rifle/halo/ma5c/shredder
	name = "\improper Armor Piercing MA5C magazine (7.62x51mm Shredder)"
	desc = "A rectangular box magazine for the MA5C holding 48 rounds of 7.62x51 shredder ammunitions, a specialized ammunition that pierces armor and splinters in the target."
	max_rounds = 48
	gun_type = /obj/item/weapon/gun/rifle/halo/ma5c
	default_ammo = /datum/ammo/bullet/rifle/ma5c/shredder
	caliber = "7.62x51"
	ammo_band_color = "#994545"

/obj/item/ammo_magazine/rifle/halo/ma5b
	name = "\improper MA5B magazine (7.62x51mm FMJ)"
	desc = "A rectangular box magazine for the MA5C holding 60 rounds of 7.62x51 FMJ ammunitions."
	icon_state = "ma5b"
	max_rounds = 60
	gun_type = /obj/item/weapon/gun/rifle/halo/ma5b
	default_ammo = /datum/ammo/bullet/rifle/ma5c
	caliber = "7.62x51"
	ammo_band_icon = "+ma5b_band"
	ammo_band_icon_empty = "+ma5b_band_e"

/obj/item/ammo_magazine/rifle/halo/ma5b/shredder
	name = "\improper MA5B magazine (7.62x51mm Shredder)"
	desc = "A rectangular box magazine for the MA5B holding 60 rounds of 7.62x51 shredder ammunitions, a specialized ammunition that pierces armor and splinters in the target."
	max_rounds = 60
	gun_type = /obj/item/weapon/gun/rifle/halo/ma5b
	default_ammo = /datum/ammo/bullet/rifle/ma5c/shredder
	caliber = "7.62x51"
	ammo_band_color = "#994545"

/obj/item/ammo_magazine/rifle/halo/ma3a
	name = "\improper MA3A magazine (7.62x51mm FMJ)"
	desc = "A rectangular box magazine for the MA3A holding 32 rounds of 7.62x51 FMJ ammunitions."
	icon_state = "ma3a"
	max_rounds = 32
	gun_type = /obj/item/weapon/gun/rifle/halo/ma3a
	default_ammo = /datum/ammo/bullet/rifle/ma3a
	caliber = "7.62x51"

/obj/item/ammo_magazine/rifle/halo/vk78
	name = "\improper VK78 magazine (6.5x48mm FMJ)"
	desc = "An angular box magazine for the VK78 holding 20 rounds of 6.5x48mm FMJ ammunitions."
	icon_state = "vk78"
	max_rounds = 20
	gun_type = /obj/item/weapon/gun/rifle/halo/vk78
	default_ammo = /datum/ammo/bullet/rifle/vk78
	caliber = "6.5x48"

/obj/item/ammo_magazine/rifle/halo/br55
	name = "\improper BR55 magazine (9.5x40mm X-HP SAP-HE)"
	desc = "A rectangular box magazine for the BR55 holding 36 rounds of 9.5x40mm X-HP SAP-HE ammunitions."
	icon_state = "br55"
	max_rounds = 36
	gun_type = /obj/item/weapon/gun/rifle/halo/br55
	default_ammo = /datum/ammo/bullet/rifle/br55
	caliber = "9.5x40mm"
	bonus_overlay = "br55_overlay"
	bonus_overlay_icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_magazines.dmi'

/obj/item/ammo_magazine/rifle/halo/br55/extended
	name = "\improper quad-stack BR55 magazine (9.5x40mm X-HP SAP-HE)"
	desc = "A quad-stack rectangular box magazine for the BR55 holding 60 rounds of 9.5x40mm X-HP SAP-HE ammunitions."
	icon_state = "br55_quadstack"
	max_rounds = 60
	bonus_overlay = "br55_ext_overlay"

/obj/item/ammo_magazine/rifle/halo/dmr
	name = "\improper M392 DMR magazine (7.62x51mm FMJ)"
	desc = "A rectangular 15 round box magazine for the M392 DMR filled with 7.62x51mm FMJ ammo."
	icon_state = "dmr"
	max_rounds = 15
	gun_type = /obj/item/weapon/gun/rifle/halo/dmr
	default_ammo = /datum/ammo/bullet/rifle/dmr
	caliber = "7.62x51"

// smg magazines
/obj/item/ammo_magazine/smg/halo
	name = "halo smg magazine"
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_magazines.dmi'
	icon_state = null
	ammo_band_icon = null
	ammo_band_icon_empty = null

/obj/item/ammo_magazine/smg/halo/m7
	name = "\improper M7 magazine (5×23mm M443 Caseless FMJ)"
	desc = "A rectangular magazine to be inserted into the side of the M7 submachine gun. It holds 60 rounds of 5×23mm M443 Caseless FMJ."
	icon_state = "m7"
	max_rounds = 60
	gun_type = /obj/item/weapon/gun/smg/halo/
	default_ammo = /datum/ammo/bullet/smg/m7
	caliber = "5x23mm"

// sniper magazines

/obj/item/ammo_magazine/rifle/halo/sniper
	name = "\improper SRS99-AM magazine (14.5x114mm APFSDS)"
	desc = "A rectangular box magazine for the SRS99-AM holding four rounds of 14.5x114mm armor-piercing, fin-stabilized, discarding sabot."
	icon_state = "srs99"
	max_rounds = 4
	gun_type = /obj/item/weapon/gun/rifle/sniper/halo
	default_ammo = /datum/ammo/bullet/rifle/srs99
	caliber = "14.5x114mm"

// shotgun internal magazines

/obj/item/ammo_magazine/internal/shotgun/m90
	caliber = "8g"
	max_rounds = 12
	current_rounds = 12
	default_ammo = /datum/ammo/bullet/shotgun/buckshot/unsc

/obj/item/ammo_magazine/internal/shotgun/m90/unloaded
	current_rounds = 0

/obj/item/ammo_magazine/internal/shotgun/m90/police
	default_ammo = /datum/ammo/bullet/shotgun/beanbag/unsc

// shotgun shells

/obj/item/ammo_magazine/shotgun/buckshot/unsc
	name = "UNSC 8-gauge shotgun shell box"
	desc = "A box filled with 8-gauge MAG 15P-00B buckshot shells."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_magazines.dmi'
	icon_state = "8g"
	item_state = "8g"
	default_ammo = /datum/ammo/bullet/shotgun/buckshot/unsc
	transfer_handful_amount = 5
	max_rounds = 24
	caliber = "8g"

/obj/item/ammo_magazine/shotgun/beanbag/unsc
	name = "UNSC 8-gauge shotgun beanbag box"
	desc = "A box filled with 8-gauge MAG LLHB beanbag shells."
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_magazines.dmi'
	icon_state = "8g_beanbag"
	default_ammo = /datum/ammo/bullet/shotgun/beanbag/unsc
	transfer_handful_amount = 5
	max_rounds = 24
	caliber = "8g"

// rockets

/obj/item/ammo_magazine/spnkr
	name = "\improper M19 SSM tube assembly"
	desc = "A 102mm dual-tubed rocket assembly intended to be loaded into an M41 spnkr."
	caliber = "102mm"
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/special.dmi'
	icon_state = "spnkr_rockets"
	bonus_overlay_icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/special.dmi'
	bonus_overlay = "spnkr_rockets"
	max_rounds = 2
	default_ammo = /datum/ammo/rocket/spnkr
	gun_type = /obj/item/weapon/gun/halo_launcher/spnkr
	reload_delay = 30
	w_class = SIZE_LARGE

/obj/item/ammo_magazine/spnkr/update_icon()
	..()
	if(current_rounds <= 0)
		name = "\improper spent M19 SSM tube assembly"
		desc = "A spent 102mm dual-tubed rocket assembly previously loaded into a spnkr. Of no use to you now..."
		icon_state = "spnkr_rockets_e"

// pistol magazines

/obj/item/ammo_magazine/pistol/halo
	name = "halo magazine"
	icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_magazines.dmi'
	icon_state = null
	ammo_band_icon = null
	ammo_band_icon_empty = null
	caliber = "12.7x40mm"

/obj/item/ammo_magazine/pistol/halo/m6c
	name = "\improper M6C magazine (12.7x40mm SAP-HE)"
	desc = "A rectangular and slanted magazine for the M6C, holding 12 rounds of 12.7x40mm SAP-HE ammunition."
	icon_state = "m6c"
	gun_type = /obj/item/weapon/gun/pistol/halo/m6c
	default_ammo = /datum/ammo/bullet/pistol/magnum
	max_rounds = 12
	bonus_overlay_icon = 'icons/halo/obj/items/weapons/guns_by_faction/unsc/unsc_magazines.dmi'
	bonus_overlay = "m6c_overlay"

/obj/item/ammo_magazine/pistol/halo/m6c/socom
	name = "\improper M6C/SOCOM magazine (12.7x40mm SAP-HE)"
	desc = "An extended capacity M6C magazine, capable of holding 16 rounds compared to the standard 12. Comes in special-ops black, for the true clandestine operative."
	max_rounds = 16
	icon_state = "m6c_socom"
	bonus_overlay = "m6c_ext_overlay"

/obj/item/ammo_magazine/pistol/halo/m6a
	name = "\improper M6A magazine (12.7x40mm SAP-HE)"
	desc = "A rectangular and slanted magazine for the M6A, holding 12 rounds of 12.7x40mm SAP-HE ammunition."
	icon_state = "m6c"
	gun_type = /obj/item/weapon/gun/pistol/halo/m6a
	default_ammo = /datum/ammo/bullet/pistol/magnum
	max_rounds = 12

/obj/item/ammo_magazine/pistol/halo/m6g
	name = "\improper M6G magazine (12.7x40mm SAP-HE)"
	desc = "A rectangular slanted magazine for the M6G, holding 8 rounds of 12.7x40mm SAP-HE ammunition"
	icon_state = "m6g"
	gun_type = /obj/item/weapon/gun/pistol/halo/m6g
	default_ammo = /datum/ammo/bullet/pistol/magnum
	max_rounds = 8

/obj/item/ammo_magazine/pistol/halo/m6d
	name = "\improper M6D magazine (12.7x40mm SAP-HE)"
	desc = "A rectangular slanted magazine for the M6D, holding 12 rounds of 12.7x40mm SAP-HE ammunition. Chrome finish."
	icon_state = "m6d"
	gun_type = /obj/item/weapon/gun/pistol/halo/m6d
	default_ammo = /datum/ammo/bullet/pistol/magnum
	max_rounds = 12

//ammo
// rifle ammo

/datum/ammo/bullet/rifle/ma5c
	name = "FMJ bullet"

/datum/ammo/bullet/rifle/ma5c/shredder
	name = "shredder bullet"
	damage = 30
	penetration = ARMOR_PENETRATION_TIER_8

/datum/ammo/bullet/rifle/ma3a
	name = "FMJ bullet"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM
	damage = 35
	penetration = ARMOR_PENETRATION_TIER_2

/datum/ammo/bullet/rifle/vk78
	name = "FMJ bullet"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM
	damage = 35
	penetration = ARMOR_PENETRATION_TIER_1
	accurate_range = 14
	scatter = SCATTER_AMOUNT_TIER_7
	shell_speed = AMMO_SPEED_TIER_5
	damage_falloff = DAMAGE_FALLOFF_TIER_5
	max_range = 22

/datum/ammo/bullet/rifle/br55
	name = "X-HP SAP-HE bullet"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM
	penetration = ARMOR_PENETRATION_TIER_3
	accurate_range = 16
	scatter = SCATTER_AMOUNT_TIER_10
	shell_speed = 1.5*AMMO_SPEED_TIER_6
	effective_range_max = 16

/datum/ammo/bullet/rifle/dmr
	name = "FMJ bullet"
	headshot_state = HEADSHOT_OVERLAY_HEAVY
	damage = 55
	penetration = ARMOR_PENETRATION_TIER_4
	accurate_range = 24
	scatter = SCATTER_AMOUNT_TIER_10
	shell_speed = AMMO_SPEED_TIER_6
	effective_range_max = 12
	damage_falloff = DAMAGE_FALLOFF_TIER_7
	max_range = 36

// smg ammo
/datum/ammo/bullet/smg/m7
	name = "5×23mm M443 FMJ"
	penetration = 0
	damage = 20
	penetration = ARMOR_PENETRATION_TIER_1
	scatter = SCATTER_AMOUNT_TIER_8
	accuracy = HIT_ACCURACY_TIER_4

// shotgun ammo

/datum/ammo/bullet/shotgun/buckshot/unsc
	name = "MAG 15P-00B"
	handful_state = "buckshot_shell"
	bonus_projectiles_type = /datum/ammo/bullet/shotgun/spread/unsc

/datum/ammo/bullet/shotgun/spread/unsc
	name = "additional buckshot, USCM special type"

/datum/ammo/bullet/shotgun/beanbag/unsc
	name = "MAG LLHB"
	handful_state = "8g_beanbag"
	accurate_range = 10
	max_range = 10
	stamina_damage = 75
	damage = 35

// rocket ammo

/datum/ammo/rocket/spnkr
	name = "M19 missile"
	icon = 'icons/halo/obj/items/weapons/halo_projectiles.dmi'
	icon_state = "spnkr_missile"
	damage = 200
	shell_speed = AMMO_SPEED_TIER_6
	accuracy = HIT_ACCURACY_TIER_4
	accurate_range = 14
	max_range = 14


// sniper ammo

/datum/ammo/bullet/rifle/srs99
	name = "APFSDS bullet"
	headshot_state = HEADSHOT_OVERLAY_HEAVY
	damage = 200
	penetration = ARMOR_PENETRATION_TIER_8
	accurate_range = 24
	accuracy = HIT_ACCURACY_TIER_10
	scatter = SCATTER_AMOUNT_TIER_10
	effective_range_max = 24
	damage_falloff = DAMAGE_FALLOFF_TIER_7
	max_range = 48
	shell_speed = AMMO_SPEED_TIER_6 + AMMO_SPEED_TIER_2
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_SNIPER|AMMO_IGNORE_COVER

/datum/ammo/bullet/rifle/srs99/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_penetrating),
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

// pistol ammo

/datum/ammo/bullet/pistol/magnum
	name = "SAP-HE bullet"
	headshot_state = HEADSHOT_OVERLAY_HEAVY
	accuracy = HIT_ACCURACY_TIER_4
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	damage = 40
	penetration= ARMOR_PENETRATION_TIER_2
	shrapnel_chance = SHRAPNEL_CHANCE_TIER_2

/datum/ammo/energy/plasma
	name = "plasma bolt"
	icon = 'icons/halo/obj/items/weapons/halo_projectiles.dmi'
	shell_speed = AMMO_SPEED_TIER_3
	flags_ammo_behavior = AMMO_BALLISTIC
	sound_hit = "plasma_impact"
	sound_miss = "plasma_miss"

/datum/ammo/energy/plasma/plasma_pistol
	name = "light plasma bolt"
	icon_state = "plasma_teal"
	accurate_range = 10
	max_range = 20
	damage = 28
	accuracy = HIT_ACCURACY_TIER_3
	scatter = SCATTER_AMOUNT_TIER_10

/datum/ammo/energy/plasma/plasma_pistol/overcharge
	name = "overcharged light plasma bolt"
	damage = 80
	shell_speed = AMMO_SPEED_TIER_4

/datum/ammo/energy/plasma/plasma_rifle
	name = "plasma bolt"
	icon_state = "plasma_blue"
	shell_speed = AMMO_SPEED_TIER_4
	accurate_range = 14
	max_range = 24
	damage = 38

/datum/ammo/bullet/rifle/carbine
	name = "carbine bullet"
	icon = 'icons/halo/obj/items/weapons/halo_projectiles.dmi'
	icon_state = "carbine"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM
	damage = 50
	penetration = ARMOR_PENETRATION_TIER_3
	accurate_range = 24
	scatter = SCATTER_AMOUNT_TIER_10
	shell_speed = 1.5*AMMO_SPEED_TIER_6
	effective_range_max = 24
	damage_falloff = DAMAGE_FALLOFF_TIER_7
	max_range = 32
	shrapnel_chance = null
