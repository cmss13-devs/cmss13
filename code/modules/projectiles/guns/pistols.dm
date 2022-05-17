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
	movement_onehanded_acc_penalty_mult = 3
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
	movement_onehanded_acc_penalty_mult = 3

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
	attachable_offset = list("muzzle_x" = 30, "muzzle_y" = 20,"rail_x" = 17, "rail_y" = 21, "under_x" = 20, "under_y" = 17, "stock_x" = 20, "stock_y" = 17)


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
	desc = "The Desert Eagle. Expensive, heavy, and unwieldy, yet immensely powerful. Sporting rosewood grips and a monstrous amount of kick, it's a symbol of power more than anything. But it can kill a bear in its tracks, and you look like a badass in doing so."
	icon_state = "c_deagle"
	item_state = "c_deagle"
	base_gun_icon = "c_deagle"
	current_mag = /obj/item/ammo_magazine/pistol/heavy/super/highimpact

/obj/item/weapon/gun/pistol/heavy/co/gold
	name = "golden vintage Desert Eagle"
	desc = "A Desert Eagle anodized in gold and adorned with rosewood grips. The living definition of ostentatious, it's flashy, unwieldy, tremendously heavy, and kicks like a mule. But as a symbol of power, there's nothing like it."
	icon_state = "g_deagle"
	item_state = "g_deagle"
	base_gun_icon = "g_deagle"
//-------------------------------------------------------
//MAUSER MERC PISTOL //Inspired by the Makarov, specifically the "PB" version, an integrally silenced Makarov.
//Rebalanced: Now acts like an UPP M4A3.

/obj/item/weapon/gun/pistol/c99
	name = "\improper Korovin PK-9 pistol"
	desc = "The Korovin PK-9 is a cheap, robust and reliable sidearm, its design is strongly inspired by the classic ancient Makarov pistol. Commonly used by many groups, mostly those worried about cost."
	icon_state = "pk9"
	item_state = "pk9"
	inherent_traits = list(TRAIT_GUN_SILENCED)
	fire_sound = 'sound/weapons/gun_c99.ogg'
	current_mag = /obj/item/ammo_magazine/pistol/c99
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED
	attachable_allowed = list(
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/lasersight,
						/obj/item/attachable/burstfire_assembly
						)

/obj/item/weapon/gun/pistol/c99/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 30, "muzzle_y" = 19,"rail_x" = 10, "rail_y" = 22, "under_x" = 21, "under_y" = 18, "stock_x" = 21, "stock_y" = 18)

/obj/item/weapon/gun/pistol/c99/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_10
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_5

/obj/item/weapon/gun/pistol/c99/upp
	desc = "The Korovin PK-9 is a cheap, robust and reliable sidearm, its design is strongly inspired by the classic ancient Makarov pistol. This version has been refitted for military usage by the UPP."
	icon_state = "pk9u"
	item_state = "pk9u"

/obj/item/weapon/gun/pistol/c99/upp/tranq
	desc = "The Korovin PK-9 is a cheap, robust and reliable sidearm, its design strongly inspired by the classic ancient Makarov pistol. This version contains a customized exterior, an integrated laser and reflex sight, and is noticeably easy to handle."
	icon_state = "pk9r"
	item_state = "pk9r"
	current_mag = /obj/item/ammo_magazine/pistol/c99/tranq
	aim_slowdown = 0
	wield_delay = WIELD_DELAY_MIN


/obj/item/weapon/gun/pistol/c99/upp/tranq/handle_starting_attachment()
	..()
	var/obj/item/attachable/lasersight/LS = new(src)
	LS.flags_attach_features &= ~ATTACH_REMOVABLE
	LS.Attach(src)
	update_attachable(LS.slot)

	var/obj/item/attachable/reflex/RX = new(src)
	RX.flags_attach_features &= ~ATTACH_REMOVABLE
	RX.Attach(src)
	update_attachable(RX.slot)

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
	desc = "Standard issue USCM firearm. Also found in the hands of Weyland-Yutani PMC teams. Fires 9mm armor shredding rounds and is capable of 3-round burst."
	icon_state = "88m4"
	item_state = "88m4"
	fire_sound = 'sound/weapons/gun_88m4_v7.ogg'
	reload_sound = 'sound/weapons/gun_88m4_reload.ogg'
	unload_sound = 'sound/weapons/gun_88m4_unload.ogg'
	current_mag = /obj/item/ammo_magazine/pistol/mod88
	force = 8
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_AMMO_COUNTER
	attachable_allowed = list(
						/obj/item/attachable/suppressor,
						/obj/item/attachable/extended_barrel,
						/obj/item/attachable/heavy_barrel,
						/obj/item/attachable/compensator,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/reflex,
						/obj/item/attachable/reddot,
						/obj/item/attachable/burstfire_assembly,
						/obj/item/attachable/lasersight,
						/obj/item/attachable/flashlight/grip,
						/obj/item/attachable/magnetic_harness,
						/obj/item/attachable/stock/mod88)

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
	desc = "A massive, formidable automatic handgun chambered in 9mm squash-head rounds. Commonly seen in the hands of wealthy Weyland-Yutani members."
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
						/obj/item/attachable/heavy_barrel)


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
#define NOT_LOCKING	0
#define LOCKING_ON	1
#define LOCKED_ON	2
#define LOCK_ON_COOLDOWN 10

