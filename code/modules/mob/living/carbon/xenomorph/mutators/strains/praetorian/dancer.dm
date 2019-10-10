/datum/xeno_mutator/praetorian_dancer
	// My name is Cuban Pete, I'm the King of the Rumba Beat
	name = "STRAIN: Praetorian - Dancer"
	description = "You are now a paragon of agility. You lose the ability to spit and shed some armor and pheromones. Your screech now makes you move faster and you gain a dance ability along with the power to perform various attacks with your tail."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Praetorian")  	// Only bae
	mutator_actions_to_remove = list("Xeno Spit","Toggle Spit Type", "Spray Acid")
	mutator_actions_to_add = list(/datum/action/xeno_action/activable/prae_dance, /datum/action/xeno_action/activable/prae_tailattack, /datum/action/xeno_action/prae_shift_tailattack)
	keystone = TRUE

/datum/xeno_mutator/praetorian_dancer/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return
	
	var/mob/living/carbon/Xenomorph/Praetorian/P = MS.xeno
	P.armor_modifier -= XENO_ARMOR_MOD_SMALL
	P.speed_modifier -= XENO_SPEED_MOD_VERYLARGE
	P.evasion_modifier += XENO_EVASION_MOD_ULTRA + XENO_EVASION_MOD_VERYLARGE // Best in game evasion.
	P.phero_modifier -= XENO_PHERO_MOD_LARGE;
	P.plasma_types = list(PLASMA_CATECHOLAMINE)
	mutator_update_actions(P)
	MS.recalculate_actions(description)
	P.recalculate_everything()
	P.mutation_type = PRAETORIAN_DANCER

/*
	TAIL ATTACK
*/

/datum/action/xeno_action/activable/prae_tailattack
	name = "Tail Attack (150)"
	action_icon_state = "prae_tailattack"
	ability_name = "tail attack"
	macro_path = /datum/action/xeno_action/verb/verb_prae_tailattack
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/prae_tailattack/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.praetorian_tailattack(A)
	..()

/datum/action/xeno_action/activable/prae_tailattack/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.used_punch

// Toggle impale type for Prae dancer
/datum/action/xeno_action/prae_shift_tailattack
	name = "Toggle tail attack type"
	action_icon_state = "prae_tailattack_impale"
	plasma_cost = 0
	macro_path = /datum/action/xeno_action/verb/verb_prae_shift_tailattack
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/prae_shift_tailattack/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner
	if(X && !X.buckled && !X.is_mob_incapacitated())
		return TRUE

/datum/action/xeno_action/prae_shift_tailattack/action_activate()
	var/mob/living/carbon/Xenomorph/X = owner
	var/action_icon_result

	if(!X.check_state(1))
		return

	if (!(X.prae_status_flags & PRAE_DANCER_TAILATTACK_TYPE)) // 0 = damage, 1 = abduct
		action_icon_result = "prae_tailattack_abduct"
		to_chat(X, SPAN_WARNING("You will now abduct marines with your tail attack."))
	else
		action_icon_result = "prae_tailattack_impale"
		to_chat(X, SPAN_WARNING("You will now impale marines with your tail attack."))

	X.prae_status_flags = X.prae_status_flags^(PRAE_DANCER_TAILATTACK_TYPE) // flip the bit

	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_result)

/datum/action/xeno_action/verb/verb_prae_tailattack()
	set category = "Alien"
	set name = "Praetorian Tail Attack"
	set hidden = 1
	var/action_name = "Tail Attack (150)"
	handle_xeno_macro(src, action_name) 

/datum/action/xeno_action/verb/verb_prae_shift_tailattack()
	set category = "Alien"
	set name = "Praetorian Shift Tail Attack"
	set hidden = 1
	var/action_name = "Toggle tail attack type"
	handle_xeno_macro(src, action_name) 

