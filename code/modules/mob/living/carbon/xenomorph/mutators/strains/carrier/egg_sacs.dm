/datum/xeno_mutator/egg_sacs 
	name = "STRAIN: Carrier - Egg Sacs"
	description = "In exchange for your ability to store huggers, you gain the ability to produce eggs."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Carrier") 
	mutator_actions_to_remove = list("Use/Throw Facehugger")
	mutator_actions_to_add = list(/datum/action/xeno_action/activable/lay_egg)
	keystone = TRUE

/datum/xeno_mutator/egg_sacs/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return
	var/mob/living/carbon/Xenomorph/Carrier/C = MS.xeno
	C.mutation_type = CARRIER_EGGSACS
	MS.egg_sac = TRUE
	C.plasma_types += PLASMA_EGG
	mutator_update_actions(C)
	MS.recalculate_actions(description)

/*
	LAY EGG
*/

/datum/action/xeno_action/activable/lay_egg
	name = "Lay Egg (50)"
	action_icon_state = "lay_egg"
	ability_name = "lay egg"
	macro_path = /datum/action/xeno_action/verb/verb_lay_egg
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/lay_egg/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	return !X.laid_egg

/datum/action/xeno_action/activable/lay_egg/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	X.lay_egg(A)
	..()

/datum/action/xeno_action/verb/verb_lay_egg()
	set category = "Alien"
	set name = "Lay Egg"
	set hidden = 1
	var/action_name = "Lay Egg (50)"
	handle_xeno_macro(src, action_name)

/mob/living/carbon/Xenomorph/Carrier/proc/lay_egg()

	if(!check_state())
		return

	if(laid_egg)
		to_chat(src, SPAN_XENOWARNING("You must wait before laying another egg."))
		return

	if(!check_plasma(50))
		return

	var/obj/item/xeno_egg/E = get_active_hand()
	if(!E)
		E = new()
		E.hivenumber = hivenumber
		put_in_active_hand(E)
		use_plasma(50)
		to_chat(src, SPAN_XENONOTICE("You produce an egg."))
		playsound(loc, "alien_resin_build", 25)
		laid_egg = TRUE
		spawn(caste.egg_cooldown)
			laid_egg = FALSE
			to_chat(src, SPAN_XENONOTICE("You can produce an egg again."))
			for(var/X in actions)
				var/datum/action/A = X
				A.update_button_icon()

	return 1
