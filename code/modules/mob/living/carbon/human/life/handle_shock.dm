//Refer to life.dm for caller

/mob/living/carbon/human/handle_shock()
	// Post-hoc documentation by Fourkhan
	// This gets called on every human on every life() proc
	// Determines how human pain works 
	// Important vars:
	// Human.health => 200 - damage 
	// Human.shock_stage => total shock stage (what decides the negative effects)
	// Human.traumatic_shock => whether or not your shock stage increases every tick

	var/max_shock
	if (HEALTH_THRESHOLD_VERYHIGHSHOCK >= health)
		max_shock = MAXSHOCK_VERYHIGH
	else if (HEALTH_THRESHOLD_HIGHSHOCK >= health)
		// One below the super bad effects 
		max_shock = MAXSHOCK_HIGH
	else if (HEALTH_THRESHOLD_MEDSHOCK >= health)
		max_shock = MAXSHOCK_MED
	else if (HEALTH_THRESHOLD_LOWSHOCK >= health)
		max_shock = MAXSHOCK_LOW
	else 
		max_shock = MAXSHOCK_VERYLOW

	
	..() // This is where traumatic_shock gets updated 

	recalculate_move_delay = TRUE

	if(status_flags & GODMODE || analgesic || (species && species.flags & NO_PAIN)) return //Godmode or some other pain reducers. //Analgesic avoids all traumatic shock temporarily

	// Scale very very quickly at super-high damage totals 
	if(traumatic_shock >= TRAUMA_HIGH) 
		shock_stage += SHOCK_GAIN_RATE_HIGH
	else if (traumatic_shock >= TRAUMA_MED)
		shock_stage += SHOCK_GAIN_RATE_MED
	else if (traumatic_shock >= TRAUMA_LOW)
		shock_stage += SHOCK_GAIN_RATE_LOW
	else if (traumatic_shock >= TRAUMA_VERYLOW)
		shock_stage += SHOCK_GAIN_RATE_VLOW

	// Introduce some notion of levels of damage - we shouldn't die from 50 brute, which is what the system currently does
	if (shock_stage > max_shock)
		shock_stage = max_shock
	
	if (traumatic_shock <= TRAUMA_VERYLOW) // IF we have essentially healed, or been painkiller'd, reduce our effects quickly
		if (shock_stage < 10)
			shock_stage = 0
		else
			shock_stage -= 10
	
	if(species.pain_mod >= 1) //Pain mods lower than one will avoid pain consequences.

		//This just adds up effects together at each step, with a few small exceptions. Preferable to copy and paste rather than have a billion if statements.
		var/message = SPAN_DANGER("You really need some painkillers!")
		var/message_numb = SPAN_DANGER("The pain is excruciating!")
		var/message_dying = SPAN_DANGER("You feel like you could die any moment now!")
		var/show_message = client && client.prefs && (CHAT_TYPE_PAIN & client.prefs.chat_display_preferences)
		switch(shock_stage)
			// Low pain/damage
			if(10 to 29) to_chat(src, message)
			if(30 to 39)
				if(shock_stage == 30)
					emote("me", 1, "is having trouble keeping their eyes open.")
				if(prob(35) && show_message)
					to_chat(src, message)
				eye_blurry = max(2, eye_blurry)
				stuttering = max(stuttering, 5)
			if(40 to 59)
				if(shock_stage == 40  && show_message)
					to_chat(src, message_numb)
				eye_blurry = max(2, eye_blurry)
				stuttering = max(stuttering, 5)
			
			// Below here lie BAD EFFECTS
			if(60 to 79)
				eye_blurry = max(2, eye_blurry)
				stuttering = max(stuttering, 5)
				if(prob(4))
					if(show_message)
						to_chat(src, message_numb)
					emote("me", 1, " is having trouble standing.")
					KnockDown(2)

			if(80 to 119)
				eye_blurry = max(2, eye_blurry)
				stuttering = max(stuttering, 5)
				if(prob(7))
					if(show_message)
						to_chat(src, message_numb)
					KnockDown(5)
			
			// death tier 
			if(120 to 149)
				eye_blurry = max(2, eye_blurry)
				stuttering = max(stuttering, 5)
				if(prob(9))
					if(show_message)
						to_chat(src, message_numb)
					KnockDown(10)
				if(prob(2))
					if(show_message)
						to_chat(src, message_dying)
					KnockOut(5)
			if(150 to INFINITY)
				if(shock_stage == 150 && !lying) emote("me", 1, "can no longer stand, collapsing!")
				eye_blurry = max(2, eye_blurry)
				stuttering = max(stuttering, 5)
				if(prob(7)) to_chat(src, message_numb)
				if(prob(2))
					if(show_message)
						to_chat(src, message_dying)
					KnockOut(5)
				KnockDown(20)