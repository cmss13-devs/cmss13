/obj/item/ammo_magazine/smg
	name = "\improper default SMG magazine"
	desc = "A submachinegun magazine."
	item_state = "generic_mag"
	default_ammo = /datum/ammo/bullet/smg
	max_rounds = 30

//-------------------------------------------------------
//M39 SMG ammo

/obj/item/ammo_magazine/smg/m39
	name = "\improper M39 HV magazine (10x20mm)"
	desc = "A 10x20mm caseless high-velocity submachinegun magazine. Powerful propellant allows the bullet increased velocity and minor penetration capabilities, noticeably improving its efficacy at medium ranges, although it still suffers significantly compared to a rifle bullet."
	caliber = "10x20mm"
	icon_state = "m39_HV"
	max_rounds = 48
	w_class = SIZE_MEDIUM
	gun_type = /obj/item/weapon/gun/smg/m39
	default_ammo = /datum/ammo/bullet/smg/m39

/obj/item/ammo_magazine/smg/m39/ap
	name = "\improper M39 AP magazine (10x20mm)"
	desc = "A 10x20mm caseless armor-piercing submachinegun magazine. The bullet tips are made out of high-density material, allowing them to pierce straight through armor, but also reducing the raw stopping power and velocity of the ammunition."
	icon_state = "m39_AP"
	default_ammo = /datum/ammo/bullet/smg/ap
/obj/item/ammo_magazine/smg/m39/le
	name = "\improper M39 LE magazine (10x20mm)"
	desc = "A 10x20mm caseless light-explosive submachinegun magazine containing special light explosive rounds, designed to rapidly decimate armor, at the cost of vastly reduced damage and penetration."
	icon_state = "m39_le"
	default_ammo = /datum/ammo/bullet/smg/le

/obj/item/ammo_magazine/smg/m39/rubber
	name = "\improper M39 rubber magazine (10x20mm)"
	desc = "A 10x20mm caseless rubber bullet submachinegun magazine, containing rubber bullets. Non-lethal, but terrible on bioforms."
	icon_state = "m39_le"
	default_ammo = /datum/ammo/bullet/smg/rubber

/obj/item/ammo_magazine/smg/m39/penetrating
	name = "\improper M39 wall-piercing magazine (10x20mm)"
	desc = "A 10x20mm caseless wall-piercing bullet submachinegun magazine, containing wall-piercing bullets. Designed to penetrate straight through objects and walls."
	icon_state = "m39_penetrating"
	default_ammo = /datum/ammo/bullet/smg/penetrating

/obj/item/ammo_magazine/smg/m39/toxin
	name = "\improper M39 toxin magazine (10x20mm)"
	desc = "A 10x20mm caseless toxin bullet submachinegun magazine, containing toxin bullets. Great at stripping away armour and destroying biological structures."
	icon_state = "m39_toxin"
	default_ammo = /datum/ammo/bullet/smg/ap/toxin

/obj/item/ammo_magazine/smg/m39/incendiary
	name = "\improper M39 incendiary magazine (10x20mm)"
	desc = "A 10x20mm caseless incendiary submachinegun magazine. Incendiary payload sets targets ablaze, but causes the gun to have low stopping power and strongly decreased accuracy."
	icon_state = "m39_incendiary"
	default_ammo = /datum/ammo/bullet/smg/incendiary

/obj/item/ammo_magazine/smg/m39/extended
	name = "\improper M39 HV extended magazine (10x20mm)"
	desc = "A 10x20mm caseless HV extended submachinegun magazine. Powerful propellant allows the bullet increased travel speed and minor penetration capabilities, noticeably improving its efficacy at long ranges, although it still suffers significantly compared to a rifle bullet."
	max_rounds = 72
	icon_state = "m39_HV_extended"
	bonus_overlay = "m39_ex"


//-------------------------------------------------------
//M5, a classic SMG used in a lot of action movies.

/obj/item/ammo_magazine/smg/mp5
	name = "\improper MP5 magazine (9mm)"
	desc = "A 9mm magazine for the MP5."
	default_ammo = /datum/ammo/bullet/smg
	caliber = "9mm"
	icon_state = "mp7" //PLACEHOLDER
	gun_type = /obj/item/weapon/gun/smg/mp5
	max_rounds = 30 //Also comes in 10 and 40.


//-------------------------------------------------------
//MP27, based on the MP27, based on the M7.

/obj/item/ammo_magazine/smg/mp7
	name = "\improper MP27 magazine (4.6x30mm)"
	desc = "A 4.6mm magazine for the MP27."
	default_ammo = /datum/ammo/bullet/smg/ap
	caliber = "4.6x30mm"
	icon_state = "mp7"
	gun_type = /obj/item/weapon/gun/smg/mp7
	max_rounds = 30 //Also comes in 20 and 40.

//-------------------------------------------------------
//SKORPION //Based on the same thing.

/obj/item/ammo_magazine/smg/skorpion
	name = "\improper CZ-81 magazine (.32ACP)"
	desc = "A .32ACP caliber magazine for the CZ-81."
	caliber = ".32ACP"
	icon_state = "skorpion" //PLACEHOLDER
	gun_type = /obj/item/weapon/gun/smg/skorpion
	max_rounds = 30 //Can also be 10.


//-------------------------------------------------------
//PPSH //Based on the PPSh-41.

/obj/item/ammo_magazine/smg/ppsh
	name = "\improper PPSh-17b drum magazine (7.62x25mm)"
	desc = "A drum magazine for the PPSh submachinegun."
	caliber = "7.62x25mm"
	icon_state = "ppsh17b"
	w_class = SIZE_MEDIUM
	max_rounds = 35
	gun_type = /obj/item/weapon/gun/smg/ppsh

/obj/item/ammo_magazine/smg/ppsh/extended
	name = "\improper PPSh-17b extended magazine (7.62x25mm)"
	max_rounds = 71


//-------------------------------------------------------
//GENERIC UZI //Based on the uzi submachinegun, of course.

/obj/item/ammo_magazine/smg/uzi //Based on the Uzi.
	name = "\improper MAC-15 magazine (9mm)"
	desc = "A magazine for the MAC-15."
	caliber = "9mm"
	icon_state = "mac15"
	max_rounds = 32 //Can also be 20, 25, 40, and 50.
	gun_type = /obj/item/weapon/gun/smg/uzi

/obj/item/ammo_magazine/smg/uzi/extended
	name = "\improper MAC-15 extended magazine (9mm)"
	max_rounds = 50


//-------------------------------------------------------
//FP9000 //Based on the FN P90

/obj/item/ammo_magazine/smg/fp9000
	name = "FN FP9000 magazine (5.7x28mm)"
	desc = "A magazine for the FN FP9000 SMG."
	default_ammo = /datum/ammo/bullet/smg/ap
	caliber = "5.7x28mm"
	icon_state = "fp9000"
	w_class = SIZE_MEDIUM
	max_rounds = 50
	gun_type = /obj/item/weapon/gun/smg/fp9000

//-------------------------------------------------------
//Nailgun!
/obj/item/ammo_magazine/smg/nailgun
	name = "nailgun magazine (7x45mm)"
	desc = "A large magazine of oversized plasteel nails. Unfortunately, the production cost of those nail makes them ill-affordable for most military projects, and only some specific construction projects requires them."
	default_ammo = /datum/ammo/bullet/smg/nail
	flags_magazine = NO_FLAGS // Let's not start messing with nails...
	caliber = "7x45mm"
	icon_state = "nailgun"
	w_class = SIZE_SMALL
	max_rounds = 50
	gun_type = /obj/item/weapon/gun/smg/nailgun
