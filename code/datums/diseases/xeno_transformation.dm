//Xenomicrobes

/datum/disease/xeno_transformation
	name = "Unknown Mutagenic Disease"
	max_stages = 5
	spread = "Syringe"
	spread_type = SPECIAL
	cure = "Unknown"
	cure_chance = 5
	agent = "Rip-LEY Mutagenic Microbes"
	affected_species = list("Human", "Monkey")
	hidden = list(1, 0)
	stage_minimum_age = 100

/datum/disease/xeno_transformation/stage_act()
	..()
	switch(stage)
		if(2)
			if (prob(3))
				to_chat(affected_mob, "Your throat feels scratchy.")
		if(3)
			if (prob(5))
				playsound(affected_mob.loc, 'sound/voice/alien_help1.ogg', 15, FALSE)
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
				to_chat(affected_mob, "\italic " + pick("Soon we will be one...", "Must... devour...", "Capture...", "We are perfect."))
		if(4)
			if (prob(10))
				to_chat(affected_mob, pick(SPAN_DANGER("Your skin feels very tight."), SPAN_DANGER("Your blood boils!")))
				affected_mob.take_limb_damage(3)
				playsound(affected_mob.loc, 'sound/voice/alien_growl1.ogg', 15, FALSE)
			if (prob(5))
				if(!ismonkey(affected_mob))
					affected_mob.whisper(pick("Soon we will be one...", "Must... devour...", "Capture...", "We are perfect.", "Hsssshhhhh!"))
			if (prob(8))
				to_chat(affected_mob, SPAN_DANGER("You can feel... something...inside you."))
		if(5)
			to_chat(affected_mob, SPAN_DANGER("Your skin feels impossibly calloused..."))
			affected_mob.apply_damage(10, TOX)
			affected_mob.updatehealth()
			if(prob(40))
				var/turf/turf = get_turf(affected_mob)
				var/area/area = get_area(turf)
				gibs(turf)
				var/mob/living/carbon/xenomorph/drone/xeno = new()
				xeno.forceMove(turf)
				xeno.set_hive_and_update(XENO_HIVE_FERAL)
				if(ismonkey(affected_mob))
					xeno.free_for_ghosts(TRUE)
				else
					affected_mob.mind.transfer_to(xeno, TRUE)

				src.cure()
				qdel(affected_mob)

				if(istype(area, /area/almayer/medical/containment))
					GLOB.ddi_experiment.trigger(xeno)
