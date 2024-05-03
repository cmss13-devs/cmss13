//Cannibalism disease datum, obtained through human meat consumption.
#define PRION_INFECTION_STAGE_ONE 1
#define PRION_INFECTION_STAGE_TWO 2
#define PRION_INFECTION_STAGE_THREE 3
#define PRION_INFECTION_STAGE_FOUR 4
#define STAGE_LEVEL_THRESHOLD 360
#define MESSAGE_COOLDOWN_TIME 1 MINUTES

/datum/disease/prion
	name = "Human Prion Disease"
	max_stages = 3
	cure = "Lithium"
	cure_id = "lithium"
	spread = "Human Meat Consumption"
	spread_type = NON_CONTAGIOUS
	affected_species = list("Human")
	cure_chance = 100
	severity = "Medium"
	agent = "Prions"
	hidden = list(1,0)
	permeability_mod = 2
	desc = "If left untreated the patient will fall into permanent insanity"
	survive_mob_death = FALSE
	longevity = 500
	stage_prob = 0
	var/stage_level = 0
	var/infection_rate = 5
	COOLDOWN_DECLARE(message_cooldown)

/datum/disease/prion/stage_act()
	..()
	if(!ishuman_strict(affected_mob))
		return
	var/mob/living/carbon/human/infected_mob = affected_mob

	if(iszombie(infected_mob)) // if someone force feeds a zombie they should not suffer from cannibalism.
		return

	stage_level += infection_rate

	if(stage_level >= STAGE_LEVEL_THRESHOLD)
		stage++
		stage_level = stage_level % STAGE_LEVEL_THRESHOLD

	if(infected_mob.stat == DEAD || !COOLDOWN_FINISHED(src, message_cooldown))
		return
	COOLDOWN_START(src, message_cooldown, MESSAGE_COOLDOWN_TIME)
	infected_mob.jitteriness = max(infected_mob.jitteriness - 100 ,0)
	infected_mob.hallucination = max(infected_mob.hallucination - 20, 0)
	switch(stage)
		if(PRION_INFECTION_STAGE_ONE)
			switch(rand(0, 100))
				if(0 to 25)
					return
				if(25 to 75)
					INVOKE_ASYNC(affected_mob, TYPE_PROC_REF(/mob,emote), "giggles")
					stage_level += 5
				if(76 to 100)
					INVOKE_ASYNC(affected_mob, TYPE_PROC_REF(/mob,emote), "laughs")
					stage_level += 9
		if(PRION_INFECTION_STAGE_TWO)
			switch(rand(0, 100))
				if(0 to 50)
					to_chat(infected_mob, SPAN_DANGER("Your insticts overwhelm you, you must speak..."))
					stage_level += 9
					speak_gibberish()
				if(51 to 100)
					to_chat(infected_mob, SPAN_DANGER("Was it something you ate?!..."))
					stage_level += 12
					infected_mob.vomit()
					infected_mob.make_jittery(200)
		if(PRION_INFECTION_STAGE_THREE)
			INVOKE_ASYNC(affected_mob, TYPE_PROC_REF(/mob,emote), "giggles")
			switch(rand(0, 100))
				if(0 to 25)
					return
				if(25 to 50)
					to_chat(infected_mob, SPAN_DANGER("Your insticts overwhelm you, you must speak..."))
					stage_level += 9
					speak_gibberish(aggressive = TRUE)
					to_chat(infected_mob, SPAN_DANGER("What did I just say?!..."))
				if(51 to 100)
					stage_level += 12
					infected_mob.hallucination = max(50, infected_mob.hallucination)
					infected_mob.make_jittery(200)
		if(PRION_INFECTION_STAGE_FOUR)
			INVOKE_ASYNC(affected_mob, TYPE_PROC_REF(/mob,emote), "giggles")
			cure_chance = 0 // that's it, doomed to giggle forever.
			switch(rand(0, 100))
				if(0 to 70)
					return
				if(70 to 100)
					INVOKE_ASYNC(affected_mob, TYPE_PROC_REF(/mob,emote), "laughs")
					speak_gibberish(aggressive = TRUE)
					infected_mob.make_jittery(100)

/datum/disease/prion/proc/speak_gibberish(aggressive = FALSE)
	var/list/random_words = list(
		1 = "I am jesus, ",
		2 = "please spread love ",
		3 = "love not hate ",
		4 = "you look nice today, ",
		5 = "wow ",
		6 = "so clean ",
		7 = "and your soul is saved ",
		8 = "praise be brother ",
		9 = "god is good, and ",
		10 = "and ",
		11 = "you ",
		12 = "the truth is true ",
		13 = "your soul can be saved. ",
		14 = "I love furry animals. ",
		15 = "I think you are a great person ",
		16 = "no being is truely evil ",
		17 = "sometimes, I think, ",
		18 = "I love the chef ",
		19 = "eddible ",
		20 = "human meat ",
	)
	var/list/random_words_aggressive = list(
		1 = "I WON'T STOP! ",,
		2 = "KILL ALL MPS, NEXT, ",
		3 = "I WILL MURDER THE CAPTAIN AND ",
		4 = "DO YOU KNOW WHO I AM!?! ",
		5 = "I WILL CLENSE THIS SHIP ",
		6 = "I'M NOT CRAZY, I MEAN IT ",
		7 = "THIS IS IT FOR YOU ALL ",
		8 = "WHAT ARE YOU LOOKING AT MOTHERFUCKER?! ",
		9 = "AND THEN ILL FINISH WITH JONES ",
		10 = "FIRST ILL START WITH CARGO ",
		11 = "YOU BETTER RUN ",
		12 = "I WILL BLOW UP THE MEDBAY ",
		13 = "AND I WILL DO IT AGAIN! ",
		14 = "GOD WILL NOT SAVE YOU FROM MY WRATH! ",
		15 = "STUPID MOTHERFUCKERS ",
		16 = "HOW DARE YOU ",
		17 = "I WILL KILL EVERY LAST ONE OF YOU SONS OF BITCHES ",
		18 = "NOW, LISTEN CLOSELY, ",
		19 = "THIS IS NOT A JOKE, ",
		20 = "LISTEN HERE, YOU STUPID FUCKS, ",
	)
	var/psychotic_message = null
	for(var/i in 1 to rand(3, 7))
		if(aggressive)
			psychotic_message += random_words_aggressive[rand(1, 20)]
		else
			psychotic_message += random_words[rand(1, 20)]

	affected_mob.say(psychotic_message)

#undef PRION_INFECTION_STAGE_ONE
#undef PRION_INFECTION_STAGE_TWO
#undef PRION_INFECTION_STAGE_THREE
#undef PRION_INFECTION_STAGE_FOUR
#undef STAGE_LEVEL_THRESHOLD
#undef MESSAGE_COOLDOWN_TIME
