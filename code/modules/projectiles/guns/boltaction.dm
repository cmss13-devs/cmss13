// Bolt Action Rifle Code, credit to Alardun and Optimisticdude. This is for bolt action rifles which use external magazines, such as the AWM International, rather than internally fed rifles such as the Mosin-Nagant.
// For internally fed bolt actions, it'd be more advised to use pump shotgun code, or obj/item/weapon/gun/shotgun/pump, to create that type of variant of bolt action rifle.
/obj/item/weapon/gun/boltaction
	name = "Bolt-Action Rifle"
	desc = "It's a bolt action, simple really."
	reload_sound = 'sound/weapons/gun_rifle_reload.ogg'
	cocked_sound = 'sound/weapons/gun_cocked2.ogg'
	fire_sound = 'sound/weapons/gun_boltaction.ogg'
	var/open_bolt_sound ='sound/weapons/handling/gun_boltaction_open.ogg'
	var/close_bolt_sound ='sound/weapons/handling/gun_boltaction_close.ogg'
	icon_state = "boltaction"
	item_state = "hunting"

	flags_equip_slot = SLOT_BACK
	w_class = SIZE_LARGE
	force = 5
	flags_gun_features = GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_WIELDED_FIRING_ONLY
	gun_category = GUN_CATEGORY_RIFLE
	aim_slowdown = SLOWDOWN_ADS_MINISCOPE_DYNAMIC
	wield_delay = WIELD_DELAY_VERY_SLOW
	var/bolted = TRUE // FALSE IS OPEN, TRUE IS CLOSE
	var/bolt_delay
	var/recent_cycle //world.time to see when they last bolted it.
	current_mag = /obj/item/ammo_magazine/rifle/boltaction
	attachable_allowed = list(
						/obj/item/attachable/bayonet,
						/obj/item/attachable/bayonet/upp,
						/obj/item/attachable/stock/hunting,
						)
	starting_attachment_types = list(/obj/item/attachable/stock/hunting)

/obj/item/weapon/gun/boltaction/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 17,"rail_x" = 5, "rail_y" = 18, "under_x" = 25, "under_y" = 14, "stock_x" = 18, "stock_y" = 10)

/obj/item/weapon/gun/boltaction/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0) load_into_chamber()
	bolt_delay = FIRE_DELAY_TIER_5

/obj/item/weapon/gun/boltaction/update_icon() // needed for bolt action sprites
	..()

	var/new_icon_state = icon_state
	if(!bolted)
		new_icon_state += "_o"

	icon_state = new_icon_state

/obj/item/weapon/gun/boltaction/set_gun_config_values()
	..()
	burst_amount = 0
	fire_delay = FIRE_DELAY_TIER_7
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_4
	recoil_unwielded = RECOIL_AMOUNT_TIER_2

/obj/item/weapon/gun/boltaction/unique_action(mob/M)
	if(world.time < (recent_cycle + bolt_delay) )  //Don't spam it.
		to_chat(M, SPAN_DANGER("You can't cycle the bolt again right now."))
		return

	bolted = !bolted

	if(bolted)
		to_chat(M, SPAN_DANGER("You close the bolt of [src]!"))
		playsound(get_turf(src), open_bolt_sound, 15, TRUE, 1)
		ready_in_chamber()
		recent_cycle = world.time
	else
		to_chat(M, SPAN_DANGER("You open the bolt of [src]!"))
		playsound(get_turf(src), close_bolt_sound, 65, TRUE, 1)
		unload_chamber(M)

	update_icon()

/obj/item/weapon/gun/boltaction/able_to_fire(mob/user)
	. = ..()

	if(. && !bolted)
		to_chat(user, SPAN_WARNING("The bolt is still open, you can't fire [src]."))
		return FALSE

/obj/item/weapon/gun/boltaction/load_into_chamber(mob/user)
	return in_chamber

/obj/item/weapon/gun/boltaction/reload_into_chamber(mob/user)
	in_chamber = null
	return TRUE

/obj/item/weapon/gun/boltaction/cock(mob/user)
	return

/obj/item/weapon/gun/boltaction/replace_magazine(mob/user, obj/item/ammo_magazine/magazine) //mostly standard but without the cock-and-load if unchambered.
	user.drop_inv_item_to_loc(magazine, src) //Click!
	current_mag = magazine
	replace_ammo(user,magazine)
	user.visible_message(SPAN_NOTICE("[user] loads [magazine] into [src]!"),
		SPAN_NOTICE("You load [magazine] into [src]!"), null, 3, CHAT_TYPE_COMBAT_ACTION)
	if(reload_sound)
		playsound(user, reload_sound, 25, 1, 5)

/obj/item/weapon/gun/boltaction/colony
	name = "Model 12 Bolt-Action Rifle"
	desc = "Produced by Weyland-Yutani Colonial Supplies, the Model 12 is a bolt-action hunting rifle suited for dispatching xenofauna of medium to large size. Designed in the early 2120s for securing the frontiers of more exotic colony planets, the Model 12 has served all manner of colonists well since then. Chambered in 8mm W-Y."
	flags_gun_features = GUN_CAN_POINTBLANK|GUN_WIELDED_FIRING_ONLY
	current_mag = /obj/item/ammo_magazine/rifle/boltaction/colony

/obj/item/weapon/gun/boltaction/colony/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_8
