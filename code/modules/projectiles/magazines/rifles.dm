


//-------------------------------------------------------
//M41A (MK2) PULSE RIFLE AMMUNITION

/obj/item/ammo_magazine/rifle
	name = "\improper M41A magazine (10x24mm)"
	desc = "A 10mm assault rifle magazine."
	caliber = "10x24mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "m41a"
	item_state = "generic_mag"
	w_class = SIZE_MEDIUM
	default_ammo = /datum/ammo/bullet/rifle
	max_rounds = 40
	gun_type = /obj/item/weapon/gun/rifle/m41a
	ammo_band_icon = "+m41a_band"
	ammo_band_icon_empty = "+m41a_band_e"

/obj/item/ammo_magazine/rifle/extended
	name = "\improper M41A extended magazine (10x24mm)"
	desc = "A 10mm assault extended rifle magazine."
	icon_state = "m41a_extended"
	max_rounds = 60
	bonus_overlay = "m41a_ex"

/obj/item/ammo_magazine/rifle/incendiary
	name = "\improper M41A incendiary magazine (10x24mm)"
	desc = "A 10mm assault rifle magazine."
	default_ammo = /datum/ammo/bullet/rifle/incendiary
	ammo_band_color = AMMO_BAND_COLOR_INCENDIARY

/obj/item/ammo_magazine/rifle/explosive
	name = "\improper M41A explosive magazine (10x24mm)"
	desc = "A 10mm assault rifle magazine. Oh god... just don't hit friendlies with it."
	default_ammo = /datum/ammo/bullet/rifle/explosive
	ammo_band_color = AMMO_BAND_COLOR_EXPLOSIVE

/obj/item/ammo_magazine/rifle/heap
	name = "\improper M41A HEAP magazine (10x24mm)"
	desc = "A 10mm armor piercing high explosive magazine."
	default_ammo = /datum/ammo/bullet/rifle/heap
	ammo_band_color = AMMO_BAND_COLOR_HEAP

/obj/item/ammo_magazine/rifle/ap
	name = "\improper M41A AP magazine (10x24mm)"
	desc = "A 10mm armor piercing magazine."
	default_ammo = /datum/ammo/bullet/rifle/ap
	ammo_band_color = AMMO_BAND_COLOR_AP

/obj/item/ammo_magazine/rifle/le
	name = "\improper M41A LE magazine (10x24mm)"
	desc = "A 10mm armor shredding magazine."
	default_ammo = /datum/ammo/bullet/rifle/le
	ammo_band_color = AMMO_BAND_COLOR_LIGHT_EXPLOSIVE

/obj/item/ammo_magazine/rifle/penetrating
	name = "\improper M41A wall-penetrating magazine (10x24mm)"
	desc = "A 10mm wall-penetrating magazine."
	default_ammo = /datum/ammo/bullet/rifle/ap/penetrating
	ammo_band_color = AMMO_BAND_COLOR_PENETRATING

/obj/item/ammo_magazine/rifle/toxin
	name = "\improper M41A toxin magazine (10x24mm)"
	desc = "A 10mm toxin magazine."
	default_ammo = /datum/ammo/bullet/rifle/ap/toxin
	ammo_band_color = AMMO_BAND_COLOR_TOXIN


/obj/item/ammo_magazine/rifle/rubber
	name = "M41A Rubber Magazine (10x24mm)"
	desc = "A 10mm magazine filled with rubber bullets."
	default_ammo = /datum/ammo/bullet/rifle/rubber
	ammo_band_color = AMMO_BAND_COLOR_RUBBER

//-------------------------------------------------------
//M41A (MK1) TRUE AND ORIGINAL

/obj/item/ammo_magazine/rifle/m41aMK1
	name = "\improper M41A MK1 magazine (10x24mm)"
	desc = "A long rectangular box of rounds that is only compatible with the older M41A MK1. Holds up to 95 rounds."
	icon_state = "m41a_mk1"
	max_rounds = 95
	gun_type = /obj/item/weapon/gun/rifle/m41aMK1
	default_ammo = /datum/ammo/bullet/rifle
	ammo_band_icon = "+m41a_mk1_band"
	ammo_band_icon_empty = "+m41a_mk1_band_e"