/obj/item/weapon/gun/pistol/smart
	name = "\improper SU-6 Smartpistol"
	desc = "The SU-6 Smartpistol is an IFF-based sidearm currently undergoing field testing in the Colonial Marines. Uses modified .45 ACP IFF bullets. Capable of firing in bursts. It can also lock onto targets via integrated circuitry and tracking systems."
	icon_state = "smartpistol"
	item_state = "smartpistol"
	force = 8
	current_mag = /obj/item/ammo_magazine/pistol/smart
	fire_sound = 'sound/weapons/gun_su6.ogg'
	reload_sound = 'sound/weapons/handling/gun_su6_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_su6_unload.ogg'
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_AMMO_COUNTER
	actions_types = list(/datum/action/item_action/smartpistol_lock_mode)
	var/locking_state = NOT_LOCKING
	var/mob/living/auto_aim_target //the ref to the mob we're locking onto
	var/lock_duration = 15 SECONDS //how long it lasts
	var/lockonattempt_cooldown = 0

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

/obj/item/weapon/gun/pistol/smart/Fire(atom/target, mob/living/user, params, reflex, dual_wield)
	if(locking_state == LOCKED_ON && auto_aim_target)
		target = auto_aim_target
	. = ..()

/obj/item/weapon/gun/pistol/smart/unwield(mob/user)
	. = ..()
	switch(locking_state)
		if(LOCKED_ON)
			break_iff_lock()
		if(LOCKING_ON)
			stop_aim()

/obj/item/weapon/gun/pistol/smart/Destroy()
	switch(locking_state)
		if(LOCKED_ON)
			break_iff_lock()
		if(LOCKING_ON)
			stop_aim()
	. = ..()

/obj/item/weapon/gun/pistol/smart/proc/break_iff_lock()
	if(!locking_state)
		return
	var/image/locked = image(icon = 'icons/effects/Targeted.dmi', icon_state = "locked-spistol")
	LAZYREMOVE(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_homing)
	))
	locking_state = NOT_LOCKING
	if(auto_aim_target)
		auto_aim_target.overlays &= ~locked
		REMOVE_TRAIT(auto_aim_target, TRAIT_LOCKED_ON_BY_SMARTPISTOL, TRAIT_SOURCE_ITEM("smartpistol"))
	auto_aim_target = null
	playsound(src, 'sound/weapons/TargetOff.ogg', 50, FALSE, 8, falloff = 0.4)
	STOP_PROCESSING(SSobj, src)
	lockonattempt_cooldown = world.time + LOCK_ON_COOLDOWN

/obj/item/weapon/gun/pistol/smart/proc/stop_aiming() //proc we use if interrupted during the aiming process
	if(!locking_state)
		return
	var/image/locking = image(icon = 'icons/effects/Targeted.dmi', icon_state = "locking-spistol")
	auto_aim_target.overlays &= ~locking
	if(auto_aim_target)
		REMOVE_TRAIT(auto_aim_target, TRAIT_LOCKED_ON_BY_SMARTPISTOL, TRAIT_SOURCE_ITEM("smartpistol"))
	auto_aim_target = null
	playsound(src, 'sound/weapons/TargetOff.ogg', 50, FALSE, 8, falloff = 0.4)
	lockonattempt_cooldown = world.time + LOCK_ON_COOLDOWN
	locking_state = NOT_LOCKING

/obj/item/weapon/gun/pistol/smart/process()
	. = ..()
	var/datum/action/item_action/smartpistol_lock_mode/ability = src.actions[1]
	var/mob/living/L = auto_aim_target
	if(!ability.check_can_keep_locking(L))
		break_iff_lock()

/datum/action/item_action/smartpistol_lock_mode
	name = "Aim Lock-On"

/datum/action/item_action/smartpistol_lock_mode/New(var/mob/living/user, var/obj/item/holder)
	..()
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('icons/mob/hud/actions.dmi', button, "spistol_aim")
	button.overlays |= IMG

/datum/action/item_action/smartpistol_lock_mode/action_activate()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(H.selected_ability == src)
		to_chat(H, "You will no longer use [name] with \
			[H.client && H.client.prefs && H.client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK ? "middle-click" : "shift-click"].")
		button.icon_state = "template"
		H.selected_ability = null
	else
		to_chat(H, "You will now use [name] with \
			[H.client && H.client.prefs && H.client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK ? "middle-click" : "shift-click"].")
		if(H.selected_ability)
			H.selected_ability.button.icon_state = "template"
			H.selected_ability = null
		button.icon_state = "template_on"
		H.selected_ability = src

