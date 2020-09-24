/mob/living/carbon/Xenomorph/proc/age_xeno()
	if(stat == DEAD || !caste || disposed || !client || age == XENO_NO_AGE)
		return

	age = XENO_NORMAL
	var/hours_as_caste = get_job_playtime(client, caste.caste_name)

	switch(hours_as_caste)
		if(MATURE_THRESHOLD to ELDER_THRESHOLD)
			age = XENO_MATURE
		if(ELDER_THRESHOLD to ANCIENT_THRESHOLD)
			age = XENO_ELDER
		if(ANCIENT_THRESHOLD to PRIME_THRESHOLD)
			age = XENO_ANCIENT
		if(PRIME_THRESHOLD to INFINITY)
			age = XENO_PRIME

	// For people who wish to remain anonymous
	if(!client.prefs.show_xeno_age)
		age = XENO_NORMAL

	switch(age)
		if(XENO_NORMAL)
			age_prefix = ""
		if(XENO_MATURE)
			age_prefix = "Mature "
		if(XENO_ELDER)
			age_prefix = "Elder "
		if(XENO_ANCIENT)
			age_prefix = "Ancient "
		if(XENO_PRIME)
			age_prefix = "Prime "

	hud_update() //update the age level insignia on our xeno hud.

	//One last shake for the sake of it
	xeno_jitter(25)