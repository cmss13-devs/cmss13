/datum/disease/weave_mind
	name = "Fey Manipulation"
	form = "Enchantment"
	max_stages = 5
	spread = "Unknown"
	spread_type = SPECIAL
	cure = "Unknown"
	cure_chance = 5
	agent = "Weave Essence"
	affected_species = list(SPECIES_YAUTJA, SPECIES_HUMAN, SPECIES_MONKEY)
	hidden = list(1, 1)
	stage_minimum_age = 140
	curable = FALSE
	longevity = 60 SECONDS

/datum/disease/weave_mind/stage_act()
	..()
	switch(stage)
		if(2)
			if(prob(5))
				to_chat(affected_mob, SPAN_XENOMINORWARNING("What was that noise?"))
		if(3)
			if(prob(3))
				to_chat(affected_mob, pick(SPAN_XENOWARNING("Your head throbs."), SPAN_XENOWARNING("Do you feel The Weave...")))
				affected_mob.adjustBrainLoss(3)
		if(4)
			if(prob(3))
				to_chat(affected_mob, pick(SPAN_XENODANGER("The Weave calls..."), SPAN_XENODANGER("Follow The Weave...")))
				affected_mob.adjustBrainLoss(5)
		if(5)
			affected_mob.adjustBrainLoss(10)
			affected_mob.updatehealth()
			if(prob(40))
				to_chat(affected_mob, SPAN_XENOHIGHDANGER("Images flash through your mind as The Weave makes itself known..."))
				var/mob/living/carbon/human/H = affected_mob
				H.WeaveClaim(CAUSE_ESSENCE)
				cure()
