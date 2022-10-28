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
	fire_delay = FIRE_DELAY_TIER_5
	burst_amount = BURST_AMOUNT_TIER_3
	burst_delay = FIRE_DELAY_TIER_9
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
						/obj/item/attachable/bayonet/c02,
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
						/obj/item/attachable/magnetic_harness,
						/obj/item/attachable/stock/rifle,
						/obj/item/attachable/stock/rifle/collapsible,
						/obj/item/attachable/attached_gun/grenade,
						/obj/item/attachable/attached_gun/flamer,
						/obj/item/attachable/attached_gun/shotgun,
						/obj/item/attachable/attached_gun/extinguisher,
						/obj/item/attachable/scope,
						/obj/item/attachable/scope/mini
						)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	starting_attachment_types = list(/obj/item/attachable/attached_gun/grenade, /obj/item/attachable/stock/rifle/collapsible)
	map_specific_decoration = TRUE

/obj/item/weapon/gun/rifle/m41a/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 23, "under_x" = 24, "under_y" = 13, "stock_x" = 24, "stock_y" = 13)


/obj/item/weapon/gun/rifle/m41a/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_9
	burst_amount = BURST_AMOUNT_TIER_3
	burst_delay = FIRE_DELAY_TIER_9
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
						/obj/item/attachable/attached_gun/grenade,
						/obj/item/attachable/scope/mini/nsg23)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_BURST_ON|GUN_BURST_ONLY|GUN_WY_RESTRICTED
	starting_attachment_types = list(/obj/item/attachable/scope/mini/nsg23,
								/obj/item/attachable/attached_gun/flamer)

/obj/item/weapon/gun/rifle/nsg23/Initialize(mapload, spawn_empty)
	. = ..()
	update_icon()

/obj/item/weapon/gun/rifle/nsg23/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 16,"rail_x" = 13, "rail_y" = 22, "under_x" = 21, "under_y" = 10, "stock_x" = 5, "stock_y" = 17)

/obj/item/weapon/gun/rifle/nsg23/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_7
	burst_amount = BURST_AMOUNT_TIER_3
	burst_delay = FIRE_DELAY_TIER_8
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_9
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_8
	recoil_unwielded = RECOIL_AMOUNT_TIER_2
	damage_falloff_mult = 0

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
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_BURST_ON|GUN_BURST_ONLY

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
	starting_attachment_types = list()

	random_spawn_chance = 100
	random_spawn_rail = list(
							/obj/item/attachable/reddot,
							/obj/item/attachable/reflex,
							/obj/item/attachable/flashlight,
							/obj/item/attachable/magnetic_harness,
							)
	random_spawn_under = list(
							/obj/item/attachable/lasersight,
							)


/obj/item/weapon/gun/rifle/m41a/elite/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_9
	burst_amount = BURST_AMOUNT_TIER_2
	burst_delay = FIRE_DELAY_TIER_10
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	scatter = SCATTER_AMOUNT_TIER_10
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_5

//-------------------------------------------------------
//M40-SD AKA MARSOC RIFLE FROM HELL (It's actually an M41A, don't tell!)

/obj/item/weapon/gun/rifle/m41a/elite/m40_sd
	name = "\improper M40-SD pulse rifle"
	desc = "One of the experimental predecessors to the M41A line that never saw widespread adoption beyond elite marine units. Of the rifles in the USCM inventory that are still in production, this is the only one to feature an integrated suppressor. It can accept M41A MK2 magazines, but also features its own proprietary magazine system. Extremely lethal in burstfire mode."
	icon_state = "m40sd"
	item_state = "m40sd"
	reload_sound = 'sound/weapons/handling/m40sd_reload.ogg'
	unload_sound = 'sound/weapons/handling/m40sd_unload.ogg'
	unacidable = TRUE
	indestructible = TRUE

	current_mag = /obj/item/ammo_magazine/rifle/m40_sd
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_BURST_ON
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
		/obj/item/ammo_magazine/rifle/m40_sd
	)
	attachable_allowed = list(
						/obj/item/attachable/suppressor/m40_integral,//no rail attachies
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
						/obj/item/attachable/attached_gun/shotgun,
						/obj/item/attachable/attached_gun/extinguisher,
						)

	random_spawn_chance = 0