/mob/living/carbon/Xenomorph/proc/praetorian_tailattack(atom/A)
	var/mob/living/carbon/Xenomorph/Praetorian/P = src
	var/datum/caste_datum/praetorian/pCaste = src.caste
	var/mob/living/carbon/human/T
	
	if(!check_state())
		return

	if(P.used_punch)
		to_chat(src, SPAN_XENOWARNING("You are not ready to use your tail attack again."))
		return

	if (!A || !ishuman(A))
		return
	else
		T = A // Target

	if (T.stat == DEAD)
		to_chat(src, SPAN_XENOWARNING("[T] is dead, why would you want to attack it?"))
		return
	
	if(!check_plasma(150))
		return
	
	var/dist = get_dist(src, T)
	var/buffed = prae_status_flags & PRAE_DANCER_STATSBUFFED

	if (dist > pCaste.tailattack_max_range)
		to_chat(src, SPAN_WARNING("[T] is too far away!"))
		return 

	if (dist > 1)
		var/turf/targetTurf = get_step(src, get_dir(src, T))
		if (targetTurf.density)
			to_chat(src, SPAN_WARNING("You can't attack through [targetTurf]!"))
			return
		else
			for (var/atom/I in targetTurf)
				if (I.density && !I.throwpass && !istype(I, /obj/structure/barricade) && !istype(I, /mob/living))
					to_chat(src, SPAN_WARNING("You can't attack through [I]!"))
					return

	used_punch = TRUE
	use_plasma(150)

	// Hmm today I will kill a marine while looking away from them
	face_atom(T)

	if (buffed) // Now we've exhausted our dance, time to go slow again
		to_chat(src, SPAN_WARNING("You expend your dance to empower your tail attack!"))
		P.speed_modifier += pCaste.dance_speed_buff
		P.evasion_modifier -= pCaste.dance_evasion_buff
		P.recalculate_speed()
		P.recalculate_evasion()
		P.prae_status_flags &= ~PRAE_DANCER_STATSBUFFED

	var/damage = rand(melee_damage_lower, melee_damage_upper) + pCaste.tailattack_damagebuff
	var/target_zone = T.get_limb("chest")
	var/armor_block = getarmor(target_zone, ARMOR_MELEE)

	switch(!!(prae_status_flags & PRAE_DANCER_TAILATTACK_TYPE)) // Bit fuckery to simpify 0,4 to 0,1
		
		if (0) // Direct damage impale
			
			visible_message(SPAN_DANGER("\The [src] violently impales [T] with its tail[buffed?" twice":""]!"), \
			SPAN_DANGER("You impale [T] with your tail[buffed?" twice":""]!"))
			
			if (buffed)
				
				// Do two attacks instead of one 
				animation_attack_on(T, 15) // Slightly further than standard animation, because we want to clearly indicate a double-tile attack 
				flick_attack_overlay(T, "slash")
				emote("roar") // Feedback for the player that we got the magic double impale
				
				var/n_damage = armor_damage_reduction(config.marine_melee, damage, armor_block)
				if (n_damage <= 0.34*damage)
					show_message(SPAN_WARNING("Your armor absorbs the blow!"))
				else if (n_damage <= 0.67*damage)
					show_message(SPAN_WARNING("Your armor softens the blow!"))
				T.apply_damage(n_damage, BRUTE, target_zone, 0, sharp = 1, edge = 1) // Stolen from attack_alien. thanks Neth
				playsound(T.loc, "alien_claw_flesh", 30, 1)
				
				// Reroll damage
				damage = rand(melee_damage_lower, melee_damage_upper) + pCaste.tailattack_damagebuff
				sleep(4) // Short sleep so the animation and sounds will be distinct, but this creates some strange effects if the prae runs away 
						 // not entirely happy with this, but I think its benefits outweigh its drawbacks

			animation_attack_on(T, 15) // Slightly further than standard animation, because we want to clearly indicate a double-tile attack 
			flick_attack_overlay(T, "slash")
				
			var/n_damage = armor_damage_reduction(config.marine_melee, damage, armor_block)
			if (n_damage <= 0.34*damage)
				show_message(SPAN_WARNING("Your armor absorbs the blow!"))
			else if (n_damage <= 0.67*damage)
				show_message(SPAN_WARNING("Your armor softens the blow!"))
			T.last_damage_mob = src
			T.last_damage_source = initial(caste_name)
			T.apply_damage(n_damage, BRUTE, target_zone, 0, sharp = 1, edge = 1)
			
			playsound(T.loc, "alien_claw_flesh", 30, 1) 

		if (1) // 'Abduct' tail attack

			var/leap_range = pCaste.tailattack_abduct_range
			var/delay = pCaste.tailattack_abduct_usetime_long // Delay before we jump back
			if (buffed)
				delay = pCaste.tailattack_abduct_usetime_short
				emote("roar") // Same as before, give player feedback for hitting the combo

			var/leap_dir = turn(get_dir(src, T), 180) // Leap the opposite direction of the vector between us and our target
			
			var/turf/target_turf = get_turf(src)
			var/turf/temp = get_turf(src)
			for (var/x in 0 to leap_range-1)
				temp = get_step(target_turf, leap_dir)
				if (!temp || temp.density) // Stop if we run into a dense turf
					break
				target_turf = temp

			// Warrior grab but with less stun
			if (!Adjacent(T))
				T.throw_at(get_step_towards(T, src), 6, 2, src)

			// Just making sure..
			if (Adjacent(T) && start_pulling(T, 0, TRUE))
				
				T.drop_held_items()
				T.KnockDown(2) // So ungas can blast the Praetorian
				T.Stun(2)
				grab_level = GRAB_NECK
				T.pulledby = src
				visible_message(SPAN_WARNING("\The [src] grabs [T] by the neck with its tail!"), \
				SPAN_XENOWARNING("You grab [T] by the neck with your tail!"))
		
			if (do_after(src, delay, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, show_remaining_time = TRUE) || T.pulledby != src || !src.Adjacent(T))
				to_chat(src, SPAN_XENOWARNING("You stop abducting [T]!"))
				if (T.pulledby)
					T.pulledby.stop_pulling()
			else
				throw_at(target_turf, leap_range, 2, src)
				T.throw_at(target_turf, leap_range, 2, src)
				T.Stun(2)
				visible_message(SPAN_WARNING("\The [src] leaps backwards with [T]!"), \
				SPAN_XENOWARNING("You leap backwards with [T]!"))

		else 
			log_debug("[src] tried to impale with an invalid flag. Error code: PRAE_IMP_1")
			log_admin("[src] tried to impale with an invalid flag. Tell the devs. Error code: PRAE_IMP_1")

	spawn (pCaste.tailattack_cooldown)
		used_punch = FALSE
		to_chat(src, SPAN_XENOWARNING("You regain enough strength to use your tail attack again."))
		for(var/X in actions)
			var/datum/action/act = X
			act.update_button_icon()