/obj/item/ammo_magazine/rifle/m41aMK1/ap
	name = "\improper M41A MK1 AP magazine (10x24mm)"
	desc = "A long rectangular box of rounds that is only compatible with the older M41A MK1. Holds up to 95 rounds. This one contains AP bullets."
	default_ammo = /datum/ammo/bullet/rifle/ap
	ammo_band_color = AMMO_BAND_COLOR_AP

/obj/item/ammo_magazine/rifle/m41aMK1/heap
	name = "\improper M41A MK1 HEAP magazine (10x24mm)"
	desc = "A long rectangular box of rounds that is only compatible with the older M41A MK1. Holds up to 95 rounds. This one contains High-Explosive Armor-Piercing bullets."
	default_ammo = /datum/ammo/bullet/rifle/heap
	ammo_band_color = AMMO_BAND_COLOR_HEAP

/obj/item/ammo_magazine/rifle/m41aMK1/incendiary
	name = "\improper M41A MK1 incendiary magazine (10x24mm)"
	desc = "A long rectangular box of rounds that is only compatible with the older M41A MK1. Holds up to 95 rounds. This one contains incendiary bullets."
	default_ammo = /datum/ammo/bullet/rifle/incendiary
	ammo_band_color = AMMO_BAND_COLOR_INCENDIARY

/obj/item/ammo_magazine/rifle/m41aMK1/toxin
	name = "\improper M41A MK1 toxin magazine (10x24mm)"
	desc = "A long rectangular box of rounds that is only compatible with the older M41A MK1. Holds up to 95 rounds. This one contains toxic bullets."
	default_ammo = /datum/ammo/bullet/rifle/ap/toxin
	ammo_band_color = AMMO_BAND_COLOR_TOXIN

/obj/item/ammo_magazine/rifle/m41aMK1/penetrating
	name = "\improper M41A MK1 wall-penetrating magazine (10x24mm)"
	desc = "A long rectangular box of rounds that is only compatible with the older M41A MK1. Holds up to 95 rounds. This one contains wall-penetrating bullets."
	default_ammo = /datum/ammo/bullet/rifle/ap/penetrating
	ammo_band_color = AMMO_BAND_COLOR_PENETRATING
//-------------------------------------------------------
//M4RA, l42 reskin, same stats as before but different, lore friendly, shell.

/obj/item/ammo_magazine/rifle/m4ra
	name = "\improper M4RA magazine (10x24mm)"
	desc = "A magazine of standard 10x24mm rounds for use in the M4RA battle rifle."
	icon_state = "m4ra"
	default_ammo = /datum/ammo/bullet/rifle
	max_rounds = 25
	gun_type = /obj/item/weapon/gun/rifle/m4ra
	ammo_band_icon = "+m4ra_band"
	ammo_band_icon_empty = "+m4ra_band_e"

/obj/item/ammo_magazine/rifle/m4ra/ap
	name = "\improper M4RA armor-piercing magazine (10x24mm)"
	desc = "A magazine of armor-piercing 10x24mm rounds for use in the M4RA battle rifle."
	default_ammo = /datum/ammo/bullet/rifle/ap
	max_rounds = 25
	ammo_band_color = AMMO_BAND_COLOR_AP

/obj/item/ammo_magazine/rifle/m4ra/ext
	name = "\improper M4RA extended magazine (10x24mm)"
	desc = "A magazine of armor-piercing 10x24mm rounds for use in the M4RA battle rifle. Holds an additional 10 rounds, up to 35."
	icon_state = "m4ra_extended"
	bonus_overlay = "m4ra_ex"
	max_rounds = 35

/obj/item/ammo_magazine/rifle/m4ra/rubber
	name = "M4RA rubber magazine (10x24mm)"
	desc = "A magazine of less than lethal rubber 10x24mm rounds for use in the M4RA battle rifle."
	default_ammo = /datum/ammo/bullet/rifle/rubber
	ammo_band_color = AMMO_BAND_COLOR_RUBBER

/obj/item/ammo_magazine/rifle/m4ra/heap
	name = "\improper M4RA high-explosive armor-piercing magazine (10x24mm)"
	desc = "A magazine of high explosive armor piercing 10x24mm rounds for use in the M4RA battle rifle."
	default_ammo = /datum/ammo/bullet/rifle/heap
	ammo_band_color = AMMO_BAND_COLOR_HEAP

/obj/item/ammo_magazine/rifle/m4ra/penetrating
	name = "\improper M4RA wall-penetrating magazine (10x24mm)"
	desc = "A magazine of wall-penetrating 10x24mm rounds for use in the M4RA battle rifle."
	default_ammo = /datum/ammo/bullet/rifle/ap/penetrating
	ammo_band_color = AMMO_BAND_COLOR_PENETRATING

