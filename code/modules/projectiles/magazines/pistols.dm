
//-------------------------------------------------------
//M4A3 PISTOL

/obj/item/ammo_magazine/pistol
	name = "\improper M4A3 magazine (9mm)"
	desc = "A pistol magazine."
	caliber = "9mm"
	icon_state = "m4a3"
	max_rounds = 9
	w_class = SIZE_SMALL
	default_ammo = /datum/ammo/bullet/pistol
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
	default_ammo = /datum/ammo/bullet/pistol/ap/penetrating

/obj/item/ammo_magazine/pistol/cluster
	name = "\improper M4A3 cluster magazine (9mm)"
	desc = "A pistol magazine. Designed to attach tiny explosives to targets, to detonate all at once if enough hit."
	icon_state = "m4a3_cluster"
	default_ammo = /datum/ammo/bullet/pistol/heavy/cluster

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
	max_rounds = 14
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

/obj/item/ammo_magazine/pistol/mod88/toxin
	name = "\improper 88M4 toxic magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/ap/toxin
	icon_state = "88m4_mag_toxin"

/obj/item/ammo_magazine/pistol/mod88/penetrating
	name = "\improper 88M4 wall-piercing magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/ap/penetrating
	icon_state = "88m4_mag_penetrating"

/obj/item/ammo_magazine/pistol/mod88/cluster
	name = "\improper 88M4 cluster magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/ap/cluster
	icon_state = "88m4_mag_cluster"

/obj/item/ammo_magazine/pistol/mod88/incendiary
	name = "\improper 88M4 incendiary magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/incendiary
	icon_state = "88m4_mag_incendiary"

/obj/item/ammo_magazine/pistol/mod88/rubber
	name = "\improper 88M4 rubber magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/rubber
	icon_state = "88m4_mag_rubber"


//-------------------------------------------------------
//VP78

/obj/item/ammo_magazine/pistol/vp78
	name = "\improper VP78 magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/squash
	caliber = "9mm"
	icon_state = "vp78" //PLACEHOLDER
	max_rounds = 18
	gun_type = /obj/item/weapon/gun/pistol/vp78

/obj/item/ammo_magazine/pistol/vp78/toxin
	name = "\improper VP78 toxic magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/squash/toxin
	icon_state = "vp78_toxin"

/obj/item/ammo_magazine/pistol/vp78/penetrating
	name = "\improper VP78 wall-piercing magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/squash/penetrating
	icon_state = "vp78_penetrating"

/obj/item/ammo_magazine/pistol/vp78/cluster
	name = "\improper VP78 cluster magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/squash/cluster
	icon_state = "vp78_cluster"

/obj/item/ammo_magazine/pistol/vp78/incendiary
	name = "\improper VP78 incendiary magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/squash/incendiary
	icon_state = "vp78_incendiary"


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
	icon_state = "deagle"
	max_rounds = 7
	gun_type = /obj/item/weapon/gun/pistol/heavy

/obj/item/ammo_magazine/pistol/heavy/super //Commander's variant
	name = "\improper Heavy Desert Eagle magazine (.50)"
	desc = "A heavy variant of Desert Eagle magazines specially-tuned to fit a high-ranking officer. This variant is optimized for anti-armor."
	gun_type = /obj/item/weapon/gun/pistol/heavy/co
	default_ammo = /datum/ammo/bullet/pistol/heavy/super
	icon_state = "deagleS"

/obj/item/ammo_magazine/pistol/heavy/super/highimpact
	name = "\improper High Impact Desert Eagle magazine (.50)"
	desc = "A heavy variant of Desert Eagle magazines specially-tuned to fit a high-ranking officer. This variant is optimized for anti-personnel. Don't fire it at anyone you'd like to stay alive."
	default_ammo = /datum/ammo/bullet/pistol/heavy/super/highimpact
	icon_state = "deagleE"

//-------------------------------------------------------
//MAUSER MERC PISTOL //Inspired by the Makarov.



/obj/item/ammo_magazine/pistol/c99
	name = "\improper PK-9 magazine (.380)"
	default_ammo = /datum/ammo/bullet/pistol
	caliber = ".380"
	icon_state = "pk-9"
	max_rounds = 8
	gun_type = /obj/item/weapon/gun/pistol/c99

/obj/item/ammo_magazine/pistol/c99/tranq
	name = "\improper PK-9 tranquilizer magazine (.380)"
	default_ammo = /datum/ammo/bullet/pistol/tranq
	icon_state = "pk-9_tranq"

//-------------------------------------------------------
//KT-42 //Inspired by the .44 Auto Mag pistol

/obj/item/ammo_magazine/pistol/kt42
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
It is a modified Beretta 93R, and can fire three-round burst or single fire. Whether or not anyone else aside RoboCop can use it is not established.
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

//-------------------------------------------------------
//SKORPION //Based on the same thing.

/obj/item/ammo_magazine/pistol/skorpion
	name = "\improper CZ-81 20-round magazine (.32ACP)"
	desc = "A .32ACP caliber magazine for the CZ-81."
	caliber = ".32ACP"
	icon_state = "skorpion" //PLACEHOLDER
	gun_type = /obj/item/weapon/gun/pistol/skorpion
	max_rounds = 20