/obj/item/weapon/gun/rifle/m41a/elite/m40_sd/handle_starting_attachment()
	..()
	var/obj/item/attachable/suppressor/m40_integral/S = new(src)
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.hidden = FALSE
	S.Attach(src)
	update_attachable(S.slot)

	var/obj/item/attachable/magnetic_harness/H = new(src)//integrated mag harness, no rail attachies
	H.flags_attach_features &= ~ATTACH_REMOVABLE
	H.hidden = TRUE
	H.Attach(src)
	update_attachable(H.slot)

/obj/item/weapon/gun/rifle/m41a/elite/m40_sd/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 17,"rail_x" = 12, "rail_y" = 23, "under_x" = 24, "under_y" = 13, "stock_x" = 24, "stock_y" = 13)

/obj/item/weapon/gun/rifle/m41a/elite/m40_sd/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_9
	burst_amount = BURST_AMOUNT_TIER_3
	burst_delay = FIRE_DELAY_TIER_10
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	scatter = SCATTER_AMOUNT_TIER_10
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_4

//-------------------------------------------------------
//M41A TRUE AND ORIGINAL

/obj/item/weapon/gun/rifle/m41aMK1
	name = "\improper M41A pulse rifle"
	desc = "An older design of the Pulse Rifle commonly used by Colonial Marines. Uses 10x24mm caseless ammunition."
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
						/obj/item/attachable/attached_gun/shotgun)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	starting_attachment_types = list(/obj/item/attachable/attached_gun/grenade/mk1, /obj/item/attachable/stock/rifle/collapsible)

/obj/item/weapon/gun/rifle/m41aMK1/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 23, "under_x" = 23, "under_y" = 13, "stock_x" = 24, "stock_y" = 14)


/obj/item/weapon/gun/rifle/m41aMK1/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_9
	burst_amount = BURST_AMOUNT_TIER_4
	burst_delay = FIRE_DELAY_TIER_9
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
//----------------------------------------------
//Special gun for the CO to replace the smartgun

/obj/item/weapon/gun/rifle/m46c
	name = "\improper M46C pulse rifle"
	desc = "A prototype M46C, an experimental rifle platform built to outperform the standard M41A. Back issue only. Uses standard MK1 & MK2 rifle magazines."
	icon_state = "m46c"
	item_state = "m46c"
	fire_sound = "gun_pulse"
	reload_sound = 'sound/weapons/handling/m41_reload.ogg'
	unload_sound = 'sound/weapons/handling/m41_unload.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/incendiary
	var/iff_enabled = TRUE
	accepted_ammo = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/rifle/extended,
		/obj/item/ammo_magazine/rifle/ap,
		/obj/item/ammo_magazine/rifle/incendiary,
		/obj/item/ammo_magazine/rifle/toxin,
		/obj/item/ammo_magazine/rifle/penetrating,
		/obj/item/ammo_magazine/rifle/m41aMK1,
		/obj/item/ammo_magazine/rifle/m41aMK1/ap,
		/obj/item/ammo_magazine/rifle/m41aMK1/incendiary,
		/obj/item/ammo_magazine/rifle/m41aMK1/cluster,
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
						/obj/item/attachable/scope/mini,
						/obj/item/attachable/verticalgrip,
						/obj/item/attachable/angledgrip,
						/obj/item/attachable/flashlight/grip,
						/obj/item/attachable/stock/rifle/collapsible,
						/obj/item/attachable/attached_gun/grenade,
						/obj/item/attachable/attached_gun/flamer,
						/obj/item/attachable/attached_gun/extinguisher,
						/obj/item/attachable/attached_gun/shotgun)
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

