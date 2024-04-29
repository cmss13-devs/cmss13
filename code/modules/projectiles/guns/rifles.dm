//-------------------------------------------------------

/obj/item/weapon/gun/rifle
	reload_sound = 'sound/weapons/gun_rifle_reload.ogg'
	cocked_sound = 'sound/weapons/gun_cocked2.ogg'

	flags_equip_slot = SLOT_BACK
	w_class = SIZE_LARGE
	force = 5
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK
	gun_category = GUN_CATEGORY_RIFLE
	aim_slowdown = SLOWDOWN_ADS_RIFLE
	wield_delay = WIELD_DELAY_NORMAL

/obj/item/weapon/gun/rifle/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0) load_into_chamber()

/obj/item/weapon/gun/rifle/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_5)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_11)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_2

/obj/item/weapon/gun/rifle/unique_action(mob/user)
	cock(user)


//-------------------------------------------------------
//M41A PULSE RIFLE

/obj/item/weapon/gun/rifle/m41a
	name = "\improper M41A pulse rifle MK2"
	desc = "The standard issue rifle of the Colonial Marines. Commonly carried by most combat personnel. Uses 10x24mm caseless ammunition."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "m41a"
	item_state = "m41a"
	fire_sound = "gun_pulse"
	reload_sound = 'sound/weapons/handling/m41_reload.ogg'
	unload_sound = 'sound/weapons/handling/m41_unload.ogg'
	current_mag = /obj/item/ammo_magazine/rifle
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/bayonet/co2,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/flashlight/grip,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/gyro,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/bipod,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/heavy_barrel/upgraded,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/stock/rifle,
		/obj/item/attachable/stock/rifle/collapsible,
		/obj/item/attachable/attached_gun/grenade,
		/obj/item/attachable/attached_gun/flamer,
		/obj/item/attachable/attached_gun/flamer/advanced,
		/obj/item/attachable/attached_gun/shotgun,
		/obj/item/attachable/attached_gun/extinguisher,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini,
	)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	starting_attachment_types = list(/obj/item/attachable/attached_gun/grenade, /obj/item/attachable/stock/rifle/collapsible)
	map_specific_decoration = TRUE
	start_automatic = TRUE

/obj/item/weapon/gun/rifle/m41a/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 23, "under_x" = 24, "under_y" = 13, "stock_x" = 24, "stock_y" = 13)


/obj/item/weapon/gun/rifle/m41a/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_11)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_11)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4 + 2*HIT_ACCURACY_MULT_TIER_1
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_2
	recoil_unwielded = RECOIL_AMOUNT_TIER_2


//variant without ugl attachment
/obj/item/weapon/gun/rifle/m41a/stripped
	starting_attachment_types = list()


/obj/item/weapon/gun/rifle/m41a/training
	current_mag = /obj/item/ammo_magazine/rifle/rubber


/obj/item/weapon/gun/rifle/m41a/tactical
	current_mag = /obj/item/ammo_magazine/rifle/ap
	starting_attachment_types = list(/obj/item/attachable/magnetic_harness, /obj/item/attachable/suppressor, /obj/item/attachable/angledgrip, /obj/item/attachable/stock/rifle/collapsible)
//-------------------------------------------------------
//NSG 23 ASSAULT RIFLE - PMC PRIMARY RIFLE

/obj/item/weapon/gun/rifle/nsg23
	name = "\improper NSG 23 assault rifle"
	desc = "A rare sight, this rifle is seen most commonly in the hands of Weyland-Yutani PMCs. Compared to the M41A MK2, it has noticeably improved handling and vastly improved performance at long and medium range, but compares similarly up close."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/wy.dmi'
	icon_state = "nsg23"
	item_state = "nsg23"
	fire_sound = "gun_nsg23"
	reload_sound = 'sound/weapons/handling/nsg23_reload.ogg'
	unload_sound = 'sound/weapons/handling/nsg23_unload.ogg'
	cocked_sound = 'sound/weapons/handling/nsg23_cocked.ogg'
	aim_slowdown = SLOWDOWN_ADS_QUICK
	wield_delay = WIELD_DELAY_VERY_FAST
	current_mag = /obj/item/ammo_magazine/rifle/nsg23
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/bipod,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/stock/nsg23,
		/obj/item/attachable/attached_gun/flamer,
		/obj/item/attachable/attached_gun/flamer/advanced,
		/obj/item/attachable/attached_gun/grenade,
		/obj/item/attachable/scope/mini/nsg23,
	)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_WY_RESTRICTED

	random_spawn_muzzle = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/extended_barrel,
	)
	starting_attachment_types = list(
		/obj/item/attachable/scope/mini/nsg23,
		/obj/item/attachable/attached_gun/flamer/advanced,
	)
	start_semiauto = FALSE
	start_automatic = TRUE

/obj/item/weapon/gun/rifle/nsg23/Initialize(mapload, spawn_empty)
	. = ..()
	update_icon()

/obj/item/weapon/gun/rifle/nsg23/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 16,"rail_x" = 13, "rail_y" = 22, "under_x" = 21, "under_y" = 10, "stock_x" = 5, "stock_y" = 17)

/obj/item/weapon/gun/rifle/nsg23/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_7)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_9)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_9
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_8
	recoil_unwielded = RECOIL_AMOUNT_TIER_2
	damage_falloff_mult = 0
	fa_max_scatter = SCATTER_AMOUNT_TIER_5

/obj/item/weapon/gun/rifle/nsg23/handle_starting_attachment()
	..()
	var/obj/item/attachable/stock/nsg23/S = new(src)
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)

//has no scope or underbarrel
/obj/item/weapon/gun/rifle/nsg23/stripped
	starting_attachment_types = list() //starts with the stock anyways due to handle_starting_attachment()

/obj/item/weapon/gun/rifle/nsg23/no_lock
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	starting_attachment_types = list(
		/obj/item/attachable/scope/mini/nsg23,
		/obj/item/attachable/attached_gun/flamer,//non-op flamer for normal spawns
	)

/obj/item/weapon/gun/rifle/nsg23/no_lock/stripped
	starting_attachment_types = list() //starts with the stock anyways due to handle_starting_attachment()

//-------------------------------------------------------
//M41A PMC VARIANT

/obj/item/weapon/gun/rifle/m41a/elite
	name = "\improper M41A/2 pulse rifle"
	desc = "A modified version M41A Pulse Rifle MK2, re-engineered for better weight, handling and accuracy. Fires precise two-round bursts. Given only to elite units."
	icon_state = "m41a2"
	item_state = "m41a2"

	current_mag = /obj/item/ammo_magazine/rifle/ap
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_WY_RESTRICTED
	aim_slowdown = SLOWDOWN_ADS_QUICK
	wield_delay = WIELD_DELAY_FAST
	map_specific_decoration = FALSE
	starting_attachment_types = list(/obj/item/attachable/stock/rifle/collapsible)

	random_spawn_chance = 100
	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/magnetic_harness,
	)
	random_spawn_under = list(
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/attached_gun/shotgun,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/attached_gun/flamer/advanced,
	)
	random_spawn_muzzle = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
	)


/obj/item/weapon/gun/rifle/m41a/elite/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_11)
	set_burst_amount(BURST_AMOUNT_TIER_2)
	set_burst_delay(FIRE_DELAY_TIER_12)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	scatter = SCATTER_AMOUNT_TIER_10
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_5

/obj/item/weapon/gun/rifle/m41a/elite/whiteout //special version for whiteout, has preset attachments and HEAP mag loaded.
	current_mag = /obj/item/ammo_magazine/rifle/heap
	starting_attachment_types = list(/obj/item/attachable/stock/rifle/collapsible, /obj/item/attachable/magnetic_harness, /obj/item/attachable/angledgrip, /obj/item/attachable/suppressor)

/obj/item/weapon/gun/rifle/m41a/corporate
	desc = "A Weyland-Yutani creation, this M41A MK2 comes equipped in corporate white. Uses 10x24mm caseless ammunition."
	icon = 'icons/obj/items/weapons/guns/guns_by_map/snow/guns_obj.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/obj/items/weapons/guns/guns_by_map/snow/guns_lefthand.dmi',
		WEAR_R_HAND = 'icons/obj/items/weapons/guns/guns_by_map/snow/guns_righthand.dmi',
		WEAR_BACK = 'icons/obj/items/weapons/guns/guns_by_map/snow/back.dmi',
		WEAR_J_STORE = 'icons/obj/items/weapons/guns/guns_by_map/snow/suit_slot.dmi'
	)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_WY_RESTRICTED
	map_specific_decoration = FALSE
	starting_attachment_types = list(/obj/item/attachable/stock/rifle/collapsible)

/obj/item/weapon/gun/rifle/m41a/corporate/no_lock //for PMC nightmares.
	desc = "A Weyland-Yutani creation, this M41A MK2 comes equipped in corporate white. Uses 10x24mm caseless ammunition. This one had its IFF electronics removed."
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER

