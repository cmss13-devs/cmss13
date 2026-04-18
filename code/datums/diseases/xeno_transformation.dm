//Xenomicrobes

/datum/disease/xeno_transformation
	name = "Unknown Mutagenic Disease"
	max_stages = 5
	spread = "Syringe"
	spread_type = SPECIAL
	cure = "Unknown"
	cure_chance = 5
	agent = "Rip-LEY Mutagenic Microbes"
	affected_species = list("Human")
	hidden = list(1, 0)
	stage_minimum_age = 0 // 0 for test

/datum/disease/xeno_transformation/stage_act()
	..()
	var/hivenumber_alienize = XENO_HIVE_NORMAL
	var/alienize_list = XENO_T1_CASTES //define first then check for ciphering during disease infection
	var/level = 0

	for(var/datum/reagent/ciphering_reagent as anything in affected_mob.reagents.reagent_list)
		var/datum/chem_property/property_CIP = ciphering_reagent.get_property(PROPERTY_CIPHERING) //Checks for CIP changes to hivenumber

		if(property_CIP)
			level = property_CIP.level //check level on CIP for hivenumber_alienize
			hivenumber_alienize = GLOB.hive_datum[level]

	for(var/datum/reagent/ciphering_reagent_predator as anything in affected_mob.reagents.reagent_list)
		var/datum/chem_property/property_CIP_PRED = ciphering_reagent_predator.get_property(PROPERTY_CIPHERING_PREDATOR) //checks for predalien hivenumber

		if(property_CIP_PRED)
			level = property_CIP_PRED.level //check level on PCI for hivenumber_alienize
			hivenumber_alienize = GLOB.hive_datum[level]
			alienize_list = XENO_CASTE_PREDALIEN


	switch(stage)
		if(2)
			if (prob(3))
				to_chat(affected_mob, "Your throat feels scratchy.")
		if(3)
			if (prob(5))
				to_chat(affected_mob, SPAN_DANGER("Your throat feels very scratchy."))
				affected_mob.take_limb_damage(1)
			if (prob(8))
				to_chat(affected_mob, SPAN_DANGER("Your skin feels tight."))
				affected_mob.take_limb_damage(2)
			if (prob(4))
				to_chat(affected_mob, SPAN_DANGER("You feel a stabbing pain in your head."))
				affected_mob.apply_effect(2, PARALYZE)
			if (prob(4))
				to_chat(affected_mob, SPAN_DANGER("You can feel something move...inside."))
			if (prob(5))
				to_chat(affected_mob, "\italic " + pick("Soon we will be one...", "Must... evolve...", "Capture...", "We are perfect."))
		if(4)
			if (prob(10))
				to_chat(affected_mob, pick(SPAN_DANGER("Your skin feels very tight."), SPAN_DANGER("Your blood boils!")))
				affected_mob.take_limb_damage(3)
			if (prob(5))
				affected_mob.whisper(pick("Soon we will be one...", "Must... evolve...", "Capture...", "We are perfect.", "Hsssshhhhh!"))
			if (prob(8))
				to_chat(affected_mob, SPAN_DANGER("You can feel... something...inside you."))
		if(5)
			to_chat(affected_mob, SPAN_DANGER("Your skin feels impossibly calloused..."))
			affected_mob.apply_damage(10, TOX)
			affected_mob.updatehealth()
			if(prob(40))
				var/turf/T = find_loc(affected_mob)
				gibs(T)
				var/mob/living/carbon/human/H = affected_mob
				H.Alienize(alienize_list, hivenumber_alienize)
				src.cure()