/obj/item/weapon/gun/rifle/m46c/Initialize(mapload, ...)
	. = ..()
	if(iff_enabled)
		LAZYADD(traits_to_give, list(
			BULLET_TRAIT_ENTRY_ID("iff", /datum/element/bullet_trait_iff)
		))

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
	fire_delay = FIRE_DELAY_TIER_8
	burst_amount = BURST_AMOUNT_TIER_4
	burst_delay = FIRE_DELAY_TIER_10
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_8
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_3
	recoil_unwielded = RECOIL_AMOUNT_TIER_2

/obj/item/weapon/gun/rifle/m46c/able_to_fire(mob/user)
	. = ..()
	if(is_locked && linked_human && linked_human != user)
		if(linked_human.is_revivable() || linked_human.stat != DEAD)
			to_chat(user, SPAN_WARNING("[icon2html(src)] Trigger locked by [src]. Unauthorized user."))
			playsound(loc,'sound/weapons/gun_empty.ogg', 25, 1)
			return FALSE

		linked_human = null
		is_locked = FALSE
		UnregisterSignal(linked_human, COMSIG_PARENT_QDELETING)

/obj/item/weapon/gun/rifle/m46c/pickup(user)
	if(!linked_human)
		src.name_after_co(user, src)
		to_chat(usr, SPAN_NOTICE("[icon2html(src)] You pick up \the [src], registering yourself as its owner."))
	..()

/obj/item/weapon/gun/rifle/m46c/verb/toggle_lock()
	set category = "Weapons"
	set name = "Toggle Lock"
	set src in usr

	if(usr != linked_human)
		to_chat(usr, SPAN_WARNING("[icon2html(src)] Action denied by [src]. Unauthorized user."))
		return

	is_locked = !is_locked
	to_chat(usr, SPAN_NOTICE("[icon2html(src)] You [is_locked? "lock": "unlock"] [src]."))
	playsound(loc,'sound/machines/click.ogg', 25, 1)


/obj/item/weapon/gun/rifle/m46c/verb/toggle_iff()
	set category = "Weapons"
	set name = "Toggle Lethal Mode"
	set src in usr

	if(is_locked && linked_human && usr != linked_human)
		to_chat(usr, SPAN_WARNING("[icon2html(src)] Action denied by [src]. Unauthorized user."))
		return

	iff_enabled = !iff_enabled
	to_chat(usr, SPAN_NOTICE("[icon2html(src)] You [iff_enabled? "enable": "disable"] the IFF on [src]."))
	playsound(loc,'sound/machines/click.ogg', 25, 1)

	recalculate_attachment_bonuses()
	if(iff_enabled)
		add_bullet_trait(BULLET_TRAIT_ENTRY_ID("iff", /datum/element/bullet_trait_iff))
	else
		remove_bullet_trait("iff")

/obj/item/weapon/gun/rifle/m46c/recalculate_attachment_bonuses()
	. = ..()
	if(iff_enabled)
		fire_delay += FIRE_DELAY_TIER_10
		burst_amount -=  BURST_AMOUNT_TIER_6

		flags_gun_features &= ~GUN_BURST_ON //Gun loses some combat ability in return for IFF, as well as burst fire mode


/obj/item/weapon/gun/rifle/m46c/proc/name_after_co(var/mob/living/carbon/human/H, var/obj/item/weapon/gun/rifle/m46c/I)
	linked_human = H
	RegisterSignal(linked_human, COMSIG_PARENT_QDELETING, .proc/remove_idlock)

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
						/obj/item/attachable/attached_gun/extinguisher,
						/obj/item/attachable/attached_gun/shotgun,
						/obj/item/attachable/scope/slavic
						)
	random_spawn_chance = 38
	random_spawn_rail = list(
							/obj/item/attachable/reddot,
							/obj/item/attachable/reflex/,
							/obj/item/attachable/scope/slavic,
							/obj/item/attachable/magnetic_harness
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



/obj/item/weapon/gun/rifle/mar40/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 28, "muzzle_y" = 17,"rail_x" = 16, "rail_y" = 20, "under_x" = 24, "under_y" = 15, "stock_x" = 24, "stock_y" = 13)