/obj/item/weapon/gun/rifle/m41a/corporate/detainer //for chem ert
	current_mag = /obj/item/ammo_magazine/rifle/ap
	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/magnetic_harness,
	)
	random_spawn_muzzle = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/extended_barrel,
	)

	starting_attachment_types = list(/obj/item/attachable/stock/rifle/collapsible, /obj/item/attachable/attached_gun/flamer/advanced)

//-------------------------------------------------------
//M40-SD AKA SOF RIFLE FROM HELL (It's actually an M41A, don't tell!)

/obj/item/weapon/gun/rifle/m41a/elite/xm40
	name = "\improper XM40 pulse rifle"
	desc = "One of the experimental predecessors to the M41 line that never saw widespread adoption beyond elite marine units. Of the rifles in the USCM inventory that are still in production, this is the only one to feature an integrated suppressor. It can accept M41A MK2 magazines, but also features its own proprietary magazine system. Extremely lethal in burstfire mode."
	icon_state = "m40sd"
	item_state = "m40sd"
	reload_sound = 'sound/weapons/handling/m40sd_reload.ogg'
	unload_sound = 'sound/weapons/handling/m40sd_unload.ogg'
	unacidable = TRUE
	indestructible = TRUE

	current_mag = /obj/item/ammo_magazine/rifle/xm40/heap
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	aim_slowdown = SLOWDOWN_ADS_QUICK
	wield_delay = WIELD_DELAY_FAST
	map_specific_decoration = FALSE
	starting_attachment_types = list()
	accepted_ammo = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/rifle/extended,
		/obj/item/ammo_magazine/rifle/incendiary,
		/obj/item/ammo_magazine/rifle/explosive,
		/obj/item/ammo_magazine/rifle/le,
		/obj/item/ammo_magazine/rifle/ap,
		/obj/item/ammo_magazine/rifle/xm40,
		/obj/item/ammo_magazine/rifle/xm40/heap,
	)
	attachable_allowed = list(
		/obj/item/attachable/suppressor/xm40_integral,//no rail attachies
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/flashlight/grip,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/gyro,
		/obj/item/attachable/bipod,
		/obj/item/attachable/burstfire_assembly,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/attached_gun/grenade,
		/obj/item/attachable/attached_gun/flamer,
		/obj/item/attachable/attached_gun/flamer/advanced,
		/obj/item/attachable/attached_gun/shotgun,
		/obj/item/attachable/attached_gun/extinguisher,
		)

	random_spawn_chance = 0

/obj/item/weapon/gun/rifle/m41a/elite/xm40/handle_starting_attachment()
	..()
	var/obj/item/attachable/suppressor/xm40_integral/S = new(src)
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.hidden = FALSE
	S.Attach(src)
	update_attachable(S.slot)

	var/obj/item/attachable/magnetic_harness/H = new(src)//integrated mag harness, no rail attachies
	H.flags_attach_features &= ~ATTACH_REMOVABLE
	H.hidden = TRUE
	H.Attach(src)
	update_attachable(H.slot)

/obj/item/weapon/gun/rifle/m41a/elite/xm40/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 17,"rail_x" = 12, "rail_y" = 23, "under_x" = 24, "under_y" = 13, "stock_x" = 24, "stock_y" = 13)

/obj/item/weapon/gun/rifle/m41a/elite/xm40/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_11)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_12)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	scatter = SCATTER_AMOUNT_TIER_10
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_4

/obj/item/weapon/gun/rifle/m41a/elite/xm40/ap
	current_mag = /obj/item/ammo_magazine/rifle/xm40
//-------------------------------------------------------
//M41A TRUE AND ORIGINAL

/obj/item/weapon/gun/rifle/m41aMK1
	name = "\improper M41A pulse rifle"
	desc = "An older design of the Pulse Rifle commonly used by Colonial Marines. Uses 10x24mm caseless ammunition."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "m41amk1" //Placeholder.
	item_state = "m41amk1" //Placeholder.
	fire_sound = "gun_pulse"
	reload_sound = 'sound/weapons/handling/m41_reload.ogg'
	unload_sound = 'sound/weapons/handling/m41_unload.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/m41aMK1
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/reddot,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/reflex,
		/obj/item/attachable/attached_gun/grenade/mk1,
		/obj/item/attachable/stock/rifle/collapsible,
		/obj/item/attachable/attached_gun/shotgun,
	)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	starting_attachment_types = list(/obj/item/attachable/attached_gun/grenade/mk1, /obj/item/attachable/stock/rifle/collapsible)
	start_automatic = TRUE

/obj/item/weapon/gun/rifle/m41aMK1/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 23, "under_x" = 23, "under_y" = 13, "stock_x" = 24, "stock_y" = 14)


/obj/item/weapon/gun/rifle/m41aMK1/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_11)
	set_burst_amount(BURST_AMOUNT_TIER_4)
	set_burst_delay(FIRE_DELAY_TIER_11)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_9
	burst_scatter_mult = SCATTER_AMOUNT_TIER_9
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_2
	recoil_unwielded = RECOIL_AMOUNT_TIER_2

/obj/item/weapon/gun/rifle/m41aMK1/ap //for making it start with ap loaded
	current_mag = /obj/item/ammo_magazine/rifle/m41aMK1/ap

/obj/item/weapon/gun/rifle/m41aMK1/tactical
	starting_attachment_types = list(/obj/item/attachable/attached_gun/grenade/mk1, /obj/item/attachable/suppressor, /obj/item/attachable/magnetic_harness, /obj/item/attachable/stock/rifle/collapsible)
	current_mag = /obj/item/ammo_magazine/rifle/m41aMK1/ap

/obj/item/weapon/gun/rifle/m41aMK1/anchorpoint
	desc = "A classic M41 MK1 Pulse Rifle painted in a fresh coat of the classic Humbrol 170 camoflauge. This one appears to be used by the Colonial Marine contingent aboard Anchorpoint Station, and is equipped with an underbarrel shotgun. Uses 10x24mm caseless ammunition."
	starting_attachment_types = list(/obj/item/attachable/stock/rifle/collapsible, /obj/item/attachable/attached_gun/shotgun)
	current_mag = /obj/item/ammo_magazine/rifle/m41aMK1/ap

/obj/item/weapon/gun/rifle/m41aMK1/anchorpoint/gl
	desc = "A classic M41 MK1 Pulse Rifle painted in a fresh coat of the classic Humbrol 170 camoflauge. This one appears to be used by the Colonial Marine contingent aboard Anchorpoint Station, and is equipped with an underbarrel grenade launcher. Uses 10x24mm caseless ammunition."
	starting_attachment_types = list(/obj/item/attachable/stock/rifle/collapsible, /obj/item/attachable/attached_gun/grenade/mk1)
//----------------------------------------------
//Special gun for the CO to replace the smartgun

/obj/item/weapon/gun/rifle/m46c
	name = "\improper M46C pulse rifle"
	desc = "A prototype M46C, an experimental rifle platform built to outperform the standard M41A. Back issue only. Uses standard MK1 & MK2 rifle magazines."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "m46c"
	item_state = "m46c"
	fire_sound = "gun_pulse"
	reload_sound = 'sound/weapons/handling/m41_reload.ogg'
	unload_sound = 'sound/weapons/handling/m41_unload.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/incendiary

	accepted_ammo = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/rifle/rubber,
		/obj/item/ammo_magazine/rifle/extended,
		/obj/item/ammo_magazine/rifle/ap,
		/obj/item/ammo_magazine/rifle/incendiary,
		/obj/item/ammo_magazine/rifle/toxin,
		/obj/item/ammo_magazine/rifle/penetrating,
		/obj/item/ammo_magazine/rifle/m41aMK1,
		/obj/item/ammo_magazine/rifle/m41aMK1/ap,
		/obj/item/ammo_magazine/rifle/m41aMK1/incendiary,
		/obj/item/ammo_magazine/rifle/m41aMK1/heap,
		/obj/item/ammo_magazine/rifle/m41aMK1/toxin,
		/obj/item/ammo_magazine/rifle/m41aMK1/penetrating,
	)
	//somewhere in between the mk1 and mk2
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/heavy_barrel/upgraded,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/flashlight/grip,
		/obj/item/attachable/stock/rifle/collapsible,
		/obj/item/attachable/attached_gun/grenade,
		/obj/item/attachable/attached_gun/flamer,
		/obj/item/attachable/attached_gun/flamer/advanced,
		/obj/item/attachable/attached_gun/extinguisher,
		/obj/item/attachable/attached_gun/shotgun,
	)
	// CO rifle is guaranteed kitted out
	random_spawn_chance = 100
	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex/,
		/obj/item/attachable/scope/mini,
	)
	random_spawn_under = list(
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/attached_gun/shotgun,
	)
	random_spawn_muzzle = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/extended_barrel,
	)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	indestructible = TRUE
	auto_retrieval_slot = WEAR_J_STORE
	map_specific_decoration = TRUE

	var/mob/living/carbon/human/linked_human
	var/is_locked = TRUE
	var/iff_enabled = TRUE

