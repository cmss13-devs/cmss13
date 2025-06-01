
//-------------------------------------------------------
//M4A3 PISTOL

/obj/item/ammo_magazine/pistol
	name = "\improper M4A3 magazine (9mm)"
	desc = "A pistol magazine."
	caliber = "9mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/pistols.dmi'
	icon_state = "m4a3"
	max_rounds = 12
	w_class = SIZE_SMALL
	default_ammo = /datum/ammo/bullet/pistol
	gun_type = /obj/item/weapon/gun/pistol/m4a3
	ammo_band_icon = "+m4a3_band"
	ammo_band_icon_empty = "+m4a3_band_e"

/obj/item/ammo_magazine/pistol/hp
	name = "\improper M4A3 hollowpoint magazine (9mm)"
	desc = "A pistol magazine. This one contains hollowpoint bullets, which have noticeably higher stopping power on unarmored targets, and noticeably less on armored targets."
	default_ammo = /datum/ammo/bullet/pistol/hollow
	ammo_band_color = AMMO_BAND_COLOR_HOLLOWPOINT
	mag_jam_modifier = MAG_JAM_MOD_PISTOL_MEDIUM

/obj/item/ammo_magazine/pistol/ap
	name = "\improper M4A3 AP magazine (9mm)"
	desc = "A pistol magazine. This one contains armor-piercing bullets, which have noticeably higher stopping power on well-armored targets, and noticeably less on unarmored or lightly-armored targets."
	default_ammo = /datum/ammo/bullet/pistol/ap
	ammo_band_color = AMMO_BAND_COLOR_AP
	mag_jam_modifier = MAG_JAM_MOD_PISTOL_MEDIUM

/obj/item/ammo_magazine/pistol/rubber
	name = "\improper M4A3 Rubber magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/rubber
	ammo_band_color = AMMO_BAND_COLOR_RUBBER
	mag_jam_modifier = MAG_JAM_MOD_PISTOL_RUBBER //youre firing rubber, of course its gonna jam your shit a lot more... but its smaller so we give it a little pass

/obj/item/ammo_magazine/pistol/incendiary
	name = "\improper M4A3 incendiary magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/incendiary
	ammo_band_color = AMMO_BAND_COLOR_INCENDIARY
	mag_jam_modifier = MAG_JAM_MOD_PISTOL_LOW

/obj/item/ammo_magazine/pistol/penetrating
	name = "\improper M4A3 wall-penetrating magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/ap/penetrating
	ammo_band_color = AMMO_BAND_COLOR_PENETRATING
	mag_jam_modifier = MAG_JAM_MOD_PISTOL_FAIR

/obj/item/ammo_magazine/pistol/toxin
	name = "\improper M4A3 toxin magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/ap/toxin
	ammo_band_color = AMMO_BAND_COLOR_TOXIN
	mag_jam_modifier = MAG_JAM_MOD_PISTOL_LOW

//-------------------------------------------------------
//M4A3 45 //Inspired by the 1911

/obj/item/ammo_magazine/pistol/m1911
	name = "\improper M1911 magazine (.45)"
	default_ammo = /datum/ammo/bullet/pistol/heavy
	caliber = ".45"
	icon_state = "m4a345"//rename later
	max_rounds = 7
	gun_type = /obj/item/weapon/gun/pistol/m1911


//-------------------------------------------------------
//88M4 based off VP70

/obj/item/ammo_magazine/pistol/mod88
	name = "\improper 88M4 AP magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/ap
	caliber = "9mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/WY/pistols.dmi'
	icon_state = "88m4"
	max_rounds = 19
	gun_type = /obj/item/weapon/gun/pistol/mod88
	ammo_band_icon = "+88m4_band"
	ammo_band_icon_empty = "+88m4_band_e"
	ammo_band_color = AMMO_BAND_COLOR_AP

/obj/item/ammo_magazine/pistol/mod88/normalpoint // Unused
	name = "\improper 88M4 FMJ magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol
	caliber = "9mm"
	ammo_band_color = null

/obj/item/ammo_magazine/pistol/mod88/normalpoint/extended // Unused
	name = "\improper 88M4 FMJ extended magazine (9mm)"
	icon_state = "88m4_mag_ex"
	default_ammo = /datum/ammo/bullet/pistol
	caliber = "9mm"

/obj/item/ammo_magazine/pistol/mod88/toxin
	name = "\improper 88M4 toxic magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/ap/toxin
	ammo_band_color = AMMO_BAND_COLOR_TOXIN
	mag_jam_modifier = MAG_JAM_MOD_PISTOL_LOW

