


//-------------------------------------------------------
//M41A (MK2) PULSE RIFLE AMMUNITION

/obj/item/ammo_magazine/rifle
	name = "\improper M41A magazine (10x24mm)"
	desc = "A 10mm assault rifle magazine."
	caliber = "10x24mm"
	icon_state = "m41a"
	item_state = "generic_mag"
	w_class = SIZE_MEDIUM
	default_ammo = /datum/ammo/bullet/rifle
	max_rounds = 40
	gun_type = /obj/item/weapon/gun/rifle/m41a

/obj/item/ammo_magazine/rifle/extended
	name = "\improper M41A extended magazine (10x24mm)"
	desc = "A 10mm assault extended rifle magazine."
	icon_state = "m41a_extended"
	max_rounds = 60
	bonus_overlay = "m41a_ex"

/obj/item/ammo_magazine/rifle/incendiary
	name = "\improper M41A incendiary magazine (10x24mm)"
	desc = "A 10mm assault rifle magazine."
	icon_state = "m41a_incendiary"
	default_ammo = /datum/ammo/bullet/rifle/incendiary

/obj/item/ammo_magazine/rifle/explosive
	name = "\improper M41A explosive magazine (10x24mm)"
	desc = "A 10mm assault rifle magazine. Oh god... just don't hit friendlies with it."
	icon_state = "m41a_explosive"
	default_ammo = /datum/ammo/bullet/rifle/explosive

/obj/item/ammo_magazine/rifle/ap
	name = "\improper M41A AP magazine (10x24mm)"
	desc = "A 10mm armor piercing magazine."
	icon_state = "m41a_AP"
	default_ammo = /datum/ammo/bullet/rifle/ap

/obj/item/ammo_magazine/rifle/le
	name = "\improper M41A LE magazine (10x24mm)"
	desc = "A 10mm armor shredding magazine."
	icon_state = "m41a_LE"
	default_ammo = /datum/ammo/bullet/rifle/le

/obj/item/ammo_magazine/rifle/penetrating
	name = "\improper M41A wall-piercing magazine (10x24mm)"
	desc = "A 10mm wall-piercing magazine."
	icon_state = "m41a_penetrating"
	default_ammo = /datum/ammo/bullet/rifle/ap/penetrating

/obj/item/ammo_magazine/rifle/cluster
	name = "\improper M41A cluster magazine (10x24mm)"
	desc = "A 10mm cluster magazine. Designed to attach tiny explosives to targets, to detonate all at once if enough hit."
	icon_state = "m41a_cluster"
	default_ammo = /datum/ammo/bullet/rifle/ap/cluster

/obj/item/ammo_magazine/rifle/toxin
	name = "\improper M41A toxin magazine (10x24mm)"
	desc = "A 10mm toxin magazine."
	icon_state = "m41a_toxin"
	default_ammo = /datum/ammo/bullet/rifle/ap/toxin

/obj/item/ammo_magazine/rifle/rubber
	name = "M41A Rubber Magazine (10x24mm)"
	desc = "A 10mm magazine filled with rubber bullets."
	icon_state = "m41a_LE"
	default_ammo = /datum/ammo/bullet/rifle/rubber

//-------------------------------------------------------
//M41A (MK1) TRUE AND ORIGINAL

/obj/item/ammo_magazine/rifle/m41aMK1
	name = "\improper M41A MK1 magazine (10x24mm)"
	desc = "A long rectangular box of rounds that is only compatible with the older M41A MK1. Holds up to 95 rounds."
	icon_state = "m41a_mk1"
	max_rounds = 95
	gun_type = /obj/item/weapon/gun/rifle/m41aMK1
	default_ammo = /datum/ammo/bullet/rifle

/obj/item/ammo_magazine/rifle/m41aMK1/ap
	name = "\improper M41A MK1 AP magazine (10x24mm)"
	desc = "A long rectangular box of rounds that is only compatible with the older M41A MK1. Holds up to 95 rounds. This one contains AP bullets."
	icon_state = "m41a_mk1_ap"
	default_ammo = /datum/ammo/bullet/rifle/ap

/obj/item/ammo_magazine/rifle/m41aMK1/incendiary
	name = "\improper M41A MK1 incendiary magazine (10x24mm)"
	desc = "A long rectangular box of rounds that is only compatible with the older M41A MK1. Holds up to 95 rounds. This one contains incendiary bullets."
	icon_state = "m41a_mk1_incendiary"
	default_ammo = /datum/ammo/bullet/rifle/incendiary

/obj/item/ammo_magazine/rifle/m41aMK1/toxin
	name = "\improper M41A MK1 toxin magazine (10x24mm)"
	desc = "A long rectangular box of rounds that is only compatible with the older M41A MK1. Holds up to 95 rounds. This one contains toxic bullets."
	icon_state = "m41a_mk1_toxin"
	default_ammo = /datum/ammo/bullet/rifle/ap/toxin

