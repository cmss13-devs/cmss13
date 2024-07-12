/obj/item/weapon/gun/rifle/xm52
	name = "\improper XM52 experimental breaching scattergun"
	desc = "An experimental shotgun model going through testing trials in the USCM. Based on the original XM51 version, the XM52 is a mag-fed, burst pump-action shotgun. It utilizes special lighted 16-gauge breaching rounds which are effective at breaching walls and doors. Users are advised not to employ the weapon against soft or armored targets due to low performance of the shells."
	icon = 'core_ru/icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "xm52"
	item_state = "xm52"
	item_icons = list(
	WEAR_L_HAND = 'core_ru/icons/mob/humans/onmob/items_lefthand_1.dmi',
	WEAR_R_HAND = 'core_ru/icons/mob/humans/onmob/items_righthand_1.dmi'
	)
	fire_sound = 'sound/weapons/gun_shotgun_xm51.ogg'
	reload_sound = 'sound/weapons/handling/l42_reload.ogg'
	unload_sound = 'sound/weapons/handling/l42_unload.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/xm52
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
	)
	starting_attachment_types = list(/obj/item/attachable/stock/rifle/collapsible/xm52)
	flags_equip_slot = SLOT_BACK
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	gun_category = GUN_CATEGORY_SHOTGUN
	gun_firemode = GUN_FIREMODE_BURSTFIRE
	aim_slowdown = SLOWDOWN_ADS_SHOTGUN
	map_specific_decoration = FALSE

	var/pump_delay //How long we have to wait before we can pump the shotgun again.
	var/pump_sound = "shotgunpump"
	var/message_delay = 1 SECONDS //To stop message spam when trying to pump the gun constantly.
	var/burst_count = 0 //To detect when the burst fire is near its end.
	COOLDOWN_DECLARE(allow_message)
	COOLDOWN_DECLARE(allow_pump)

/obj/item/weapon/gun/rifle/xm52/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 34, "muzzle_y" = 18, "rail_x" = 12, "rail_y" = 20, "under_x" = 24, "under_y" = 13, "stock_x" = 15, "stock_y" = 16)

/obj/item/weapon/gun/rifle/xm52/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_4*3)
	set_burst_amount(4)
	burst_scatter_mult = SCATTER_AMOUNT_TIER_7
	accuracy_mult = BASE_ACCURACY_MULT + 2*HIT_ACCURACY_MULT_TIER_8
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_8
	recoil = RECOIL_AMOUNT_TIER_4
	recoil_unwielded = RECOIL_AMOUNT_TIER_2
	scatter = SCATTER_AMOUNT_TIER_6

/obj/item/weapon/gun/rifle/xm52/Initialize(mapload, spawn_empty)
	. = ..()
	if(gun_firemode == GUN_FIREMODE_BURSTFIRE)
		pump_delay = FIRE_DELAY_TIER_8*3
	else
		pump_delay = FIRE_DELAY_TIER_8*1
	additional_fire_group_delay += pump_delay

/obj/item/weapon/gun/rifle/xm52/able_to_fire(mob/living/user)
	. = ..()
	if (. && istype(user)) //Let's check all that other stuff first.
		if(!skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL) && user.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_ST)
			to_chat(user, SPAN_WARNING("You don't seem to know how to use \the [src]..."))
			return FALSE

/obj/item/weapon/gun/rifle/xm52/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY_ID("turfs", /datum/element/bullet_trait_damage_boost, 30, GLOB.damage_boost_turfs), //2550, 2 taps colony walls, 4 taps reinforced walls
		BULLET_TRAIT_ENTRY_ID("xeno turfs", /datum/element/bullet_trait_damage_boost, 0.23, GLOB.damage_boost_turfs_xeno), //2550*0.23 = 586, 2 taps resin walls, 3 taps thick resin
		BULLET_TRAIT_ENTRY_ID("breaching", /datum/element/bullet_trait_damage_boost, 15, GLOB.damage_boost_breaching), //1275, enough to 1 tap airlocks
		BULLET_TRAIT_ENTRY_ID("pylons", /datum/element/bullet_trait_damage_boost, 6, GLOB.damage_boost_pylons) //510, 4 shots to take out a pylon
	))

/obj/item/weapon/gun/rifle/xm52/unique_action(mob/user)
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

/obj/item/weapon/gun/rifle/xm52/load_into_chamber(mob/user)
	return in_chamber

/obj/item/weapon/gun/rifle/xm52/reload_into_chamber(mob/user) //Don't chamber bullets after firing.
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

/obj/item/weapon/gun/rifle/xm52/replace_magazine(mob/user, obj/item/ammo_magazine/magazine) //Don't chamber a round when reloading.
	user.drop_inv_item_to_loc(magazine, src) //Click!
	current_mag = magazine
	replace_ammo(user,magazine)
	user.visible_message(SPAN_NOTICE("[user] loads [magazine] into [src]!"),
		SPAN_NOTICE("You load [magazine] into [src]!"), null, 3, CHAT_TYPE_COMBAT_ACTION)
	if(reload_sound)
		playsound(user, reload_sound, 25, 1, 5)

/obj/item/weapon/gun/rifle/xm52/cock_gun(mob/user)
	return

/obj/item/weapon/gun/rifle/xm52/cock(mob/user) //Stops the "You cock the gun." message where nothing happens.
	return
