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

/obj/item/weapon/shield/riot/yautja/attackby(obj/item/I, mob/user)
	if(cooldown < world.time - 25)
		if(istype(I, /obj/item/weapon) && (I.flags_item & ITEM_PREDATOR))
			user.visible_message(SPAN_WARNING("[user] bashes \the [src] with \the [I]!"))
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 25, 1)
			cooldown = world.time
	else
		..()