/obj/item/ammo_magazine/rifle/m4ra/incendiary
	name = "\improper M4RA incendiary magazine (10x24mm)"
	desc = "A magazine of incendiary 10x24mm rounds for use in the M4RA battle rifle."
	default_ammo = /datum/ammo/bullet/rifle/incendiary
	ammo_band_color = AMMO_BAND_COLOR_INCENDIARY

//-------------------------------------------------------
//XM40 AKA SOF RIFLE FROM HELL (It's an EM-2, a prototype of the real world L85A1 way back from the 1940s. We've given it a blue plastic shell and an integral suppressor)
/obj/item/ammo_magazine/rifle/xm40
	name = "\improper XM40 magazine (10x24mm)"
	desc = "A stubby and wide, high-capacity double stack magazine used in the XM40 pulse rifle. Fires 10x24mm Armor Piercing rounds, holding up to 60 + 1 in the chamber."
	icon_state = "m40_sd"
	max_rounds = 60
	gun_type = /obj/item/weapon/gun/rifle/m41a/elite/xm40
	default_ammo = /datum/ammo/bullet/rifle/ap

/obj/item/ammo_magazine/rifle/xm40/heap
	name = "\improper XM40 HEAP magazine (10x24mm)"
	desc = "A stubby and wide, high-capacity double stack magazine used in the XM40 pulse rifle. Fires 10x24mm High Explosive Armor Piercing rounds, holding up to 60 + 1 in the chamber."
	icon_state = "m40_sd_heap"
	max_rounds = 60
	gun_type = /obj/item/weapon/gun/rifle/m41a/elite/xm40
	default_ammo = /datum/ammo/bullet/rifle/heap

//-------------------------------------------------------
//MAR-40 AK CLONE //AK47 and FN FAL together as one.

/obj/item/ammo_magazine/rifle/mar40
	name = "\improper MAR magazine (7.62x39mm)"
	desc = "A 7.62x39mm magazine for the MAR series of firearms."
	caliber = "7.62x39mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "mar40"
	default_ammo = /datum/ammo/bullet/rifle/mar40
	max_rounds = 40
	gun_type = /obj/item/weapon/gun/rifle/mar40
	w_class = SIZE_MEDIUM

/obj/item/ammo_magazine/rifle/mar40/extended
	name = "\improper MAR extended magazine (7.62x39mm)"
	desc = "A 7.62x39mm MAR magazine, this one carries more rounds than the average magazine."
	max_rounds = 60
	bonus_overlay = "mar40_ex"
	icon_state = "mar40_extended"

/obj/item/ammo_magazine/rifle/mar40/lmg
	name = "\improper MAR drum magazine (7.62x39mm)"
	desc = "A 7.62x39mm drum magazine for the MAR-50 LMG."
	caliber = "7.62x39mm"
	icon_state = "mar50"
	max_rounds = 100
	gun_type = /obj/item/weapon/gun/rifle/mar40/lmg

//-------------------------------------------------------
//M16 RIFLE

/obj/item/ammo_magazine/rifle/m16
	name = "\improper M16 magazine (5.56x45mm)"
	desc = "A 5.56x45mm magazine for the M16 assault rifle."
	caliber = "5.56x45mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "m16"
	default_ammo = /datum/ammo/bullet/rifle
	max_rounds = 20
	gun_type = /obj/item/weapon/gun/rifle/m16
	w_class = SIZE_MEDIUM
	ammo_band_icon = "+m16_band"
	ammo_band_icon_empty = "+m16_band_e"

/obj/item/ammo_magazine/rifle/m16/ap
	name = "\improper M16 AP magazine (5.56x45mm)"
	desc = "An AP 5.56x45mm magazine for the M16 assault rifle."
	caliber = "5.56x45mm"
	default_ammo = /datum/ammo/bullet/rifle/ap
	max_rounds = 20
	gun_type = /obj/item/weapon/gun/rifle/m16
	w_class = SIZE_MEDIUM
	ammo_band_color = AMMO_BAND_COLOR_AP

//-------------------------------------------------------
//AR10 RIFLE

