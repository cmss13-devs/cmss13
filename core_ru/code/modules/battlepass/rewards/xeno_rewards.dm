/datum/battlepass_reward/xeno
	lifeform_type = "Xeno"

/datum/battlepass_reward/xeno/can_claim(mob/target_mob)
	. = ..()
	if(!.)
		return .

	if(!isxeno(target_mob))
		return FALSE

	return TRUE

/mob/living/carbon/xenomorph
	var/has_halo = FALSE

/mob/living/carbon/xenomorph/proc/get_halo_iconname()
	return lowertext(caste_type)

/mob/living/carbon/xenomorph/praetorian/get_halo_iconname()
	if(!strain)
		return "basePrae"

	switch(strain.type)
		if(/datum/xeno_strain/vanguard)
			return "vanguardPrae"
		if(/datum/xeno_strain/dancer)
			return "dancerPrae"
		if(/datum/xeno_strain/warden)
			return "wardenPrae"
		if(/datum/xeno_strain/oppressor)
			return "oppPrae"

/datum/battlepass_reward/xeno/halo
	name = "Golden Halo"
	icon_state = "golden_halo"

/datum/battlepass_reward/xeno/halo/on_claim(mob/living/carbon/xenomorph/target_mob)
	target_mob.create_halo()
	return TRUE

/datum/battlepass_reward/xeno/evil_halo
	name = "Red Halo"
	icon_state = "red_halo"

/datum/battlepass_reward/xeno/evil_halo/on_claim(mob/living/carbon/xenomorph/target_mob)
	target_mob.create_evil_halo()
	return TRUE
