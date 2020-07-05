
// Takes care of organ & limb related updates, such as broken and missing limbs
/mob/living/carbon/human/proc/handle_organs()

	var/leg_tally = 2

	last_dam = getBruteLoss() + getFireLoss() + getToxLoss()

	//processing internal organs is pretty cheap, do that first.
	for(var/datum/internal_organ/I in internal_organs)
		I.process()

	for(var/obj/limb/E in limbs_to_process)
		if(!E)
			continue
		if(!E.need_process())
			E.stop_processing()
			continue
		else
			E.process()

			if (!lying && world.time - l_move_time < 15)
			//Moving around with fractured ribs won't do you any good
				if (E.is_broken() && E.internal_organs && prob(15))
					var/datum/internal_organ/I = pick(E.internal_organs)
					custom_pain("You feel broken bones moving in your [E.display_name]!", 1)
					var/damage = rand(3,5)
					I.take_damage(damage)
					pain.apply_pain(damage * PAIN_ORGAN_DAMAGE_MULTIPLIER)

			if(E.name in list("l_leg","l_foot","r_leg","r_foot") && !lying)
				if (!E.is_usable() || E.is_malfunctioning() || (E.is_broken() && !(E.status & LIMB_SPLINTED)))
					leg_tally--			// let it fail even if just foot&leg

	// standing is poor
	if(leg_tally <= 0 && !knocked_out && !lying && prob(5))
		if(pain.feels_pain)
			emote("pain")
		emote("collapse")
		knocked_out = 10
