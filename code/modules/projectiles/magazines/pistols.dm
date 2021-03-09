
//-------------------------------------------------------
//M4A3 PISTOL

/obj/item/ammo_magazine/pistol
	name = "\improper M4A3 magazine (9mm)"
	desc = "A pistol magazine."
	caliber = "9mm"
	icon_state = "m4a3"
	max_rounds = 9
	w_class = SIZE_SMALL
	default_ammo = /datum/ammo/bullet/pistol/heavy
	gun_type = /obj/item/weapon/gun/pistol/m4a3

/obj/item/ammo_magazine/pistol/hp
	name = "\improper M4A3 hollowpoint magazine (9mm)"
	desc = "A pistol magazine. This one contains hollowpoint bullets, which have noticeably higher stopping power on unarmoured targets, and noticeably less on armored targets."
	icon_state = "m4a3_hp"
	default_ammo = /datum/ammo/bullet/pistol/hollow

/obj/item/ammo_magazine/pistol/ap
	name = "\improper M4A3 AP magazine (9mm)"
	desc = "A pistol magazine. This one contains armor-piercing bullets, which have noticeably higher stopping power on well-armoured targets, and noticeably less on unarmored or lightly-armored targets."
	icon_state = "m4a3_ap"
	default_ammo = /datum/ammo/bullet/pistol/ap

/obj/item/ammo_magazine/pistol/rubber
	name = "\improper M4A3 Rubber magazine (9mm)"
	icon_state = "m4a3_le"
	default_ammo = /datum/ammo/bullet/pistol/rubber

/obj/item/ammo_magazine/pistol/incendiary
	name = "\improper M4A3 incendiary magazine (9mm)"
	icon_state = "m4a3_incendiary"
	default_ammo = /datum/ammo/bullet/pistol/incendiary

/obj/item/ammo_magazine/pistol/penetrating
	name = "\improper M4A3 wall-piercing magazine (9mm)"
	icon_state = "m4a3_penetrating"
	default_ammo = /datum/ammo/bullet/pistol/penetrating

/obj/item/ammo_magazine/pistol/toxin
	name = "\improper M4A3 toxin magazine (9mm)"
	icon_state = "m4a3_toxin"
	default_ammo = /datum/ammo/bullet/pistol/ap/toxin

//-------------------------------------------------------
//M4A3 45 //Inspired by the 1911

/obj/item/ammo_magazine/pistol/m1911
	name = "\improper M1911 magazine (.45)"
	default_ammo = /datum/ammo/bullet/pistol/heavy
	caliber = ".45"
	icon_state = "m4a345"//rename later
	max_rounds = 9
	gun_type = /obj/item/weapon/gun/pistol/m1911


//-------------------------------------------------------
//88M4 based off VP70

/obj/item/ammo_magazine/pistol/mod88
	name = "\improper 88M4 AP magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/ap
	caliber = "9mm"
	icon_state = "88m4_mag_ap"
	max_rounds = 19
	gun_type = /obj/item/weapon/gun/pistol/mod88

/obj/item/ammo_magazine/pistol/mod88/rubber
	name = "\improper 88M4 rubber magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/rubber

//-------------------------------------------------------
//VP78

/obj/item/ammo_magazine/pistol/vp78
	name = "\improper VP78 magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/squash
	caliber = "9mm"
	icon_state = "vp78" //PLACEHOLDER
	max_rounds = 14
	gun_type = /obj/item/weapon/gun/pistol/vp78


//-------------------------------------------------------
//Beretta 92FS, the gun McClane carries around in Die Hard. Very similar to the service pistol, all around.

/obj/item/ammo_magazine/pistol/b92fs
	name = "\improper Beretta 92FS magazine (9mm)"
	caliber = "9mm"
	icon_state = "m4a3" //PLACEHOLDER
	max_rounds = 15
	default_ammo = /datum/ammo/bullet/pistol
	gun_type = /obj/item/weapon/gun/pistol/b92fs


//-------------------------------------------------------
//DEAGLE //This one is obvious.

/obj/item/ammo_magazine/pistol/heavy
	name = "\improper Desert Eagle magazine (.50)"
	default_ammo = /datum/ammo/bullet/pistol/heavy
	caliber = ".50"
	icon_state = "m4a345" //PLACEHOLDER
	max_rounds = 7
	gun_type = /obj/item/weapon/gun/pistol/heavy