/obj/item/weapon/gun/rifle/m46c/Initialize(mapload, ...)
	LAZYADD(actions_types, /datum/action/item_action/m46c/toggle_lethal_mode)
	LAZYADD(actions_types, /datum/action/item_action/m46c/toggle_id_lock)
	. = ..()
	if(iff_enabled)
		LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY_ID("iff", /datum/element/bullet_trait_iff)
		))
	recalculate_attachment_bonuses()

/obj/item/weapon/gun/rifle/m46c/Destroy()
	linked_human = null
	. = ..()

/obj/item/weapon/gun/rifle/m46c/handle_starting_attachment()
	..()
	var/obj/item/attachable/stock/rifle/collapsible/S = new(src)
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)


/obj/item/weapon/gun/rifle/m46c/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 17, "rail_x" = 11, "rail_y" = 19, "under_x" = 24, "under_y" = 12, "stock_x" = 24, "stock_y" = 13)


/obj/item/weapon/gun/rifle/m46c/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_9)
	set_burst_amount(BURST_AMOUNT_TIER_4)
	set_burst_delay(FIRE_DELAY_TIER_12)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_8
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_3
	recoil_unwielded = RECOIL_AMOUNT_TIER_2
	fa_max_scatter = SCATTER_AMOUNT_TIER_7

/obj/item/weapon/gun/rifle/m46c/able_to_fire(mob/user)
	. = ..()
	if(is_locked && linked_human && linked_human != user)
		if(linked_human.is_revivable() || linked_human.stat != DEAD)
			to_chat(user, SPAN_WARNING("[icon2html(src, usr)] Trigger locked by [src]. Unauthorized user."))
			playsound(loc,'sound/weapons/gun_empty.ogg', 25, 1)
			return FALSE

		linked_human = null
		is_locked = FALSE
		UnregisterSignal(linked_human, COMSIG_PARENT_QDELETING)

/obj/item/weapon/gun/rifle/m46c/pickup(user)
	if(!linked_human)
		name_after_co(user)
		to_chat(usr, SPAN_NOTICE("[icon2html(src, usr)] You pick up \the [src], registering yourself as its owner."))
	..()

//---ability actions--\\

/datum/action/item_action/m46c/action_activate()
	var/obj/item/weapon/gun/rifle/m46c/protag_gun = holder_item
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/protagonist = owner
	if(protagonist.is_mob_incapacitated() || protag_gun.get_active_firearm(protagonist, FALSE) != holder_item)
		return

/datum/action/item_action/m46c/update_button_icon()
	return

/datum/action/item_action/m46c/toggle_lethal_mode/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle IFF"
	action_icon_state = "iff_toggle_on"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/m46c/toggle_lethal_mode/action_activate()
	. = ..()
	var/obj/item/weapon/gun/rifle/m46c/protag_gun = holder_item
	protag_gun.toggle_iff(usr)
	if(protag_gun.iff_enabled)
		action_icon_state = "iff_toggle_on"
	else
		action_icon_state = "iff_toggle_off"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/m46c/toggle_id_lock/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle ID lock"
	action_icon_state = "id_lock_locked"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/m46c/toggle_id_lock/action_activate()
	. = ..()
	var/obj/item/weapon/gun/rifle/m46c/protag_gun = holder_item
	protag_gun.toggle_lock()
	if(protag_gun.is_locked)
		action_icon_state = "id_lock_locked"
	else
		action_icon_state = "id_lock_unlocked"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)


// -- ability actions procs -- \\

/obj/item/weapon/gun/rifle/m46c/proc/toggle_lock(mob/user)
	if(linked_human && usr != linked_human)
		to_chat(usr, SPAN_WARNING("[icon2html(src, usr)] Action denied by [src]. Unauthorized user."))
		return
	else if(!linked_human)
		name_after_co(usr)

	is_locked = !is_locked
	to_chat(usr, SPAN_NOTICE("[icon2html(src, usr)] You [is_locked? "lock": "unlock"] [src]."))
	playsound(loc,'sound/machines/click.ogg', 25, 1)

/obj/item/weapon/gun/rifle/m46c/proc/toggle_iff(mob/user)
	if(is_locked && linked_human && usr != linked_human)
		to_chat(usr, SPAN_WARNING("[icon2html(src, usr)] Action denied by [src]. Unauthorized user."))
		return

	gun_firemode = GUN_FIREMODE_SEMIAUTO
	iff_enabled = !iff_enabled
	to_chat(usr, SPAN_NOTICE("[icon2html(src, usr)] You [iff_enabled? "enable": "disable"] the IFF on [src]."))
	playsound(loc,'sound/machines/click.ogg', 25, 1)

	recalculate_attachment_bonuses()
	if(iff_enabled)
		add_bullet_trait(BULLET_TRAIT_ENTRY_ID("iff", /datum/element/bullet_trait_iff))
	else
		remove_bullet_trait("iff")

/obj/item/weapon/gun/rifle/m46c/recalculate_attachment_bonuses()
	. = ..()
	if(iff_enabled)
		modify_fire_delay(FIRE_DELAY_TIER_12)
		remove_firemode(GUN_FIREMODE_BURSTFIRE)
		remove_firemode(GUN_FIREMODE_AUTOMATIC)

	else
		add_firemode(GUN_FIREMODE_BURSTFIRE)
		add_firemode(GUN_FIREMODE_AUTOMATIC)


/obj/item/weapon/gun/rifle/m46c/proc/name_after_co(mob/living/carbon/human/H)
	linked_human = H
	RegisterSignal(linked_human, COMSIG_PARENT_QDELETING, PROC_REF(remove_idlock))

/obj/item/weapon/gun/rifle/m46c/get_examine_text(mob/user)
	. = ..()
	if(linked_human)
		if(is_locked)
			. += SPAN_NOTICE("It is registered to [linked_human].")
		else
			. += SPAN_NOTICE("It is registered to [linked_human] but has its fire restrictions unlocked.")
	else
		. += SPAN_NOTICE("It's unregistered. Pick it up to register yourself as its owner.")
	if(!iff_enabled)
		. += SPAN_WARNING("Its IFF restrictions are disabled.")

/obj/item/weapon/gun/rifle/m46c/proc/remove_idlock()
	SIGNAL_HANDLER
	linked_human = null

/obj/item/weapon/gun/rifle/m46c/stripped
	random_spawn_chance = 0//no extra attachies on spawn, still gets its stock though.

//-------------------------------------------------------
//MAR-40 AK CLONE //AK47 and FN FAL together as one.


/obj/item/weapon/gun/rifle/mar40
	name = "\improper MAR-40 battle rifle"
	desc = "A cheap, reliable assault rifle chambered in 7.62x39mm. Commonly found in the hands of criminals or mercenaries, or in the hands of the UPP or CLF."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "mar40"
	item_state = "mar40"
	fire_sound = 'sound/weapons/gun_mar40.ogg'
	reload_sound = 'sound/weapons/handling/gun_mar40_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_mar40_unload.ogg'

	current_mag = /obj/item/ammo_magazine/rifle/mar40
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/gyro,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/bipod,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/burstfire_assembly,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/attached_gun/grenade,
		/obj/item/attachable/attached_gun/flamer,
		/obj/item/attachable/attached_gun/flamer/advanced,
		/obj/item/attachable/attached_gun/extinguisher,
		/obj/item/attachable/attached_gun/shotgun,
		/obj/item/attachable/scope/slavic,
	)
	random_spawn_chance = 38
	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex/,
		/obj/item/attachable/scope/slavic,
		/obj/item/attachable/magnetic_harness,
	)
	random_spawn_under = list(
		/obj/item/attachable/gyro,
		/obj/item/attachable/bipod,
		/obj/item/attachable/attached_gun/flamer,
		/obj/item/attachable/attached_gun/extinguisher,
		/obj/item/attachable/attached_gun/shotgun,
		/obj/item/attachable/burstfire_assembly,
	)
	random_spawn_muzzle = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/compensator,
	)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK
	start_automatic = TRUE



/obj/item/weapon/gun/rifle/mar40/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 28, "muzzle_y" = 17,"rail_x" = 16, "rail_y" = 20, "under_x" = 24, "under_y" = 15, "stock_x" = 24, "stock_y" = 13)


/obj/item/weapon/gun/rifle/mar40/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_7)
	set_burst_amount(BURST_AMOUNT_TIER_4)
	set_burst_delay(FIRE_DELAY_TIER_11)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_2
	recoil = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/rifle/mar40/tactical
	desc = "A cheap, reliable assault rifle chambered in 7.62x39mm. Commonly found in the hands of criminals or mercenaries, or in the hands of the UPP or CLF. This one has been equipped with an after-market ammo-counter."
	starting_attachment_types = list(/obj/item/attachable/angledgrip, /obj/item/attachable/suppressor, /obj/item/attachable/magnetic_harness)
	flags_gun_features = GUN_AMMO_COUNTER|GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK

