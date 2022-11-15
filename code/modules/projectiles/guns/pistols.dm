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
	fire_sound = "m4a3"
	firesound_volume = 25
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

	current_mag = /obj/item/ammo_magazine/pistol/m1911


/obj/item/weapon/gun/pistol/m1911/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 28, "muzzle_y" = 20,"rail_x" = 10, "rail_y" = 22, "under_x" = 21, "under_y" = 17, "stock_x" = 21, "stock_y" = 17)


/obj/item/weapon/gun/pistol/m1911/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_8
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT


/obj/item/weapon/gun/pistol/m1911/socom
	name = "\improper SOCOM M1911 service pistol"
	desc = "A timeless classic since the first World War. Chambered in .45 ACP. This one has a darkened grip and appears especially well-kept. "
	icon_state = "m4a345_s"
	item_state = "m4a3"
	starting_attachment_types = list(/obj/item/attachable/suppressor, /obj/item/attachable/lasersight, /obj/item/attachable/reflex)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_AMMO_COUNTER

/obj/item/weapon/gun/pistol/m1911/socom/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_8
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_2


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
	firesound_volume = 40
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
	current_mag = /obj/item/ammo_magazine/pistol/kt42


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

/obj/item/weapon/gun/pistol/holdout/flashlight/handle_starting_attachment()
	..()
	var/obj/item/attachable/flashlight/flashlight = new(src)
	flashlight.Attach(src)
	update_attachable(flashlight.slot)

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
	fire_sound = "88m4"
	firesound_volume = 20
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


/obj/item/weapon/gun/pistol/mod88/flashlight/handle_starting_attachment()
	..()
	var/obj/item/attachable/flashlight/flashlight = new(src)
	flashlight.Attach(src)
	update_attachable(flashlight.slot)

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

/obj/item/weapon/gun/pistol/vp78/handle_starting_attachment()
	..()
	var/obj/item/attachable/lasersight/VP = new(src)
	VP.flags_attach_features &= ~ATTACH_REMOVABLE
	VP.hidden = FALSE
	VP.Attach(src)
	update_attachable(VP.slot)

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
It is a modified Beretta 93R, and can fire three-round burst or single fire. Whether or not anyone else aside RoboCop can use it is not established.
*/

/obj/item/weapon/gun/pistol/auto9
	name = "\improper Auto-9 pistol"
	desc = "An advanced, select-fire machine pistol capable of three-round burst. Last seen cleaning up the mean streets of Detroit."
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
//SKORPION //Based on the same thing.

/obj/item/weapon/gun/pistol/skorpion
	name = "\improper CZ-81 machine pistol"
	desc = "A robust, 20th century firearm that's a combination of pistol and submachinegun. Fires .32ACP caliber rounds from a 20-round magazine."
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
	desc = "A robust, 20th century firearm modernized for the 23rd century. Fires .32ACP caliber rounds from a 20-round magazine."
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
