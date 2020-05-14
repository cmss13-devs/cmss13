/*
Contains most of the procs that are called when a mob is attacked by something
*/

/mob/living/carbon/human/stun_effect_act(var/stun_amount, var/agony_amount, var/def_zone)
	var/obj/limb/affected = get_limb(check_zone(def_zone))
	var/siemens_coeff = get_siemens_coefficient_organ(affected)
	stun_amount *= siemens_coeff
	agony_amount *= siemens_coeff

	switch (def_zone)
		if("head")
			agony_amount *= 1.50
		if("l_hand", "r_hand")
			var/c_hand
			if (def_zone == "l_hand")
				c_hand = l_hand
			else
				c_hand = r_hand

			if(c_hand && (stun_amount || agony_amount > 10))
				msg_admin_attack("[key_name(src)] was disarmed by a stun effect in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)

				drop_inv_item_on_ground(c_hand)
				if (affected.status & LIMB_ROBOT)
					emote("me", 1, "drops what they were holding, their [affected.display_name] malfunctioning!")
				else
					var/emote_scream = pick("screams in pain and", "lets out a sharp cry and", "cries out and")
					emote("me", 1, "[(species && species.flags & NO_PAIN) ? "" : emote_scream ] drops what they were holding in their [affected.display_name]!")

	..(stun_amount, agony_amount, def_zone)

/mob/living/carbon/human/getarmor(var/def_zone, var/type)
	var/armorval = 0
	var/total = 0

	if(def_zone)
		if(isorgan(def_zone))
			return getarmor_organ(def_zone, type)
		var/obj/limb/affecting = get_limb(def_zone)
		return getarmor_organ(affecting, type)
		//If a specific bodypart is targetted, check how that bodypart is protected and return the value.

	//If you don't specify a bodypart, it checks ALL your bodyparts for protection, and averages out the values
	for(var/X in limbs)
		var/obj/limb/E = X
		var/weight = organ_rel_size[E.name]
		armorval += getarmor_organ(E, type) * weight
		total += weight
	return (armorval/max(total, 1))

//this proc returns the Siemens coefficient of electrical resistivity for a particular external organ.
/mob/living/carbon/human/proc/get_siemens_coefficient_organ(var/obj/limb/def_zone)
	if (!def_zone)
		return 1.0

	var/siemens_coefficient = 1.0

	var/list/clothing_items = list(head, wear_mask, wear_suit, w_uniform, gloves, shoes) // What all are we checking?
	for(var/obj/item/clothing/C in clothing_items)
		if(istype(C) && (C.flags_armor_protection & def_zone.body_part)) // Is that body part being targeted covered?
			siemens_coefficient *= C.siemens_coefficient

	return siemens_coefficient

//this proc returns the armour value for a particular external organ.
/mob/living/carbon/human/proc/getarmor_organ(var/obj/limb/def_zone, var/type)
	if(!type)	return 0
	var/protection = 0
	var/list/protective_gear = list(head, wear_mask, wear_suit, w_uniform, gloves, shoes)
	for(var/gear in protective_gear)
		if(gear && istype(gear ,/obj/item/clothing))
			var/obj/item/clothing/C = gear
			if(C.flags_armor_protection & def_zone.body_part)
				protection += C.get_armor(type)
	return protection

/mob/living/carbon/human/proc/check_head_coverage()

	var/list/body_parts = list(head, wear_mask, wear_suit ) /* w_uniform, gloves, shoes*/ //We don't need to check these for heads.
	for(var/bp in body_parts)
		if(!bp)	continue
		if(bp && istype(bp ,/obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(C.flags_armor_protection & BODY_FLAG_HEAD)
				return 1
	return 0

/mob/living/carbon/human/proc/check_shields(var/damage = 0, var/attack_text = "the attack", var/combistick=0)
	if(l_hand && istype(l_hand, /obj/item/weapon))//Current base is the prob(50-d/3)
		if(combistick && istype(l_hand,/obj/item/weapon/combistick) && prob(66))
			var/obj/item/weapon/combistick/C = l_hand
			if(C.on)
				return TRUE

		if(l_hand.IsShield() && istype(l_hand,/obj/item/weapon/shield)) // Activable shields
			var/obj/item/weapon/shield/S = l_hand
			var/shield_blocked_l = FALSE
			if(S.shield_readied && prob(S.readied_block)) // User activated his shield before the attack. Lower if it blocks.
				S.lower_shield(src)
				shield_blocked_l = TRUE
			else if(prob(S.passive_block))
				shield_blocked_l = TRUE

			if(shield_blocked_l)
				visible_message(SPAN_DANGER("<B>[src] blocks [attack_text] with the [l_hand.name]!</B>"), null, null, 5)
				return TRUE 
			// We cannot return FALSE on fail here, because we haven't checked r_hand yet. Dual-wielding shields perhaps!

		var/obj/item/weapon/I = l_hand
		if(I.IsShield() && !istype(I, /obj/item/weapon/shield) && (prob(50 - round(damage / 3)))) // 'other' shields, like predweapons. Make sure that item/weapon/shield does not apply here, no double-rolls.
			visible_message(SPAN_DANGER("<B>[src] blocks [attack_text] with the [l_hand.name]!</B>"), null, null, 5)
			return TRUE

	if(r_hand && istype(r_hand, /obj/item/weapon))
		if(combistick && istype(r_hand,/obj/item/weapon/combistick) && prob(66))
			var/obj/item/weapon/combistick/C = r_hand
			if(C.on)
				return TRUE
				
		if(r_hand.IsShield() && istype(r_hand,/obj/item/weapon/shield)) // Activable shields
			var/obj/item/weapon/shield/S = r_hand
			var/shield_blocked_r = FALSE
			if(S.shield_readied && prob(S.readied_block)) // User activated his shield before the attack. Lower if it blocks.
				shield_blocked_r = TRUE
				S.lower_shield(src)
			else if(prob(S.passive_block))
				shield_blocked_r = TRUE

			if(shield_blocked_r)
				visible_message(SPAN_DANGER("<B>[src] blocks [attack_text] with the [r_hand.name]!</B>"), null, null, 5)
				return TRUE 

		var/obj/item/weapon/I = r_hand
		if(I.IsShield() && !istype(I, /obj/item/weapon/shield) && (prob(50 - round(damage / 3)))) // other shields. Don't doublecheck activable here.
			visible_message(SPAN_DANGER("<B>[src] blocks [attack_text] with the [r_hand.name]!</B>"), null, null, 5)
			return TRUE

	if(back && istype(back, /obj/item/weapon/shield/riot) && prob(20))
		visible_message(SPAN_DANGER("<B>The [back] on [src]'s back blocks [attack_text]!</B>"), null, null, 5)
		return TRUE

	if(attack_text == "the pounce" && wear_suit && wear_suit.flags_inventory & BLOCK_KNOCKDOWN)
		visible_message(SPAN_DANGER("<B>[src] withstands [attack_text] with their [wear_suit.name]!</B>"), null, null, 5)
		return TRUE
	return FALSE

/mob/living/carbon/human/emp_act(severity)
	for(var/obj/O in src)
		if(!O)	continue
		O.emp_act(severity)
	for(var/obj/limb/O in limbs)
		if(O.status & LIMB_DESTROYED)	continue
		O.emp_act(severity)
		for(var/datum/internal_organ/I in O.internal_organs)
			if(I.robotic == 0)	continue
			I.emp_act(severity)
	..()


//Returns 1 if the attack hit, 0 if it missed.
/mob/living/carbon/human/proc/attacked_by(var/obj/item/I, var/mob/living/user, var/def_zone)
	if(!I || !user)
		return 0

	var/target_zone = def_zone? check_zone(def_zone) : get_zone_with_miss_chance(user.zone_selected, src)

	user.animation_attack_on(src)
	if(user == src) // Attacking yourself can't miss
		target_zone = user.zone_selected
	if(!target_zone && !(I.flags_item & ITEM_PREDATOR))
		visible_message(SPAN_DANGER("[user] misses [src] with \the [I]!"), null, null, 5)
		return 0

	var/obj/limb/affecting = get_limb(target_zone)
	if (!affecting)
		return 0
	if(affecting.status & LIMB_DESTROYED)
		to_chat(user, "What [affecting.display_name]?")
		return 0
	var/hit_area = affecting.display_name

	if((user != src) && check_shields(I.force, "the [I.name]"))
		return 0

	if(I.attack_verb && I.attack_verb.len)
		visible_message(SPAN_DANGER("<B>[src] has been [pick(I.attack_verb)] in the [hit_area] with [I.name] by [user]!</B>"), null, null, 5)
	else
		visible_message(SPAN_DANGER("<B>[src] has been attacked in the [hit_area] with [I.name] by [user]!</B>"), null, null, 5)

	var/armor = getarmor(affecting, ARMOR_MELEE)
	var/armor_block = run_armor_check(affecting, ARMOR_MELEE, "Your armor has protected your [hit_area].", "Your armor has softened hit to your [hit_area].")

	var/weapon_sharp = is_sharp(I)
	var/weapon_edge = has_edge(I)
	if ((weapon_sharp || weapon_edge) && prob(getarmor(target_zone, ARMOR_MELEE)))
		weapon_sharp = 0
		weapon_edge = 0

	if(!I.force)
		return 0
	if(weapon_sharp)
		user.flick_attack_overlay(src, "punch")
	else
		user.flick_attack_overlay(src, "punch")

	var/damage = armor_damage_reduction(config.marine_melee, I.force, armor, (weapon_sharp?30:0) + (weapon_edge?10:0)) // no penetration frm punches
	apply_damage(damage, I.damtype, affecting, 0, sharp=weapon_sharp, edge=weapon_edge, used_weapon=I)

	var/bloody = 0
	if((I.damtype == BRUTE || I.damtype == HALLOSS) && prob(I.force*2 + 25))
		if(!(affecting.status & LIMB_ROBOT))
			I.add_mob_blood(src)	//Make the weapon bloody, not the person.
			if(prob(33))
				bloody = 1
				var/turf/location = loc
				if(istype(location, /turf))
					location.add_mob_blood(src)
				if(ishuman(user))
					var/mob/living/carbon/human/H = user
					if(get_dist(H, src) <= 1) //people with TK won't get smeared with blood
						H.bloody_body(src)
						H.bloody_hands(src)


		switch(hit_area)
			if("head")
				if(bloody)//Apply blood
					if(wear_mask)
						wear_mask.add_mob_blood(src)
						update_inv_wear_mask(0)
					if(head)
						head.add_mob_blood(src)
						update_inv_head(0)
					if(glasses && prob(33))
						glasses.add_mob_blood(src)
						update_inv_glasses(0)

			if("chest")//Easier to score a stun but lasts less time
				if(prob((I.force + 10)))
					apply_effect(6, WEAKEN, armor_block)
					visible_message(SPAN_DANGER("<B>[src] has been knocked down!</B>"), null, null, 5)

				if(bloody)
					bloody_body(src)

	//Melee weapon embedded object code.
	if (I.damtype == BRUTE && !I.is_robot_module() && !(I.flags_item & (NODROP|DELONDROP)))
		damage = I.force
		if(damage > 40) damage = 40  //Some sanity, mostly for yautja weapons. CONSTANT STICKY ICKY
		if (!armor_block && weapon_sharp && prob(3) && !isYautja(user)) // make yautja less likely to get their weapon stuck
			affecting.embed(I)

	return 1

//this proc handles being hit by a thrown atom
/mob/living/carbon/human/hitby(atom/movable/AM)
	if (!isobj(AM))
		return

	var/obj/O = AM

	//empty active hand and we're in throw mode
	if (throw_mode && !get_active_hand() && cur_speed <= SPEED_VERY_FAST && \
		!is_mob_incapacitated() && isturf(O.loc) && put_in_active_hand(O)
	)
		if ((O.flags_atom & ITEM_UNCATCHABLE) && !isYautja(src))
			return
		visible_message(SPAN_WARNING("[src] catches [O]!"), null, null, 5)
		toggle_throw_mode(THROW_MODE_OFF)
		return

	var/dtype = BRUTE
	if (istype(O,/obj/item/weapon))
		var/obj/item/weapon/W = O
		dtype = W.damtype
	var/impact_damage = (1 + O.throwforce*THROWFORCE_COEFF)*O.throwforce*THROW_SPEED_IMPACT_COEFF*O.cur_speed

	var/zone
	if (istype(O.thrower, /mob/living))
		var/mob/living/L = O.thrower
		zone = check_zone(L.zone_selected)
	else
		zone = ran_zone("chest",75)	//Hits a random part of the body, geared towards the chest

	//check if we hit
	if (O.throw_source)
		var/distance = get_dist(O.throw_source, loc)
		zone = get_zone_with_miss_chance(zone, src, min(15*(distance-2), 0))
	else
		zone = get_zone_with_miss_chance(zone, src, 15)

	if (!zone)
		visible_message(SPAN_NOTICE("\The [O] misses [src] narrowly!"), null, null, 5)
		return
	O.throwing = 0		//it hit, so stop moving

	if ((O.thrower != src) && check_shields(impact_damage, "[O]"))
		return

	var/obj/limb/affecting = get_limb(zone)
	var/hit_area = affecting.display_name

	src.visible_message(SPAN_DANGER("[src] has been hit in the [hit_area] by [O]."), null, null, 5)

	var/armor = getarmor(affecting, ARMOR_MELEE)

	var/weapon_sharp = is_sharp(O)
	var/weapon_edge = has_edge(O)

	var/damage = armor_damage_reduction(config.marine_melee, impact_damage, armor, (weapon_sharp?30:0) + (weapon_edge?10:0))
	apply_damage(damage, dtype, affecting, 0, sharp=weapon_sharp, edge=weapon_edge, used_weapon=O)

	if (damage > 5)
		last_damage_source = initial(AM.name)

	if (ismob(O.thrower))
		var/mob/M = O.thrower
		var/client/assailant = M.client
		if (damage > 5)
			last_damage_mob = M
			M.track_hit(initial(name))
			if (M.faction == faction)
				M.track_friendly_fire(initial(name))
		if (assailant)
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been hit with a [O], thrown by [key_name(M)]</font>")
			M.attack_log += text("\[[time_stamp()]\] <font color='red'>Hit [key_name(src)] with a thrown [O]</font>")
			if(!istype(src,/mob/living/simple_animal/mouse))
				msg_admin_attack("[key_name(src)] was hit by a [O], thrown by [key_name(M)] in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)

	//thrown weapon embedded object code.
	if (dtype == BRUTE && istype(O,/obj/item))
		var/obj/item/I = O
		if (!I.is_robot_module())
			var/sharp = is_sharp(I)
			//blunt objects should really not be embedding in things unless a huge amount of force is involved
			var/embed_chance = sharp? damage/I.w_class : damage/(I.w_class*3)
			var/embed_threshold = sharp? 5*I.w_class : 15*I.w_class

			//Sharp objects will always embed if they do enough damage.
			//Thrown sharp objects have some momentum already and have a small chance to embed even if the damage is below the threshold
			if (!isYautja(src) && ((sharp && prob(damage/(10*I.w_class)*100)) || (damage > embed_threshold && prob(embed_chance))))
				affecting.embed(I)

/mob/living/carbon/human/proc/bloody_hands(var/mob/living/source, var/amount = 2)
	var/b_color = source.get_blood_color()
	if(!b_color)
		return
	if (gloves)
		gloves.add_mob_blood(source)
		gloves.gloves_blood_amt = amount
	else
		hands_blood_color = b_color
		hands_blood_amt = max(amount, hands_blood_amt)

	update_inv_gloves()		//updates on-mob overlays for bloody hands and/or bloody gloves


/mob/living/carbon/human/proc/bloody_body(var/mob/living/source)
	if(wear_suit)
		wear_suit.add_mob_blood(source)
		update_inv_wear_suit()
	if(w_uniform)
		w_uniform.add_mob_blood(source)
		update_inv_w_uniform()

//This looks for a "marine", ie. non-civilian ID on a person. Used with the m56 Smartgun code.
//Does not actually check for station jobs or access yet, cuz I'm mad lazy.
//Updated and renamed a bit. Will probably updated properly once we have a new ID system in place, as this is just a workaround ~N.
/mob/living/carbon/human/proc/get_target_lock(access_to_check)
	//Streamlined for faster processing. Needs a unique access, otherwise it will just hit everything.
	var/obj/item/card/id/C = wear_id
	if(!istype(C)) 
		C = get_active_hand()
	if(!istype(C)) 
		return FALSE
	if (!islist(access_to_check))
		return access_to_check in C.access
	var/list/overlap = access_to_check & C.access
	return overlap.len