/obj/item/weapon/gun/rifle/mar40/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_7
	burst_amount = BURST_AMOUNT_TIER_4
	burst_delay = FIRE_DELAY_TIER_9
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
					/obj/item/attachable/magnetic_harness,
					/obj/item/attachable/attached_gun/grenade,
					/obj/item/attachable/attached_gun/flamer,
					/obj/item/attachable/attached_gun/extinguisher,
					/obj/item/attachable/attached_gun/shotgun,
					/obj/item/attachable/scope,
					/obj/item/attachable/scope/mini
					)
	random_spawn_chance = 35
	random_spawn_rail = list(
							/obj/item/attachable/reddot,
							/obj/item/attachable/reflex/,
							/obj/item/attachable/scope/mini,
							/obj/item/attachable/magnetic_harness
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
							/obj/item/attachable/extended_barrel
								)

/obj/item/weapon/gun/rifle/mar40/carbine/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_8
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
						/obj/item/attachable/scope/slavic
						)
	random_spawn_chance = 38
	random_spawn_rail = list(
							/obj/item/attachable/reddot,
							/obj/item/attachable/reflex,
							/obj/item/attachable/scope/slavic,
							/obj/item/attachable/magnetic_harness
							)

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_WIELDED_FIRING_ONLY

/obj/item/weapon/gun/rifle/mar40/lmg/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 16,"rail_x" = 16, "rail_y" = 20, "under_x" = 26, "under_y" = 16, "stock_x" = 24, "stock_y" = 13)

/obj/item/weapon/gun/rifle/mar40/lmg/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_8
	burst_amount = BURST_AMOUNT_TIER_5
	burst_delay = FIRE_DELAY_TIER_9
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
						/obj/item/attachable/attached_gun/extinguisher,
						/obj/item/attachable/attached_gun/shotgun,
						/obj/item/attachable/lasersight,
						/obj/item/attachable/stock/m16
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
							/obj/item/attachable/lasersight
									)
	random_spawn_muzzle = list(
							/obj/item/attachable/suppressor,
							/obj/item/attachable/bayonet,
							/obj/item/attachable/compensator,
							/obj/item/attachable/extended_barrel
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
	fire_delay = FIRE_DELAY_TIER_9
	burst_amount = BURST_AMOUNT_TIER_3
	burst_delay = FIRE_DELAY_TIER_9
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_7
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_10
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_6
	recoil_unwielded = RECOIL_AMOUNT_TIER_2

//-------------------------------------------------------
//AR10 rifle
//basically an early M16

/obj/item/weapon/gun/rifle/ar10
	name = "\improper AR10 rifle"
	desc = "An earlier version of the more widespread M16 rifle. Considered to be the father of the 20th century rifle. How one of these ended up here is a mystery of its own. It is chambered in 7.62x51mm."
	desc_lore = "The AR10 was initially manufactured by the Armalite corporation (bought by Weyland-Yutani in 2002) in the 1950s. It was the first production rifle to incorporate many new and innovative features, such as a gas operated bolt and carrier system. Only 10,000 were ever produced, and the only national entities to use them were Portugal and Sudan. Since the end of the 20th century, these rifles - alongside the far more common M16 and AR15 - have floated around the less civillised areas of space, littering jungles and colony floors with their uncommon cased ammunition - a rarity since the introduction of pulse munitions. This rifle has the word \"Salazar\" engraved on its side."
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
						/obj/item/attachable/stock/ar10
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
							/obj/item/attachable/bipod
									)
	random_spawn_muzzle = list(
							/obj/item/attachable/suppressor,
							/obj/item/attachable/bayonet,
							/obj/item/attachable/compensator,
							/obj/item/attachable/extended_barrel
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
	fire_delay = FIRE_DELAY_TIER_7
	burst_amount = BURST_AMOUNT_TIER_3
	burst_delay = FIRE_DELAY_TIER_7
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
	name = "\improper Dutch's M16A2"
	desc = "A modified M16 employed by Dutch's Dozen mercenaries. It has 'CLOAKER KILLER' printed on a label on the side. Chambered in 5.56x45mm."
	icon_state = "m16"
	item_state = "m16"
	fire_sound = 'sound/weapons/gun_m16.ogg'
	reload_sound = 'sound/weapons/handling/gun_m16_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_m16_unload.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/m16/ap
	attachable_allowed = list(
						/obj/item/attachable/suppressor,
						/obj/item/attachable/bayonet,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
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
						/obj/item/attachable/attached_gun/extinguisher,
						/obj/item/attachable/attached_gun/shotgun
						)

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_ANTIQUE

/obj/item/weapon/gun/rifle/m16/dutch/set_gun_config_values()
	..()
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_7


//-------------------------------------------------------
//M41AE2 HEAVY PULSE RIFLE

/obj/item/weapon/gun/rifle/lmg
	name = "\improper M41AE2 heavy pulse rifle"
	desc = "A large squad support weapon capable of laying down sustained suppressing fire from a mounted position. While unstable and less accurate, it can be lugged and shot with two hands. Like it's smaller brothers, the M41A MK2 and L42 MK1, the M41AE2 is chambered in 10mm."
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
						/obj/item/attachable/compensator,
						/obj/item/attachable/burstfire_assembly,
						/obj/item/attachable/magnetic_harness)

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_WIELDED_FIRING_ONLY
	gun_category = GUN_CATEGORY_HEAVY

