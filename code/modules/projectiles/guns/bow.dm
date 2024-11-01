/obj/item/weapon/gun/bow
	name = "\improper hunting bow"
	desc = "here be dragons"
	icon = 'icons/obj/items/weapons/guns/pred_bow.dmi'
	icon_state = "bow"
	item_state = "bow"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/hunter/items_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/hunter/items_righthand.dmi'
		)
	current_mag = /obj/item/ammo_magazine/internal/bow
	reload_sound = 'sound/weapons/gun_shotgun_shell_insert.ogg'
	fire_sound = 'sound/effects/throwing/swoosh1.ogg'
	aim_slowdown = 0
	flags_equip_slot = SLOT_WAIST
	flags_gun_features = GUN_INTERNAL_MAG|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED
	gun_category = GUN_CATEGORY_HEAVY
	muzzle_flash = null

/obj/item/weapon/gun/flare/Initialize(mapload, spawn_empty)
	. = ..()
	if(spawn_empty)
		update_icon()

/obj/item/weapon/gun/bow/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_12)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_10
	scatter = 0
	recoil = RECOIL_AMOUNT_TIER_4
	recoil_unwielded = RECOIL_AMOUNT_TIER_4

/obj/item/weapon/gun/bow/unload(mob/user)
	if(!current_mag)
		return
	if(current_mag.current_rounds)
		var/obj/item/arrow/unloaded_arrow = new ammo.handful_type(get_turf(src))
		playsound(user, reload_sound, 25, TRUE)
		current_mag.current_rounds--
		if(user)
			to_chat(user, SPAN_NOTICE("You unload [unloaded_arrow] from \the [src]."))
			user.put_in_hands(unloaded_arrow)
		update_icon()

/obj/item/weapon/gun/bow/update_icon()
	..()
	if (current_mag && current_mag.current_rounds > 0)
		if (istype(ammo, /datum/ammo/arrow))
			var/datum/ammo/arrow/arrow = ammo
			if (arrow.activated)
				icon_state = "bow_expl"
			else
				icon_state = "bow_loaded"

/obj/item/weapon/gun/bow/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/arrow))
		var/obj/item/arrow/attacking_arrow = attacking_item
		if(current_mag && current_mag.current_rounds == 0)
			ammo = GLOB.ammo_list[attacking_arrow.ammo_datum]
			playsound(user, reload_sound, 25, 1)
			to_chat(user, SPAN_NOTICE("You load [attacking_arrow] into [src]."))
			current_mag.current_rounds++
			qdel(attacking_arrow)
			update_icon()
		else
			to_chat(user, SPAN_WARNING("[src] is already loaded!"))
	else
		to_chat(user, SPAN_WARNING("That's not an arrow!"))

/obj/item/arrow
	w_class = SIZE_MEDIUM
	var/activated = FALSE
	icon = 'icons/obj/items/weapons/guns/pred_bow.dmi'
	icon_state = "arrow"
	item_state = "arrow"
	var/ammo_datum = /datum/ammo/arrow

/obj/item/arrow/expl
	activated = TRUE
	icon_state = "arrow_expl"
	ammo_datum = /datum/ammo/arrow/expl

/obj/item/arrow/attack_self(mob/user)
	. = ..()
	if (activated)
		activated = FALSE
		icon_state = "arrow"
		ammo_datum = /datum/ammo/arrow
	else
		activated = TRUE
		icon_state = "arrow_expl"
		ammo_datum = /datum/ammo/arrow/expl
