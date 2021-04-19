//Base pistol for inheritance/
//--------------------------------------------------

/obj/item/weapon/gun/pistol
	icon_state = "" //should return the honk-error sprite if there's no assigned icon.
	reload_sound = 'sound/weapons/flipblade.ogg'
	cocked_sound = 'sound/weapons/gun_pistol_cocked.ogg'

	matter = list("metal" = 2000)
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_MEDIUM
	force = 6
	movement_acc_penalty_mult = 3
	wield_delay = WIELD_DELAY_VERY_FAST //If you modify your pistol to be two-handed, it will still be fast to aim
	fire_sound = 'sound/weapons/gun_servicepistol.ogg'
	attachable_allowed = list(
						/obj/item/attachable/suppressor,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/compensator,
						/obj/item/attachable/lasersight,
						/obj/item/attachable/extended_barrel,
						/obj/item/attachable/heavy_barrel,
						/obj/item/attachable/burstfire_assembly)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED //For easy reference.
	gun_category = GUN_CATEGORY_HANDGUN

/obj/item/weapon/gun/pistol/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0)
		load_into_chamber()

/obj/item/weapon/gun/pistol/unique_action(mob/user)
		cock(user)


/obj/item/weapon/gun/pistol/set_gun_config_values()
	..()
	movement_acc_penalty_mult = 3

//-------------------------------------------------------
//M4A3 PISTOL

/obj/item/weapon/gun/pistol/m4a3
	name = "\improper M4A3 service pistol"//1911
	desc = "An M4A3 Service Pistol, the standard issue sidearm of the Colonial Marines. Fires 9mm pistol rounds."
	icon_state = "m4a3"
	item_state = "m4a3"
	current_mag = /obj/item/ammo_magazine/pistol
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_AMMO_COUNTER
	attachable_allowed = list(
						/obj/item/attachable/suppressor,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/compensator,
						/obj/item/attachable/lasersight,
						/obj/item/attachable/extended_barrel,
						/obj/item/attachable/heavy_barrel,
						/obj/item/attachable/burstfire_assembly)

/obj/item/weapon/gun/pistol/m4a3/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 28, "muzzle_y" = 20,"rail_x" = 10, "rail_y" = 21, "under_x" = 21, "under_y" = 17, "stock_x" = 21, "stock_y" = 17)


/obj/item/weapon/gun/pistol/m4a3/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_10
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT


/obj/item/weapon/gun/pistol/m4a3/training
	current_mag = /obj/item/ammo_magazine/pistol/rubber


/obj/item/weapon/gun/pistol/m4a3/custom
	name = "\improper M4A3 custom pistol"
	desc = "An M4A3 Service Pistol, the standard issue sidearm of the Colonial Marines. Uses 9mm pistol rounds. This one has an ivory-colored grip and has a slide carefully polished yearly by a team of orphan children. Looks like it belongs to a low-ranking officer."
	icon_state = "m4a3c"
	item_state = "m4a3c"

/obj/item/weapon/gun/pistol/m4a3/custom/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_10
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_2


//-------------------------------------------------------
//M4A3 45 //Inspired by the 1911
//deprecated

/obj/item/weapon/gun/pistol/m1911
	name = "\improper M1911 service pistol"
	desc = "A timeless classic since the first World War. Once standard issue for the USCM, now back order only. Chambered in .45 ACP. Unfortunately, due to the progression of IFF technology, M1911 .45 ACP is NOT compatible with the SU-6."
	icon_state = "m4a345"
	item_state = "m4a3"

	fire_sound = 'sound/weapons/gun_glock.ogg'
	current_mag = /obj/item/ammo_magazine/pistol/m1911


/obj/item/weapon/gun/pistol/m1911/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 28, "muzzle_y" = 20,"rail_x" = 10, "rail_y" = 22, "under_x" = 21, "under_y" = 17, "stock_x" = 21, "stock_y" = 17)


/obj/item/weapon/gun/pistol/m1911/set_gun_config_values()
	..()
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT

//-------------------------------------------------------
//Beretta 92FS, the gun McClane carries around in Die Hard. Very similar to the service pistol, all around.

/obj/item/weapon/gun/pistol/b92fs
	name = "\improper Beretta 92FS pistol"
	desc = "A popular police firearm in the 20th century, often employed by hardboiled cops while confronting terrorists. A classic of its time, chambered in 9mm."
	icon_state = "b92fs"
	item_state = "b92fs"
	current_mag = /obj/item/ammo_magazine/pistol/b92fs


/obj/item/weapon/gun/pistol/b92fs/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 28, "muzzle_y" = 20,"rail_x" = 10, "rail_y" = 22, "under_x" = 21, "under_y" = 17, "stock_x" = 21, "stock_y" = 17)

/obj/item/weapon/gun/pistol/b92fs/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_8
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT


//-------------------------------------------------------
//DEAGLE //This one is obvious.

/obj/item/weapon/gun/pistol/heavy
	name = "vintage Desert Eagle"
	desc = "A bulky 50 caliber pistol with a serious kick, probably taken from some museum somewhere. This one is engraved, 'Peace through superior firepower.'"
	icon_state = "deagle"
	item_state = "deagle"
	fire_sound = 'sound/weapons/gun_DE50.ogg'
	current_mag = /obj/item/ammo_magazine/pistol/heavy
	force = 13

	attachable_allowed = list(
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/extended_barrel,
						/obj/item/attachable/heavy_barrel,
						/obj/item/attachable/lasersight,
						/obj/item/attachable/compensator)

// /obj/item/weapon/gun/pistol/heavy/Initialize(mapload, spawn_empty)
//	. = ..()
//	var/skin = pick("","c_","g_")
//	icon_state = skin + icon_state
//	item_state = skin + item_state
//	base_gun_icon = skin + base_gun_icon


/obj/item/weapon/gun/pistol/heavy/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 31, "muzzle_y" = 21,"rail_x" = 9, "rail_y" = 23, "under_x" = 20, "under_y" = 17, "stock_x" = 20, "stock_y" = 17)


/obj/item/weapon/gun/pistol/heavy/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_4
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_7
	burst_scatter_mult = SCATTER_AMOUNT_TIER_4
	scatter_unwielded = SCATTER_AMOUNT_TIER_3
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_10
	recoil = RECOIL_AMOUNT_TIER_3
	recoil_unwielded = RECOIL_AMOUNT_TIER_2

/obj/item/weapon/gun/pistol/heavy/co
	name = "polished vintage Desert Eagle"
	desc = "A bulky 50 caliber pistol with a serious kick, probably taken from some museum somewhere. This one is engraved, 'Peace through superior firepower.'"
	icon_state = "c_deagle"
	item_state = "c_deagle"
	base_gun_icon = "c_deagle"

//-------------------------------------------------------
//MAUSER MERC PISTOL //Inspired by the Makarov.

/obj/item/weapon/gun/pistol/c99
	name = "\improper Korovin PK-9 pistol"
	desc = "An updated variant of an old eastern design, dating back to from the 20th century. Commonly found among mercenary companies due to its reliability, but also issued to UPP armed forces. Features an integrated silencer, and chambered in the razor small .22 rounds. This one is usually loaded with the more common .22 hollowpoint rounds and appears to be a mercenary version.."
	icon_state = "pk9"
	item_state = "pk9"

	fire_sound = 'sound/weapons/gun_c99.ogg'
	current_mag = /obj/item/ammo_magazine/pistol/c99
	attachable_allowed = list(
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/lasersight,
						/obj/item/attachable/burstfire_assembly)


/obj/item/weapon/gun/pistol/c99/handle_starting_attachment()//Making the gun have an invisible silencer since it's supposed to have one.
	..()
	var/obj/item/attachable/suppressor/S = new(src)
	S.hidden = TRUE
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)



