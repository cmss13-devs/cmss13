//Refer to life.dm for caller

/mob/living/carbon/human/proc/handle_mutations_and_radiation()
	radiation = Clamp(radiation,0,100)

	if(radiation)

		var/damage = 0
		radiation -= 1 * RADIATION_SPEED_COEFFICIENT
		if(prob(25))
			damage = 1

		if(radiation > 50)
			damage = 1
			radiation -= 1 * RADIATION_SPEED_COEFFICIENT
			if(prob(5) && prob(100 * RADIATION_SPEED_COEFFICIENT))
				radiation -= 5 * RADIATION_SPEED_COEFFICIENT
				to_chat(src, SPAN_WARNING("You feel weak."))
				KnockDown(3)
				if(!lying)
					emote("collapse")
			if(prob(5) && prob(100 * RADIATION_SPEED_COEFFICIENT) && species.name == "Human") //Apes go bald
				if((h_style != "Bald" || f_style != "Shaved"))
					to_chat(src, SPAN_WARNING("Your hair falls out."))
					h_style = "Bald"
					f_style = "Shaved"
					update_hair()

		if(radiation > 75)
			radiation -= 1 * RADIATION_SPEED_COEFFICIENT
			damage = 3
			if(prob(5))
				take_overall_damage(0, 5 * RADIATION_SPEED_COEFFICIENT, used_weapon = "Radiation Burns")
			if(prob(1))
				to_chat(src, SPAN_WARNING("You feel strange!"))
				adjustCloneLoss(5 * RADIATION_SPEED_COEFFICIENT)
				emote("gasp")

		if(damage)
			adjustToxLoss(damage * RADIATION_SPEED_COEFFICIENT)
			//updatehealth() moved to Life()
			if(limbs.len)
				var/datum/limb/O = pick(limbs)
				O.add_autopsy_data("Radiation Poisoning", damage)