/obj/item/ammo_magazine/rifle/ar10
	name = "\improper AR10 magazine (7.62x51mm)"
	desc = "A 7.62x51mm magazine for the AR10 assault rifle."
	caliber = "7.62x51mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "ar10"
	default_ammo = /datum/ammo/bullet/rifle
	max_rounds = 20
	gun_type = /obj/item/weapon/gun/rifle/ar10
	w_class = SIZE_MEDIUM

//-------------------------------------------------------
//M41AE2 HEAVY PULSE RIFLE

/obj/item/ammo_magazine/rifle/lmg
	name = "\improper M41AE2 ammo box (10x24mm)"
	desc = "A semi-rectangular box of rounds for the M41AE2 Heavy Pulse Rifle."
	icon_state = "m41ae2"
	max_rounds = 300
	gun_type = /obj/item/weapon/gun/rifle/lmg
	flags_magazine = AMMUNITION_CANNOT_REMOVE_BULLETS|AMMUNITION_REFILLABLE|AMMUNITION_SLAP_TRANSFER
	ammo_band_icon = "+m41ae2_band"
	ammo_band_icon_empty = "+m41ae2_band_e"

/obj/item/ammo_magazine/rifle/lmg/holo_target
	name = "\improper M41AE2 ammo box (10x24mm holo-target)"
	desc = "A semi-rectangular box of holo-target rounds for the M41AE2 Heavy Pulse Rifle."
	default_ammo = /datum/ammo/bullet/rifle/holo_target
	max_rounds = 200
	ammo_band_color = AMMO_BAND_COLOR_HOLOTARGETING

/obj/item/ammo_magazine/rifle/lmg/heap
	name = "\improper M41AE2 HEAP ammo box (10x24mm)"
	desc = "A semi-rectangular box of rounds for the M41AE2 Heavy Pulse Rifle. This one contains the standard Armor-Piercing explosive tipped round of the USCM."
	default_ammo = /datum/ammo/bullet/rifle/heap
	max_rounds = 300
	gun_type = /obj/item/weapon/gun/rifle/lmg
	ammo_band_color = AMMO_BAND_COLOR_HEAP

//-------------------------------------------------------
//UPP TYPE 71 RIFLE

/obj/item/ammo_magazine/rifle/type71
	name = "\improper Type 71 magazine (5.45x39mm)"
	desc = "A 5.45x39mm high-capacity casket magazine for the Type 71 rifle."
	caliber = "5.45x39mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "type71"
	ammo_band_icon = "+type71_band"
	ammo_band_icon_empty = "+type71_band_e"
	default_ammo = /datum/ammo/bullet/rifle/type71
	max_rounds = 60
	gun_type = /obj/item/weapon/gun/rifle/type71

/obj/item/ammo_magazine/rifle/type71/ap
	name = "\improper Type 71 AP magazine (5.45x39mm)"
	desc = "A 5.45x39mm high-capacity casket magazine containing armor piercing rounds for the Type 71 rifle."
	default_ammo = /datum/ammo/bullet/rifle/type71/ap
	ammo_band_color = AMMO_BAND_COLOR_AP

/obj/item/ammo_magazine/rifle/type71/heap
	name = "\improper Type 71 HEAP magazine (5.45x39mm)"
	desc = "A 5.45x39mm high-capacity casket magazine containing the standard high explosive armor piercing rounds for the Type 71 rifle."
	default_ammo = /datum/ammo/bullet/rifle/type71/heap
	ammo_band_color = AMMO_BAND_COLOR_HEAP

//-------------------------------------------------------
//L42A Battle Rifle

/obj/item/ammo_magazine/rifle/l42a
	name = "\improper L42A magazine (10x24mm)"
	desc = "A 10mm battle rifle magazine."
	caliber = "10x24mm"
	icon_state = "l42mk1"
	bonus_overlay = "l42_mag_overlay"
	default_ammo = /datum/ammo/bullet/rifle
	max_rounds = 25
	gun_type = /obj/item/weapon/gun/rifle/l42a
	w_class = SIZE_MEDIUM
	ammo_band_icon = "+l42mk1_band"
	ammo_band_icon_empty = "+l42mk1_band_e"

/obj/item/ammo_magazine/rifle/l42a/ap
	name = "\improper L42A AP magazine (10x24mm)"
	desc = "A 10mm battle rifle armor piercing magazine."
	default_ammo = /datum/ammo/bullet/rifle/ap
	ammo_band_color = AMMO_BAND_COLOR_AP