/obj/item/ammo_magazine/pistol/mod88/penetrating
	name = "\improper 88M4 wall-penetrating magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/ap/penetrating
	ammo_band_color = AMMO_BAND_COLOR_PENETRATING
	mag_jam_modifier = MAG_JAM_MOD_PISTOL_FAIR

/obj/item/ammo_magazine/pistol/mod88/incendiary
	name = "\improper 88M4 incendiary magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/incendiary
	ammo_band_color = AMMO_BAND_COLOR_INCENDIARY
	mag_jam_modifier = MAG_JAM_MOD_PISTOL_LOW

/obj/item/ammo_magazine/pistol/mod88/rubber
	name = "\improper 88M4 rubber magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/rubber
	ammo_band_color = AMMO_BAND_COLOR_RUBBER
	mag_jam_modifier = MAG_JAM_MOD_PISTOL_RUBBER //youre firing rubber, of course its gonna jam your shit a lot more... but its smaller so we give it a little pass

//-------------------------------------------------------
//ES-4

/obj/item/ammo_magazine/pistol/es4
	name = "\improper ES-4 stun magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/rubber/es4
	caliber = "9mm"
	desc = "Holds 19 rounds of specialized Conductive 9mm. Electrostatic propulsion in the ES-4 functions by propelling an cV9mm round, at a proportionally slower velocity to maintain a higher kinetic energy transfer rate. All this turns a penetrative round into a less-than-lethal round."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/WY/pistols.dmi'
	icon_state = "es4"
	max_rounds = 19
	gun_type = /obj/item/weapon/gun/pistol/es4

//-------------------------------------------------------
//VP78

/obj/item/ammo_magazine/pistol/vp78
	name = "\improper VP78 magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/squash
	caliber = "9mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/WY/pistols.dmi'
	icon_state = "vp78"
	max_rounds = 18
	gun_type = /obj/item/weapon/gun/pistol/vp78
	ammo_band_icon = "+vp78_band"
	ammo_band_icon_empty = "+vp78_band_e"

/obj/item/ammo_magazine/pistol/vp78/toxin
	name = "\improper VP78 toxic magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/squash/toxin
	ammo_band_color = AMMO_BAND_COLOR_TOXIN
	mag_jam_modifier = MAG_JAM_MOD_PISTOL_LOW

/obj/item/ammo_magazine/pistol/vp78/penetrating
	name = "\improper VP78 wall-penetrating magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/squash/penetrating
	ammo_band_color = AMMO_BAND_COLOR_PENETRATING
	mag_jam_modifier = MAG_JAM_MOD_PISTOL_FAIR

/obj/item/ammo_magazine/pistol/vp78/incendiary
	name = "\improper VP78 incendiary magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/squash/incendiary
	ammo_band_color = AMMO_BAND_COLOR_INCENDIARY
	mag_jam_modifier = MAG_JAM_MOD_PISTOL_LOW

/obj/item/ammo_magazine/pistol/vp78/rubber
	name = "\improper VP78 rubber magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/squash/rubber
	ammo_band_color = AMMO_BAND_COLOR_RUBBER

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
	default_ammo = /datum/ammo/bullet/pistol/deagle
	caliber = ".50"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony/pistols.dmi'
	icon_state = "deagle"
	max_rounds = 7
	gun_type = /obj/item/weapon/gun/pistol/heavy
	ammo_band_icon = "+deagle_band"
	ammo_band_icon_empty = "+deagle_band_e"

/obj/item/ammo_magazine/pistol/heavy/super //Commander's variant
	name = "\improper Heavy Desert Eagle magazine (.50)"
	desc = "Seven rounds of devastatingly powerful 50-caliber destruction."
	gun_type = /obj/item/weapon/gun/pistol/heavy/co
	default_ammo = /datum/ammo/bullet/pistol/heavy/super
	ammo_band_color = AMMO_BAND_COLOR_SUPER
	mag_jam_modifier = MAG_JAM_MOD_PISTOL_HIGH

/obj/item/ammo_magazine/pistol/heavy/super/highimpact
	name = "\improper High Impact Desert Eagle magazine (.50)"
	desc = "Seven rounds of devastatingly powerful 50-caliber destruction. The bullets are tipped with a synthesized osmium and lead alloy to stagger absolutely anything they hit. Point away from anything you value."
	default_ammo = /datum/ammo/bullet/pistol/heavy/super/highimpact
	ammo_band_color = AMMO_BAND_COLOR_HIGH_IMPACT
	mag_jam_modifier = MAG_JAM_MOD_PISTOL_CRITICAL