/obj/item/weapon/gun/rifle/mar40/carbine
	name = "\improper MAR-30 battle carbine"
	desc = "A cheap, reliable carbine chambered in 7.62x39mm. Commonly found in the hands of criminals or mercenaries."
	icon_state = "mar30"
	item_state = "mar30"
	fire_sound = 'sound/weapons/gun_mar40.ogg'
	reload_sound = 'sound/weapons/handling/gun_mar40_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_mar40_unload.ogg'

	aim_slowdown = SLOWDOWN_ADS_QUICK //Carbine is more lightweight
	wield_delay = WIELD_DELAY_FAST
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/bipod,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/heavy_barrel/upgraded,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/attached_gun/grenade,
		/obj/item/attachable/attached_gun/flamer,
		/obj/item/attachable/attached_gun/flamer/advanced,
		/obj/item/attachable/attached_gun/extinguisher,
		/obj/item/attachable/attached_gun/shotgun,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini,
	)
	random_spawn_chance = 35
	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex/,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/magnetic_harness,
	)
	random_spawn_under = list(
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/bipod,
		/obj/item/attachable/attached_gun/extinguisher,
		/obj/item/attachable/attached_gun/shotgun,
		/obj/item/attachable/lasersight,
	)
	random_spawn_muzzle = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/extended_barrel,
	)

/obj/item/weapon/gun/rifle/mar40/carbine/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_9)
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT - BULLET_DAMAGE_MULT_TIER_2
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	recoil_unwielded = RECOIL_AMOUNT_TIER_3

/obj/item/weapon/gun/rifle/mar40/carbine/tactical
	desc = "A cheap, reliable carbine chambered in 7.62x39mm. Commonly found in the hands of criminals or mercenaries. This one has been equipped with an after-market ammo-counter."
	starting_attachment_types = list(/obj/item/attachable/verticalgrip, /obj/item/attachable/suppressor, /obj/item/attachable/magnetic_harness)
	flags_gun_features = GUN_AMMO_COUNTER|GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK

/obj/item/weapon/gun/rifle/mar40/lmg
	name = "\improper MAR-50 light machine gun"
	desc = "A cheap, reliable LMG chambered in 7.62x39mm. Commonly found in the hands of slightly better funded criminals."
	icon_state = "mar50"
	item_state = "mar50"
	fire_sound = 'sound/weapons/gun_mar40.ogg'
	reload_sound = 'sound/weapons/handling/gun_mar40_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_mar40_unload.ogg'

	starting_attachment_types = list(/obj/item/attachable/mar50barrel)

	current_mag = /obj/item/ammo_magazine/rifle/mar40/lmg
	attachable_allowed = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/bipod,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/scope/slavic,
	)
	random_spawn_chance = 38
	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/scope/slavic,
		/obj/item/attachable/magnetic_harness,
	)

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_WIELDED_FIRING_ONLY

/obj/item/weapon/gun/rifle/mar40/lmg/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 16,"rail_x" = 16, "rail_y" = 20, "under_x" = 26, "under_y" = 16, "stock_x" = 24, "stock_y" = 13)

/obj/item/weapon/gun/rifle/mar40/lmg/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_9)
	set_burst_amount(BURST_AMOUNT_TIER_5)
	set_burst_delay(FIRE_DELAY_TIER_11)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_2
	recoil = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/rifle/mar40/lmg/tactical
	desc = "A cheap, reliable LMG chambered in 7.62x39mm. Commonly found in the hands of slightly better funded criminals. This one has been equipped with an after-market ammo-counter."
	starting_attachment_types = list(/obj/item/attachable/mar50barrel, /obj/item/attachable/bipod, /obj/item/attachable/magnetic_harness)
	flags_gun_features = GUN_AMMO_COUNTER|GUN_CAN_POINTBLANK|GUN_WIELDED_FIRING_ONLY
//-------------------------------------------------------
//M16 RIFLE

/obj/item/weapon/gun/rifle/m16
	name = "\improper M16 rifle"
	desc = "An old, reliable design first adopted by the U.S. military in the 1960s. Something like this belongs in a museum of war history. It is chambered in 5.56x45mm."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "m16"
	item_state = "m16"

	fire_sound = 'sound/weapons/gun_m16.ogg'
	reload_sound = 'sound/weapons/handling/gun_m16_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_m16_unload.ogg'

	current_mag = /obj/item/ammo_magazine/rifle/m16
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/flashlight/grip,
		/obj/item/attachable/gyro,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/bipod,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/burstfire_assembly,
		/obj/item/attachable/attached_gun/grenade,
		/obj/item/attachable/attached_gun/flamer,
		/obj/item/attachable/attached_gun/flamer/advanced,
		/obj/item/attachable/attached_gun/extinguisher,
		/obj/item/attachable/attached_gun/shotgun,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/stock/m16,
	)
	random_spawn_chance = 42
	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex/,
		/obj/item/attachable/scope/mini,
	)
	random_spawn_under = list(
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/gyro,
		/obj/item/attachable/burstfire_assembly,
		/obj/item/attachable/bipod,
		/obj/item/attachable/attached_gun/extinguisher,
		/obj/item/attachable/attached_gun/shotgun,
		/obj/item/attachable/lasersight,
	)
	random_spawn_muzzle = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/compensator,
		/obj/item/attachable/extended_barrel,
	)

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_ANTIQUE

/obj/item/weapon/gun/rifle/m16/handle_starting_attachment()
	..()
	var/obj/item/attachable/stock/m16/S = new(src)
	S.hidden = FALSE
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)

/obj/item/weapon/gun/rifle/m16/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 17,"rail_x" = 9, "rail_y" = 20, "under_x" = 22, "under_y" = 14, "stock_x" = 15, "stock_y" = 14)

/obj/item/weapon/gun/rifle/m16/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_11)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_11)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_7
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_10
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_6
	recoil_unwielded = RECOIL_AMOUNT_TIER_2

/obj/item/weapon/gun/rifle/m16/grenadier
	name = "\improper M16 grenadier rifle"
	desc = "An old, reliable design first adopted by the U.S. military in the 1960s. Something like this belongs in a museum of war history. It is chambered in 5.56x45mm. This one has an irremovable M203 grenade launcher attached to it, holds one propriatary 40mm shell at a time, it lacks modern IFF systems and will impact the first target it hits; introduce your little friend."
	icon_state = "m16g"
	item_state = "m16"
	fire_sound = 'sound/weapons/gun_m16.ogg'
	reload_sound = 'sound/weapons/handling/gun_m16_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_m16_unload.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/m16
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/scope,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/attached_gun/grenade/m203,
	)
	random_spawn_chance = 42
	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex/,
		/obj/item/attachable/scope/mini,
	)
	random_spawn_muzzle = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/compensator,
		/obj/item/attachable/extended_barrel,
	)

/obj/item/weapon/gun/rifle/m16/grenadier/handle_starting_attachment()
	..()
	var/obj/item/attachable/attached_gun/grenade/m203/integrated = new(src)
	integrated.flags_attach_features &= ~ATTACH_REMOVABLE
	integrated.hidden = FALSE
	integrated.Attach(src)
	update_attachable(integrated.slot)

//-------------------------------------------------------
//XM177 carbine
//awesome vietnam era special forces carbine version of the M16

/obj/item/weapon/gun/rifle/xm177
	name = "\improper XM177E2 carbine"
	desc = "An old design, essentially a shortened M16A1 with a collapsable stock. It is chambered in 5.56x45mm. The short length inhibits the attachment of most underbarrel attachments, and the barrel moderator prohibits the attachment of all muzzle devices."
	desc_lore = "A carbine similar to the M16A1, with a collapsible stock and a distinct flash suppressor. A stamp on the receiver reads: 'COLT AR-15 - PROPERTY OF U.S. GOVT - XM177E2 - CAL 5.56MM' \nA design originating from the Vietnam War, the XM177, also known as the Colt Commando or GAU-5/A, was an improvement on the CAR-15 Model 607, fixing multiple issues found with the limited service of the Model 607 with Special Forces. The XM177 saw primary use with Army Special Forces and Navy Seals operating as commandos. \nHow this got here is a mystery."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "xm177"
	item_state = "m16"
	current_mag = /obj/item/ammo_magazine/rifle/m16

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_ANTIQUE

	fire_sound = 'sound/weapons/gun_m16.ogg'
	reload_sound = 'sound/weapons/handling/gun_m16_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_m16_unload.ogg'
	accepted_ammo = list(
		/obj/item/ammo_magazine/rifle/m16,
		/obj/item/ammo_magazine/rifle/m16/ap,
	)

	attachable_allowed = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/stock/m16/xm177,
	)

	random_spawn_chance = 75
	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex/,
		/obj/item/attachable/flashlight,
	)
	random_spawn_under = list(
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/lasersight,
	)

