///Attacking direction is determined by get_dir(DEFENDER, ATTACKER)
/mob/living/carbon/human/proc/check_shields(attack_text = "the attack", attacking_direction, is_projectile = FALSE, custom_response = FALSE)
	var/block_effect = /obj/effect/block
	var/owner_turf = get_turf(src)

	// First we handle the easy stuff.

	if(back && istype(back, /obj/item/weapon/shield))
		var/obj/item/weapon/shield/back_shield = back
		if(back_shield.blocks_on_back)
			var/appropriate_dir = FALSE
			var/facing_dir = dir
			for(var/catchment_dir in facing_nearby_direction(reverse_direction(facing_dir)))
				if(attacking_direction == catchment_dir)
					appropriate_dir = TRUE
					break
			if(appropriate_dir && prob(back_shield.passive_block))
				if(!custom_response)
					visible_message(SPAN_DANGER("<B>The [back_shield] on [src]'s back blocks [attack_text]!</B>"), null, null, 5)
				new block_effect(owner_turf)
				playsound(src, back_shield.shield_sound, 70, vary = TRUE)
				return TRUE

	if(attack_text == "the pounce" && wear_suit && wear_suit.flags_inventory & BLOCK_KNOCKDOWN)
		if(!custom_response)
			visible_message(SPAN_DANGER("<B>[src] withstands [attack_text] with their [wear_suit.name]!</B>"), null, null, 5)
		new block_effect(owner_turf)
		playsound(src, 'sound/items/block_shield.ogg', 70, vary = TRUE)
		return TRUE

	// Now we get all the stats of our possible shields.
	var/obj/item/weapon/left_hand_weapon
	var/obj/item/weapon/shield/left_hand_shield
	var/left_hand_type = 0
	var/left_hand_base_chance = 0
	var/left_hand_proj_mult = 0

	var/obj/item/weapon/right_hand_weapon
	var/obj/item/weapon/shield/right_hand_shield
	var/right_hand_type = 0
	var/right_hand_base_chance = 0
	var/right_hand_proj_mult = 0

	if(l_hand && istype(l_hand, /obj/item/weapon))
		left_hand_weapon = l_hand
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
		left_hand_type = 0
		left_hand_base_chance = 0
		left_hand_proj_mult = 0

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
	if(is_projectile)
		block_chance = (block_chance * checking_proj_mult)

	/// If there is no passed attack direction, we can't appropriately check for directional blocks, so we convert to absolute block instead.
	if(checking_type == SHIELD_DIRECTIONAL)
		if(!attacking_direction)
			checking_type = SHIELD_ABSOLUTE

	switch(checking_type)
		if(SHIELD_ABSOLUTE)
			if(prob(block_chance))
				new block_effect(owner_turf)
				playsound(src, checking_weapon.shield_sound, 70, vary = TRUE)
				if(!custom_response)
					visible_message(SPAN_DANGER("<B>[src] blocks [attack_text] with the [checking_weapon.name]!</B>"), null, null, 5)

				if(right_hand_shield && right_hand_shield.shield_readied) // User activated their shield before the attack. Lower if it blocks.
					right_hand_shield.lower_shield(src)
				if(left_hand_shield && left_hand_shield.shield_readied)
					left_hand_shield.lower_shield(src)
				return TRUE

		if(SHIELD_DIRECTIONAL)
			var/appropriate_dir = FALSE
			var/facing_dir = dir
			for(var/catchment_dir in facing_nearby_direction(facing_dir))
				if(attacking_direction == catchment_dir)
					appropriate_dir = TRUE
					break
			if(appropriate_dir && prob(block_chance))
				new block_effect(owner_turf)
				playsound(src, checking_weapon.shield_sound, 70, vary = TRUE)
				if(!custom_response)
					visible_message(SPAN_DANGER("<B>[src] blocks [attack_text] with the [checking_weapon.name]!</B>"), null, null, 5)

				if(right_hand_shield && right_hand_shield.shield_readied) // User activated their shield before the attack. Lower if it blocks.
					right_hand_shield.lower_shield(src)
				if(left_hand_shield && left_hand_shield.shield_readied)
					left_hand_shield.lower_shield(src)
				return TRUE
	return FALSE
