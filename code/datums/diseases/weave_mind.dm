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
			if (prob(10))
				to_chat(affected_mob, SPAN_XENOMINORWARNING("What was that noise?"))
		if(3)
			if (prob(10))
				to_chat(affected_mob, SPAN_XENOMINORWARNING("Your head throbs."))
				affected_mob.adjustBrainLoss(3)
			if (prob(8))
				to_chat(affected_mob, SPAN_WARNING("Do you feel The Weave..."))
				affected_mob.adjustBrainLoss(2)
			if (prob(4))
				to_chat(affected_mob, SPAN_XENODANGER("You feel a stabbing pain in your head."))
				affected_mob.KnockOut(2)
		if(4)
			if (prob(10))
				to_chat(affected_mob, pick(SPAN_XENODANGER("The Weave calls..."), SPAN_DANGER("Follow The Weave...")))
				affected_mob.adjustBrainLoss(5)
		if(5)
			to_chat(affected_mob, SPAN_XENOHIGHDANGER("Images flash through your mind as The Weave makes itself known..."))
			affected_mob.adjustBrainLoss(10)
			affected_mob.updatehealth()
			if(prob(40))
				var/mob/living/carbon/human/H = affected_mob
				H.WeaveClaim(2)
				src.cure()