/obj/item/weapon/gun/rifle/xm177/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 30, "muzzle_y" = 18,"rail_x" = 9, "rail_y" = 20, "under_x" = 19, "under_y" = 13, "stock_x" = 15, "stock_y" = 14)

/obj/item/weapon/gun/rifle/xm177/handle_starting_attachment()
	..()
	var/obj/item/attachable/stock/m16/xm177/integrated = new(src)
	integrated.hidden = FALSE
	integrated.flags_attach_features &= ~ATTACH_REMOVABLE
	integrated.Attach(src)
	update_attachable(integrated.slot)

/obj/item/weapon/gun/rifle/xm177/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_SMG)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_SMG)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_6
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_3
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_7
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_6
	recoil_unwielded = RECOIL_AMOUNT_TIER_2

//-------------------------------------------------------
//AR10 rifle
//basically an early M16

/obj/item/weapon/gun/rifle/ar10
	name = "\improper AR10 rifle"
	desc = "An earlier version of the more widespread M16 rifle. Considered to be the father of the 20th century rifle. How one of these ended up here is a mystery of its own. It is chambered in 7.62x51mm."
	desc_lore = "The AR10 was initially manufactured by the Armalite corporation (bought by Weyland-Yutani in 2002) in the 1950s. It was the first production rifle to incorporate many new and innovative features, such as a gas operated bolt and carrier system. Only 10,000 were ever produced, and the only national entities to use them were Portugal and Sudan. Since the end of the 20th century, these rifles - alongside the far more common M16 and AR15 - have floated around the less civillised areas of space, littering jungles and colony floors with their uncommon cased ammunition - a rarity since the introduction of pulse munitions. This rifle has the word \"Salazar\" engraved on its side."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "ar10"
	item_state = "ar10"
	fire_sound = 'sound/weapons/gun_ar10.ogg'
	reload_sound = 'sound/weapons/handling/gun_m16_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_ar10_unload.ogg'
	cocked_sound = 'sound/weapons/handling/gun_ar10_cocked.ogg'

	current_mag = /obj/item/ammo_magazine/rifle/ar10
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/flashlight/grip,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/bipod,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/stock/ar10,
	)
	random_spawn_chance = 10
	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex/,
		/obj/item/attachable/scope/mini,
	)
	random_spawn_under = list(
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/bipod,
	)
	random_spawn_muzzle = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/compensator,
		/obj/item/attachable/extended_barrel,
	)

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_ANTIQUE

/obj/item/weapon/gun/rifle/ar10/handle_starting_attachment()
	..()
	var/obj/item/attachable/stock/ar10/S = new(src)
	S.hidden = FALSE
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)

/obj/item/weapon/gun/rifle/ar10/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 17,"rail_x" = 8, "rail_y" = 20, "under_x" = 22, "under_y" = 14, "stock_x" = 15, "stock_y" = 14)

/obj/item/weapon/gun/rifle/ar10/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_7)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_7)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_8
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_9
	burst_scatter_mult = SCATTER_AMOUNT_TIER_9
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_8
	recoil_unwielded = RECOIL_AMOUNT_TIER_3

//-------------------------------------------------------
//DUTCH'S GEAR

/obj/item/weapon/gun/rifle/m16/dutch
	name = "\improper Dutch's M16A1"
	desc = "A modified M16 employed by Dutch's Dozen mercenaries. It has 'CLOAKER KILLER' printed on a label on the side. Chambered in 5.56x45mm."
	icon_state = "m16a1"
	current_mag = /obj/item/ammo_magazine/rifle/m16/ap
	starting_attachment_types = list(/obj/item/attachable/bayonet)

	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex/,
	)
	random_spawn_under = list(
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/burstfire_assembly,
		/obj/item/attachable/attached_gun/extinguisher,
		/obj/item/attachable/attached_gun/shotgun,
		/obj/item/attachable/lasersight,
	)
	random_spawn_muzzle = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/extended_barrel,
	)

/obj/item/weapon/gun/rifle/m16/dutch/set_gun_config_values()
	..()
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_8

/obj/item/weapon/gun/rifle/m16/grenadier/dutch
	name = "\improper Dutch's Grenadier M16A1"
	desc = "A modified M16 employed by Dutch's Dozen mercenaries. It has 'CLOAKER KILLER' printed on a label on the side. It is chambered in 5.56x45mm. This one has an irremovable M203 grenade launcher attached to it, holds one propriatary 40mm shell at a time, it lacks modern IFF systems and will impact the first target it hits; introduce your little friend."
	current_mag = /obj/item/ammo_magazine/rifle/m16/ap
	starting_attachment_types = list(/obj/item/attachable/scope/mini, /obj/item/attachable/bayonet)

/obj/item/weapon/gun/rifle/m16/grenadier/dutch/set_gun_config_values()
	..()
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_8

/obj/item/weapon/gun/rifle/xm177/dutch
	name = "\improper Dutch's XM177E2 Carbine"
	desc = "A modified XM177 employed by Dutch's Dozen mercenaries. It has 'CLOAKER KILLER' printed on a label on the side. It is chambered in 5.56x45mm. The short length inhibits the attachment of most underbarrel attachments, and the barrel moderator prohibits the attachment of all muzzle devices."
	desc_lore = "A carbine similar to the M16A1, with a collapsible stock and a distinct flash suppressor. A stamp on the receiver reads: 'COLT AR-15 - PROPERTY OF U.S. GOVT - XM177E2 - CAL 5.56MM', above the receiver is a crude sketching of some sort of mask? with the words 'CLOAKER KILLER' and seven tally marks etched on. \nA design originating from the Vietnam War, the XM177, also known as the Colt Commando or GAU-5/A, was an improvement on the CAR-15 Model 607, fixing multiple issues found with the limited service of the Model 607 with Special Forces. The XM177 saw primary use with Army Special Forces and Navy Seals operating as commandos. \nHow this got here is a mystery."
	icon_state = "xm177"
	current_mag = /obj/item/ammo_magazine/rifle/m16/ap

/obj/item/weapon/gun/rifle/xm177/dutch/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_SMG)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_SMG)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_6
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_3
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_7
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_8
	recoil_unwielded = RECOIL_AMOUNT_TIER_2


//-------------------------------------------------------
//M41AE2 HEAVY PULSE RIFLE

/obj/item/weapon/gun/rifle/lmg
	name = "\improper M41AE2 heavy pulse rifle"
	desc = "A large squad support weapon capable of laying down sustained suppressing fire from a mounted position. While unstable and less accurate, it can be lugged and shot with two hands. Like it's smaller brothers, the M41A MK2 and M4RA, the M41AE2 is chambered in 10mm."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "m41ae2"
	item_state = "m41ae2"

	reload_sound = 'sound/weapons/handling/hpr_reload.ogg'
	unload_sound = 'sound/weapons/handling/hpr_unload.ogg'
	fire_sound = 'sound/weapons/gun_hpr.ogg'
	aim_slowdown = SLOWDOWN_ADS_LMG
	current_mag = /obj/item/ammo_magazine/rifle/lmg
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/flashlight/grip,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/bipod,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/heavy_barrel/upgraded,
		/obj/item/attachable/compensator,
		/obj/item/attachable/burstfire_assembly,
		/obj/item/attachable/magnetic_harness,
	)

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_WIELDED_FIRING_ONLY|GUN_SUPPORT_PLATFORM
	gun_category = GUN_CATEGORY_HEAVY

/obj/item/weapon/gun/rifle/lmg/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 19,"rail_x" = 10, "rail_y" = 23, "under_x" = 23, "under_y" = 12, "stock_x" = 24, "stock_y" = 12)


/obj/item/weapon/gun/rifle/lmg/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_LMG)
	set_burst_amount(BURST_AMOUNT_TIER_5)
	set_burst_delay(FIRE_DELAY_TIER_LMG)
	fa_scatter_peak = FULL_AUTO_SCATTER_PEAK_TIER_3
	fa_max_scatter = SCATTER_AMOUNT_TIER_4
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4 - HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_5
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_1



//-------------------------------------------------------


//-------------------------------------------------------
//UPP TYPE 71 RIFLE

/obj/item/weapon/gun/rifle/type71
	name = "\improper Type 71 pulse rifle"
	desc = "The primary service rifle of the UPP space forces, the Type 71 is an ergonomic, lightweight pulse rifle chambered in 5.45x39mm. In accordance with doctrinal principles of overmatch and suppression, the rifle has a high rate of fire and a high-capacity casket magazine. Despite lackluster precision, an integrated recoil-dampening mechanism makes the rifle surprisingly controllable in bursts."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/upp.dmi'
	icon_state = "type71"
	item_state = "type71"

	fire_sound = 'sound/weapons/gun_type71.ogg'
	reload_sound = 'sound/weapons/handling/m41_reload.ogg'
	unload_sound = 'sound/weapons/handling/m41_unload.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/type71
	wield_delay = WIELD_DELAY_FAST
	attachable_allowed = list(
		/obj/item/attachable/flashlight, // Rail
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/suppressor, // Muzzle
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/heavy_barrel/upgraded,
		/obj/item/attachable/verticalgrip, // Underbarrel
		/obj/item/attachable/flashlight/grip,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/burstfire_assembly,
		/obj/item/attachable/attached_gun/flamer,
		/obj/item/attachable/attached_gun/flamer/advanced,
		/obj/item/attachable/attached_gun/extinguisher,
		)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	flags_equip_slot = SLOT_BACK
	start_automatic = TRUE

