/datum/xeno_mutator/boxer
	name = "STRAIN: Warrior - Boxer"
	description = "In exchange for your ability to fling, you gain the ability to Jab. Your punches no longer break bones, but they do more damage and confuse your enemies. Jab knocks down your target for a very short time, while also pulling you out of agility mode and refreshing your Punch cooldown."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Warrior")
	mutator_actions_to_remove = list("Fling","Lunge")
	mutator_actions_to_add = list(/datum/action/xeno_action/activable/jab)
	keystone = TRUE

/datum/xeno_mutator/boxer/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Warrior/W = MS.xeno
	W.mutation_type = WARRIOR_BOXER
	mutator_update_actions(W)
	MS.recalculate_actions(description)

/*
	JAB
*/

/datum/action/xeno_action/activable/jab
	name = "Jab"
	action_icon_state = "pounce"
	ability_name = "jab"
	macro_path = /datum/action/xeno_action/verb/verb_jab
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/jab/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.jab(A)
	..()

/datum/action/xeno_action/activable/jab/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.used_jab

/datum/action/xeno_action/verb/verb_jab()
	set category = "Alien"
	set name = "Jab"
	set hidden = 1
	var/action_name = "Jab"
	handle_xeno_macro(src, action_name)

/mob/living/carbon/Xenomorph/proc/jab(atom/A)

	if (!A || !ishuman(A))
		return

	if (!check_state())
		return

	if (used_jab)
		to_chat(src, SPAN_XENOWARNING("You must gather your strength before jabbing."))
		return

	if (!check_plasma(10))
		return

	var/distance = get_dist(src, A)

	if (distance > 2)
		return

	var/mob/living/carbon/human/H = A
	if(H.stat == DEAD) return
	if(istype(H.buckled, /obj/structure/bed/nest)) return
	if(H.status_flags & XENO_HOST)
		to_chat(src, SPAN_XENOWARNING("This would harm the embryo!"))
		return

	if (distance > 1)
		step_towards(src, H, 1)

	if (!Adjacent(H))
		return

	H.last_damage_mob = src
	H.last_damage_source = initial(caste_name)
	visible_message(SPAN_XENOWARNING("\The [src] hits [H] with a powerful jab!"), \
	SPAN_XENOWARNING("You hit [H] with a powerful jab!"))
	var/S = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(H,S, 50, 1)
	used_jab = 1
	use_plasma(10)

	if(!isYautja(H))
		H.KnockDown(0.1)

	if(agility)
		toggle_agility()

	if(used_punch)
		used_punch = FALSE

	shake_camera(H, 3, 1)
	step_away(H, src, 2)

	spawn(caste.jab_cooldown)
		used_jab = 0
		to_chat(src, SPAN_NOTICE("You gather enough strength to jab again."))
		for(var/X in actions)
			var/datum/action/act = X
			act.update_button_icon()