/*
	DANCE
*/

/datum/action/xeno_action/activable/prae_dance
	name = "Dance (200)"
	action_icon_state = "prae_dance"
	ability_name = "dance"
	macro_path = /datum/action/xeno_action/verb/verb_prae_dance
	action_type = XENO_ACTION_ACTIVATE

/datum/action/xeno_action/activable/prae_dance/use_ability()
	var/mob/living/carbon/Xenomorph/X = owner
	X.praetorian_dance()
	..()

/datum/action/xeno_action/activable/prae_dance/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.used_pounce

/datum/action/xeno_action/verb/verb_prae_dance()
	set category = "Alien"
	set name = "Praetorian Dance"
	set hidden = 1
	var/action_name = "Dance (200)"
	handle_xeno_macro(src, action_name) 

/mob/living/carbon/Xenomorph/proc/praetorian_dance()
	var/mob/living/carbon/Xenomorph/Praetorian/P = src
	var/datum/caste_datum/praetorian/pCaste = src.caste
	
	if(!check_state())
		return

	if(P.used_pounce)
		to_chat(src, SPAN_XENOWARNING("You are not ready to dance again."))
		return
	
	if(!check_plasma(200))
		return

	// Dance time
	P.used_pounce = TRUE

	to_chat(src, SPAN_XENOWARNING("You begin to move at a fever pace!"))

	P.speed_modifier -= pCaste.dance_speed_buff
	P.evasion_modifier += pCaste.dance_evasion_buff
	P.recalculate_speed()
	P.recalculate_evasion()
	P.prae_status_flags |= PRAE_DANCER_STATSBUFFED

	spawn(pCaste.dance_duration)
		
		// Reset our stats just in case they haven't been reset already somewhere else.
		if (prae_status_flags & PRAE_DANCER_STATSBUFFED)
			to_chat(src, SPAN_XENOWARNING("You feel the effects of your dance wane!"))
			P.speed_modifier += pCaste.dance_speed_buff
			P.evasion_modifier -= pCaste.dance_evasion_buff
			P.recalculate_speed()
			P.recalculate_evasion()
			P.prae_status_flags &= ~PRAE_DANCER_STATSBUFFED
	
	spawn (pCaste.dance_cooldown)
		to_chat(src, SPAN_XENOWARNING("You gather enough strength to dance again."))
		used_pounce = FALSE
		for(var/X in actions)
			var/datum/action/act = X
			act.update_button_icon()