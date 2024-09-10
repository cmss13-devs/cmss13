/datum/disease/addiction
	form = "Condition"
	name = "Chemical Addiction"
	max_stages = 4
	cure = "Withdrawal"
	curable = 0
	agent = "Chemical Addiction"
	affected_species = list("Human")
	permeability_mod = 1
	can_carry = 0
	spread_type = NON_CONTAGIOUS
	desc = "Use of addictive stimulants results in physiological and psychological dependency."
	severity = "Medium"
	longevity = 1000
	hidden = list(1, 1) //hidden from med-huds and pandemic scanners
	contagious_period = 900001 //additional safeguard to prevent spreading
	stage_minimum_age = 900001 // advanced only by chemical
	var/addiction_progression = 1
	var/progression_threshold = 300 //how many life() ticks it takes to advance stage. At 300, a 5 unit pill should increase progression from 0 to just below the threshold
	var/withdrawal_progression = 0 //how long the individual has been in withdrawal
	var/addiction_multiplier = 1
	var/chemical_id

/datum/disease/addiction/New(chem_id, potency = 1)
	addiction_multiplier = potency
	chemical_id = chem_id
	..(TRUE)

/datum/disease/addiction/stage_act()
	..()

	//withdrawal process
	if(affected_mob.reagents.has_reagent(chemical_id))
		withdrawal_progression = 0
		return

	addiction_progression -= 0.383 //about 30 minutes to get past each stage
	if(addiction_progression < 0)
		if(stage == 1)
			addiction_progression = 0 // never truly goes away
		else
			stage = max(stage-1, 0)
			addiction_progression = progression_threshold

	withdrawal_progression += addiction_multiplier

	//symptoms
	switch(stage)
		if(1)
			if(addiction_progression)
				if(prob(20))
					affected_mob.halloss = max(affected_mob.halloss, min(20, withdrawal_progression*0.5) )
					if(prob(50))
						var/message = SPAN_DANGER( pick("You could use another hit.", "More of that would be nice.", "Another dose would help.", "One more dose wouldn't hurt", "Why not take one more?") )
						to_chat(affected_mob, message)

				affected_mob.next_move_slowdown = max(affected_mob.next_move_slowdown, 5)

			else
				if(prob(20))
					affected_mob.halloss = max(affected_mob.halloss, 12)

		if(2)
			if(prob(20))
				affected_mob.halloss = max(affected_mob.halloss, min(40, withdrawal_progression) )
				if(prob(50))
					var/message = SPAN_DANGER( pick("It's just not the same without it.", "You could use another hit.", "You should take another.", "Just one more.", "Looks like you need another one.") )
					to_chat(affected_mob, message)
				if(prob(25))
					affected_mob.emote("me",1, pick("winces slightly.", "grimaces.") )

			affected_mob.next_move_slowdown = max(affected_mob.next_move_slowdown, 7)

		if(3)
			if(prob(3))
				affected_mob.hallucination = max(50, affected_mob.hallucination)

			if(prob(20))
				affected_mob.halloss = max(affected_mob.halloss, min(60, withdrawal_progression*1.5) )
				if(prob(50))
					var/message = SPAN_DANGER( pick("You need more.", "It's hard to go on like this.", "You want more. You need more.", "Just take another hit. Now.", "One more.") )
					to_chat(affected_mob, message)
				if(prob(25))
					affected_mob.emote("me",1, pick("winces.", "grimaces.", "groans!") )

			affected_mob.next_move_slowdown = max(affected_mob.next_move_slowdown, 10)

		if(4)
			if(prob(5))
				affected_mob.hallucination = max(75, affected_mob.hallucination)

			if(prob(20))
				affected_mob.halloss = max(affected_mob.halloss, min(80, withdrawal_progression*2) )
				if(prob(50))
					var/message = SPAN_DANGER( pick("You need another dose, now. NOW.", "You can't stand it. You have to go back. You have to go back.", "You need more. YOU NEED MORE.", "MORE", "TAKE MORE.") )
					to_chat(affected_mob, message)
				if(prob(25))
					affected_mob.emote("me",1, pick("groans painfully!", "contorts with pain!"))
			affected_mob.next_move_slowdown = max(affected_mob.next_move_slowdown, 10)

