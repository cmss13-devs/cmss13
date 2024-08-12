/mob/living/carbon/human/movement_delay()
	. = ..()

	recalculate_move_delay = FALSE

	if(interactee)// moving stops any kind of interaction
		if(!(SEND_SIGNAL(src, COMSIG_HUMAN_MOVEMENT_CANCEL_INTERACTION) & COMPONENT_HUMAN_MOVEMENT_KEEP_USING))
			unset_interaction()

	if(species.slowdown)
		. += species.slowdown

	if(length(embedded_items) > 0)
		handle_embedded_objects() //Moving with objects stuck in you can cause bad times.

	var/reducible_tally = 0 //Tally elements that can be reduced are put here, then we apply MST effects
	var/wear_slowdown_reduction = 0

	reducible_tally += max(pain.pain_slowdown, stamina.stamina_slowdown) // Get the highest slowdown and apply that

	// Limb break/loss slowdown
	// Wheelchairs depend on different limbs than walking, which is...cute
	if(istype(buckled, /obj/structure/bed/chair/wheelchair))
		for(var/organ_name in list("l_hand","r_hand","l_arm","r_arm","chest","groin","head"))
			var/obj/limb/E = get_limb(organ_name)
			if(!E || !E.is_usable())
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
			if(!E || !E.is_usable())
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

	reducible_tally += reagent_move_delay_modifier //Muscle-stimulating property

	if(bodytemperature < species.cold_level_1 && !isyautja(src))
		reducible_tally += 2 //Major slowdown if you're freezing

	if(temporary_slowdown)
		temporary_slowdown = max(temporary_slowdown - 1, 0)
		reducible_tally += 2 //Temporary slowdown slows hard

	if(shield_slowdown)
		reducible_tally += shield_slowdown

	//Compile reducible tally and send it to total tally. Cannot go more than 1 units faster from the reducible tally!
	. += max(-0.7, reducible_tally)

	if(isgun(get_active_hand()))
		var/obj/item/weapon/gun/G = get_active_hand() //If wielding, it will ALWAYS be on the active hand
		. += max(0, G.slowdown - wear_slowdown_reduction)

	if(mobility_aura && . >= 1.5)
		. = max(. - (0.1 + 0.1 * mobility_aura), 1.5)

	if(superslowed)
		. += HUMAN_SUPERSLOWED_AMOUNT

	if(slowed && !superslowed)
		. += HUMAN_SLOWED_AMOUNT

	. += CONFIG_GET(number/human_delay)
	var/list/movedata = list("move_delay" = .)
	SEND_SIGNAL(src, COMSIG_HUMAN_POST_MOVE_DELAY, movedata)
	move_delay = movedata["move_delay"]

/mob/living/carbon/human/yautja/movement_delay()
	. = ..()

	if(superslowed)
		. += YAUTJA_SUPERSLOWED_AMOUNT

	if(slowed && !superslowed)
		. += YAUTJA_SLOWED_AMOUNT

	move_delay = .

/mob/living/carbon/human/Process_Spacemove(check_drift = 0)
	//Can we act
	if(is_mob_restrained()) return 0

// if(!check_drift && J.allow_thrust(0.01, src))
// return 1

	//If no working jetpack then use the other checks
	if(..()) return 1
	return 0


/mob/living/carbon/human/Process_Spaceslipping(prob_slip = 5)
	//If knocked out we might just hit it and stop.  This makes it possible to get dead bodies and such.

	if(species.flags & NO_SLIP)
		return

	if(stat)
		prob_slip = 0 // Changing this to zero to make it line up with the comment, and also, make more sense.

	//Do we have magboots or such on if so no slip
	if(istype(shoes, /obj/item/clothing/shoes/magboots) && (shoes.flags_inventory & NOSLIPPING))
		prob_slip = 0

	//Check hands and mod slip
	if(!l_hand) prob_slip -= 2
	else if(l_hand.w_class <= SIZE_SMALL) prob_slip--
	if (!r_hand) prob_slip -= 2
	else if(r_hand.w_class <= SIZE_SMALL) prob_slip--

	prob_slip = floor(prob_slip)
	return(prob_slip)

/// Updates [TRAIT_FLOORED] based on whether the mob has appropriate limbs to stand or not
/mob/living/carbon/human/proc/update_leg_status()
	if((has_limb("r_foot") && has_limb("r_leg")) || (has_limb("l_foot") && has_limb("l_leg")))
		REMOVE_TRAIT(src, TRAIT_FLOORED, BODY_TRAIT)
	else
		ADD_TRAIT(src, TRAIT_FLOORED, BODY_TRAIT)
