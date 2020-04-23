/datum/xeno_mutator/tremor 
	name = "STRAIN: Burrower - Tremor"
	description = "In exchange for your ability to create traps, you gain the ability to create tremors in the ground. These tremors will knock down those next to you, while confusing everyone on your screen."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Burrower")
	mutator_actions_to_remove = list("Place resin hole (200)")
	mutator_actions_to_add = list(/datum/action/xeno_action/activable/tremor)
	keystone = TRUE

/datum/xeno_mutator/tremor/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Burrower/B = MS.xeno
	B.mutation_type = BURROWER_TREMOR
	mutator_update_actions(B)
	MS.recalculate_actions(description, flavor_description)

/*
	TREMOR
*/

/datum/action/xeno_action/activable/tremor
	name = "Tremor (100)"
	action_icon_state = "screech"
	ability_name = "screech"
	macro_path = /datum/action/xeno_action/verb/verb_tremor
	action_type = XENO_ACTION_ACTIVATE

/datum/action/xeno_action/activable/tremor/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.used_tremor

/datum/action/xeno_action/activable/tremor/use_ability()
	var/mob/living/carbon/Xenomorph/X = owner
	X.tremor()
	..()

/datum/action/xeno_action/verb/verb_tremor()
	set category = "Alien"
	set name = "Tremor"
	set hidden = 1
	var/action_name = "Tremor (100)"
	handle_xeno_macro(src, action_name)

/mob/living/carbon/Xenomorph/proc/tremor() //More support focused version of crusher earthquakes.
	if(burrow)
		to_chat(src, SPAN_NOTICE("You must be above ground to do this."))
		return

	if(!check_state())
		return

	if(used_tremor)
		to_chat(src, SPAN_XENOWARNING("Your aren't ready to cause more tremors yet!"))
		return

	if(!check_plasma(100)) return

	use_plasma(100)
	playsound(loc, 'sound/effects/alien_footstep_charge3.ogg', 75, 0)
	visible_message(SPAN_XENODANGER("[src] digs itself into the ground and shakes the earth itself, causing violent tremors!"), \
	SPAN_XENODANGER("You dig into the ground and shake it around, causing violent tremors!"))
	create_stomp() //Adds the visual effect. Wom wom wom
	used_tremor = 1

	for(var/mob/living/carbon/M in range(7, loc))
		to_chat(M, SPAN_WARNING("You struggle to remain on your feet as the ground shakes beneath your feet!"))
		shake_camera(M, 2, 3)

	for(var/mob/living/carbon/human/H in range(3, loc))
		to_chat(H, SPAN_WARNING("The violent tremors make you lose your footing!"))
		H.KnockDown(1)

	spawn(caste.tremor_cooldown)
		used_tremor = 0
		to_chat(src, SPAN_NOTICE("You gather enough strength to cause tremors again."))
		for(var/X in actions)
			var/datum/action/act = X
			act.update_button_icon()