/obj/item/weapon/gun/rifle/lmg/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 19,"rail_x" = 10, "rail_y" = 23, "under_x" = 23, "under_y" = 12, "stock_x" = 24, "stock_y" = 12)


/obj/item/weapon/gun/rifle/lmg/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_LMG
	burst_amount = BURST_AMOUNT_TIER_5
	burst_delay = FIRE_DELAY_TIER_LMG
	fa_delay = FIRE_DELAY_TIER_9
	fa_scatter_peak = FULL_AUTO_SCATTER_PEAK_TIER_3
	fa_max_scatter = SCATTER_AMOUNT_TIER_4
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_6
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
	icon_state = "type71"
	item_state = "type71"

	fire_sound = 'sound/weapons/gun_type71.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/type71
	wield_delay = WIELD_DELAY_FAST
	attachable_allowed = list(
						//Rail
						/obj/item/attachable/flashlight,
						/obj/item/attachable/magnetic_harness,
						/obj/item/attachable/scope,
						/obj/item/attachable/scope/mini,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						//Muzzle
						/obj/item/attachable/suppressor,
						/obj/item/attachable/bayonet,
						/obj/item/attachable/bayonet/upp,
						/obj/item/attachable/extended_barrel,
						/obj/item/attachable/heavy_barrel,
						//Underbarrel
						/obj/item/attachable/verticalgrip,
						/obj/item/attachable/angledgrip,
						/obj/item/attachable/flashlight/grip,
						/obj/item/attachable/lasersight,
						/obj/item/attachable/bipod,
						/obj/item/attachable/burstfire_assembly,
						/obj/item/attachable/attached_gun/flamer,
						/obj/item/attachable/attached_gun/extinguisher
						)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	flags_equip_slot = SLOT_BACK

/obj/item/weapon/gun/rifle/type71/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 18, "rail_y" = 23, "under_x" = 20, "under_y" = 13, "stock_x" = 24, "stock_y" = 13)