/obj/item/weapon/gun/pistol/c99/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 30, "muzzle_y" = 19,"rail_x" = 10, "rail_y" = 22, "under_x" = 21, "under_y" = 18, "stock_x" = 21, "stock_y" = 18)


/obj/item/weapon/gun/pistol/c99/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_6
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_7
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT



/obj/item/weapon/gun/pistol/c99/russian
	icon_state = "pk9r"
	item_state = "pk9r"

/obj/item/weapon/gun/pistol/c99/upp
	desc = "An updated variant of an old eastern design, dating back to from the 20th century. Commonly found among mercenary companies due to its reliability, but also issued to UPP armed forces. Features an integrated silencer, and chambered in the razor small .22 rounds. This one is usually loaded with the more common .22 hollowpoint rounds and appears to be a UPP model."
	icon_state = "pk9u"
	item_state = "pk9u"

/obj/item/weapon/gun/pistol/c99/upp/tranq
	desc = "An updated variant of an old eastern design, dating back to from the 20th century. Commonly found among mercenary companies due to its reliability, but also issued to UPP armed forces. Features an integrated silencer, and chambered in the razor small .22 rounds. This one is usually loaded with special low-recoil .22 dart rounds, which act as a dangerous tranquilizer."
	desc = "This one is usually loaded with special low-recoil .22 dart rounds, which act as a dangerous tranquilizer."
	current_mag = /obj/item/ammo_magazine/pistol/c99t

//-------------------------------------------------------
//KT-42 //Inspired by the .44 Auto Mag pistol

/obj/item/weapon/gun/pistol/kt42
	name = "\improper KT-42 automag"
	desc = "The KT-42 Automag is an archaic but reliable design, going back many decades. There have been many versions and variations, but the 42 is by far the most common. You can't go wrong with this handcannon."
	icon_state = "kt42"
	item_state = "kt42"
	fire_sound = 'sound/weapons/gun_kt42.ogg'
	current_mag = /obj/item/ammo_magazine/pistol/automatic


/obj/item/weapon/gun/pistol/kt42/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 20,"rail_x" = 8, "rail_y" = 22, "under_x" = 22, "under_y" = 17, "stock_x" = 22, "stock_y" = 17)


/obj/item/weapon/gun/pistol/kt42/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_6*2
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5
	recoil_unwielded = RECOIL_AMOUNT_TIER_3


//-------------------------------------------------------
//PIZZACHIMP PROTECTION

/obj/item/weapon/gun/pistol/holdout
	name = "holdout pistol"
	desc = "A tiny pistol meant for hiding in hard-to-reach areas. Best not ask where it came from."
	icon_state = "holdout"
	item_state = "holdout"

	fire_sound = 'sound/weapons/gun_pistol_holdout.ogg'
	current_mag = /obj/item/ammo_magazine/pistol/holdout
	w_class = SIZE_TINY
	force = 2
	attachable_allowed = list(
						/obj/item/attachable/suppressor,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/heavy_barrel,
						/obj/item/attachable/lasersight,
						/obj/item/attachable/burstfire_assembly)


/obj/item/weapon/gun/pistol/holdout/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 25, "muzzle_y" = 20,"rail_x" = 12, "rail_y" = 22, "under_x" = 17, "under_y" = 15, "stock_x" = 22, "stock_y" = 17)

/obj/item/weapon/gun/pistol/holdout/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_9
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT

//-------------------------------------------------------
//CLF HOLDOUT PISTOL
/obj/item/weapon/gun/pistol/m43pistol
	name = "M43 Hummingbird Pistol"
	desc = "The M43 Hummingbird Pistol was produced in the mid-2170s as a cheap and concealable firearm for CLF Sleeper Cell agents for assassinations and ambushes, and is able to be concealed in shoes and workboots."
	icon_state = "m43"
	item_state = "m43"
	flags_gun_features = GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED
	fire_sound = 'sound/weapons/gun_m43.ogg'
	current_mag = /obj/item/ammo_magazine/pistol/m43pistol
	w_class = SIZE_TINY
	force = 5
	attachable_allowed = list(
						/obj/item/attachable/suppressor,
						/obj/item/attachable/flashlight)