/datum/action/item_action/smartpistol_lock_mode/can_use_action()
	var/mob/living/carbon/human/H = owner
	if(istype(H) && !H.is_mob_incapacitated() && !H.lying)
		return TRUE

/datum/action/item_action/smartpistol_lock_mode/proc/check_can_keep_locking(var/mob/M)
	var/mob/living/carbon/human/H = owner
	var/obj/item/weapon/gun/pistol/smart/SP = holder_item

	if(!can_use_action())
		return FALSE

	if(!SP.auto_aim_target)
		return FALSE

	if(get_dist(H, M) < 2)
		to_chat(H, SPAN_WARNING("[M] is too close to lock on to!"))
		return FALSE

	if(get_dist(H, M) > 7)
		to_chat(H, SPAN_WARNING("[M] is too far away for \the [SP]'s circuitry to get a lock!"))
		return FALSE

	return TRUE

/datum/action/item_action/smartpistol_lock_mode/proc/check_can_use(var/mob/living/M)
	var/mob/living/carbon/human/H = owner
	var/obj/item/weapon/gun/pistol/smart/SP = holder_item

	if(!istype(M))
		return FALSE

	if(!can_use_action())
		return FALSE

	if(!istype(H.l_hand, /obj/item/weapon/melee/twohanded/offhand) && !istype(H.r_hand, /obj/item/weapon/melee/twohanded/offhand))
		to_chat(H, SPAN_WARNING("Your grip on \the [SP] is not stable enough with just one hand. Use both hands!"))
		return FALSE

	if(!SP.in_chamber)
		to_chat(H, SPAN_WARNING("\The [SP] is unloaded!"))
		return FALSE

	if(get_dist(H, M) < 2)
		to_chat(H, SPAN_WARNING("[M] is too close to lock on to!"))
		return FALSE

	if(get_dist(H, M) > 7)
		to_chat(H, SPAN_WARNING("[M] is too far away for \the [SP]'s circuitry to get a lock!"))
		return FALSE

	if(!SP.in_chamber)
		to_chat(H, SPAN_WARNING("There is no ammo left in \the [SP], and it drops the lock."))
		return FALSE

	if(M.get_target_lock(H.faction_group))
		to_chat(H, SPAN_WARNING("\The [SP] refuses to lock onto [M]! They have a friendly IFF signal!"))
		return FALSE

	var/obj/item/projectile/P = SP.in_chamber
	if(check_shot_is_blocked(H, M, P))
		to_chat(H, SPAN_WARNING("Something is in the way, or you're out of range!"))
		return FALSE

	return TRUE

/datum/action/item_action/smartpistol_lock_mode/proc/check_shot_is_blocked(var/mob/firer, var/mob/target, obj/item/projectile/P)
	var/list/turf/path = getline2(firer, target, include_from_atom = FALSE)
	if(!path.len || get_dist(firer, target) > P.ammo.max_range)
		return TRUE

	var/blocked = FALSE
	for(var/turf/T in path)
		if(T.density || T.opacity)
			blocked = TRUE
			break

		for(var/obj/O in T)
			if(O.get_projectile_hit_boolean(P))
				blocked = TRUE
				break

		for(var/obj/effect/particle_effect/smoke/S in T)
			blocked = TRUE
			break

	return blocked