/datum/disease/addiction/proc/handle_chem()
	if(stage < max_stages)
		addiction_progression += addiction_multiplier
		if(addiction_progression > progression_threshold)
			addiction_progression = 0
			stage++
	else
		addiction_progression = min(addiction_progression+1, progression_threshold) //withdrawal buffer

	switch(stage)
		if(2)
			if(prob(1))
				affected_mob.hallucination = max(50, affected_mob.hallucination)
		if(3)
			if(prob(1))
				affected_mob.hallucination = max(75, affected_mob.hallucination)
		if(4)
			if(prob(2))
				affected_mob.hallucination = max(75, affected_mob.hallucination)
			if(prob(0.5))
				var/affected_organ = pick("heart","lungs","liver","kidneys")
				var/mob/living/carbon/human/H = affected_mob
				var/datum/internal_organ/I =  H.internal_organs_by_name[affected_organ]
				I.take_damage(5)

	if(prob(2))
		affected_mob.emote(pick("twitch","blink_r","shiver"))

/datum/disease/addiction/Copy()
	return new type(chemical_id, addiction_multiplier)

/datum/disease/addiction/opioid
	name = "Opioid Addiction"
	hidden = list(1, 1)
	addiction_progression = 1
	progression_threshold = 240 // TESTING
	var/withdrawal = 0
	var/withdrawal_goal = 240 // roughtly 16 minutes if you dont want to treat it medically , 4 minutes per stage
	max_stages = 4

/datum/disease/addiction/opioid/New()
	..(TRUE)

/datum/disease/addiction/opioid/handle_chem(potency)
	if(addiction_progression >= progression_threshold)
		stage = min(stage+1, max_stages)
		addiction_progression = 0
	addiction_progression += potency
	to_chat(affected_mob, SPAN_HELPFUL("WATER IS POISON [potency]"))

/datum/disease/addiction/opioid/stage_act()

	for(var/datum/reagent/mob_reagents in affected_mob.reagents.reagent_list)
		if(mob_reagents.get_property(PROPERTY_OPIOID))
			withdrawal_progression = 0
			return

	if(withdrawal_progression >= withdrawal_goal  || addiction_progression < 1)
		if(stage <= 1)
			addiction_progression = 1 // addiction becomes dormant , you still need medical help to wipe it out
			return
		stage--
		withdrawal = 0
		addiction_progression = progression_threshold
		to_chat(affected_mob, SPAN_HELPFUL("You feel less reliant on opioids"))
		return
	withdrawal += 2
	addiction_progression -= 2

	switch(stage)

		if(2) // Regular Use
			if(prob(5))
				var/message = SPAN_INFO( pick("One more wont hurt; everything is under control.", "I will quit when things settle down, but right now I just need this.", "I have been through worse. I can handle this for now.", "I am CURED ; I am ready to use painkillers again" ) )
				to_chat(affected_mob, message)
				return

		if(3) // Dependance
			if(prob(5))
				var/message = SPAN_DANGER( pick("I am not strong enough, I NEED IT!", "If I don't get some soon, I don't know what is going to happen.", "I cant think straight. I need it.", "I cant handle this pain anymore, I need it now." ) )
				to_chat(affected_mob, message)
				return

			if(prob(5))
				affected_mob.make_jittery(120)
				to_chat(affected_mob, SPAN_DANGER("my body starts shaking"))
				return

			if(prob(5))
				affected_mob.apply_effect(1, DAZE)
				to_chat(affected_mob, SPAN_DANGER("My head is going to explode..."))
				return

		if(4) // Tolerance
			if(!CHECK_BITFIELD(affected_mob.disabilities, OPIATE_RECEPTOR_DEFICIENCY))
				ENABLE_BITFIELD(affected_mob.disabilities, OPIATE_RECEPTOR_DEFICIENCY)
				to_chat(affected_mob, SPAN_HIGHDANGER("You feel your stomach drop, something terrible has happened."))
				return

			if(prob(5))
				var/message = SPAN_DANGER( pick("I NEED IT NOW!", "If I don't get some soon, I don't know what is going to happen.", "I cant think straight. I need it", "I cant handle the pain anymore." ) )
				to_chat(affected_mob, message)
				return

			if(prob(1))
				to_chat(affected_mob, SPAN_HIGHDANGER("RUN RUN RUN RUN RUN RUN RUN RUN RUN RUN RUN RUN"))
				playsound_client(affected_mob.client, 'sound/effects/heart_beat_short.ogg', 35)
				affected_mob.apply_effect(3, DAZE)
				affected_mob.make_jittery(150)
				affected_mob.emote("scream")
				return



/datum/disease/addiction/opioid/cure() // cure us from this horrible disease

	DISABLE_BITFIELD(affected_mob.disabilities, OPIATE_RECEPTOR_DEFICIENCY)
	. = ..()