/obj/item/weapon/gun/rifle/type71/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_9
	burst_amount = BURST_AMOUNT_TIER_4
	burst_delay = FIRE_DELAY_TIER_8
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_3

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
							/obj/item/attachable/bayonet/upp
							)
	random_under_chance = 40
	random_spawn_under = list(
							/obj/item/attachable/lasersight,
							/obj/item/attachable/verticalgrip,
							/obj/item/attachable/angledgrip
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
							/obj/item/attachable/bayonet/upp
							)
	random_under_chance = 40
	random_spawn_under = list(
							/obj/item/attachable/lasersight,
							/obj/item/attachable/verticalgrip,
							/obj/item/attachable/angledgrip
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
							/obj/item/attachable/bayonet/upp
							)
	random_under_chance = 90
	random_spawn_under = list(
							/obj/item/attachable/lasersight,
							/obj/item/attachable/attached_gun/extinguisher
							)

/obj/item/weapon/gun/rifle/type71/flamer
	name = "\improper Type 71-F pulse rifle"
	desc = " This appears to be a less common variant of the Type 71 with an integrated flamethrower that seems especially powerful."
	attachable_allowed = list(
						/obj/item/attachable/suppressor,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/extended_barrel,
						)

/obj/item/weapon/gun/rifle/type71/flamer/handle_starting_attachment()
	..()
	var/obj/item/attachable/attached_gun/flamer/integrated/S = new(src)
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
							/obj/item/attachable/bayonet/upp
							)

/obj/item/weapon/gun/rifle/type71/carbine
	name = "\improper Type 71 pulse carbine"
	desc = "A carbine variant of the Type 71, easier to handle at the cost of lesser damage, but negative soldier reviews have shifted it out of active use, given only to reserves or troops not expected to face much combat."
	icon_state = "type71c"
	item_state = "type71c"
	aim_slowdown = SLOWDOWN_ADS_QUICK //Carbine is more lightweight
	wield_delay = WIELD_DELAY_VERY_FAST
	bonus_overlay_x = 2

	random_spawn_muzzle = list() //no default bayonet

/obj/item/weapon/gun/rifle/type71/carbine/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 30, "muzzle_y" = 18,"rail_x" = 19, "rail_y" = 22, "under_x" = 21, "under_y" = 14, "stock_x" = 24, "stock_y" = 13)

/obj/item/weapon/gun/rifle/type71/carbine/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_9
	damage_mult = BASE_BULLET_DAMAGE_MULT - BULLET_DAMAGE_MULT_TIER_2
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
							/obj/item/attachable/bayonet/upp
							)
	random_under_chance = 40
	random_spawn_under = list(
							/obj/item/attachable/lasersight,
							/obj/item/attachable/verticalgrip,
							/obj/item/attachable/angledgrip
							)

/obj/item/weapon/gun/rifle/type71/carbine/commando
	name = "\improper Type 71 'Commando' pulse carbine"
	desc = "A much rarer variant of the Type 71, this version contains an integrated suppressor, integrated scope, and extensive fine-tuning. Many parts have been replaced, filed down, and improved upon. As a result, this variant is rarely seen outside of commando units."
	icon_state = "type73"
	item_state = "type73"
	wield_delay = 0 //Ends up being .5 seconds due to scope
	current_mag = /obj/item/ammo_magazine/rifle/type71/ap
	attachable_allowed = list(
						/obj/item/attachable/lasersight,
						/obj/item/attachable/verticalgrip,
						/obj/item/attachable/angledgrip,
						)
	random_spawn_chance = 0
	random_spawn_rail = list()
	random_spawn_muzzle = list()
	bonus_overlay_x = 1
	bonus_overlay_y = 0

/obj/item/weapon/gun/rifle/type71/carbine/commando/handle_starting_attachment()//Making the gun have an invisible silencer since it's supposed to have one.
	..()
	//suppressor
	var/obj/item/attachable/suppressor/S = new(src)
	S.hidden = TRUE
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)
	//scope
	var/obj/item/attachable/scope/mini/F = new(src)
	F.hidden = TRUE
	F.flags_attach_features &= ~ATTACH_REMOVABLE
	F.Attach(src)
	update_attachable(F.slot)


