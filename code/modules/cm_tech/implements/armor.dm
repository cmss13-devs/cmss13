
/obj/item/clothing/accessory/health
	name = "armor plate"
	desc = "A metal trauma plate, able to absorb some blows."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "regular2_100"
	var/base_icon_state = "regular2"

	slot = ACCESSORY_SLOT_ARMOR_C
	var/armor_health = 10
	var/armor_maxhealth = 10

	var/take_slash_damage = TRUE
	var/slash_durability_mult = 0.25
	var/FF_projectile_durability_mult = 0.1
	var/hostile_projectile_durability_mult = 1

	var/list/health_states = list(
		0,
		50,
		100
	)

	var/scrappable = TRUE

	var/armor_hitsound = 'sound/effects/metalhit.ogg'
	var/armor_shattersound = 'sound/effects/metal_shatter.ogg'

/obj/item/clothing/accessory/health/update_icon()
	for(var/health_state in health_states)
		if(armor_health / armor_maxhealth * 100 <= health_state)
			icon_state = "[base_icon_state]_[health_state]"
			return

/obj/item/clothing/accessory/health/proc/get_damage_status()
	var/percentage = round(armor_health / armor_maxhealth * 100)
	switch(percentage)
		if(0)
			. = "It is broken."
			if(scrappable)
				. += " If you had two, you could repair it."
		if(1 to 19)
			. = "It is crumbling apart!"
		if(20 to 49)
			. = "It is seriously damaged."
		if(50 to 79)
			. = "It is moderately damaged."
		if(80 to 99)
			. = "It is slightly damaged."
		else
			. = "It is in pristine condition."

/obj/item/clothing/accessory/health/get_examine_text(mob/user)
	. = ..()
	. += "To use it, attach it to your uniform."
	. += SPAN_NOTICE(get_damage_status())

/obj/item/clothing/accessory/health/additional_examine_text()
	return ". [get_damage_status()]"

/obj/item/clothing/accessory/health/on_attached(obj/item/clothing/S, mob/living/carbon/human/user)
	. = ..()
	if(.)
		RegisterSignal(S, COMSIG_ITEM_EQUIPPED, PROC_REF(check_to_signal))
		RegisterSignal(S, COMSIG_ITEM_DROPPED, PROC_REF(unassign_signals))

		if(istype(user) && user.w_uniform == S)
			check_to_signal(S, user, WEAR_BODY)

/obj/item/clothing/accessory/health/on_removed(mob/living/user, obj/item/clothing/C)
	. = ..()
	if(.)
		unassign_signals(C, user)
		UnregisterSignal(C, list(
			COMSIG_ITEM_EQUIPPED,
			COMSIG_ITEM_DROPPED
		))

/obj/item/clothing/accessory/health/proc/check_to_signal(obj/item/clothing/S, mob/living/user, slot)
	SIGNAL_HANDLER

	if(slot == WEAR_BODY)
		if(take_slash_damage)
			RegisterSignal(user, COMSIG_HUMAN_XENO_ATTACK, PROC_REF(take_slash_damage))
		RegisterSignal(user, COMSIG_HUMAN_BULLET_ACT, PROC_REF(take_bullet_damage))
	else
		unassign_signals(S, user)

/obj/item/clothing/accessory/health/proc/unassign_signals(obj/item/clothing/S, mob/living/user)
	SIGNAL_HANDLER

	UnregisterSignal(user, list(
		COMSIG_HUMAN_XENO_ATTACK,
		COMSIG_HUMAN_BULLET_ACT
	))

/obj/item/clothing/accessory/health/proc/take_bullet_damage(mob/living/carbon/human/user, damage, ammo_flags, obj/item/projectile/P)
	SIGNAL_HANDLER
	if(damage <= 0 || (ammo_flags & AMMO_IGNORE_ARMOR))
		return

	var/damage_to_nullify = armor_health
	var/final_proj_mult = FF_projectile_durability_mult

	var/mob/living/carbon/human/pfirer = P.firer
	if(user.faction != pfirer.faction)
		final_proj_mult = hostile_projectile_durability_mult

	armor_health = max(armor_health - damage*final_proj_mult, 0)

	update_icon()
	if(!armor_health && damage_to_nullify)
		user.show_message(SPAN_WARNING("You feel [src] break apart."), null, null, null, CHAT_TYPE_ARMOR_DAMAGE)
		playsound(user, armor_shattersound, 35, TRUE)

	if(damage_to_nullify)
		playsound(user, armor_hitsound, 25, TRUE)
		P.play_hit_effect(user)
		return COMPONENT_CANCEL_BULLET_ACT

/obj/item/clothing/accessory/health/proc/take_slash_damage(mob/living/user, list/slashdata)
	SIGNAL_HANDLER
	var/armor_damage = slashdata["n_damage"]
	var/damage_to_nullify = armor_health
	armor_health = max(armor_health - armor_damage*slash_durability_mult, 0)

	update_icon()
	if(!armor_health && damage_to_nullify)
		user.show_message(SPAN_WARNING("You feel [src] break apart."), null, null, null, CHAT_TYPE_ARMOR_DAMAGE)
		playsound(user, armor_shattersound, 50, TRUE)

	if(damage_to_nullify)
		slashdata["n_damage"] = 0
		slashdata["slash_noise"] = armor_hitsound

/obj/item/clothing/accessory/health/attackby(obj/item/clothing/accessory/health/I, mob/user)
	if(!istype(I, src.type) || !scrappable || has_suit || I.has_suit)
		return

	if(!I.armor_health && !armor_health)
		to_chat(user, SPAN_NOTICE("You use the shards of armor to cobble together an improvised trauma plate."))
		qdel(I)
		qdel(src)
		user.put_in_active_hand(new /obj/item/clothing/accessory/health/scrap())


/obj/item/clothing/accessory/health/ceramic_plate
	name = "ceramic plate"
	desc = "A strong trauma plate, able to protect the user from a large amount of bullets. Ineffective against sharp objects."
	icon_state = "ceramic2_100"
	base_icon_state = "ceramic2"

	take_slash_damage = FALSE
	scrappable = FALSE
	FF_projectile_durability_mult = 0.3

	armor_health = 100
	armor_maxhealth = 100

	armor_shattersound = 'sound/effects/ceramic_shatter.ogg'

/obj/item/clothing/accessory/health/ceramic_plate/take_bullet_damage(mob/living/user, damage, ammo_flags)
	if(ammo_flags & AMMO_ACIDIC)
		return

	return ..()

/obj/item/clothing/accessory/health/scrap
	name = "scrap metal"
	desc = "A weak armour plate, only able to protect from a little bit of damage. Perhaps that will be enough."
	icon_state = "scrap_100"
	base_icon_state = "scrap"
	health_states = list(
		0,
		100,
	)

	scrappable = FALSE

	armor_health = 7.5
	armor_maxhealth = 7.5

/obj/item/clothing/accessory/health/scrap/on_removed(mob/living/user, obj/item/clothing/C)
	. = ..()
	if(. && !armor_health)
		qdel(src)
