/obj/item/weapon/shield/riot/yautja
	name = "clan shield"
	desc = "A large tribal shield made of a strange metal alloy. The face of the shield bears three skulls, two human, one alien."
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "shield"
	base_icon_state = "shield"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/hunter/items_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/hunter/items_righthand.dmi',
		WEAR_BACK = 'icons/mob/humans/onmob/hunter/pred_gear.dmi'
	)
	item_state = "shield"
	flags_item = ITEM_PREDATOR
	flags_equip_slot = SLOT_BACK

	passive_block = 15
	readied_block = 30

	blocks_on_back = FALSE

	var/last_attack = 0
	var/cooldown_time = 25 SECONDS

/obj/item/weapon/shield/riot/yautja/raise_shield(mob/user)
	..()
	item_state = "[base_icon_state]_ready"
	if(user.r_hand == src)
		user.update_inv_r_hand()
	if(user.l_hand == src)
		user.update_inv_l_hand()

/obj/item/weapon/shield/riot/yautja/lower_shield(mob/user)
	..()
	item_state = base_icon_state
	if(user.r_hand == src)
		user.update_inv_r_hand()
	if(user.l_hand == src)
		user.update_inv_l_hand()

/obj/item/weapon/shield/riot/yautja/attack(mob/living/M, mob/living/user)
	. = ..()
	if(. && (world.time > last_attack + cooldown_time))
		last_attack = world.time
		M.throw_atom(get_step(M, user.dir), 1, SPEED_AVERAGE, user, FALSE)
		M.apply_effect(3, DAZE)
		M.apply_effect(5, SLOW)

/obj/item/weapon/shield/riot/yautja/attackby(obj/item/attacking_item, mob/user)
	if(cooldown < world.time - 25)
		if(istype(attacking_item, /obj/item/weapon) && (attacking_item.flags_item & ITEM_PREDATOR))
			user.visible_message(SPAN_WARNING("[user] bashes [src] with [attacking_item]!"))
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 25, 1)
			cooldown = world.time
	else
		..()

/obj/item/weapon/shield/riot/yautja/ancient
	name = "ancient shield"
	desc = "A large, ancient shield forged from an unknown golden alloy, gleaming with a luminous brilliance. Its worn surface and masterful craftsmanship hint at a forgotten purpose and a history lost to time."
	icon = 'icons/obj/items/weapons/melee/shields.dmi'
	icon_state = "ancient_shield"
	base_icon_state = "ancient_shield"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/melee/shields_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/melee/shields_righthand.dmi',
		WEAR_BACK = 'icons/mob/humans/onmob/hunter/pred_gear.dmi'
	)
	item_state = "ancient_shield"

/obj/item/weapon/shield/riot/yautja/ancient/alt
	name = "ancient shield"
	desc = "A large, ornately crafted shield forged from an unknown alloy. The colossal metal skull of a Xenomorph dominates the center, its jagged edges and hollow eyes giving it a fearsome presence. The masterful craftsmanship and weathered battle scars whisper of long-forgotten hunts and a legacy etched in blood."
	icon_state = "ancient_shield_alt"
	base_icon_state = "ancient_shield_alt"
	item_state = "ancient_shield_alt"
