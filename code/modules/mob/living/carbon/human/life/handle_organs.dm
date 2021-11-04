
// Takes care of organ & limb related updates, such as broken and missing limbs
/mob/living/carbon/human/proc/handle_organs()
	for(var/obj/limb/E as anything in limbs_to_process)
		if(!E)
			continue
		if(!E.need_process())
			E.stop_processing()
			continue
		else
			E.process()

	/*Knockdown if broken limb. needs to be compared to foolosopher's thing -Vanagandr
	if(!lying && !buckled && prob(2))
		var/left_leg_crippled = FALSE
		var/right_leg_crippled = FALSE

		var/obj/limb/right_leg = get_limb("r_leg")
		var/obj/limb/right_foot = get_limb("r_foot")
		if(!right_leg || !right_foot)
			right_leg_crippled = TRUE
		else if(!right_leg.is_usable() || right_leg.is_malfunctioning() || (right_leg.is_broken() && !(right_leg.status & LIMB_SPLINTED)))
			right_leg_crippled = TRUE
		else if(!right_foot.is_usable() || right_foot.is_malfunctioning() || (right_foot.is_broken() && !(right_foot.status & LIMB_SPLINTED)))
			right_leg_crippled = TRUE

		var/obj/limb/left_leg = get_limb("l_leg")
		var/obj/limb/left_foot = get_limb("l_foot")
		if(!left_leg || !left_foot)
			left_leg_crippled = TRUE
		else if(!left_leg.is_usable() || left_leg.is_malfunctioning() || (left_leg.is_broken() && !(left_leg.status & LIMB_SPLINTED)))
			left_leg_crippled = TRUE
		else if(!left_foot.is_usable() || left_foot.is_malfunctioning() || (left_foot.is_broken() && !(left_foot.status & LIMB_SPLINTED)))
			left_leg_crippled = TRUE

		if(left_leg_crippled && right_leg_crippled)
			if(pain.feels_pain)
				emote("pain")
			custom_pain("You can't stand on broken legs!", 1)
			KnockDown(5)*/