/obj/item/ammo_magazine/rifle/l42a/le
	name = "\improper L42A LE magazine (10x24mm)"
	desc = "A 10mm battle rifle armor shredding magazine."
	default_ammo = /datum/ammo/bullet/rifle/le
	ammo_band_color = AMMO_BAND_COLOR_LIGHT_EXPLOSIVE

/obj/item/ammo_magazine/rifle/l42a/rubber
	name = "L42A rubber magazine (10x24mm)"
	default_ammo = /datum/ammo/bullet/rifle/rubber
	ammo_band_color = AMMO_BAND_COLOR_RUBBER

/obj/item/ammo_magazine/rifle/l42a/heap
	name = "\improper L42A HEAP (10x24mm)"
	desc = "A 10mm battle rifle high explosive armor piercing magazine."
	default_ammo = /datum/ammo/bullet/rifle/heap
	ammo_band_color = AMMO_BAND_COLOR_HEAP

/obj/item/ammo_magazine/rifle/l42a/penetrating
	name = "\improper L42A wall-penetrating magazine (10x24mm)"
	default_ammo = /datum/ammo/bullet/rifle/ap/penetrating
	ammo_band_color = AMMO_BAND_COLOR_PENETRATING

/obj/item/ammo_magazine/rifle/l42a/toxin
	name = "\improper L42A toxin magazine (10x24mm)"
	desc = "A 10mm battle rifle toxin magazine."
	default_ammo = /datum/ammo/bullet/rifle/ap/toxin
	ammo_band_color = AMMO_BAND_COLOR_TOXIN

/obj/item/ammo_magazine/rifle/l42a/extended
	name = "\improper L42A extended magazine (10x24mm)"
	desc = "A 10mm battle rifle extended magazine."
	caliber = "10x24mm"
	icon_state = "l42mk1_extended"
	bonus_overlay = "l42_ex_overlay"
	default_ammo = /datum/ammo/bullet/rifle
	max_rounds = 35
	gun_type = /obj/item/weapon/gun/rifle/l42a
	w_class = SIZE_MEDIUM

/obj/item/ammo_magazine/rifle/l42a/incendiary
	name = "\improper L42A incendiary magazine (10x24mm)"
	desc = "A 10mm battle rifle incendiary magazine."
	caliber = "10x24mm"
	default_ammo = /datum/ammo/bullet/rifle/incendiary
	max_rounds = 20
	gun_type = /obj/item/weapon/gun/rifle/l42a
	w_class = SIZE_MEDIUM
	ammo_band_color = AMMO_BAND_COLOR_INCENDIARY

/obj/item/ammo_magazine/rifle/l42a/abr40
	name = "\improper ABR-40 magazine (10x24mm)"
	desc = "An ABR-40 magazine loaded with full metal jacket ammunition, for use at the firing range or while hunting. Theoretically cross-compatible with an L42A battle rifle."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "abr40"
	bonus_overlay = "abr40_mag_overlay"
	max_rounds = 12
	w_class = SIZE_SMALL
	ammo_band_icon = "+abr40_band"
	ammo_band_icon_empty = "+abr40_band_e"

/obj/item/ammo_magazine/rifle/l42a/abr40/holo_target
	name = "\improper ABR-40 holotargeting magazine (10x24mm)"
	desc = "An ABR-40 magazine loaded with holo-targeting ammunition, primarily utilized to highlight hunting targets for easier target capture. Theoretically cross-compatible with an L42A battle rifle."
	default_ammo = /datum/ammo/bullet/rifle/holo_target/hunting
	ammo_band_color = AMMO_BAND_COLOR_HOLOTARGETING

//-------------------------------------------------------
// NSG 23 ASSAULT RIFLE - PMC PRIMARY RIFLE

/obj/item/ammo_magazine/rifle/nsg23
	name = "\improper NSG 23 magazine (10x24mm)"
	desc = "An NSG 23 assault rifle magazine."
	caliber = "10x24mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/wy.dmi'
	icon_state = "nsg23"
	item_state = "nsg23"
	bonus_overlay = "nsg23_mag_overlay" //needs to be an overlay, as the mag has a hole that would be filled over by the ext overlay
	max_rounds = 30
	gun_type = /obj/item/weapon/gun/rifle/nsg23
	ammo_band_icon = "+nsg23_band"
	ammo_band_icon_empty = "+nsg23_band_e"