//-------------------------------------------------------
//MAUSER MERC PISTOL //Inspired by the Makarov.

/obj/item/ammo_magazine/pistol/c99t
	name = "\improper PK-9 magazine (.22 tranq)"
	default_ammo = /datum/ammo/bullet/pistol/tranq
	caliber = ".22"
	icon_state = "pk-9_tranq"
	max_rounds = 8
	gun_type = /obj/item/weapon/gun/pistol/c99

/obj/item/ammo_magazine/pistol/c99
	name = "\improper PK-9 magazine (.22 hollowpoint)"
	default_ammo = /datum/ammo/bullet/pistol/hollow
	caliber = ".22"
	icon_state = "pk-9"
	max_rounds = 12
	gun_type = /obj/item/weapon/gun/pistol/c99


//-------------------------------------------------------
//KT-42 //Inspired by the .44 Auto Mag pistol

/obj/item/ammo_magazine/pistol/automatic
	name = "\improper KT-42 magazine (.44)"
	default_ammo = /datum/ammo/bullet/pistol/heavy
	caliber = ".44"
	icon_state = "kt42"
	max_rounds = 7
	gun_type = /obj/item/weapon/gun/pistol/kt42


//-------------------------------------------------------
//PIZZACHIMP PROTECTION

/obj/item/ammo_magazine/pistol/holdout
	name = "tiny pistol magazine (.22)"
	desc = "A surprisingly small magazine, holding .22 bullets. No Kolibri, but it's getting there."
	default_ammo = /datum/ammo/bullet/pistol/tiny
	caliber = ".22"
	icon_state = "m4a3" //PLACEHOLDER
	max_rounds = 5
	w_class = SIZE_TINY
	gun_type = /obj/item/weapon/gun/pistol/holdout

//-------------------------------------------------------
//CLF HOLDOUT PISTOL
/obj/item/ammo_magazine/pistol/m43pistol
	name = "M43 magazine (9mm)"
	desc = "A small M43 magazine storing 7 9mm bullets. How is it even this small?"
	default_ammo = /datum/ammo/bullet/pistol
	caliber = "9mm"
	icon_state = "m4a3"
	max_rounds = 7
	w_class = SIZE_TINY
	gun_type = /obj/item/weapon/gun/pistol/m43pistol


//-------------------------------------------------------
//.45 MARSHALS PISTOL //Inspired by the Browning Hipower

/obj/item/ammo_magazine/pistol/highpower
	name = "\improper Highpower magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/ap
	caliber = "9mm"
	icon_state = "m4a3" //PLACEHOLDER
	max_rounds = 13
	gun_type = /obj/item/weapon/gun/pistol/highpower


//-------------------------------------------------------
/*
Auto 9 The gun RoboCop uses. A better version of the VP78, with more rounds per magazine. Probably the best pistol around, but takes no attachments.
It is a modified Beretta 93R, and can fire three round burst or single fire. Whether or not anyone else aside RoboCop can use it is not established.
*/

/obj/item/ammo_magazine/pistol/auto9
	name = "\improper Auto-9 magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/squash
	caliber = "9mm"
	icon_state = "88m4" //PLACEHOLDER
	max_rounds = 50
	gun_type = /obj/item/weapon/gun/pistol/auto9



//-------------------------------------------------------
//The first rule of monkey pistol is we don't talk about monkey pistol.
/obj/item/ammo_magazine/pistol/chimp
	name = "\improper CHIMP70 magazine (.70M)"
	default_ammo = /datum/ammo/bullet/pistol/mankey
	caliber = ".70M"
	icon_state = "c70" //PLACEHOLDER

	matter = list("metal" = 3000)
	max_rounds = 300
	gun_type = /obj/item/weapon/gun/pistol/chimp

//-------------------------------------------------------
//Smartpistol IFF magazine.

/obj/item/ammo_magazine/pistol/smart
	name = "\improper SU-6 Smartpistol magazine (.45)"
	default_ammo = /datum/ammo/bullet/pistol/smart
	caliber = ".45"
	icon_state = "smartpistol"
	max_rounds = 15
	gun_type = /obj/item/weapon/gun/pistol/smart
