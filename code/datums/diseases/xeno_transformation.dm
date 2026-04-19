//Xenomicrobes

/datum/disease/xeno_transformation
	name = "|D-ID Field Error|"
	max_stages = 5
	spread = "SCANNER UNIT FAILURE"
	spread_type = SPECIAL
	cure = "Please contact the nearest Weyland-Yutani Specialist Technician."
	cure_chance = 5
	stage_prob = 100 //Guaranteed stage advance per check, but minimum age keeps it a consistent length.
	agent = "Rip-LEY Mutagenic Microbes"
	affected_species = list("Human")
	stage_minimum_age = 80
	var/hivenumber_alienize = XENO_HIVE_NORMAL
	var/alienize_list = XENO_T1_CASTES //define first then check for PCI during disease infection
	var/level = 0
	var/xenospeaker = FALSE

/datum/disease/xeno_transformation/stage_act()
	..()

	for(var/datum/reagent/ciphering_reagent as anything in affected_mob.reagents.reagent_list)
		var/datum/chem_property/property_CIP = ciphering_reagent.get_property(PROPERTY_CIPHERING) //Checks for CIP changes to hivenumber

		if(property_CIP)
			level = property_CIP.level //check level on CIP for hivenumber_alienize
			var/hivenumber = GLOB.hive_datum[level]
			hivenumber_alienize = hivenumber

	for(var/datum/reagent/ciphering_reagent_predator as anything in affected_mob.reagents.reagent_list)
		var/datum/chem_property/property_CIP_PRED = ciphering_reagent_predator.get_property(PROPERTY_CIPHERING_PREDATOR) //checks for predalien hivenumber

		if(property_CIP_PRED)
			level = property_CIP_PRED.level //check level on PCI for hivenumber_alienize
			var/hivenumber = GLOB.hive_datum[level]
			hivenumber_alienize = hivenumber
			alienize_list = list(XENO_CASTE_PREDALIEN)


	switch(stage)
		if(1)
		if(2)
			if (prob(1))
				to_chat(affected_mob, "Your throat feels scratchy.")
			if (prob(1))
				to_chat(affected_mob, "Your heart pumps a little faster.")
			if (prob(1))
				to_chat(affected_mob, "Something catches in your throat.")
		if(3)
			if(xenospeaker == FALSE)
				xenospeaker = TRUE
				to_chat(affected_mob, SPAN_XENOHIGHDANGER("Something in your mind tears- and your thoughts don't sound the way they did before."))
				affected_mob.add_language(LANGUAGE_XENOMORPH) //For roleplay purposes. You're gonna be one of them soon, anyway.
				give_action(affected_mob, /datum/action/human_action/activable/cult/speak_hivemind) //Lets the victim speak in their hivemind, but not spectate xenos. Fun for roleplay.
				affected_mob.remove_language(LANGUAGE_ENGLISH)
				affected_mob.remove_language(ALL_HUMAN_LANGUAGES) //No servant of the Queen Mother speaks American.
				affected_mob.add_language(LANGUAGE_ENGLISH)
				LAZYORASSOC(affected_mob.language_flags, LANGUAGE_ENGLISH, LANGUAGE_HEAR_ONLY)

				if(SSticker.mode && affected_mob.mind)
					SSticker.mode.xenomorphs += affected_mob.mind

				var/datum/hive_status/hive = GLOB.hive_datum[hivenumber_alienize]
				if(hive)
					affected_mob.faction = hive.internal_faction
					affected_mob.hivenumber = hivenumber_alienize
			if (prob(5))
				to_chat(affected_mob, SPAN_DANGER("There's- something in your throat..."))
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
				to_chat(affected_mob, pick(SPAN_XENODANGER("Your skin feels very tight."), SPAN_DANGER("Your blood boils!")))
				affected_mob.take_limb_damage(3)
			if (prob(5))
				affected_mob.whisper(pick("Soon we will be one...", "Must... evolve...", "Capture...", "You are perfect."))
			if (prob(8))
				to_chat(affected_mob, SPAN_XENODANGER("You can feel... something...inside you."))
		if(5)
			if(!HAS_TRAIT(src, TRAIT_KNOCKEDOUT))
				affected_mob.pain.apply_pain(PAIN_CHESTBURST_WEAK)
				affected_mob.visible_message(SPAN_DANGER("[affected_mob] starts shaking uncontrollably!"),
											SPAN_XENOHIGHDANGER("There's- a screaming coming from inside us- a voice so loud our insides rush at the ends of our skin to make space for its light- it won't be long now..."))
				affected_mob.apply_effect(3, PARALYZE)
				affected_mob.make_jittery(105)
				affected_mob.take_limb_damage(1)
			if (prob(5))
				affected_mob.whisper(pick("So close...", "Evolve- EVOLVE- NOW!", "Capture... them... all...", "Just... a little... more...", "Hsssshhhhh!", "It's all so clear, now."))
			if(prob(10))
				to_chat(affected_mob, SPAN_DANGER("Your skin feels impossibly calloused..."))
				affected_mob.pain.apply_pain(PAIN_CHESTBURST_WEAK)
				var/message = pick("There's an emptiness inside of you.", "The organelles in your chest grieve for what you aren't.", "Your heart starts beating rapidly, and each beat is painful.")
				message = SPAN_XENOBOLDNOTICE("[message].")
				to_chat(affected_mob, message)
				affected_mob.apply_damage(10, TOX)
			if (prob(20))
				affected_mob.updatehealth()
				var/turf/T = find_loc(affected_mob)
				gibs(T)
				var/mob/living/carbon/human/H = affected_mob
				H.Alienize(alienize_list, hivenumber_alienize)
				src.cure()