/obj/item/weapon/gun/rifle/type71/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 17,"rail_x" = 10, "rail_y" = 23, "under_x" = 20, "under_y" = 13, "stock_x" = 11, "stock_y" = 13)

/obj/item/weapon/gun/rifle/type71/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_8)
	set_burst_amount(BURST_AMOUNT_TIER_4)
	set_burst_delay(FIRE_DELAY_TIER_9)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT //10~ more damage than m41, as well as higher ap from bullet, slightly higher DPS, 133>137.5
	recoil_unwielded = RECOIL_AMOUNT_TIER_3

/obj/item/weapon/gun/rifle/type71/handle_starting_attachment()
	..()
	var/obj/item/attachable/stock/type71/STOCK = new(src)
	STOCK.flags_attach_features &= ~ATTACH_REMOVABLE
	STOCK.Attach(src)
	update_attachable(STOCK.slot)

/obj/item/weapon/gun/rifle/type71/rifleman
	//add GL
	random_spawn_chance = 100
	random_rail_chance = 70
	random_spawn_rail = list(
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
	)
	random_muzzle_chance = 100
	random_spawn_muzzle = list(
		/obj/item/attachable/bayonet/upp,
	)
	random_under_chance = 40
	random_spawn_under = list(
		/obj/item/attachable/verticalgrip,
	)

/obj/item/weapon/gun/rifle/type71/dual
	random_spawn_chance = 100
	random_rail_chance = 70
	random_spawn_rail = list(
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
	)
	random_muzzle_chance = 100
	random_spawn_muzzle = list(
		/obj/item/attachable/bayonet/upp,
	)
	random_under_chance = 40
	random_spawn_under = list(
		/obj/item/attachable/lasersight,
		/obj/item/attachable/verticalgrip,
	)

/obj/item/weapon/gun/rifle/type71/sapper
	current_mag = /obj/item/ammo_magazine/rifle/type71/ap
	random_spawn_chance = 100
	random_rail_chance = 80
	random_spawn_rail = list(
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/magnetic_harness,
	)
	random_muzzle_chance = 80
	random_spawn_muzzle = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet/upp,
	)
	random_under_chance = 90
	random_spawn_under = list(
		/obj/item/attachable/attached_gun/extinguisher,
	)

/obj/item/weapon/gun/rifle/type71/flamer
	name = "\improper Type 71-F pulse rifle"
	desc = " This appears to be a less common variant of the Type 71 with an integrated flamethrower that seems especially powerful."
	attachable_allowed = list(
		/obj/item/attachable/flashlight, // Rail
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/suppressor, // Muzzle
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/heavy_barrel/upgraded,
	)

/obj/item/weapon/gun/rifle/type71/flamer/handle_starting_attachment()
	..()
	var/obj/item/attachable/attached_gun/flamer/advanced/integrated/S = new(src)
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)

/obj/item/weapon/gun/rifle/type71/flamer/leader
	random_spawn_chance = 100
	random_rail_chance = 100
	random_spawn_rail = list(
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/scope/mini,
	)
	random_muzzle_chance = 100
	random_spawn_muzzle = list(
		/obj/item/attachable/bayonet/upp,
	)

/obj/item/weapon/gun/rifle/type71/carbine
	name = "\improper Type 71 pulse carbine"
	desc = "A carbine variant of the Type 71, easier to handle at the cost of lesser damage, but negative soldier reviews have shifted it out of active use, given only to reserves or troops not expected to face much combat."
	icon_state = "type71c"
	item_state = "type71c"
	aim_slowdown = SLOWDOWN_ADS_QUICK //Carbine is more lightweight
	wield_delay = WIELD_DELAY_VERY_FAST
	bonus_overlay_x = 2
	force = 20 //integrated melee mod from stock, which doesn't fit on the gun but is still clearly there on the sprite
	attachable_allowed = list(
		/obj/item/attachable/flashlight, // Rail
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/suppressor, // Muzzle
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/heavy_barrel/upgraded,
		/obj/item/attachable/verticalgrip, // Underbarrel
		/obj/item/attachable/burstfire_assembly,
		)

	random_spawn_muzzle = list() //no default bayonet

/obj/item/weapon/gun/rifle/type71/carbine/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 17,"rail_x" = 14, "rail_y" = 23, "under_x" = 25, "under_y" = 14, "stock_x" = 24, "stock_y" = 13)

/obj/item/weapon/gun/rifle/type71/carbine/handle_starting_attachment()
	return //integrated attachment code makes me want to blow my brains out

/obj/item/weapon/gun/rifle/type71/carbine/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_11)//same fire rate as m41
	damage_mult = BASE_BULLET_DAMAGE_MULT - BULLET_DAMAGE_MULT_TIER_4//same damage as m41 reg bullets probably
	scatter_unwielded = SCATTER_AMOUNT_TIER_5
	recoil_unwielded = RECOIL_AMOUNT_TIER_4

/obj/item/weapon/gun/rifle/type71/carbine/dual
	random_spawn_chance = 100
	random_rail_chance = 70
	random_spawn_rail = list(
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
	)
	random_muzzle_chance = 100
	random_spawn_muzzle = list(
		/obj/item/attachable/bayonet/upp,
	)
	random_under_chance = 40
	random_spawn_under = list(
		/obj/item/attachable/verticalgrip,
	)

/obj/item/weapon/gun/rifle/type71/carbine/commando
	name = "\improper Type 71 'Commando' pulse carbine"
	desc = "A much rarer variant of the Type 71, this version contains an integrated suppressor, integrated scope, and extensive fine-tuning. Many parts have been replaced, filed down, and improved upon. As a result, this variant is rarely seen outside of commando units."
	icon_state = "type73"
	item_state = "type73"

	fire_sound = "gun_silenced"
	wield_delay = 0 //Ends up being .5 seconds due to scope
	inherent_traits = list(TRAIT_GUN_SILENCED)
	current_mag = /obj/item/ammo_magazine/rifle/type71/ap
	attachable_allowed = list(
		/obj/item/attachable/verticalgrip,
	)
	random_spawn_chance = 0
	random_spawn_rail = list()
	random_spawn_muzzle = list()
	bonus_overlay_x = 1
	bonus_overlay_y = 0

/obj/item/weapon/gun/rifle/type71/carbine/commando/handle_starting_attachment()
	..()
	//suppressor
	var/obj/item/attachable/type73suppressor/suppressor = new(src)
	suppressor.flags_attach_features &= ~ATTACH_REMOVABLE
	suppressor.Attach(src)
	update_attachable(suppressor.slot)
	//scope
	var/obj/item/attachable/scope/mini/scope = new(src)
	scope.hidden = TRUE
	scope.flags_attach_features &= ~ATTACH_REMOVABLE
	scope.Attach(src)
	update_attachable(scope.slot)


/obj/item/weapon/gun/rifle/type71/carbine/commando/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 35, "muzzle_y" = 17,"rail_x" = 10, "rail_y" = 22, "under_x" = 23, "under_y" = 14, "stock_x" = 21, "stock_y" = 18)


/obj/item/weapon/gun/rifle/type71/carbine/commando/set_gun_config_values()
	..()
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_7
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	set_fire_delay(FIRE_DELAY_TIER_11)
	set_burst_delay(FIRE_DELAY_TIER_12)
	scatter = SCATTER_AMOUNT_TIER_8

	//-------------------------------------------------------

//M4RA Battle Rifle, standard USCM DMR

/obj/item/weapon/gun/rifle/m4ra
	name = "\improper M4RA battle rifle"
	desc = "The M4RA battle rifle is a designated marksman rifle in service with the USCM. Sporting a bullpup configuration, the M4RA battle rifle is perfect for reconnaissance and fire support teams.\nTakes *only* non-high-velocity M4RA magazines."
	icon_state = "m4ra"
	item_state = "m4ra"
	fire_sound = 'sound/weapons/gun_m4ra.ogg'
	reload_sound = 'sound/weapons/handling/l42_reload.ogg'
	unload_sound = 'sound/weapons/handling/l42_unload.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/m4ra
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/bayonet/co2,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/bipod,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/scope/mini_iff,
		/obj/item/attachable/flashlight/grip,
	)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	wield_delay = WIELD_DELAY_VERY_FAST
	aim_slowdown = SLOWDOWN_ADS_QUICK
	map_specific_decoration = TRUE

