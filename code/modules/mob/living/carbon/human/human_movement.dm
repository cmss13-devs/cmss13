/mob/living/carbon/human/movement_delay()
	. = ..()

	recalculate_move_delay = FALSE

	if(interactee)// moving stops any kind of interaction
		unset_interaction()

	if(species.slowdown)
		. += species.slowdown

	if(embedded_items.len > 0)
		handle_embedded_objects() //Moving with objects stuck in you can cause bad times.

	var/reducible_tally = 0 //Tally elements that can be reduced are put here, then we apply hyperzine effects
	var/wear_slowdown_reduction = 0

	// All pain is now handled based off of traumatic_shock and scales based off it instead of being a flat effect.
	// There are levels here just like the levels used to scale pain effects:
	// Keep in mind 1 damage = 1.2 traumatic_shock
	// After trauma_highmed, scaling picks up real quick and you fall over
	if(!(species && (species.flags & NO_PAIN)))
		if (traumatic_shock >= TRAUMA_HIGH) 
			reducible_tally += PAIN_SPEED_VERYSLOW
		else if (traumatic_shock >= TRAUMA_HIGHMED)
			reducible_tally += PAIN_SPEED_SLOW
		else if (traumatic_shock >= TRAUMA_MED) 
			reducible_tally += PAIN_SPEED_MED
		else if (traumatic_shock >= TRAUMA_LOWMED)
			reducible_tally += PAIN_SPEED_LOWMED
		else if (traumatic_shock >= TRAUMA_LOW) 
			reducible_tally += PAIN_SPEED_LOW
		
		if(species.pain_mod != 1) //Lower the reducible tally based on species mod.
			reducible_tally *= species.pain_mod

	// Limb break/loss slowdown
	// Wheelchairs depend on different limbs than walking, which is...cute
	if(istype(buckled, /obj/structure/bed/chair/wheelchair))
		for(var/organ_name in list("l_hand","r_hand","l_arm","r_arm","chest","groin","head"))
			var/obj/limb/E = get_limb(organ_name)
			if(!E || (E.status & LIMB_DESTROYED))
				. += MOVE_REDUCTION_LIMB_DESTROYED
			if(E.status & LIMB_SPLINTED)
				. += MOVE_REDUCTION_LIMB_SPLINTED
			else if(E.status & LIMB_BROKEN)
				. += MOVE_REDUCTION_LIMB_BROKEN
	else
		if(shoes)
			. += shoes.slowdown

		for(var/organ_name in list("l_foot","r_foot","l_leg","r_leg","chest","groin","head"))
			var/obj/limb/E = get_limb(organ_name)
			if(!E || (E.status & LIMB_DESTROYED))
				. += MOVE_REDUCTION_LIMB_DESTROYED
			// Splinted limbs are not as punishing 
			if(E.status & LIMB_SPLINTED)
				. += MOVE_REDUCTION_LIMB_SPLINTED
			else if(E.status & LIMB_BROKEN)
				. += MOVE_REDUCTION_LIMB_BROKEN


	var/hungry = (500 - nutrition)/5 // So overeat would be 100 and default level would be 80
	if(hungry >= 50) //Level where a yellow food pip shows up, aka hunger level 3 at 250 nutrition and under
		reducible_tally += hungry/50 //Goes from a slowdown of 1 all the way to 2 for total starvation

	//Equipment slowdowns
	if(w_uniform)
		reducible_tally += w_uniform.slowdown
		wear_slowdown_reduction += w_uniform.movement_compensation

	if(wear_suit)
		reducible_tally += wear_suit.slowdown
		wear_slowdown_reduction += wear_suit.movement_compensation

	reducible_tally += reagent_move_delay_modifier //hyperzine and ultrazine

	if(bodytemperature < species.cold_level_1 && !isYautja(src))
		reducible_tally += 2 //Major slowdown if you're freezing

	if(temporary_slowdown)
		temporary_slowdown = max(temporary_slowdown - 1, 0)
		reducible_tally += 2 //Temporary slowdown slows hard

	if(shield_slowdown)
		reducible_tally += shield_slowdown

	//Compile reducible tally and send it to total tally. Cannot go more than 1 units faster from the reducible tally!
	. += max(-0.7, reducible_tally)

	if(istype(get_active_hand(), /obj/item/weapon/gun))
		var/obj/item/weapon/gun/G = get_active_hand() //If wielding, it will ALWAYS be on the active hand
		. += max(0, G.slowdown - wear_slowdown_reduction)

	if(mobility_aura)
		. -= 0.1 + 0.1 * mobility_aura

	if(superslowed)
		. += HUMAN_SUPERSLOWED_AMOUNT

	if(slowed && !superslowed)
		. += HUMAN_SLOWED_AMOUNT

	. += config.human_delay
	move_delay = .


/mob/living/carbon/human/Process_Spacemove(var/check_drift = 0)
	//Can we act
	if(is_mob_restrained())	return 0

	//Do we have a working jetpack
	if(istype(back, /obj/item/tank/jetpack))
		var/obj/item/tank/jetpack/J = back
		if(((!check_drift) || (check_drift && J.stabilization_on)) && (!lying) && (J.allow_thrust(0.01, src)))
			inertia_dir = 0
			return 1
//		if(!check_drift && J.allow_thrust(0.01, src))
//			return 1

	//If no working jetpack then use the other checks
	if(..())	return 1
	return 0


/mob/living/carbon/human/Process_Spaceslipping(var/prob_slip = 5)
	//If knocked out we might just hit it and stop.  This makes it possible to get dead bodies and such.

	if(species.flags & NO_SLIP)
		return

	if(stat)
		prob_slip = 0 // Changing this to zero to make it line up with the comment, and also, make more sense.

	//Do we have magboots or such on if so no slip
	if(istype(shoes, /obj/item/clothing/shoes/magboots) && (shoes.flags_inventory & NOSLIPPING))
		prob_slip = 0

	//Check hands and mod slip
	if(!l_hand)	prob_slip -= 2
	else if(l_hand.w_class <= SIZE_SMALL)	prob_slip -= 1
	if (!r_hand)	prob_slip -= 2
	else if(r_hand.w_class <= SIZE_SMALL)	prob_slip -= 1

	prob_slip = round(prob_slip)
	return(prob_slip)