/datum/action/item_action/smartpistol_lock_mode/proc/use_ability(atom/A) //the proc for ACTUALLY using the ability
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	var/mob/living/M = A
	var/obj/item/weapon/gun/pistol/smart/SP = istype(H.l_hand, /obj/item/weapon/gun/pistol/smart) ? H.l_hand : H.r_hand
	var/obj/item/projectile/P = SP.in_chamber
	var/image/locking = image(icon = 'icons/effects/Targeted.dmi', icon_state = "locking-spistol", dir = get_cardinal_dir(M, H))
	var/image/locked = image(icon = 'icons/effects/Targeted.dmi', icon_state = "locked-spistol")
	// intial checks before we begin the locking sequence
	if(!istype(A, /mob/living))
		return

	if(M.stat == DEAD || M == H)
		return
	switch(SP.locking_state)
		if(LOCKED_ON)
			SP.break_iff_lock()
		if(LOCKING_ON)
			SP.stop_aiming()


	if(SP.lockonattempt_cooldown > world.time) //cooldown only to prevent spam toggling
		to_chat(H, SPAN_WARNING("\The [SP]'s internal circuitry is still recharging!"))
		return

	if(HAS_TRAIT(M, TRAIT_LOCKED_ON_BY_SMARTPISTOL))
		to_chat(H, SPAN_WARNING("Something is already locking on to \the [M]! Your gun's circuitry jams up!"))
		SP.lockonattempt_cooldown = world.time + LOCK_ON_COOLDOWN
		return

	if(!check_can_use(M))
		return

	///Add a decisecond to the default 1.5 seconds for each two tiles to hit.
	var/distance = round(get_dist(M, H) * 0.5)
	var/f_aiming_time = (5 * M.get_skill_duration_multiplier(SKILL_FIREARMS)) + distance

	//we now begin the locking sequence. To return after this, you must use the "stop_aiming" proc
	SP.auto_aim_target = M //assign here to help with the cancel procs
	ADD_TRAIT(SP.auto_aim_target, TRAIT_LOCKED_ON_BY_SMARTPISTOL, TRAIT_SOURCE_ITEM("smartpistol"))
	SP.locking_state = LOCKING_ON
	M.overlays |= locking
	if(H.client)
		playsound_client(H.client, 'sound/weapons/TargetOn.ogg', H, 50)
	playsound(M, 'sound/weapons/TargetOn.ogg', 70, FALSE, 8, falloff = 0.4)

	if(!do_after(H, f_aiming_time, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, NO_BUSY_ICON))
		return SP.stop_aiming()

	if(!check_can_use(M))
		return SP.stop_aiming()

	//we now lock on. To return after this, use the "break_iff_lock" proc
	M.overlays &= ~locking
	P.homing_target = M
	P.projectile_override_flags |= AMMO_HOMING
	SP.locking_state = LOCKED_ON
	M.overlays |= locked
	LAZYADD(SP.traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_homing)
	))
	addtimer(CALLBACK(SP, /obj/item/weapon/gun/pistol/smart/proc/break_iff_lock), SP.lock_duration)
	if(!do_after(H, delay = SP.lock_duration, user_flags = INTERRUPT_OUT_OF_RANGE, show_busy_icon = FALSE, target = M, target_flags = null, max_dist = 7))
		to_chat(H, SPAN_WARNING("[M] is too far away for \the [SP]'s circuitry to get a lock!"))
		return SP.break_iff_lock()
	START_PROCESSING(SSobj, SP)

#undef NOT_LOCKING
#undef LOCKING_ON
#undef LOCKED_ON
#undef LOCK_ON_COOLDOWN

//-------------------------------------------------------
//SKORPION //Based on the same thing.

/obj/item/weapon/gun/pistol/skorpion
	name = "\improper CZ-81 machine pistol"
	desc = "A robust, 20th century firearm that's a combination of pistol and submachinegun. Fires .32ACP caliber rounds from a 20 round magazine."
	icon_state = "skorpion"
	item_state = "skorpion"

	fire_sound = 'sound/weapons/gun_skorpion.ogg'
	current_mag = /obj/item/ammo_magazine/pistol/skorpion
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_HAS_FULL_AUTO|GUN_FULL_AUTO_ON
	attachable_allowed = list(
						//Rail
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/flashlight,
						//Muzzle
						/obj/item/attachable/suppressor,
						/obj/item/attachable/compensator,
						/obj/item/attachable/extended_barrel,
						/obj/item/attachable/heavy_barrel,
						//Underbarrel
						/obj/item/attachable/lasersight,
						/obj/item/attachable/burstfire_assembly,
						)

/obj/item/weapon/gun/pistol/skorpion/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 29, "muzzle_y" = 18,"rail_x" = 16, "rail_y" = 21, "under_x" = 23, "under_y" = 15, "stock_x" = 23, "stock_y" = 15)

/obj/item/weapon/gun/pistol/skorpion/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_10
	burst_delay = FIRE_DELAY_TIER_10
	burst_amount = BURST_AMOUNT_TIER_3

	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_1
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	damage_mult = BASE_BULLET_DAMAGE_MULT

	fa_delay = FIRE_DELAY_TIER_9
	fa_scatter_peak = 15 //shots
	fa_max_scatter = SCATTER_AMOUNT_TIER_6

/obj/item/weapon/gun/pistol/skorpion/upp
	desc = "A robust, 20th century firearm modernized for the 23rd century. Fires .32ACP caliber rounds from a 20 round magazine."
	icon_state = "skorpion_u"
	item_state = "skorpion_u"

/obj/item/weapon/gun/pistol/skorpion/upp/medic
	random_spawn_chance = 100
	random_rail_chance = 70
	random_spawn_rail = list(
							/obj/item/attachable/reflex,
							/obj/item/attachable/flashlight,
							)
	random_muzzle_chance = 50
	random_spawn_muzzle = list(
							/obj/item/attachable/suppressor,
							)
	random_under_chance = 60
	random_spawn_under = list(
							/obj/item/attachable/lasersight,
							)