/obj/item/weapon/gun/pistol/m43pistol/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 28, "muzzle_y" = 20,"rail_x" = 10, "rail_y" = 21, "under_x" = 21, "under_y" = 17, "stock_x" = 21, "stock_y" = 17)

/obj/item/weapon/gun/pistol/m43pistol/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_10
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_5
	scatter_unwielded = SCATTER_AMOUNT_TIER_8
	scatter = SCATTER_AMOUNT_TIER_9
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_4

//-------------------------------------------------------
//.45 MARSHALS PISTOL //Inspired by the Browning Hipower

/obj/item/weapon/gun/pistol/highpower
	name = "\improper Highpower automag"
	desc = "A Colonial Marshals issued, powerful semi-automatic pistol chambered in armor piercing 9mm caliber rounds. Used for centuries by law enforcement and criminals alike, recently recreated with this new model."
	icon_state = "highpower"
	item_state = "highpower"
	fire_sound = 'sound/weapons/gun_kt42.ogg'
	current_mag = /obj/item/ammo_magazine/pistol/highpower
	force = 10


/obj/item/weapon/gun/pistol/highpower/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 27, "muzzle_y" = 20,"rail_x" = 8, "rail_y" = 22, "under_x" = 16, "under_y" = 15, "stock_x" = 16, "stock_y" = 15)


/obj/item/weapon/gun/pistol/highpower/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_5
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_2
	recoil = RECOIL_AMOUNT_TIER_5
	recoil_unwielded = RECOIL_AMOUNT_TIER_3



//-------------------------------------------------------
//mod88 based off VP70 - Counterpart to M1911, offers burst and capacity ine exchange of low accuracy and damage.

/obj/item/weapon/gun/pistol/mod88
	name = "\improper 88 Mod 4 combat pistol"
	desc = "A powerful sidearm issued mainly to Weston-Yamada response teams, but issued to the USCM in small numbers, based on the original VP70 more than a century ago. Fires 9mm armor shredding rounds and is capable of 3-round burst."
	icon_state = "88m4"
	item_state = "88m4"

	fire_sound = 'sound/weapons/gun_88m4_v7.ogg'
	reload_sound = 'sound/weapons/gun_88m4_reload.ogg'
	unload_sound = 'sound/weapons/gun_88m4_unload.ogg'
	current_mag = /obj/item/ammo_magazine/pistol/mod88
	force = 8
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_AMMO_COUNTER


/obj/item/weapon/gun/pistol/mod88/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 27, "muzzle_y" = 21,"rail_x" = 8, "rail_y" = 22, "under_x" = 21, "under_y" = 18, "stock_x" = 18, "stock_y" = 15)


/obj/item/weapon/gun/pistol/mod88/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_9
	burst_amount = BURST_AMOUNT_TIER_3
	burst_delay = FIRE_DELAY_TIER_9
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_7
	burst_scatter_mult = SCATTER_AMOUNT_TIER_7
	scatter_unwielded = SCATTER_AMOUNT_TIER_7
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_4


/obj/item/weapon/gun/pistol/mod88/training
	current_mag = /obj/item/ammo_magazine/pistol/mod88/rubber

//-------------------------------------------------------
//VP78 - the only pistol viable as a primary.

/obj/item/weapon/gun/pistol/vp78
	name = "\improper VP78 pistol"
	desc = "A massive, formidable automatic handgun chambered in 9mm squash-head rounds. Commonly seen in the hands of wealthy Weston-Yamada members."
	icon_state = "vp78"
	item_state = "vp78"

	fire_sound = 'sound/weapons/gun_vp78_v2.ogg'
	reload_sound = 'sound/weapons/gun_vp78_reload.ogg'
	unload_sound = 'sound/weapons/gun_vp78_unload.ogg'
	current_mag = /obj/item/ammo_magazine/pistol/vp78
	force = 8
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_AMMO_COUNTER
	attachable_allowed = list(
						/obj/item/attachable/suppressor,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/compensator,
						/obj/item/attachable/lasersight,
						/obj/item/attachable/extended_barrel,
						/obj/item/attachable/heavy_barrel,
						/obj/item/attachable/burstfire_assembly)