/obj/item/weapon/gun/rifle/type71/carbine/commando/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 30, "muzzle_y" = 19,"rail_x" = 10, "rail_y" = 22, "under_x" = 21, "under_y" = 18, "stock_x" = 21, "stock_y" = 18)


/obj/item/weapon/gun/rifle/type71/carbine/commando/set_gun_config_values()
	..()
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_7
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	fire_delay = FIRE_DELAY_TIER_9
	burst_delay = FIRE_DELAY_TIER_10
	scatter = SCATTER_AMOUNT_TIER_8

//-------------------------------------------------------

//L42A Battle Rifle

/obj/item/weapon/gun/rifle/l42a
	name = "\improper L42A battle rifle"
	desc = "A L42A battle rifle. A non-standard alternative to the standard issue M41A-MK2 available to the jarheads of the USCM. Renowned for its high accuracy and superior stopping power compared to other pulse rifles. Chambered in 10x24mm caseless."
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
						/obj/item/attachable/bayonet/c02,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/extended_barrel,
						/obj/item/attachable/magnetic_harness,
						/obj/item/attachable/stock/carbine,
						/obj/item/attachable/bipod,
						/obj/item/attachable/lasersight,
						/obj/item/attachable/scope,
						/obj/item/attachable/scope/mini,
						/obj/item/attachable/scope/mini_iff,
						/obj/item/attachable/flashlight/grip
						)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	wield_delay = WIELD_DELAY_VERY_FAST
	aim_slowdown = SLOWDOWN_ADS_QUICK
	starting_attachment_types = list(/obj/item/attachable/stock/carbine)
	map_specific_decoration = TRUE

/obj/item/weapon/gun/rifle/l42a/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 19,"rail_x" = 6, "rail_y" = 20, "under_x" = 18, "under_y" = 16, "stock_x" = 22, "stock_y" = 10)


/obj/item/weapon/gun/rifle/l42a/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_8
	burst_amount = 0
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
//Basira-Armstrong rifle (Used by the CLF)

/obj/item/weapon/gun/rifle/hunting
	name = "\improper Basira-Armstrong rifle"
	desc = "Named after its eccentric designers, the Basira-Armstrong is a civilian semi-automatic rifle frequently found in the outer colonies. Despite its legally-mandated limited magazine capacity, its light weight and legendary accuracy makes it popular among hunters and competitive shooters."
	icon_state = "hunting"
	item_state = "hunting"
	reload_sound = 'sound/weapons/handling/l42_reload.ogg'
	unload_sound = 'sound/weapons/handling/l42_unload.ogg'
	fire_sound = 'sound/weapons/gun_carbine.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/hunting
	attachable_allowed = list(
						/obj/item/attachable/suppressor,
						/obj/item/attachable/bayonet,
						/obj/item/attachable/bayonet/upp,
						/obj/item/attachable/reddot,
						/obj/item/attachable/reflex,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/extended_barrel,
						/obj/item/attachable/magnetic_harness,
						/obj/item/attachable/lasersight,
						/obj/item/attachable/scope,
						/obj/item/attachable/scope/mini,
						/obj/item/attachable/scope/mini_iff,
						/obj/item/attachable/scope/mini/hunting,
						/obj/item/attachable/stock/hunting,
						)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	wield_delay = WIELD_DELAY_VERY_FAST
	aim_slowdown = SLOWDOWN_ADS_QUICK
	starting_attachment_types = list(/obj/item/attachable/scope/mini/hunting,/obj/item/attachable/stock/hunting)

/obj/item/weapon/gun/rifle/hunting/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 17,"rail_x" = 5, "rail_y" = 18, "under_x" = 25, "under_y" = 14, "stock_x" = 18, "stock_y" = 10)

/obj/item/weapon/gun/rifle/hunting/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_7
	burst_amount = 0
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	scatter = SCATTER_AMOUNT_TIER_10
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_6
	recoil_unwielded = RECOIL_AMOUNT_TIER_4
	damage_falloff_mult = 0