/obj/item/weapon/gun/rifle/m4ra/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 43, "muzzle_y" = 17,"rail_x" = 22, "rail_y" = 21, "under_x" = 30, "under_y" = 13, "stock_x" = 24, "stock_y" = 13, "special_x" = 37, "special_y" = 16)

/obj/item/weapon/gun/rifle/m4ra/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_9)
	set_burst_amount(0)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_5
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_8
	recoil_unwielded = RECOIL_AMOUNT_TIER_4
	damage_falloff_mult = 0
	scatter = SCATTER_AMOUNT_TIER_8

/obj/item/weapon/gun/rifle/m4ra/handle_starting_attachment()
	..()
	var/obj/item/attachable/m4ra_barrel/integrated = new(src)
	integrated.flags_attach_features &= ~ATTACH_REMOVABLE
	integrated.Attach(src)
	update_attachable(integrated.slot)

/obj/item/weapon/gun/rifle/m4ra/training
	current_mag = /obj/item/ammo_magazine/rifle/m4ra/rubber

//-------------------------------------------------------

//L42A Battle Rifle

/obj/item/weapon/gun/rifle/l42a
	name = "\improper L42A battle rifle"
	desc = "The L42A Battle Rifle, found commonly around the frontiers of the Galaxy. It's commonly used by colonists for self defense, as well as many colonial militias, whomever they serve due to it's rugged reliability and ease of use without much training. This rifle was put up for adoption by the USCM and tested for a time, but ultimately lost to the M4RA already in service."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "l42mk1"
	item_state = "l42mk1"
	reload_sound = 'sound/weapons/handling/l42_reload.ogg'
	unload_sound = 'sound/weapons/handling/l42_unload.ogg'
	fire_sound = 'sound/weapons/gun_carbine.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/l42a
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/bayonet/co2,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/stock/carbine,
		/obj/item/attachable/stock/carbine/wood,
		/obj/item/attachable/bipod,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/scope/mini_iff,
		/obj/item/attachable/flashlight/grip,
	)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	wield_delay = WIELD_DELAY_VERY_FAST
	aim_slowdown = SLOWDOWN_ADS_QUICK
	starting_attachment_types = list(/obj/item/attachable/stock/carbine)
	map_specific_decoration = TRUE

/obj/item/weapon/gun/rifle/l42a/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 19,"rail_x" = 12, "rail_y" = 20, "under_x" = 18, "under_y" = 15, "stock_x" = 22, "stock_y" = 10)

/obj/item/weapon/gun/rifle/l42a/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_9)
	set_burst_amount(0)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_5
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_6
	recoil_unwielded = RECOIL_AMOUNT_TIER_4
	damage_falloff_mult = 0
	scatter = SCATTER_AMOUNT_TIER_8

/obj/item/weapon/gun/rifle/l42a/training
	current_mag = /obj/item/ammo_magazine/rifle/l42a/rubber

//-------------------------------------------------------
//-------------------------------------------------------
//ABR-40 hunting rifle

// Civilian version of the L42A, used for hunting, and also by undersupplied paramilitary groups.

/obj/item/weapon/gun/rifle/l42a/abr40
	name = "\improper ABR-40 hunting rifle"
	desc = "The civilian version of the L42A battle rifle. Almost identical and even cross-compatible with L42 magazines, just don't take the stock off.."
	desc_lore = "The ABR-40 was created along-side the L42A as a hunting rifle for civilians. Sporting faux wooden furniture and a legally-mandated 12 round magazine, it's still highly accurate and deadly, a favored pick of experienced hunters and retired Marines. However, it's very limited in attachment selection, only being able to fit rail attachments, and the differences in design from the L42 force an awkward pose when attempting to hold it one-handed. Removing the stock is not recommended."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "abr40"
	item_state = "abr40"
	current_mag = /obj/item/ammo_magazine/rifle/l42a/abr40
	attachable_allowed = list(
		//Barrel,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/bayonet/co2,
		//Rail,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/scope/mini/hunting,
		//Stock,
		/obj/item/attachable/stock/carbine,
		/obj/item/attachable/stock/carbine/wood,
		/obj/item/attachable/stock/carbine/wood/tactical,
	)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER
	wield_delay = WIELD_DELAY_FAST
	starting_attachment_types = list(/obj/item/attachable/stock/carbine/wood, /obj/item/attachable/scope/mini/hunting)
	map_specific_decoration = FALSE
	civilian_usable_override = TRUE

// Identical to the L42 in stats, *except* for extra recoil and scatter that are nulled by keeping the stock on.
/obj/item/weapon/gun/rifle/l42a/abr40/set_gun_config_values()
	..()
	accuracy_mult = (BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_5) - HIT_ACCURACY_MULT_TIER_10
	recoil = RECOIL_AMOUNT_TIER_4
	scatter = (SCATTER_AMOUNT_TIER_8) + SCATTER_AMOUNT_TIER_5


/obj/item/weapon/gun/rifle/l42a/abr40/tactical
	desc = "The civilian version of the L42A battle rifle that is often wielded by Marines. Almost identical and even cross-compatible with L42 magazines, just don't take the stock off. This rifle seems to have unique tacticool blue-black furniture alongside some miscellaneous aftermarket modding."
	desc_lore = "The ABR-40 was created after the striking popularity of the L42 battle rifle as a hunting rifle for civilians, and naturally fell into the hands of many underfunded paramilitary groups and insurrections in turn, due to its smooth and simple handling and cross-compatibility with L42A magazines."
	icon_state = "abr40_tac"
	item_state = "abr40_tac"
	current_mag = /obj/item/ammo_magazine/rifle/l42a/ap
	attachable_allowed = list(
		//Barrel,
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/bayonet/co2,
		//Rail,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/scope/mini/hunting,
		//Under,
		/obj/item/attachable/flashlight/grip,
		//Stock,
		/obj/item/attachable/stock/carbine,
		/obj/item/attachable/stock/carbine/wood,
		/obj/item/attachable/stock/carbine/wood/tactical,
	)
	starting_attachment_types = list(/obj/item/attachable/stock/carbine/wood/tactical, /obj/item/attachable/suppressor)
	random_spawn_chance = 100
	random_spawn_rail = list(
		/obj/item/attachable/reflex,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini/hunting,
	)
	random_under_chance = 50
	random_spawn_under = list(/obj/item/attachable/flashlight/grip)

//=ROYAL MARINES=\\

/obj/item/weapon/gun/rifle/rmc_f90
	name = "\improper F903A1 Rifle"
	desc = "The standard issue rifle of the royal marines. Uniquely the royal marines are the only modern military to not use a pulse weapon. Uses 10x24mm caseless ammunition."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/twe_guns.dmi'
	icon_state = "aug"
	item_state = "aug"
	fire_sound = "gun_pulse"
	reload_sound = 'sound/weapons/handling/m41_reload.ogg'
	unload_sound = 'sound/weapons/handling/m41_unload.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/rmc_f90
	flags_equip_slot = NO_FLAGS
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/bayonet/co2,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/heavy_barrel/upgraded,
		/obj/item/attachable/magnetic_harness,
	)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	map_specific_decoration = FALSE
	aim_slowdown = SLOWDOWN_ADS_QUICK

/obj/item/weapon/gun/rifle/rmc_f90/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 16,"rail_x" = 15, "rail_y" = 21, "under_x" = 24, "under_y" = 13, "stock_x" = 24, "stock_y" = 13)


/obj/item/weapon/gun/rifle/rmc_f90/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_11
	burst_amount = BURST_AMOUNT_TIER_3
	burst_delay = FIRE_DELAY_TIER_11
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4 + 2*HIT_ACCURACY_MULT_TIER_1
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_2
	recoil_unwielded = RECOIL_AMOUNT_TIER_2

/obj/item/weapon/gun/rifle/rmc_f90/a_grip
	name = "\improper F903A2 Rifle"
	desc = "A non-standard issue rifle of the royal marines the F903A2 is currently being phased into the royal marines as their new mainline rifle but currently only sees use by unit leaders. Uniquely the royal marines are the only modern military to not use a pulse weapon. Uses 10x24mm caseless ammunition."
	icon_state = "aug_com"
	item_state = "aug_com"
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/extended_barrel,
	)

/obj/item/weapon/gun/rifle/rmc_f90/a_grip/handle_starting_attachment()
	..()
	var/obj/item/attachable/angledgrip/f90_agrip = new(src)
	f90_agrip.flags_attach_features &= ~ATTACH_REMOVABLE
	f90_agrip.hidden = TRUE
	f90_agrip.Attach(src)
	update_attachable(f90_agrip.slot)

/obj/item/weapon/gun/rifle/rmc_f90/scope
	name = "\improper F903A1 Marksman Rifle"
	desc = "A variation of the F903 rifle used by the royal marines commando. This weapon only accepts the smaller 20 round magazines of 10x24mm."
	icon_state = "aug_dmr"
	item_state = "aug_dmr"
	attachable_allowed = null
	current_mag = /obj/item/ammo_magazine/rifle/rmc_f90/marksman