/obj/item/weapon/gun/pistol/vp78/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 29, "muzzle_y" = 21,"rail_x" = 10, "rail_y" = 23, "under_x" = 20, "under_y" = 17, "stock_x" = 18, "stock_y" = 14)


/obj/item/weapon/gun/pistol/vp78/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_4
	burst_amount = BURST_AMOUNT_TIER_3
	burst_delay = FIRE_DELAY_TIER_9
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5
	recoil_unwielded = RECOIL_AMOUNT_TIER_4


//-------------------------------------------------------
/*
Auto 9 The gun RoboCop uses. A better version of the VP78, with more rounds per magazine. Probably the best pistol around, but takes no attachments.
It is a modified Beretta 93R, and can fire three round burst or single fire. Whether or not anyone else aside RoboCop can use it is not established.
*/

/obj/item/weapon/gun/pistol/auto9
	name = "\improper Auto-9 pistol"
	desc = "An advanced, select-fire machine pistol capable of three round burst. Last seen cleaning up the mean streets of Detroit."
	icon_state = "auto9"
	item_state = "auto9"

	fire_sound = 'sound/weapons/gun_pistol_large.ogg'
	current_mag = /obj/item/ammo_magazine/pistol/auto9
	force = 15

/obj/item/weapon/gun/pistol/auto9/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_7
	burst_amount = BURST_AMOUNT_TIER_3
	burst_delay = FIRE_DELAY_TIER_10
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5
	recoil_unwielded = RECOIL_AMOUNT_TIER_3



//-------------------------------------------------------
//The first rule of monkey pistol is we don't talk about monkey pistol.

/obj/item/weapon/gun/pistol/chimp
	name = "\improper CHIMP70 pistol"
	desc = "A powerful sidearm issued mainly to highly trained elite assassin necro-cyber-agents."
	icon_state = "c70"
	item_state = "c70"

	current_mag = /obj/item/ammo_magazine/pistol/chimp
	fire_sound = 'sound/weapons/gun_chimp70.ogg'
	w_class = SIZE_MEDIUM
	force = 8
	flags_gun_features = GUN_AUTO_EJECTOR

/obj/item/weapon/gun/pistol/chimp/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_8
	burst_delay = FIRE_DELAY_TIER_9
	burst_amount = BURST_AMOUNT_TIER_2
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT


//-------------------------------------------------------
//Smartpistol. An IFF pistol, pretty much.

/obj/item/weapon/gun/pistol/smart
	name = "\improper SU-6 Smartpistol"
	desc = "The SU-6 Smartpistol is an IFF-based sidearm currently undergoing field testing in the Colonial Marines. Uses modified .45 ACP IFF bullets. Capable of firing in bursts."
	icon_state = "smartpistol"
	item_state = "smartpistol"
	force = 8
	current_mag = /obj/item/ammo_magazine/pistol/smart
	fire_sound = 'sound/weapons/gun_su6.ogg'
	reload_sound = 'sound/weapons/handling/gun_su6_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_su6_unload.ogg'
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_AMMO_COUNTER

/obj/item/weapon/gun/pistol/smart/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 28, "muzzle_y" = 20,"rail_x" = 13, "rail_y" = 22, "under_x" = 24, "under_y" = 17, "stock_x" = 24, "stock_y" = 17)

/obj/item/weapon/gun/pistol/smart/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_10
	burst_amount = BURST_AMOUNT_TIER_3
	burst_delay = FIRE_DELAY_TIER_9
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5
	recoil_unwielded = RECOIL_AMOUNT_TIER_4

/obj/item/weapon/gun/pistol/smart/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

//-------------------------------------------------------