/obj/item/ammo_magazine/rifle/m41aMK1/penetrating
	name = "\improper M41A MK1 wall-piercing magazine (10x24mm)"
	desc = "A long rectangular box of rounds that is only compatible with the older M41A MK1. Holds up to 95 rounds. This one contains wall-piercing bullets."
	icon_state = "m41a_mk1_penetrating"
	default_ammo = /datum/ammo/bullet/rifle/ap/penetrating

/obj/item/ammo_magazine/rifle/m41aMK1/cluster
	name = "\improper M41A MK1 cluster magazine (10x24mm)"
	desc = "A long rectangular box of rounds that is only compatible with the older M41A MK1. Holds up to 95 rounds. This one contains cluster bullets."
	icon_state = "m41a_mk1_cluster"
	default_ammo = /datum/ammo/bullet/rifle/ap/cluster


//-------------------------------------------------------
//M40-SD AKA MARSOC RIFLE FROM HELL (It's an EM-2, a prototype of the real world L85A1 way back from the 1940s. We've given it a blue plastic shell and an integral suppressor)
/obj/item/ammo_magazine/rifle/m40_sd
	name = "\improper M40-SD magazine (10x24mm)"
	desc = "A stubby and wide, high-capacity double stack magazine used in the M40-SD pulse rifle. Fires 10x24mm Armor Piercing rounds, holding up to 60 + 1 in the chamber."
	icon_state = "m40_sd"
	max_rounds = 60
	gun_type = /obj/item/weapon/gun/rifle/m41a/elite/m40_sd
	default_ammo = /datum/ammo/bullet/rifle/ap

//-------------------------------------------------------
//MAR-40 AK CLONE //AK47 and FN FAL together as one.

/obj/item/ammo_magazine/rifle/mar40
	name = "\improper MAR magazine (7.62x39mm)"
	desc = "A 7.62x39mm magazine for the MAR series of firearms."
	caliber = "7.62x39mm"
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
	icon_state = "m16"
	default_ammo = /datum/ammo/bullet/rifle
	max_rounds = 20
	gun_type = /obj/item/weapon/gun/rifle/m16
	w_class = SIZE_MEDIUM

/obj/item/ammo_magazine/rifle/m16/ap
	name = "\improper M16 AP magazine (5.56x45mm)"
	desc = "An AP 5.56x45mm magazine for the M16 assault rifle."
	caliber = "5.56x45mm"
	icon_state = "m16_ap"
	default_ammo = /datum/ammo/bullet/rifle/ap
	max_rounds = 20
	gun_type = /obj/item/weapon/gun/rifle/m16
	w_class = SIZE_MEDIUM

//-------------------------------------------------------
//AR10 RIFLE

/obj/item/ammo_magazine/rifle/ar10
	name = "\improper AR10 magazine (7.62x51mm)"
	desc = "A 7.62x51mm magazine for the AR10 assault rifle."
	caliber = "7.62x51mm"
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

/obj/item/ammo_magazine/rifle/lmg/holo_target
	name = "\improper M41AE2 ammo box (10x24mm holo-target)"
	desc = "A semi-rectangular box of holo-target rounds for the M41AE2 Heavy Pulse Rifle."
	icon_state = "m41ae2_track"
	default_ammo = /datum/ammo/bullet/rifle/holo_target
	max_rounds = 200

//-------------------------------------------------------
//UPP TYPE 71 RIFLE

/obj/item/ammo_magazine/rifle/type71
	name = "\improper Type 71 magazine (5.45x39mm)"
	desc = "A 5.45x39mm high-capacity casket magazine for the Type 71 rifle."
	caliber = "5.45x39mm"
	icon_state = "type_71"
	default_ammo = /datum/ammo/bullet/rifle/type71
	max_rounds = 60
	gun_type = /obj/item/weapon/gun/rifle/type71

/obj/item/ammo_magazine/rifle/type71/ap
	name = "\improper Type 71 AP magazine (5.45x39mm)"
	desc = "A 5.45x39mm high-capacity casket magazine containing armor piercing rounds for the Type 71 rifle."
	icon_state = "type_71_ap"
	default_ammo = /datum/ammo/bullet/rifle/type71/ap
	bonus_overlay = "type71_ap"

//-------------------------------------------------------
//USCM L42A Battle Rifle

/obj/item/ammo_magazine/rifle/l42a
	name = "\improper L42A magazine (10x24mm)"
	desc = "A 10mm battle rifle magazine."
	caliber = "10x24mm"
	icon_state = "l42mk1"
	default_ammo = /datum/ammo/bullet/rifle
	max_rounds = 25
	gun_type = /obj/item/weapon/gun/rifle/l42a
	w_class = SIZE_MEDIUM