/obj/item/weapon/gun/rifle/rmc_f90/scope/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_11
	burst_amount = 0
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4 + 2*HIT_ACCURACY_MULT_TIER_1
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_6
	recoil_unwielded = RECOIL_AMOUNT_TIER_2
	damage_falloff_mult = 0

/obj/item/weapon/gun/rifle/rmc_f90/scope/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/mini/f90/f90_scope = new(src)
	var/obj/item/attachable/angledgrip/f90_agrip = new(src)
	var/obj/item/attachable/f90_dmr_barrel/f90_dmr_barrel = new(src)
	f90_scope.flags_attach_features &= ~ATTACH_REMOVABLE
	f90_agrip.flags_attach_features &= ~ATTACH_REMOVABLE
	f90_dmr_barrel.flags_attach_features &= ~ATTACH_REMOVABLE
	f90_scope.hidden = TRUE
	f90_agrip.hidden = TRUE
	f90_dmr_barrel.hidden = FALSE
	f90_agrip.Attach(src)
	f90_scope.Attach(src)
	f90_dmr_barrel.Attach(src)
	update_attachable(f90_agrip.slot)
	update_attachable(f90_scope.slot)
	update_attachable(f90_dmr_barrel.slot)

/obj/item/weapon/gun/rifle/rmc_f90/shotgun
	name = "\improper F903A1/B 'Breacher' Rifle"
	desc = "A variation of the F903 rifle used by the royal marines commando. Modified to be used in one hand with a shield. Uses 10x24mm caseless ammunition."
	icon_state = "aug_mkey"
	item_state = "aug_mkey"
	attachable_allowed = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
	)

/obj/item/weapon/gun/rifle/rmc_f90/shotgun/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_11
	burst_amount = BURST_AMOUNT_TIER_3
	burst_delay = FIRE_DELAY_TIER_11
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4 + 2*HIT_ACCURACY_MULT_TIER_1
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_2
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_2
	recoil_unwielded = RECOIL_OFF

/obj/item/weapon/gun/rifle/rmc_f90/shotgun/handle_starting_attachment()
	..()
	var/obj/item/attachable/attached_gun/shotgun/f90_shotgun = new(src)
	var/obj/item/attachable/f90_dmr_barrel/f90_shotgun_barrel = new(src)
	f90_shotgun.flags_attach_features &= ~ATTACH_REMOVABLE
	f90_shotgun_barrel.flags_attach_features &= ~ATTACH_REMOVABLE
	f90_shotgun_barrel.hidden = FALSE
	f90_shotgun.hidden = TRUE
	f90_shotgun.Attach(src)
	f90_shotgun_barrel.Attach(src)
	update_attachable(f90_shotgun.slot)
	update_attachable(f90_shotgun_barrel.slot)

//-------------------------------------------------------
//XM51, Breaching Scattergun

/obj/item/weapon/gun/rifle/xm51
	name = "\improper XM51 breaching scattergun"
	desc = "An experimental shotgun model going through testing trials in the USCM. Based on the original civilian and CMB version, the XM51 is a mag-fed, pump-action shotgun. It utilizes special 16-gauge breaching rounds which are effective at breaching walls and doors. Users are advised not to employ the weapon against soft or armored targets due to low performance of the shells."
	icon_state = "xm51"
	item_state = "xm51"
	fire_sound = 'sound/weapons/gun_shotgun_xm51.ogg'
	reload_sound = 'sound/weapons/handling/l42_reload.ogg'
	unload_sound = 'sound/weapons/handling/l42_unload.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/xm51
	attachable_allowed = list(
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/bayonet/co2,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/gyro,
		/obj/item/attachable/flashlight/grip,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/stock/xm51,
	)
	flags_equip_slot = SLOT_BACK
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	gun_category = GUN_CATEGORY_SHOTGUN
	aim_slowdown = SLOWDOWN_ADS_SHOTGUN
	map_specific_decoration = TRUE

	var/pump_delay //How long we have to wait before we can pump the shotgun again.
	var/pump_sound = "shotgunpump"
	var/message_delay = 1 SECONDS //To stop message spam when trying to pump the gun constantly.
	var/burst_count = 0 //To detect when the burst fire is near its end.
	COOLDOWN_DECLARE(allow_message)
	COOLDOWN_DECLARE(allow_pump)

/obj/item/weapon/gun/rifle/xm51/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 34, "muzzle_y" = 18, "rail_x" = 12, "rail_y" = 20, "under_x" = 24, "under_y" = 13, "stock_x" = 15, "stock_y" = 16)

/obj/item/weapon/gun/rifle/xm51/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_4*2)
	set_burst_amount(0)
	burst_scatter_mult = SCATTER_AMOUNT_TIER_7
	accuracy_mult = BASE_ACCURACY_MULT + 2*HIT_ACCURACY_MULT_TIER_8
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_8
	recoil = RECOIL_AMOUNT_TIER_4
	recoil_unwielded = RECOIL_AMOUNT_TIER_2
	scatter = SCATTER_AMOUNT_TIER_6

/obj/item/weapon/gun/rifle/xm51/Initialize(mapload, spawn_empty)
	. = ..()
	pump_delay = FIRE_DELAY_TIER_8*3
	additional_fire_group_delay += pump_delay

/obj/item/weapon/gun/rifle/xm51/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY_ID("turfs", /datum/element/bullet_trait_damage_boost, 30, GLOB.damage_boost_turfs), //2550, 2 taps colony walls, 4 taps reinforced walls
		BULLET_TRAIT_ENTRY_ID("xeno turfs", /datum/element/bullet_trait_damage_boost, 0.23, GLOB.damage_boost_turfs_xeno), //2550*0.23 = 586, 2 taps resin walls, 3 taps thick resin
		BULLET_TRAIT_ENTRY_ID("breaching", /datum/element/bullet_trait_damage_boost, 15, GLOB.damage_boost_breaching), //1275, enough to 1 tap airlocks
		BULLET_TRAIT_ENTRY_ID("pylons", /datum/element/bullet_trait_damage_boost, 6, GLOB.damage_boost_pylons) //510, 4 shots to take out a pylon
	))

/obj/item/weapon/gun/rifle/xm51/unique_action(mob/user)
	if(!COOLDOWN_FINISHED(src, allow_pump))
		return
	if(in_chamber)
		if(COOLDOWN_FINISHED(src, allow_message))
			to_chat(usr, SPAN_WARNING("<i>[src] already has a shell in the chamber!<i>"))
			COOLDOWN_START(src, allow_message, message_delay)
		return

	playsound(user, pump_sound, 10, 1)
	COOLDOWN_START(src, allow_pump, pump_delay)
	ready_in_chamber()
	burst_count = 0 //Reset the count for burst mode.

/obj/item/weapon/gun/rifle/xm51/load_into_chamber(mob/user)
	return in_chamber

/obj/item/weapon/gun/rifle/xm51/reload_into_chamber(mob/user) //Don't chamber bullets after firing.
	if(!current_mag)
		update_icon()
		return

	in_chamber = null
	if(current_mag.current_rounds <= 0 && flags_gun_features & GUN_AUTO_EJECTOR)
		if (user.client?.prefs && (user.client?.prefs?.toggle_prefs & TOGGLE_AUTO_EJECT_MAGAZINE_OFF))
			update_icon()
		else if (!(flags_gun_features & GUN_BURST_FIRING) || !in_chamber) // Magazine will only unload once burstfire is over
			var/drop_to_ground = TRUE
			if (user.client?.prefs && (user.client?.prefs?.toggle_prefs & TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND))
				drop_to_ground = FALSE
				unwield(user)
				user.swap_hand()
			unload(user, TRUE, drop_to_ground) // We want to quickly autoeject the magazine. This proc does the rest based on magazine type. User can be passed as null.
			playsound(src, empty_sound, 25, 1)
	if(gun_firemode == GUN_FIREMODE_BURSTFIRE & burst_count < burst_amount - 1) //Fire two (or more) shots in a burst without having to pump.
		ready_in_chamber()
		burst_count++
		return in_chamber

/obj/item/weapon/gun/rifle/xm51/replace_magazine(mob/user, obj/item/ammo_magazine/magazine) //Don't chamber a round when reloading.
	user.drop_inv_item_to_loc(magazine, src) //Click!
	current_mag = magazine
	replace_ammo(user,magazine)
	user.visible_message(SPAN_NOTICE("[user] loads [magazine] into [src]!"),
		SPAN_NOTICE("You load [magazine] into [src]!"), null, 3, CHAT_TYPE_COMBAT_ACTION)
	if(reload_sound)
		playsound(user, reload_sound, 25, 1, 5)

/obj/item/weapon/gun/rifle/xm51/cock_gun(mob/user)
	return

/obj/item/weapon/gun/rifle/xm51/cock(mob/user) //Stops the "You cock the gun." message where nothing happens.
	return
