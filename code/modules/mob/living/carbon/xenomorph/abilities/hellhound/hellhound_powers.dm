/datum/action/xeno_action/activable/pounce/gorge/additional_effects(mob/living/target_living)


	var/mob/living/carbon = target_living
	var/mob/living/carbon/xenomorph/hellhound/hellhound_gorger = owner

	hellhound_gorger.visible_message(SPAN_XENODANGER("[hellhound_gorger] gorges at [carbon] with it's spikes."))
	carbon.apply_armoured_damage(gorge_damage, BRUTE)
	playsound(hellhound_gorger, "giant_lizard_growl", 30)
	playsound(carbon, "alien_bite", 30)




/datum/action/xeno_action/onclick/sense_owner/use_ability(atom/layer)
	var/mob/living/carbon/xenomorph/hellhound/xeno = owner
	var/datum/behavior_delegate/hellhound_base/hound_owner = xeno.behavior_delegate
	var/direction = -3
	var/dist = get_dist(xeno, hound_owner.pred_owner)

	direction = Get_Compass_Dir(xeno, hound_owner.pred_owner)

	if(!hound_owner.pred_owner)
		to_chat(xeno, SPAN_XENOWARNING("You do not have an owner."))
		return

	if(hound_owner.pred_owner.z != xeno.z)
		to_chat(xeno, SPAN_XENOWARNING("You do not sense your owner in this place."))
		return
	else
		for(var/mob/living/carbon/viewers in orange(xeno, 5))
			to_chat(viewers, SPAN_WARNING("[xeno] sniffs the ground in a hurry, what the hell.."))
		to_chat(xeno, SPAN_XENOWARNING("You sniff the ground in a hurry to find where your master is."))
		to_chat(xeno, SPAN_XENOWARNING("Your owner is [dist] meters to the [dir2text(direction)]"))

	apply_cooldown()
	..()
