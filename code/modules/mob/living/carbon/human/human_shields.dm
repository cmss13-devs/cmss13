/**
*Attacking direction is determined by get_dir(DEFENDER, ATTACKER)
*
*Arguments:
* * attack_type - Checking if this is a Melee, Projectile or Pounce attack.
* * custom_response - Used to determine if the items involved are sending their own messages to chat about the interaction or whether this proc needs to generate an interaction message.
*/
/mob/living/carbon/human/proc/check_shields(attack_text = "the attack", attacking_direction, attack_type = SHIELD_ATTACK_MELEE, custom_response = FALSE)
	var/block_effect = /obj/effect/block
	var/turf/owner_turf = get_turf(src)

	// First we handle the easy stuff.

	// Check if our armour blocks pounces.
	if((attack_type == SHIELD_ATTACK_POUNCE) && wear_suit && wear_suit.flags_inventory & BLOCK_KNOCKDOWN)
		if(!custom_response)
			visible_message(SPAN_DANGER("<B>[src] withstands [attack_text] with their [wear_suit.name]!</B>"), max_distance=5)
		new block_effect(owner_turf)
		playsound(src, 'sound/items/block_shield.ogg', 70, vary = TRUE)
		return TRUE

	if(back && istype(back, /obj/item/weapon/shield))
		var/obj/item/weapon/shield/back_shield = back
		if(back_shield.blocks_on_back)
			// Check if we can block a pounce at all.
			if(attack_type == SHIELD_ATTACK_POUNCE && !(back_shield.shield_flags & CAN_BLOCK_POUNCE))
				return FALSE
			switch(back_shield.shield_type)
				if(SHIELD_DIRECTIONAL, SHIELD_DIRECTIONAL_TWOHANDS)
					var/appropriate_dir = (attacking_direction in get_related_directions(reverse_direction(dir)))
					if(appropriate_dir && prob(back_shield.passive_block))
						if(!custom_response)
							visible_message(SPAN_DANGER("<B>The [back_shield] on [src]'s back blocks [attack_text]!</B>"), null, null, 5)
						new block_effect(owner_turf)
						playsound(src, back_shield.shield_sound, 70, vary = TRUE)
						return TRUE
				if(SHIELD_ABSOLUTE, SHIELD_ABSOLUTE_TWOHANDS)
					if(prob(back_shield.passive_block))
						if(!custom_response)
							visible_message(SPAN_DANGER("<B>[src] is protected from [attack_text] by the [back_shield]!</B>"), null, null, 5)
						new block_effect(owner_turf)
						playsound(src, back_shield.shield_sound, 70, vary = TRUE)
						return TRUE

	// Now we get all the stats of our possible shields.
	var/obj/item/weapon/left_hand_weapon
	var/obj/item/weapon/shield/left_hand_shield
	var/left_hand_type = SHIELD_NONE
	var/left_hand_base_chance = 0
	var/left_hand_proj_mult = 0

	var/obj/item/weapon/right_hand_weapon
	var/obj/item/weapon/shield/right_hand_shield
	var/right_hand_type = SHIELD_NONE
	var/right_hand_base_chance = 0
	var/right_hand_proj_mult = 0

	var/can_block_pounce = FALSE

	if(l_hand && istype(l_hand, /obj/item/weapon))
		left_hand_weapon = l_hand
		if(left_hand_weapon.shield_flags & CAN_BLOCK_POUNCE)
			can_block_pounce = TRUE
		if(left_hand_weapon.shield_chance && left_hand_weapon.shield_type)
			left_hand_type = left_hand_weapon.shield_type
			left_hand_proj_mult = left_hand_weapon.shield_projectile_mult
			left_hand_base_chance = left_hand_weapon.shield_chance

			if(!(left_hand_weapon.flags_item & WIELDED))
				if(left_hand_type == SHIELD_ABSOLUTE_TWOHANDS)
					left_hand_base_chance = (left_hand_base_chance / 2)
				if(left_hand_type == SHIELD_DIRECTIONAL_TWOHANDS)
					left_hand_base_chance = (left_hand_base_chance / 3)
			if(istype(left_hand_weapon, /obj/item/weapon/shield)) // Activable shields
				left_hand_shield = left_hand_weapon

	if(!left_hand_shield) // Don't want to be sharing a dedicated shield and a weapon's block, else numbers could theoretically go over 100
		if(r_hand && istype(r_hand, /obj/item/weapon))
			right_hand_weapon = r_hand
			if(right_hand_weapon.shield_flags & CAN_BLOCK_POUNCE)
				can_block_pounce = TRUE
			if(right_hand_weapon.shield_chance && right_hand_weapon.shield_type)
				right_hand_type = right_hand_weapon.shield_type
				right_hand_proj_mult = right_hand_weapon.shield_projectile_mult
				right_hand_base_chance = right_hand_weapon.shield_chance

				if(!(right_hand_weapon.flags_item & WIELDED))
					if(right_hand_type == SHIELD_ABSOLUTE_TWOHANDS)
						right_hand_base_chance = (right_hand_base_chance / 2)
					if(left_hand_type == SHIELD_DIRECTIONAL_TWOHANDS)
						right_hand_base_chance = (right_hand_base_chance / 3)
				if(istype(right_hand_weapon, /obj/item/weapon/shield)) // Activable shields
					right_hand_shield = right_hand_weapon
	if(right_hand_shield)
		left_hand_weapon = null
		left_hand_type = SHIELD_NONE
		left_hand_base_chance = 0
		left_hand_proj_mult = 0

	// Check if we can block a pounce at all.
	if((attack_type == SHIELD_ATTACK_POUNCE) && !can_block_pounce)
		return FALSE

	/// Here we want to check for absolute first, and then directional. If one shield has absolute and the other doesn't, we still treat the total block as absolute.
	var/checking_type
	if(left_hand_type == SHIELD_ABSOLUTE_TWOHANDS || right_hand_type == SHIELD_ABSOLUTE_TWOHANDS)
		checking_type = SHIELD_ABSOLUTE
	else if(left_hand_type == SHIELD_ABSOLUTE || right_hand_type == SHIELD_ABSOLUTE)
		checking_type = SHIELD_ABSOLUTE
	else if(left_hand_type == SHIELD_DIRECTIONAL_TWOHANDS || right_hand_type == SHIELD_DIRECTIONAL_TWOHANDS)
		checking_type = SHIELD_DIRECTIONAL
	else if(left_hand_type == SHIELD_DIRECTIONAL || right_hand_type == SHIELD_DIRECTIONAL)
		checking_type = SHIELD_DIRECTIONAL
	else // If there aren't any shield types assigned to etiher possible weapon, we're not blocking anything.
		return FALSE

	/// We go with the highest percentage possible, based on all of one weapon and half of the other.
	var/checking_base_chance = max(left_hand_base_chance + (right_hand_base_chance/2), right_hand_base_chance + (left_hand_base_chance/2))

	if(checking_base_chance <= 0) // Fail.
		return FALSE

	/// We're not adding up projectile multipliers, we just take the highest available.
	var/checking_proj_mult = max(left_hand_proj_mult, right_hand_proj_mult)

	/// Now we need to work out which weapon we're giving the glory of playing a sound and giving text.
	var/obj/item/weapon/checking_weapon
	if(left_hand_base_chance > right_hand_base_chance)
		checking_weapon = left_hand_weapon
	else
		checking_weapon = right_hand_weapon

	/// Now we work out the real block chance.
	var/block_chance = checking_base_chance
	if(attack_type == SHIELD_ATTACK_PROJECTILE)
		block_chance = (block_chance * checking_proj_mult)

	/// If there is no passed attack direction, we can't appropriately check for directional blocks, so we convert to absolute block instead.
	if(!attacking_direction && checking_type == SHIELD_DIRECTIONAL)
		checking_type = SHIELD_ABSOLUTE

	if(checking_type == SHIELD_DIRECTIONAL)
		if(!(attacking_direction in get_related_directions(dir)))
			return FALSE

	if(prob(block_chance))
		new block_effect(owner_turf)
		playsound(src, checking_weapon.shield_sound, 70, vary = TRUE)
		if(!custom_response)
			visible_message(SPAN_DANGER("<B>[src] blocks [attack_text] with the [checking_weapon.name]!</B>"), null, null, 5)
		return TRUE

	return FALSE
