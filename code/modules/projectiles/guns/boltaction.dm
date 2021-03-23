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
        to_chat(M, SPAN_DANGER("You can't recycle the bolt again right now."))
        return
    if(!bolted)
        close_bolt(M)
        recent_cycle = world.time
    else
        open_bolt(M)

/obj/item/weapon/gun/boltaction/proc/close_bolt(mob/user)
    to_chat(user, SPAN_DANGER("You close the bolt of [src]!"))
    playsound(get_turf(src), open_bolt_sound, 15, TRUE, 1)
    load_into_chamber()
    bolted = TRUE
    update_icon()

/obj/item/weapon/gun/boltaction/proc/open_bolt(mob/user)
    to_chat(user, SPAN_DANGER("You open the bolt of [src]!"))
    playsound(get_turf(src), close_bolt_sound, 75, TRUE, 1)
    in_chamber = null
    bolted = FALSE
    update_icon()

/obj/item/weapon/gun/boltaction/able_to_fire(mob/user)
    . = ..()

    if(!.) return
    if(!bolted)
        to_chat(user, SPAN_WARNING("The bolt is still open, you can't fire [src]."))
        return FALSE

    return 

/obj/item/weapon/gun/boltaction/reload_into_chamber(mob/user)
    return TRUE // Literally do nothing.