/obj/item/ammo_magazine/rifle/nsg23/extended
	name = "\improper NSG 23 extended magazine (10x24mm)"
	desc = "An NSG 23 assault rifle magazine. This one contains 45 bullets."
	icon_state = "nsg23_ext"
	item_state = "nsg23_ext"
	bonus_overlay = "nsg23_ext_overlay"
	max_rounds = 45

/obj/item/ammo_magazine/rifle/nsg23/ap
	name = "\improper NSG 23 armor-piercing magazine (10x24mm)"
	desc = "An NSG 23 assault rifle magazine. This one is armor piercing."
	default_ammo = /datum/ammo/bullet/rifle/ap
	ammo_band_color = AMMO_BAND_COLOR_AP

/obj/item/ammo_magazine/rifle/nsg23/heap
	name = "\improper NSG 23 HEAP magazine (10x24mm)"
	desc = "An NSG 23 assault rifle magazine. This one is loaded with armor-piercing explosive tipped rounds."
	default_ammo = /datum/ammo/bullet/rifle/heap
	ammo_band_color = AMMO_BAND_COLOR_HEAP

//--------------------------------------------------------
//Bolt action rifle ammo
/obj/item/ammo_magazine/rifle/boltaction
	name = "\improper Basira-Armstrong magazine (6.5mm)"
	desc = "A magazine for the Basira-Armstrong hunting rifle. Compliant with the 15-cartridge limit on civilian hunting rifles."
	caliber = "6.5mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "hunting"
	default_ammo = /datum/ammo/bullet/sniper/crude
	max_rounds = 10
	gun_type = /obj/item/weapon/gun/boltaction
	w_class = SIZE_SMALL

/obj/item/ammo_magazine/rifle/boltaction/vulture
	name = "\improper M707 \"Vulture\" magazine (20x102mm)"
	desc = "A magazine for the M707 \"Vulture\" anti-matieriel rifle. Contains up to 4 massively oversized rounds."
	caliber = "20x102mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "vulture"
	handful_state = "vulture_bullet"
	default_ammo = /datum/ammo/bullet/sniper/anti_materiel/vulture
	max_rounds = 4
	gun_type = /obj/item/weapon/gun/boltaction/vulture
	w_class = SIZE_MEDIUM // maybe small? This shit's >4 inches long mind you

//=ROYAL MARINES=\\

/obj/item/ammo_magazine/rifle/rmc_f90
	name = "\improper F903 magazine (10x24mm)"
	desc = "A 10mm assault rifle magazine used by the royal marines."
	caliber = "10x24mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/twe_ammo.dmi'
	icon_state = "aug"
	item_state = "aug"
	w_class = SIZE_MEDIUM
	default_ammo = /datum/ammo/bullet/rifle
	max_rounds = 30
	gun_type = /obj/item/weapon/gun/rifle/rmc_f90
	ammo_band_icon = "+aug_band"
	ammo_band_icon_empty = "+aug_band_e"

/obj/item/ammo_magazine/rifle/rmc_f90/marksman
	name = "\improper F903A1 Marksman magazine (10x24mm)"
	desc = "A 10mm armor-piercing assault rifle magazine used by the royal marines."
	icon_state = "aug_dmr"
	item_state = "aug_dmr"
	default_ammo = /datum/ammo/bullet/rifle/ap
	gun_type = /obj/item/weapon/gun/rifle/rmc_f90/scope
	max_rounds = 20
	ammo_band_color = AMMO_BAND_COLOR_AP
	ammo_band_icon = "+aug_dmr_band"
	ammo_band_icon_empty = "+aug_dmr_band_e"

/obj/item/ammo_magazine/rifle/rmc_f90/heap
	name = "\improper F903 HEAP magazine (10x24mm)"
	desc = "A 10mm armor piercing high explosive assault rifle magazine used by the royal marines."
	default_ammo = /datum/ammo/bullet/rifle/heap
	ammo_band_color = AMMO_BAND_COLOR_HEAP

/obj/item/ammo_magazine/rifle/rmc_f90/marksman/heap
	name = "\improper F903A1 Marksman magazine (10x24mm)"
	desc = "A 10mm armor piercing high explosive assault rifle magazine used by the royal marines."
	icon_state = "aug_dmr"
	item_state = "aug_dmr"
	default_ammo = /datum/ammo/bullet/rifle/heap
	ammo_band_color = AMMO_BAND_COLOR_HEAP