/obj/item/ammo_magazine/pistol/heavy/super/highimpact/ap
	name = "\improper High Impact Armor-Piercing Desert Eagle magazine (.50)"
	desc = "Seven rounds of devastatingly powerful 50-caliber destruction. Packs a devastating punch. The bullets are tipped with an osmium-tungsten carbide alloy to not only stagger but shred through any target's armor. Issued in few numbers due to the massive production cost and worries about hull breaches. Point away from anything you value."
	default_ammo = /datum/ammo/bullet/pistol/heavy/super/highimpact/ap
	ammo_band_color = AMMO_BAND_COLOR_AP
	mag_jam_modifier = MAG_JAM_MOD_PISTOL_CRITICAL

//-------------------------------------------------------
//Type 31 pistol. //A makarov

/obj/item/ammo_magazine/pistol/np92
	name = "\improper NP92 magazine (9x18mm Makarov)"
	default_ammo = /datum/ammo/bullet/pistol
	caliber = "9x18mm Makarov"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/UPP/pistols.dmi'
	icon_state = "np92mag"
	max_rounds = 12
	gun_type = /obj/item/weapon/gun/pistol/np92

/obj/item/ammo_magazine/pistol/np92/suppressed
	name = "\improper NPZ92 magazine (9x18mm Makarov)"
	default_ammo = /datum/ammo/bullet/pistol
	caliber = "9x18mm Makarov"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/UPP/pistols.dmi'
	icon_state = "npz92mag"
	max_rounds = 12

/obj/item/ammo_magazine/pistol/np92/tranq
	name = "\improper NPZ92 tranq magazine (9x18mm Makarov)"
	default_ammo = /datum/ammo/bullet/pistol/tranq
	caliber = "9x18mm Makarov"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/UPP/pistols.dmi'
	icon_state = "npz92tranqmag"
	max_rounds = 12
	mag_jam_modifier = MAG_JAM_MOD_PISTOL_MEDIUM

//-------------------------------------------------------
//Type 73 pistol. //A TT

/obj/item/ammo_magazine/pistol/t73
	name = "\improper Type 73 magazine (7.62x25mm Tokarev)"
	default_ammo = /datum/ammo/bullet/pistol/heavy
	caliber = "7.62x25mm Tokarev"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/UPP/pistols.dmi'
	icon_state = "ttmag"
	max_rounds = 9
	gun_type = /obj/item/weapon/gun/pistol/t73

/obj/item/ammo_magazine/pistol/t73_impact
	name = "\improper High Impact Type 74 magazine (7.62x25mm Tokarev)"
	default_ammo = /datum/ammo/bullet/pistol/heavy/super/highimpact/upp
	caliber = "7.62x25mm Tokarev"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/UPP/pistols.dmi'
	icon_state = "ttmag_impact"
	max_rounds = 9
	gun_type = /obj/item/weapon/gun/pistol/t73/leader
	mag_jam_modifier = MAG_JAM_MOD_PISTOL_HIGH

//-------------------------------------------------------
//KT-42 //Inspired by the .44 Auto Mag pistol

/obj/item/ammo_magazine/pistol/kt42
	name = "\improper KT-42 magazine (.44)"
	default_ammo = /datum/ammo/bullet/pistol/heavy
	caliber = ".44"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony/pistols.dmi'
	icon_state = "kt42"
	max_rounds = 16
	gun_type = /obj/item/weapon/gun/pistol/kt42

//-------------------------------------------------------
//PIZZACHIMP PROTECTION

/obj/item/ammo_magazine/pistol/holdout
	name = "tiny pistol magazine (.22)"
	desc = "A surprisingly small magazine, holding .22 bullets. No Kolibri, but it's getting there."
	default_ammo = /datum/ammo/bullet/pistol/tiny
	caliber = ".22"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony/pistols.dmi'
	icon_state = "holdout"
	max_rounds = 5
	w_class = SIZE_TINY
	gun_type = /obj/item/weapon/gun/pistol/holdout

//-------------------------------------------------------
//CLF HOLDOUT PISTOL
/obj/item/ammo_magazine/pistol/clfpistol
	name = "D18 magazine (9mm)"
	desc = "A small D18 magazine storing 7 9mm bullets. How is it even this small?"
	default_ammo = /datum/ammo/bullet/pistol
	caliber = "9mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/pistols.dmi'
	icon_state = "m4a3" // placeholder
	max_rounds = 7
	w_class = SIZE_TINY
	gun_type = /obj/item/weapon/gun/pistol/clfpistol


