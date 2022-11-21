/mob/living/carbon/Xenomorph/proc/age_xeno()
	if(stat == DEAD || !caste || QDELETED(src) || !client || age == XENO_NO_AGE)
		return

	age = XENO_NORMAL
	var/hours_as_caste = get_job_playtime(client, caste.caste_type)

	switch(hours_as_caste)
		if(JOB_PLAYTIME_TIER_1 to JOB_PLAYTIME_TIER_2)
			age = XENO_MATURE
		if(JOB_PLAYTIME_TIER_2 to JOB_PLAYTIME_TIER_3)
			age = XENO_ELDER
		if(JOB_PLAYTIME_TIER_3 to JOB_PLAYTIME_TIER_4)
			age = XENO_ANCIENT
		if(JOB_PLAYTIME_TIER_4 to INFINITY)
			age = XENO_PRIME

	// For people who wish to remain anonymous
	if(!client.prefs.playtime_perks)
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

/mob/living/carbon/Xenomorph/proc/upgrade_xeno()
	upgrade++
	upgrade_stored = 0
	upgrade_threshold = caste.upgrade_threshold
	visible_message("<span class='xenonotice'>\The [src] begins to twist and contort.</span>", \
	"<span class='xenonotice'>You begin to twist and contort.</span>")
	xeno_jitter(25)
	sleep(25)

	switch(upgrade)
		if(1)
			matured_prefix = "Young "
			maturation_health_bonus = XENO_SCALAR_HEALTH_YOUNG
		if(2)
			matured_prefix = ""
			maturation_health_bonus = XENO_SCALAR_HEALTH_NONE
		if(3)
			matured_prefix = "Aged "
			maturation_health_bonus = XENO_SCALAR_HEALTH_LOW
			maturation_plasma_bonus = XENO_MULTIPLIER_PLASMA_MATURE
			maturation_damage_bonus = XENO_MULTIPLIER_DAMAGE_MATURE
			maturation_speed_bonus = XENO_SPEED_FASTMOD_TIER_6
		if(4)
			matured_prefix = "Hardened "
			maturation_health_bonus = XENO_SCALAR_HEALTH_MED
			maturation_speed_bonus = XENO_SPEED_FASTMOD_TIER_9

	generate_name() //Give them a new name now
	recalculate_everything()