/obj/item/ammo_magazine/rifle/l42a/ap
	name = "\improper L42A AP magazine (10x24mm)"
	desc = "A 10mm battle rifle armor piercing magazine."
	icon_state = "l42mk1_ap"
	default_ammo = /datum/ammo/bullet/rifle/ap

/obj/item/ammo_magazine/rifle/l42a/le
	name = "\improper L42A LE magazine (10x24mm)"
	desc = "A 10mm battle rifle armor shredding magazine."
	icon_state = "l42mk1_le"
	default_ammo = /datum/ammo/bullet/rifle/le

/obj/item/ammo_magazine/rifle/l42a/rubber
	name = "L42A rubber magazine (10x24mm)"
	icon_state = "l42mk1_le"
	default_ammo = /datum/ammo/bullet/rifle/rubber

/obj/item/ammo_magazine/rifle/l42a/penetrating
	name = "\improper L42A wall-piercing magazine (10x24mm)"
	desc = "A 10mm battle rifle wall-piercing magazine."
	icon_state = "l42mk1_penetrating"
	default_ammo = /datum/ammo/bullet/rifle/ap/penetrating

/obj/item/ammo_magazine/rifle/l42a/cluster
	name = "\improper L42A cluster magazine (10x24mm)"
	desc = "A 10mm battle rifle cluster magazine."
	icon_state = "l42mk1_cluster"
	default_ammo = /datum/ammo/bullet/rifle/ap/cluster

/obj/item/ammo_magazine/rifle/l42a/toxin
	name = "\improper L42A toxin magazine (10x24mm)"
	desc = "A 10mm battle rifle toxin magazine."
	icon_state = "l42mk1_toxin"
	default_ammo = /datum/ammo/bullet/rifle/ap/toxin

/obj/item/ammo_magazine/rifle/l42a/extended
	name = "\improper L42A extended magazine (10x24mm)"
	desc = "A 10mm battle rifle extended magazine."
	caliber = "10x24mm"
	icon_state = "l42mk1_extended"
	default_ammo = /datum/ammo/bullet/rifle
	max_rounds = 35
	gun_type = /obj/item/weapon/gun/rifle/l42a
	w_class = SIZE_MEDIUM

/obj/item/ammo_magazine/rifle/l42a/incendiary
	name = "\improper L42A incendiary magazine (10x24mm)"
	desc = "A 10mm battle rifle incendiary magazine."
	caliber = "10x24mm"
	icon_state = "l42mk1_incendiary"
	default_ammo = /datum/ammo/bullet/rifle/incendiary
	max_rounds = 20
	gun_type = /obj/item/weapon/gun/rifle/l42a
	w_class = SIZE_MEDIUM

//-------------------------------------------------------
////NSG 23 ASSAULT RIFLE - PMC PRIMARY RIFLE

/obj/item/ammo_magazine/rifle/nsg23
	name = "\improper NSG 23 magazine (10x24mm)"
	desc = "An NSG 23 assault rifle magazine."
	caliber = "10x24mm"
	icon_state = "nsg23"
	item_state = "nsg23"
	bonus_overlay = "nsg23_mag_overlay" //needs to be an overlay, as the mag has a hole that would be filled over by the ext overlay
	max_rounds = 30
	gun_type = /obj/item/weapon/gun/rifle/nsg23

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
	icon_state = "nsg23_ap"
	item_state = "nsg23_ap"
	default_ammo = /datum/ammo/bullet/rifle/ap

//-------------------------------------------------------
//Basira-Armstrong rifle

/obj/item/ammo_magazine/rifle/hunting
	name = "\improper Basira-Armstrong magazine (6.5mm)"
	desc = "A magazine for the Basira-Armstrong rifle. Compliant with the 10-cartridge limit on civilian semi-automatic rifles."
	caliber = "6.5mm"
	icon_state = "hunting"
	default_ammo = /datum/ammo/bullet/rifle
	max_rounds = 10
	gun_type = /obj/item/weapon/gun/rifle/hunting
	w_class = SIZE_SMALL

//--------------------------------------------------------
//Bolt action rifle ammo
/obj/item/ammo_magazine/rifle/boltaction
	name = "\improper Bolt Action magazine (7.62mm)"
	desc = "Bolt action magazine, simple really."
	caliber = "7.62mm"
	icon_state = "hunting"
	default_ammo = /datum/ammo/bullet/rifle
	max_rounds = 10
	gun_type = /obj/item/weapon/gun/boltaction
	w_class = SIZE_SMALL

/obj/item/ammo_magazine/rifle/boltaction/colony
	name = "\improper Model 12 Bolt Action magazine (8mm W-Y)"
	desc = "A magazine for the Model 12 Bolt Action Rifle, holds ten rounds."
	caliber = "8mm W-Y"
	gun_type = /obj/item/weapon/gun/boltaction/colony
	w_class = SIZE_MEDIUM