//-------------------------------------------------------
//.45 MARSHALS PISTOL //Inspired by the Browning Hipower
// rebalanced - singlefire, very strong bullets but slow to fire and heavy recoil
// redesigned - now rejected USCM sidearm model, utilized by Colonial Marshals and other stray groups.

/obj/item/ammo_magazine/pistol/highpower
	name = "\improper MK-45 Automagnum magazine (.45)"
	default_ammo = /datum/ammo/bullet/pistol/highpower
	caliber = ".45"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony/pistols.dmi'
	icon_state = "highpower"
	max_rounds = 13
	gun_type = /obj/item/weapon/gun/pistol/highpower

//comes in black, for the black variant of the highpower, better for military usage

/obj/item/ammo_magazine/pistol/highpower/black
	icon_state = "highpower_b"

//-------------------------------------------------------
/*
Auto 9 The gun RoboCop uses. A better version of the VP78, with more rounds per magazine. Probably the best pistol around, but takes no attachments.
It is a modified Beretta 93R, and can fire three-round burst or single fire. Whether or not anyone else aside RoboCop can use it is not established.
*/

/obj/item/ammo_magazine/pistol/auto9
	name = "\improper Auto-9 magazine (9mm)"
	default_ammo = /datum/ammo/bullet/pistol/squash
	caliber = "9mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/WY/pistols.dmi'
	icon_state = "88m4" //PLACEHOLDER
	max_rounds = 50
	gun_type = /obj/item/weapon/gun/pistol/auto9



//-------------------------------------------------------
//The first rule of monkey pistol is we don't talk about monkey pistol.
/obj/item/ammo_magazine/pistol/chimp
	name = "\improper CHIMP70 magazine (.70M)"
	default_ammo = /datum/ammo/bullet/pistol/mankey
	caliber = ".70M"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/event.dmi'
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
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/pistols.dmi'
	icon_state = "smartpistol"
	max_rounds = 15
	gun_type = /obj/item/weapon/gun/pistol/smart

//-------------------------------------------------------
//SKORPION //Based on the same thing.

/obj/item/ammo_magazine/pistol/skorpion
	name = "\improper CZ-81 20-round magazine (.32ACP)"
	desc = "A .32ACP caliber magazine for the CZ-81."
	caliber = ".32ACP"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony/smgs.dmi'
	icon_state = "skorpion" //PLACEHOLDER
	gun_type = /obj/item/weapon/gun/pistol/skorpion
	max_rounds = 20

//-------------------------------------------------------
/*
M10 Auto Pistol: A compact machine pistol that sacrifices accuracy for an impressive fire rate, shredding close-range targets with ease.
With a 40-round magazine, it can keep up sustained fire in tense situations, though its high recoil and low stability make it tricky to control.
Unlike other pistols, it can be equipped with limited mods (small muzzle, magazine, and optics) but has no burst-fire option.
*/

/obj/item/ammo_magazine/pistol/m10
	name = "\improper M10 HV magazine (10x20mm)"
	desc = "A compact 40-round high-velocity magazine, designed for rapid reloads and reliable performance in close-quarters combat."
	default_ammo = /datum/ammo/bullet/smg/m39
	caliber = "10x20mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/pistols.dmi'
	icon_state = "m10"
	bonus_overlay = "m10_overlay"
	bonus_overlay_icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/pistols.dmi'
	max_rounds = 40
	gun_type = /obj/item/weapon/gun/pistol/m10

/obj/item/ammo_magazine/pistol/m10/extended
	name = "\improper M10 HV extended magazine (10x20mm)"
	desc = "A 78-round high-velocity magazine, offering additional firepower for sustained engagements without significantly increasing reload time."
	default_ammo = /datum/ammo/bullet/smg/m39
	caliber = "10x20mm"
	icon_state = "m10_ext"
	bonus_overlay = "m10_ex_overlay"
	max_rounds = 78
	gun_type = /obj/item/weapon/gun/pistol/m10
	mag_jam_modifier = MAG_JAM_MOD_PISTOL_MEDIUM //the blicky

/obj/item/ammo_magazine/pistol/m10/drum
	name = "\improper M10 HV drum magazine (10x20mm)"
	desc = "High-capacity 92-round drum magazine designed for prolonged firefights, delivering maximum ammunition capacity at the cost of a longer reload."
	default_ammo = /datum/ammo/bullet/smg/m39
	caliber = "10x20mm"
	icon_state = "m10_drum"
	bonus_overlay = "m10_drum_overlay"
	max_rounds = 92
	gun_type = /obj/item/weapon/gun/pistol/m10
	mag_jam_modifier = MAG_JAM_MOD_PISTOL_CRITICAL //cant handle this shit brap brap brap
