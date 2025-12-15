//Refer to life.dm for caller

/mob/living/carbon/human/handle_regular_status_updates(regular_update = TRUE) // you're next, evil proc --fira

	if(status_flags & GODMODE)
		return 0

	if(stat == DEAD) //DEAD. BROWN BREAD. SWIMMING WITH THE SPESS CARP
		blinded = TRUE
		silent = 0
	else //ALIVE. LIGHTS ARE ON
		if(regular_update)
			if(hallucination)
				if(hallucination >= 20)
					if(prob(3))
						fake_attack(src)
					if(!handling_hal)
						INVOKE_ASYNC(src, TYPE_PROC_REF(/mob/living/carbon, handle_hallucinations))

				if(hallucination <= 2)
					hallucination = 0
					halloss = 0
				else
					hallucination -= 2

			else
				for(var/atom/a in hallucinations)
					hallucinations -= a
					qdel(a)

				if(halloss > 100)
					visible_message(SPAN_WARNING("\The [src] slumps to the ground, too weak to continue fighting."),
					SPAN_WARNING("You slump to the ground, you're in too much pain to keep going."))
					apply_effect(10, PARALYZE)
					setHalLoss(99)

		//UNCONSCIOUS. NO-ONE IS HOME
		if(regular_update && ((getOxyLoss() > 50)))
			apply_effect(3, PARALYZE)

		if((src.species.flags & HAS_HARDCRIT) && HEALTH_THRESHOLD_CRIT > health)
			var/already_in_crit = FALSE
			for(var/datum/effects/crit/C in effects_list)
				already_in_crit = TRUE
				break
			// Need to only apply if its not already active
			if(!already_in_crit)
				new /datum/effects/crit/human(src)

		if(IsKnockOut())
			blinded = TRUE
			if(regular_update && halloss > 0)
				apply_damage(-3, HALLOSS)
		else if(sleeping)
			if(regular_update)
				handle_dreams()
				apply_damage(-3, HALLOSS)
				if(mind)
					if((mind.active && client != null) || immune_to_ssd) //This also checks whether a client is connected, if not, sleep is not reduced.
						sleeping = max(sleeping - 1, 0)
				if(prob(2) && health && !hal_crit)
					addtimer(CALLBACK(src, PROC_REF(emote), "snore"))
			blinded = TRUE
			set_stat(UNCONSCIOUS)
		else
			set_stat(CONSCIOUS)

		if(in_stasis == STASIS_IN_CRYO_CELL)
			blinded = TRUE //Always blinded while in stasisTUBES

		if(!regular_update)
			return
		//Eyes
		if(!species.has_organ["eyes"]) //Presumably if a species has no eyes, they see via something else.
			SetEyeBlind(0)
			if(stat == CONSCIOUS) //even with 'eye-less' vision, unconsciousness makes you blind
				blinded = FALSE
			SetEyeBlur(0)
		else if(!has_eyes()) //Eyes cut out? Permablind.
			SetEyeBlind(1)
			blinded = 1
			// we don't need to blur vision if they are blind...
		else if(eye_blind) //Blindness, heals slowly over time
			ReduceEyeBlind(1)
			blinded = TRUE
		else if(eye_blurry) //Blurry eyes heal slowly
			ReduceEyeBlur(1)

		//Ears
		if(ear_deaf) //Deafness, heals slowly over time
			if(client && client.soundOutput && !(client.soundOutput.status_flags & EAR_DEAF_MUTE))
				client.soundOutput.status_flags |= EAR_DEAF_MUTE
				client.soundOutput.apply_status()

			AdjustEarDeafness(-1)

		else if(ear_damage)
			ear_damage = max(ear_damage - 0.05, 0)

		// This should be done only on updates abvoe, or even better in the AdjsutEarDeafnes handlers
		if(!ear_deaf && (client?.soundOutput?.status_flags & EAR_DEAF_MUTE))
			client.soundOutput.status_flags ^= EAR_DEAF_MUTE
			client.soundOutput.apply_status()

		//Resting
		if(resting)
			dizziness = max(0, dizziness - 15)
			jitteriness = max(0, jitteriness - 15)
			apply_damage(-3, HALLOSS)
		else
			dizziness = max(0, dizziness - 3)
			jitteriness = max(0, jitteriness - 3)
			apply_damage(-1, HALLOSS)

		//Other
		handle_statuses()

		if(paralyzed)
			apply_effect(1, WEAKEN)
			silent = 1
			blinded = TRUE
			use_me = 0
			pain.apply_pain_reduction(PAIN_REDUCTION_FULL)
			paralyzed--

		if(drowsyness)
			drowsyness = max(0,drowsyness - 2)
			EyeBlur(2)
			if(drowsyness > 10 && prob(5))
				sleeping++
				apply_effect(5, PARALYZE)

		confused = max(0, confused - 1)

	return 1
